const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn object(self: *Lower, type_expr: node.ExpressionId, fields: []const node.Field) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .object = .{ .type_expr = type_expr, .fields = fields } });

    const entry = @import("generated_aggregate_object");
    const Input = std.meta.Child(entry.Input);
    const stored = try self.builder.nodes.fields(self.allocator, fields);

    const input: Input = .{
        .type_expr = @backingInt(type_expr),
        .first = stored.start,
        .count = stored.len,
    };

    return append(self, entry, &input);
}

pub fn tuple(self: *Lower, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return self.builder.expression(.{ .tuple = values });

    const entry = @import("generated_aggregate_tuple");
    const input = view.slice(entry.Input, values);

    return append(self, entry, input);
}

fn append(self: *Lower, comptime entry: type, input: entry.Input) Lower.Error!node.ExpressionId {
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

    return @fromBackingInt(@intCast(base));
}
