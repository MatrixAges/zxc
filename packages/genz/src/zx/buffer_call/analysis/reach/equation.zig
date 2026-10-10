const std = @import("std");
const ir = @import("zx").ir;
const Reach = @import("../reach.zig");
const flow = @import("../flow.zig");
const masks = @import("masks.zig");
const Error = Reach.Error;
const Node = Reach.Node;

const Children = struct {
    reach: *Reach,
    items: std.ArrayList(Reach.Index) = .empty,
    fn add(self: *Children, id: ir.ExprId, path: []const u32) Error!void {
        try self.items.append(self.reach.allocator, try self.reach.visit(id, path));
    }
    fn all(self: *Children, ids: []const ir.ExprId) Error!void {
        for (ids) |id| try self.add(id, &.{});
    }
    fn join(self: *Children, mask: ?[]const usize) Node {
        return .{ .low = 0, .kind = .join, .mask = mask, .children = self.items.items };
    }
};

/// Equation of one query; mirrors the per-origin alias rules with origin sets.
pub fn build(reach: *Reach, id: ir.ExprId, path: []const u32) Error!Node {
    const trace = reach.trace;
    const program = trace.program;
    const expression = trace.function.expressions.at(@backingInt(id));
    const none: Node = .{ .low = 0 };
    var selected = expression.type_id;

    for (path) |index| {
        while (program.typeOf(selected) == .optional) selected = program.typeOf(selected).optional;

        selected = switch (program.typeOf(selected)) {
            .object => |fields| if (index < fields.len) fields.at(index).type_id else return none,
            .tuple => |items| if (index < items.len) items.at(index) else return none,
            else => return none,
        };
    }

    if (flow.detached(program, selected) or program.typeOf(selected) == .native_reference) return none;

    const mask = try masks.filter(reach, selected);
    var children = Children{ .reach = reach };

    switch (expression.value) {
        .iteration => |value| {
            try children.add(value.initial, path);

            const chosen = try masks.chosen(reach, id, path);

            if (chosen) |lanes| if (std.mem.eql(usize, lanes, reach.universe)) return children.join(mask);
            try children.add(value.body, path);
            if (chosen) |lanes| return .{ .low = 0, .kind = .iteration, .mask = mask, .owned = lanes, .children = children.items.items };
        },
        .list_update => |value| {
            try children.add(value.target, &.{});
            try children.add(value.value, &.{});
        },
        .scope => |scope| try children.add(scope.result, path),
        .reference => |symbol| if (@backingInt(symbol) == 0) {
            return .{ .low = 0, .kind = .base, .base = try masks.prefixed(reach, mask, path) };
        } else if (trace.bindings[@backingInt(symbol)]) |binding| {
            try children.add(binding, path);
        } else if (trace.iterations[@backingInt(symbol)]) |iteration| {
            try children.add(iteration, path);
        } else return .{ .low = 0, .kind = .all, .mask = mask },
        .conditional => |value| {
            try children.add(value.yes, path);
            try children.add(value.no, path);
        },
        .match_expr => |value| {
            try children.add(value.fallback, path);
            for (0..value.arms.len) |record_index| try children.add(value.arms.at(record_index).result, path);
        },
        .field, .tuple_field => |projection| {
            const nested = try reach.allocator.alloc(u32, path.len + 1);

            nested[0] = projection.index;

            @memcpy(nested[1..], path);

            try children.add(projection.target, nested);
        },
        .object => |object| for (0..object.fields.len) |record_index| {
            const field = object.fields.at(record_index);

            if (path.len != 0 and field.index != path[0]) continue;

            try children.add(field.value, if (path.len == 0) &.{} else path[1..]);
        },
        .tuple => |items| if (path.len != 0) try children.add(items[path[0]], path[1..]) else try children.all(items),
        .list => |items| try children.all(items),
        .some, .optional_value => |child| try children.add(child, path),
        .capture => |child| if (path.len == 0 or path[0] == 1) try children.add(child, if (path.len == 0) &.{} else path[1..]) else return none,
        .binary => |value| {
            try children.add(value.left, path);
            try children.add(value.right, path);
        },
        .index => |value| try children.add(value.target, &.{}),
        .list_operation => |operation| {
            try children.add(operation.target, &.{});
            try children.all(operation.arguments);

            if (operation.kind == .pop and path.len != 0 and path[0] == 1) {
                return children.join(try masks.popped(reach, mask, trace.function.expressions.at(@backingInt(operation.target)).type_id));
            }
        },
        .call => |call| return @import("call.zig").build(reach, &children.items, call, path, selected, mask),
        .transform => |value| {
            try children.add(value.target, &.{});
            try children.add(value.body, &.{});
            if (value.initial) |initial| try children.add(initial, &.{});
        },
        else => return none,
    }

    return children.join(mask);
}
