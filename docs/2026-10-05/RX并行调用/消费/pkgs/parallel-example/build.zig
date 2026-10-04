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
        .{ .name = "zxc_module_d14f1b051d1952c73264cdd97d41ec7d50341f56038e9929e77b4131be84b8a3", .path = "modules/zxc_module_d14f1b051d1952c73264cdd97d41ec7d50341f56038e9929e77b4131be84b8a3.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_e381993432177f7f22c4905764c34bdbc43085aca217467508bc9545f8a1b110", .path = "modules/zxc_module_e381993432177f7f22c4905764c34bdbc43085aca217467508bc9545f8a1b110.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_4f1874a8601b9d40840a577631765bf60726e6f56294d4937b70e189c85cac0d", .path = "modules/zxc_module_4f1874a8601b9d40840a577631765bf60726e6f56294d4937b70e189c85cac0d.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_5737f73f4ad01acc945eb09d814361f281713eefd9bed2b04673ab69c44e0027", .path = "modules/zxc_module_5737f73f4ad01acc945eb09d814361f281713eefd9bed2b04673ab69c44e0027.zig", .dependencies = &.{ "zxc_module_4f1874a8601b9d40840a577631765bf60726e6f56294d4937b70e189c85cac0d", } },
        .{ .name = "zxc_module_ac984aacbf37983902a12ea9fe0e907c01ff1f765dbd25de108fb16e8daf092f", .path = "modules/zxc_module_ac984aacbf37983902a12ea9fe0e907c01ff1f765dbd25de108fb16e8daf092f.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_8fd6cc39ecb7ae24aabe4ec49ce4ae3b78d78c4ee92593a73d66b89e48d34507", .path = "modules/zxc_module_8fd6cc39ecb7ae24aabe4ec49ce4ae3b78d78c4ee92593a73d66b89e48d34507.zig", .dependencies = &.{ } },
    },
    .public_modules = &.{
        .{ .name = ".", .path = "public/public_cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8.zig", .dependencies = &.{ "zxc_module_5737f73f4ad01acc945eb09d814361f281713eefd9bed2b04673ab69c44e0027", "zxc_module_d14f1b051d1952c73264cdd97d41ec7d50341f56038e9929e77b4131be84b8a3", "zxc_module_e381993432177f7f22c4905764c34bdbc43085aca217467508bc9545f8a1b110", } },
        .{ .name = "./discard", .path = "public/public_59d54b814afd15cbbe0f38ff5578667588312e205bf47e034d6ceb3901e7bc9a.zig", .dependencies = &.{ "zxc_module_8fd6cc39ecb7ae24aabe4ec49ce4ae3b78d78c4ee92593a73d66b89e48d34507", "zxc_module_ac984aacbf37983902a12ea9fe0e907c01ff1f765dbd25de108fb16e8daf092f", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
