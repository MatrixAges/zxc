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
        .{ .name = "library_native_0cd6f1314c2010436047124e0e37cbfae481405200b5bc72cecbfa5f29d6612b", .path = "native/library_native_0cd6f1314c2010436047124e0e37cbfae481405200b5bc72cecbfa5f29d6612b/source/choice.zig", .header = null, .dependencies = &.{}, .bundle_files = &.{}, .include_paths = &.{}, .abi_view = "abi_views/zxc_abi_view_library_native_0cd6f1314c2010436047124e0e37cbfae481405200b5bc72cecbfa5f29d6612b.zig" },
    },
    .generated_modules = &.{
        .{ .name = "zxc_module_3757bf87093fc7ec87a65d5c6178e5a5bedab4c62bcf9e123da641dbb23ad166", .path = "modules/zxc_module_3757bf87093fc7ec87a65d5c6178e5a5bedab4c62bcf9e123da641dbb23ad166.zig", .dependencies = &.{
            "library_native_0cd6f1314c2010436047124e0e37cbfae481405200b5bc72cecbfa5f29d6612b",
        } },
        .{ .name = "zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc", .path = "modules/zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc.zig", .dependencies = &.{
            "zxc_module_3757bf87093fc7ec87a65d5c6178e5a5bedab4c62bcf9e123da641dbb23ad166",
        } },
        .{ .name = "zxc_module_f996438a9670128b29be54ba0595d588345e91f3e0865d9bc4042c45dd3214cd", .path = "modules/zxc_module_f996438a9670128b29be54ba0595d588345e91f3e0865d9bc4042c45dd3214cd.zig", .dependencies = &.{
            "zxc_module_3757bf87093fc7ec87a65d5c6178e5a5bedab4c62bcf9e123da641dbb23ad166",
            "zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc",
        } },
    },
    .public_modules = &.{
        .{ .name = "./twice", .path = "public/public_6917705b18b7644c71d2d9c11fc5ccf1f86c8faa78fe02f7c5a5219a87d25f54.zig", .dependencies = &.{
            "zxc_module_f996438a9670128b29be54ba0595d588345e91f3e0865d9bc4042c45dd3214cd",
        } },
        .{ .name = "./once", .path = "public/public_c0127e46fb5f24e596381156a205121215baa0896217b970255e308068422874.zig", .dependencies = &.{
            "zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc",
        } },
    },
    .libraries = &.{},
    .include_paths = &.{},
    .library_paths = &.{},
};
