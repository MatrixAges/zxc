const std = @import("std");

pub fn create(b: *std.Build, source: std.Build.LazyPath) *std.Build.Step.Compile {
    const target = b.graph.host;
    const optimize: std.builtin.OptimizeMode = .small;
    const modules = generated(b, source, target, optimize, true, null);
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
            .imports = &.{.{ .name = "generated", .module = modules }},
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

pub fn generated(b: *std.Build, source: std.Build.LazyPath, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, strip: ?bool, shared_standard: ?*std.Build.Module) *std.Build.Module {
    const abi = b.createModule(.{ .root_source_file = source.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const standard = shared_standard orelse b.createModule(.{
        .root_source_file = b.dependency("zxc_std", .{}).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    return b.createModule(.{
        .root_source_file = source.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
    });
}
