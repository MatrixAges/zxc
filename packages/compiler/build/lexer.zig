const std = @import("std");

pub fn generate(b: *std.Build, stage0: []const u8, executable: *std.Build.Step.Compile) std.Build.LazyPath {
    if (stage0.len != 0) {
        const run = b.addSystemCommand(&.{ stage0, "--lexer" });

        run.addFileInput(.{ .cwd_relative = stage0 });
        run.addDirectoryArg2(b.path("src/zx/frontend/lexer"), .{});
        run.addDirectoryArg2(b.path("../core/src"), .{});
        trackSources(b, run) catch @panic("unable to track ZX lexer sources");

        return run.addOutputFileArg("lexer.zig");
    }

    const run = b.addRunArtifact(executable);

    run.addArg("--lexer");
    run.addDirectoryArg2(b.path("src/zx/frontend/lexer"), .{});
    run.addDirectoryArg2(b.path("../core/src"), .{});
    trackSources(b, run) catch @panic("unable to track ZX lexer sources");

    return run.addOutputFileArg("lexer.zig");
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run) !void {
    run.addFileInput(b.path("../core/src/const.zx"));
    run.addFileInput(b.path("../core/src/ascii/const.zx"));

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

pub fn module(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: std.Build.LazyPath, strip: ?bool) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/frontend/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "generated", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .strip = strip }) },
        },
    });
}
