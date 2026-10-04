const std = @import("std");

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step.Options {
    return generate(b, target, optimize) catch @panic("cannot fingerprint compiler sources");
}

fn generate(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !*std.Build.Step.Options {
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    field(&hash, "zxc.semantic.cache.v1");
    field(&hash, @import("builtin").zig_version_string);
    field(&hash, try target.result.zigTriple(b.allocator));
    field(&hash, @tagName(optimize));

    try directory(b, &hash, "compiler", b.path("src").getPath(b));
    try directory(b, &hash, "compiler-build", b.path("build").getPath(b));
    try file(b, &hash, "compiler/build.zig", b.path("build.zig").getPath(b));
    try file(b, &hash, "compiler/build.zig.zon", b.path("build.zig.zon").getPath(b));
    try file(b, &hash, "standard/modules.json", b.path("standard/modules.json").getPath(b));
    try directory(b, &hash, "standard/interfaces", b.path("standard/interfaces").getPath(b));

    for ([_][]const u8{ "zx", "dsl", "lint", "genz" }) |name| {
        const dependency = b.dependency(name, .{ .target = target, .optimize = optimize });

        try directory(b, &hash, name, dependency.path("src").getPath(b));
        try file(b, &hash, b.fmt("{s}/build.zig", .{name}), dependency.path("build.zig").getPath(b));
        try file(b, &hash, b.fmt("{s}/build.zig.zon", .{name}), dependency.path("build.zig.zon").getPath(b));
    }

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    const options = b.addOptions();

    options.addOption([32]u8, "digest", digest);

    return options;
}

fn directory(b: *std.Build, hash: *std.crypto.hash.sha2.Sha256, name: []const u8, path: []const u8) !void {
    var dir = try std.Io.Dir.cwd().openDir(b.graph.io, path, .{ .iterate = true });

    defer dir.close(b.graph.io);

    var walker = try dir.walk(b.allocator);

    defer walker.deinit();

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) continue;
        if (entry.kind != .file) return error.UnsupportedSourceFile;
        try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);
    field(hash, name);

    var count: [8]u8 = undefined;

    std.mem.writeInt(u64, &count, @intCast(paths.items.len), .little);
    field(hash, &count);

    for (paths.items) |relative| {
        const content = try dir.readFileAlloc(b.graph.io, relative, b.allocator, .unlimited);

        field(hash, relative);
        field(hash, content);
        b.allocator.free(content);
    }
}

fn file(b: *std.Build, hash: *std.crypto.hash.sha2.Sha256, name: []const u8, path: []const u8) !void {
    const content = try std.Io.Dir.cwd().readFileAlloc(b.graph.io, path, b.allocator, .unlimited);

    defer b.allocator.free(content);
    field(hash, name);
    field(hash, content);
}

fn field(hash: *std.crypto.hash.sha2.Sha256, bytes: []const u8) void {
    var length: [8]u8 = undefined;

    std.mem.writeInt(u64, &length, @intCast(bytes.len), .little);
    hash.update(&length);
    hash.update(bytes);
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
