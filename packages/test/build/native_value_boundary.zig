const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-value-boundary", "Validate native borrowing and transitive value call classification");
    const files = b.addWriteFiles();
    const root = files.add("root.zig", "pub const native = @import(\"zx/native_value.zig\");\npub const summary = @import(\"zx/value_call/analysis.zig\");\n");
    _ = files.addCopyDirectory(b.path("../genz/src/zx"), "zx", .{});

    const checks = b.createModule(.{
        .root_source_file = root,
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = compiler.module("frontend").import_table.get("zx").? }},
    });

    for ([_][]const u8{ "borrowing", "guards", "allocation" }) |name| {
        const tests = b.addTest(.{
            .name = b.fmt("native-value-boundary-{s}", .{name}),
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/native/value_boundary/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "compiler", .module = compiler.module("compiler") },
                    .{ .name = "native_value_checks", .module = checks },
                },
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        const run = b.addRunArtifact(tests);

        run.has_side_effects = true;

        step.dependOn(&run.step);
    }

    return step;
}
