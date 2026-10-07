const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsics = @import("intrinsics.zig");
pub const Storage = struct { buffer: *const node.Expression, started: *const node.Expression, capacity: ?@import("iteration_buffer/capacity.zig") = null, enabled: ?*const node.Expression = null, fallback_capacity: ?@import("iteration_buffer/capacity.zig") = null };

pub fn lower(self: *Lower, update: ir.ListUpdate, storage: ?Storage) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(update.target));
    const index = try aggregate.bind(self, &body, try self.expr(update.index));

    try intrinsics.failIf(self, &body, try intrinsics.binary(self, .greater_equal, index, try self.field(source, "len")), "IndexOutOfBounds");

    const value = try aggregate.bind(self, &body, try self.expr(update.value));
    const element = self.program.typeOf(self.program.expression(update.target).type_id).list;

    if (storage) |shared| if (shared.enabled) |enabled| {
        self.uses_buffers = true;

        var active = shared;
        active.enabled = null;

        const fallback: ?Storage = if (shared.fallback_capacity) |capacity| .{ .buffer = try capacity.items(self), .started = capacity.started, .capacity = capacity } else null;

        return aggregate.finish(self, &body, try self.cast(self.types[@backingInt(self.program.expression(update.target).type_id)], try self.builder.expression(.{ .conditional = .{
            .condition = enabled,
            .yes = try write(self, source, index, value, element, active),
            .no = try write(self, source, index, value, element, fallback),
        } })));
    };

    return aggregate.finish(self, &body, try write(self, source, index, value, element, storage));
}

fn write(self: *Lower, source: *const node.Expression, index: *const node.Expression, value: *const node.Expression, element: ir.TypeId, storage: ?Storage) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const copy = try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ try @import("iteration_value/types.zig").element(self, element), source }, true);

    const buffer = if (storage) |shared| blk: {
        if (shared.capacity) |capacity| {
            try capacity.prepare(self, &body, source);

            break :blk try capacity.items(self);
        }

        try body.append(self.allocator, .{ .branch = .{
            .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = shared.started } }),
            .yes = try self.allocator.dupe(node.Statement, &.{
                .{ .assignment = .{ .target = shared.buffer, .value = copy } },
                .{ .assignment = .{ .target = shared.started, .value = try self.builder.expression(.{ .boolean = true }) } },
            }),
            .no = &.{},
        } });

        break :blk shared.buffer;
    } else try aggregate.bind(self, &body, copy);

    const slot = try self.builder.expression(.{ .index = .{ .target = buffer, .index = try self.builtin(.intCast, &.{index}) } });

    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = value } });

    return aggregate.finish(self, &body, buffer);
}
