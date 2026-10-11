const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Types = @import("../analysis/types.zig");
const Analyzer = @import("../analysis/analyzer.zig");
const numbers = @import("../analysis/numbers.zig");
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
active: []bool,
declared: []bool,
declaration_owner: []?ir.ExprId,
pure_functions: ?@import("parallel.zig").Result = null,
callback_depth: usize = 0,
task_depth: usize = 0,
refinement: zx.Refinement = .{},
pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    const active = try allocator.alloc(bool, program.symbols.count());

    defer allocator.free(active);

    const declared = try allocator.alloc(bool, program.symbols.count());

    defer allocator.free(declared);

    const declaration_owner = try allocator.alloc(?ir.ExprId, program.symbols.count());

    defer allocator.free(declaration_owner);
    @memset(active, false);
    @memset(declared, false);
    @memset(declaration_owner, null);

    active[0] = true;
    declared[0] = true;

    var self = Self{ .allocator = allocator, .program = program, .active = active, .declared = declared, .declaration_owner = declaration_owner };

    defer if (self.pure_functions) |*pure| pure.deinit();
    defer self.refinement.deinit(allocator);

    if (!try self.block(program.body.block(), 0)) return false;

    for (declared) |item| if (!item) {
        return false;
    };

    return program.output_type == Types.scalarId(.void) or Analyzer.returns(program.body.block());
}

fn declare(self: *Self, symbol: ir.SymbolId, type_id: ir.TypeId) bool {
    const index = @backingInt(symbol);

    if (index >= self.active.len or self.declared[index] or self.program.symbols.at(index).type_id != type_id or type_id == Types.scalarId(.void)) return false;

    self.declared[index] = true;
    self.active[index] = true;

    return true;
}

fn block(self: *Self, statements: ir.Block, depth: usize) std.mem.Allocator.Error!bool {
    if (depth > 256) return false;

    const facts = self.refinement.mark();

    defer self.refinement.restore(facts);

    const saved = try self.allocator.dupe(bool, self.active);

    defer self.allocator.free(saved);
    defer @memcpy(self.active, saved);

    for (0..statements.len) |index| {
        const statement = statements.at(index);

        if (Analyzer.returns(statements.prefix(index))) return false;

        switch (statement) {
            .evaluate => |id| if (!try self.expression(id, 0)) return false,
            .constant => |binding| {
                if (!try self.expression(binding.value, 0) or !self.declare(binding.symbol, self.program.expression(binding.value).type_id)) return false;
            },
            .parallel => |invocations| {
                if (invocations.len == 0) return false;
                if (self.pure_functions == null) self.pure_functions = try @import("parallel.zig").functions(self.allocator, self.program);

                for (0..invocations.len) |invocation_index| {
                    const invocation = invocations.at(invocation_index);

                    if (!try self.expression(invocation.value, 0)) return false;

                    const value = self.program.expression(invocation.value).value;

                    if (value != .call or !self.pure_functions.?.values[@backingInt(value.call.function)]) return false;
                }

                for (0..invocations.len) |invocation_index| {
                    const invocation = invocations.at(invocation_index);

                    if (invocation.symbol) |symbol| if (!self.declare(symbol, self.program.expression(invocation.value).type_id)) return false;
                }
            },
            .destructure => |binding| {
                if (!try self.expression(binding.value, 0)) return false;

                const target = self.program.typeOf(self.program.expression(binding.value).type_id);

                if (target != .tuple or target.tuple.len != binding.symbols.len) return false;

                for (0..binding.symbols.len, 0..target.tuple.len) |symbol_index, view_index| {
                    const symbol = binding.symbols.at(symbol_index);
                    const type_id = target.tuple.at(view_index);

                    if (symbol) |id| if (!self.declare(id, type_id)) {
                        return false;
                    };
                }

                if (binding.symbols.len == 2) try self.refinement.bind(self.allocator, self.program.expression(binding.value), &.{ binding.symbols.at(0), binding.symbols.at(1) });
            },
            .result => |value| {
                if (value) |id| {
                    if (!try self.expression(id, 0) or self.program.expression(id).type_id != self.program.output_type) return false;
                } else if (self.program.output_type != Types.scalarId(.void)) return false;
            },
            .branch => |branch| {
                if (!try self.expression(branch.condition, 0) or self.program.expression(branch.condition).type_id != Types.scalarId(.bool)) return false;

                const before = self.refinement.mark();

                try self.refinement.assume(self.allocator, self.program.expressions, branch.condition, true);

                if (!try self.block(branch.yes, depth + 1)) return false;

                self.refinement.restore(before);
                try self.refinement.assume(self.allocator, self.program.expressions, branch.condition, false);
                if (!try self.block(branch.no, depth + 1)) return false;

                self.refinement.restore(before);
                if (Analyzer.returns(branch.yes)) try self.refinement.assume(self.allocator, self.program.expressions, branch.condition, false);
                if (Analyzer.returns(branch.no)) try self.refinement.assume(self.allocator, self.program.expressions, branch.condition, true);
            },
            .switch_stmt => |selection| {
                if (!try self.expression(selection.subject, 0) or !self.switchCases(selection)) return false;

                for (0..selection.cases.len) |case_index| {
                    const case = selection.cases.at(case_index);

                    if (case.value) |id| if (!try self.expression(id, 0)) {
                        return false;
                    };

                    const before = self.refinement.mark();

                    if (switchTruth(self.program, selection, case.value)) |truth| try self.refinement.assume(self.allocator, self.program.expressions, selection.subject, truth);
                    if (!try self.block(case.body, depth + 1)) return false;

                    self.refinement.restore(before);
                }
            },
            .store_set => |setter| {
                if (self.program.store_mode != .transaction or setter.slot >= self.program.stores.count() or !self.program.stores.at(setter.slot).writable or !try self.expression(setter.value, 0) or self.program.expression(setter.value).type_id != self.program.stores.at(setter.slot).type_id) return false;
            },
        }
    }

    return true;
}

