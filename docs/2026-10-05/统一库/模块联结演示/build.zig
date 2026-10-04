const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });

    for ([_]struct { name: []const u8, source: []const u8 }{
        .{ .name = "library-modules", .source = "generate.zig" },
        .{ .name = "library-emit", .source = "emit.zig" },
        .{ .name = "library-import", .source = "import.zig" },
    }) |entry| {
        const generator = b.addExecutable(.{
            .name = entry.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(entry.source),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "compiler", .module = compiler.module("compiler") },
                    .{ .name = "rx", .module = compiler.module("rx") },
                    .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
                },
            }),
        });

        b.installArtifact(generator);
    }
}
