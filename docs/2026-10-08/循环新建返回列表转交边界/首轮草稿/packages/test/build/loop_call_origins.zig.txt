const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-loop-call-origins", "Validate fresh call origins shared aliases and native scalar loop effects");
    const directory = "tests/collections/loop_call_origins";

    const tool = b.addExecutable(.{ .name = "compile-loop-call-origins", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "fresh", "literal", "chain", "branch", "mixed", "borrowed", "shared", "impure" }) |mode| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const host = b.createModule(.{ .root_source_file = b.path(directory ++ "/host.zig"), .target = target, .optimize = optimize });

            program.addImport("origin_host", host);

            const tests = b.createModule(.{ .root_source_file = b.path(directory ++ "/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });
            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            tests.addOptions("options", options);
            tests.addImport("origin_host", host);
            tests.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

            const run = b.addRunArtifact(b.addTest(.{ .name = b.fmt("loop-call-origins-{s}-{s}", .{ mode, route }), .root_module = tests }));

            run.has_side_effects = true;

            step.dependOn(&run.step);

            if (!std.mem.eql(u8, mode, "mixed") and !std.mem.eql(u8, mode, "borrowed") and !std.mem.eql(u8, mode, "shared")) {
                const capacity = b.createModule(.{ .root_source_file = b.path(directory ++ "/capacity_test.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }, .{ .name = "origin_host", .module = host }} });

                capacity.addOptions("options", options);

                const run_capacity = b.addRunArtifact(b.addTest(.{ .name = b.fmt("loop-call-capacity-{s}-{s}", .{ mode, route }), .root_module = capacity }));
                run_capacity.has_side_effects = true;

                step.dependOn(&run_capacity.step);
            }
        }
    }

    return step;
}