fn expression(self: *Self, id: ir.ExprId, depth: usize) std.mem.Allocator.Error!bool {
    if (@backingInt(id) >= self.program.expressions.count() or depth > 256) return false;

    return switch (self.program.expression(id).value) {
        .store_get => self.callback_depth == 0 and self.task_depth == 0,
        .list_update => |update| try self.expression(update.target, depth + 1) and try self.expression(update.index, depth + 1) and try self.expression(update.value, depth + 1),
        .iteration => |iteration| blk: {
            if (!try self.expression(iteration.initial, depth + 1)) break :blk false;

            const saved = try self.allocator.dupe(bool, self.active);

            defer self.allocator.free(saved);
            defer @memcpy(self.active, saved);

            self.callback_depth += 1;
            defer self.callback_depth -= 1;
            const parameters = [_]ir.SymbolId{ iteration.condition_parameter, iteration.parameter };
            const callbacks = [_]ir.ExprId{ iteration.condition, iteration.body };

            for (parameters, callbacks) |parameter, callback| {
                @memset(self.active, false);

                const index = @backingInt(parameter);

                if (index >= self.active.len or (self.declared[index] and self.declaration_owner[index] != id)) break :blk false;

                self.declared[index] = true;
                self.active[index] = true;
                self.declaration_owner[index] = id;

                if (!try self.expression(callback, depth + 1)) break :blk false;
            }

            break :blk true;
        },
        .scope => |scope| blk: {
            const facts = self.refinement.mark();

            defer self.refinement.restore(facts);

            try self.refinement.scope(self.allocator, self.program.expressions, scope.bindings);

            const saved = try self.allocator.dupe(bool, self.active);

            defer self.allocator.free(saved);
            defer @memcpy(self.active, saved);

            for (0..scope.bindings.len) |record_index| {
                const binding = scope.bindings.at(record_index);

                if (!try self.expression(binding.value, depth + 1)) break :blk false;

                if (binding.symbol) |symbol| {
                    const index = @backingInt(symbol);

                    if (index >= self.active.len or self.active[index]) break :blk false;
                    if (self.declared[index] and self.declaration_owner[index] != id) break :blk false;
                    if (self.program.symbols.at(index).type_id == Types.scalarId(.void)) break :blk false;

                    self.declared[index] = true;
                    self.active[index] = true;
                    self.declaration_owner[index] = id;
                }
            }

            break :blk try self.expression(scope.result, depth + 1);
        },
        .reference => |symbol| self.active[@backingInt(symbol)],
        .field, .tuple_field => |field| self.expression(field.target, depth + 1),
        .index => |item| try self.expression(item.target, depth + 1) and try self.expression(item.index, depth + 1),
        .length, .some => |child| self.expression(child, depth + 1),
        .capture => |child| self.expression(child, depth + 1),
        .await_task, .cancel_task => |child| self.expression(child, depth + 1),
        .task => |task| blk: {
            const saved = try self.allocator.dupe(bool, self.active);

            defer self.allocator.free(saved);
            defer @memcpy(self.active, saved);
            @memset(self.active, false);

            for (task.captures) |symbol| {
                if (!saved[@backingInt(symbol)]) break :blk false;

                self.active[@backingInt(symbol)] = true;
            }

            self.task_depth += 1;
            defer self.task_depth -= 1;

            break :blk try self.expression(task.body, depth + 1);
        },
        .parallel => |branches| blk: {
            for (0..branches.len) |record_index| {
                const branch = branches.at(record_index);

                if (!try self.expression(branch.task, depth + 1)) break :blk false;
            }

            break :blk true;
        },
        .optional_value => |child| blk: {
            break :blk self.refinement.containsValue(self.program.expressions, child) and try self.expression(child, depth + 1);
        },
        .unary => |unary| self.expression(unary.operand, depth + 1),
        .binary => |binary| blk: {
            if (!try self.expression(binary.left, depth + 1)) break :blk false;

            const facts = self.refinement.mark();

            defer self.refinement.restore(facts);

            if (binary.operator == .logical_and or binary.operator == .logical_or) try self.refinement.assume(self.allocator, self.program.expressions, binary.left, binary.operator == .logical_and);

            break :blk try self.expression(binary.right, depth + 1);
        },
        .conditional => |value| blk: {
            if (!try self.expression(value.condition, depth + 1)) break :blk false;

            const facts = self.refinement.mark();

            defer self.refinement.restore(facts);

            try self.refinement.assume(self.allocator, self.program.expressions, value.condition, true);
            if (!try self.expression(value.yes, depth + 1)) break :blk false;

            self.refinement.restore(facts);

            try self.refinement.assume(self.allocator, self.program.expressions, value.condition, false);

            break :blk try self.expression(value.no, depth + 1);
        },
        .match_expr => |selection| blk: {
            if (selection.subject) |subject| if (!try self.expression(subject, depth + 1)) {
                break :blk false;
            };

            for (0..selection.arms.len) |record_index| {
                const arm = selection.arms.at(record_index);

                if (!try self.expression(arm.condition, depth + 1) or !try self.expression(arm.result, depth + 1)) break :blk false;
            }

            break :blk try self.expression(selection.fallback, depth + 1);
        },
        .list, .tuple, .template => |items| self.sequence(items, depth + 1),
        .object => |object| blk: {
            if (!try self.sequence(object.evaluation, depth + 1)) break :blk false;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (!try self.expression(field.value, depth + 1)) {
                    break :blk false;
                }
            }

            break :blk true;
        },
        .call => |call| (self.callback_depth == 0 or call.stores.len == 0) and (self.task_depth == 0 or try @import("tasks.zig").callSafe(self.allocator, self.program.functions, call.function)) and try self.expression(call.argument, depth + 1),
        .list_operation => |operation| try self.expression(operation.target, depth + 1) and try self.sequence(operation.arguments, depth + 1),
        .transform => |transform| blk: {
            if (!try self.expression(transform.target, depth + 1)) break :blk false;

            if (transform.initial) |initial| if (!try self.expression(initial, depth + 1)) {
                break :blk false;
            };

            const saved = try self.allocator.dupe(bool, self.active);

            defer self.allocator.free(saved);
            defer @memcpy(self.active, saved);
            @memset(self.active, false);

            self.callback_depth += 1;
            defer self.callback_depth -= 1;

            for (transform.parameters) |symbol| {
                const index = @backingInt(symbol);

                if (self.active[index]) break :blk false;
                if (self.declared[index] and self.declaration_owner[index] != id) break :blk false;

                self.declared[index] = true;
                self.active[index] = true;
                self.declaration_owner[index] = id;
            }

            break :blk try self.expression(transform.body, depth + 1);
        },
        else => true,
    };
}

