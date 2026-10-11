const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const options = b.addOptions();

    options.addOption(bool, "generated_printer", b.option(bool, "generated_printer", "Print Zig source through the generated RX/ZX printer") orelse false);

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
