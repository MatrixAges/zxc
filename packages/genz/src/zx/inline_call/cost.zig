const ir = @import("zx").ir;
const Children = @import("children.zig");
const limit = @import("plan.zig").limit;

pub fn count(costs: []const usize, value: @FieldType(ir.ExpressionRow, "value")) usize {
    const children = Children.init(value);
    var result: usize = 0;

    for (0..children.len) |index| result +|= costs[@backingInt(children.at(index))];

    return @min(limit + 1, result);
}
