const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-child-process", "Validate synchronous child process execution and cleanup");

    const child = b.addExecutable(.{ .name = "child-process-fixture", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/child_process/child.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    const options = b.addOptions();

    options.addOptionPath("child", child.getEmittedBin());

    for ([_][]const u8{ "results", "validation", "allocation" }) |name| {
        const module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/child_process/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
        });

        module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        module.addOptions("options", options);

        const tests = b.addTest(.{ .root_module = module });
        const run = b.addRunArtifact(tests);

        run.setEnvironmentVariable("ZXC_CHILD_TEST_VALUE", "inherited-test-value");
        step.dependOn(&run.step);
    }

    const compile = b.addRunArtifact(b.dependency("cli", .{ .target = target, .optimize = optimize }).artifact("zxc"));

    compile.addFileArg(b.path("tests/standard/resources/child_process/main.zx"));
    compile.addArg("--out");

    const source = compile.addOutputFileArg("program.zig");
    const abi = b.createModule(.{ .root_source_file = source.dirname().path(b, "program.zig.abi.zig"), .target = target, .optimize = optimize });

    const standard = b.createModule(.{
        .root_source_file = compiler.path("standard/src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const program = b.createModule(.{
        .root_source_file = source,
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
    });

    const module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/child_process/generated.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "standard", .module = standard } },
    });

    module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    module.addOptions("options", options);

    const tests = b.addTest(.{ .root_module = module });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
