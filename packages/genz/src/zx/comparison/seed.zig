const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const std = @import("std");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");

pub fn equal(self: *Lower, type_id: ir.TypeId, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const first = try aggregate.bind(self, &body, left);
    const second = try aggregate.bind(self, &body, right);

    return aggregate.finish(self, &body, try compare(self, type_id, first, second));
}

fn compare(self: *Lower, type_id: ir.TypeId, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    const target = self.program.typeOf(type_id);

    if (target == .scalar and target.scalar == .string) return intrinsic.standard(self, &.{ "mem", "eql" }, &.{ try self.builder.expression(.{ .primitive = .u8 }), left, right }, false);
    if (target != .optional) return intrinsic.binary(self, .equal, left, right);

    const left_null = try intrinsic.binary(self, .equal, left, try self.builder.expression(.null_value));
    const right_null = try intrinsic.binary(self, .equal, right, try self.builder.expression(.null_value));

    return self.builder.expression(.{ .conditional = .{
        .condition = try intrinsic.binary(self, .logical_or, left_null, right_null),
        .yes = try intrinsic.binary(self, .logical_and, left_null, right_null),
        .no = try compare(self, target.optional, try self.builder.expression(.{ .optional_unwrap = left }), try self.builder.expression(.{ .optional_unwrap = right })),
    } });
}
