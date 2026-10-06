const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Buffers = @import("../iteration_buffer/root.zig");
const aggregate = @import("../aggregate.zig");

pub fn convert(self: *Context, buffers: *const Buffers, id: ir.TypeId, value: *const node.Expression, path: *std.ArrayList(usize)) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    const layout = try @import("types.zig").get(self, id);

    return switch (lowering.program.typeOf(id)) {
        .object => |fields| blk: {
            const items = try lowering.allocator.alloc(node.Field, fields.len);

            for (items, 0..) |*item, index| {
                const field = fields.at(index);

                try path.append(lowering.allocator, index);

                item.* = .{ .name = field.name, .value = try convert(self, buffers, field.type_id, try lowering.field(value, field.name), path) };
                _ = path.pop();
            }

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
        },
        .tuple => |children| blk: {
            const items = try lowering.allocator.alloc(*const node.Expression, children.len);

            for (items, 0..) |*item, index| {
                try path.append(lowering.allocator, index);

                item.* = try convert(self, buffers, children.at(index), try lowering.field(value, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index})), path);
                _ = path.pop();
            }

            break :blk try lowering.cast(layout, try lowering.builder.expression(.{ .tuple = items }));
        },
        .list => |child| blk: {
            if (!@import("../iteration_layout.zig").represented(lowering.program, child)) break :blk value;

            const storage = for (buffers.fields.items) |field| {
                if (std.mem.eql(usize, field.path, path.items)) break field.storage;
            } else unreachable;

            const source = try aggregate.bind(lowering, self.declarations, value);
            const items = try storage.items(lowering);
            const length = try lowering.field(source, "len");
            const capture = try lowering.fresh("initial_element");
            const index = try lowering.fresh("initial_index");

            try self.declarations.append(lowering.allocator, .{ .expression = try storage.method(lowering, "ensureTotalCapacity", &.{length}, true) });
            try self.declarations.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.field(items, "len"), .value = length } });

            const converted = try @import("conversion.zig").convert(self, child, try lowering.builder.identifier(capture), false);
            const target = try lowering.builder.expression(.{ .index = .{ .target = items, .index = try lowering.builder.identifier(index) } });

            try self.declarations.append(lowering.allocator, .{ .for_loop = .{
                .iterable = source,
                .capture = capture,
                .index_capture = index,
                .body = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = target, .value = converted } }}),
            } });

            try self.declarations.append(lowering.allocator, .{ .assignment = .{ .target = storage.started, .value = try lowering.builder.expression(.{ .boolean = true }) } });

            break :blk try lowering.cast(layout, items);
        },
        else => @import("conversion.zig").convert(self, id, value, false),
    };
}
