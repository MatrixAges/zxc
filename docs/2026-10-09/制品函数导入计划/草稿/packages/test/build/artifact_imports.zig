const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-artifact-import-runtime", "Execute relinked artifact aliases through source and independent library consumers");

    const tool = b.addExecutable(.{ .name = "compile-artifact-imports", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/incremental/artifact/imports/compile.zig"),
        .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for (0..6) |ordering| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(tool);

            generate.addArg(b.fmt("{d}", .{ordering}));
            generate.addArg(route);

            const source = generate.addOutputFileArg(b.fmt("{d}-{s}.zig", .{ ordering, route }));
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

            const tests = b.addTest(.{ .root_module = b.createModule(.{
                .root_source_file = b.path("tests/incremental/artifact/imports/runtime_test.zig"),
                .target = target, .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }) });

            tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            step.dependOn(&b.addRunArtifact(tests).step);
        }
    }

    return step;
}
