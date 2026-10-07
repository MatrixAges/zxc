const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, paths: []const []const u8) *std.Build.Step {
    const step = b.step("test-compound-integer", "Execute typed compound field and list safety boundaries");

    if (!optimize.runtimeSafety()) return step;

    const tool = b.addExecutable(.{ .name = "compile-compound-integer", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/runtime/safety/compound_integer/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for (paths) |path| {
        const prefix = "runtime/safety/compound_integer/";

        if (!std.mem.startsWith(u8, path, prefix)) continue;

        const mode = path[prefix.len..];
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            const executable = b.addExecutable(.{ .name = b.fmt("compound-integer-{s}-{s}-{s}", .{ std.fs.path.dirname(mode).?, std.fs.path.basename(mode), route }), .root_module = b.createModule(.{
                .root_source_file = b.path("tests/runtime/safety/compound_integer/process.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }) });

            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/runtime/safety/compound_integer/run_test.ts"));
            run.addFileInput(b.path("src/shared/json.ts"));
            run.addArtifactArg(executable);
            run.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{path})));

            const results = run.addOutputFileArg(b.fmt("{s}-{s}-{s}-{s}.jsonl", .{ @tagName(optimize), std.fs.path.dirname(mode).?, std.fs.path.basename(mode), route }));
            const install = b.addInstallFile(results, b.fmt("conformance/{s}/compound_integer/{s}/{s}.jsonl", .{ @tagName(optimize), mode, route }));

            run.has_side_effects = true;

            step.dependOn(&install.step);
        }
    }

    return step;
}
