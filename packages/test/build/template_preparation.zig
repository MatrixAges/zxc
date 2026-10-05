const std = @import("std");
const source_inputs = @import("source_inputs.zig");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-template-preparation-resources", "Validate generated template preparation allocation cleanup and result lifetime");

    for ([_][]const u8{ "zx", "rx" }) |route| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));
        const is_rx = std.mem.eql(u8, route, "rx");

        generate.addFileArg(compiler.path(if (is_rx) "src/zx/frontend/lexical.rx" else "src/zx/frontend/parser/templates/prepare.zx"));
        generate.setCwd(compiler.path("."));
        generate.addArg("--out");

        const source = generate.addOutputFileArg(b.fmt("template_preparation_{s}.zig", .{route}));

        generate.addArg("--no-cache");

        for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/templates" }) |path| {
            source_inputs.add(b, generate, compiler, path) catch @panic("unable to track template preparation sources");
        }

        const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/bootstrap/template_preparation/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
