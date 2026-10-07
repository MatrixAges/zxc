const std = @import("std");
pub const Modules = struct { syntax: *std.Build.Module, analysis: *std.Build.Module };

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, frontend: *std.Build.Module, lint: *std.Build.Module) Modules {
    const core = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core");
    const dsl = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl");

    const rx = b.createModule(.{
        .root_source_file = b.path("src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "dsl", .module = dsl }, .{ .name = "frontend", .module = frontend } },
    });

    const rx_options = b.addOptions();

    rx_options.addOption(bool, "generated_paths", false);
    rx_options.addOption(bool, "generated_graph", false);
    rx_options.addOption(bool, "generated_rules", false);
    rx.addOptions("rx_options", rx_options);

    const analysis = b.createModule(.{
        .root_source_file = b.path("src/rx/analysis/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = rx },
            .{ .name = "dsl", .module = dsl },
            .{ .name = "zx", .module = core },
            .{ .name = "frontend", .module = frontend },
            .{ .name = "lint", .module = lint },
        },
    });

    return .{ .syntax = rx, .analysis = analysis };
}
