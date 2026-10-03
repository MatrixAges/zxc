const std = @import("std");

pub fn add(b: *std.Build, rx: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const []const u8) *std.Build.Step {
    const step = b.step("test-module-graphs", "Validate synthetic RX module graphs");
    const generate = b.addSystemCommand(&.{"node"});

    generate.addFileArg(b.path("src/emit_module_graph_tests.ts"));
    generate.addFileInput(b.path("src/zig_string.ts"));
    generate.addFileInput(b.path("src/shared/json.ts"));

    for (suites) |suite| generate.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite})));

    const source = generate.addOutputFileArg("module_graphs.zig");

    const support = b.createModule(.{
        .root_source_file = b.path("tests/support/module_graphs/check.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "rx", .module = rx.module("rx") }},
    });

    const tests = b.addTest(.{
        .name = "conformance-module-graphs",
        .root_module = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "support", .module = support }},
        }),
    });

    const run = b.addRunArtifact(tests);

    step.dependOn(&run.step);

    return step;
}
