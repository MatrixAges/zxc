const std = @import("std");
const Options = @import("options.zig").Options;
const Loaded = @import("project.zig").Loaded;
const artifacts = @import("artifacts.zig");
const Cache = @import("build/observed.zig").Cache;
pub const Observed = @import("build/observed.zig");
const Staged = @import("build/staged.zig");
const Translation = @import("build/translation.zig");
const Emission = union(enum) { staged: Staged, observed: Cache };

pub fn run(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, environment: *const std.process.Environ.Map) !bool {
    const bindings = try @import("node/bindings.zig").create(allocator, bundle, options);

    if (bindings) |files| try files.check(io, allocator, options);

    const staged = try Staged.init(io, allocator, options);

    defer staged.deinit(io);

    var backend_environment = try environmentFor(allocator, environment, toolchain.library);

    defer backend_environment.deinit();

    var translation = Translation.init(allocator, try Cache.init(io, allocator, environment));

    defer translation.deinit();

    const arguments = try prepare(io, allocator, bundle, options, loaded, toolchain, .{ .staged = staged }, &translation, &backend_environment) orelse {
        var buffer: [4096]u8 = undefined;
        var stderr = std.Io.File.stderr().writer(io, &buffer);

        try stderr.interface.writeAll(translation.failure.?.stderr);
        try translation.failure.?.diagnostics.renderToWriter(.{}, &stderr.interface);
        try stderr.interface.flush();

        return false;
    };

    var child = try std.process.spawn(io, .{ .argv = arguments, .environ_map = &backend_environment });
    const termination = try child.wait(io);

    if (termination != .exited or termination.exited != 0) return false;

    if (bindings) |files| {
        try files.check(io, allocator, options);
        try files.stage(io, allocator, std.fs.path.dirname(staged.binary).?);
    }

    try staged.publish(io, allocator, options);

    return true;
}

pub fn runObserved(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, environment: *const std.process.Environ.Map, inputs: *@import("watch/inputs.zig")) !Observed {
    const cache = try Cache.init(io, allocator, environment);
    var backend_environment = try environmentFor(allocator, environment, toolchain.library);

    defer backend_environment.deinit();

    var translation = Translation.init(allocator, cache);

    defer translation.deinit();

    const arguments = try prepare(io, allocator, bundle, options, loaded, toolchain, .{ .observed = cache }, &translation, &backend_environment);
    var response = if (arguments) |argv| try @import("backend/process.zig").run(io, allocator, argv, &backend_environment) else translation.failure.?;

    translation.failure = null;

    errdefer response.deinit();

    try translation.merge(&response);

    var observed = try Observed.resolve(io, &response, cache, toolchain.library, options, inputs);

    observed.bindings = try @import("node/bindings.zig").create(response.arena.allocator(), bundle, options);

    return observed;
}

