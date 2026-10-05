const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsics = @import("intrinsics.zig");
pub const Storage = struct { buffer: *const node.Expression, started: *const node.Expression };

pub fn lower(self: *Lower, update: ir.ListUpdate, storage: ?Storage) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(update.target));
    const index = try aggregate.bind(self, &body, try self.expr(update.index));
    const value = try aggregate.bind(self, &body, try self.expr(update.value));

    try intrinsics.failIf(self, &body, try intrinsics.binary(self, .greater_equal, index, try self.field(source, "len")), "IndexOutOfBounds");

    const element = self.program.typeOf(self.program.expression(update.target).type_id).list;
    const copy = try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ self.types[@backingInt(element)], source }, true);

    const buffer = if (storage) |shared| blk: {
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
