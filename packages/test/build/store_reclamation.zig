const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const tool = b.addExecutable(.{
        .name = "compile-store-reclamation",
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

    const step = b.step("test-store-reclamation", "Validate independent Store region reclamation and conservative sharing");

    for ([_]struct { mode: []const u8, name: []const u8 }{
        .{ .mode = "memory", .name = "owned" },
        .{ .mode = "memory_borrowed", .name = "borrowed" },
        .{ .mode = "memory_pure_readonly", .name = "readonly" },
        .{ .mode = "memory_failure", .name = "failure" },
    }) |case| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(case.mode);

        const directory = generate.addOutputDirectoryArg("generated");
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path("tests/rx/runtime/store/memory/run_test.ts"));
        run.addFileInput(b.path("tests/support/allocation_testing.zig"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(directory);
        run.addFileArg(b.path(b.fmt("tests/rx/runtime/store/memory/reclamation/{s}.zig", .{case.name})));
        run.setEnvironmentVariable("ZXC_TEST_OPTIMIZE", @tagName(optimize));
        step.dependOn(&run.step);
    }

    return step;
}
