const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-aggregate-loop", "Validate aggregate loop snapshots ownership native consumers and fallbacks");

    const tool = b.addExecutable(.{ .name = "compile-aggregate-loop", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/aggregate_loop/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "stack", "nested", "two_lanes", "bounds", "old_list", "call", "escaping", "consumer" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const host = if (std.mem.eql(u8, mode, "consumer")) b.createModule(.{
                .root_source_file = b.path("tests/collections/aggregate_loop/consumer/choose.zig"),
                .target = target,
                .optimize = optimize,
            }) else null;

            if (host) |module| program.addImport("choose", module);

            const root = if (std.mem.eql(u8, mode, "consumer")) "consumer_test" else if (std.mem.eql(u8, mode, "nested")) "nested_test" else if (std.mem.eql(u8, mode, "escaping")) "escaping_test" else "root";

            const module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/collections/aggregate_loop/{s}.zig", .{root})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            });

            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            module.addOptions("options", options);
            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            if (host) |native| module.addImport("choose", native);

            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("aggregate-loop-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    return step;
}
