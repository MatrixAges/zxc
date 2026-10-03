const std = @import("std");

pub fn link(b: *std.Build, executable: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) void {
    const source = b.dependency("libyaml", .{});
    const module = b.createModule(.{ .target = target, .optimize = optimize, .link_libc = true });
    const library = b.addLibrary(.{ .name = "yaml", .linkage = .static, .root_module = module });

    module.addIncludePath(source.path("include"));

    module.addCSourceFiles(.{
        .root = source.path(""),
        .files = &.{ "src/api.c", "src/reader.c", "src/scanner.c", "src/parser.c", "src/loader.c", "src/writer.c", "src/emitter.c", "src/dumper.c" },
        .flags = &.{ "-DYAML_DECLARE_STATIC", "-DYAML_VERSION_MAJOR=0", "-DYAML_VERSION_MINOR=2", "-DYAML_VERSION_PATCH=5", "-DYAML_VERSION_STRING=\"0.2.5\"" },
    });

    executable.root_module.addIncludePath(source.path("include"));
    executable.root_module.linkLibrary(library);

    const license = b.addInstallFile(source.path("License"), "share/zxc/licenses/libyaml.txt");

    b.getInstallStep().dependOn(&license.step);
}
