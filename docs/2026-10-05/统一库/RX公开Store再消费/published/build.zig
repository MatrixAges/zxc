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
    },
    .generated_modules = &.{
        .{ .name = "zxc_module_5b36e241c4067c3e911e0b6eb63afc9193e11f3a3f7c7961379e0b2b58ee87a2", .path = "modules/zxc_module_5b36e241c4067c3e911e0b6eb63afc9193e11f3a3f7c7961379e0b2b58ee87a2.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_372d7cc3d254a4b7980e5027b1768b491adfdb995fc288800f32de7dd9435929", .path = "modules/zxc_module_372d7cc3d254a4b7980e5027b1768b491adfdb995fc288800f32de7dd9435929.zig", .dependencies = &.{ "zxc_module_5b36e241c4067c3e911e0b6eb63afc9193e11f3a3f7c7961379e0b2b58ee87a2", } },
        .{ .name = "zxc_module_c88c610977dc252a1728a0dd66d1024f93356eeb920cdd9c6da2e75af2114754", .path = "modules/zxc_module_c88c610977dc252a1728a0dd66d1024f93356eeb920cdd9c6da2e75af2114754.zig", .dependencies = &.{ "zxc_module_372d7cc3d254a4b7980e5027b1768b491adfdb995fc288800f32de7dd9435929", } },
        .{ .name = "zxc_module_2435939d10fe518e53b63c1c6f9995b8f4a0ade94e91f8557d3e19f2c40f7309", .path = "modules/zxc_module_2435939d10fe518e53b63c1c6f9995b8f4a0ade94e91f8557d3e19f2c40f7309.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_7690ebc84f085e3301e6b1c794cd66b7fba54fb883b38a5a51cb9259233a3806", .path = "modules/zxc_module_7690ebc84f085e3301e6b1c794cd66b7fba54fb883b38a5a51cb9259233a3806.zig", .dependencies = &.{ "zxc_module_2435939d10fe518e53b63c1c6f9995b8f4a0ade94e91f8557d3e19f2c40f7309", } },
        .{ .name = "zxc_module_d4d7d429fca2e20d04f9391baeacd773f64b6f194556a2de41d112ffd64e457b", .path = "modules/zxc_module_d4d7d429fca2e20d04f9391baeacd773f64b6f194556a2de41d112ffd64e457b.zig", .dependencies = &.{ "zxc_module_7690ebc84f085e3301e6b1c794cd66b7fba54fb883b38a5a51cb9259233a3806", } },
        .{ .name = "zxc_store_initial_30479d9632a863f781fd0dcd6a0a0728e97ba63908019aa645913762a02d6fd3", .path = "modules/zxc_store_initial_30479d9632a863f781fd0dcd6a0a0728e97ba63908019aa645913762a02d6fd3.zig", .dependencies = &.{ } },
    },
    .public_modules = &.{
        .{ .name = ".", .path = "public/public_cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8.zig", .dependencies = &.{ "zxc_module_c88c610977dc252a1728a0dd66d1024f93356eeb920cdd9c6da2e75af2114754", "zxc_module_d4d7d429fca2e20d04f9391baeacd773f64b6f194556a2de41d112ffd64e457b", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
