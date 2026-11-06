const std = @import("std");

/// Names of the functions declared `pub inline fn` at the start of a line; callers must expand them in their
/// own unit.
pub fn inlineNames(allocator: std.mem.Allocator, source: []const u8) ![]const []const u8 {
    const marker = "pub inline fn ";
    var names: std.ArrayList([]const u8) = .empty;
    var cursor: usize = 0;

    while (@import("compiler").zig.search.find(source, cursor, marker)) |at| {
        cursor = at + marker.len;

        if (at != 0 and source[at - 1] != '\n') continue;

        const end = std.mem.indexOfScalarPos(u8, source, cursor, '(') orelse break;

        try names.append(allocator, source[cursor..end]);
    }

    return names.items;
}
