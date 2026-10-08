const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-product-transfer", "Validate independent RX product buffers aliases observers and resource cleanup");
    const directory = "tests/rx/runtime/product_transfer";

    const tool = b.addExecutable(.{ .name = "compile-product-transfer", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "rx", .module = compiler.module("rx") }, .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") } },
    }) });

    for (@import("../tests/rx/runtime/product_transfer/catalog.zig").modes) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        const source = compile.addOutputFileArg("source.zig");
        const types = compile.addOutputFileArg("types.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
        const options = b.addOptions();

        options.addOption([]const u8, "mode", mode);

        for ([_][]const u8{ "root.zig", "capacity_test.zig" }) |name| {
            if (std.mem.eql(u8, name, "capacity_test.zig") and !std.mem.eql(u8, mode, "object") and !std.mem.eql(u8, mode, "nested")) continue;

            const tests = b.createModule(.{ .root_source_file = b.path(b.fmt("{s}/{s}", .{ directory, name })), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });

            tests.addOptions("options", options);
            tests.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("product-transfer-{s}-{s}", .{ mode, name }), .root_module = tests })).step);
        }
    }

    return step;
}
