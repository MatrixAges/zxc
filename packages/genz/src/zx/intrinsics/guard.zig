const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), condition: node.ExpressionId, name: []const u8) Lower.Error!void {
    const generated = @import("generated_failure_branch");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .condition = @backingInt(condition),
        .name = name,
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    try publish(self, body, output);
}

pub fn publish(self: *Lower, body: *std.ArrayList(node.Statement), output: anytype) Lower.Error!void {
    if (!output.valid) return error.OutOfMemory;

    const expressions = @import("../../node/view.zig").join(output.expressions.*, output.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, output.statements);

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, output.roots) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.appendBorrowingText(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
