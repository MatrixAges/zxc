const std = @import("std");
const dsl = @import("dsl");
const rx = @import("rx");
const target = @import("../call/target.zig");
pub const Route = struct { path: []const u8, method: ?rx.gateway.Method, service: []const u8, location: rx.ast.Location };

const Row = struct {
    node: *const rx.ast.Node,
    parent: ?u32,
    group: bool,
    part: []const u8,
    method: ?u32,
};

pub fn collect(allocator: std.mem.Allocator, backing: std.mem.Allocator, owner: []const u8, node: rx.ast.Node, reporter: *dsl.Reporter) dsl.Error![]const Route {
    if (node.children.len == 0) return &.{};
    if (comptime !@import("rx_options").generated_graph) return @import("routes/seed.zig").collect(allocator, owner, node, reporter);

    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    var rows: std.MultiArrayList(Row) = .empty;

    try flatten(temporary, &rows, node.children, null);

    const nodes = rows.items(.node);
    const parents = rows.items(.parent);
    const groups = rows.items(.group);
    const parts = rows.items(.part);
    const methods = rows.items(.method);
    const layout = try plan(temporary, parts, groups, parents);
    const paths = try temporary.alloc([]const u8, layout.len);
    const services = try temporary.alloc([]const u8, layout.len);
    const present = try temporary.alloc(bool, layout.len);
    var count: usize = 0;

    for (layout, paths, services, present, 0..) |length, *path, *service, *valid, row| {
        const prefix = if (parents[row]) |parent| paths[parent] else "";
        const scope = if (groups[row]) temporary else allocator;
        const size = std.math.cast(usize, length) orelse return error.OutOfMemory;
        const joined = try scope.alloc(u8, size);

        @memcpy(joined[0..prefix.len], prefix);
        @memcpy(joined[prefix.len..], parts[row][0 .. size - prefix.len]);

        path.* = joined;
        service.* = "";
        valid.* = false;

        if (groups[row]) continue;

        count += 1;

        service.* = rx.resolveModulePath(allocator, owner, target.attribute(nodes[row].*, "service").value) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            continue;
        };

        valid.* = true;
    }

    const conflicts = @import("generated_rx_gateway_conflicts").executeValue(temporary, &.{
        .paths = paths,
        .groups = groups,
        .methods = methods,
        .services = present,
    }) catch |err| return generatedError(err);

    switch (conflicts.issue) {
        .None => {},
        .Overlap => return fail(nodes[@intCast(conflicts.row)].*, "path", "Gateway routes overlap after Group prefix expansion", reporter),
        .Service => return fail(nodes[@intCast(conflicts.row)].*, "service", "Gateway service must resolve to an ordinary module inside the project", reporter),
    }

    if (layout.len != rows.len) {
        const key = if (groups[layout.len]) "prefix" else "path";

        return fail(nodes[layout.len].*, key, "Gateway paths must be absolute literal paths without query, fragment, parameters or wildcards", reporter);
    }

    const routes = try allocator.alloc(Route, count);
    var next: usize = 0;

    for (nodes, paths, services, groups, methods) |source, path, service, group, method| {
        if (group) continue;

        routes[next] = .{
            .path = path,
            .method = if (method) |tag| @as(rx.gateway.Method, @enumFromInt(tag)) else null,
            .service = service,
            .location = source.location,
        };

        next += 1;
    }

    return routes;
}

fn flatten(allocator: std.mem.Allocator, rows: *std.MultiArrayList(Row), nodes: []const rx.ast.Node, parent: ?u32) std.mem.Allocator.Error!void {
    for (nodes) |*node| {
        const group = std.mem.eql(u8, node.name, "Group");
        const key = if (group) "prefix" else "path";
        const method = if (target.optionalAttribute(node.*, "method")) |value| std.meta.stringToEnum(rx.gateway.Method, value.value).? else null;
        const row = std.math.cast(u32, rows.len) orelse return error.OutOfMemory;

        try rows.append(allocator, .{
            .node = node,
            .parent = parent,
            .group = group,
            .part = target.attribute(node.*, key).value,
            .method = if (method) |value| @intFromEnum(value) else null,
        });

        if (group) try flatten(allocator, rows, node.children, row);
    }
}

fn plan(allocator: std.mem.Allocator, parts: []const []const u8, groups: []const bool, parents: []const ?u32) std.mem.Allocator.Error![]const u64 {
    return @import("generated_rx_gateway_layout").executeValue(allocator, &.{ .parts = parts, .groups = groups, .parents = parents }) catch |err| generatedError(err);
}

fn generatedError(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}

fn fail(node: rx.ast.Node, key: []const u8, message: []const u8, reporter: *dsl.Reporter) dsl.Error {
    return reporter.fail(.{ .code = .context, .location = target.attribute(node, key).value_location, .element = node.name, .attribute = key, .message = message });
}
