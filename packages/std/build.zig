const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const abi = b.option(std.Build.LazyPath, "abi", "Generated ABI for standard interfaces");
    const module = b.addModule("zxc_std", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize });

    if (abi) |source| module.addImport("zxc_abi", b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize }));

    _ = b.addModule("string", .{ .root_source_file = b.path("src/string.zig"), .target = target, .optimize = optimize });
}
