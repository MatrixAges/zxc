const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-process-context", "Validate process context APIs and independent IO capability forwarding");

    for ([_][]const u8{ "argv", "environment", "cwd" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/process/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const tool = b.addExecutable(.{ .name = "compile-process-context", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/process/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "none", "io", "process", "both" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

            const standard = b.createModule(.{
                .root_source_file = compiler.path("standard/src/root.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "zxc_abi", .module = abi }},
            });

            const program = b.createModule(.{
                .root_source_file = source,
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
            });

            const options = b.addOptions();

            options.addOption(bool, "io", std.mem.eql(u8, mode, "io") or std.mem.eql(u8, mode, "both"));
            options.addOption(bool, "process", std.mem.eql(u8, mode, "process") or std.mem.eql(u8, mode, "both"));

            const module = b.createModule(.{
                .root_source_file = b.path("tests/standard/resources/process/runtime.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "standard", .module = standard } },
            });

            module.addOptions("options", options);

            const tests = b.addTest(.{ .root_module = module });

            step.dependOn(&b.addRunArtifact(tests).step);
        }
    }

    return step;
}
