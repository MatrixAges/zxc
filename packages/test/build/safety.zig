const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, paths: []const []const u8) *std.Build.Step {
    const step = b.step("test-safety", "Check integer safety failures in isolated processes");

    for (paths) |path| {
        const scalar = std.fs.path.basename(path);
        const base = b.fmt("tests/{s}", .{path});
        const compile_case = b.addRunArtifact(compiler.artifact("zxc"));

        compile_case.addFileArg(b.path(b.fmt("{s}.zx", .{base})));
        compile_case.addArg("--out");

        const program_source = compile_case.addOutputFileArg("program.zig");

        const program = b.createModule(.{
            .root_source_file = program_source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_standard", .module = compiler.module("standard") }},
        });

        const executable = b.addExecutable(.{
            .name = b.fmt("integer-safety-{s}", .{scalar}),
            .root_module = b.createModule(.{
                .root_source_file = b.path("tests/support/integer_process.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }),
        });

        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path("src/run_integer_safety.ts"));
        run.addFileInput(b.path("src/shared/json.ts"));
        run.addArtifactArg(executable);
        run.addFileArg(b.path(b.fmt("{s}.jsonl", .{base})));

        const results = run.addOutputFileArg("results.jsonl");
        const install = b.addInstallFile(results, b.fmt("conformance/{s}/{s}.jsonl", .{ @tagName(optimize), scalar }));

        step.dependOn(&install.step);
    }

    return step;
}
