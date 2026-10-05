const std = @import("std");
const Options = @import("options.zig").Options;
const Loaded = @import("project.zig").Loaded;
const artifacts = @import("artifacts.zig");
const Cache = @import("build/observed.zig").Cache;
pub const Observed = @import("build/observed.zig");
const Staged = @import("build/staged.zig");
const Emission = union(enum) { staged: Staged, observed: Cache };

pub fn run(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, environment: *const std.process.Environ.Map) !bool {
    const staged = try Staged.init(io, allocator, options);

    defer staged.deinit(io);

    const arguments = try prepare(io, allocator, bundle, options, loaded, toolchain, .{ .staged = staged });
    var backend_environment = try environmentFor(allocator, environment, toolchain.library);

    defer backend_environment.deinit();

    var child = try std.process.spawn(io, .{ .argv = arguments, .environ_map = &backend_environment });
    const termination = try child.wait(io);

    if (termination != .exited or termination.exited != 0) return false;

    try staged.publish(io, allocator, options);

    return true;
}

pub fn runObserved(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, environment: *const std.process.Environ.Map, inputs: *@import("watch/inputs.zig")) !Observed {
    const cache = try Cache.init(io, allocator, environment);
    const arguments = try prepare(io, allocator, bundle, options, loaded, toolchain, .{ .observed = cache });
    var backend_environment = try environmentFor(allocator, environment, toolchain.library);

    defer backend_environment.deinit();

    var response = try @import("backend/process.zig").run(io, allocator, arguments, &backend_environment);

    errdefer response.deinit();

    return Observed.resolve(io, &response, cache, toolchain.library, options, inputs);
}

fn prepare(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, emission: Emission) ![]const []const u8 {
    var configuration_options = options;
    configuration_options.cache = true;
    configuration_options.cache_stats = false;
    configuration_options.watch = false;
    const configuration = try std.json.Stringify.valueAlloc(allocator, .{ .options = configuration_options, .project = loaded }, .{});
    const abi = try @import("abi.zig").create(allocator, bundle, loaded);
    const directory = try artifacts.prepare(io, allocator, bundle, configuration, abi, options.result == .json);
    var arguments: std.ArrayList([]const u8) = .empty;

    try arguments.appendSlice(allocator, &.{ toolchain.executable, "build-exe", "--zig-lib-dir", toolchain.library });

    if (emission == .observed) {
        const paths = emission.observed;

        try arguments.appendSlice(allocator, &.{ "--listen=-", "--name", Observed.artifact_name, "--cache-dir", paths.local, "--global-cache-dir", paths.global });
        if (options.assembly != null) try arguments.append(allocator, "-femit-asm");
    } else {
        const staged = emission.staged;

        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-femit-bin={s}", .{staged.binary}));
        try ensureParent(io, staged.binary);

        if (staged.assembly) |assembly| {
            try ensureParent(io, assembly);
            try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-femit-asm={s}", .{assembly}));
        }
    }

    for (loaded.config.libraries) |library| try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-l{s}", .{library}));
    for (loaded.config.library_paths) |path| try arguments.appendSlice(allocator, &.{ "-L", try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) });

    for (loaded.config.native_modules) |module| {
        if (module.header != null) {
            try arguments.append(allocator, "-lc");

            break;
        }
    }

    try settings(allocator, &arguments, options);
    if (bundle.state_module) |name| try arguments.appendSlice(allocator, &.{ "--dep", name });
    try arguments.appendSlice(allocator, &.{ "--dep", "application", try std.fmt.allocPrint(allocator, "-Mroot={s}/main.zig", .{directory}) });
    try settings(allocator, &arguments, options);
    try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi" });
    for (bundle.entry.imports) |dependency| try arguments.appendSlice(allocator, &.{ "--dep", dependency });
    for (loaded.config.native_modules) |module| try arguments.appendSlice(allocator, &.{ "--dep", module.name });
    try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mapplication={s}/program.zig", .{directory}));

    for (bundle.modules) |module| {
        try settings(allocator, &arguments, options);
        try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi" });
        for (module.imports) |dependency| try arguments.appendSlice(allocator, &.{ "--dep", dependency });
        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ module.name, try artifacts.modulePath(allocator, module) }));
    }

    for (loaded.config.native_modules) |module| {
        try settings(allocator, &arguments, options);

        var abi_name: []const u8 = "zxc_abi";

        for (abi.views) |view| if (std.mem.eql(u8, view.module, module.name)) {
            abi_name = try std.fmt.allocPrint(allocator, "zxc_abi={s}", .{view.name});

            break;
        };

        try arguments.appendSlice(allocator, &.{ "--dep", abi_name });
        for (module.dependencies) |dependency| try arguments.appendSlice(allocator, &.{ "--dep", dependency });

        var include_root = loaded.project.root_dir;
        var include_paths = module.include_paths orelse loaded.config.include_paths;

        for (loaded.native_settings) |setting| {
            if (!std.mem.eql(u8, setting.name, module.name)) continue;

            include_root = setting.root;
            include_paths = module.include_paths orelse setting.include_paths;

            break;
        }

        for (include_paths) |path| try arguments.appendSlice(allocator, &.{ "-I", try std.fs.path.resolve(allocator, &.{ include_root, path }) });

        const path = if (module.path) |path| try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) else blk: {
            const path = try std.fmt.allocPrint(allocator, "{s}/native/{s}.zig", .{ directory, module.name });
            const text = try std.fmt.allocPrint(allocator, "pub const c = @cImport({{ @cInclude(\"{f}\"); }});\n", .{std.zig.fmtString(module.header.?)});

            try artifacts.write(io, path, text);

            break :blk path;
        };

        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ module.name, path }));
    }

    for (abi.views) |view| {
        try settings(allocator, &arguments, options);
        try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi_canonical=zxc_abi", try std.fmt.allocPrint(allocator, "-M{s}={s}/{s}", .{ view.name, directory, view.path }) });
    }

    try settings(allocator, &arguments, options);
    try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mzxc_abi={s}/abi.zig", .{directory}));

    const manifest = try std.json.Stringify.valueAlloc(allocator, arguments.items, .{ .whitespace = .indent_2 });

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "command.json" }), manifest);

    return arguments.items;
}

fn environmentFor(allocator: std.mem.Allocator, environment: *const std.process.Environ.Map, library: []const u8) !std.process.Environ.Map {
    var result = std.process.Environ.Map.init(allocator);

    errdefer result.deinit();

    for (environment.keys(), environment.values()) |key, value| try result.put(key, value);
    try result.put("ZIG_LIB_DIR", library);

    return result;
}

fn settings(allocator: std.mem.Allocator, arguments: *std.ArrayList([]const u8), options: Options) !void {
    try arguments.appendSlice(allocator, &.{ "-O", @tagName(options.optimize) });

    const builtin = @import("builtin");
    const host = @tagName(builtin.cpu.arch) ++ "-" ++ @tagName(builtin.os.tag);
    const target = options.target orelse if (!std.mem.eql(u8, host, @import("bundle").zig_host)) try builtin.target.zigTriple(allocator) else null;

    if (target) |triple| try arguments.appendSlice(allocator, &.{ "-target", triple });
    if (options.cpu) |cpu| try arguments.appendSlice(allocator, &.{ "-mcpu", cpu });
}

fn ensureParent(io: std.Io, path: []const u8) !void {
    const parent = std.fs.path.dirname(path) orelse return;
    var directory = try std.Io.Dir.cwd().createDirPathOpen(io, parent, .{});

    directory.close(io);
}
