const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const options = b.addOptions();

    options.addOption(bool, "generated", b.option(bool, "generated", "Use the generated RX/ZX implementations") orelse false);
    options.addOption(bool, "generated_analysis", b.option(bool, "generated_analysis", "Use the generated RX/ZX function facts and inline preparation") orelse false);

    const module = b.addModule("genz", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz_options", .module = options.createModule() },
        },
    });

    const library = b.addLibrary(.{ .name = "zxc_genz", .root_module = module });

    b.installArtifact(library);
}
