const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const seed = b.option(bool, "seed", "Use the initial Zig naming and length implementations") orelse false;
    const generated_name = b.option(std.Build.LazyPath, "generated_name", "Generated RX/ZX naming implementation");
    const generated_length = b.option(std.Build.LazyPath, "generated_length", "Generated RX/ZX length implementation");

    if (seed and (generated_name != null or generated_length != null)) @panic("seed lint cannot use generated rules");
    if (!seed and (generated_name == null or generated_length == null)) @panic("lint requires generated_name and generated_length; seed is only for bootstrap");

    const naming = b.createModule(.{
        .root_source_file = b.path(if (seed) "bootstrap/naming.zig" else "src/naming/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (generated_name) |source| naming.addImport("generated", b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }));

    const length = b.createModule(.{
        .root_source_file = b.path(if (seed) "bootstrap/length.zig" else "src/length/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (generated_length) |source| length.addImport("generated", b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }));

    const module = b.addModule("lint", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "naming", .module = naming },
            .{ .name = "length", .module = length },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
        },
    });

    const library = b.addLibrary(.{ .name = "zxc_lint", .root_module = module });

    b.installArtifact(library);
}
