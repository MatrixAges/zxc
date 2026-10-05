const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-type-parser", "Validate generated ZX type parser semantics and resources");
    const resources_step = b.step("test-type-parser-resources", "Validate generated ZX type parser allocation failure cleanup and result lifetime");
    const parity_step = b.step("test-type-parser-parity", "Compare generated ZX type grammar with the native parser");

    for ([_][]const u8{ "zx", "rx" }) |route| {
        const generate = b.addRunArtifact(cli.artifact("zxc"));

        generate.addFileArg(if (std.mem.eql(u8, route, "rx")) compiler.path("src/zx/frontend/parser/type.rx") else b.path("tests/bootstrap/type_parser/source.zx"));
        generate.addArg("--out");

        const source = generate.addOutputFileArg(b.fmt("type_parser_{s}.zig", .{route}));

        generate.addArg("--no-cache");

        for ([_][]const u8{ "src/zx/frontend/lexer", "src/zx/frontend/parser/types" }) |path| {
            @import("source_inputs.zig").add(b, generate, compiler, path) catch @panic("unable to track type parser sources");
        }

        if (std.mem.eql(u8, route, "rx")) {
            generate.setCwd(compiler.path("."));
            generate.addFileInput(compiler.path("src/zx/frontend/lexical.rx"));
            @import("source_inputs.zig").add(b, generate, compiler, "src/zx/frontend/parser/templates") catch @panic("unable to track template sources");
        }

        const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("tests/bootstrap/type_parser/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        resources_step.dependOn(&b.addRunArtifact(tests).step);

        const frontend = compiler.module("frontend");

        for ([_][]const u8{ "parity", "short_tokens" }) |name| {
            const parity = b.addTest(.{ .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/bootstrap/type_parser/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "program", .module = program },
                    .{ .name = "frontend", .module = frontend },
                    .{ .name = "lexer", .module = frontend.import_table.get("lexer").? },
                    .{ .name = "zx", .module = frontend.import_table.get("zx").? },
                },
            }) });

            parity_step.dependOn(&b.addRunArtifact(parity).step);
        }
    }

    step.dependOn(resources_step);
    step.dependOn(parity_step);

    return step;
}
