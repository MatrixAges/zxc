const std = @import("std");
const api = @import("zxc_abi").native.@"std:fs";
const path = @import("path.zig");
const Allocator = std.mem.Allocator;

pub fn readFile(allocator: Allocator, io: std.Io, input: api.readFile.Input) ![]const u8 {
    try path.validate(input.path);

    return std.Io.Dir.cwd().readFileAlloc(io, input.path, allocator, .limited64(input.max_bytes +| 1));
}

pub fn readText(allocator: Allocator, io: std.Io, input: api.readText.Input) ![]const u8 {
    const bytes = try readFile(allocator, io, input);

    errdefer allocator.free(bytes);

    if (!std.unicode.utf8ValidateSlice(bytes)) return error.InvalidUtf8;

    return bytes;
}

pub fn writeFile(io: std.Io, input: api.writeFile.Input) !void {
    try path.validate(input.path);
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = input.path, .data = input.data });
}

pub fn writeText(io: std.Io, input: api.writeText.Input) !void {
    try path.validate(input.path);
    if (!std.unicode.utf8ValidateSlice(input.text)) return error.InvalidUtf8;

    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = input.path, .data = input.text });
}

pub fn truncate(io: std.Io, input: api.truncate.Input) !void {
    try path.validate(input.path);

    const file = try std.Io.Dir.cwd().openFile(io, input.path, .{ .mode = .write_only, .allow_directory = false });

    defer file.close(io);

    try file.setLength(io, input.length);
}
