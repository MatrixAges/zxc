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

    try directory(b, &hash, "cli", try b.root.joinString(b.allocator, "src"));
    try directory(b, &hash, "cli-build", try b.root.joinString(b.allocator, "build"));
    try file(b, &hash, "cli/build.zig", try b.root.joinString(b.allocator, "build.zig"));
    try file(b, &hash, "cli/build.zig.zon", try b.root.joinString(b.allocator, "build.zig.zon"));
    try file(b, &hash, "standard/modules.json", try b.dependency("compiler", .{ .target = target, .optimize = optimize }).builder.root.joinString(b.allocator, "standard/modules.json"));
    try directory(b, &hash, "standard/interfaces", try b.dependency("compiler", .{ .target = target, .optimize = optimize }).builder.root.joinString(b.allocator, "standard/interfaces"));

    for ([_][]const u8{ "compiler", "core", "dsl", "lint", "genz", "pkgs", "napi" }) |name| {
        const dependency = if (std.mem.eql(u8, name, "lint"))
            b.dependency("lint", .{ .target = target, .optimize = optimize, .generated_name = b.dependency("compiler", .{ .target = target, .optimize = optimize }).namedLazyPath("naming") })

        else
            b.dependency(name, .{ .target = target, .optimize = optimize });

        try directory(b, &hash, name, try dependency.builder.root.joinString(b.allocator, "src"));
        try file(b, &hash, b.fmt("{s}/build.zig", .{name}), try dependency.builder.root.joinString(b.allocator, "build.zig"));
        try file(b, &hash, b.fmt("{s}/build.zig.zon", .{name}), try dependency.builder.root.joinString(b.allocator, "build.zig.zon"));
        if (std.mem.eql(u8, name, "lint")) try directory(b, &hash, "lint-bootstrap", try dependency.builder.root.joinString(b.allocator, "bootstrap"));

        if (std.mem.eql(u8, name, "compiler")) {
            try directory(b, &hash, "compiler-build", try dependency.builder.root.joinString(b.allocator, "build"));
            try directory(b, &hash, "compiler-bootstrap", try dependency.builder.root.joinString(b.allocator, "bootstrap"));
        }
    }

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    const options = b.addOptions();

    options.addOption([32]u8, "digest", digest);

    return options;
}

fn directory(b: *std.Build, hash: *std.crypto.hash.sha2.Sha256, name: []const u8, path: []const u8) !void {
    b.dependOnDirectoryContents(.{ .cwd_relative = path });

    var dir = try std.Io.Dir.cwd().openDir(b.graph.io, path, .{ .iterate = true });

    defer dir.close(b.graph.io);

    var walker = try dir.walk(b.allocator);

    defer walker.deinit();

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(.{ .cwd_relative = try std.fs.path.join(b.allocator, &.{ path, entry.path }) });

            continue;
        }

        if (entry.kind != .file) return error.UnsupportedSourceFile;
        try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);
    field(hash, name);

    var count: [8]u8 = undefined;

    std.mem.writeInt(u64, &count, @intCast(paths.items.len), .little);
    field(hash, &count);

    for (paths.items) |relative| {
        b.dependOnFileContents(.{ .cwd_relative = try std.fs.path.join(b.allocator, &.{ path, relative }) });

        const content = try dir.readFileAlloc(b.graph.io, relative, b.allocator, .unlimited);

        field(hash, relative);
        field(hash, content);
        b.allocator.free(content);
    }
}

fn file(b: *std.Build, hash: *std.crypto.hash.sha2.Sha256, name: []const u8, path: []const u8) !void {
    b.dependOnFileContents(.{ .cwd_relative = path });

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
