const std = @import("std");
const dsl = @import("dsl");
const rx = @import("rx");
const target = @import("../call/target.zig");

pub const Route = struct { path: []const u8, method: ?rx.gateway.Method, service: []const u8, location: rx.ast.Location };

pub fn collect(allocator: std.mem.Allocator, owner: []const u8, node: rx.ast.Node, reporter: *dsl.Reporter) dsl.Error![]const Route {
    var builder = Builder{ .allocator = allocator, .owner = owner, .reporter = reporter };

    defer builder.methods.deinit(allocator);

    try builder.append(node.children, "");

    return builder.routes.toOwnedSlice(allocator);
}

const Builder = struct {
    allocator: std.mem.Allocator,
    owner: []const u8,
    reporter: *dsl.Reporter,
    routes: std.ArrayList(Route) = .empty,
    methods: std.StringHashMapUnmanaged(u16) = .empty,
    fn append(self: *@This(), nodes: []const rx.ast.Node, prefix: []const u8) dsl.Error!void {
        for (nodes) |node| {
            const group = std.mem.eql(u8, node.name, "Group");
            const key: []const u8 = if (group) "prefix" else "path";
            const path = target.attribute(node, key).value;

            if (!validPath(path)) return fail(node, key, "Gateway paths must be absolute literal paths without query, fragment, parameters or wildcards", self.reporter);

            const joined = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ std.mem.trimEnd(u8, prefix, "/"), path });

            if (group) {
                try self.append(node.children, joined);

                continue;
            }

            const method = if (target.optionalAttribute(node, "method")) |name| std.meta.stringToEnum(rx.gateway.Method, name.value).? else null;
            const mask: u16 = if (method) |value| @as(u16, 1) << @intCast(@intFromEnum(value)) else std.math.maxInt(u16);
            const entry = try self.methods.getOrPut(self.allocator, joined);

            if (entry.found_existing and entry.value_ptr.* & mask != 0) return fail(node, "path", "Gateway routes overlap after Group prefix expansion", self.reporter);

            entry.value_ptr.* = if (entry.found_existing) entry.value_ptr.* | mask else mask;

            const service = rx.resolveModulePath(self.allocator, self.owner, target.attribute(node, "service").value) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return fail(node, "service", "Gateway service must resolve to an ordinary module inside the project", self.reporter);
            };

            try self.routes.append(self.allocator, .{ .path = joined, .method = method, .service = service, .location = node.location });
        }
    }
};

fn validPath(path: []const u8) bool {
    if (path.len == 0 or path[0] != '/') return false;

    var index: usize = 0;

    while (index < path.len) : (index += 1) {
        const byte = path[index];

        if (byte <= 0x20 or byte >= 0x7f or std.mem.indexOfScalar(u8, "?#\\*{}", byte) != null) return false;
        if (byte == ':' and index > 0 and path[index - 1] == '/') return false;

        if (byte == '%') {
            if (index + 2 >= path.len or !std.ascii.isHex(path[index + 1]) or !std.ascii.isHex(path[index + 2])) return false;

            index += 2;
        }
    }

    return true;
}

fn fail(node: rx.ast.Node, key: []const u8, message: []const u8, reporter: *dsl.Reporter) dsl.Error {
    return reporter.fail(.{ .code = .context, .location = target.attribute(node, key).value_location, .element = node.name, .attribute = key, .message = message });
}
