const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-process-entry", "Execute Process forwarding and result policies in ZX RX and Store applications");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/runtime/process_entry/run_test.ts"));
    run.addFileInput(b.path("tests/runtime/process_entry/fixture.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/runtime/process_entry/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
