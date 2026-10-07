const std = @import("std");
const api = @import("zxc_abi").native.@"std:fs";
const path = @import("path.zig");
const Allocator = std.mem.Allocator;

pub fn unlink(io: std.Io, input: []const u8) !void {
    try path.validate(input);
    try std.Io.Dir.cwd().deleteFile(io, input);
}

pub fn rename(io: std.Io, input: api.rename.Input) !void {
    try path.validate(input.from);
    try path.validate(input.to);
    try std.Io.Dir.cwd().rename(input.from, .cwd(), input.to, io);
}

pub fn copyFile(io: std.Io, input: api.copyFile.Input) !void {
    try path.validate(input.from);
    try path.validate(input.to);
    try std.Io.Dir.cwd().copyFile(input.from, .cwd(), input.to, io, .{ .replace = !input.exclusive });
}

pub fn realpath(allocator: Allocator, io: std.Io, input: []const u8) ![]const u8 {
    try path.validate(input);

    var buffer: [std.fs.max_path_bytes]u8 = undefined;
    const length = try std.Io.Dir.cwd().realPathFile(io, input, &buffer);

    if (!std.unicode.utf8ValidateSlice(buffer[0..length])) return error.InvalidUtf8;

    return allocator.dupe(u8, buffer[0..length]);
}

pub fn readlink(allocator: Allocator, io: std.Io, input: []const u8) ![]const u8 {
    try path.validate(input);

    var buffer: [std.fs.max_path_bytes]u8 = undefined;
    const length = try std.Io.Dir.cwd().readLink(io, input, &buffer);

    if (!std.unicode.utf8ValidateSlice(buffer[0..length])) return error.InvalidUtf8;

    return allocator.dupe(u8, buffer[0..length]);
}
