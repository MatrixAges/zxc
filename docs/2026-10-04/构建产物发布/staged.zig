const std = @import("std");
const Options = @import("../options.zig").Options;
const Self = @This();

directory: []const u8,
binary: []const u8,
assembly: ?[]const u8,
pub fn init(io: std.Io, allocator: std.mem.Allocator, options: Options) !Self {
    if (options.assembly) |path| {
        const binary = try std.fs.path.resolve(allocator, &.{options.output.?});
        const assembly = try std.fs.path.resolve(allocator, &.{path});

        if (std.mem.eql(u8, binary, assembly)) return error.ConflictingOutputPaths;
    }

    var random: [16]u8 = undefined;

    std.Io.random(io, &random);

    const directory = try std.fmt.allocPrint(allocator, ".zxc/build/pending/{s}", .{std.fmt.bytesToHex(random, .lower)});

    try std.Io.Dir.cwd().createDirPath(io, ".zxc/build/pending");
    try std.Io.Dir.cwd().createDir(io, directory, .default_dir);

    errdefer std.Io.Dir.cwd().deleteTree(io, directory) catch {};

    return .{
        .directory = directory,
        .binary = try std.fs.path.join(allocator, &.{ directory, "binary", std.fs.path.basename(options.output.?) }),
        .assembly = if (options.assembly) |path| try std.fs.path.join(allocator, &.{ directory, "assembly", std.fs.path.basename(path) }) else null,
    };
}

pub fn deinit(self: Self, io: std.Io) void {
    std.Io.Dir.cwd().deleteTree(io, self.directory) catch {};
}

pub fn publish(self: Self, io: std.Io, allocator: std.mem.Allocator, options: Options) !void {
    if (self.assembly) |path| try std.Io.Dir.cwd().copyFile(path, .cwd(), options.assembly.?, io, .{ .make_path = true });

    var directory = try std.Io.Dir.cwd().openDir(io, std.fs.path.dirname(self.binary).?, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        if (entry.kind == .directory or std.mem.eql(u8, entry.path, std.fs.path.basename(self.binary))) continue;
        if (entry.kind != .file) return error.UnsupportedBuildArtifact;

        const destination = try std.fs.path.join(allocator, &.{ std.fs.path.dirname(options.output.?) orelse ".", entry.path });

        try directory.copyFile(entry.path, .cwd(), destination, io, .{ .make_path = true });
    }

    try std.Io.Dir.cwd().copyFile(self.binary, .cwd(), options.output.?, io, .{ .make_path = true });
}
