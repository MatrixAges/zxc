const std = @import("std");
const ir = @import("zx").ir;

pub fn build(comptime Plan: type, allocator: std.mem.Allocator, functions: ir.FunctionTable) std.mem.Allocator.Error!?Plan {
    const count = functions.count();
    const depths = try allocator.alloc(u32, count);
    var deepest: u32 = 0;

    for (depths, 0..) |*depth, index| {
        const function = functions.at(index);

        depth.* = 0;

        if (function.external != null) continue;

        for (function.expressions.kinds, 0..) |_, expression| {
            const callee = @backingInt(function.expressions.callee(expression) orelse continue);

            if (callee >= index) return null;

            depth.* = @max(depth.*, depths[callee] + 1);
        }

        deepest = @max(deepest, depth.*);
    }

    const ends = try allocator.alloc(u64, deepest + 1);
    const order = try allocator.alloc(u32, count);

    @memset(ends, 0);

    for (depths) |depth| ends[depth] += 1;

    var total: u64 = 0;

    for (ends) |*end| {
        total += end.*;
        end.* = total - end.*;
    }

    for (depths, 0..) |depth, index| {
        order[@intCast(ends[depth])] = @intCast(index);

        ends[depth] += 1;
    }

    return .{ .order = order, .ends = ends };
}
