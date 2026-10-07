const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-function-updates", "Execute function element updates loops stale captures and duplicate aliases");

    const tool = b.addExecutable(.{ .name = "compile-function-updates", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/function_updates/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "flat", "branch", "chain", "captured", "duplicate", "fallback", "mixed" }) |mode| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const module = b.createModule(.{
                .root_source_file = b.path("tests/collections/function_updates/root.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            });

            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            module.addOptions("options", options);
            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

            const run = b.addRunArtifact(b.addTest(.{ .name = b.fmt("function-updates-{s}-{s}", .{ mode, route }), .root_module = module }));
            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
