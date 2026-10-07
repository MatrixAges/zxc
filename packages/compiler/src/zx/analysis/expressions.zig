const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const span = expression.span;

    if (@import("expression_binding.zig").unit(self, expression)) return self.append(.{ .span = span, .type_id = Types.scalarId(.void), .value = .unit });

    if (@import("expression_binding.zig").lookup(self, expression)) |binding| {
        const symbol = try self.resolveValue(.{ .text = self.symbols.at(@backingInt(binding)).name, .span = span });

        return @import("refinement.zig").reference(self, symbol, span);
    }

    switch (syntax.value(expression)) {
        .number => |text| return numbers.literal(self, text, span, aggregates.payload(self, expected), false),
        .string => |text| return self.append(.{ .span = span, .type_id = Types.scalarId(.string), .value = .{ .string = try @import("strings.zig").decode(self.allocator, text[1 .. text.len - 1]) } }),
        .boolean => |value| return self.append(.{ .span = span, .type_id = Types.scalarId(.bool), .value = .{ .boolean = value } }),
        .identifier => |name| {
            const symbol = try self.resolveValue(name);

            return @import("refinement.zig").reference(self, symbol, span);
        },
        .field => |field| {
            const target_value = syntax.value(field.target);

            if (target_value == .identifier and std.mem.startsWith(u8, target_value.identifier.text, "$") and @import("expression_binding.zig").lookup(self, field.target) == null and !@import("expression_binding.zig").unit(self, field.target)) {
                return @import("store.zig").read(self, expression);
            }

            if (target_value == .identifier) {
                const name = target_value.identifier.text;

                if (std.mem.eql(u8, name, "error") and self.lookup(name) == null) return @import("capture.zig").member(self, field.name, span, aggregates.payload(self, expected));

                if (self.types.resolved.get(name) orelse aliasType(self, name)) |type_id| {
                    const named_type = self.types.get(type_id);

                    if (named_type == .enumeration) {
                        for (named_type.enumeration.members, 0..) |member, index| {
                            if (std.mem.eql(u8, member, field.name.text)) return self.append(.{ .span = span, .type_id = type_id, .value = .{ .enum_value = @intCast(index) } });
                        }

                        return self.reporter.fail(.name, field.name.span, "unknown enum member");
                    }
                }
            }

            const target = try self.expression(field.target, null);
            const target_type = self.types.items.view().at(@backingInt(self.node(target).type_id));

            if ((target_type == .list or self.node(target).type_id == Types.scalarId(.string)) and std.mem.eql(u8, field.name.text, "length")) {
                return self.append(.{ .span = span, .type_id = Types.scalarId(.u64), .value = .{ .length = target } });
            }

            if (target_type != .object) return self.reporter.fail(.type_mismatch, field.name.span, "field access requires an object");

            for (0..target_type.object.len, 0..) |view_index, index| {
                const item = target_type.object.at(view_index);

                if (std.mem.eql(u8, item.name, field.name.text)) return self.append(.{
                    .span = span,
                    .type_id = item.type_id,
                    .value = .{ .field = .{ .target = target, .index = @intCast(index) } },
                });
            }

            return self.reporter.fail(.name, field.name.span, "unknown object field");
        },
        .capture => |child| return @import("capture.zig").analyze(self, child, span),
        .task => |child| return @import("tasks.zig").start(self, child, span),
        .await_task => |child| return @import("tasks.zig").wait(self, child, span),
        .cancel_task => |child| return @import("tasks.zig").cancel(self, child, span),
        .unary => |unary| {
            if (unary.operator == .negate and syntax.value(unary.operand) == .number) return numbers.literal(self, syntax.value(unary.operand).number, span, aggregates.payload(self, expected), true);

            const operand = try self.expression(unary.operand, if (unary.operator == .not) Types.scalarId(.bool) else aggregates.payload(self, expected));
            const type_id = self.node(operand).type_id;

            if (unary.operator == .negate and !numbers.isSigned(type_id) and !numbers.isFloat(type_id)) return self.reporter.fail(.type_mismatch, span, "negation requires a signed integer or float");

            return self.append(.{ .span = span, .type_id = type_id, .value = .{ .unary = .{ .operator = if (unary.operator == .not) .not else .negate, .operand = operand } } });
        },
        .binary => |binary| {
            if (binary.operator == .coalesce) {
                const left = try self.expression(binary.left, null);
                const left_type = self.types.get(self.node(left).type_id);

                if (left_type != .optional) return self.reporter.fail(.type_mismatch, span, "?? requires an optional left operand");

                const right = try self.expression(binary.right, left_type.optional);

                return self.append(.{ .span = span, .type_id = left_type.optional, .value = .{ .binary = .{ .operator = .coalesce, .left = left, .right = right } } });
            }

            const logical = binary.operator == .logical_and or binary.operator == .logical_or;

            const comparison = switch (binary.operator) {
                .equal, .not_equal, .less, .less_equal, .greater, .greater_equal => true,
                else => false,
            };

            const hint = if (logical) Types.scalarId(.bool) else knownType(self, binary.left) orelse knownType(self, binary.right) orelse (if (comparison) null else aggregates.payload(self, expected)) orelse literalHint(binary.left, binary.right);
            const left = try self.expression(binary.left, hint);
            const operand_type = self.node(left).type_id;
            const facts = self.refinement.mark();

            if (logical) try self.refinement.assume(self.allocator, self.nodes.view(), left, binary.operator == .logical_and);

            const right = try self.expression(binary.right, operand_type);

            self.refinement.restore(facts);

            const numeric = numbers.isInteger(operand_type) or numbers.isFloat(operand_type);
            const equality = binary.operator == .equal or binary.operator == .not_equal;

            if (equality and self.types.get(operand_type) == .optional and !comparable(self, operand_type) and self.node(left).value != .none and self.node(right).value != .none) return self.reporter.fail(.type_mismatch, span, "optional aggregates can only be compared with null");
            if (!logical and !numeric and !(equality and (operand_type == Types.scalarId(.bool) or operand_type == Types.scalarId(.string) or self.types.get(operand_type) == .enumeration or self.types.get(operand_type) == .error_set or self.types.get(operand_type) == .optional))) return self.reporter.fail(.type_mismatch, span, "operator is not supported for these operand types");

            return self.append(.{
                .span = span,
                .type_id = if (logical or comparison) Types.scalarId(.bool) else operand_type,
                .value = .{ .binary = .{ .operator = binary.operator, .left = left, .right = right } },
            });
        },
        .conditional => |conditional| {
            const condition = try self.expression(conditional.condition, Types.scalarId(.bool));
            const hint = expected orelse knownType(self, conditional.yes) orelse knownType(self, conditional.no) orelse literalHint(conditional.yes, conditional.no);
            const facts = self.refinement.mark();

            try self.refinement.assume(self.allocator, self.nodes.view(), condition, true);

            const yes = try self.expression(conditional.yes, hint);
            const type_id = self.node(yes).type_id;

            self.refinement.restore(facts);

            try self.refinement.assume(self.allocator, self.nodes.view(), condition, false);

            const no = try self.expression(conditional.no, type_id);

            self.refinement.restore(facts);

            return self.append(.{ .span = span, .type_id = type_id, .value = .{ .conditional = .{ .condition = condition, .yes = yes, .no = no } } });
        },
        .match_expr => return @import("match.zig").analyze(self, expression, expected),
        .object => |fields| return aggregates.object(self, fields, span, expected),
        .list => |items| return aggregates.list(self, items, span, expected),
        .null_value => {
            const type_id = expected orelse return self.reporter.fail(.type_mismatch, span, "null requires an optional type context");

            if (self.types.get(type_id) != .optional) return self.reporter.fail(.type_mismatch, span, "null requires an optional type context");

            return self.append(.{ .span = span, .type_id = type_id, .value = .none });
        },
        .index => |item| {
            const target = try self.expression(item.target, null);
            var target_type = self.types.get(self.node(target).type_id);
            const is_string = self.node(target).type_id == Types.scalarId(.string);

            if (target_type != .list and target_type != .tuple and !is_string) return self.reporter.fail(.type_mismatch, span, "indexing requires a list, tuple or string");

            const index = try self.expression(item.index, Types.scalarId(.u64));

            target_type = self.types.get(self.node(target).type_id);

            if (target_type == .tuple) {
                const value = self.node(index).value;

                if (value != .integer) return self.reporter.fail(.type_mismatch, item.index.span, "tuple indexing requires an integer literal");
                if (value.integer >= target_type.tuple.len) return self.reporter.fail(.type_mismatch, item.index.span, "tuple index is out of bounds");

                return self.append(.{ .span = span, .type_id = target_type.tuple.at(@intCast(value.integer)), .value = .{ .tuple_field = .{ .target = target, .index = @intCast(value.integer) } } });
            }

            return self.append(.{ .span = span, .type_id = if (is_string) Types.scalarId(.u8) else target_type.list, .value = .{ .index = .{ .target = target, .index = index } } });
        },
        .call => return @import("calls.zig").analyze(self, expression, expected),
        .lambda => return self.reporter.fail(.unsupported, span, "callbacks are only allowed directly in map, filter, reduce or loop rules"),
        .state_block => return self.reporter.fail(.unsupported, span, "state update blocks are only allowed in loop"),
        .template => return @import("strings.zig").template(self, expression),
    }
}

