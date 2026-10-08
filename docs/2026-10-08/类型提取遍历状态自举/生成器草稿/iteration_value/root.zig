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
types: std.AutoHashMapUnmanaged(ir.TypeId, *const node.Expression) = .empty,
symbols: std.AutoHashMapUnmanaged(ir.SymbolId, void) = .empty,
cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = .empty,
reads: std.AutoHashMapUnmanaged(ir.ExprId, usize) = .empty,
argument: ?struct { id: ir.ExprId, value: *const node.Expression } = null,
pub fn represented(self: *const Self, id: ir.TypeId) bool {
    return analysis.represented(self.lowering.program, id) or (self.inline_lists and self.lowering.program.typeOf(id) == .list);
}

pub fn expression(self: *Self, id: ir.ExprId) Lower.Error!?*const node.Expression {
    const lowering = self.lowering;
    const value = lowering.program.expression(id);

    if (self.argument) |argument| if (argument.id == id) return argument.value;

    if (self.cache.get(id)) |cached| {
        const count = try self.reads.getOrPut(lowering.allocator, id);

        if (!count.found_existing) count.value_ptr.* = 0;

        count.value_ptr.* += 1;

        return cached;
    }

    if (lowering.cache.contains(id)) {
        if (!self.represented(value.type_id)) return null;

        return try self.unpack(id);
    }

    if (lowering.append_overrides.contains(id) and (!self.inline_lists or analysis.leaf(lowering.program, value.type_id))) return try self.unpack(id);

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
        .index => |item| if (self.inline_lists) return try @import("../intrinsics.zig").index(lowering, try lowering.expr(item.target), try lowering.expr(item.index)),
        .list_update => |update| if (self.inline_lists) return try @import("../list_update.zig").lower(lowering, update, lowering.list_update_buffers.get(id)),
        .list => |items| if (self.inline_lists) return try @import("list.zig").lower(self, value.type_id, items),
        .call => |call| {
            if (analysis.represented(lowering.program, lowering.program.expression(call.argument).type_id)) return try @import("invocation.zig").lower(self, id, call.argument);
        },
        else => {},
    }

    if (!self.represented(value.type_id)) return null;

    return switch (value.value) {
        .none => try lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.builder.expression(.null_value)),
        .some => |child| try lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.expr(child)),
        .binary => try lowering.regular(id),
        .object, .tuple => try @import("aggregate.zig").lower(self, id),
        .list_operation => |operation| try @import("../collections.zig").lowerValue(lowering, value.type_id, operation, try @import("types.zig").get(self, value.type_id), lowering.collection_buffers.get(id)),
        .conditional => |conditional| try lowering.builder.expression(.{ .conditional = .{
            .condition = try lowering.expr(conditional.condition),
            .yes = try lowering.expr(conditional.yes),
            .no = try lowering.expr(conditional.no),
        } }),
        .match_expr => |selection| try @import("../match.zig").lower(lowering, selection),
        else => try self.unpack(id),
    };
}

fn unpack(self: *Self, id: ir.ExprId) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;
    const value = try aggregate.bind(lowering, &body, try lowering.regular(id));

    return aggregate.finish(lowering, &body, try @import("conversion.zig").convert(self, lowering.program.expression(id).type_id, value, false));
}
