const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-iterate", "Validate iterate preconditions postconditions snapshots list updates and resources");

    const analysis = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/iterate/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    analysis.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(analysis).step);

    for ([_][]const u8{ "next", "do", "snapshot", "list" }) |mode| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));

        generate.addFileArg(b.path(b.fmt("tests/collections/iterate/fixtures/{s}.zx", .{mode})));
        generate.addArg("--out");

        const source = generate.addOutputFileArg("program.zig");
        const options = b.addOptions();

        options.addOption([]const u8, "mode", mode);

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/collections/iterate/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }) }},
        }) });

        tests.root_module.addOptions("options", options);
        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const cli_step = b.step("test-iterate-cli", "Validate iterate condition order indexed effects RX values and name shadowing");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/collections/iterate/cli_test.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(@tagName(optimize));
    cli_step.dependOn(&run.step);
    step.dependOn(cli_step);

    return step;
}
