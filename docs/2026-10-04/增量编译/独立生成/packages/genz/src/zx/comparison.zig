const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsic = @import("intrinsics.zig");

pub fn equal(self: *Lower, type_id: ir.TypeId, left: *const node.Expression, right: *const node.Expression) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const first = try aggregate.bind(self, &body, left);
    const second = try aggregate.bind(self, &body, right);

    return aggregate.finish(self, &body, try compare(self, type_id, first, second));
}

fn compare(self: *Lower, type_id: ir.TypeId, left: *const node.Expression, right: *const node.Expression) Lower.Error!*const node.Expression {
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

pub fn ordering(self: *Lower, type_id: ir.TypeId) Lower.Error!node.Declaration {
    const left = try self.builder.identifier("left");
    const right = try self.builder.identifier("right");
    const scalar = self.program.typeOf(type_id).scalar;
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });

    if (scalar == .f32 or scalar == .f64) {
        for ([_]*const node.Expression{ left, right }, [_]bool{ false, true }) |value, result| {
            try body.append(self.allocator, .{ .branch = .{ .condition = try intrinsic.standard(self, &.{ "math", "isNan" }, &.{value}, false), .yes = try self.allocator.dupe(node.Statement, &.{.{ .result = try self.builder.expression(.{ .boolean = result }) }}), .no = &.{} } });
        }
    }

    const result = if (scalar == .string) try intrinsic.standard(self, &.{ "mem", "lessThan" }, &.{ try self.builder.expression(.{ .primitive = .u8 }), left, right }, false) else try intrinsic.binary(self, .less, left, right);

    try body.append(self.allocator, .{ .result = result });

    return .{ .function = .{
        .name = try name(self, type_id),
        .parameters = try self.allocator.dupe(node.Field, &.{ .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .void }) }, .{ .name = "left", .value = self.types[@intFromEnum(type_id)] }, .{ .name = "right", .value = self.types[@intFromEnum(type_id)] } }),
        .return_type = try self.builder.expression(.{ .primitive = .bool }),
        .body = body.items,
    } };
}

pub fn name(self: *Lower, type_id: ir.TypeId) Lower.Error![]const u8 {
    if (self.type_names != null) return std.fmt.allocPrint(self.allocator, "zx_compare_{s}", .{@tagName(self.program.typeOf(type_id).scalar)});

    return std.fmt.allocPrint(self.allocator, "zx_compare_{d}", .{@intFromEnum(type_id)});
}
