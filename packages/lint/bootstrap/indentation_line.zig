const std = @import("std");

pub const Planned = struct { start: usize, end: usize, count: usize };

pub fn plan(source: []const u8, offset: usize, level: usize) ?Planned {
    var start = offset;

    while (start > 0 and (source[start - 1] == ' ' or source[start - 1] == '\t')) start -= 1;
    if (start > 0 and source[start - 1] != '\n') return null;

    const count = level * 4;
    const previous = source[start..offset];

    if (previous.len == count and std.mem.indexOfScalar(u8, previous, '\t') == null) return null;

    return .{ .start = start, .end = offset, .count = count };
}
