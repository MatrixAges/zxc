const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn tuple(self: *Lower, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .tuple = values });

    const entry = @import("generated_aggregate_tuple");
    const input = view.slice(entry.Input, values);

    return append(self, entry, input, 1);
}

pub fn array(self: *Lower, element: node.ExpressionId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) {
        const literal = try self.builder.expression(.{ .array = .{ .element_type = element, .values = values } });

        return self.builder.expression(.{ .address_of = literal });
    }

    const entry = @import("generated_aggregate_array");
    const Input = std.meta.Child(entry.Input);
    const base = self.builder.nodes.expressions.tags.items.len;

    if (base > std.math.maxInt(u32) - 2) return error.OutOfMemory;

    const input: Input = .{
        .values = view.slice(@FieldType(Input, "values"), values),
        .element = @backingInt(element),
        .base = @intCast(base),
    };

    return append(self, entry, &input, 2);
}

fn append(self: *Lower, comptime entry: type, input: entry.Input, count: usize) Lower.Error!node.ExpressionId {
    const base = self.builder.nodes.expressions.tags.items.len;
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);

    const output = if (comptime @typeInfo(entry.Input).pointer.size == .slice)
        try entry.executeValue(memory.allocator(), input)
    else
        try zx.columns.invoke(entry.executeValue, memory.allocator(), input);

    const rows = zx.columns.view(std.meta.Child(entry.Output), output);

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &rows) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(@intCast(base + count - 1));
}
