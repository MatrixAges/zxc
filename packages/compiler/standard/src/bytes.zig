const std = @import("std");

pub fn count(haystack: []const u8, needle: u8) u64 {
    return std.mem.countScalar(u8, haystack, needle);
}

pub fn indexOfScalar(haystack: []const u8, start: u64, needle: u8) ?u64 {
    if (start >= haystack.len) return null;

    return if (std.mem.indexOfScalarPos(u8, haystack, @intCast(start), needle)) |index| @intCast(index) else null;
}

pub fn lastIndexOfScalar(haystack: []const u8, needle: u8) ?u64 {
    return if (std.mem.lastIndexOfScalar(u8, haystack, needle)) |index| @intCast(index) else null;
}

pub fn indexOfSlice(haystack: []const u8, start: u64, needle: []const u8) ?u64 {
    if (start > haystack.len) return null;

    return if (std.mem.indexOfPos(u8, haystack, @intCast(start), needle)) |index| @intCast(index) else null;
}

pub fn indexOfText(haystack: []const u8, start: u64, needle: []const u8) ?u64 {
    return indexOfSlice(haystack, start, needle);
}

pub fn startsWith(haystack: []const u8, start: u64, prefix: []const u8) bool {
    return start <= haystack.len and std.mem.startsWith(u8, haystack[@intCast(start)..], prefix);
}

pub fn startsWithText(haystack: []const u8, start: u64, prefix: []const u8) bool {
    return startsWith(haystack, start, prefix);
}

pub fn equals(left: []const u8, right: []const u8) bool {
    return std.mem.eql(u8, left, right);
}

pub fn lessThan(left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
