const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-iterate-calls", "Validate aggregate aliases and ABI views through source and archived iteration programs");

    const analysis = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/iterate_calls/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    analysis.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(analysis).step);

    const tool = b.addExecutable(.{ .name = "compile-iterate-calls", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/iterate_calls/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "identity", "child", "pair", "branch_return", "tuple_identity", "list_alias" }) |mode| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            options.addOption(bool, "bounded", !std.mem.eql(u8, mode, "pair") and !std.mem.eql(u8, mode, "list_alias"));

            const module = b.createModule(.{ .root_source_file = b.path("tests/collections/iterate_calls/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });

            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            module.addOptions("options", options);
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("iterate-calls-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    const cli_step = b.step("test-iterate-calls-cli", "Publish relocate and republish iteration libraries without original sources");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/collections/iterate_calls/cli_test.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(@tagName(optimize));
    run.addDirectoryArg(b.path("tests/collections/iterate_calls/fixtures"));
    run.addFileInput(b.path("tests/collections/iterate_calls/cli_fixture.ts"));
    run.addFileInput(b.path("tests/collections/iterate_calls/cli_cases.ts"));
    cli_step.dependOn(&run.step);
    step.dependOn(cli_step);

    return step;
}
