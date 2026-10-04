const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-configuration-formatting", "Validate manifest index and lock formatting and read-only lint boundaries");

    for ([_][]const u8{ "manifest", "index", "lock" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/formatting/configuration/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/formatting/configuration/fixture.ts"));
        run.addArtifactArg(cli.artifact("zxc"));

        if (std.mem.eql(u8, name, "lock")) {
            run.addFileInput(b.path("tests/package_install/fixture.ts"));
            run.addFileInput(b.path("tests/package_install/registry.ts"));
            run.addFileInput(b.path("src/shared/tar.ts"));
        } else {
            run.addFileInput(b.path(b.fmt("tests/formatting/configuration/{s}_cases.ts", .{name})));
            if (std.mem.eql(u8, name, "manifest")) run.addFileInput(b.path("tests/package_manifest/inspect_cases.ts"));
        }

        step.dependOn(&run.step);
    }

    const lint = compiler.builder.dependency("lint", .{ .target = target, .optimize = optimize });
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/formatting/configuration/json_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "lint", .module = lint.module("lint") }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
