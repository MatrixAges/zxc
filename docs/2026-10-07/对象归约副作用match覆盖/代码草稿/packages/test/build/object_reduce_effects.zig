const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-object-reduce-effects", "Execute match subject effects lazy patterns errors and bounded reductions");
    const directory = "tests/collections/object_reduce/effects";

    const tool = b.addExecutable(.{ .name = "compile-object-reduce-effects", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    tool.root_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "source", "library" }) |route| {
        const generate = b.addRunArtifact(tool);

        generate.addFileArg(b.path(directory ++ "/main.zx"));
        generate.addFileArg(b.path(directory ++ "/host.d.zx"));
        generate.addArg(route);

        const output = generate.addOutputDirectoryArg(route);
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(directory ++ "/run_test.ts"));
        run.addArg(b.graph.zig_exe);
        run.addDirectoryArg(output);
        run.addFileArg(b.path(directory ++ "/root.zig"));
        run.addArg(@tagName(optimize));
        run.addFileArg(b.path(directory ++ "/host.zig"));
        run.addFileArg(b.path("tests/support/allocation_testing.zig"));

        _ = run.addOutputFileArg(b.fmt("object-reduce-effects-{s}", .{route}));

        for ([_][]const u8{ "check.zig", "expected.zig", "failure.zig" }) |name| run.addFileInput(b.path(b.fmt("{s}/{s}", .{ directory, name })));

        run.has_side_effects = true;

        step.dependOn(&run.step);
    }

    return step;
}
