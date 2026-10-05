const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-idna", "Validate Unicode18 nontransitional IDNA profile and allocation cleanup");
    const files = b.addWriteFiles();
    _ = files.addCopyFile(b.path("upstream/unicode/18.0.0/IdnaTestV2.txt"), "IdnaTestV2.txt");

    const data = b.createModule(.{
        .root_source_file = files.add("data.zig", "pub const text = @embedFile(\"IdnaTestV2.txt\");\n"),
        .target = target,
        .optimize = optimize,
    });

    const implementation = b.createModule(.{
        .root_source_file = compiler.path("standard/src/url/host/idna/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "corpus", "resources" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/url/idna/conformance/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "implementation", .module = implementation }, .{ .name = "idna_data", .module = data } },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
