const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-runtime", "Run conformance cases through generated Zig");
    const owned_step = b.step("test-owned-collections", "Run collection cases with locally constructed owners");

    for (suites) |suite| {
        const base = b.fmt("tests/{s}", .{suite.path});
        const compile_case = b.addRunArtifact(compiler.artifact("zxc"));

        compile_case.addFileArg(b.path(b.fmt("{s}.zx", .{base})));
        compile_case.addArg("--out");

        const program_source = compile_case.addOutputFileArg("program.zig");
        const generate = b.addSystemCommand(&.{"node"});
        const uses_bits = suite.kind == .floating or suite.kind == .floating_comparison or suite.kind == .floating_unary or suite.kind == .floating_ternary;
        const emitter = if (uses_bits) "floating" else "control";

        generate.addFileArg(b.path(b.fmt("src/emit_{s}_tests.ts", .{emitter})));
        generate.addFileInput(b.path("src/zig_string.ts"));
        generate.addFileInput(b.path("src/shared/json.ts"));

        if (!uses_bits) generate.addFileInput(b.path("src/shared/zig_literal.ts"));

        generate.addFileArg(b.path(b.fmt("{s}.jsonl", .{base})));

        const test_source = generate.addOutputFileArg("cases.zig");

        const support = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/support/{s}.zig", .{@tagName(suite.kind)})),
            .target = target,
            .optimize = optimize,
        });

        const program = b.createModule(.{
            .root_source_file = program_source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_standard", .module = compiler.module("standard") }},
        });

        const tests = b.addTest(.{
            .name = suite.name,
            .root_module = b.createModule(.{
                .root_source_file = test_source,
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "support", .module = support },
                    .{ .name = "program", .module = program },
                },
            }),
        });

        const run = b.addRunArtifact(tests);

        step.dependOn(&run.step);

        if (std.mem.indexOf(u8, suite.path, "/owned/") != null) owned_step.dependOn(&run.step);
    }

    return step;
}
