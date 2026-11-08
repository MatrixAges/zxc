const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const emit = @import("entry/emitting.zig");

pub fn declarations(lowering: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!emit.generated) return @import("entry/values_seed.zig").declarations(lowering, output);
    if (!lowering.entry_flags.value) return;

    const route = @import("entry/policy.zig").value(lowering);

    if (route.state and try @import("entry_state.zig").declarations(lowering, output, route.state_name)) return;
    if (route.value == .Alias) return output.append(lowering.allocator, try emit.alias(lowering, false, null));

    lowering.public_value_output = route.public_value_output;
    defer lowering.public_value_output = false;
    var value = if (route.value == .Aggregate) try lowering.functionValue(route.name) else try lowering.function(route.name, false);

    value.function.exported = true;

    try output.append(lowering.allocator, value);
}
