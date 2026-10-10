const std = @import("std");
const ir = @import("zx").ir;
const Reach = @import("../reach.zig");
const Error = Reach.Error;

/// Callee lanes come first so the owned origins can keep only the first matching lane.
pub fn build(reach: *Reach, children: *std.ArrayList(Reach.Index), call: @FieldType(@FieldType(ir.Expression, "value"), "call"), path: []const u32, selected: ir.TypeId, mask: ?[]const usize) Error!Reach.Node {
    const trace = reach.trace;
    const index = @backingInt(call.function);
    var lanes: u32 = 0;

    if (index < trace.summaries.len) for (trace.summaries[index]) |lane| {
        if (!std.mem.eql(u32, lane.output, path)) continue;
        try children.append(reach.allocator, try reach.visit(call.argument, lane.input));

        lanes += 1;
    };

    const callee = trace.program.functions.at(index);

    if (callee.external != null or callee.stores.count() != 0 or index >= trace.summaries.len) {
        try children.append(reach.allocator, try reach.visit(call.argument, &.{}));
    } else {
        const nested = try trace.callee(index);

        for (try nested.dependencies.inputs(nested, path)) |input| try children.append(reach.allocator, try reach.visit(call.argument, input));
    }

    return .{
        .low = 0,
        .kind = .call,
        .mask = mask,
        .owned = if (lanes != 0) try @import("masks.zig").owned(reach, selected) else null,
        .children = children.items,
        .lanes = lanes,
    };
}
