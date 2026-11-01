const std = @import("std");
const layout = @import("../layout/root.zig");

pub fn format(allocator: std.mem.Allocator, source: []const u8, tokens: anytype, comments: anytype) std.mem.Allocator.Error![]u8 {
    return formatAt(allocator, source, tokens, comments, 0);
}

pub fn formatAt(allocator: std.mem.Allocator, source: []const u8, tokens: anytype, comments: anytype, base_level: usize) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const projection = try layout.Projection.init(arena.allocator(), source, tokens, comments);

    return layout.indent(allocator, source, projection.tokens, base_level);
}
