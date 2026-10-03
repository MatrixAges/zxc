const std = @import("std");

pub fn write(io: std.Io, path: []const u8, content: []const u8) !void {
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, content);
    try file.replace(io);
}

pub fn prepare(io: std.Io, allocator: std.mem.Allocator, source: []const u8, types: []const u8, configuration: []const u8) ![]const u8 {
    var hash: [32]u8 = undefined;
    var state = std.crypto.hash.sha2.Sha256.init(.{});

    state.update(source);
    state.update(types);
    state.update(@embedFile("runner.zig"));
    state.update(configuration);
    state.final(&hash);

    const directory = try std.fmt.allocPrint(allocator, ".zxc/build/{s}", .{std.fmt.bytesToHex(hash, .lower)});

    try write(io, try std.fs.path.join(allocator, &.{ directory, "program.zig" }), source);
    try write(io, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), types);
    try write(io, try std.fs.path.join(allocator, &.{ directory, "main.zig" }), @embedFile("runner.zig"));

    return directory;
}
