const std = @import("std");
pub const Modules = struct { frontend: *std.Build.Module, compiler: *std.Build.Module };

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, standard_interfaces: *std.Build.Module) Modules {
    const frontend = b.createModule(.{
        .root_source_file = b.path("src/frontend.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") },
            .{ .name = "standard_interfaces", .module = standard_interfaces },
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
        },
    });

    const module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "frontend", .module = frontend },
            .{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") },
            .{ .name = "genz", .module = b.dependency("genz", .{ .target = target, .optimize = optimize }).module("genz") },
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
        },
    });

    return .{ .frontend = frontend, .compiler = module };
}
