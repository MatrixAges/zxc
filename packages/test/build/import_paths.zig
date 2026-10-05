const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-zx-import-paths", "Validate extensionless ZX import identity boundaries and cycles");
    const module = compiler.module("compiler");

    for ([_][]const u8{ "resolve", "project" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/modules/import_paths/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = module },
                .{ .name = "zx", .module = module.import_table.get("zx").? },
            },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const cli_step = b.step("test-zx-import-paths-cli", "Validate extensionless ZX imports through actual file collection build and execution");
    const cli_tests = b.addSystemCommand(&.{"node"});

    cli_tests.addFileArg(b.path("tests/modules/import_paths/cli_test.ts"));
    cli_tests.addFileInput(b.path("tests/modules/import_paths/cli_cases.ts"));
    cli_tests.addArtifactArg(cli.artifact("zxc"));
    cli_tests.addArg(@tagName(optimize));
    cli_step.dependOn(&cli_tests.step);
    step.dependOn(cli_step);

    return step;
}
