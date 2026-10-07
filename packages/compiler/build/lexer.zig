const std = @import("std");

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode) std.Build.LazyPath {
    const target = b.graph.host;

    const seed = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
    });

    const lint = b.dependency("lint", .{ .target = target, .optimize = optimize, .seed = true }).module("lint");
    const compiler = @import("compiler.zig").create(b, target, optimize, seed, null, lint);
    const flow = @import("seed_rx.zig").create(b, target, optimize, compiler.frontend, lint);

    const executable = b.addExecutable(.{ .name = "generate-lexer", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_lexer.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = compiler.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
    }) });

    const run = b.addRunArtifact(executable);

    run.addDirectoryArg2(b.path("src/zx/frontend/lexer"), .{});
    trackSources(b, run) catch @panic("unable to track ZX lexer sources");

    return run.addOutputFileArg("lexer.zig");
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run) !void {
    const root = b.path("src/zx/frontend/lexer");
    const absolute = try b.root.joinString(b.allocator, "src/zx/frontend/lexer");
    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, absolute, .{ .iterate = true });

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
    return b.createModule(.{
        .root_source_file = b.path("src/zx/frontend/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "generated", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }) },
        },
    });
}
