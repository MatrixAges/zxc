const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const frontend = compiler.module("frontend");
    const generated = b.createModule(.{ .root_source_file = .{ .cwd_relative = "/tmp/zxc_type_source.zig" }, .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{ .name = "type-boundary-observe", .root_module = b.createModule(.{
        .root_source_file = b.path("observe.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "frontend", .module = frontend },
            .{ .name = "zx", .module = frontend.import_table.get("zx").? },
            .{ .name = "lexer", .module = frontend.import_table.get("lexer").? },
            .{ .name = "generated", .module = generated },
        },
    }) });

    b.installArtifact(executable);
}
