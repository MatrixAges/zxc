const std = @import("std");
const compiler = @import("compiler");
const Compile = @import("../../compile.zig");
const Loaded = @import("../../project.zig").Loaded;

pub fn run(context: Compile.Context, loaded: Loaded) !Compile.Status {
    const allocator = context.allocator;
    const options = context.options;
    const writer = context.stderr;

    if (!options.native or options.verifying or options.fpga or options.result != .json) {
        try writer.writeAll("Gateway requires build --mode app and does not support --result discard\n");

        return .failed;
    }

    const inputs = if (context.watch) |attempt| attempt.inputs else null;
    var analyzed = try @import("analyze.zig").run(allocator, .{ .io = context.io, .loaded = loaded, .writer = writer, .inputs = inputs }) orelse return .failed;

    defer analyzed.deinit();

    var linked = try analyzed.link(allocator);

    defer if (linked) |*result| result.deinit();

    const definition = analyzed.gateway.value.definition;
    const routes = try allocator.alloc(compiler.zig.gateway.Route, definition.routes.len);

    for (definition.routes, routes) |route, *mapped| {
        const index = for (linked.?.exports, 0..) |exported, index| {
            if (std.mem.eql(u8, exported.name, route.service)) break index;
        } else return error.MissingGatewayService;

        mapped.* = .{ .path = route.path, .method = if (route.method) |method| @tagName(method) else null, .service = index };
    }

    const configuration = compiler.zig.gateway.Options{ .routes = routes, .listen = definition.listen orelse "127.0.0.1:8080", .max_header_bytes = definition.max_header_bytes, .max_body_bytes = definition.max_body_bytes };
    var cache = try @import("../../generation_cache.zig").init(context.io, allocator, loaded.project.root_dir);

    defer cache.deinit();

    var dependencies: std.ArrayList([]const u8) = .empty;

    var bundle = if (linked) |*library| blk: {
        var sources: std.ArrayList(compiler.project.Source) = .empty;

        for (analyzed.services.?.modules) |module| try sources.appendSlice(allocator, module.sources);

        var emitted = try compiler.emitLibraryVerified(allocator, .{ .io = context.io, .sources = sources.items, .project = loaded.project, .generation_cache = if (options.cache) &cache else null, .solver = options.solver, .writer = writer, .dependencies = &dependencies }, library);

        if (emitted == .diagnostic) {
            defer emitted.diagnostic.deinit();

            try writer.print("{s}: {t}: {s}\n", .{ options.input, emitted.diagnostic.code, emitted.diagnostic.message });

            return .failed;
        }

        errdefer emitted.bundle.deinit();

        break :blk try compiler.zig.gateway.create(library, &emitted.bundle, configuration);
    } else try compiler.zig.gateway.empty(allocator, configuration);

    defer bundle.deinit();

    bundle.runner = try compiler.zig.host.gateway(allocator);

    defer allocator.free(bundle.runner.?);

    try @import("../../generation_cache.zig").report(&cache, options, writer);

    const toolchain = try @import("../../toolchain.zig").resolve(context.io, allocator, context.environment);
    const project = try @import("../../standard.zig").resolve(allocator, loaded, dependencies.items, toolchain.standard);

    for (project.config.native_modules) |native| {
        for (bundle.modules) |module| if (std.mem.eql(u8, native.name, module.name)) return error.ConflictingModuleName;
    }

    if (context.watch) |attempt| {
        try attempt.prepareBackend(context.io);

        var observed = try @import("../../build.zig").runObserved(context.io, allocator, bundle, options, project, toolchain, context.environment, attempt.inputs);

        defer observed.deinit();

        try attempt.finishBackend(observed.input_paths);
        try writer.writeAll(observed.response.stderr);
        try observed.response.diagnostics.renderToWriter(.{}, writer);

        if (!observed.response.succeeded) return .backend_failed;
        if (!observed.response.inputs_complete) return error.IncompleteBackendInputs;
        if (!try observed.publish(context.io, allocator, attempt.inputs, options)) return .retry;
    } else if (!try @import("../../build.zig").run(context.io, allocator, bundle, options, project, toolchain, context.environment)) return .failed;

    return .success;
}
