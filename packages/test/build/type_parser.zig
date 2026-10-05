const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-type-parser-resources", "Validate generated ZX type parser allocation failure cleanup and result lifetime");
    const generate = b.addRunArtifact(cli.artifact("zxc"));

    generate.addFileArg(b.path("tests/bootstrap/type_parser/source.zx"));
    generate.addArg("--out");

    const source = generate.addOutputFileArg("type_parser.zig");

    generate.addArg("--no-cache");

    for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/types" }) |path| {
        trackSources(b, generate, compiler, path) catch @panic("unable to track type parser sources");
    }

    const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/bootstrap/type_parser/resources_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "program", .module = program }},
    }) });

    tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run, compiler: *std.Build.Dependency, path: []const u8) !void {
    const root = compiler.path(path);
    const absolute = try compiler.builder.root.joinString(b.allocator, path);
    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, absolute, .{ .iterate = true });

    defer directory.close(b.graph.io);

    var walker = try directory.walk(b.allocator);

    defer walker.deinit();
    b.dependOnDirectoryContents(root);

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(root.path(b, entry.path));
        } else if (entry.kind == .file and std.mem.endsWith(u8, entry.path, ".zx")) {
            try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
        }
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    for (paths.items) |item| run.addFileInput(root.path(b, item));
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
