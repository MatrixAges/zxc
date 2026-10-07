const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const rx = b.dependency("rx", .{ .target = target, .optimize = optimize });
    const step = b.step("test", "Run existing expression suites against staged sources");

    for ([_][]const u8{ "bindings/input_test.zig", "xml/position_test.zig" }) |name| {
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/expressions/{s}", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "compiler", .module = compiler.module("compiler") },
                    .{ .name = "rx_compiler", .module = compiler.module("rx_compiler") },
                    .{ .name = "rx", .module = rx.module("rx") },
                },
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    step.dependOn(@import("build/expression_runtime.zig").add(b, compiler, target, optimize));
}
