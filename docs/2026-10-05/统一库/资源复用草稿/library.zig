const std = @import("std");
const compiler = @import("compiler");
const Options = @import("options.zig").Options;
const project_config = @import("project.zig");
const artifacts = @import("artifacts.zig");

pub fn runWithInputs(io: std.Io, allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, sources: []const compiler.project.Source, options: Options, loaded: project_config.Loaded, cache: *compiler.project.ParseCache, inputs: ?*@import("watch/inputs.zig")) !void {
    if (loaded.config.exports.len != 0) return error.PublicModuleLibraryBuildNotIntegrated;

    const directory = options.output.?;
    const abi = try @import("abi.zig").create(allocator, bundle, loaded);
    const resources = try @import("library/resources.zig").write(io, allocator, directory, loaded, inputs);
    var config = resources.config;
    config.entry = "source/module_0.zx";
    config.dependencies = &.{};
    config.dev_dependencies = &.{};
    config.workspace = null;

    try @import("library_sources.zig").write(io, allocator, directory, sources, loaded.project, cache);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), abi.source);
    for (abi.views) |view| try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, view.path }), view.source);
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
    try @import("library_config.zig").write(&build_source.writer, config, bundle.entry.imports, generated.items, abi.views);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "build.zig" }), build_source.written());

    const retired = try @import("library_resources.zig").retired(io, allocator, directory, resources.bundled_files, inputs);

    try @import("library_resources.zig").remove(io, retired);

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "library.json" }), try std.json.Stringify.valueAlloc(allocator, .{
        .format_version = 1,
        .zig_module = "library",
        .zig_entry = "root.zig",
        .zx_entry = "source/module_0.zx",
        .ir_version = @import("zx").ir_version,
        .native_sources_bundled = resources.bundled_files.len != 0,
        .bundled_files = resources.bundled_files,
        .native_dependencies = resources.dependencies,
        .generated_modules = generated.items,
        .entry_dependencies = bundle.entry.imports,
        .external_build_requirements = .{ .libraries = config.libraries, .include_paths = resources.external_includes, .library_paths = config.library_paths },
    }, .{ .whitespace = .indent_2 }));
}
