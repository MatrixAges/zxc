const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const Self = @This();
pub const Multiplicity = enum { none, one, many };

trace: *Trace,
origin: []const u32,
counts: []?Multiplicity,
paths: std.AutoHashMapUnmanaged(ir.TypeId, []const []const u32) = .empty,
pub fn init(trace: *Trace, origin: []const u32) std.mem.Allocator.Error!Self {
    const counts = try trace.queryAllocator().alloc(?Multiplicity, trace.function.expressions.count());

    @memset(counts, null);

    return .{ .trace = trace, .origin = origin, .counts = counts };
}

pub fn classify(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!Multiplicity {
    const cached = &self.counts[@backingInt(id)];

    if (cached.*) |value| return value;

    const type_id = self.trace.function.expressions.at(@backingInt(id)).type_id;
    const paths = try self.leaves(type_id);
    var total: Multiplicity = .none;

    for (paths) |path| {
        if (!try @import("may.zig").contains(self.trace, id, path, self.origin)) continue;

        if (total == .one) {
            total = .many;

            break;
        }

        total = .one;
    }

    cached.* = total;

    return total;
}

fn leaves(self: *Self, type_id: ir.TypeId) std.mem.Allocator.Error![]const []const u32 {
    if (self.paths.get(type_id)) |paths| return paths;

    const allocator = self.trace.queryAllocator();
    var paths: std.ArrayList([]const u32) = .empty;

    try @import("flow.zig").leaves(allocator, self.trace.program, type_id, &.{}, true, &paths);
    try self.paths.put(allocator, type_id, paths.items);

    return paths.items;
}
