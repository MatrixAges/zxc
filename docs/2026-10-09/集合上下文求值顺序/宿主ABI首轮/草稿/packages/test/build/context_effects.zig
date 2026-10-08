const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-context-effects", "Validate explicit collection context evaluation order and failures");

    const tool = b.addExecutable(.{ .name = "compile-context-effects", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/context_effects/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    const host = b.createModule(.{ .root_source_file = b.path("tests/collections/context_effects/host.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "map", "filter", "every", "some" }) |method| {
        for ([_]bool{ true, false }) |used| {
            const generate = b.addRunArtifact(tool);

            generate.addFileArg(b.path(b.fmt("tests/collections/context_effects/fixtures/{s}_{s}.zx", .{ method, if (used) "used" else "ignored" })));
            generate.addArg(method);

            const source = generate.addOutputFileArg("program.zig");
            const types = generate.addOutputFileArg("types.zig");
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "host", .module = host } } });
            const options = b.addOptions();

            options.addOption([]const u8, "method", method);
            options.addOption(bool, "used", used);

            const module = b.createModule(.{ .root_source_file = b.path("tests/collections/context_effects/root.zig"), .target = target, .optimize = optimize, .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } } });

            module.addOptions("options", options);

            const tests = b.addTest(.{ .root_module = module });

            step.dependOn(&b.addRunArtifact(tests).step);
        }
    }

    return step;
}
