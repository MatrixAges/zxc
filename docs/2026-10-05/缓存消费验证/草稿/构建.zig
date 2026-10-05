const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-cached-ownership", "Validate cached ownership mutation gates and runtime spread semantics");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/cached/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    const tool = b.addExecutable(.{ .name = "compile-cached-ownership", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/cached/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "fresh", "nested", "child", "borrowed", "conditional" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        for ([_][]const u8{ "source", "library" }) |route| {
            const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{route}));
            const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{route}));
            const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
            const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });
            const options = b.addOptions();

            options.addOption([]const u8, "mode", mode);

            const module = b.createModule(.{ .root_source_file = b.path("tests/ownership/cached/runtime/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "program", .module = program }} });

            module.addOptions("options", options);
            step.dependOn(&b.addRunArtifact(b.addTest(.{ .name = b.fmt("cached-ownership-{s}-{s}", .{ mode, route }), .root_module = module })).step);
        }
    }

    return step;
}
