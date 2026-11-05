const std = @import("std");
const source_inputs = @import("source_inputs.zig");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-expression-preparation", "Validate generated expression lookahead across root and interpolation token streams");
    const semantics_step = b.step("test-expression-preparation-semantics", "Validate expression lookahead classification and stream alignment");
    const resources_step = b.step("test-expression-preparation-resources", "Validate expression preparation allocation failures and result lifetime");
    const frontend = compiler.module("frontend");
    const files = b.addWriteFiles();

    _ = files.add("pkg.yaml",
        \\name: expression_preparation
        \\version: 0.0.0
        \\entry: packages/compiler/src/zx/frontend/parser/prepare.rx
        \\workspace:
        \\    packages: [packages/core]
        \\dependencies:
        \\    core: workspace:*
        \\
    );

    _ = files.add("packages/core/pkg.yaml",
        \\name: core
        \\version: 0.0.0
        \\exports:
        \\    ./const: src/const.zx
        \\    ./ascii/const: src/ascii/const.zx
        \\
    );

    _ = files.addCopyFile(b.path("../core/src/const.zx"), "packages/core/src/const.zx");
    _ = files.addCopyFile(b.path("../core/src/ascii/const.zx"), "packages/core/src/ascii/const.zx");

    for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/templates", "src/zx/frontend/parser/expressions/prepare" }) |path| {
        _ = files.addCopyDirectory(compiler.path(path), b.fmt("packages/compiler/{s}", .{path}), .{});
    }

    _ = files.addCopyFile(compiler.path("src/zx/frontend/lexical.rx"), "packages/compiler/src/zx/frontend/lexical.rx");
    const module = files.addCopyFile(compiler.path("src/zx/frontend/parser/prepare.rx"), "packages/compiler/src/zx/frontend/parser/prepare.rx");
    const direct = files.addCopyFile(b.path("tests/bootstrap/expression_preparation/source.rx"), "packages/test/tests/bootstrap/expression_preparation/source.rx");

    for ([_][]const u8{ "direct", "module" }) |route| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));
        const is_module = std.mem.eql(u8, route, "module");

        generate.addFileArg(if (is_module) module else direct);
        generate.setCwd(files.getDirectory());
        generate.addArg("--project");
        generate.addFileArg(files.getDirectory().path(b, "pkg.yaml"));
        generate.addArg("--out");

        const source = generate.addOutputFileArg(b.fmt("expression_preparation_{s}.zig", .{route}));

        generate.addArg("--no-cache");

        for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/templates", "src/zx/frontend/parser/expressions/prepare" }) |path| {
            source_inputs.add(b, generate, compiler, path) catch @panic("unable to track expression preparation sources");
        }

        generate.addFileInput(compiler.path("src/zx/frontend/lexical.rx"));

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

        semantics_step.dependOn(&b.addRunArtifact(tests).step);

        const resources = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/bootstrap/expression_preparation/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        }) });

        resources.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        resources_step.dependOn(&b.addRunArtifact(resources).step);
    }

    step.dependOn(semantics_step);
    step.dependOn(resources_step);

    return step;
}
