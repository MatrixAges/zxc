const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-object-shorthand", "Execute object shorthand through source and decoded unified libraries");

    const tool = b.addExecutable(.{ .name = "compile-object-shorthand", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/object_construction/compile_identifiers.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for (suites) |suite| {
        if (!std.mem.startsWith(u8, suite.name, "object-construction-shorthand-")) continue;

        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_control_tests.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/shared/zig_literal.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));

        const cases = emit.addOutputFileArg("cases.zig");
        const generate = b.addRunArtifact(tool);

        generate.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const support = b.createModule(.{ .root_source_file = b.path("tests/support/control.zig"), .target = target, .optimize = optimize });
            const tests = b.createModule(.{ .root_source_file = cases, .target = target, .optimize = optimize, .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "support", .module = support } } });

            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("{s}-{s}", .{ suite.name, route }), .root_module = tests })).step);
        }
    }

    return step;
}
