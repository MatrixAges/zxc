const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-reduce-floating", "Execute strict floating folds through source and compiled consumers");
    const check = b.addSystemCommand(&.{"node"});

    check.addFileArg(b.path("src/generate_reduce_floating.ts"));
    check.addArg("--check");
    for ([_][]const u8{ "src/models/reduce_floating.ts", "src/reduce_floating/inputs.ts", "src/reduce_floating/node_reference.ts", "src/generate_division.ts", "src/models/add.ts", "src/models/subtract.ts", "src/models/multiply.ts", "src/models/ieee.ts", "src/models/rational.ts", "src/shared/catalog.ts", "src/shared/json.ts" }) |path| check.addFileInput(b.path(path));

    check.has_side_effects = true;

    step.dependOn(&check.step);

    const module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/field_facts/runtime/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-reduce-floating", .root_module = module });

    for (suites) |suite| {
        if (suite.kind != .floating_reduce) continue;

        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_reduce_floating.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
        emit.addFileArg(b.path("tests/collections/reduce_floating/check.zig"));

        const cases = emit.addOutputFileArg("cases.zig");

        for ([_][]const u8{ "source", "library" }) |route| {
            const compile = b.addRunArtifact(tool);

            compile.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));
            compile.addArg(route);

            const directory = compile.addOutputDirectoryArg("program");
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/collections/reduce_floating/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(cases);
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addFileInput(b.path("tests/ownership/field_facts/runtime/arguments.ts"));

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
