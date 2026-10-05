const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-http", "Validate bounded HTTP requests and response ownership");

    for ([_][]const u8{ "validation", "sending", "request", "allocations" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/http/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/runtime/http/run_test.ts"));
    run.addFileInput(b.path("tests/runtime/http/application.ts"));
    run.addFileInput(b.path("tests/runtime/http/server.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/runtime/http/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
