const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_invocation_builtin");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);

    comptime view.compatible(@TypeOf(name), @FieldType(Input, "name"));

    const owned = try self.allocator.dupe(node.ExpressionId, arguments);

    const input: Input = .{
        .name = @fromBackingInt(@backingInt(name)),
        .arguments = view.slice(@FieldType(Input, "arguments"), owned),
    };

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
