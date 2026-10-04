const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-link-runtime", "Execute original and independently relinked module artifacts");
    const plain = b.createModule(.{
        .root_source_file = b.path("tests/incremental/module_records/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });
    const slots = b.createModule(.{
        .root_source_file = b.path("tests/incremental/artifact_slots/check.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });
    const tool = b.addExecutable(.{
        .name = "compile-link-runtime",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/incremental/link_runtime/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "plain_fixture", .module = plain }, .{ .name = "slots_fixture", .module = slots } },
        }),
    });

    for ([_][]const u8{ "plain", "slots" }) |name| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(name);

        const original = compile.addOutputFileArg("original.zig");
        const linked = compile.addOutputFileArg("linked.zig");
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/link_runtime/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "original", .module = b.createModule(.{ .root_source_file = original, .target = target, .optimize = optimize }) },
                    .{ .name = "linked", .module = b.createModule(.{ .root_source_file = linked, .target = target, .optimize = optimize }) },
                },
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
