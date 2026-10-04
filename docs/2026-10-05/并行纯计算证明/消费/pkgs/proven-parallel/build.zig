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
        .{ .name = "zxc_module_a9730b37f60f138c8007ec0d9ce38cad36c3b4bd34e6e29d2c38fe2a602b285f", .path = "modules/zxc_module_a9730b37f60f138c8007ec0d9ce38cad36c3b4bd34e6e29d2c38fe2a602b285f.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_d52136c4cb52107035a2d2a1714ee0e1b5d751465b4dcb80ce6eece8fc4226e7", .path = "modules/zxc_module_d52136c4cb52107035a2d2a1714ee0e1b5d751465b4dcb80ce6eece8fc4226e7.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_1563386adb966ab59f9e688e56b93cff0194d7cab4897f7f26a69d1879a2c57d", .path = "modules/zxc_module_1563386adb966ab59f9e688e56b93cff0194d7cab4897f7f26a69d1879a2c57d.zig", .dependencies = &.{ "zxc_module_d52136c4cb52107035a2d2a1714ee0e1b5d751465b4dcb80ce6eece8fc4226e7", } },
        .{ .name = "zxc_module_56344588f2c34e943d538b86cfa8ebbd9a9c25fb7bf7f8dc3c9ee908e1d23229", .path = "modules/zxc_module_56344588f2c34e943d538b86cfa8ebbd9a9c25fb7bf7f8dc3c9ee908e1d23229.zig", .dependencies = &.{ } },
    },
    .public_modules = &.{
        .{ .name = ".", .path = "public/public_cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8.zig", .dependencies = &.{ "zxc_module_1563386adb966ab59f9e688e56b93cff0194d7cab4897f7f26a69d1879a2c57d", "zxc_module_56344588f2c34e943d538b86cfa8ebbd9a9c25fb7bf7f8dc3c9ee908e1d23229", "zxc_module_a9730b37f60f138c8007ec0d9ce38cad36c3b4bd34e6e29d2c38fe2a602b285f", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
