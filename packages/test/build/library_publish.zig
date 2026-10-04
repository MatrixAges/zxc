const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency) *std.Build.Step {
    const step = b.step("test-library-publish", "Publish unified public libraries and consume relocated artifacts through ZX and Zig");

    for ([_][]const u8{ "runtime", "failure" }) |name| {
        const run = b.addSystemCommand(&.{"node"});
        run.addFileArg(b.path(b.fmt("tests/library_publish/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/library_publish/fixture.ts"));
        for ([_][]const u8{ "source/identity.zx", "source/invert.zx", "source/types.zx", "source/flow.rx", "consumer/main.zx", "zig/build.zig", "zig/build.zig.zon", "zig/consumer_test.zig" }) |file| {
            run.addFileInput(b.path(b.fmt("tests/library_publish/fixtures/{s}", .{file})));
        }
        run.addArtifactArg(cli.artifact("zxc"));
        run.addArg(b.graph.zig_exe);
        step.dependOn(&run.step);
    }

    return step;
}
