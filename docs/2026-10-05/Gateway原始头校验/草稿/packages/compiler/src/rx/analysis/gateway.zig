const std = @import("std");
const dsl = @import("dsl");
const rx = @import("rx");
const target = @import("call/target.zig");
const routes = @import("gateway/routes.zig");
pub const Route = routes.Route;
pub const Options = struct { owner: []const u8, node: rx.ast.Node };
pub const Definition = struct { source_path: []const u8, name: []const u8, protocol: ?rx.gateway.Protocol, listen: ?[]const u8, routes: []const Route, max_header_bytes: u32, max_body_bytes: u32 };
pub const Value = union(enum) { definition: Definition, diagnostic: target.Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn analyze(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try analyzeIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn analyzeIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var checked = try dsl.validate(rx.gateway.Gateway, allocator, options.node, {});

    defer checked.deinit();

    if (checked.value == .diagnostic) return failure(allocator, options.owner, checked.value.diagnostic);

    const owner = rx.normalizeGatewayPath(allocator, options.owner) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, options.owner, .{ .code = .context, .location = options.node.location, .element = options.node.name, .message = "Gateway must have a project-relative .gateway.rx path" });
    };

    if ((checked.value.data.attributes.protocol orelse .http) != .http) return failure(allocator, owner, .{ .code = .context, .location = target.attribute(options.node, "protocol").value_location, .element = options.node.name, .message = "Gateway execution analysis currently supports HTTP only" });

    var reporter: dsl.Reporter = .{};

    const collected = routes.collect(allocator, owner, options.node, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, owner, reporter.diagnostic.?);
    };

    const attributes = checked.value.data.attributes;

    if (attributes.max_header_bytes == 0 or attributes.max_header_bytes > 16 * 1024 * 1024) return failure(allocator, owner, .{ .code = .context, .location = options.node.location, .element = options.node.name, .message = "max_header_bytes must be between 1 and 16777216" });
    if (!validListen(attributes.listen orelse "127.0.0.1:8080")) return failure(allocator, owner, .{ .code = .context, .location = options.node.location, .element = options.node.name, .message = "HTTP listen requires a numeric IP address and port" });

    return .{ .definition = .{
        .source_path = owner,
        .name = try allocator.dupe(u8, attributes.name),
        .protocol = attributes.protocol,
        .listen = if (attributes.listen) |listen| try allocator.dupe(u8, listen) else null,
        .routes = collected,
        .max_header_bytes = attributes.max_header_bytes,
        .max_body_bytes = attributes.max_body_bytes,
    } };
}

fn failure(allocator: std.mem.Allocator, path: []const u8, issue: rx.Diagnostic) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = path, .location = issue.location, .code = @tagName(issue.code), .message = issue.message });

    return .{ .diagnostic = failed.diagnostic };
}

fn validListen(listen: []const u8) bool {
    const separator = if (std.mem.startsWith(u8, listen, "["))
        (std.mem.indexOf(u8, listen, "]:") orelse return false) + 1

    else
        std.mem.indexOfScalar(u8, listen, ':') orelse return false;

    const port = listen[separator + 1 ..];

    if (port.len == 0) return false;
    for (port) |byte| if (!std.ascii.isDigit(byte)) return false;

    _ = std.Io.net.IpAddress.parseLiteral(listen) catch return false;

    return true;
}
