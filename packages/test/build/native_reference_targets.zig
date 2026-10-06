const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-references-targets", "Validate native reference application interfaces in CLI Wasm and WASI builds");
    const directory = "tests/native/references/targets";
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path(directory ++ "/run_test.ts"));
    run.addFileInput(b.path(directory ++ "/fixture.ts"));
    run.addFileInput(b.path(directory ++ "/scalar.ts"));
    run.addFileInput(b.path("tests/targets/wasm/host.ts"));
    run.addFileInput(b.path("tests/targets/wasm/wasi_host.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path(directory ++ "/fixtures"));
    run.addArg(@tagName(optimize));

    _ = run.addOutputFileArg("application-targets.json");
    run.has_side_effects = true;

    step.dependOn(&run.step);

    return step;
}
