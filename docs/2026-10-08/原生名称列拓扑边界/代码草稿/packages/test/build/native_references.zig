const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-references-analysis", "Validate native opaque declarations and language lifetime boundaries");

    for ([_][]const u8{ "acceptance", "declaration", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/native/references/analysis/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const validation = b.step("test-native-references-ir", "Validate native reference IR ownership and accessor boundaries");
    const frontend = compiler.module("frontend");
    const files = b.addWriteFiles();
    const checks_root = files.add("root.zig", "pub const expressions = @import(\"zx/ir/expression_rules.zig\");\npub const scopes = @import(\"zx/ir/scopes.zig\");\npub const tasks = @import(\"zx/ir/tasks.zig\");\n");
    _ = files.addCopyDirectory(compiler.path("src/zx"), "zx", .{});

    const checks = b.createModule(.{ .root_source_file = checks_root, .target = target, .optimize = optimize });
    var imports = frontend.import_table.iterator();

    while (imports.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    for ([_][]const u8{ "owner", "boundary", "allocation", "task", "name_columns/root" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/native/references/ir/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        if (std.mem.eql(u8, name, "name_columns/root")) {
            tests.root_module.addAnonymousImport("native_ir_fixture", .{
                .root_source_file = b.path("tests/native/references/ir/fixture.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            });
        }

        if (std.mem.eql(u8, name, "task")) {
            tests.root_module.addImport("frontend", frontend);
            tests.root_module.addImport("native_ir_checks", checks);
        }

        validation.dependOn(&b.addRunArtifact(tests).step);
    }

    const exports = b.step("test-native-references-exports", "Reject native references at external data conversion boundaries");

    for ([_][]const u8{ "napi", "gateway", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/native/references/exports/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        exports.dependOn(&b.addRunArtifact(tests).step);
    }

    const library = b.step("test-native-references-library", "Validate native reference nominal identity and compiled library ownership");

    for ([_][]const u8{ "identity", "roundtrip", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/native/references/library/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        library.dependOn(&b.addRunArtifact(tests).step);
    }

    const all = b.step("test-native-references", "Validate native reference language and IR boundaries");

    all.dependOn(step);
    all.dependOn(validation);
    all.dependOn(exports);
    all.dependOn(library);
    all.dependOn(@import("native_reference_runtime.zig").add(b, compiler, target, optimize));

    return all;
}
