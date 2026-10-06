const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-loop-columns", "Validate selected loop column transfer ownership projections and errors");

    const tool = b.addExecutable(.{ .name = "compile-loop-columns", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/loop_columns/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "mixed", "direct", "borrowed", "shrink", "nested", "dual", "leaves", "consumer", "fallback" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const host = if (std.mem.eql(u8, mode, "consumer")) b.createModule(.{
                .root_source_file = b.path("tests/collections/loop_columns/consumer/choose.zig"),
                .target = target,
                .optimize = optimize,
            }) else null;

            if (host) |module| program.addImport("choose", module);

            const root = if (std.mem.eql(u8, mode, "consumer")) "consumer_test" else if (std.mem.eql(u8, mode, "dual")) "dual_test" else if (std.mem.eql(u8, mode, "leaves")) "leaves_test" else "root";

            const module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/collections/loop_columns/{s}.zig", .{root})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            });

            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            module.addOptions("options", options);
            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            if (host) |native| module.addImport("choose", native);

            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("loop-columns-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    return step;
}
