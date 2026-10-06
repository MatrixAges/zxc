const ir = @import("zx").ir;

namespace: ?[]const u8 = null,

positional_types: ?ir.TypeIds = null,
name: []const u8,
id: ir.FunctionId,
input_type: ir.TypeId,
output_type: ir.TypeId,
