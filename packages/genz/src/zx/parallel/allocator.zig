const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn declaration(self: *Lower) Lower.Error!node.Declaration {
    const value = try @import("../allocator.zig").lower(self, false);

    if (!@import("genz_options").generated_analysis) return .{ .constant = .{ .name = "zx_parallel_allocator", .value = value } };

    const entry = @import("generated_parallel_allocator_alias");
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const columns = entry.executeIn(memory.allocator(), @backingInt(value)) catch |err| return failure(err);
    var storage: [1]node.Declaration = undefined;
    var output = std.ArrayList(node.Declaration).initBuffer(&storage);
    @import("../../node/import_constants.zig").appendBorrowingText(self.allocator, &output, columns) catch |err| return failure(err);

    return output.items[0];
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
