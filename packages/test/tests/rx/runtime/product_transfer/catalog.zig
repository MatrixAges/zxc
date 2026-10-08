const std = @import("std");

pub const modes = [_][]const u8{ "object", "nested", "shared", "retained_target", "retained_parent", "borrowed", "branch", "duplicate", "growth" };

pub fn slots(mode: []const u8) usize {
    if (std.mem.eql(u8, mode, "object") or std.mem.eql(u8, mode, "nested")) return 2;
    if (std.mem.eql(u8, mode, "retained_target") or std.mem.eql(u8, mode, "growth")) return 1;

    return 0;
}
