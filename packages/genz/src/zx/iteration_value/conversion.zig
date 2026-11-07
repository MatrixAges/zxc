const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn convert(self: *Context, id: ir.TypeId, value: node.ExpressionId, output: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("conversion_seed.zig").convert(self, id, value, output);
    if (output) return @import("conversion_output.zig").lower(self, id, value);

    return @import("conversion_emission.zig").lower(self, id, value);
}
