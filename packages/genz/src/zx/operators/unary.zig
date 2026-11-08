const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const Operation = @FieldType(@FieldType(zx.ir.ExpressionRow, "value"), "unary");

pub fn lower(self: *Lower, value: Operation) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .unary = .{ .operator = if (value.operator == .not) .not else .negate, .operand = try self.expr(value.operand) } });

    const generated = @import("generated_unary_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);

    comptime view.compatible(@FieldType(Operation, "operator"), @FieldType(Input, "operator"));

    const operand = try self.expr(value.operand);
    const input: Input = .{ .operator = @fromBackingInt(@intCast(@backingInt(value.operator))), .operand = @backingInt(operand) };
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = try zx.columns.invoke(generated.executeValue, memory.allocator(), @as(*const Input, &input));
    const emitted = zx.columns.view(Output, output);
    const root = self.builder.nodes.expressions.tags.items.len;

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &emitted) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(@intCast(root));
}
