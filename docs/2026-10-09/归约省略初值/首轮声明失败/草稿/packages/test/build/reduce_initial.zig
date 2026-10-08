const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-reduce-initial", "Validate reduce initialization through source and compiled consumers");

    const module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-reduce-initial", .root_module = module });

    for ([_][]const u8{ "numeric", "text" }) |kind| {
        for ([_][]const u8{ "unseeded", "seeded" }) |initial| {
            for ([_][]const u8{ "source", "library" }) |route| {
                const generate = b.addRunArtifact(tool);

                generate.addFileArg(b.path(b.fmt("tests/collections/reduce_initial/fixtures/{s}/{s}.zx", .{ kind, initial })));
                generate.addFileArg(b.path(b.fmt("tests/collections/reduce_initial/fixtures/{s}/host.d.zx", .{kind})));
                generate.addArg(route);

                const directory = generate.addOutputDirectoryArg(b.fmt("{s}-{s}-{s}", .{ kind, initial, route }));
                const run = b.addSystemCommand(&.{"node"});

                run.addFileArg(b.path("tests/collections/reduce_initial/run_test.ts"));
                run.addArg(b.graph.zig_exe);
                run.addDirectoryArg(directory);
                run.addFileArg(b.path("tests/collections/reduce_initial/root.zig"));
                run.addArg(@tagName(optimize));
                run.addFileArg(b.path("tests/collections/reduce_initial/host.zig"));
                run.addFileArg(b.path("tests/collections/context_effects/oracle.zig"));
                run.addArg(kind);
                run.addArg(initial);

                run.has_side_effects = true;

                step.dependOn(&run.step);
            }
        }
    }

    return step;
}
