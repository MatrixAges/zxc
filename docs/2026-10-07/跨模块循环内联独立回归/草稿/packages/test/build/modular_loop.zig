const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-modular-loop", "Validate modular aggregate loop calls branches ownership and effects");

    const tool = b.addExecutable(.{ .name = "compile-modular-loop", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/modular_loop/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const host = b.createModule(.{
                .root_source_file = b.path("tests/collections/modular_loop/probe.zig"),
                .target = target,
                .optimize = optimize,
            });

            if (std.mem.eql(u8, mode, "effects")) program.addImport("probe", host);

            const root = if (std.mem.eql(u8, mode, "effects")) "effects_test" else if (std.mem.eql(u8, mode, "bounds")) "bounds_test" else "root";

            const module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/collections/modular_loop/{s}.zig", .{root})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            });

            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            module.addOptions("options", options);
            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            module.addImport("probe", host);
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("modular-loop-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    const generation = b.createModule(.{
        .root_source_file = b.path("tests/collections/modular_loop/generation_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    generation.addAnonymousImport("module_compare", .{
        .root_source_file = b.path("tests/incremental/module_generation/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    generation.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = "modular-loop-generation", .root_module = generation })).step);

    return step;
}
