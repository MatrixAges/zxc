const std = @import("std");

pub fn count(haystack: []const u8, needle: u8) u64 {
    return std.mem.countScalar(u8, haystack, needle);
}
