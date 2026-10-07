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
        .{ .name = "zxc_module_7318a572e20e0801b09b7e0c6e3d6f9bdafef99c84bd84cfde6917004ceebe9d", .path = "modules/zxc_module_7318a572e20e0801b09b7e0c6e3d6f9bdafef99c84bd84cfde6917004ceebe9d.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_862317882b28a27c11d014f36c0503f929ceca248d7721908779a4810ae96c8c", .path = "modules/zxc_module_862317882b28a27c11d014f36c0503f929ceca248d7721908779a4810ae96c8c.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_cac988214a2deaff641c7c3d8b3f8e5bd0701c6f25577bbd89a4b1ea6fdfab89", .path = "modules/zxc_module_cac988214a2deaff641c7c3d8b3f8e5bd0701c6f25577bbd89a4b1ea6fdfab89.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_17301f56aa469cd2bcdeed4c5c2acce33c6e05fc457bf99658bf96c1322de779", .path = "modules/zxc_module_17301f56aa469cd2bcdeed4c5c2acce33c6e05fc457bf99658bf96c1322de779.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_3bb1a823766ec208fff506832f14e592a1b39a5b5c560198a59147e2fd021fe7", .path = "modules/zxc_module_3bb1a823766ec208fff506832f14e592a1b39a5b5c560198a59147e2fd021fe7.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_aa9a067085cfbc58391b9a900aba6859d151fe6bbfbb281e0997e254ba73088a", .path = "modules/zxc_module_aa9a067085cfbc58391b9a900aba6859d151fe6bbfbb281e0997e254ba73088a.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_173678ed421757f042dafb952025de758bc05623d03d3ef8e56305b84192edf0", .path = "modules/zxc_module_173678ed421757f042dafb952025de758bc05623d03d3ef8e56305b84192edf0.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_fa80c79528c1b09ebf4084ec9c56bba6f91c14c4586bf4cfd101d76aa85d1dcd", .path = "modules/zxc_module_fa80c79528c1b09ebf4084ec9c56bba6f91c14c4586bf4cfd101d76aa85d1dcd.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_b1d65d61baaee201ecb2dc685839f117f61e624134860188428cb859ebc02237", .path = "modules/zxc_module_b1d65d61baaee201ecb2dc685839f117f61e624134860188428cb859ebc02237.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_184a6c51ea04d6fa72138d3e7d356ebb2fce0d79d95095f9937b2a642b415046", .path = "modules/zxc_module_184a6c51ea04d6fa72138d3e7d356ebb2fce0d79d95095f9937b2a642b415046.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_2e2a93364a8017bafb393f8ca370f2bafb98ba2ee2bfc943844e3e39b07666c5", .path = "modules/zxc_module_2e2a93364a8017bafb393f8ca370f2bafb98ba2ee2bfc943844e3e39b07666c5.zig", .dependencies = &.{ "zxc_standard", } },
        .{ .name = "zxc_module_b511d3b6a9c27c88edd240133e6adf512250878ecd0cc718c59fb9947c3586e6", .path = "modules/zxc_module_b511d3b6a9c27c88edd240133e6adf512250878ecd0cc718c59fb9947c3586e6.zig", .dependencies = &.{ "zxc_standard", } },
    },
    .public_modules = &.{
        .{ .name = "library", .path = "root.zig", .dependencies = &.{ "zxc_module_17301f56aa469cd2bcdeed4c5c2acce33c6e05fc457bf99658bf96c1322de779", "zxc_module_173678ed421757f042dafb952025de758bc05623d03d3ef8e56305b84192edf0", "zxc_module_184a6c51ea04d6fa72138d3e7d356ebb2fce0d79d95095f9937b2a642b415046", "zxc_module_2e2a93364a8017bafb393f8ca370f2bafb98ba2ee2bfc943844e3e39b07666c5", "zxc_module_3bb1a823766ec208fff506832f14e592a1b39a5b5c560198a59147e2fd021fe7", "zxc_module_7318a572e20e0801b09b7e0c6e3d6f9bdafef99c84bd84cfde6917004ceebe9d", "zxc_module_862317882b28a27c11d014f36c0503f929ceca248d7721908779a4810ae96c8c", "zxc_module_aa9a067085cfbc58391b9a900aba6859d151fe6bbfbb281e0997e254ba73088a", "zxc_module_b1d65d61baaee201ecb2dc685839f117f61e624134860188428cb859ebc02237", "zxc_module_b511d3b6a9c27c88edd240133e6adf512250878ecd0cc718c59fb9947c3586e6", "zxc_module_cac988214a2deaff641c7c3d8b3f8e5bd0701c6f25577bbd89a4b1ea6fdfab89", "zxc_module_fa80c79528c1b09ebf4084ec9c56bba6f91c14c4586bf4cfd101d76aa85d1dcd", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
