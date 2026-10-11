const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(lowering: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!@import("value_call/analysis.zig").eligibleEntry(lowering.program, lowering.local_functions)) return;

    const output_type = lowering.program.typeOf(lowering.program.output_type);
    const aggregate = output_type == .object or output_type == .tuple or lowering.state_plan.represented(lowering.program, lowering.program.output_type);
    var value = if (aggregate) try lowering.functionValue("executeValue") else try lowering.function("executeValue", false);

    value.function.exported = true;

    try output.append(lowering.allocator, value);
}
