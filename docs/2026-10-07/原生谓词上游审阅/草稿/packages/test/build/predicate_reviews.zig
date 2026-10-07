const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-predicate-reviews", "Execute upstream predicate assertions through source and compiled consumers");

    const tool_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    tool_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-predicate-reviews", .root_module = tool_module });

    for (suites) |suite| {
        if (suite.kind != .predicate_trace) continue;

        const mode = std.fs.path.basename(suite.path);
        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_predicate_tests.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/shared/zig_literal.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
        emit.addFileArg(b.path("tests/collections/predicate_reviews/check.zig"));

        const tests = emit.addOutputFileArg("cases.zig");

        for ([_][]const u8{ "source", "library" }) |route| {
            const compile = b.addRunArtifact(tool);

            compile.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));
            compile.addFileArg(b.path("tests/collections/predicates/fixtures/host.d.zx"));
            compile.addArg(route);

            const directory = compile.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ mode, route }));
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/collections/predicates/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(tests);
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/collections/predicate_reviews/host.zig"));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addArg(mode);

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
