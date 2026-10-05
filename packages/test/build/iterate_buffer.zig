const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-iterate-buffer", "Validate iterate list reuse snapshots static paths and allocation costs");

    for ([_][]const u8{ "flat", "branch", "switch", "direct", "nested", "tuple", "stale_local", "stale_branch", "stale_switch", "stale_state", "two_fields" }) |mode| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));

        generate.addFileArg(b.path(b.fmt("tests/collections/iterate_buffer/fixtures/{s}.zx", .{mode})));
        generate.addArg("--out");

        const source = generate.addOutputFileArg("program.zig");
        const options = b.addOptions();

        options.addOption([]const u8, "mode", mode);

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/collections/iterate_buffer/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }) }},
        }) });

        tests.root_module.addOptions("options", options);
        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
