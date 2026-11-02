const std = @import("std");

pub const Url = struct {
    scheme: []const u8 = "",
    username: []const u8 = "",
    password: []const u8 = "",
    host: ?[]const u8 = null,
    port: ?u16 = null,
    path: []const []const u8 = &.{},
    opaque_path: ?[]const u8 = null,
    query: ?[]const u8 = null,
    fragment: ?[]const u8 = null,
};

pub fn special(scheme: []const u8) bool {
    return std.mem.eql(u8, scheme, "file") or defaultPort(scheme) != null;
}

pub fn defaultPort(scheme: []const u8) ?u16 {
    if (std.mem.eql(u8, scheme, "ftp")) return 21;
    if (std.mem.eql(u8, scheme, "http") or std.mem.eql(u8, scheme, "ws")) return 80;
    if (std.mem.eql(u8, scheme, "https") or std.mem.eql(u8, scheme, "wss")) return 443;

    return null;
}
