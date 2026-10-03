const std = @import("std");
const compiler = @import("compiler");
const Options = @import("options.zig").Options;
const project_config = @import("project.zig");
const artifacts = @import("artifacts.zig");
const native_sources = @import("native_sources.zig");
const Dependency = struct { name: []const u8, header: ?[]const u8, c_imports: bool = false, dynamic_resources: bool = false };

pub fn run(io: std.Io, allocator: std.mem.Allocator, source: []const u8, types: []const u8, sources: []const compiler.project.Source, options: Options, loaded: project_config.Loaded) !void {
    const directory = options.output.?;
    var config = loaded.config;
    const native_modules = try allocator.dupe(project_config.NativeModule, config.native_modules);
    config.native_modules = native_modules;

    const interfaces = try allocator.dupe(project_config.NativeInterface, config.native_interfaces);

    for (interfaces, loaded.project.native_interfaces, 0..) |*entry, interface, index| {
        entry.path = try std.fmt.allocPrint(allocator, "interfaces/module_{d}.d.zx", .{index});

        try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, entry.path }), interface.source);
    }

    config.native_interfaces = interfaces;
    config.packages = &.{.{ .specifier = "library", .entry = "source/module_0.zx" }};
    config.include_paths = try absolutePaths(allocator, loaded.project.root_dir, config.include_paths);
    config.library_paths = try absolutePaths(allocator, loaded.project.root_dir, config.library_paths);
    var bundled_files: std.ArrayList(native_sources.File) = .empty;
    var dependencies: std.ArrayList(Dependency) = .empty;

    for (native_modules) |*native| {
        var dependency = Dependency{ .name = native.name, .header = native.header };

        if (native.path != null) {
            const bundled = try native_sources.write(io, allocator, directory, loaded.project.root_dir, native.*);
            native.path = bundled.entry;
            dependency.c_imports = bundled.c_imports;
            dependency.dynamic_resources = bundled.dynamic_resources;

            try bundled_files.appendSlice(allocator, bundled.files);
        }

        try dependencies.append(allocator, dependency);

        if (native.header) |header| {
            const path = try std.fmt.allocPrint(allocator, "{s}/native/{s}.zig", .{ directory, native.name });
            const text = try std.fmt.allocPrint(allocator, "pub const c = @cImport({{ @cInclude(\"{f}\"); }});\n", .{std.zig.fmtString(header)});

            try artifacts.write(io, path, text);
        }
    }

    try @import("library_sources.zig").write(io, allocator, directory, sources, loaded.project);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), types);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "root.zig" }), source);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "build.zig" }), @embedFile("library_build.zig"));
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "zxc.json" }), try std.json.Stringify.valueAlloc(allocator, config, .{ .whitespace = .indent_2 }));

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "library.json" }), try std.json.Stringify.valueAlloc(allocator, .{
        .format_version = 1,
        .zig_module = "library",
        .zig_entry = "root.zig",
        .zx_entry = "source/module_0.zx",
        .ir_version = @import("zx").ir_version,
        .native_sources_bundled = bundled_files.items.len != 0,
        .bundled_files = bundled_files.items,
        .native_dependencies = dependencies.items,
        .external_build_requirements = .{ .libraries = config.libraries, .include_paths = config.include_paths, .library_paths = config.library_paths },
    }, .{ .whitespace = .indent_2 }));
}

fn absolutePaths(allocator: std.mem.Allocator, root: []const u8, paths: []const []const u8) ![]const []const u8 {
    const result = try allocator.alloc([]const u8, paths.len);

    for (paths, result) |path, *absolute| absolute.* = try std.fs.path.resolve(allocator, &.{ root, path });

    return result;
}
