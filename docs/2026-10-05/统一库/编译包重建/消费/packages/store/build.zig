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
        .{ .name = "zxc_module_0369ba5e4a14952643089eeb4b36b02a36abde631b7bcc107fdbf3d9c8918918", .path = "modules/zxc_module_0369ba5e4a14952643089eeb4b36b02a36abde631b7bcc107fdbf3d9c8918918.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_935c88baabd90475919c6674a23029e3a8005eee002f2ee7b588a14dc238f5a0", .path = "modules/zxc_module_935c88baabd90475919c6674a23029e3a8005eee002f2ee7b588a14dc238f5a0.zig", .dependencies = &.{ "zxc_module_0369ba5e4a14952643089eeb4b36b02a36abde631b7bcc107fdbf3d9c8918918", } },
        .{ .name = "zxc_module_becea1120b36cd103a899d9da43028f74fea97bc8246387bc65a41286f7bbac3", .path = "modules/zxc_module_becea1120b36cd103a899d9da43028f74fea97bc8246387bc65a41286f7bbac3.zig", .dependencies = &.{ "zxc_module_935c88baabd90475919c6674a23029e3a8005eee002f2ee7b588a14dc238f5a0", } },
        .{ .name = "zxc_module_ff9cac7e4e0b20f72c6e8a8756971bbc65b09932e62ac960d3ca09d654f7b3e0", .path = "modules/zxc_module_ff9cac7e4e0b20f72c6e8a8756971bbc65b09932e62ac960d3ca09d654f7b3e0.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_a3feab9848eca18924410606a1773b540be592d2144c4a2a193c8bfb7b2139ce", .path = "modules/zxc_module_a3feab9848eca18924410606a1773b540be592d2144c4a2a193c8bfb7b2139ce.zig", .dependencies = &.{ "zxc_module_ff9cac7e4e0b20f72c6e8a8756971bbc65b09932e62ac960d3ca09d654f7b3e0", } },
        .{ .name = "zxc_module_3362530bb87beaa81194a109461d102733df39aa37cf9e5453fd8a08d8f566ca", .path = "modules/zxc_module_3362530bb87beaa81194a109461d102733df39aa37cf9e5453fd8a08d8f566ca.zig", .dependencies = &.{ "zxc_module_a3feab9848eca18924410606a1773b540be592d2144c4a2a193c8bfb7b2139ce", } },
        .{ .name = "zxc_store_initial_cbf1092a5cbb97f717885ecb31af61f20f39cb7b8e1e82f895db34e072ea1e90", .path = "modules/zxc_store_initial_cbf1092a5cbb97f717885ecb31af61f20f39cb7b8e1e82f895db34e072ea1e90.zig", .dependencies = &.{ } },
    },
    .public_modules = &.{
        .{ .name = ".", .path = "public/public_cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8.zig", .dependencies = &.{ "zxc_module_3362530bb87beaa81194a109461d102733df39aa37cf9e5453fd8a08d8f566ca", "zxc_module_becea1120b36cd103a899d9da43028f74fea97bc8246387bc65a41286f7bbac3", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
