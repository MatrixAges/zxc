const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-zx-import-order", "Validate fixed ZX import groups stable declarations comments and resource ownership");
    const library_step = b.step("test-zx-import-order-library", "Validate ZX import order through format lint and compiler APIs");
    const module = compiler.module("compiler");

    for ([_][]const u8{ "groups", "comments", "resources" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/formatting/zx/imports/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = module },
                .{ .name = "lint", .module = module.import_table.get("lint").? },
            },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        library_step.dependOn(&b.addRunArtifact(tests).step);
    }

    const cli_step = b.step("test-zx-import-order-cli", "Validate ZX import order lint fmt modes and static runtime behavior");

    for ([_][]const u8{ "cli", "runtime" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/formatting/zx/imports/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/formatting/zx/imports/cli_fixture.ts"));
        if (std.mem.eql(u8, name, "cli")) run.addFileInput(b.path("tests/formatting/zx/imports/cli_cases.ts"));

        run.addArtifactArg(cli.artifact("zxc"));
        run.addArg(@tagName(optimize));
        cli_step.dependOn(&run.step);
    }

    step.dependOn(cli_step);
    step.dependOn(library_step);

    return step;
}
