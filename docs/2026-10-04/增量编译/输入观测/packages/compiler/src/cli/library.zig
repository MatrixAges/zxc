const std = @import("std");
const compiler = @import("compiler");
const Options = @import("options.zig").Options;
const project_config = @import("project.zig");
const artifacts = @import("artifacts.zig");
const native_sources = @import("native_sources.zig");
const Dependency = struct { name: []const u8, header: ?[]const u8, c_imports: bool = false, dynamic_resources: bool = false };

pub fn run(io: std.Io, allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, sources: []const compiler.project.Source, options: Options, loaded: project_config.Loaded, cache: *compiler.project.ParseCache) !void {
    return runWithInputs(io, allocator, bundle, sources, options, loaded, cache, null);
}

pub fn runWithInputs(io: std.Io, allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, sources: []const compiler.project.Source, options: Options, loaded: project_config.Loaded, cache: *compiler.project.ParseCache, inputs: ?*@import("watch/inputs.zig")) !void {
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

    if (config.name.len == 0) config.name = "library";
    if (config.version.len == 0) config.version = "0.0.0";

    config.entry = "source/module_0.zx";
    config.dependencies = &.{};
    config.dev_dependencies = &.{};
    config.workspace = null;
    config.include_paths = try absolutePaths(allocator, loaded.project.root_dir, config.include_paths);
    config.library_paths = try absolutePaths(allocator, loaded.project.root_dir, config.library_paths);
    var bundled_files: std.ArrayList(native_sources.File) = .empty;
    var dependencies: std.ArrayList(Dependency) = .empty;

    for (native_modules) |*native| {
        var dependency = Dependency{ .name = native.name, .header = native.header };

        if (native.path != null) {
            const bundled = try native_sources.writeWithInputs(io, allocator, directory, loaded.project.root_dir, native.*, inputs);
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

    try @import("library_sources.zig").write(io, allocator, directory, sources, loaded.project, cache);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), bundle.types);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "root.zig" }), bundle.entry.source);

    var generated: std.ArrayList(@import("library_config.zig").GeneratedModule) = .empty;

    for (bundle.modules) |module| {
        const path = try std.fmt.allocPrint(allocator, "modules/{s}.zig", .{module.name});

        try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, path }), module.source);
        try generated.append(allocator, .{ .name = module.name, .path = path, .dependencies = module.imports });
    }

    var manifest: std.Io.Writer.Allocating = .init(allocator);

    try @import("../package/manifest/write.zig").write(&manifest.writer, config);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "pkg.yaml" }), manifest.written());

    var build_source: std.Io.Writer.Allocating = .init(allocator);

    try build_source.writer.writeAll(@embedFile("library_build.zig"));
    try @import("library_config.zig").write(&build_source.writer, config, bundle.entry.imports, generated.items);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "build.zig" }), build_source.written());

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "library.json" }), try std.json.Stringify.valueAlloc(allocator, .{
        .format_version = 1,
        .zig_module = "library",
        .zig_entry = "root.zig",
        .zx_entry = "source/module_0.zx",
        .ir_version = @import("zx").ir_version,
        .native_sources_bundled = bundled_files.items.len != 0,
        .bundled_files = bundled_files.items,
        .native_dependencies = dependencies.items,
        .generated_modules = generated.items,
        .entry_dependencies = bundle.entry.imports,
        .external_build_requirements = .{ .libraries = config.libraries, .include_paths = config.include_paths, .library_paths = config.library_paths },
    }, .{ .whitespace = .indent_2 }));
}

fn absolutePaths(allocator: std.mem.Allocator, root: []const u8, paths: []const []const u8) ![]const []const u8 {
    const result = try allocator.alloc([]const u8, paths.len);

    for (paths, result) |path, *absolute| absolute.* = try std.fs.path.resolve(allocator, &.{ root, path });

    return result;
}
