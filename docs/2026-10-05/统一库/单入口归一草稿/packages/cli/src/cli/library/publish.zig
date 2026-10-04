const std = @import("std");
const compiler = @import("compiler");
const Loaded = @import("../project.zig").Loaded;
const Inputs = @import("../watch/inputs.zig");
const artifacts = @import("../artifacts.zig");
const config_writer = @import("../library_config.zig");

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, library: *const compiler.library.Result, bundle: compiler.zig.LibraryBundle, loaded: Loaded, inputs: ?*Inputs) !void {
    const abi = try @import("../abi.zig").createLibrary(allocator, bundle, loaded);
    var resources_input = loaded;

    resources_input.config.native_interfaces = &.{};
    resources_input.config.externals = &.{};
    resources_input.project.native_interfaces = &.{};
    const resources = try @import("resources.zig").write(io, allocator, directory, resources_input, inputs);
    var config = resources.config;
    const exports = try allocator.alloc(@import("../../package/manifest/model.zig").Export, library.exports.len);

    for (library.exports, exports) |exported, *entry| entry.* = .{ .path = exported.name, .module = exported.name };

    config.entry = null;
    config.library = "library.zxcir";
    config.exports = exports;
    config.dependencies = &.{};
    config.dev_dependencies = &.{};
    config.workspace = null;

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "library.zxcir" }), try compiler.library.codec.encode(allocator, library));
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "abi.zig" }), abi.source);
    for (abi.views) |view| try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, view.path }), view.source);

    var generated: std.ArrayList(config_writer.GeneratedModule) = .empty;
    var public: std.ArrayList(config_writer.GeneratedModule) = .empty;

    for (bundle.modules) |module| {
        const path = try std.fmt.allocPrint(allocator, "modules/{s}.zig", .{module.name});

        try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, path }), module.source);
        try generated.append(allocator, .{ .name = module.name, .path = path, .dependencies = module.imports });
    }

    for (bundle.public_modules) |module| {
        const single = loaded.config.exports.len == 0;
        const path = if (single) "root.zig" else try std.fmt.allocPrint(allocator, "public/{s}.zig", .{module.file.name});
        const name = if (single) "library" else module.name;

        for (public.items) |previous| if (std.mem.eql(u8, previous.name, name)) return error.ConflictingModuleName;
        try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, path }), module.file.source);
        try public.append(allocator, .{ .name = name, .path = path, .dependencies = module.file.imports });
    }

    var manifest: std.Io.Writer.Allocating = .init(allocator);

    try @import("../../package/manifest/write.zig").write(&manifest.writer, config);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "pkg.yaml" }), manifest.written());

    var build_source: std.Io.Writer.Allocating = .init(allocator);

    try build_source.writer.writeAll(@embedFile("../library_build.zig"));
    try config_writer.writePublic(&build_source.writer, config, public.items, generated.items, abi.views);
    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "build.zig" }), build_source.written());

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "library.json" }), try std.json.Stringify.valueAlloc(allocator, .{
        .format_version = 2,
        .library = config.library,
        .ir_version = @import("zx").ir_version,
        .public_modules = public.items,
        .native_sources_bundled = resources.bundled_files.len != 0,
        .bundled_files = resources.bundled_files,
        .native_dependencies = resources.dependencies,
        .generated_modules = generated.items,
        .external_build_requirements = .{ .libraries = config.libraries, .include_paths = resources.external_includes, .library_paths = config.library_paths },
    }, .{ .whitespace = .indent_2 }));
}
