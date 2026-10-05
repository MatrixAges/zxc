const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-api-library", "Execute all URL API catalogs through published libraries and ZX consumers");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/standard/url/api/library_test.ts"));
    run.addFileInput(b.path("src/shared/json.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/standard/url/api"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    const native_step = b.step("test-url-api-native", "Execute URL API catalogs from standalone Zig consumers of published libraries");
    const native = b.addSystemCommand(&.{"node"});

    native.addFileArg(b.path("tests/standard/url/api/native_test.ts"));
    native.addFileInput(b.path("src/shared/json.ts"));
    native.addFileInput(b.path("src/emit_control_tests.ts"));
    native.addFileInput(b.path("src/shared/zig_literal.ts"));
    native.addFileInput(b.path("src/zig_string.ts"));
    native.addFileInput(b.path("tests/support/collections.zig"));
    native.addArtifactArg(cli.artifact("zxc"));
    native.addDirectoryArg(b.path("tests/standard/url/api"));
    native.addArg(b.graph.zig_exe);
    native.addArg(@tagName(optimize));
    native_step.dependOn(&native.step);
    step.dependOn(native_step);

    return step;
}
