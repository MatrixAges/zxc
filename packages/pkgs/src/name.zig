const std = @import("std");

pub fn valid(name: []const u8) bool {
    if (name.len == 0) return false;

    var parts = std.mem.splitScalar(u8, if (name[0] == '@') name[1..] else name, '/');
    var count: usize = 0;

    while (parts.next()) |part| {
        if (part.len == 0 or !std.ascii.isAlphanumeric(part[0])) return false;

        for (part) |byte| {
            if (!std.ascii.isLower(byte) and !std.ascii.isDigit(byte) and std.mem.indexOfScalar(u8, "-_.", byte) == null) return false;
        }

        count += 1;
    }

    return count == @as(usize, if (name[0] == '@') 2 else 1);
}
