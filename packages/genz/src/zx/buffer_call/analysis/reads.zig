const std = @import("std");
const ir = @import("zx").ir;
const Batch = @import("batch.zig");
const Self = @This();
pub const Multiplicity = enum { none, one, many };

batch: *Batch,
origin: usize,
pub fn classify(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!Multiplicity {
    const cached = &self.batch.counts[@backingInt(id)];

    if (cached.*) |value| return value;

    var total: Multiplicity = .none;

    for (try self.batch.paths(id)) |index| {
        if (!self.batch.reach.has(index, self.origin)) continue;

        if (total == .one) {
            total = .many;

            break;
        }

        total = .one;
    }

    cached.* = total;

    return total;
}

pub fn independent(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!bool {
    return !try self.batch.reach.contains(id, &.{}, self.origin);
}
