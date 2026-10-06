const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-references-runtime", "Execute real native references through source and compiled library routes");
    const directory = "tests/native/references/runtime";

    const generator = b.addExecutable(.{ .name = "generate-native-reference-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/generate.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    generator.root_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "identity", "read", "optional", "coalesce", "containers", "order" }) |name| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(generator);

            generate.addFileArg(b.path(b.fmt("{s}/{s}/main.zx", .{ directory, name })));
            generate.addFileArg(b.path(directory ++ "/host.d.zx"));
            generate.addArg(route);

            const output = generate.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ name, route }));
            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path(directory ++ "/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(output);
            run.addFileArg(b.path(b.fmt("{s}/{s}/execution_test.zig", .{ directory, name })));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path(directory ++ "/host.zig"));
            run.addFileArg(b.path(directory ++ "/support.zig"));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            step.dependOn(&run.step);
        }
    }

    return step;
}
