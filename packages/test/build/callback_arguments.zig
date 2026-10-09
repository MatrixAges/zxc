const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-callback-arguments", "Validate callback parameters through source and compiled consumers");

    const module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-callback-arguments", .root_module = module });

    for ([_][]const u8{ "map", "filter", "every", "some" }) |method| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(tool);

            generate.addFileArg(b.path(b.fmt("tests/collections/callback_arguments/fixtures/{s}.zx", .{method})));
            generate.addFileArg(b.path("tests/collections/callback_arguments/fixtures/host.d.zx"));
            generate.addArg(route);

            const directory = generate.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ method, route }));
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/collections/callback_arguments/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(b.path("tests/collections/callback_arguments/root.zig"));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/collections/callback_arguments/host.zig"));
            run.addFileArg(b.path("tests/collections/context_effects/oracle.zig"));
            run.addArg(method);

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
