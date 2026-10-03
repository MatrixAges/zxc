const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");
const aggregates = @import("aggregates.zig");

pub fn analyze(self: *Analyzer, expression: *const zx.ast.Expression, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const span = expression.span;

    switch (expression.value) {
        .number => |text| return numbers.literal(self, text, span, aggregates.payload(self, expected), false),
        .string => |text| return self.append(.{ .span = span, .type_id = Types.scalarId(.string), .value = .{ .string = try @import("strings.zig").decode(self.allocator, text[1 .. text.len - 1]) } }),
        .boolean => |value| return self.append(.{ .span = span, .type_id = Types.scalarId(.bool), .value = .{ .boolean = value } }),
        .identifier => |name| {
            const symbol = try self.resolveValue(name);

            return self.append(.{ .span = span, .type_id = self.symbols.items[@intFromEnum(symbol)].type_id, .value = .{ .reference = symbol } });
        },
        .field => |field| {
            if (field.target.value == .identifier and std.mem.startsWith(u8, field.target.value.identifier.text, "$")) {
                return @import("store.zig").read(self, expression);
            }

            if (field.target.value == .identifier) {
                const name = field.target.value.identifier.text;

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
            const target_type = self.types.items.items[@intFromEnum(self.node(target).type_id)];

            if ((target_type == .list or self.node(target).type_id == Types.scalarId(.string)) and std.mem.eql(u8, field.name.text, "length")) {
                return self.append(.{ .span = span, .type_id = Types.scalarId(.u64), .value = .{ .length = target } });
            }

            if (target_type != .object) return self.reporter.fail(.type_mismatch, field.name.span, "field access requires an object");

            for (target_type.object, 0..) |item, index| {
                if (std.mem.eql(u8, item.name, field.name.text)) return self.append(.{
                    .span = span,
                    .type_id = item.type_id,
                    .value = .{ .field = .{ .target = target, .index = @intCast(index) } },
                });
            }

            return self.reporter.fail(.name, field.name.span, "unknown object field");
        },
        .unary => |unary| {
            if (unary.operator == .negate and unary.operand.value == .number) return numbers.literal(self, unary.operand.value.number, span, aggregates.payload(self, expected), true);

            const operand = try self.expression(unary.operand, if (unary.operator == .not) Types.scalarId(.bool) else expected);
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

            const hint = if (logical) Types.scalarId(.bool) else knownType(self, binary.left) orelse knownType(self, binary.right) orelse (if (comparison) null else expected) orelse literalHint(binary.left, binary.right);
            const left = try self.expression(binary.left, hint);
            const operand_type = self.node(left).type_id;
            const right = try self.expression(binary.right, operand_type);
            const numeric = numbers.isInteger(operand_type) or numbers.isFloat(operand_type);
            const equality = binary.operator == .equal or binary.operator == .not_equal;

            if (equality and self.types.get(operand_type) == .optional and !comparable(self, operand_type) and self.node(left).value != .none and self.node(right).value != .none) return self.reporter.fail(.type_mismatch, span, "optional aggregates can only be compared with null");
            if (!logical and !numeric and !(equality and (operand_type == Types.scalarId(.bool) or operand_type == Types.scalarId(.string) or self.types.get(operand_type) == .enumeration or self.types.get(operand_type) == .optional))) return self.reporter.fail(.type_mismatch, span, "operator is not supported for these operand types");

            return self.append(.{
                .span = span,
                .type_id = if (logical or comparison) Types.scalarId(.bool) else operand_type,
                .value = .{ .binary = .{ .operator = binary.operator, .left = left, .right = right } },
            });
        },
        .conditional => |conditional| {
            const condition = try self.expression(conditional.condition, Types.scalarId(.bool));
            const hint = expected orelse knownType(self, conditional.yes) orelse knownType(self, conditional.no) orelse literalHint(conditional.yes, conditional.no);
            const yes = try self.expression(conditional.yes, hint);
            const type_id = self.node(yes).type_id;
            const no = try self.expression(conditional.no, type_id);

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
            const target_type = self.types.get(self.node(target).type_id);

            if (target_type != .list) return self.reporter.fail(.type_mismatch, span, "indexing requires a list");

            const index = try self.expression(item.index, Types.scalarId(.u64));

            return self.append(.{ .span = span, .type_id = target_type.list, .value = .{ .index = .{ .target = target, .index = index } } });
        },
        .call => return @import("calls.zig").analyze(self, expression, expected),
        .lambda => return self.reporter.fail(.unsupported, span, "callbacks are only allowed directly in map, filter or reduce"),
        .template => return @import("strings.zig").template(self, expression),
    }
}

pub fn knownType(self: *const Analyzer, value: *const zx.ast.Expression) ?ir.TypeId {
    return switch (value.value) {
        .identifier => |name| if (self.lookup(name.text)) |id| self.symbols.items[@intFromEnum(id)].type_id else null,
        .field => |field| blk: {
            if (field.target.value == .identifier and std.mem.startsWith(u8, field.target.value.identifier.text, "$")) {
                for (self.stores) |slot| {
                    if (std.mem.eql(u8, slot.handle, field.target.value.identifier.text) and std.mem.eql(u8, field.name.text, "value")) break :blk slot.type_id;
                }
            }

            const type_id = knownType(self, field.target) orelse break :blk null;
            const value_type = self.types.items.items[@intFromEnum(type_id)];

            if ((value_type == .list or type_id == Types.scalarId(.string)) and std.mem.eql(u8, field.name.text, "length")) break :blk Types.scalarId(.u64);

            if (value_type == .object) {
                for (value_type.object) |item| {
                    if (std.mem.eql(u8, item.name, field.name.text)) break :blk item.type_id;
                }
            }

            break :blk null;
        },
        .index => |item| blk: {
            const type_id = knownType(self, item.target) orelse break :blk null;
            const target = self.types.get(type_id);

            break :blk if (target == .list) target.list else null;
        },
        .call => |call| blk: {
            if (call.callee.value == .identifier) {
                for (self.function_imports) |function| {
                    if (std.mem.eql(u8, function.name, call.callee.value.identifier.text)) break :blk function.output_type;
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

pub fn literalHint(left: *const zx.ast.Expression, right: *const zx.ast.Expression) ?ir.TypeId {
    var signed = false;

    for ([_]*const zx.ast.Expression{ left, right }) |expression| {
        const value = if (expression.value == .unary and expression.value.unary.operator == .negate) blk: {
            signed = true;

            break :blk expression.value.unary.operand;
        } else expression;

        if (value.value == .number and std.mem.indexOfAny(u8, value.value.number, ".eE") != null) return Types.scalarId(.f64);
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
        .enumeration => true,
        .optional => |child| comparable(self, child),
        else => false,
    };
}
