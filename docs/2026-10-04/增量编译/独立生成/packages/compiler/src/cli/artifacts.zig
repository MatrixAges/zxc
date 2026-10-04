const std = @import("std");

pub fn write(io: std.Io, path: []const u8, content: []const u8) !void {
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, content);
    try file.replace(io);
}

pub fn prepare(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, configuration: []const u8) ![]const u8 {
    var hash: [32]u8 = undefined;
    var state = std.crypto.hash.sha2.Sha256.init(.{});

    state.update("zxc.build.artifacts.v2");

    const graph = try std.json.Stringify.valueAlloc(allocator, .{ .entry = bundle.entry.imports, .modules = bundle.modules }, .{});

    defer allocator.free(graph);

    for ([_][]const u8{ bundle.entry.source, bundle.types, @embedFile("runner.zig"), configuration, graph }) |field| {
        var length: [8]u8 = undefined;

        std.mem.writeInt(u64, &length, @intCast(field.len), .little);
        state.update(&length);
        state.update(field);
    }

    state.final(&hash);

    const directory = try std.fmt.allocPrint(allocator, ".zxc/build/{s}", .{std.fmt.bytesToHex(hash, .lower)});

    try retain(io, allocator, try std.fs.path.join(allocator, &.{ directory, "program.zig" }), bundle.entry.source);
    try retain(io, allocator, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), bundle.types);
    try retain(io, allocator, try std.fs.path.join(allocator, &.{ directory, "main.zig" }), @embedFile("runner.zig"));
    for (bundle.modules) |module| try retain(io, allocator, try modulePath(allocator, module), module.source);

    return directory;
}

pub fn modulePath(allocator: std.mem.Allocator, module: @import("compiler").zig.ModuleFile) std.mem.Allocator.Error![]const u8 {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(module.source, &digest, .{});

    return std.fmt.allocPrint(allocator, ".zxc/build/modules/{s}/{s}.zig", .{ module.name, std.fmt.bytesToHex(digest, .lower) });
}

fn retain(io: std.Io, allocator: std.mem.Allocator, path: []const u8, content: []const u8) !void {
    const existing = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(content.len + 1)) catch |err| switch (err) {
        error.FileNotFound, error.StreamTooLong => return write(io, path, content),
        else => return err,
    };

    defer allocator.free(existing);

    if (!std.mem.eql(u8, existing, content)) try write(io, path, content);
}
