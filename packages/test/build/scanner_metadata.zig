const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-scanner-metadata", "Validate generated scanner scalar token metadata");
    const lexer = compiler.module("frontend").import_table.get("lexer").?;

    for ([_][]const u8{ "boundaries", "words", "symbols" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/lexical/scanner_metadata/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "scanner", .module = lexer.import_table.get("generated").? }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
