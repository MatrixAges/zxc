const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-package-manifest-resources", "Validate manifest exports ownership serialization and allocation failures");
    const files = b.addWriteFiles();
    const root = files.add("root.zig", "pub const parse = @import(\"manifest.zig\").parse;\npub const write = @import(\"manifest/write.zig\").write;\n");
    _ = files.addCopyFile(cli.path("src/package/manifest.zig"), "manifest.zig");
    _ = files.addCopyDirectory(cli.path("src/package/manifest"), "manifest", .{});

    const yaml = cli.builder.dependency("libyaml", .{});
    const manifest = b.createModule(.{
        .root_source_file = root,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "pkgs", .module = b.dependency("pkgs", .{ .target = target, .optimize = optimize }).module("pkgs") },
        },
    });

    manifest.addIncludePath(yaml.path("include"));

    const yaml_module = b.createModule(.{ .target = target, .optimize = optimize, .link_libc = true });
    yaml_module.addIncludePath(yaml.path("include"));
    yaml_module.addCSourceFiles(.{
        .root = yaml.path(""),
        .files = &.{ "src/api.c", "src/reader.c", "src/scanner.c", "src/parser.c", "src/loader.c", "src/writer.c", "src/emitter.c", "src/dumper.c" },
        .flags = &.{ "-DYAML_DECLARE_STATIC", "-DYAML_VERSION_MAJOR=0", "-DYAML_VERSION_MINOR=2", "-DYAML_VERSION_PATCH=5", "-DYAML_VERSION_STRING=\"0.2.5\"" },
    });

    const library = b.addLibrary(.{ .name = "manifest-test-yaml", .linkage = .static, .root_module = yaml_module });
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/package_manifest/resources/exports_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "manifest", .module = manifest }},
    }) });

    tests.root_module.linkLibrary(library);
    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
