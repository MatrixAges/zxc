const std = @import("std");

pub fn check(source: []const u8, mode: []const u8) !void {
    const start = std.mem.indexOf(u8, source, "pub fn execute(") orelse return error.MissingExecute;
    const execute = source[start..];
    const transfers = std.mem.eql(u8, mode, "map") or std.mem.eql(u8, mode, "filter") or std.mem.eql(u8, mode, "local") or std.mem.eql(u8, mode, "nested") or std.mem.eql(u8, mode, "tuple");
    const copies = std.mem.count(u8, execute, ").dupe(");

    if (transfers) {
        if (copies != 0) return error.UnexpectedOwnedInitialCopy;
        if (std.mem.indexOf(u8, execute, "@constCast(") == null) return error.MissingOwnedInitialTransfer;
    } else {
        if (copies == 0) return error.MissingSharedInitialCopy;
    }
}
