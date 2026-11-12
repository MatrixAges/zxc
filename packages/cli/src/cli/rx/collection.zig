const std = @import("std");
const rx = @import("rx");
const compiler = @import("compiler");
const gateway = @import("rx_analysis").gateway;
const Inputs = @import("../watch/inputs.zig");
pub const Options = struct { io: std.Io, root: []const u8, entry: []const u8, writer: *std.Io.Writer, inputs: ?*Inputs = null, project: compiler.project.Options = .{ .entry = "" }, parse_cache: ?*compiler.project.ParseCache = null, libraries: ?*@import("../library/inputs.zig") = null };
pub const GatewaySource = struct { path: []const u8, node: rx.ast.Node };
pub const Data = struct { gateway: ?GatewaySource = null, modules: []const rx.ModuleSource, stores: []const rx.ModuleSource, sources: []const rx.TextSource, functions: []const rx.TextSource };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    data: Data,
    gateway_analysis: ?gateway.Result = null,
    pub fn deinit(self: *Result) void {
        if (self.gateway_analysis) |*analysis| analysis.deinit();

        self.arena.deinit();

        self.* = undefined;
    }

    pub fn takeGateway(self: *Result) ?gateway.Result {
        const analysis = self.gateway_analysis;

        self.gateway_analysis = null;

        return analysis;
    }
};

pub fn load(allocator: std.mem.Allocator, options: Options) !?Result {
    var result: Result = .{ .arena = std.heap.ArenaAllocator.init(allocator), .data = undefined };

    errdefer result.deinit();

    result.data = try loadIn(&result, allocator, options) orelse {
        result.deinit();

        return null;
    };

    return result;
}

