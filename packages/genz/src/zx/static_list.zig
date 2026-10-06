const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, value: ir.Expression, items: []const ir.ExprId) Lower.Error!?*const node.Expression {
    if (!@import("value_call/analysis.zig").scalarLocals(self.program, self.pure_functions)) return null;

    const element = self.program.typeOf(value.type_id).list;

    switch (self.program.typeOf(element)) {
        .scalar, .enumeration, .error_set => {},
        else => return null,
    }

    for (items) |item| switch (self.program.expression(item).value) {
        .integer, .negative_integer, .float, .string, .boolean, .unit, .enum_value, .error_value => {},
        else => return null,
    };

    const expressions = try self.allocator.alloc(*const node.Expression, items.len);

    for (items, expressions) |item, *expression| expression.* = try self.expr(item);

    const array = try self.builder.expression(.{ .array = .{ .element_type = self.types[@backingInt(element)], .values = expressions } });
    const address = try self.builder.expression(.{ .comptime_value = try self.builder.expression(.{ .address_of = array }) });

    return self.cast(self.types[@backingInt(value.type_id)], address);
}
