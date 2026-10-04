const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-library-runtime", "Execute unified public entries and nested dependency remapping");
    const generator = b.addExecutable(.{ .name = "generate-library-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/library/runtime/generate.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "forward", "reverse" }) |order| {
        const generate = b.addRunArtifact(generator);
        generate.addArg(order);
        const directory = generate.addOutputDirectoryArg(order);
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path("tests/library/runtime/run_test.ts"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(directory);
        run.addFileArg(b.path("tests/library/runtime/consume_test.zig"));
        step.dependOn(&run.step);
    }

    return step;
}
