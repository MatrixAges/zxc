const std = @import("std");
const references = @import("native_references.zig");
const artifacts = @import("artifacts.zig");
const NativeModule = @import("project.zig").NativeModule;
pub const collect = @import("native_sources/collect.zig");
pub const File = struct { path: []const u8, kind: references.Kind, sha256: []const u8, referenced_from: ?[]const u8 };
pub const Result = struct { entry: []const u8, files: []const File, dynamic_resources: bool, c_imports: bool };

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, project_root: []const u8, module: NativeModule) !Result {
    return writeWithInputs(io, allocator, directory, project_root, module, null);
}

pub fn writeWithInputs(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, project_root: []const u8, module: NativeModule, inputs: ?*@import("watch/inputs.zig")) !Result {
    const source = try collect.read(io, allocator, project_root, module, inputs);
    const destination = try std.fs.path.join(allocator, &.{ "native", module.name, "source" });
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
        .entry = try std.fs.path.join(allocator, &.{ destination, source.entry }),
        .files = files,
        .dynamic_resources = source.dynamic_resources,
        .c_imports = source.c_imports,
    };
}
