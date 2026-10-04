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
        .{ .name = "zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368", .path = "modules/zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_b2907635802a7ac81857196cd21fe76fc814161fb19277aba5649dad0dd1eefd", .path = "modules/zxc_module_b2907635802a7ac81857196cd21fe76fc814161fb19277aba5649dad0dd1eefd.zig", .dependencies = &.{ "zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368", } },
        .{ .name = "zxc_module_84276465a08357fbcb9164cbc2bb538acfc3c549caec7e98ac0b3dd71b5e5048", .path = "modules/zxc_module_84276465a08357fbcb9164cbc2bb538acfc3c549caec7e98ac0b3dd71b5e5048.zig", .dependencies = &.{ } },
        .{ .name = "zxc_module_98fd8fd6cc800706cf3eedaa54670f0670d77d485f6fdb90c95fc741b06e49be", .path = "modules/zxc_module_98fd8fd6cc800706cf3eedaa54670f0670d77d485f6fdb90c95fc741b06e49be.zig", .dependencies = &.{ "zxc_module_84276465a08357fbcb9164cbc2bb538acfc3c549caec7e98ac0b3dd71b5e5048", } },
        .{ .name = "zxc_module_c7ea3e9bb87f13c75e993d9376c360e6c36b240c3aa2c7df9a3fbd351b5e745a", .path = "modules/zxc_module_c7ea3e9bb87f13c75e993d9376c360e6c36b240c3aa2c7df9a3fbd351b5e745a.zig", .dependencies = &.{ "zxc_module_98fd8fd6cc800706cf3eedaa54670f0670d77d485f6fdb90c95fc741b06e49be", "zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368", } },
        .{ .name = "zxc_module_b0a0bea1333245418751008e17fc4addc5b41760c7973359c2505b71631d1595", .path = "modules/zxc_module_b0a0bea1333245418751008e17fc4addc5b41760c7973359c2505b71631d1595.zig", .dependencies = &.{ "zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368", } },
    },
    .public_modules = &.{
        .{ .name = ".", .path = "public/public_cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8.zig", .dependencies = &.{ "zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368", "zxc_module_b0a0bea1333245418751008e17fc4addc5b41760c7973359c2505b71631d1595", "zxc_module_b2907635802a7ac81857196cd21fe76fc814161fb19277aba5649dad0dd1eefd", "zxc_module_c7ea3e9bb87f13c75e993d9376c360e6c36b240c3aa2c7df9a3fbd351b5e745a", } },
    },
    .libraries = &.{ },
    .include_paths = &.{ },
    .library_paths = &.{ },
};
