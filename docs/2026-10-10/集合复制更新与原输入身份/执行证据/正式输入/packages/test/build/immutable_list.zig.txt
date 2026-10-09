const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-immutable-list", "Verify source preservation and new storage for immutable list operations");
    const check = b.addSystemCommand(&.{"node"});

    check.addFileArg(b.path("src/generate_immutable_list.ts"));
    check.addFileInput(b.path("src/immutable_list/cases.ts"));
    check.addFileInput(b.path("src/shared/catalog.ts"));
    check.addFileInput(b.path("src/shared/json.ts"));
    check.addArg("--check");
    check.has_side_effects = true;

    step.dependOn(&check.step);

    const tool = b.addExecutable(.{ .name = "compile-immutable-list", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/reverse_ownership/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for (suites) |suite| {
        if (suite.kind != .immutable_list) continue;

        const operation = std.fs.path.basename(suite.path);
        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_immutable_list.ts"));
        emit.addFileInput(b.path("src/immutable_list/cases.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/shared/zig_literal.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
        emit.addArg(operation);

        const cases = emit.addOutputFileArg("cases.zig");
        const generate = b.addRunArtifact(tool);

        generate.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const support = b.createModule(.{ .root_source_file = b.path("tests/collections/immutable_list/check.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });

            support.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

            const run = b.addRunArtifact(b.addTest(.{ .name = b.fmt("immutable-list-{s}-{s}", .{ operation, route }), .root_module = b.createModule(.{
                .root_source_file = cases,
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "support", .module = support }},
            }) }));

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
