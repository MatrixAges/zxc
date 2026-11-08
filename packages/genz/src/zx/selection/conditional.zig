const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Operation = @FieldType(@FieldType(zx.ir.ExpressionRow, "value"), "conditional");

pub fn lower(self: *Lower, value: Operation) Lower.Error!node.ExpressionId {
    const condition = try self.expr(value.condition);
    const yes = try self.expr(value.yes);
    const no = try self.expr(value.no);

    return construct(self, condition, yes, no);
}

pub fn construct(self: *Lower, condition: node.ExpressionId, yes: node.ExpressionId, no: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .conditional = .{ .condition = condition, .yes = yes, .no = no } });

    const generated = @import("generated_conditional_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const input: Input = .{ .condition = @backingInt(condition), .yes = @backingInt(yes), .no = @backingInt(no) };
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
