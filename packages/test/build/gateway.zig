const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-gateway", "Validate Gateway routes HTTP boundaries and shared application state");

    for ([_][]const u8{ "routes", "validation", "allocations" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/rx/inference/gateway/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "rx", .module = compiler.module("rx") }, .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") } },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/runtime/gateway/run_test.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/application.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/request.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/types.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/routing.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/state.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/body.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/runtime/gateway/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
