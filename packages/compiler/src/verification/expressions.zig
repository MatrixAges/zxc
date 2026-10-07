const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const terms = @import("terms.zig");
const Value = terms.Value;
const Evaluation = terms.Evaluation;
const Self = @This();
const Graph = @import("graph.zig");

allocator: std.mem.Allocator,
program: ir.Program,
environment: []?Value,
reporter: *zx.Reporter,
graph: *Graph,
cache: std.AutoHashMapUnmanaged(ir.ExprId, Evaluation) = .empty,
depth: usize = 0,
call_depth: usize = 0,
pub fn evaluate(self: *Self, id: ir.ExprId) zx.Error!Evaluation {
    if (self.cache.get(id)) |result| return result;

    const expression = self.program.expression(id);

    try self.graph.step(expression.span);

    const result = try self.retain(expression, try self.evaluateRaw(id));

    try self.cache.put(self.allocator, id, result);

    return result;
}

fn retain(self: *Self, expression: ir.ExpressionRow, result: Evaluation) zx.Error!Evaluation {
    return .{
        .value = try self.graph.value(self.program, expression.type_id, result.value, expression.span),
        .safe = try self.boolean(result.safe, expression.span),
    };
}

fn boolean(self: *Self, value: []const u8, span: zx.Span) zx.Error![]const u8 {
    return self.graph.bind(value, 0, .{ .file_name = self.program.file_name, .span = span });
}

fn evaluateRaw(self: *Self, id: ir.ExprId) zx.Error!Evaluation {
    const expression = self.program.expression(id);

    if (self.depth >= 256) return self.reporter.fail(.unsupported, expression.span, "verification expression depth exceeds 256");

    self.depth += 1;
    defer self.depth -= 1;

    switch (expression.value) {
        .reference => |symbol| return .{ .value = self.environment[@backingInt(symbol)] orelse return self.reporter.fail(.contract, expression.span, "verification encountered an unbound symbol") },
        .integer, .negative_integer => |number| {
            const target = terms.integer(self.program.typeOf(expression.type_id)).?;
            const value = try terms.constant(self.allocator, number, target.width);

            return .{ .value = .{ .scalar = if (expression.value == .negative_integer) try terms.unary(self.allocator, "bvneg", value) else value } };
        },
        .enum_value => |member| return .{ .value = .{ .scalar = try terms.constant(self.allocator, member, terms.enumWidth(self.program.typeOf(expression.type_id))) } },
        .boolean => |value| return .{ .value = .{ .scalar = if (value) "true" else "false" } },
        .unit => return .{ .value = .{ .fields = &.{} } },
        .field, .tuple_field => |field| {
            const result = try self.evaluate(field.target);

            return .{ .value = result.value.fields[field.index], .safe = result.safe };
        },
        .unary => |operation| {
            const operand = try self.evaluate(operation.operand);

            if (operation.operator == .not) return .{ .value = .{ .scalar = try terms.unary(self.allocator, "not", operand.value.scalar) }, .safe = operand.safe };

            const target = terms.integer(self.program.typeOf(expression.type_id)) orelse return self.unsupported(expression);
            const minimum = try terms.constant(self.allocator, @as(u64, 1) << @intCast(target.width - 1), target.width);
            const safe = try terms.unary(self.allocator, "not", try terms.binary(self.allocator, "=", operand.value.scalar, minimum));

            return .{ .value = .{ .scalar = try terms.unary(self.allocator, "bvneg", operand.value.scalar) }, .safe = try terms.binary(self.allocator, "and", operand.safe, safe) };
        },
        .binary => return self.binary(expression),
        .call => return @import("calls.zig").evaluate(self, expression),
        .conditional => |choice| {
            const condition = try self.evaluate(choice.condition);
            const yes = try self.evaluate(choice.yes);
            const no = try self.evaluate(choice.no);

            return .{
                .value = try terms.select(self.allocator, condition.value.scalar, yes.value, no.value),
                .safe = try terms.binary(self.allocator, "and", condition.safe, try terms.choose(self.allocator, condition.value.scalar, yes.safe, no.safe)),
            };
        },
        .match_expr => |selection| {
            const subject = if (selection.subject) |subject_id| try self.evaluate(subject_id) else null;
            var result = try self.evaluate(selection.fallback);
            var index = selection.arms.len;

            while (index > 0) {
                index -= 1;
                const arm = selection.arms.at(index);
                const condition = try self.evaluate(arm.condition);
                const yes = try self.evaluate(arm.result);
                const selected = if (subject) |value| try terms.binary(self.allocator, "=", value.value.scalar, condition.value.scalar) else condition.value.scalar;

                result = try self.retain(expression, .{
                    .value = try terms.select(self.allocator, selected, yes.value, result.value),
                    .safe = try terms.binary(self.allocator, "and", condition.safe, try terms.choose(self.allocator, selected, yes.safe, result.safe)),
                });
            }

            if (subject) |value| result.safe = try terms.binary(self.allocator, "and", value.safe, result.safe);

            return result;
        },
        .tuple => |items| {
            const fields = try self.allocator.alloc(Value, items.len);
            var safe: []const u8 = "true";

            for (items, fields) |item, *field| {
                const value = try self.evaluate(item);

                field.* = value.value;
                safe = try self.boolean(try terms.binary(self.allocator, "and", safe, value.safe), expression.span);
            }

            return .{ .value = .{ .fields = fields }, .safe = safe };
        },
        .object => |object| {
            const fields = try self.allocator.alloc(Value, object.fields.len);
            var safe: []const u8 = "true";

            for (object.evaluation) |item| {
                const value = try self.evaluate(item);

                safe = try self.boolean(try terms.binary(self.allocator, "and", safe, value.safe), expression.span);
            }

            for (0..object.fields.len) |record_index| {
    const field = object.fields.at(record_index);
                const value = try self.evaluate(field.value);

                fields[field.index] = value.value;
                safe = try self.boolean(try terms.binary(self.allocator, "and", safe, value.safe), expression.span);
            }

            return .{ .value = .{ .fields = fields }, .safe = safe };
        },
        else => return self.unsupported(expression),
    }
}

