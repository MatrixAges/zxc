const std = @import("std");

const Config = struct {
    native_modules: []const NativeModule,
    libraries: []const []const u8,
    include_paths: []const []const u8,
    library_paths: []const []const u8,
};

const NativeModule = struct {
    name: []const u8,
    path: ?[]const u8,
    header: ?[]const u8,
    dependencies: []const []const u8,
    bundle_files: []const []const u8 = &.{},
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const config = std.json.parseFromSliceLeaky(Config, b.allocator, @embedFile("zxc.json"), .{ .ignore_unknown_fields = true }) catch @panic("invalid library configuration");
    const library = b.addModule("library", .{ .root_source_file = b.path("root.zig"), .target = target, .optimize = optimize });
    const abi = b.createModule(.{ .root_source_file = b.path("abi.zig"), .target = target, .optimize = optimize });

    library.addImport("zxc_abi", abi);

    var modules: std.StringHashMap(*std.Build.Module) = .init(b.allocator);

    for (config.native_modules) |native| {
        const path: std.Build.LazyPath = if (native.path) |path| b.path(path) else b.path(b.fmt("native/{s}.zig", .{native.name}));
        const module = b.createModule(.{ .root_source_file = path, .target = target, .optimize = optimize, .link_libc = native.header != null });

        module.addImport("zxc_abi", abi);

        for (config.include_paths) |include| module.addIncludePath(.{ .cwd_relative = include });

        library.addImport(native.name, module);
        modules.put(native.name, module) catch @panic("out of memory");
    }

    for (config.native_modules) |native| {
        const module = modules.get(native.name).?;

        for (native.dependencies) |dependency| module.addImport(dependency, modules.get(dependency) orelse @panic("unknown native dependency"));
    }

    for (config.libraries) |name| library.linkSystemLibrary(name, .{});
    for (config.library_paths) |path| library.addLibraryPath(.{ .cwd_relative = path });
}
