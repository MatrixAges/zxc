const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-context-borrow", "Validate shared collection context through source and compiled consumers");

    const module = b.createModule(.{
        .root_source_file = b.path("tests/collections/predicates/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-context-borrow", .root_module = module });

    for ([_][]const u8{ "list", "object", "nested" }) |kind| {
        for ([_][]const u8{ "map", "filter", "every", "some" }) |method| {
            for ([_][]const u8{ "source", "library" }) |route| {
                const generate = b.addRunArtifact(tool);

                generate.addFileArg(b.path(b.fmt("tests/collections/context_borrow/fixtures/{s}/{s}.zx", .{ kind, method })));
                generate.addFileArg(b.path(b.fmt("tests/collections/context_borrow/fixtures/{s}/host.d.zx", .{kind})));
                generate.addArg(route);

                const directory = generate.addOutputDirectoryArg(b.fmt("{s}-{s}-{s}", .{ kind, method, route }));
                const run = b.addSystemCommand(&.{"node"});

                run.addFileArg(b.path("tests/collections/context_borrow/run_test.ts"));
                run.addArg(b.graph.zig_exe);
                run.addDirectoryArg(directory);
                run.addFileArg(b.path("tests/collections/context_borrow/root.zig"));
                run.addArg(@tagName(optimize));
                run.addFileArg(b.path("tests/collections/context_borrow/host.zig"));
                run.addFileArg(b.path("tests/collections/context_effects/oracle.zig"));
                run.addArg(method);
                run.addArg(kind);

                run.has_side_effects = true;

                step.dependOn(&run.step);
            }
        }
    }

    return step;
}
