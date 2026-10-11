const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const intrinsic = @import("intrinsics.zig");

pub fn lower(self: *Lower, items: []const ir.ExprId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const strings = try self.allocator.alloc(node.ExpressionId, items.len);

    for (items, values, strings) |item, value, *text| {
        const scalar = self.program.typeOf(self.program.expression(item).type_id).scalar;

        text.* = switch (scalar) {
            .string => value,
            .bool => try self.builder.expression(.{ .conditional = .{ .condition = value, .yes = try self.builder.string("true"), .no = try self.builder.string("false") } }),
            .f32, .f64 => try intrinsic.standard(self, &.{ "fmt", "allocPrint" }, &.{ try self.builder.identifier("allocator"), try self.builder.string("{d}"), try self.builder.expression(.{ .tuple = try self.allocator.dupe(node.ExpressionId, &.{value}) }) }, true),
            else => try decimal(self, value),
        };
    }

    const byte = try self.builder.expression(.{ .primitive = .u8 });
    const array = try self.builder.expression(.{ .array = .{ .element_type = try self.builder.expression(.{ .const_slice = byte }), .values = strings } });

    return intrinsic.standard(self, &.{ "mem", "concat" }, &.{ try self.builder.identifier("allocator"), byte, try self.builder.expression(.{ .address_of = array }) }, true);
}

/// An integer in decimal, as `{d}` prints it, rendered in a local buffer and copied to the allocator. Unlike
/// `std.fmt.allocPrint`, this needs no growable writer, whose page-size queries bring the C library bindings into
/// every unit that formats a number.
fn decimal(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const label = try self.fresh("decimal");
    const buffer_name = try self.fresh("digits");
    const buffer = try self.builder.identifier(buffer_name);
    const length = try intrinsic.standard(self, &.{ "fmt", "printInt" }, &.{
        try self.builder.expression(.{ .address_of = buffer }),
        value,
        try self.builder.expression(.{ .integer = 10 }),
        try self.builder.expression(.{ .enum_literal = "lower" }),
        try self.builder.expression(.{ .object = .{ .fields = &.{} } }),
    }, false);
    const digits = try self.builder.expression(.{ .slice = .{ .target = buffer, .start = try self.builder.expression(.{ .integer = 0 }), .end = length } });
    const copy = try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ try self.builder.expression(.{ .primitive = .u8 }), digits }, true);

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try self.builder.statements(&.{
        .{ .variable = .{
            .name = buffer_name,
            .type_expr = try self.builder.expression(.{ .fixed_array_type = .{ .length = try self.builder.expression(.{ .integer = 32 }), .element = try self.builder.expression(.{ .primitive = .u8 }) } }),
            .value = try self.builder.expression(.undefined_value),
        } },
        .{ .break_value = .{ .label = label, .value = copy } },
    }) } });
}
