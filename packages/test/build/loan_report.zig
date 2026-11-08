const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, stage0: []const u8) *std.Build.Step {
    const step = b.step("test-loan-source-report", "Evaluate Source loan reports over real typed IR without changing production ownership");
    const prepare = b.addSystemCommand(&.{"node"});

    prepare.addFileArg(b.path("tests/ownership/lifetimes/source_manifest.ts"));
    prepare.addFileArg(compiler.namedLazyPath("generation_manifest"));
    prepare.addDirectoryArg(b.path("tests/ownership/lifetimes/source"));

    const manifest = prepare.addOutputFileArg("loan_manifest.json");
    const tool: std.Build.LazyPath = if (stage0.len == 0) compiler.namedLazyPath("bootstrap_generator") else .{ .cwd_relative = stage0 };
    const generate = std.Build.Step.Run.create(b, "generate-loan-report");

    generate.addFileArg(tool);
    generate.addArg("--manifest");
    generate.addFileArg(manifest);

    const output = generate.addOutputDirectoryArg("loans");

    _ = generate.addOutputDirectoryArg("cache");

    generate.setEnvironmentVariable("ZXC_RESIDENT_GENERATOR", "0");
    generate.has_side_effects = true;

    const abi = b.createModule(.{ .root_source_file = output.path(b, "types.zig"), .target = target, .optimize = optimize });
    const generated = b.createModule(.{ .root_source_file = output.path(b, "root.zig"), .target = target, .optimize = optimize });

    generated.addImport("zxc_abi", abi);
    generated.addImport("zxc_standard", compiler.module("generated_standard"));

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/lifetimes/source_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "zx", .module = compiler.module("compiler").import_table.get("zx").? },
            .{ .name = "loan_report", .module = generated },
        },
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
