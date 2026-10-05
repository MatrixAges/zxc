const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-owned-input", "Validate explicit input consumption across source and library boundaries");

    for ([_][]const u8{ "analysis", "library", "modules" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/ownership/input/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const tool = b.addExecutable(.{ .name = "compile-owned-input", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/input/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    const compile = b.addRunArtifact(tool);

    for ([_][]const u8{ "source", "linked", "library", "republished", "owned", "mutating" }) |mode| {
        const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{mode}));
        const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{mode}));
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });

        const options = b.addOptions();

        options.addOption(bool, "owned", std.mem.eql(u8, mode, "owned") or std.mem.eql(u8, mode, "mutating"));
        options.addOption(bool, "mutating", std.mem.eql(u8, mode, "mutating"));

        const module = b.createModule(.{
            .root_source_file = b.path("tests/ownership/input/runtime/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        });

        module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        module.addOptions("options", options);

        const tests = b.addTest(.{ .name = b.fmt("owned-input-{s}", .{mode}), .root_module = module });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
