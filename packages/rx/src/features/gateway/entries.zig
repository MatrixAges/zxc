const std = @import("std");
const dsl = @import("dsl");
const Route = @import("labels/Route.zig").Route;
const Group = @import("labels/Group.zig").Group;

pub const Entry = struct {
    pub const Data = union(enum) {
        route: Route.Data,
        group: Group.Data,
    };

    pub fn decode(allocator: std.mem.Allocator, node: dsl.ast.Node, reporter: *dsl.Reporter, context: anytype) dsl.Error!Data {
        if (Route.matches(node.name)) return .{ .route = try Route.decode(allocator, node, reporter, context) };
        if (Group.matches(node.name)) return .{ .group = try Group.decode(allocator, node, reporter, context) };

        return reporter.fail(.{
            .code = .unexpected_element,
            .location = node.location,
            .element = node.name,
            .message = "Gateway and Group only allow Route or Group",
        });
    }
};
