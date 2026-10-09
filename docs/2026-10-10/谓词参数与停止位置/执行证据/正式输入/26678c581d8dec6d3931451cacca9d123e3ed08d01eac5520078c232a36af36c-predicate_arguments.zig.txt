const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-predicate-arguments", "Execute predicate argument stopping positions through source and compiled consumers");
    const check = b.addSystemCommand(&.{"node"});

    check.addFileArg(b.path("src/generate_predicate_arguments.ts"));
    check.addArg("--check");
    for ([_][]const u8{ "src/models/predicate_arguments.ts", "src/data/predicate_arguments.jsonl", "src/shared/catalog.ts", "src/shared/json.ts", "src/predicate_arguments/inputs.ts", "src/predicate_arguments/cases.ts", "upstream/reviews/built_ins/array/predicate_arguments.jsonl" }) |path| check.addFileInput(b.path(path));

    check.has_side_effects = true;

    step.dependOn(&check.step);

    const module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-predicate-arguments", .root_module = module });

    for (suites) |suite| {
        if (suite.kind != .predicate_arguments) continue;

        const method = std.fs.path.basename(std.fs.path.dirname(suite.path).?);
        const name = b.fmt("{s}_{s}", .{ method, std.fs.path.basename(suite.path) });
        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_predicate_arguments.ts"));
        emit.addFileInput(b.path("src/models/predicate_arguments.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/shared/zig_literal.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
        emit.addFileArg(b.path("tests/collections/predicate_arguments/check.zig"));

        const tests = emit.addOutputFileArg("cases.zig");

        for ([_][]const u8{ "source", "library" }) |route| {
            const compile = b.addRunArtifact(tool);

            compile.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));
            compile.addFileArg(b.path("tests/collections/callback_arguments/fixtures/host.d.zx"));
            compile.addArg(route);

            const directory = compile.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ name, route }));
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/collections/callback_arguments/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(tests);
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/collections/predicate_arguments/host.zig"));
            run.addFileArg(b.path("tests/collections/context_effects/oracle.zig"));
            run.addArg(method);

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
