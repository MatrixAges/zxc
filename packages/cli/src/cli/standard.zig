const std = @import("std");
const compiler = @import("compiler");
const project = @import("project.zig");
const bytes_backend = "zxc.std.bytes";

const backends = [_]struct { name: []const u8, path: []const u8 }{
    .{ .name = "sha256_backend", .path = "src/crypto/sha256.zig" },
    .{ .name = bytes_backend, .path = "src/bytes/fast.zig" },
};

const standard_dependencies: []const []const u8 = &.{ backends[0].name, "bytes_backend=" ++ bytes_backend };

pub fn resolve(allocator: std.mem.Allocator, loaded: project.Loaded, dependencies: []const []const u8, standard_root: []const u8) !project.Loaded {
    var modules: std.ArrayList(project.NativeModule) = .empty;

    try modules.appendSlice(allocator, loaded.config.native_modules);

    for (compiler.project.standard) |standard| {
        var required = false;

        for (dependencies) |dependency| {
            if (std.mem.eql(u8, dependency, standard.module)) required = true;
        }

        for (modules.items) |module| {
            if (std.mem.eql(u8, module.name, standard.module)) required = false;
        }

        if (!required) continue;

        const path = try std.fs.path.resolve(allocator, &.{ standard_root, standard.implementation_path });
        const needs_backends = std.mem.eql(u8, standard.module, "zxc_standard");
        const backend_dependencies: []const []const u8 = if (needs_backends) standard_dependencies else &.{};

        if (needs_backends) {
            for (backends) |backend| {
                for (modules.items) |module| {
                    if (std.mem.eql(u8, module.name, backend.name)) return error.ReservedNativeModule;
                }
            }
        }

        try modules.append(allocator, .{ .name = standard.module, .path = path, .dependencies = backend_dependencies });

        if (needs_backends) {
            for (backends) |backend| {
                const source = try std.fs.path.resolve(allocator, &.{ standard_root, backend.path });

                try modules.append(allocator, .{ .name = backend.name, .path = source });
            }
        }
    }

    var result = loaded;

    result.config.native_modules = modules.items;

    return result;
}
