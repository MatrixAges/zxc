const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-for-each", "Validate sequential forEach callbacks void statements ownership and allocation behavior");

    const analysis = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/for_each/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    analysis.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(analysis).step);

    for ([_][]const u8{ "scalar", "rows", "allocated", "owned" }) |mode| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));

        generate.addFileArg(b.path(b.fmt("tests/collections/for_each/fixtures/{s}.zx", .{mode})));
        generate.addArg("--out");

        const source = generate.addOutputFileArg("program.zig");
        const options = b.addOptions();

        options.addOption([]const u8, "mode", mode);

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/collections/for_each/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }) }},
        }) });

        tests.root_module.addOptions("options", options);
        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    step.dependOn(&b.top_level_steps.get("test-for-each-catalog").?.step);

    const cli_step = b.step("test-for-each-cli", "Validate forEach ordered effects receiver evaluation and RX execution");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/collections/for_each/cli_test.ts"));
    run.addFileInput(b.path("tests/collections/for_each/cli_cases.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(@tagName(optimize));
    cli_step.dependOn(&run.step);
    step.dependOn(cli_step);

    return step;
}
