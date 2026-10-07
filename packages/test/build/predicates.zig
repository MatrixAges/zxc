const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-list-predicates", "Execute native every and some callbacks through source and compiled consumers");

    const analysis = b.addTest(.{ .name = "list-predicates-analysis", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "zx", .module = compiler.module("frontend").import_table.get("zx").? } },
    }) });

    const analysis_run = b.addRunArtifact(analysis);

    analysis_run.has_side_effects = true;

    step.dependOn(&analysis_run.step);

    const tool_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    tool_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-list-predicates", .root_module = tool_module });

    for ([_][]const u8{ "every", "some" }) |mode| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const compile = b.addRunArtifact(tool);

            compile.addFileArg(b.path(b.fmt("tests/collections/predicates/fixtures/{s}.zx", .{mode})));
            compile.addFileArg(b.path("tests/collections/predicates/fixtures/host.d.zx"));
            compile.addArg(route);

            const directory = compile.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ mode, route }));
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/collections/predicates/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(b.path("tests/collections/predicates/root.zig"));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/collections/predicates/host.zig"));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addArg(mode);

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
