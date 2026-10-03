const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.option(
        std.builtin.OptimizeMode,
        "optimize",
        "Prioritize performance, safety, or binary size",
    ) orelse .ReleaseSafe;

    const dsl_dependency = b.dependency("dsl", .{
        .target = target,
        .optimize = optimize,
    });

    const dsl_example = dsl_dependency.artifact("dsl-rules");
    const run_dsl_example = b.addRunArtifact(dsl_example);
    const dsl_step = b.step("dsl-example", "Run the typed DSL package example");

    b.getInstallStep().dependOn(&dsl_example.step);
    dsl_step.dependOn(&run_dsl_example.step);

    const rx_dependency = b.dependency("rx", .{ .target = target, .optimize = optimize });

    const rx_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = rx_dependency.path("tests/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "rx", .module = rx_dependency.module("rx") }},
        }),
    });

    b.getInstallStep().dependOn(&rx_tests.step);

    const run_rx_tests = b.addRunArtifact(rx_tests);
    const test_step = b.step("test", "Run package unit tests");

    test_step.dependOn(&run_rx_tests.step);

    const compiler_dependency = b.dependency("compiler", .{ .target = target, .optimize = optimize });

    test_step.dependOn(&compiler_dependency.builder.top_level_steps.get("test").?.step);

    const conformance = b.dependency("conformance", .{ .target = target, .optimize = optimize });

    test_step.dependOn(&conformance.builder.top_level_steps.get("test").?.step);
    b.installArtifact(compiler_dependency.artifact("zxc"));
    b.installDirectory(.{ .source_dir = compiler_dependency.path("standard"), .install_dir = .prefix, .install_subdir = "share/zxc/standard", .include_extensions = &.{".zig"} });

    const run_zx_example = b.addRunArtifact(compiler_dependency.artifact("zx-example"));
    const zx_step = b.step("zx-example", "Compile and run the ZX package example");

    zx_step.dependOn(&run_zx_example.step);
}
