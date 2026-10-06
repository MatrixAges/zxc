const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-references-runtime", "Execute real native references through source and compiled library routes");
    const transfers = b.step("test-native-references-transfers", "Execute native reference capacity transfers through ordinary ZX helpers");
    const directory = "tests/native/references/runtime";

    const generator = b.addExecutable(.{ .name = "generate-native-reference-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/generate.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    generator.root_module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const cases = [_]struct { name: []const u8, files: []const []const u8 = &.{} }{
        .{ .name = "identity" },
        .{ .name = "read" },
        .{ .name = "optional" },
        .{ .name = "coalesce" },
        .{ .name = "containers" },
        .{ .name = "order" },
        .{ .name = "traversal" },
        .{ .name = "borrowed" },
        .{ .name = "loop_write" },
        .{ .name = "loop_history" },
        .{ .name = "two_buffers" },
        .{ .name = "nested_helpers", .files = &.{ "types", "create", "pop", "push" } },
        .{ .name = "helper_pop", .files = &.{ "types", "create", "step", "pop", "push" } },
        .{ .name = "dual_append", .files = &.{ "types", "step" } },
    };

    for (cases) |case| {
        const name = case.name;

        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(generator);

            generate.addFileArg(b.path(b.fmt("{s}/{s}/main.zx", .{ directory, name })));
            generate.addFileArg(b.path(directory ++ "/host.d.zx"));
            generate.addArg(route);

            const output = generate.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ name, route }));

            for (case.files) |file| generate.addFileArg(b.path(b.fmt("{s}/{s}/{s}.zx", .{ directory, name, file })));

            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path(directory ++ "/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(output);
            run.addFileArg(b.path(b.fmt("{s}/{s}/execution_test.zig", .{ directory, name })));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path(directory ++ "/host.zig"));
            run.addFileArg(b.path(directory ++ "/support.zig"));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));

            if (case.files.len == 0) {
                step.dependOn(&run.step);
            } else {
                transfers.dependOn(&run.step);
            }
        }
    }

    step.dependOn(transfers);

    return step;
}
