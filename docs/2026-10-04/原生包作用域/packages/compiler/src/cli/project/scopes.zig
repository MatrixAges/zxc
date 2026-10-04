const std = @import("std");
const compiler = @import("compiler");
const model = @import("../../package/manifest/model.zig");
const identity = @import("identity.zig");
const Inputs = @import("../watch/inputs.zig");
pub const NativeSettings = struct { name: []const u8, root: []const u8, include_paths: []const []const u8 };
pub const Result = struct { scopes: []compiler.project.PackageScope, config: model.Manifest, interfaces: []const compiler.project.NativeInterface, settings: []const NativeSettings };

pub fn load(io: std.Io, allocator: std.mem.Allocator, scopes: []const compiler.project.PackageScope, entry_root: []const u8, entry_config: model.Manifest, inputs: ?*Inputs) !Result {
    var result = Result{ .scopes = try allocator.dupe(compiler.project.PackageScope, scopes), .config = entry_config, .interfaces = &.{}, .settings = &.{} };
    var modules: std.ArrayList(model.NativeModule) = .empty;
    var declarations: std.ArrayList(model.NativeInterface) = .empty;
    var interfaces: std.ArrayList(compiler.project.NativeInterface) = .empty;
    var externals: std.ArrayList(compiler.project.External) = .empty;
    var settings: std.ArrayList(NativeSettings) = .empty;
    var libraries: std.ArrayList([]const u8) = .empty;
    var library_paths: std.ArrayList([]const u8) = .empty;

    for (result.scopes) |*scope| {
        const config = if (std.mem.eql(u8, scope.root, entry_root)) entry_config else try @import("../../package/install/model.zig").read(io, allocator, scope.root, inputs);
        const native = try @import("native.zig").load(io, allocator, scope.root, config, inputs);
        const legacy = try allocator.dupe(compiler.project.External, config.externals);

        for (native, config.native_interfaces) |*entry, original| {
            entry.identity = try identity.declaration(allocator, scope.root, entry.specifier);
            entry.module = try backendName(allocator, scope.root, entry_root, entry.module);

            var declaration = original;
            declaration.module = entry.module;
            declaration.path = entry.path;
            declaration.specifier = entry.key();

            try declarations.append(allocator, declaration);
        }

        for (legacy) |*entry| {
            entry.identity = try identity.declaration(allocator, scope.root, entry.specifier);
            entry.implementation.module = try backendName(allocator, scope.root, entry_root, entry.implementation.module);

            var published = entry.*;

            published.specifier = try identity.declaration(allocator, scope.root, entry.specifier);
            published.identity = null;

            try externals.append(allocator, published);
        }

        scope.native_interfaces = native;
        scope.externals = legacy;

        try interfaces.appendSlice(allocator, native);
        try libraries.appendSlice(allocator, config.libraries);
        for (config.library_paths) |path| try library_paths.append(allocator, try std.fs.path.resolve(allocator, &.{ scope.root, path }));

        for (config.native_modules) |original| {
            var module = original;

            module.name = try backendName(allocator, scope.root, entry_root, original.name);

            if (original.path) |path| module.path = try std.fs.path.resolve(allocator, &.{ scope.root, path });

            const dependencies = try allocator.alloc([]const u8, original.dependencies.len);

            for (original.dependencies, dependencies) |local, *dependency| {
                const separator = std.mem.indexOfScalar(u8, local, '=');
                const alias = if (separator) |index| local[0..index] else local;
                const target = if (separator) |index| local[index + 1 ..] else local;
                var found = false;

                for (config.native_modules) |candidate| if (std.mem.eql(u8, candidate.name, target)) {
                    found = true;

                    break;
                };

                if (!found) return error.UnknownNativeDependency;

                dependency.* = try std.fmt.allocPrint(allocator, "{s}={s}", .{ alias, try backendName(allocator, scope.root, entry_root, target) });
            }

            module.dependencies = dependencies;
            const includes = original.include_paths orelse config.include_paths;
            const resolved_includes = try allocator.alloc([]const u8, includes.len);

            for (includes, resolved_includes) |path, *resolved| resolved.* = try std.fs.path.resolve(allocator, &.{ scope.root, path });

            module.include_paths = resolved_includes;
            module.abi_aliases = try @import("abi_aliases.zig").resolve(allocator, scope.*, original.abi_aliases);

            for (modules.items) |previous| {
                if (std.mem.eql(u8, previous.name, module.name)) return error.DuplicateNativeModule;
            }

            try modules.append(allocator, module);
            try settings.append(allocator, .{ .name = module.name, .root = scope.root, .include_paths = config.include_paths });
        }
    }

    result.config.native_modules = try modules.toOwnedSlice(allocator);
    result.config.native_interfaces = try declarations.toOwnedSlice(allocator);
    result.config.externals = try externals.toOwnedSlice(allocator);
    result.config.libraries = try libraries.toOwnedSlice(allocator);
    result.config.library_paths = try library_paths.toOwnedSlice(allocator);
    result.interfaces = try interfaces.toOwnedSlice(allocator);
    result.settings = try settings.toOwnedSlice(allocator);

    return result;
}

fn backendName(allocator: std.mem.Allocator, owner: []const u8, entry_root: []const u8, local: []const u8) ![]const u8 {
    if (std.mem.eql(u8, owner, entry_root)) return allocator.dupe(u8, local);

    return identity.name(allocator, owner, local);
}
