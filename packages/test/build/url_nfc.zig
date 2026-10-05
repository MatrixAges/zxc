const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-nfc", "Validate Unicode18 NFC official conformance and allocation cleanup");
    const files = b.addWriteFiles();
    _ = files.addCopyFile(b.path("upstream/unicode/18.0.0/NormalizationTest.txt"), "NormalizationTest.txt");
    _ = files.addCopyFile(b.path("upstream/unicode/18.0.0/UnicodeData.txt"), "UnicodeData.txt");

    const data = b.createModule(.{
        .root_source_file = files.add("data.zig", "pub const normalization = @embedFile(\"NormalizationTest.txt\");\npub const unicode = @embedFile(\"UnicodeData.txt\");\n"),
        .target = target,
        .optimize = optimize,
    });

    const implementation = b.createModule(.{
        .root_source_file = compiler.path("standard/src/url/host/idna/nfc.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "nfc", "nfc_identity", "nfc_resource" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/url/idna/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "implementation", .module = implementation }, .{ .name = "normalization_data", .module = data } },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
