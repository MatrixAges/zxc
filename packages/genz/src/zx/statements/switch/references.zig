const std = @import("std");
const zx = @import("zx");
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn name(self: *Lower) Lower.Error![]const u8 {
    const entry = @import("generated_switch_name");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .serial = self.serial };
    const output = zx.columns.invoke(entry.executeValue, self.allocator, @as(*const Input, &input)) catch |err| return failure(err);

    self.serial = @intCast(output.serial);

    return output.name;
}

pub fn identifier(self: *Lower, text: []const u8) Lower.Error!node.ExpressionId {
    const entry = @import("generated_switch_reference");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .name = text, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(buffered.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    @import("../../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, output.expressions) catch |err| return failure(err);

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
