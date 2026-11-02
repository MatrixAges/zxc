const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(lowering: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!lowering.entry_flags.value) return;

    const output_type = lowering.program.typeOf(lowering.program.output_type);
    const aggregate = output_type == .object or output_type == .tuple or lowering.state_plan.represented(lowering.program, lowering.program.output_type);

    if (!aggregate and !lowering.entry_flags.tasks) return output.append(lowering.allocator, .{ .constant = .{
        .name = "executeValue",
        .value = try lowering.builder.identifier("executeIn"),
        .exported = true,
    } });

    lowering.public_value_output = lowering.state_plan.represented(lowering.program, lowering.program.output_type);
    defer lowering.public_value_output = false;

    var value = if (aggregate) try lowering.functionValue("executeValue") else try lowering.function("executeValue", false);
    value.function.exported = true;

    try output.append(lowering.allocator, value);
}
