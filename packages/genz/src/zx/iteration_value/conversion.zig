const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn convert(self: *Context, id: ir.TypeId, value: node.ExpressionId, output: bool) Lower.Error!node.ExpressionId {
    if (output or !@import("genz_options").generated_analysis) return @import("conversion_seed.zig").convert(self, id, value, output);

    return @import("conversion_emission.zig").lower(self, id, value);
}
