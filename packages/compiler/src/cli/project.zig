const std = @import("std");
const compiler = @import("compiler");
const model = @import("../package/manifest/model.zig");
const manifest = @import("../package/manifest.zig");
pub const NativeModule = model.NativeModule;
pub const NativeInterface = model.NativeInterface;
pub const Config = model.Manifest;
pub const Loaded = struct { project: compiler.project.Options, config: Config = .{ .name = "", .version = "" }, diagnostic: ?[]const u8 = null };

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8) !Loaded {
    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
    const source_path = try std.fs.path.resolve(allocator, &.{ cwd, entry });
    const packages = try @import("../package/project.zig").load(io, allocator, source_path, config_path);
    var loaded = Loaded{ .project = .{ .entry = packages.entry orelse source_path, .root_dir = cwd, .package_scopes = packages.scopes }, .diagnostic = packages.diagnostic };

    if (loaded.diagnostic != null) return loaded;

    const path = packages.manifest_path orelse return loaded;
    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024));
    const parsed = try manifest.parse(allocator, source);

    const config = switch (parsed.value) {
        .data => |data| data,
        .diagnostic => |issue| {
            loaded.diagnostic = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: manifest: {s}", .{ path, issue.line, issue.column, issue.message });

            return loaded;
        },
    };

    const root_dir = std.fs.path.dirname(path).?;

    for (config.externals) |external| {
        const kind = try compiler.project.specifier.classify(external.specifier);

        if (kind != .zig and kind != .c and kind != .legacy_library) return error.InvalidExternalSpecifier;
    }

    const interfaces = try allocator.alloc(compiler.project.NativeInterface, config.native_interfaces.len);

    for (config.native_interfaces, interfaces) |declaration, *interface| {
        const kind = try compiler.project.specifier.classify(declaration.specifier);

        if (kind == .file or kind == .package) return error.InvalidExternalSpecifier;
        if (!std.mem.endsWith(u8, declaration.path, ".d.zx")) return error.InvalidNativeInterfacePath;

        const interface_path = try std.fs.path.resolve(allocator, &.{ root_dir, declaration.path });

        interface.* = .{
            .specifier = declaration.specifier,
            .path = interface_path,
            .source = try std.Io.Dir.cwd().readFileAlloc(io, interface_path, allocator, .limited(16 * 1024 * 1024)),
            .module = declaration.module,
            .namespace = declaration.namespace,
        };
    }

    for (config.native_modules, 0..) |module, index| {
        const sources = @as(u8, @intFromBool(module.path != null)) + @as(u8, @intFromBool(module.header != null));

        if (module.name.len == 0 or sources != 1) return error.InvalidNativeModule;
        if (module.bundle_files.len != 0 and module.path == null) return error.InvalidNativeBundleFiles;

        for (module.name) |byte| {
            if (!std.ascii.isAlphanumeric(byte) and byte != '_' and byte != '-') return error.InvalidNativeModule;
        }

        for ([_][]const u8{ "std", "builtin", "root", "application", "zxc_abi", "zx_runtime" }) |reserved| {
            if (std.mem.eql(u8, module.name, reserved)) return error.ReservedNativeModule;
        }

        for (config.native_modules[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, module.name)) return error.DuplicateNativeModule;
        }
    }

    return .{
        .project = .{
            .entry = loaded.project.entry,
            .root_dir = root_dir,
            .package_scopes = packages.scopes,
            .externals = config.externals,
            .native_interfaces = interfaces,
        },
        .config = config,
    };
}
