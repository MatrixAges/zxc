const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, paths: []const []const u8) *std.Build.Step {
    const step = b.step("test-safety", "Check integer safety failures in isolated processes");

    step.dependOn(@import("compound_integer.zig").add(b, compiler, target, optimize, paths));

    for (paths) |path| {
        if (std.mem.startsWith(u8, path, "runtime/safety/compound_integer/")) continue;

        const scalar = std.fs.path.basename(path);
        const base = b.fmt("tests/{s}", .{path});
        const compile_case = b.addRunArtifact(cli.artifact("zxc"));

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

        const results = run.addOutputFileArg(b.fmt("integer-{s}-{s}.jsonl", .{ @tagName(optimize), scalar }));
        const install = b.addInstallFile(results, b.fmt("conformance/{s}/{s}.jsonl", .{ @tagName(optimize), scalar }));

        run.has_side_effects = true;

        step.dependOn(&install.step);
    }

    return step;
}
