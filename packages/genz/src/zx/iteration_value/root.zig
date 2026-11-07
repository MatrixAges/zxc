const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const analysis = @import("../iteration_layout.zig");
const Self = @This();

lowering: *Lower,
declarations: *std.ArrayList(node.Statement),
inline_lists: bool = false,
types: @import("../expression_map.zig").Map(ir.TypeId) = .empty,
symbols: @import("../members.zig") = .empty,
cache: @import("../expression_map.zig").Map(ir.ExprId) = .empty,
reads: @import("../counter.zig") = .empty,
transfers: std.ArrayList(struct { type_id: ir.TypeId, owner: node.ExpressionId, value: node.ExpressionId, ready: node.ExpressionId }) = .empty,
argument: ?struct { id: ir.ExprId, value: node.ExpressionId } = null,
pub fn represented(self: *const Self, id: ir.TypeId) bool {
    return analysis.represented(self.lowering, id) or self.buffered(id);
}

pub fn buffered(self: *const Self, id: ir.TypeId) bool {
    return self.inline_lists and self.lowering.program.typeOf(id) == .list;
}

pub fn bufferedPath(self: *const Self, id: ir.TypeId, path: []const u32) bool {
    var current = id;

    for (path) |step| {
        while (self.lowering.program.typeOf(current) == .optional) current = self.lowering.program.typeOf(current).optional;

        current = switch (self.lowering.program.typeOf(current)) {
            .object => |fields| fields.at(step).type_id,
            .tuple => |items| items.at(step),
            else => return false,
        };
    }

    return self.buffered(current);
}

pub fn expression(self: *Self, id: ir.ExprId) Lower.Error!?node.ExpressionId {
    const lowering = self.lowering;
    const value = lowering.program.expression(id);

    if (self.argument) |argument| if (argument.id == id) return argument.value;

    if (self.cache.get(id)) |cached| {
        try self.reads.increment(lowering.allocator, id);

        return cached;
    }

    if (lowering.cache.contains(id)) {
        if (!self.represented(value.type_id)) return null;

        return try self.unpack(id);
    }

    switch (value.value) {
        .reference => |symbol| {
            if (self.symbols.contains(symbol)) {
                lowering.used[@backingInt(symbol)] = true;

                return try lowering.builder.identifier(lowering.names[@backingInt(symbol)]);
            }
        },
        .field => |field| return try lowering.field(try lowering.expr(field.target), lowering.program.typeOf(lowering.program.expression(field.target).type_id).object.at(field.index).name),
        .optional_value => |child| return try lowering.builder.expression(.{ .optional_unwrap = try lowering.expr(child) }),
        .tuple_field => |field| {
            if (try @import("../collections.zig").projection(lowering, field.target, field.index)) |selected| return selected;

            return try lowering.field(try lowering.expr(field.target), try std.fmt.allocPrint(lowering.allocator, "{d}", .{field.index}));
        },
        .scope => |scope| return try @import("scope.zig").lower(self, scope),
        .index => |item| if (self.buffered(lowering.program.expression(item.target).type_id)) return try @import("../intrinsics.zig").index(lowering, try lowering.field(try lowering.expr(item.target), "items"), try lowering.expr(item.index)),
        .length => |child| if (self.buffered(lowering.program.expression(child).type_id)) return try lowering.cast(try lowering.typeExpr(value.type_id), try lowering.field(try lowering.field(try lowering.expr(child), "items"), "len")),
        .list_update => |write| if (self.buffered(lowering.program.expression(write.target).type_id)) return try @import("mutation.zig").update(self, id),
        .list_operation => |operation| if (self.buffered(lowering.program.expression(operation.target).type_id)) return try @import("mutation.zig").operation(self, id),
        .list => |items| if (self.buffered(value.type_id)) return try @import("list.zig").lower(self, value.type_id, items),
        .call => |call| {
            if (analysis.represented(lowering, lowering.program.expression(call.argument).type_id)) return try @import("invocation.zig").lower(self, id, call.argument);
        },
        else => {},
    }

    if (!self.represented(value.type_id)) return null;

    return switch (value.value) {
        .none => try lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.builder.expression(.null_value)),
        .some => |child| try lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.expr(child)),
        .binary => try lowering.regular(id),
        .object, .tuple => try @import("aggregate.zig").lower(self, id),
        .list_operation => try @import("../collections.zig").lowerValue(lowering, id, try @import("types.zig").get(self, value.type_id)),
        .conditional => |conditional| try lowering.builder.expression(.{ .conditional = .{
            .condition = try lowering.expr(conditional.condition),
            .yes = try lowering.expr(conditional.yes),
            .no = try lowering.expr(conditional.no),
        } }),
        .match_expr => |selection| try @import("../match.zig").lower(lowering, selection),
        else => try self.unpack(id),
    };
}

fn unpack(self: *Self, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;
    const value = try aggregate.bind(lowering, &body, try lowering.regular(id));

    return aggregate.finish(lowering, &body, try @import("conversion.zig").convert(self, lowering.program.expression(id).type_id, value, false));
}
