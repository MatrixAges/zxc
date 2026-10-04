const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, generator: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-library-import", "Execute ZX imports from compiled public library modules");
    const tool = b.addExecutable(.{ .name = "import-library-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/library/runtime/replay_import.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "forward", "reverse", "mixed_forward", "mixed_reverse" }) |order| {
        const generate = b.addRunArtifact(generator);
        generate.addArg(b.fmt("archive_{s}", .{order}));
        const artifact = generate.addOutputFileArg(b.fmt("{s}.zxlib", .{order}));
        const replay = b.addRunArtifact(tool);
        replay.addFileArg(artifact);
        const directory = replay.addOutputDirectoryArg(b.fmt("imported_{s}", .{order}));
        replay.addArg(order);
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path("tests/library/runtime/run_test.ts"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(directory);
        run.addFileArg(b.path(b.fmt("tests/library/runtime/{s}_test.zig", .{if (std.mem.startsWith(u8, order, "mixed")) "mixed" else "consume"})));
        step.dependOn(&run.step);
    }

    return step;
}
