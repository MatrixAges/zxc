const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const tool = b.addExecutable(.{
        .name = "compile-store-alias-lifetime",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/store/dual/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    const step = b.step("test-store-alias-lifetime", "Validate retained Store references across request and slot replacement");
    const generate = b.addRunArtifact(tool);

    generate.addArg("memory");

    const directory = generate.addOutputDirectoryArg("generated");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/rx/runtime/store/memory/run_test.ts"));
    run.addFileInput(b.path("tests/support/allocation_testing.zig"));
    run.addArg(b.graph.zig_exe);
    run.addDirectoryArg(directory);
    run.addFileArg(b.path("tests/rx/runtime/store/memory/aliases/root.zig"));
    run.setEnvironmentVariable("ZXC_TEST_OPTIMIZE", @tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
