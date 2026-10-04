const std = @import("std");
const compiler = @import("compiler");
const Inputs = @import("../watch/inputs.zig");
const Config = @import("../../package/manifest/model.zig").Manifest;

pub fn load(io: std.Io, allocator: std.mem.Allocator, root_dir: []const u8, config: Config, inputs: ?*Inputs) ![]compiler.project.NativeInterface {
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

        if (inputs) |observed| try observed.add(io, interface_path);

        const interface_source = try std.Io.Dir.cwd().readFileAlloc(io, interface_path, allocator, .limited(16 * 1024 * 1024));

        if (inputs) |observed| try observed.record(io, interface_path, interface_source);

        interface.* = .{
            .specifier = declaration.specifier,
            .path = interface_path,
            .source = interface_source,
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

    return interfaces;
}
