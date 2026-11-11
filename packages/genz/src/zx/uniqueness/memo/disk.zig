const std = @import("std");
const columns = @import("zx").columns;
const entry = @import("generated_uniqueness_memo_disk_inspect");
const Input = std.meta.Child(entry.Input);
const Layout = std.meta.Child(std.meta.Child(entry.Output));

pub fn inspect(backing: std.mem.Allocator, bytes: []const u8) std.mem.Allocator.Error!?Layout {
    var scratch = std.heap.ArenaAllocator.init(backing);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const input: Input = .{ .source = bytes };

    const layout = (columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds, error.IntegerOverflow, error.Overflow => return null,
        else => std.debug.panic("memo disk inspection failed: {s}", .{@errorName(err)}),
    }) orelse return null;

    return columns.view(Layout, layout);
}
