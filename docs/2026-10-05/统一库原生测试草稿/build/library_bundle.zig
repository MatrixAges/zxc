const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, generator: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-library-bundle", "Execute unified Zig library bundles with public file tables");
    const tool = b.addExecutable(.{ .name = "replay-library-bundle", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/library/runtime/replay_bundle.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "forward", "reverse", "mixed_forward", "mixed_reverse", "native_forward", "native_reverse" }) |order| {
        const generate = b.addRunArtifact(generator);
        generate.addArg(b.fmt("archive_{s}", .{order}));
        const artifact = generate.addOutputFileArg(b.fmt("{s}.zxlib", .{order}));
        const replay = b.addRunArtifact(tool);
        replay.addFileArg(artifact);
        const directory = replay.addOutputDirectoryArg(b.fmt("bundle_{s}", .{order}));
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path("tests/library/runtime/run_test.ts"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(directory);
        run.addFileArg(b.path(b.fmt("tests/library/runtime/{s}_test.zig", .{if (std.mem.startsWith(u8, order, "native")) "native" else if (std.mem.startsWith(u8, order, "mixed")) "mixed" else "consume"})));
        if (std.mem.startsWith(u8, order, "native")) run.addFileArg(b.path("tests/library/runtime/native/choice.zig"));
        step.dependOn(&run.step);
    }

    return step;
}
