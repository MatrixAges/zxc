const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("dsl", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const example = b.addExecutable(.{
        .name = "dsl-rules",
        .root_module = b.createModule(.{
            .root_source_file = b.path("examples/rules.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "dsl", .module = module }},
        }),
    });

    b.installArtifact(example);

    const run = b.addRunArtifact(example);
    const example_step = b.step("example", "Run the typed DSL example");

    example_step.dependOn(&run.step);
}
