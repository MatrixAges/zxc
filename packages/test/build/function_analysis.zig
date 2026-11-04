const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-function-analysis", "Validate owned function summaries and independent generation units");
    const files = b.addWriteFiles();
    const root = files.addCopyFile(b.path("tests/incremental/function_analysis/checks.zig"), "root.zig");
    _ = files.addCopyDirectory(b.path("../genz/src"), "genz", .{});

    const core = compiler.module("frontend").import_table.get("zx").?;

    const checks = b.createModule(.{
        .root_source_file = root,
        .target = target,
        .optimize = optimize,
    });

    var imports = compiler.module("compiler").import_table.get("genz").?.import_table.iterator();

    while (imports.next()) |entry| checks.addImport(entry.key_ptr.*, entry.value_ptr.*);

    step.dependOn(@import("function_analysis_runtime.zig").add(b, checks, core, target, optimize));

    for ([_][]const u8{ "summary", "resources", "emission", "buffer" }) |name| {
        const tests = b.addTest(.{
            .name = b.fmt("function-analysis-{s}", .{name}),
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/function_analysis/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "checks", .module = checks }, .{ .name = "zx", .module = core } },
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        const run = b.addRunArtifact(tests);

        run.has_side_effects = true;

        step.dependOn(&run.step);
    }

    return step;
}
