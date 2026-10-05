const std = @import("std");
const host = @import("../host/root.zig");
const idna = @import("../host/idna/root.zig");

pub fn domainToASCII(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return host.parse(allocator, input, false) catch |err| switch (err) {
        error.OutOfMemory => return err,
        else => allocator.dupe(u8, ""),
    };
}

pub fn domainToUnicode(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    const ascii = try domainToASCII(allocator, input);

    defer allocator.free(ascii);

    return idna.toUnicode(allocator, ascii) catch |err| switch (err) {
        error.OutOfMemory => return err,
        else => allocator.dupe(u8, ascii),
    };
}
