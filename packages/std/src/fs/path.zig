const std = @import("std");

pub fn validate(path: []const u8) !void {
    if (std.mem.indexOfScalar(u8, path, 0) != null) return error.InvalidPath;
    if (!std.unicode.utf8ValidateSlice(path)) return error.InvalidUtf8;
}
