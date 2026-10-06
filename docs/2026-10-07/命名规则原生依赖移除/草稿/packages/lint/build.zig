const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const seed = b.option(bool, "seed", "Use the initial Zig naming implementation") orelse false;
    const generated_name = b.option(std.Build.LazyPath, "generated_name", "Generated RX/ZX naming implementation");

    if (seed and generated_name != null) @panic("seed lint cannot use generated naming");
    if (!seed and generated_name == null) @panic("lint requires generated_name; seed is only for bootstrap");

    const naming = b.createModule(.{
        .root_source_file = b.path(if (seed) "bootstrap/naming.zig" else "src/naming/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (generated_name) |source| naming.addImport("generated", b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }));

    const module = b.addModule("lint", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "naming", .module = naming },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
        },
    });

    const library = b.addLibrary(.{ .name = "zxc_lint", .root_module = module });

    b.installArtifact(library);
}