fn sequence(self: *Self, items: []const ir.ExprId, depth: usize) std.mem.Allocator.Error!bool {
    for (items) |item| if (!try self.expression(item, depth)) {
        return false;
    };

    return true;
}

fn switchCases(self: *Self, selection: @FieldType(ir.StatementRow, "switch_stmt")) bool {
    const type_id = self.program.expression(selection.subject).type_id;
    const target = self.program.typeOf(type_id);

    if (target != .enumeration and target != .error_set and !numbers.isInteger(type_id) and type_id != Types.scalarId(.bool) and type_id != Types.scalarId(.string)) return false;

    var has_default = false;

    for (0..selection.cases.len) |index| {
        const case = selection.cases.at(index);

        if (case.value) |id| {
            if (@backingInt(id) >= self.program.expressions.count() or self.program.expression(id).type_id != type_id) return false;

            const value = self.program.expression(id).value;

            switch (value) {
                .integer, .negative_integer, .string, .boolean, .enum_value, .error_value => {},
                else => return false,
            }

            for (0..index) |previous_index| {
                const previous = selection.cases.at(previous_index);

                if (previous.value) |previous_id| if (same(value, self.program.expression(previous_id).value)) {
                    return false;
                };
            }
        } else {
            if (has_default) return false;

            has_default = true;
        }
    }

    const exhaustive = has_default or (target == .enumeration and selection.cases.len == target.enumeration.members.len) or (target == .error_set and selection.cases.len == target.error_set.len) or (type_id == Types.scalarId(.bool) and selection.cases.len == 2);

    return selection.exhaustive == exhaustive;
}