fn prepare(io: std.Io, allocator: std.mem.Allocator, bundle: @import("compiler").zig.ModuleBundle, options: Options, loaded: Loaded, toolchain: @import("toolchain.zig").Paths, emission: Emission, translation: *Translation, environment: *const std.process.Environ.Map) !?[]const []const u8 {
    var configuration_options = options;
    configuration_options.cache = true;
    configuration_options.cache_stats = false;
    configuration_options.watch = false;
    configuration_options.run = false;
    configuration_options.run_args = &.{};
    const node = options.host == .node;
    const configuration = try std.json.Stringify.valueAlloc(allocator, .{ .options = configuration_options, .project = loaded, .node_host_sources = if (node) @as([]const @import("node/resources.zig").File, &@import("node/resources.zig").files) else &.{}, .node_sources = if (node) @as([]const @import("napi_resources").File, &@import("napi_resources").files) else &.{} }, .{});
    const abi = try @import("abi.zig").create(allocator, bundle, loaded);
    const wasm = try @import("wasm/target.zig").freestanding(options.target);
    var executable_bundle = bundle;

    if (node) {
        if (wasm or bundle.runner != null) return error.UnsupportedNodeRunner;

        executable_bundle.runner = if (bundle.state_module != null) "pub const stateful = true;\n" ++ @embedFile("node/runner.zig") else "pub const stateful = false;\n" ++ @embedFile("node/runner.zig");
    }

    if (wasm) {
        if (bundle.runner != null) return error.UnsupportedWasmRunner;

        executable_bundle.runner = @import("wasm/target.zig").runner(bundle.state_module != null);
    }

    const directory = try artifacts.prepare(io, allocator, executable_bundle, configuration, abi, options.result == .json);
    var arguments: std.ArrayList([]const u8) = .empty;

    try arguments.appendSlice(allocator, &.{ toolchain.executable, if (node) "build-lib" else "build-exe", "--zig-lib-dir", toolchain.library });

    if (node) {
        const target = if (options.target) |triple| try std.Target.Query.parse(.{ .arch_os_abi = triple }) else std.Target.Query.fromTarget(&@import("builtin").target);
        const os = target.os_tag orelse @import("builtin").os.tag;
        const arch = target.cpu_arch orelse @import("builtin").cpu.arch;

        if (arch == .wasm32 or arch == .wasm64) return error.UnsupportedNodeTarget;
        if (os == .windows and options.node_library == null) return error.NodeImportLibraryRequired;
        try arguments.append(allocator, "-dynamic");

        if (options.node_library) |path| {
            try arguments.append(allocator, try std.fs.path.resolve(allocator, &.{path}));
        } else try arguments.append(allocator, "-fallow-shlib-undefined");

        for (@import("node/resources.zig").files) |file| try artifacts.retain(io, allocator, try std.fs.path.join(allocator, &.{ directory, "node", file.path }), file.source);
        for (@import("napi_resources").files) |file| try artifacts.retain(io, allocator, try std.fs.path.join(allocator, &.{ directory, "napi", file.path }), file.source);
    }

    if (wasm) try arguments.appendSlice(allocator, &.{ "-fno-entry", "--export-memory", "-rdynamic" });

    if (emission == .observed) {
        const paths = emission.observed;

        try arguments.appendSlice(allocator, &.{ "--listen=-", "--name", Observed.artifact_name, "--build-root", paths.cwd, "--cache-dir", paths.local, "--global-cache-dir", paths.global });
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
    if (node) try arguments.appendSlice(allocator, &.{ "--dep", "zxc_napi" });
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

        const path = if (module.path) |path| try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) else {
            const path = try std.fmt.allocPrint(allocator, "{s}/native/{s}.zig", .{ directory, module.name });
            const header_path = try std.fmt.allocPrint(allocator, "{s}/native/{s}.h", .{ directory, module.name });
            const include = try std.json.Stringify.valueAlloc(allocator, module.header.?, .{});
            const header_source = try std.fmt.allocPrint(allocator, "#include {s}\n", .{include});
            var command: std.ArrayList([]const u8) = .empty;

            try artifacts.retain(io, allocator, header_path, header_source);
            try command.appendSlice(allocator, &.{ toolchain.executable, "translate-c", "--zig-lib-dir", toolchain.library, "-lc", "--listen=-", "--cache-dir", translation.cache.local, "--global-cache-dir", translation.cache.global });
            try settings(allocator, &command, options);
            for (include_paths) |include_path| try command.appendSlice(allocator, &.{ "-I", try std.fs.path.resolve(allocator, &.{ include_root, include_path }) });
            try command.append(allocator, header_path);

            const translated = try translation.execute(io, command.items, environment, module.name) orelse return null;
            const translated_name = try std.fmt.allocPrint(allocator, "zxc_c_{s}", .{module.name});

            try arguments.appendSlice(allocator, &.{ "--dep", try std.fmt.allocPrint(allocator, "zxc_c={s}", .{translated_name}), try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ module.name, path }) });
            try settings(allocator, &arguments, options);
            try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ translated_name, translated }));
            try artifacts.retain(io, allocator, path, "pub const c = @import(\"zxc_c\");\n");

            continue;
        };

        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ module.name, path }));
    }

    for (abi.views) |view| {
        try settings(allocator, &arguments, options);
        try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi_canonical=zxc_abi", try std.fmt.allocPrint(allocator, "-M{s}={s}/{s}", .{ view.name, directory, view.path }) });
    }

    try settings(allocator, &arguments, options);
    try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mzxc_abi={s}/abi.zig", .{directory}));

    if (node) {
        try settings(allocator, &arguments, options);
        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mzxc_napi={s}/napi/root.zig", .{directory}));
    }

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
