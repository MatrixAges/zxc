const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-loop-initial-ownership", "Verify fresh map filter initial transfer and shared repeated region copies");
    const directory = "tests/collections/iterate_buffer/ownership";

    const tool = b.addExecutable(.{ .name = "compile-loop-initial-ownership", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "map", "filter", "local", "nested", "tuple", "shared", "borrowed", "repeated" }) |mode| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = generate.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = generate.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const tests = b.createModule(.{ .root_source_file = b.path(directory ++ "/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });
            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            tests.addOptions("options", options);
            tests.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("loop-initial-{s}-{s}", .{ mode, route }), .root_module = tests })).step);
        }
    }

    return step;
}
