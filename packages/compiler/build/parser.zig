const std = @import("std");

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode) std.Build.LazyPath {
    const target = b.graph.host;
    const core = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core");
    const dsl = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl");
    const lint = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint");

    const lexer = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = core }},
    });

    const seed = @import("compiler.zig").create(b, target, optimize, lexer, null);

    const rx = b.createModule(.{
        .root_source_file = b.path("src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "dsl", .module = dsl }, .{ .name = "frontend", .module = seed.frontend } },
    });

    const analysis = b.createModule(.{
        .root_source_file = b.path("src/rx/analysis/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = rx },
            .{ .name = "dsl", .module = dsl },
            .{ .name = "zx", .module = core },
            .{ .name = "frontend", .module = seed.frontend },
            .{ .name = "lint", .module = lint },
        },
    });

    const executable = b.addExecutable(.{ .name = "generate-parser", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = rx }, .{ .name = "rx_analysis", .module = analysis } },
    }) });

    const run = b.addRunArtifact(executable);
    const root = b.path("src/zx/frontend");

    run.addDirectoryArg2(root, .{});
    trackSources(b, run, root) catch @panic("unable to track RX and ZX parser sources");

    return run.addOutputFileArg("parser.zig");
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run, root: std.Build.LazyPath) !void {
    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, try b.root.joinString(b.allocator, "src/zx/frontend"), .{ .iterate = true });

    defer directory.close(b.graph.io);

    var walker = try directory.walk(b.allocator);

    defer walker.deinit();
    b.dependOnDirectoryContents(root);

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(root.path(b, entry.path));
        } else if (entry.kind == .file and (std.mem.endsWith(u8, entry.path, ".zx") or std.mem.endsWith(u8, entry.path, ".rx"))) {
            try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
        }
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    for (paths.items) |path| run.addFileInput(root.path(b, path));
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

pub fn module(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: std.Build.LazyPath) *std.Build.Module {
    return b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });
}
