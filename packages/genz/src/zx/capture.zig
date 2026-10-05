const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Boundary = struct { name: []const u8, label: []const u8, failure: *const node.Expression };

pub fn lower(self: *Lower, type_id: ir.TypeId, child: ir.ExprId) Lower.Error!*const node.Expression {
    return self.construct(type_id, try lowerValue(self, type_id, child));
}

pub fn lowerValue(self: *Lower, type_id: ir.TypeId, child: ir.ExprId) Lower.Error!*const node.Expression {
    const children = self.program.typeOf(type_id).tuple;
    const payload = self.program.expression(child).type_id;
    const is_void = self.program.typeOf(payload) == .scalar and self.program.typeOf(payload).scalar == .void;
    const name = try self.fresh("zx_error");
    const label = try self.fresh("zx_capture");
    const layout = self.layouts[@backingInt(type_id)];
    const empty = try self.builder.expression(if (is_void) .unit else .null_value);
    const failed = try self.builder.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, &.{ try self.builder.identifier(name), empty }) });
    const previous = self.capture;

    const result = blk: {
        self.capture = .{ .name = name, .label = label, .failure = try self.cast(layout, failed) };
        defer self.capture = previous;

        break :blk try self.expr(child);
    };

    var body: std.ArrayList(node.Statement) = .empty;

    const value = if (is_void) blk: {
        try body.append(self.allocator, .{ .expression = result });

        break :blk try self.builder.expression(.unit);
    } else try self.cast(self.types[@backingInt(children[1])], result);

    const succeeded = try self.builder.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, &.{ try self.builder.expression(.null_value), value }) });

    try body.append(self.allocator, .{ .break_value = .{ .label = label, .value = try self.cast(layout, succeeded) } });

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try body.toOwnedSlice(self.allocator) } });
}
