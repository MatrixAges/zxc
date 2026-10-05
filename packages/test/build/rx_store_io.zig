const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-store-io", "Execute generated Store Request IO and commit lifetime boundaries");

    const tool = b.addExecutable(.{
        .name = "compile-rx-store-io",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/store/io_compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    for ([_][]const u8{ "write", "service", "readonly" }) |mode| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        const directory = generate.addOutputDirectoryArg("generated");
        const tests: []const []const u8 = if (std.mem.eql(u8, mode, "readonly")) &.{"readonly"} else &.{ "continuity", "failure", "allocation" };

        for (tests) |name| {
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/rx/runtime/store/memory/run_test.ts"));
            run.addFileInput(b.path("tests/support/allocation_testing.zig"));
            run.addArg(b.graph.zig_exe);
            run.setEnvironmentVariable("ZXC_TEST_OPTIMIZE", @tagName(optimize));
            run.addDirectoryArg(directory);
            run.addFileArg(b.path(b.fmt("tests/rx/runtime/store/io/{s}_test.zig", .{name})));
            run.addFileArg(compiler.path("standard/src/root.zig"));
            run.addFileArg(b.path("tests/standard/resources/fs/fixture.zig"));
            step.dependOn(&run.step);
        }
    }

    return step;
}
