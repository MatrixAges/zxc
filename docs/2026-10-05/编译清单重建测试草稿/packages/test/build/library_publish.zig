const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency) *std.Build.Step {
    const step = b.step("test-library-publish", "Publish unified public libraries and consume relocated artifacts through ZX and Zig");
    const entry_step = b.step("test-library-entry", "Validate single entry normalization and preserved Zig compatibility");
    const native_step = b.step("test-library-native-publish", "Publish and republish scoped native ABI and resources");
    const store_step = b.step("test-library-store-publish", "Execute relocated and republished Store initialization modules");
    const rx_step = b.step("test-library-rx-compiled", "Execute RX compiled Store calls with shared and distinct package instances");
    const boundary_step = b.step("test-library-rx-boundary", "Reject unauthorized compiled Store transactions and missing application initializers");
    const compiled_step = b.step("test-library-compiled-manifest", "Verify and rebuild relocated compiled manifests directly");

    step.dependOn(compiled_step);
    step.dependOn(boundary_step);
    step.dependOn(rx_step);
    step.dependOn(store_step);
    step.dependOn(entry_step);
    step.dependOn(native_step);

    for ([_][]const u8{ "runtime", "failure", "closure", "entry", "native", "store", "rx_compiled", "rx_boundary", "compiled" }) |name| {
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
        } else if (std.mem.eql(u8, name, "native")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/native"));
            run.addFileInput(b.path("tests/library_publish/native_resources.ts"));
            native_step.dependOn(&run.step);
        } else if (std.mem.eql(u8, name, "store")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/store"));
            run.addFileInput(b.path("tests/library_publish/store_consume.ts"));
            store_step.dependOn(&run.step);
        } else if (std.mem.eql(u8, name, "rx_compiled")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/rx_compiled"));
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/store/source"));
            run.addFileInput(b.path("tests/library_publish/rx_rejections.ts"));
            rx_step.dependOn(&run.step);
        } else if (std.mem.eql(u8, name, "rx_boundary")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/rx_boundary"));
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/store/source"));
            run.addFileInput(b.path("tests/library_publish/store_artifact.ts"));
            boundary_step.dependOn(&run.step);
        } else if (std.mem.eql(u8, name, "compiled")) {
            run.addDirectoryArg(b.path("tests/library_publish/fixtures/compiled"));
            compiled_step.dependOn(&run.step);
        } else step.dependOn(&run.step);
    }

    return step;
}