fn same(left: @FieldType(ir.ExpressionRow, "value"), right: @FieldType(ir.ExpressionRow, "value")) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) {
        return (left == .integer and left.integer == 0 and right == .negative_integer and right.negative_integer == 0) or (right == .integer and right.integer == 0 and left == .negative_integer and left.negative_integer == 0);
    }

    return switch (left) {
        .integer => |value| value == right.integer,
        .negative_integer => |value| value == right.negative_integer,
        .boolean => |value| value == right.boolean,
        .string => |value| std.mem.eql(u8, value, right.string),
        .enum_value => |value| value == right.enum_value,
        .error_value => |value| value == right.error_value,
        else => false,
    };
}

fn switchTruth(program: ir.Program, selection: @FieldType(ir.StatementRow, "switch_stmt"), value: ?ir.ExprId) ?bool {
    if (program.expression(selection.subject).type_id != Types.scalarId(.bool)) return null;

    if (value) |id| {
        const expression_value = program.expression(id).value;

        return if (expression_value == .boolean) expression_value.boolean else null;
    }

    var yes = false;
    var no = false;

    for (0..selection.cases.len) |index| {
        const id = selection.cases.at(index).value orelse continue;
        const expression_value = program.expression(id).value;

        if (expression_value != .boolean) return null;

        const truth = expression_value.boolean;

        yes = yes or truth;
        no = no or !truth;
    }

    return if (yes != no) !yes else null;
}
