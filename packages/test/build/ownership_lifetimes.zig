const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-loan-lifetime-prototype", "Validate isolated loan expiry against concrete storage and measure current generated allocations");
    const directory = "tests/ownership/lifetimes";

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/allocation_test.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    for ([_][]const u8{ "direct", "dead", "live_view", "fresh_append", "read_direct", "read_view", "read_overlap", "read_branch", "call_overlap" }) |name| {
        const compile = b.addRunArtifact(cli.artifact("zxc"));

        compile.setCwd(b.path(directory ++ "/fixtures"));
        compile.addFileArg(b.path(b.fmt("{s}/fixtures/{s}.zx", .{ directory, name })));
        compile.addFileInput(b.path(directory ++ "/fixtures/borrow.zx"));
        compile.addFileInput(b.path(directory ++ "/fixtures/choose_view.zx"));
        compile.addArg("--out");

        const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{name}));

        tests.root_module.addImport(name, b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
        }));
    }

    step.dependOn(&b.addRunArtifact(tests).step);

    const model = b.addSystemCommand(&.{ "node", "--test" });

    model.addFileArg(b.path(directory ++ "/prototype/prototype_test.ts"));

    for ([_][]const u8{ "model.ts", "plan.ts", "execute.ts", "enumerate.ts" }) |name| {
        model.addFileInput(b.path(b.fmt("{s}/prototype/{s}", .{ directory, name })));
    }

    step.dependOn(&model.step);

    return step;
}
