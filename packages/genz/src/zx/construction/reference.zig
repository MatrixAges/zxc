const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const apply = @import("apply.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, copy: bool) Lower.Error!node.ExpressionId {
    const layout = try @import("../types.zig").get(self, self.state_layouts, id);
    const generated = @import("generated_reference_slot");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .value = @backingInt(value),
        .layout = @backingInt(layout),
        .copy = copy,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;
    try apply.expressions(self, output);
    try apply.storage(self, output);
    try apply.flat(self, body, output.statements);

    self.serial = @intCast(output.serial);

    return @fromBackingInt(output.root);
}
