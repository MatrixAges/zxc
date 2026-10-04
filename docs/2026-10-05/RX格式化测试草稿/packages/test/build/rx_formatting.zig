const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-formatting", "Validate RX formatting CLI modes content preservation runtime equivalence and allocation cleanup");

    for ([_][]const u8{ "cli", "runtime" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/formatting/rx/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/formatting/rx/fixture.ts"));
        run.addFileInput(b.path("tests/formatting/rx/cases.ts"));
        run.addArtifactArg(cli.artifact("zxc"));
        step.dependOn(&run.step);
    }

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/formatting/rx/allocation_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
