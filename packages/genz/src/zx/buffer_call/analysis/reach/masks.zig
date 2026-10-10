const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("../trace.zig");
const Reach = @import("../reach.zig");
const Error = Reach.Error;

pub fn owner(trace: *const Trace, origin: []const u32) ir.TypeId {
    var id = trace.function.input_type;

    for (origin) |part| id = switch (trace.program.typeOf(id)) {
        .object => |fields| fields.at(part).type_id,
        .tuple => |items| items.at(part),
        else => unreachable,
    };

    return id;
}

/// Origins whose list owner can be reached from a value of the selected type.
pub fn filter(reach: *Reach, selected: ir.TypeId) Error!?[]const usize {
    if (reach.filters.get(selected)) |cached| return cached;

    const program = reach.trace.program;
    const mask = try empty(reach);
    var complete = true;

    for (reach.owners, 0..) |id, origin| {
        if (program.typeOf(id) == .list and selected != id and !@import("../../../value_call/analysis.zig").containsDescendant(program, selected, id)) {
            complete = false;

            continue;
        }

        set(mask, origin);
    }

    const result: ?[]const usize = if (complete) null else mask;

    try reach.filters.put(reach.allocator, selected, result);

    return result;
}

/// Origins whose owner is exactly the selected list type.
pub fn owned(reach: *Reach, selected: ir.TypeId) Error!?[]const usize {
    if (reach.trace.program.typeOf(selected) != .list) return null;

    const mask = try empty(reach);

    for (reach.owners, 0..) |id, origin| if (id == selected) set(mask, origin);

    return mask;
}

/// Origins whose lane selects the iteration at this projection; null when no lane does.
pub fn chosen(reach: *Reach, id: ir.ExprId, path: []const u32) Error!?[]const usize {
    var result: ?[]usize = null;

    for (reach.loops, 0..) |loops, origin| for (loops) |loop| {
        if (loop.expression != id or !std.mem.eql(u32, loop.path, path)) continue;
        if (result == null) result = try empty(reach);

        set(result.?, origin);

        break;
    };

    return result;
}

/// Origins whose owner differs from the popped target type.
pub fn popped(reach: *Reach, mask: ?[]const usize, target: ir.TypeId) Error![]const usize {
    const result = try empty(reach);

    for (reach.owners, 0..) |id, origin| {
        if (id != target and (mask == null or get(mask.?, origin))) set(result, origin);
    }

    return result;
}

/// Origins on the same projection chain as the path.
pub fn prefixed(reach: *Reach, mask: ?[]const usize, path: []const u32) Error![]const usize {
    const result = try empty(reach);

    for (reach.origins, 0..) |origin, position| {
        if ((prefix(path, origin) or prefix(origin, path)) and (mask == null or get(mask.?, position))) set(result, position);
    }

    return result;
}

fn empty(reach: *Reach) Error![]usize {
    const mask = try reach.allocator.alloc(usize, reach.words);

    @memset(mask, 0);

    return mask;
}

fn set(mask: []usize, position: usize) void {
    mask[position / @bitSizeOf(usize)] |= @as(usize, 1) << @intCast(position % @bitSizeOf(usize));
}

fn get(mask: []const usize, position: usize) bool {
    return mask[position / @bitSizeOf(usize)] & (@as(usize, 1) << @intCast(position % @bitSizeOf(usize))) != 0;
}

fn prefix(left: []const u32, right: []const u32) bool {
    return left.len <= right.len and std.mem.eql(u32, left, right[0..left.len]);
}
