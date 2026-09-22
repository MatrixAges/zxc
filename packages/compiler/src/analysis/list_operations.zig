const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");

pub fn analyze(self: *Analyzer, expression: *const zx.ast.Expression, target: ir.ExprId) zx.Error!ir.ExprId {
    const call = expression.value.call;
    const kind = std.meta.stringToEnum(ir.ListOperation, call.callee.value.field.name.text) orelse return self.reporter.fail(.name, expression.span, "unknown list operation");
    const list_type = self.node(target).type_id;
    const element_type = self.types.get(list_type).list;

    const count: usize = switch (kind) {
        .push, .concat => 1,
        .pop, .sort, .reverse => 0,
        .splice => 3,
    };

    if (call.arguments.len != count) return self.reporter.fail(.type_mismatch, expression.span, "list operation argument count mismatch");
    if (kind == .sort and !numbers.isInteger(element_type) and !numbers.isFloat(element_type) and element_type != Types.scalarId(.string)) return self.reporter.fail(.type_mismatch, expression.span, "sort requires numeric or string elements");

    const arguments = try self.allocator.alloc(ir.ExprId, count);

    for (call.arguments, 0..) |argument, index| {
        const hint = switch (kind) {
            .push => element_type,
            .concat => list_type,
            .splice => if (index < 2) Types.scalarId(.u64) else list_type,
            else => unreachable,
        };

        arguments[index] = try self.expression(argument, hint);
    }

    const result_type = switch (kind) {
        .pop => try self.types.wrap(.optional, element_type),
        .splice => list_type,
        else => Types.scalarId(.void),
    };

    return self.append(.{ .span = expression.span, .type_id = try self.types.tuple(&.{ list_type, result_type }), .value = .{ .list_operation = .{ .kind = kind, .target = target, .arguments = arguments } } });
}
