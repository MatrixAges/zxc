const std = @import("std");
const source_inputs = @import("source_inputs.zig");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-expression-preparation", "Validate generated expression lookahead across root and interpolation token streams");
    const frontend = compiler.module("frontend");

    for ([_][]const u8{ "zx", "rx" }) |route| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));
        const is_rx = std.mem.eql(u8, route, "rx");

        generate.addFileArg(if (is_rx) compiler.path("src/zx/frontend/parser/prepare.rx") else b.path("tests/bootstrap/expression_preparation/source.zx"));
        generate.setCwd(compiler.path("."));
        generate.addArg("--out");

        const source = generate.addOutputFileArg(b.fmt("expression_preparation_{s}.zig", .{route}));

        generate.addArg("--no-cache");

        for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/templates", "src/zx/frontend/parser/expressions/prepare" }) |path| {
            source_inputs.add(b, generate, compiler, path) catch @panic("unable to track expression preparation sources");
        }

        if (is_rx) generate.addFileInput(compiler.path("src/zx/frontend/lexical.rx"));

        const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/bootstrap/expression_preparation/semantics_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "program", .module = program },
                .{ .name = "zx", .module = frontend.import_table.get("zx").? },
                .{ .name = "lexer", .module = frontend.import_table.get("lexer").? },
            },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
