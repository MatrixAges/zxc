const std = @import("std");
const references = @import("native_references.zig");
const artifacts = @import("artifacts.zig");
const NativeModule = @import("project.zig").NativeModule;
pub const collect = @import("native_sources/collect.zig");
pub const File = struct { path: []const u8, kind: references.Kind, sha256: []const u8, referenced_from: ?[]const u8 };
pub const Include = struct { source: []const u8, destination: []const u8 };
const Includes = struct { paths: []const []const u8, relocations: []const Include };
pub const Result = struct { entry: ?[]const u8, include_paths: []const []const u8, include_relocations: []const Include, files: []const File, dynamic_resources: bool, c_imports: bool };

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, project_root: []const u8, module: NativeModule) !Result {
    return writeWithInputs(io, allocator, directory, project_root, module, null);
}

pub fn writeWithInputs(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, project_root: []const u8, module: NativeModule, inputs: ?*@import("watch/inputs.zig")) !Result {
    if (module.header) |header| {
        if (std.fs.path.isAbsolute(header)) return error.AbsoluteNativeHeaderCannotBeBundled;
    }

    const root = if (module.path) |path| std.fs.path.dirname(try std.fs.path.resolve(allocator, &.{ project_root, path })).? else try std.fs.path.resolve(allocator, &.{project_root});
    const output_root = try std.fs.path.resolve(allocator, &.{directory});

    const physical_output = std.Io.Dir.cwd().realPathFileAlloc(io, output_root, allocator) catch |err| switch (err) {
        error.FileNotFound => null,
        else => return err,
    };

    for (module.bundle_files) |path| {
        const resource_path = try collect.referencedPath(allocator, root, root, path);
        const relative = try std.fs.path.relative(allocator, resource_path, null, resource_path, output_root);

        if (within(relative)) return error.NativeBundleContainsOutput;

        if (physical_output) |output_path| {
            if (inputs) |observed| try observed.add(io, resource_path);

            const canonical = try std.Io.Dir.cwd().realPathFileAlloc(io, resource_path, allocator);
            const physical_relative = try std.fs.path.relative(allocator, canonical, null, canonical, output_path);

            if (within(physical_relative)) return error.NativeBundleContainsOutput;
        }
    }

    const source = try collect.read(io, allocator, project_root, module, inputs);
    const destination = try std.fs.path.join(allocator, &.{ "native", module.name, "source" });
    const includes = try relocateIncludes(io, allocator, project_root, source, destination, module.include_paths orelse &.{}, inputs);
    const files = try allocator.alloc(File, source.files.len);

    for (source.files, files) |file, *output| {
        const target = try std.fs.path.join(allocator, &.{ destination, file.path });
        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(file.bytes, &digest, .{});

        const hex = std.fmt.bytesToHex(digest, .lower);

        try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, target }), file.bytes);

        output.* = .{
            .path = target,
            .kind = file.kind,
            .sha256 = try allocator.dupe(u8, &hex),
            .referenced_from = if (file.referenced_from) |path| try std.fs.path.join(allocator, &.{ destination, path }) else null,
        };
    }

    return .{
        .entry = if (source.entry) |entry| try std.fs.path.join(allocator, &.{ destination, entry }) else null,
        .include_paths = includes.paths,
        .include_relocations = includes.relocations,
        .files = files,
        .dynamic_resources = source.dynamic_resources,
        .c_imports = source.c_imports,
    };
}

fn relocateIncludes(io: std.Io, allocator: std.mem.Allocator, project_root: []const u8, source: collect.Result, destination: []const u8, paths: []const []const u8, inputs: ?*@import("watch/inputs.zig")) !Includes {
    const relocated = try allocator.alloc([]const u8, paths.len);
    var relocations: std.ArrayList(Include) = .empty;

    for (paths, relocated) |path, *result| {
        const absolute = try std.fs.path.resolve(allocator, &.{ project_root, path });
        const relative = try std.fs.path.relative(allocator, source.root, null, source.root, absolute);
        var bundled = false;

        if (within(relative)) for (source.files) |file| {
            if (file.kind != .asset) continue;

            const root = std.mem.eql(u8, relative, ".") or relative.len == 0;
            const child = std.mem.startsWith(u8, file.path, relative) and file.path.len > relative.len and std.fs.path.isSep(file.path[relative.len]);

            if (root or child) bundled = true;
        };

        if (bundled) {
            for (try @import("native_sources/resources.zig").files(io, allocator, absolute, inputs)) |path_to_file| {
                const resource = try std.fs.path.relative(allocator, source.root, null, source.root, path_to_file);
                var found = false;

                for (source.files) |file| {
                    if (std.mem.eql(u8, file.path, resource)) found = true;
                }

                if (!found) return error.IncompleteNativeIncludeBundle;
            }
        }

        result.* = if (bundled) try std.fs.path.join(allocator, &.{ destination, relative }) else absolute;

        if (bundled) try relocations.append(allocator, .{ .source = relative, .destination = result.* });
    }

    return .{ .paths = relocated, .relocations = relocations.items };
}

fn within(path: []const u8) bool {
    return !std.fs.path.isAbsolute(path) and !std.mem.eql(u8, path, "..") and !std.mem.startsWith(u8, path, ".." ++ std.fs.path.sep_str);
}
