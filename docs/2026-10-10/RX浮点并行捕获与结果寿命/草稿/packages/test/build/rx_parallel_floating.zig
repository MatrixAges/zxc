const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-rx-parallel-floating", "Execute floating Parallel captures, results and allocation boundaries");
    const check = b.addSystemCommand(&.{"node"});

    check.addFileArg(b.path("src/generate_rx_parallel_floating.ts"));
    check.addFileInput(b.path("src/rx_parallel_floating/cases.ts"));
    for ([_][]const u8{ "src/generate_division.ts", "src/models/ieee.ts", "src/models/rational.ts", "src/shared/catalog.ts", "src/shared/json.ts" }) |path| check.addFileInput(b.path(path));

    check.addArg("--check");
    check.has_side_effects = true;

    step.dependOn(&check.step);

    const module = b.createModule(.{
        .root_source_file = b.path("tests/rx/runtime/floating_compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-rx-parallel-floating", .root_module = module });

    for (suites) |suite| {
        if (suite.kind != .rx_parallel_floating) continue;

        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_rx_parallel_floating.ts"));
        emit.addFileInput(b.path("src/rx_parallel_floating/cases.ts"));
        emit.addFileInput(b.path("src/generate_division.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));

        const cases = emit.addOutputFileArg("cases.zig");

        for ([_][]const u8{ "source", "forward", "reverse", "rx_forward", "rx_reverse", "zx_forward", "zx_reverse", "republish_forward", "republish_reverse" }) |route| {
            const compile = b.addRunArtifact(tool);

            compile.addFileArg(b.path(b.fmt("tests/{s}.rx", .{suite.path})));
            compile.addArg(route);

            const directory = compile.addOutputDirectoryArg("program");

            for (suite.sources) |source| compile.addFileArg(b.path(b.fmt("tests/{s}", .{source})));

            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/rx/runtime/parallel/floating/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(cases);
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addFileInput(b.path("tests/ownership/field_facts/runtime/arguments.ts"));
            run.addFileInput(b.path("tests/collections/context_borrow/arguments.ts"));
            for ([_][]const u8{ "pattern.zig", "storage.zig", "output.zig", "check.zig" }) |name| run.addFileInput(b.path(b.fmt("tests/rx/runtime/parallel/floating/{s}", .{name})));

            run.addFileInput(b.path("tests/rx/runtime/parallel/tracking.zig"));

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
