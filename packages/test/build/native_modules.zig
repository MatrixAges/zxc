const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-module-checks", "Validate generated native module and export column boundaries");
    const frontend = compiler.module("frontend");
    const files = b.addWriteFiles();
    const root = files.add("root.zig", "pub const native = @import(\"zx/ir/native_modules.zig\");\npub const generated = @import(\"parser_options\").generated_parser;\n");
    _ = files.addCopyDirectory(compiler.path("src/zx"), "zx", .{});

    const checks = b.createModule(.{ .root_source_file = root, .target = target, .optimize = optimize });
    var imports = frontend.import_table.iterator();

    while (imports.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    var generated = compiler.module("frontend_checks").import_table.iterator();

    while (generated.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    for ([_][]const u8{ "structure", "declarations", "bindings", "exports" }) |name| {
        const tests = b.addTest(.{ .name = b.fmt("native-modules-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/native/modules/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "checks", .module = checks }, .{ .name = "compiler", .module = compiler.module("compiler") } },
        }) });

        tests.root_module.addAnonymousImport("reference_fixture", .{
            .root_source_file = b.path("tests/native/references/ir/fixture.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
