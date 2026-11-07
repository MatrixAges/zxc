const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");

pub fn lower(self: *Lower, values: node.ExpressionId, position: node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_checked_index");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .values = @backingInt(values),
        .position = @backingInt(position),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = @import("../../node/view.zig").join(output.expressions.*, output.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, output.statements);

    self.serial = output.serial;

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