fn loadIn(result: *Result, backing: std.mem.Allocator, options: Options) !?Data {
    const allocator = result.arena.allocator();
    const io = options.io;
    const writer = options.writer;
    const root = try std.fs.path.resolve(allocator, &.{options.root});
    var project = options.project;
    project.root_dir = root;

    const physical_root = try std.Io.Dir.cwd().realPathFileAlloc(io, root, allocator);

    const first = (if (std.mem.endsWith(u8, options.entry, ".zx")) allocator.dupe(u8, options.entry) else if (std.mem.endsWith(u8, options.entry, ".gateway.rx")) rx.normalizeGatewayPath(allocator, options.entry) else if (std.mem.endsWith(u8, options.entry, ".store.rx")) rx.normalizeStorePath(allocator, options.entry) else rx.normalizeModulePath(allocator, options.entry)) catch |err| {
        if (err == error.OutOfMemory) return err;
        try writer.print("{s}: invalid RX entry path\n", .{options.entry});

        return null;
    };

    var local_cache = compiler.project.ParseCache{ .allocator = allocator };

    defer local_cache.deinit();

    const cache = options.parse_cache orelse &local_cache;
    var queue: std.ArrayList([]const u8) = .empty;
    var queued: std.StringHashMapUnmanaged(void) = .empty;

    defer queued.deinit(allocator);

    var sources: std.ArrayList(rx.TextSource) = .empty;
    var modules: std.ArrayList(rx.ModuleSource) = .empty;
    var stores: std.ArrayList(rx.ModuleSource) = .empty;
    var functions: std.ArrayList(rx.TextSource) = .empty;
    var gateway_source: ?GatewaySource = null;
    var physical: std.StringHashMapUnmanaged([]const u8) = .empty;

    try queue.append(allocator, first);
    try queued.put(allocator, try std.fs.path.resolve(allocator, &.{ root, first }), {});

    var index: usize = 0;

    while (index < queue.items.len) : (index += 1) {
        const requested = queue.items[index];
        const candidate = try std.fs.path.resolve(allocator, &.{ root, requested });
        const absolute = if (std.mem.endsWith(u8, candidate, ".zx")) try @import("../sources/module_path.zig").select(io, allocator, candidate, options.inputs) else candidate;
        const path = try std.fs.path.relative(allocator, root, null, root, absolute);

        if (options.inputs) |inputs| try inputs.add(io, absolute);

        const real = std.Io.Dir.cwd().realPathFileAlloc(io, absolute, allocator) catch |err| {
            if (err == error.OutOfMemory) return err;
            if (err == error.FileNotFound and index != 0 and std.mem.endsWith(u8, path, ".zx")) continue;
            try writer.print("{s}: {s}\n", .{ path, @errorName(err) });

            return null;
        };

        const relative = try std.fs.path.relative(allocator, physical_root, null, physical_root, real);

        if (outside(relative)) {
            try writer.print("{s}: physical module file escapes the project root\n", .{path});

            return null;
        }

        if (physical.get(real)) |previous| {
            if (std.mem.eql(u8, previous, path)) continue;
            try writer.print("{s}: physical module file is already registered as {s}\n", .{ path, previous });

            return null;
        }

        try physical.put(allocator, real, path);

        const source = std.Io.Dir.cwd().readFileAlloc(io, absolute, allocator, .limited(16 * 1024 * 1024)) catch |err| {
            if (err == error.OutOfMemory) return err;
            if (err == error.FileNotFound and index != 0 and std.mem.endsWith(u8, path, ".zx")) continue;
            try writer.print("{s}: {s}\n", .{ path, @errorName(err) });

            return null;
        };

        if (options.inputs) |inputs| try inputs.record(io, absolute, source);

        if (std.mem.endsWith(u8, path, ".zx")) {
            const parsed = try cache.getModule(source, absolute);
            var collector = @import("references/collector.zig"){ .allocator = allocator, .options = project, .owner = absolute, .queue = &queue, .queued = &queued, .io = io, .inputs = options.inputs, .libraries = options.libraries, .writer = writer };

            if (parsed.diagnostic() == null) switch (parsed.*) {
                .native => |value| try collector.header(@import("zx").syntax.header.Native{ .program = value.value.parsed.ast }),
                .indexed => |*value| if (compiler.project.ParseCache.indexed_enabled) try collector.header(value.header()) else unreachable,
            };

            try functions.append(allocator, .{ .path = path, .source = source });

            continue;
        }

        const document = try rx.parseIndexedXml(allocator, source);
        const parsed = document.xml;

        if (parsed.value == .diagnostic) {
            try report(writer, path, parsed.value.diagnostic);

            return null;
        }

        var checked = try rx.validate(allocator, path, parsed.value.node);

        defer checked.deinit();

        if (checked.value == .diagnostic) {
            try report(writer, path, checked.value.diagnostic);

            return null;
        }

        const is_gateway = std.mem.endsWith(u8, path, ".gateway.rx");
        var collector = @import("references/collector.zig"){ .allocator = allocator, .options = project, .owner = absolute, .queue = &queue, .queued = &queued, .io = io, .inputs = options.inputs, .libraries = options.libraries, .writer = writer };

        if (is_gateway) gateway_source = .{ .path = path, .node = parsed.value.node };

        if (is_gateway and (checked.value.data.gateway.attributes.protocol orelse .http) == .http) {
            result.gateway_analysis = try gateway.analyze(backing, .{ .owner = path, .node = parsed.value.node, .validated_attributes = checked.value.data.gateway.attributes });
            const analysis = &result.gateway_analysis.?;

            if (analysis.value == .diagnostic) {
                const issue = analysis.value.diagnostic;

                try writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

                return null;
            }

            for (analysis.value.definition.routes) |route| try collector.local(route.service, route.location, .dependency);

            continue;
        }

        const packages = rx.module_reference.dependencies(options.project, absolute);
        const module: rx.ModuleSource = .{ .path = path, .node = parsed.value.node, .packages = packages, .references = document.references };

        if (std.mem.endsWith(u8, path, ".store.rx")) {
            try stores.append(allocator, module);
        } else if (!is_gateway) {
            try sources.append(allocator, .{ .path = path, .source = source, .packages = packages });
            try modules.append(allocator, module);
        }

        @import("rx_analysis").project.source_graph.references.collect(&collector, module) catch |err| {
            if (err == error.InvalidSourceGraph) return null;

            return err;
        };
    }

    return .{ .gateway = gateway_source, .modules = modules.items, .stores = stores.items, .sources = sources.items, .functions = functions.items };
}

pub fn outside(path: []const u8) bool {
    return std.fs.path.isAbsolute(path) or std.mem.eql(u8, path, "..") or std.mem.startsWith(u8, path, "../") or std.mem.startsWith(u8, path, "..\\");
}

fn report(writer: *std.Io.Writer, path: []const u8, issue: rx.Diagnostic) !void {
    try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, issue.location.line, issue.location.column, issue.code, issue.message });
}
