const std = @import("std");
const zx = @import("zx");
const Slot = @import("root.zig").Slot;

pub fn borrow(comptime Target: type, allocator: std.mem.Allocator, values: []const Slot) std.mem.Allocator.Error!Target {
    const Element = std.meta.Child(Target);
    const indirect = @typeInfo(Element) == .pointer;
    const Row = if (indirect) std.meta.Child(Element) else Element;

    if (comptime @sizeOf(usize) == @sizeOf(u64)) {
        if (comptime !indirect) return zx.columns.storage.view(Target, values);

        const pointers = try allocator.alloc(Element, values.len);

        for (values, pointers) |*value, *pointer| pointer.* = zx.columns.storage.view(Element, value);

        return pointers;
    }

    const headers = try allocator.alloc(Row, values.len);

    for (values, headers) |value, *header| header.* = .{ .index = @intCast(value.index), .writable = value.writable };

    if (comptime !indirect) return headers;

    const pointers = try allocator.alloc(Element, values.len);

    for (headers, pointers) |*header, *pointer| pointer.* = header;

    return pointers;
}