pub fn knownType(self: *const Analyzer, value: anytype) ?ir.TypeId {
    if (@import("expression_binding.zig").unit(self, value)) return Types.scalarId(.void);
    if (@import("expression_binding.zig").lookup(self, value)) |binding| return @import("refinement.zig").typeOf(self, binding);

    return switch (syntax.value(value)) {
        .await_task => |child| blk: {
            if (syntax.value(child) == .task) break :blk knownType(self, syntax.value(child).task);

            const type_id = knownType(self, child) orelse break :blk null;
            const target = self.types.get(type_id);

            break :blk if (target == .task) target.task.result else null;
        },
        .identifier => |name| if (self.lookup(name.text)) |id| @import("refinement.zig").typeOf(self, id) else null,
        .field => |field| blk: {
            const target_value = syntax.value(field.target);

            if (target_value == .identifier and std.mem.startsWith(u8, target_value.identifier.text, "$")) {
                for (0..self.stores.count()) |store_index| {
                    const slot = self.stores.at(store_index);

                    if (std.mem.eql(u8, slot.handle, target_value.identifier.text) and std.mem.eql(u8, field.name.text, "value")) break :blk slot.type_id;
                }
            }

            const type_id = knownType(self, field.target) orelse break :blk null;
            const value_type = self.types.items.view().at(@backingInt(type_id));

            if ((value_type == .list or type_id == Types.scalarId(.string)) and std.mem.eql(u8, field.name.text, "length")) break :blk Types.scalarId(.u64);

            if (value_type == .object) {
                for (0..value_type.object.len) |item_index| {
                    const item = value_type.object.at(item_index);

                    if (std.mem.eql(u8, item.name, field.name.text)) break :blk item.type_id;
                }
            }

            break :blk null;
        },
        .index => |item| blk: {
            const type_id = knownType(self, item.target) orelse break :blk null;
            const target = self.types.get(type_id);

            if (type_id == Types.scalarId(.string)) break :blk Types.scalarId(.u8);
            if (target == .list) break :blk target.list;
            if (target != .tuple or syntax.value(item.index) != .number) break :blk null;

            const index = std.fmt.parseInt(u64, syntax.value(item.index).number, 10) catch break :blk null;

            break :blk if (index < target.tuple.len) target.tuple.at(@intCast(index)) else null;
        },
        .call => |call| blk: {
            const callee = syntax.value(call.callee);

            if (callee == .identifier) {
                if (self.lookup(callee.identifier.text) != null) break :blk null;

                for (self.function_imports) |function| {
                    if (function.namespace == null and std.mem.eql(u8, function.name, callee.identifier.text)) break :blk function.output_type;
                }
            } else if (callee == .field and syntax.value(callee.field.target) == .identifier) {
                const field = callee.field;
                const owner = syntax.value(field.target).identifier.text;

                if (self.lookup(owner) != null) break :blk null;

                for (self.function_imports) |function| {
                    const namespace = function.namespace orelse continue;

                    if (std.mem.eql(u8, namespace, owner) and std.mem.eql(u8, function.name, field.name.text)) break :blk function.output_type;
                }
            }

            break :blk null;
        },
        .unary => |unary| if (unary.operator == .not) Types.scalarId(.bool) else knownType(self, unary.operand),
        .binary => |binary| switch (binary.operator) {
            .coalesce => blk: {
                const type_id = knownType(self, binary.left) orelse break :blk null;
                const target = self.types.get(type_id);

                break :blk if (target == .optional) target.optional else null;
            },
            .equal, .not_equal, .less, .less_equal, .greater, .greater_equal, .logical_and, .logical_or => Types.scalarId(.bool),
            else => knownType(self, binary.left) orelse knownType(self, binary.right),
        },
        .conditional => |conditional| knownType(self, conditional.yes) orelse knownType(self, conditional.no),
        .match_expr => |selection| @import("match.zig").hint(self, selection),
        .boolean => Types.scalarId(.bool),
        .string => Types.scalarId(.string),
        else => null,
    };
}

pub fn literalHint(left: anytype, right: @TypeOf(left)) ?ir.TypeId {
    var signed = false;

    for ([_]@TypeOf(left){ left, right }) |expression| {
        const value = if (syntax.value(expression) == .unary and syntax.value(expression).unary.operator == .negate) blk: {
            signed = true;

            break :blk syntax.value(expression).unary.operand;
        } else expression;

        if (syntax.value(value) == .number and std.mem.indexOfAny(u8, syntax.value(value).number, ".eE") != null) return Types.scalarId(.f64);
    }

    return if (signed) Types.scalarId(.i64) else null;
}

fn aliasType(self: *const Analyzer, name: []const u8) ?ir.TypeId {
    for (self.types.aliases) |alias| if (std.mem.eql(u8, alias.name, name)) {
        return alias.type_id;
    };

    return null;
}

fn comparable(self: *const Analyzer, id: ir.TypeId) bool {
    return switch (self.types.get(id)) {
        .scalar => |scalar| scalar != .void,
        .enumeration, .error_set => true,
        .optional => |child| comparable(self, child),
        else => false,
    };
}
