const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-child-input", "Validate concurrent child process stdin and cleanup");

    const child = b.addExecutable(.{ .name = "child-input-fixture", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/child_input/child.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    const options = b.addOptions();

    options.addOptionPath("child", child.getEmittedBin());

    for ([_][]const u8{ "results", "limits", "allocation", "validation", "concurrency" }) |name| {
        const module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/child_input/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
        });

        module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        module.addOptions("options", options);

        const tests = b.addTest(.{ .root_module = module });
        const run = b.addRunArtifact(tests);

        run.setEnvironmentVariable("ZXC_CHILD_INPUT_VALUE", "inherited-test-value");
        step.dependOn(&run.step);
    }

    const tool = b.addExecutable(.{ .name = "compile-child-input", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/child_input/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    const compile = b.addRunArtifact(tool);

    for ([_][]const u8{ "source", "library" }) |route| {
        const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
        const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

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
            .root_source_file = b.path("tests/standard/resources/child_input/generated.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "standard", .module = standard } },
        });

        module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        module.addOptions("options", options);
        step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = module })).step);
    }

    return step;
}
