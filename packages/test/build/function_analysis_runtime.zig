const std = @import("std");
const Case = struct { kind: []const u8, count: usize };

pub fn add(b: *std.Build, checks: *std.Build.Module, core: *std.Build.Module, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-function-analysis-runtime", "Execute statically linked units emitted with single and shared function summaries");

    const tool = b.addExecutable(.{ .name = "generate-function-analysis-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/incremental/function_analysis/generate_runtime.zig"), .target = target, .optimize = optimize,
        .imports = &.{ .{ .name = "checks", .module = checks }, .{ .name = "zx", .module = core } },
    }) });

    const cases = [_]Case{ .{ .kind = "scalar", .count = 1 }, .{ .kind = "scalar", .count = 3 }, .{ .kind = "scalar", .count = 17 }, .{ .kind = "nested", .count = 1 } };

    for ([_][]const u8{ "single", "shared" }) |route| for (cases) |case| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(case.kind);
        generate.addArg(route);
        generate.addArg(b.fmt("{d}", .{case.count}));
        generate.has_side_effects = true;

        const types = generate.addOutputFileArg("types.zig");
        const entry = generate.addOutputFileArg("entry.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const functions = b.allocator.alloc(*std.Build.Module, case.count) catch @panic("out of memory");

        for (functions, 0..) |*function, index| {
            const source = generate.addOutputFileArg(b.fmt("function_{d}.zig", .{index}));
            function.* = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

            for (functions[0..index], 0..) |callee, previous| function.*.addImport(b.fmt("function_{d}", .{previous}), callee);
        }

        const program = b.createModule(.{ .root_source_file = entry, .target = target, .optimize = optimize, .imports = &.{.{ .name = "zxc_abi", .module = abi }} });

        for (functions, 0..) |function, index| program.addImport(b.fmt("function_{d}", .{index}), function);

        const root = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/incremental/function_analysis/runtime/{s}_test.zig", .{case.kind})),
            .target = target, .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "last", .module = functions[functions.len - 1] } },
        });

        const options = b.addOptions();

        options.addOption(usize, "count", case.count);
        root.addOptions("options", options);

        const tests = b.addTest(.{ .name = b.fmt("function-analysis-{s}-{s}-{d}", .{ route, case.kind, case.count }), .root_module = root });
        const run = b.addRunArtifact(tests);

        run.has_side_effects = true;

        step.dependOn(&run.step);
    };

    return step;
}
