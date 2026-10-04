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
        .{ .name = "zxc_module_01c9d6df779c009b0ea5d7726587570511114a6feb2c548ce4d040951dc3ff6b", .path = "modules/zxc_module_01c9d6df779c009b0ea5d7726587570511114a6feb2c548ce4d040951dc3ff6b.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_c044739b97bc8e4ea09d77ffa272bb259170cd89137ceb594040ffae525c1171", .path = "modules/zxc_module_c044739b97bc8e4ea09d77ffa272bb259170cd89137ceb594040ffae525c1171.zig", .dependencies = &.{ } },
        .{ .name = "zxc_store_initial_48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720", .path = "modules/zxc_store_initial_48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720.zig", .dependencies = &.{ } },
    },
    .public_modules = &.{
        .{ .name = "./advance", .path = "public/public_9bb5cf7cfcb1133f807a083d2d6f5ad5584046e0c7d987c72cb2c44c00ca47dd.zig", .dependencies = &.{ "zxc_module_01c9d6df779c009b0ea5d7726587570511114a6feb2c548ce4d040951dc3ff6b", } },
        .{ .name = "./read", .path = "public/public_75f1c052cdd6055ccefa0a0cd57f4365ab737f6178f2f94076073d3ef64aee3e.zig", .dependencies = &.{ "zxc_module_c044739b97bc8e4ea09d77ffa272bb259170cd89137ceb594040ffae525c1171", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
