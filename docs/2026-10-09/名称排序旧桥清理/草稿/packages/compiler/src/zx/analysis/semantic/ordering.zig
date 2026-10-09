const std = @import("std");
const View = @import("ordering/view.zig");

pub fn sort(names: [][]const u8, types: ?[]u32) std.mem.Allocator.Error!void {
    if (types) |items| std.debug.assert(items.len == names.len);

    const data = View{ .names = names, .types = types };

    std.sort.pdqContext(0, names.len, data);
}
