const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const numbers = @import("numbers.zig");
const text_method = "concatText";
const text_element = "concatText requires a byte list";

pub fn analyze(self: *Analyzer, expression: anytype, target: ir.ExprId) zx.Error!ir.ExprId {
    const call = syntax.value(expression).call;

    if (std.mem.eql(u8, syntax.value(call.callee).field.name.text, "with")) return @import("list_replacement.zig").analyze(self, expression, target);

    const text = std.mem.eql(u8, syntax.value(call.callee).field.name.text, text_method);
    const kind = if (text) ir.ListOperation.concat else std.meta.stringToEnum(ir.ListOperation, syntax.value(call.callee).field.name.text) orelse return self.reporter.fail(.name, expression.span, "unknown list operation");
    const list_type = self.node(target).type_id;
    const element_type = self.types.get(list_type).list;

    if (text and element_type != Types.scalarId(.u8)) return self.reporter.fail(.type_mismatch, expression.span, text_element);

    const count: usize = switch (kind) {
        .push, .concat => 1,
        .pop, .sort, .reverse, .slice => 0,
        .splice => 3,
    };

    if (call.arguments.len != count) return self.reporter.fail(.type_mismatch, expression.span, "list operation argument count mismatch");
    if (kind == .sort and !numbers.isInteger(element_type) and !numbers.isFloat(element_type) and element_type != Types.scalarId(.string)) return self.reporter.fail(.type_mismatch, expression.span, "sort requires numeric or string elements");

    const arguments = try self.allocator.alloc(ir.ExprId, count);

    for (0..call.arguments.len) |index| {
        const argument = syntax.item(call.arguments, index);

        const hint = switch (kind) {
            .push => element_type,
            .concat => if (text) Types.scalarId(.string) else list_type,
            .splice => if (index < 2) Types.scalarId(.u64) else list_type,
            else => unreachable,
        };

        arguments[index] = try self.expression(argument, hint);
    }

    const result_type = if (kind == .slice) list_type else try self.types.tuple(&.{ list_type, switch (kind) {
        .pop => try self.types.wrap(.optional, element_type),
        .splice => list_type,
        else => Types.scalarId(.void),
    } });

    return self.append(.{ .span = expression.span, .type_id = result_type, .value = .{ .list_operation = .{ .kind = kind, .target = target, .arguments = arguments } } });
}
