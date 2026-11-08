const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const intrinsic = @import("intrinsics.zig");

pub fn equal(self: *Lower, type_id: ir.TypeId, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("comparison/seed.zig").equal(self, type_id, left, right);

    return @import("comparison/equality.zig").lower(self, type_id, left, right);
}

pub fn ordering(self: *Lower, type_id: ir.TypeId) Lower.Error!node.Declaration {
    const left = try self.builder.identifier("left");
    const right = try self.builder.identifier("right");
    const scalar = self.program.typeOf(type_id).scalar;
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });

    if (scalar == .f32 or scalar == .f64) {
        for ([_]node.ExpressionId{ left, right }, [_]bool{ false, true }) |value, result| {
            try body.append(self.allocator, .{ .branch = .{ .condition = try intrinsic.standard(self, &.{ "math", "isNan" }, &.{value}, false), .yes = try self.builder.statements(&.{.{ .result = try self.builder.expression(.{ .boolean = result }) }}), .no = .{} } });
        }
    }

    const result = if (scalar == .string) try intrinsic.standard(self, &.{ "mem", "lessThan" }, &.{ try self.builder.expression(.{ .primitive = .u8 }), left, right }, false) else try intrinsic.binary(self, .less, left, right);

    try body.append(self.allocator, .{ .result = result });

    return .{ .function = .{
        .name = try name(self, type_id),
        .parameters = try self.allocator.dupe(node.Field, &.{ .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .void }) }, .{ .name = "left", .value = try self.typeExpr(type_id) }, .{ .name = "right", .value = try self.typeExpr(type_id) } }),
        .return_type = try self.builder.expression(.{ .primitive = .bool }),
        .body = try self.builder.statements(body.items),
    } };
}

pub fn name(self: *Lower, type_id: ir.TypeId) Lower.Error![]const u8 {
    if (self.type_names != null) return std.fmt.allocPrint(self.allocator, "zx_compare_{s}", .{@tagName(self.program.typeOf(type_id).scalar)});

    return std.fmt.allocPrint(self.allocator, "zx_compare_{d}", .{@backingInt(type_id)});
}
