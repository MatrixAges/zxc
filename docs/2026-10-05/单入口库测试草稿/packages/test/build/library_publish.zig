const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency) *std.Build.Step {
    const step = b.step("test-library-publish", "Publish unified public libraries and consume relocated artifacts through ZX and Zig");
    const entry_step = b.step("test-library-entry", "Validate single entry normalization and preserved Zig compatibility");

    step.dependOn(entry_step);

    for ([_][]const u8{ "runtime", "failure", "closure", "entry" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/library_publish/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/library_publish/fixture.ts"));

        for ([_][]const u8{ "source/identity.zx", "source/invert.zx", "source/types.zx", "source/flow.rx", "consumer/main.zx", "zig/build.zig", "zig/build.zig.zon", "zig/consumer_test.zig" }) |file| {
            run.addFileInput(b.path(b.fmt("tests/library_publish/fixtures/{s}", .{file})));
        }

        run.addArtifactArg(cli.artifact("zxc"));
        run.addArg(b.graph.zig_exe);

        if (std.mem.eql(u8, name, "closure")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/closure"));
            run.addFileInput(b.path("tests/package_native/archive.ts"));
            run.addFileInput(b.path("src/shared/tar.ts"));
        }

        if (std.mem.eql(u8, name, "entry")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/entry"));
            entry_step.dependOn(&run.step);
        } else step.dependOn(&run.step);
    }

    return step;
}
