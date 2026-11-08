const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
pub const declaration = @import("store/transaction.zig").declaration;

pub fn adapter(self: *Lower, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("store/adapter_seed.zig").lower(self, invocation);

    return @import("store/adapter.zig").lower(self, invocation);
}
