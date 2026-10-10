const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, paths: []const []const u8) *std.Build.Step {
    const step = b.step("test-frontend", "Verify conformance diagnostic phases and positions");
    const filter = b.option([]const u8, "frontend-filter", "Run frontend cases whose names contain this text");
    const boolean_assignment_check = b.addSystemCommand(&.{"node"});

    boolean_assignment_check.addFileArg(b.path("src/generate_boolean_assignment.ts"));
    boolean_assignment_check.addArg("--check");
    boolean_assignment_check.addFileInput(b.path("src/shared/catalog.ts"));
    boolean_assignment_check.addFileInput(b.path("src/shared/json.ts"));
    boolean_assignment_check.has_side_effects = true;

    step.dependOn(&boolean_assignment_check.step);

    const support = b.createModule(.{
        .root_source_file = b.path("tests/support/frontend.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    const generate = b.addSystemCommand(&.{"node"});

    generate.addFileArg(b.path("src/emit_frontend_tests.ts"));
    generate.addFileInput(b.path("src/zig_string.ts"));
    generate.addFileInput(b.path("src/shared/json.ts"));

    for (paths) |path| {
        generate.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{path})));
    }

    const source = generate.addOutputFileArg("cases.zig");

    const tests = b.addTest(.{
        .name = "conformance-frontend",
        .filters = if (filter) |name| &.{name} else &.{},
        .root_module = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "support", .module = support }},
        }),
    });

    const run = b.addRunArtifact(tests);

    step.dependOn(&run.step);

    return step;
}
