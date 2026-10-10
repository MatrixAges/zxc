const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-attributes", "Validate RX string and braced expression attributes and resource cleanup");
    const check = b.addSystemCommand(&.{"node"});

    check.addFileArg(b.path("src/generate_rx_attributes.ts"));
    check.addFileInput(b.path("src/shared/catalog.ts"));
    check.addFileInput(b.path("src/shared/json.ts"));
    check.addFileInput(b.path("src/zig_string.ts"));
    check.addFileInput(b.path("tests/rx/attributes/parsing.json"));
    check.addFileInput(b.path("tests/rx/attributes/schema.json"));
    check.addFileInput(b.path("tests/rx/attributes/parsing_test.zig"));
    check.addFileInput(b.path("tests/rx/attributes/schema_test.zig"));
    check.addArg("--check");
    check.has_side_effects = true;

    step.dependOn(&check.step);

    for ([_][]const u8{ "parsing", "schema" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/rx/attributes/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "rx", .module = compiler.module("rx") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const runtime_step = b.step("test-rx-attribute-runtime", "Execute RX literal expression and extensionless path cases through the CLI");
    const runtime = b.addSystemCommand(&.{"node"});

    runtime.addFileArg(b.path("tests/rx/attributes/runtime/run_test.ts"));
    runtime.addFileInput(b.path("tests/rx/attributes/runtime/cases.json"));
    runtime.addArtifactArg(cli.artifact("zxc"));
    runtime.addDirectoryArg(b.path("tests/rx/attributes/runtime/fixtures"));
    runtime.addArg(@tagName(optimize));
    runtime_step.dependOn(&runtime.step);
    step.dependOn(runtime_step);

    const rejection_step = b.step("test-rx-attribute-rejections", "Reject empty expressions and quoted strings used as numeric RX values");
    const rejections = b.addSystemCommand(&.{"node"});

    rejections.addFileArg(b.path("tests/rx/attributes/runtime/rejection_test.ts"));
    rejections.addFileInput(b.path("tests/rx/attributes/runtime/rejections.json"));
    rejections.addArtifactArg(cli.artifact("zxc"));
    rejections.addDirectoryArg(b.path("tests/rx/attributes/runtime/fixtures"));
    rejection_step.dependOn(&rejections.step);
    runtime_step.dependOn(rejection_step);

    return step;
}
