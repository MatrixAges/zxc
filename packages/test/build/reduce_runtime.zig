const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-reduce-runtime", "Execute owned reduce append and fallback paths with memory boundaries");

    for ([_][]const u8{ "push", "concat", "select", "nested", "condition", "argument", "first_value", "stack" }) |mode| {
        const compile = b.addRunArtifact(cli.artifact("zxc"));

        compile.addFileArg(b.path(b.fmt("tests/collections/reduce/fixtures/{s}.zx", .{mode})));
        compile.addArg("--out");

        const source = compile.addOutputFileArg("program.zig");
        const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });
        const options = b.addOptions();

        options.addOption([]const u8, "mode", mode);

        const module = b.createModule(.{
            .root_source_file = b.path("tests/collections/reduce/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        });

        module.addOptions("options", options);

        const tests = b.addTest(.{ .name = b.fmt("reduce-{s}", .{mode}), .root_module = module });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
