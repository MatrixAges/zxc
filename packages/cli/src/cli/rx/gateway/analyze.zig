const std = @import("std");
const compiler = @import("compiler");
const gateway = @import("rx_analysis").gateway;
const collection = @import("../collection.zig");
const services = @import("../../library/analyze.zig");
const Loaded = @import("../../project.zig").Loaded;
const Inputs = @import("../../watch/inputs.zig");
const Export = @import("../../../package/manifest/model.zig").Export;
pub const Options = struct { io: std.Io, loaded: Loaded, writer: *std.Io.Writer, inputs: ?*Inputs = null };

pub const Result = struct {
    gateway: gateway.Result,
    services: ?services.Result,
    pub fn deinit(self: *Result) void {
        if (self.services) |*value| value.deinit();

        self.gateway.deinit();

        self.* = undefined;
    }

    pub fn link(self: *Result, allocator: std.mem.Allocator) !?compiler.library.Result {
        if (self.services) |*value| return try value.link(allocator);

        return null;
    }
};

pub fn run(allocator: std.mem.Allocator, options: Options) !?Result {
    const root = try std.fs.path.resolve(allocator, &.{options.loaded.project.root_dir});
    const owner = try std.fs.path.relative(allocator, root, null, root, options.loaded.project.entry);

    if (collection.outside(owner)) return error.RxEntryOutsideProject;
    if (options.loaded.config.library != null) return error.GatewaySourceRequired;

    var loaded = try collection.load(allocator, .{ .io = options.io, .root = root, .entry = owner, .writer = options.writer, .inputs = options.inputs, .check_initializers = false }) orelse return null;

    defer loaded.deinit();

    const source = loaded.data.gateway orelse return error.ExpectedGateway;
    var analyzed = try gateway.analyze(allocator, .{ .owner = source.path, .node = source.node });
    var transferred = false;

    defer if (!transferred) analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        try options.writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return null;
    }

    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    const scratch = temporary.allocator();
    var exports: std.ArrayList(Export) = .empty;
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    for (analyzed.value.definition.routes) |route| {
        if ((try seen.getOrPut(scratch, route.service)).found_existing) continue;
        try exports.append(scratch, .{ .path = route.service, .source = route.service });
    }

    var configured = options.loaded;

    configured.config.exports = exports.items;
    const prepared = if (exports.items.len == 0) null else (try services.run(allocator, .{ .io = options.io, .loaded = configured, .writer = options.writer, .inputs = options.inputs })) orelse return null;

    transferred = true;

    return .{ .gateway = analyzed, .services = prepared };
}
