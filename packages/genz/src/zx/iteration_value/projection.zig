const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub fn read(self: *Context, selected: Consumer, id: ir.ExprId, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("projection_seed.zig").read(self, selected, id, state);

    return @import("projection_emission.zig").lower(self, selected, id, state);
}
