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
parameter_owner: []?ir.ExprId,
callback_depth: usize = 0,
pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    const active = try allocator.alloc(bool, program.symbols.len);

    defer allocator.free(active);

    const declared = try allocator.alloc(bool, program.symbols.len);

    defer allocator.free(declared);

    const parameter_owner = try allocator.alloc(?ir.ExprId, program.symbols.len);

    defer allocator.free(parameter_owner);
    @memset(active, false);
    @memset(declared, false);
    @memset(parameter_owner, null);

    active[0] = true;
    declared[0] = true;
    var self = Self{ .allocator = allocator, .program = program, .active = active, .declared = declared, .parameter_owner = parameter_owner };

    if (!try self.block(program.body, 0)) return false;

    for (declared) |item| if (!item) {
        return false;
    };

    return program.output_type == Types.scalarId(.void) or Analyzer.returns(program.body);
}

fn declare(self: *Self, symbol: ir.SymbolId, type_id: ir.TypeId) bool {
    const index = @intFromEnum(symbol);

    if (index >= self.active.len or self.declared[index] or self.program.symbols[index].type_id != type_id or type_id == Types.scalarId(.void)) return false;

    self.declared[index] = true;
    self.active[index] = true;

    return true;
}

fn block(self: *Self, statements: []const ir.Statement, depth: usize) std.mem.Allocator.Error!bool {
    if (depth > 256) return false;

    const saved = try self.allocator.dupe(bool, self.active);

    defer self.allocator.free(saved);
    defer @memcpy(self.active, saved);

    for (statements, 0..) |statement, index| {
        if (Analyzer.returns(statements[0..index])) return false;

        switch (statement) {
            .constant => |binding| {
                if (!try self.expression(binding.value, 0) or !self.declare(binding.symbol, self.program.expression(binding.value).type_id)) return false;
            },
            .destructure => |binding| {
                if (!try self.expression(binding.value, 0)) return false;

                const target = self.program.typeOf(self.program.expression(binding.value).type_id);

                if (target != .tuple or target.tuple.len != binding.symbols.len) return false;

                for (binding.symbols, target.tuple) |symbol, type_id| {
                    if (symbol) |id| if (!self.declare(id, type_id)) {
                        return false;
                    };
                }
            },
            .result => |value| {
                if (value) |id| {
                    if (!try self.expression(id, 0) or self.program.expression(id).type_id != self.program.output_type) return false;
                } else if (self.program.output_type != Types.scalarId(.void)) return false;
            },
            .branch => |branch| {
                if (!try self.expression(branch.condition, 0) or self.program.expression(branch.condition).type_id != Types.scalarId(.bool)) return false;
                if (!try self.block(branch.yes, depth + 1) or !try self.block(branch.no, depth + 1)) return false;
            },
            .switch_stmt => |selection| {
                if (!try self.expression(selection.subject, 0) or !self.switchCases(selection)) return false;

                for (selection.cases) |case| {
                    if (case.value) |id| if (!try self.expression(id, 0)) {
                        return false;
                    };

                    if (!try self.block(case.body, depth + 1)) return false;
                }
            },
            .store_set => |setter| {
                if (setter.slot >= self.program.stores.len or !self.program.stores[setter.slot].writable or !try self.expression(setter.value, 0) or self.program.expression(setter.value).type_id != self.program.stores[setter.slot].type_id) return false;
            },
        }
    }

    return true;
}

fn expression(self: *Self, id: ir.ExprId, depth: usize) std.mem.Allocator.Error!bool {
    if (@intFromEnum(id) >= self.program.expressions.len or depth > 256) return false;

    return switch (self.program.expression(id).value) {
        .store_get => self.callback_depth == 0,
        .reference => |symbol| self.active[@intFromEnum(symbol)],
        .field, .tuple_field => |field| self.expression(field.target, depth + 1),
        .index => |item| try self.expression(item.target, depth + 1) and try self.expression(item.index, depth + 1),
        .length, .clone, .some => |child| self.expression(child, depth + 1),
        .unary => |unary| self.expression(unary.operand, depth + 1),
        .binary => |binary| try self.expression(binary.left, depth + 1) and try self.expression(binary.right, depth + 1),
        .conditional => |value| try self.expression(value.condition, depth + 1) and try self.expression(value.yes, depth + 1) and try self.expression(value.no, depth + 1),
        .list, .tuple, .template => |items| self.sequence(items, depth + 1),
        .object => |object| blk: {
            if (!try self.sequence(object.evaluation, depth + 1)) break :blk false;

            for (object.fields) |field| if (!try self.expression(field.value, depth + 1)) {
                break :blk false;
            };

            break :blk true;
        },
        .call => |call| self.expression(call.argument, depth + 1),
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
                const index = @intFromEnum(symbol);

                if (self.active[index]) break :blk false;
                if (self.declared[index] and self.parameter_owner[index] != id) break :blk false;

                self.declared[index] = true;
                self.active[index] = true;
                self.parameter_owner[index] = id;
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

fn switchCases(self: *Self, selection: @FieldType(ir.Statement, "switch_stmt")) bool {
    const type_id = self.program.expression(selection.subject).type_id;
    const target = self.program.typeOf(type_id);

    if (target != .enumeration and !numbers.isInteger(type_id) and type_id != Types.scalarId(.bool) and type_id != Types.scalarId(.string)) return false;

    var has_default = false;

    for (selection.cases, 0..) |case, index| {
        if (case.value) |id| {
            if (@intFromEnum(id) >= self.program.expressions.len or self.program.expression(id).type_id != type_id) return false;

            const value = self.program.expression(id).value;

            switch (value) {
                .integer, .negative_integer, .string, .boolean, .enum_value => {},
                else => return false,
            }

            for (selection.cases[0..index]) |previous| {
                if (previous.value) |previous_id| if (same(value, self.program.expression(previous_id).value)) {
                    return false;
                };
            }
        } else {
            if (has_default) return false;

            has_default = true;
        }
    }

    const exhaustive = has_default or (target == .enumeration and selection.cases.len == target.enumeration.members.len) or (type_id == Types.scalarId(.bool) and selection.cases.len == 2);

    return selection.exhaustive == exhaustive;
}

fn same(left: @FieldType(ir.Expression, "value"), right: @FieldType(ir.Expression, "value")) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) {
        return (left == .integer and left.integer == 0 and right == .negative_integer and right.negative_integer == 0) or (right == .integer and right.integer == 0 and left == .negative_integer and left.negative_integer == 0);
    }

    return switch (left) {
        .integer => |value| value == right.integer,
        .negative_integer => |value| value == right.negative_integer,
        .boolean => |value| value == right.boolean,
        .string => |value| std.mem.eql(u8, value, right.string),
        .enum_value => |value| value == right.enum_value,
        else => false,
    };
}
