const std = @import("std");
const dsl = @import("dsl");
const rx = @import("rx");
const target = @import("call/target.zig");
const routes = @import("gateway/routes.zig");
pub const Route = routes.Route;
pub const Options = struct { owner: []const u8, node: rx.ast.Node, validated_attributes: ?Attributes = null };
pub const Definition = struct { source_path: []const u8, name: []const u8, protocol: ?rx.gateway.Protocol, listen: ?[]const u8, routes: []const Route, max_header_bytes: u32, max_body_bytes: u32 };
pub const Value = union(enum) { definition: Definition, diagnostic: target.Diagnostic };
const Attributes = @FieldType(rx.gateway.Gateway.Data, "attributes");

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

    const owned = arena.allocator();

    const value = if (options.validated_attributes) |attributes|
        try analyzeIn(owned, allocator, options, attributes)

    else value: {
        var checked = try dsl.validate(rx.gateway.Gateway, allocator, options.node, {});

        defer checked.deinit();

        if (checked.value == .diagnostic) break :value try failure(owned, options.owner, checked.value.diagnostic);

        break :value try analyzeIn(owned, allocator, options, checked.value.data.attributes);
    };

    return .{ .arena = arena, .value = value };
}

fn analyzeIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, options: Options, attributes: Attributes) std.mem.Allocator.Error!Value {
    const owner = rx.normalizeGatewayPath(allocator, options.owner) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, options.owner, .{ .code = .context, .location = options.node.location, .element = options.node.name, .message = "Gateway must have a project-relative .gateway.rx path" });
    };

    if ((attributes.protocol orelse .http) != .http) return failure(allocator, owner, .{ .code = .context, .location = target.attribute(options.node, "protocol").value_location, .element = options.node.name, .message = "Gateway execution analysis currently supports HTTP only" });

    var reporter: dsl.Reporter = .{};

    const collected = routes.collect(allocator, backing, owner, options.node, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, owner, reporter.diagnostic.?);
    };

    if (checkLimits(attributes.max_header_bytes, attributes.listen orelse "127.0.0.1:8080")) |message| return failure(allocator, owner, .{ .code = .context, .location = options.node.location, .element = options.node.name, .message = message });

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

const header_limit_message = "max_header_bytes must be between 1 and 16777216";
const listen_message = "HTTP listen requires a numeric IP address and port";

fn checkLimits(header_bytes: u32, listen: []const u8) ?[]const u8 {
    if (comptime @import("rx_options").generated_graph) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const issue = @import("generated_rx_gateway_limits").executeValue(empty.allocator(), &.{ .header_bytes = header_bytes, .listen = listen }) catch unreachable;

        switch (issue) {
            .None => {},
            .Header => return header_limit_message,
            .Listen => return listen_message,
        }
    } else {
        if (header_bytes == 0 or header_bytes > 16 * 1024 * 1024) return header_limit_message;
        if (!seedPort(listen)) return listen_message;
    }

    _ = std.Io.net.IpAddress.parseLiteral(listen) catch return listen_message;

    return null;
}

fn seedPort(listen: []const u8) bool {
    const separator = if (std.mem.startsWith(u8, listen, "["))
        (std.mem.indexOf(u8, listen, "]:") orelse return false) + 1

    else
        std.mem.indexOfScalar(u8, listen, ':') orelse return false;

    const port = listen[separator + 1 ..];

    if (port.len == 0) return false;
    for (port) |byte| if (!std.ascii.isDigit(byte)) return false;

    return true;
}
