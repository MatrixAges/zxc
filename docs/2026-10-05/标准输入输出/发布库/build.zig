const std = @import("std");

const Config = struct {
    native_modules: []const NativeModule,
    generated_modules: []const GeneratedModule,
    public_modules: []const GeneratedModule,
    libraries: []const []const u8,
    include_paths: []const []const u8,
    library_paths: []const []const u8,
};

const GeneratedModule = struct { name: []const u8, path: []const u8, dependencies: []const []const u8 };

const NativeModule = struct {
    name: []const u8,
    path: ?[]const u8,
    header: ?[]const u8,
    dependencies: []const []const u8,
    bundle_files: []const []const u8 = &.{},
    include_paths: ?[]const []const u8 = null,
    abi_view: ?[]const u8 = null,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const abi = b.createModule(.{ .root_source_file = b.path("abi.zig"), .target = target, .optimize = optimize });
    var modules: std.StringHashMap(*std.Build.Module) = .init(b.allocator);

    for (config.native_modules) |native| {
        const path: std.Build.LazyPath = if (native.path) |path| b.path(path) else b.path(b.fmt("native/{s}.zig", .{native.name}));
        const module = b.createModule(.{ .root_source_file = path, .target = target, .optimize = optimize, .link_libc = native.header != null });

        if (native.abi_view) |view_path| {
            const view = b.createModule(.{ .root_source_file = b.path(view_path), .target = target, .optimize = optimize });

            view.addImport("zxc_abi_canonical", abi);
            module.addImport("zxc_abi", view);
        } else module.addImport("zxc_abi", abi);

        for (native.include_paths orelse config.include_paths) |include| module.addIncludePath(if (std.fs.path.isAbsolute(include)) .{ .cwd_relative = include } else b.path(include));

        modules.put(native.name, module) catch @panic("out of memory");
    }

    for (config.generated_modules) |generated| {
        const module = b.createModule(.{ .root_source_file = b.path(generated.path), .target = target, .optimize = optimize });

        module.addImport("zxc_abi", abi);
        modules.put(generated.name, module) catch @panic("out of memory");
    }

    for (config.generated_modules) |generated| {
        const module = modules.get(generated.name).?;

        for (generated.dependencies) |dependency| module.addImport(dependency, modules.get(dependency) orelse @panic("unknown generated dependency"));
    }

    for (config.native_modules) |native| {
        const module = modules.get(native.name).?;

        for (native.dependencies) |dependency| {
            const separator = std.mem.indexOfScalar(u8, dependency, '=');
            const alias = if (separator) |index| dependency[0..index] else dependency;
            const target_name = if (separator) |index| dependency[index + 1 ..] else dependency;

            module.addImport(alias, modules.get(target_name) orelse @panic("unknown native dependency"));
        }
    }

    for (config.public_modules) |public_module| {
        const module = b.addModule(public_module.name, .{ .root_source_file = b.path(public_module.path), .target = target, .optimize = optimize });

        module.addImport("zxc_abi", abi);

        for (public_module.dependencies) |dependency| module.addImport(dependency, modules.get(dependency) orelse @panic("unknown public module dependency"));
        for (config.libraries) |name| module.linkSystemLibrary(name, .{});
        for (config.library_paths) |path| module.addLibraryPath(.{ .cwd_relative = path });
    }
}

const config: Config = .{
    .native_modules = &.{
        .{ .name = "zxc_standard", .path = "native/zxc_standard/source/root.zig", .header = null, .dependencies = &.{ }, .bundle_files = &.{ }, .include_paths = &.{ }, .abi_view = null },
    },
    .generated_modules = &.{
        .{ .name = "zxc_module_58eb6b9cdffa2d7d9498d71bdfe963fe0c62ded514e8d0c644681f82dda9ea75", .path = "modules/zxc_module_58eb6b9cdffa2d7d9498d71bdfe963fe0c62ded514e8d0c644681f82dda9ea75.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_2bb5f38081ced26c69680c53438a65891c7046ed50660d84961bc392964e31ea", .path = "modules/zxc_module_2bb5f38081ced26c69680c53438a65891c7046ed50660d84961bc392964e31ea.zig", .dependencies = &.{ "zxc_module_58eb6b9cdffa2d7d9498d71bdfe963fe0c62ded514e8d0c644681f82dda9ea75", } },
        .{ .name = "zxc_module_85f53cf866651ba5d4bd74ce1e90db419ddb409cf1b0c192451854c18c3534f7", .path = "modules/zxc_module_85f53cf866651ba5d4bd74ce1e90db419ddb409cf1b0c192451854c18c3534f7.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_d93132c09e25e34bbf9a89283296d0e7c07e1fe4b0f25356a2a986c6b2b5efc0", .path = "modules/zxc_module_d93132c09e25e34bbf9a89283296d0e7c07e1fe4b0f25356a2a986c6b2b5efc0.zig", .dependencies = &.{ "zxc_module_85f53cf866651ba5d4bd74ce1e90db419ddb409cf1b0c192451854c18c3534f7", } },
    },
    .public_modules = &.{
        .{ .name = "library", .path = "root.zig", .dependencies = &.{ "zxc_module_2bb5f38081ced26c69680c53438a65891c7046ed50660d84961bc392964e31ea", "zxc_module_d93132c09e25e34bbf9a89283296d0e7c07e1fe4b0f25356a2a986c6b2b5efc0", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
