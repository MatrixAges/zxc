const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-object-reduce", "Execute object reduce layout ownership and allocation boundaries");

    const tool = b.addExecutable(.{ .name = "compile-object-reduce", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/object_reduce/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "plain", "spread", "select", "nested", "subject", "field_call", "escape_call", "root_call", "nested_object", "checked", "initial_call" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);
            options.addOption(bool, "bounded", !std.mem.eql(u8, mode, "escape_call") and !std.mem.eql(u8, mode, "root_call") and !std.mem.eql(u8, mode, "nested_object"));

            const module = b.createModule(.{ .root_source_file = b.path("tests/collections/object_reduce/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });

            module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
            module.addOptions("options", options);
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("object-reduce-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    return step;
}
