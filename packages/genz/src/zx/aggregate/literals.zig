const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn tuple(self: *Lower, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .tuple = values });

    const entry = @import("generated_aggregate_tuple");
    const input = view.slice(entry.Input, values);
    const base = self.builder.nodes.expressions.tags.items.len;
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = try entry.executeValue(memory.allocator(), input);
    const rows = zx.columns.view(std.meta.Child(entry.Output), output);

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &rows) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(@intCast(base));
}
