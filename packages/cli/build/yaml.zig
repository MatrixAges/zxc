const std = @import("std");

/// Gives `consumer` the libyaml declarations and returns the library for the final artifact to link; linking it
/// into a separately compiled object would merge it there and drop that object's debug information.
pub fn link(b: *std.Build, consumer: *std.Build.Module, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step.Compile {
    const source = b.dependency("libyaml", .{});

    b.addNamedLazyPath("yaml_license", source.path("License"));

    const module = b.createModule(.{ .target = target, .optimize = optimize, .link_libc = true });
    const library = b.addLibrary(.{ .name = "yaml", .linkage = .static, .root_module = module });

    module.addIncludePath(source.path("include"));

    module.addCSourceFiles(.{
        .root = source.path(""),
        .files = &.{ "src/api.c", "src/reader.c", "src/scanner.c", "src/parser.c", "src/loader.c", "src/writer.c", "src/emitter.c", "src/dumper.c" },
        .flags = &.{ "-DYAML_DECLARE_STATIC", "-DYAML_VERSION_MAJOR=0", "-DYAML_VERSION_MINOR=2", "-DYAML_VERSION_PATCH=5", "-DYAML_VERSION_STRING=\"0.2.5\"" },
    });

    const translated = b.addTranslateC(.{ .root_source_file = source.path("include/yaml.h"), .target = target, .optimize = optimize });

    translated.defineCMacro("YAML_DECLARE_STATIC", "1");

    if (target.result.os.tag == .windows) translated.defineCMacro("_FORTIFY_SOURCE", "0");

    consumer.addImport("yaml", translated.createModule());

    const license = b.addInstallFile(source.path("License"), "share/zxc/licenses/libyaml.txt");

    b.getInstallStep().dependOn(&license.step);

    return library;
}
