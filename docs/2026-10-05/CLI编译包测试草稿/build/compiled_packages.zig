const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-compiled-packages", "Execute CLI consumers of compiled package exports and reject invalid artifacts");
    const generator = b.addExecutable(.{ .name = "encode-package-fixture", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/library/runtime/generate.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
    }) });
    var artifacts: [2]std.Build.LazyPath = undefined;

    for ([_][]const u8{ "forward", "mixed_forward" }, &artifacts) |mode, *artifact| {
        const encode = b.addRunArtifact(generator);
        encode.addArg(b.fmt("archive_{s}", .{mode}));
        artifact.* = encode.addOutputFileArg(b.fmt("{s}.zxcir", .{mode}));
    }

    for ([_][]const u8{ "runtime", "rejection" }) |name| {
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path(b.fmt("tests/compiled_packages/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/compiled_packages/fixture.ts"));
        for ([_][]const u8{ "composed", "types", "branch" }) |fixture| run.addFileInput(b.path(b.fmt("tests/compiled_packages/fixtures/{s}.zx", .{fixture})));
        run.addArtifactArg(cli.artifact("zxc"));
        for (artifacts) |artifact| run.addFileArg(artifact);
        step.dependOn(&run.step);
    }

    return step;
}
