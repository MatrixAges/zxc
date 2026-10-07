const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-borrowed-runtime", "Execute borrowed native payloads through source and consumed compiled libraries");
    const directory = "tests/native/borrowed_runtime";

    const generator = b.addExecutable(.{ .name = "compile-native-borrowed-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    generator.root_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "string", "list", "nested", "optional" }) |mode| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(generator);

            generate.addFileArg(b.path(directory ++ "/fixtures/main.zx"));
            generate.addFileArg(b.path(b.fmt("{s}/payloads/{s}/host.d.zx", .{ directory, mode })));
            generate.addArg(route);

            const output = generate.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ mode, route }));

            for ([_][]const u8{ "model", "read", "step" }) |name| generate.addFileArg(b.path(b.fmt("{s}/fixtures/{s}.zx", .{ directory, name })));

            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path(directory ++ "/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(output);
            run.addFileArg(b.path(directory ++ "/root.zig"));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path(b.fmt("{s}/payloads/{s}/host.zig", .{ directory, mode })));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addArg(mode);
            run.addFileInput(b.path(directory ++ "/fixture.zig"));
            run.addFileInput(b.path(directory ++ "/execution.zig"));
            run.addFileInput(b.path(directory ++ "/host.zig"));

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
