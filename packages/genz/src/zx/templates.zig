const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const intrinsic = @import("intrinsics.zig");

pub fn lower(self: *Lower, items: []const ir.ExprId, values: []const *const node.Expression) Lower.Error!*const node.Expression {
    const strings = try self.allocator.alloc(*const node.Expression, items.len);

    for (items, values, strings) |item, value, *text| {
        const scalar = self.program.typeOf(self.program.expression(item).type_id).scalar;

        text.* = switch (scalar) {
            .string => value,
            .bool => try self.builder.expression(.{ .conditional = .{ .condition = value, .yes = try self.builder.string("true"), .no = try self.builder.string("false") } }),
            else => try intrinsic.standard(self, &.{ "fmt", "allocPrint" }, &.{ try self.builder.identifier("allocator"), try self.builder.string("{d}"), try self.builder.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, &.{value}) }) }, true),
        };
    }

    const byte = try self.builder.expression(.{ .primitive = .u8 });
    const array = try self.builder.expression(.{ .array = .{ .element_type = try self.builder.expression(.{ .const_slice = byte }), .values = strings } });

    return intrinsic.standard(self, &.{ "mem", "concat" }, &.{ try self.builder.identifier("allocator"), byte, try self.builder.expression(.{ .address_of = array }) }, true);
}
