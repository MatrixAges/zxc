const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-detached-reader", "Validate detached product readers across list growth and retained calls");
    const views_step = b.step("test-borrowed-call-views", "Execute borrowed prefix and offset views returned by ordinary module calls");

    const tool = b.addExecutable(.{ .name = "compile-detached-reader", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/detached_reader/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse", "prefix", "offset" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const module = b.createModule(.{
                .root_source_file = b.path(if (std.mem.eql(u8, mode, "prefix") or std.mem.eql(u8, mode, "offset")) "tests/collections/detached_reader/views_test.zig" else "tests/collections/detached_reader/root.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            });

            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            module.addOptions("options", options);
            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

            const run = b.addRunArtifact(b.addTest(.{ .name = b.fmt("detached-reader-{s}-{s}", .{ mode, route }), .root_module = module }));
            run.has_side_effects = true;

            step.dependOn(&run.step);

            if (std.mem.eql(u8, mode, "prefix") or std.mem.eql(u8, mode, "offset")) views_step.dependOn(&run.step);
        }
    }

    return step;
}
