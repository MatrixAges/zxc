const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const frontend = compiler.module("frontend");

    const executable = b.addExecutable(.{ .name = "lexer-adapter-observe", .root_module = b.createModule(.{
        .root_source_file = b.path("observe.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "lexer", .module = frontend.import_table.get("lexer").? },
            .{ .name = "zx", .module = frontend.import_table.get("zx").? },
        },
    }) });

    b.installArtifact(executable);
}
