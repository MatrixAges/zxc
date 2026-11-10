const std = @import("std");

pub fn create(b: *std.Build, source: std.Build.LazyPath) *std.Build.Step.Compile {
    const target = b.graph.host;
    const optimize: std.builtin.OptimizeMode = .small;
    const abi = b.createModule(.{ .root_source_file = source.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = true });

    const standard = b.createModule(.{
        .root_source_file = b.dependency("zxc_std", .{}).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const generated = b.createModule(.{
        .root_source_file = source.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = true,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
    });

    const options = b.addOptions();

    options.addOption(bool, "generated", true);
    options.addOption(bool, "generated_analysis", true);

    const genz = b.createModule(.{
        .root_source_file = b.dependency("genz", .{}).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz_options", .module = options.createModule() },
        },
    });

    inline for (@import("entries.zig").host) |entry| {
        genz.addImport(entry.importName(), b.createModule(.{
            .root_source_file = source.path(b, entry.name ++ ".zig"),
            .target = target,
            .optimize = optimize,
            .strip = true,
            .imports = &.{.{ .name = "generated", .module = generated }},
        }));
    }

    return b.addExecutable(.{
        .name = "host-metadata",
        .root_module = b.createModule(.{
            .root_source_file = b.path("build/generate_metadata.zig"),
            .target = target,
            .optimize = optimize,
            .strip = true,
            .imports = &.{.{ .name = "genz", .module = genz }},
        }),
    });
}
