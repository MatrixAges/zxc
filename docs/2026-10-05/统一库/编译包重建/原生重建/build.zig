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
        .{ .name = "library_native_6c9c0b66a907af74268a736d2868e8d92ff63965567327ece1d8f5b06c47aed2", .path = "native/library_native_6c9c0b66a907af74268a736d2868e8d92ff63965567327ece1d8f5b06c47aed2/source/choice.zig", .header = null, .dependencies = &.{ }, .bundle_files = &.{ }, .include_paths = &.{ }, .abi_view = "abi_views/zxc_abi_view_library_native_6c9c0b66a907af74268a736d2868e8d92ff63965567327ece1d8f5b06c47aed2.zig" },
    },
    .generated_modules = &.{
        .{ .name = "zxc_module_85b3264a7b18e9bd91aeeee158fd4fcf6483a9058c4146f4eec12780983b57ee", .path = "modules/zxc_module_85b3264a7b18e9bd91aeeee158fd4fcf6483a9058c4146f4eec12780983b57ee.zig", .dependencies = &.{ "library_native_6c9c0b66a907af74268a736d2868e8d92ff63965567327ece1d8f5b06c47aed2", } },
        .{ .name = "zxc_module_6b81d04a55f35d483458b3d3c7bf128e9cded3c673df9959e0f046e11f1e673d", .path = "modules/zxc_module_6b81d04a55f35d483458b3d3c7bf128e9cded3c673df9959e0f046e11f1e673d.zig", .dependencies = &.{ "zxc_module_85b3264a7b18e9bd91aeeee158fd4fcf6483a9058c4146f4eec12780983b57ee", } },
        .{ .name = "zxc_module_1e9bac08635623f876f02ef30a39aa9d1f864efc4eece416c940c01435e7fecd", .path = "modules/zxc_module_1e9bac08635623f876f02ef30a39aa9d1f864efc4eece416c940c01435e7fecd.zig", .dependencies = &.{ "zxc_module_6b81d04a55f35d483458b3d3c7bf128e9cded3c673df9959e0f046e11f1e673d", "zxc_module_85b3264a7b18e9bd91aeeee158fd4fcf6483a9058c4146f4eec12780983b57ee", } },
    },
    .public_modules = &.{
        .{ .name = "./twice", .path = "public/public_6917705b18b7644c71d2d9c11fc5ccf1f86c8faa78fe02f7c5a5219a87d25f54.zig", .dependencies = &.{ "zxc_module_1e9bac08635623f876f02ef30a39aa9d1f864efc4eece416c940c01435e7fecd", } },
        .{ .name = "./once", .path = "public/public_c0127e46fb5f24e596381156a205121215baa0896217b970255e308068422874.zig", .dependencies = &.{ "zxc_module_6b81d04a55f35d483458b3d3c7bf128e9cded3c673df9959e0f046e11f1e673d", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