fn binary(self: *Self, expression: ir.ExpressionRow) zx.Error!Evaluation {
    const operation = expression.value.binary;
    const left = try self.evaluate(operation.left);
    const right = try self.evaluate(operation.right);
    const a = left.value.scalar;
    const b = right.value.scalar;
    const target = self.program.typeOf(self.program.expression(operation.left).type_id);
    var safe = try terms.binary(self.allocator, "and", left.safe, right.safe);

    if (operation.operator == .logical_and or operation.operator == .logical_or) {
        const conjunction = operation.operator == .logical_and;

        safe = try terms.binary(self.allocator, "and", left.safe, try terms.choose(self.allocator, a, if (conjunction) right.safe else "true", if (conjunction) "true" else right.safe));

        return .{ .value = .{ .scalar = try terms.binary(self.allocator, if (conjunction) "and" else "or", a, b) }, .safe = safe };
    }

    if (operation.operator == .equal or operation.operator == .not_equal) {
        if (terms.integer(target) == null and target != .enumeration and !(target == .scalar and target.scalar == .bool)) return self.unsupported(expression);

        const equal = try terms.binary(self.allocator, "=", a, b);

        return .{ .value = .{ .scalar = if (operation.operator == .equal) equal else try terms.unary(self.allocator, "not", equal) }, .safe = safe };
    }

    const integer = terms.integer(target) orelse return self.unsupported(expression);

    const operator: []const u8 = switch (operation.operator) {
        .add => "bvadd",
        .subtract => "bvsub",
        .multiply => "bvmul",
        .divide => if (integer.signed) "bvsdiv" else "bvudiv",
        .remainder => if (integer.signed) "bvsrem" else "bvurem",
        .less => if (integer.signed) "bvslt" else "bvult",
        .less_equal => if (integer.signed) "bvsle" else "bvule",
        .greater => if (integer.signed) "bvsgt" else "bvugt",
        .greater_equal => if (integer.signed) "bvsge" else "bvuge",
        else => return self.unsupported(expression),
    };

    const value = try terms.binary(self.allocator, operator, a, b);

    switch (operation.operator) {
        .add, .subtract, .multiply => {
            const extra: u16 = if (operation.operator == .multiply) integer.width else 1;
            const extension = try std.fmt.allocPrint(self.allocator, "(_ {s} {d})", .{ if (integer.signed) "sign_extend" else "zero_extend", extra });
            const wide = try terms.binary(self.allocator, operator, try terms.unary(self.allocator, extension, a), try terms.unary(self.allocator, extension, b));
            const fits = try terms.binary(self.allocator, "=", wide, try terms.unary(self.allocator, extension, value));
            safe = try terms.binary(self.allocator, "and", safe, fits);
        },
        .divide, .remainder => {
            const zero = try terms.constant(self.allocator, 0, integer.width);

            safe = try terms.binary(self.allocator, "and", safe, try terms.unary(self.allocator, "not", try terms.binary(self.allocator, "=", b, zero)));

            if (integer.signed and operation.operator == .divide) {
                const minimum = try terms.constant(self.allocator, @as(u64, 1) << @intCast(integer.width - 1), integer.width);
                const minus_one = try terms.unary(self.allocator, "bvneg", try terms.constant(self.allocator, 1, integer.width));
                const overflow = try terms.binary(self.allocator, "and", try terms.binary(self.allocator, "=", a, minimum), try terms.binary(self.allocator, "=", b, minus_one));
                safe = try terms.binary(self.allocator, "and", safe, try terms.unary(self.allocator, "not", overflow));
            }
        },
        else => {},
    }

    return .{ .value = .{ .scalar = value }, .safe = safe };
}

fn unsupported(self: *Self, expression: ir.ExpressionRow) zx.Error {
    return self.reporter.fail(.unsupported, expression.span, "formal verification does not yet model this expression");
}
