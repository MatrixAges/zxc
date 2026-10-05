const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Block = @import("block.zig");

pub const Place = struct {
    value: ir.ExprId,
    parent: ?*const Place,
    projection: union(enum) { root, field: u32, tuple_field: u32, index: ir.ExprId },
};

pub fn prepare(block: *Block, target: ir.ExprId) zx.Error!*const Place {
    const analyzer = block.analyzer;
    const source = analyzer.node(target);
    var place: Place = undefined;

    switch (source.value) {
        .reference => |symbol| {
            if (symbol != block.state) return analyzer.reporter.fail(.ownership, source.span, "only the loop state parameter can be updated");

            place = .{ .value = target, .parent = null, .projection = .root };
        },
        .field, .tuple_field => |field| {
            const parent = try prepare(block, field.target);
            const projected = ir.Projection{ .target = parent.value, .index = field.index };
            const value = try analyzer.append(.{ .span = source.span, .type_id = source.type_id, .value = if (source.value == .field) .{ .field = projected } else .{ .tuple_field = projected } });

            place = .{ .value = value, .parent = parent, .projection = if (source.value == .field) .{ .field = field.index } else .{ .tuple_field = field.index } };
        },
        .index => |item| {
            const parent = try prepare(block, item.target);
            const index = try block.temporary(item.index);
            const value = try analyzer.append(.{ .span = source.span, .type_id = source.type_id, .value = .{ .index = .{ .target = parent.value, .index = index } } });

            place = .{ .value = value, .parent = parent, .projection = .{ .index = index } };
        },
        else => return analyzer.reporter.fail(.ownership, source.span, "state updates require a field, index or the state parameter"),
    }

    place.value = try block.temporary(place.value);
    const result = try analyzer.allocator.create(Place);

    result.* = place;

    return result;
}

pub fn replace(self: *Analyzer, place: *const Place, value: ir.ExprId) zx.Error!ir.ExprId {
    const parent = place.parent orelse return value;
    const container = self.node(parent.value);

    const replacement = switch (place.projection) {
        .root => unreachable,
        .index => |index| try self.append(.{ .span = container.span, .type_id = container.type_id, .value = .{ .list_update = .{ .target = parent.value, .index = index, .value = value } } }),
        .field => |selected| result: {
            const fields = self.types.get(container.type_id).object;
            const updated = try self.allocator.alloc(ir.ObjectField, fields.len);

            for (fields, updated, 0..) |item, *entry, index| entry.* = .{
                .index = @intCast(index),
                .value = if (index == selected) value else try self.append(.{
                    .span = container.span,
                    .type_id = item.type_id,
                    .value = .{ .field = .{ .target = parent.value, .index = @intCast(index) } },
                }),
            };

            break :result try self.append(.{ .span = container.span, .type_id = container.type_id, .value = .{ .object = .{ .fields = updated, .evaluation = &.{} } } });
        },
        .tuple_field => |selected| result: {
            const elements = self.types.get(container.type_id).tuple;
            const updated = try self.allocator.alloc(ir.ExprId, elements.len);

            for (elements, updated, 0..) |type_id, *entry, index| entry.* = if (index == selected) value else try self.append(.{
                .span = container.span,
                .type_id = type_id,
                .value = .{ .tuple_field = .{ .target = parent.value, .index = @intCast(index) } },
            });

            break :result try self.append(.{ .span = container.span, .type_id = container.type_id, .value = .{ .tuple = updated } });
        },
    };

    return replace(self, parent, replacement);
}
