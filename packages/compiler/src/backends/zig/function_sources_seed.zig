const std = @import("std");
const Cache = @import("cache.zig");
const Plan = @import("function_sources_plan.zig").Plan;

pub fn create(allocator: std.mem.Allocator, fetched: []const Cache.Fetched) std.mem.Allocator.Error!Plan {
    var reused: std.ArrayList(u64) = .empty;
    var pending: std.ArrayList(u64) = .empty;
    var offsets: std.ArrayList(u64) = .empty;
    var size: u64 = 0;

    for (fetched, 0..) |value, position| {
        switch (value) {
            .held, .stored => |source| {
                try reused.append(allocator, position);
                try offsets.append(allocator, size);

                size += source.len;
            },
            else => try pending.append(allocator, position),
        }
    }

    return .{ .reused = reused.items, .pending = pending.items, .offsets = offsets.items, .size = size };
}
