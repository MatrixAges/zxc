const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-library-runtime", "Execute unified public entries and nested dependency remapping");
    const generator = b.addExecutable(.{ .name = "generate-library-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/library/runtime/generate.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
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

    const mixed_step = b.step("test-library-mixed", "Execute linked RX orchestration and public ZX logic");

    for ([_][]const u8{ "mixed_forward", "mixed_reverse" }) |order| {
        const generate = b.addRunArtifact(generator);
        generate.addArg(order);
        const directory = generate.addOutputDirectoryArg(order);
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path("tests/library/runtime/run_test.ts"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(directory);
        run.addFileArg(b.path("tests/library/runtime/mixed_test.zig"));
        mixed_step.dependOn(&run.step);
    }

    step.dependOn(mixed_step);
    step.dependOn(@import("library_replay.zig").add(b, compiler, generator, target, optimize));
    step.dependOn(@import("library_bundle.zig").add(b, compiler, generator, target, optimize));

    return step;
}
