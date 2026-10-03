const std = @import("std");
const compiler = @import("compiler");

pub const NativeModule = struct {
    name: []const u8,
    path: ?[]const u8 = null,
    header: ?[]const u8 = null,
    dependencies: []const []const u8 = &.{},
    bundle_files: []const []const u8 = &.{},
};

pub const NativeInterface = struct { specifier: []const u8, path: []const u8, module: []const u8, namespace: []const []const u8 = &.{} };

pub const Config = struct {
    native_interfaces: []const NativeInterface = &.{},
    packages: []const compiler.project.Package = &.{},
    externals: []const compiler.project.External = &.{},
    native_modules: []const NativeModule = &.{},
    libraries: []const []const u8 = &.{},
    include_paths: []const []const u8 = &.{},
    library_paths: []const []const u8 = &.{},
};

pub const Loaded = struct { project: compiler.project.Options, config: Config = .{} };

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8) !Loaded {
    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
    const path = try std.fs.path.resolve(allocator, &.{ cwd, config_path orelse "zxc.json" });

    const source = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024)) catch |err| {
        if (config_path == null and err == error.FileNotFound) return .{ .project = .{ .entry = try std.fs.path.resolve(allocator, &.{ cwd, entry }), .root_dir = cwd } };

        return err;
    };

    const config = try std.json.parseFromSliceLeaky(Config, allocator, source, .{ .allocate = .alloc_always });
    const root_dir = std.fs.path.dirname(path).?;

    for (config.packages, 0..) |package, index| {
        if (try compiler.project.specifier.classify(package.specifier) != .package) return error.InvalidPackageSpecifier;
        if (!std.mem.endsWith(u8, package.entry, ".zx")) return error.InvalidPackageEntry;

        for (config.packages[0..index]) |previous| {
            if (std.mem.eql(u8, previous.specifier, package.specifier)) return error.DuplicatePackage;
        }
    }

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
            .entry = try std.fs.path.resolve(allocator, &.{ cwd, entry }),
            .root_dir = root_dir,
            .packages = config.packages,
            .externals = config.externals,
            .native_interfaces = interfaces,
        },
        .config = config,
    };
}
