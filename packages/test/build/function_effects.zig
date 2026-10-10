const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-function-effects", "Validate generated function effects, program purity and allocation ownership");
    const frontend = compiler.module("frontend");
    const files = b.addWriteFiles();
    const root = files.add("root.zig", "pub const parallel = @import(\"zx/ir/parallel.zig\");\npub const tasks = @import(\"zx/ir/tasks.zig\");\npub const generated = @import(\"parser_options\").generated_parser;\n");
    _ = files.addCopyDirectory(compiler.path("src/zx"), "zx", .{});

    const checks = b.createModule(.{ .root_source_file = root, .target = target, .optimize = optimize });
    var imports = frontend.import_table.iterator();

    while (imports.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    var generated = compiler.module("frontend_checks").import_table.iterator();

    while (generated.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    for ([_][]const u8{ "functions", "program", "resources" }) |name| {
        const tests = b.addTest(.{ .name = b.fmt("function-effects-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/ir/effects/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "checks", .module = checks },
                .{ .name = "zx", .module = frontend.import_table.get("zx").? },
            },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
