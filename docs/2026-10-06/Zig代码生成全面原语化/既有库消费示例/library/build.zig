const std = @import("std");

pub fn build(b: *(std).Build) void {
    const target = (b).standardTargetOptions(.{ });
    const optimize = (b).standardOptimizeOption(.{ });
    const abi = (b).createModule(.{ .root_source_file = (b).path("abi.zig"), .target = target, .optimize = optimize, });
    const public_0 = (b).addModule("library", .{ .root_source_file = (b).path("root.zig"), .target = target, .optimize = optimize, });

    (public_0).addImport("zxc_abi", abi);
}
