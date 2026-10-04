const std = @import("std");

pub fn name(allocator: std.mem.Allocator, root: []const u8, local: []const u8) ![]const u8 {
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    hash.update(root);
    hash.update(&.{0});
    hash.update(local);

    return std.fmt.allocPrint(allocator, "zxc_native_{s}", .{std.fmt.bytesToHex(hash.finalResult(), .lower)});
}

pub fn declaration(allocator: std.mem.Allocator, root: []const u8, specifier: []const u8) ![]const u8 {
    const end = std.mem.indexOfScalar(u8, specifier, ':') orelse return error.InvalidExternalSpecifier;

    return std.fmt.allocPrint(allocator, "{s}:{s}", .{ specifier[0..end], try name(allocator, root, specifier) });
}
