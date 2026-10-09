const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");

pub fn prove(trace: *Trace, id: ir.ExprId, origin: []const u32) std.mem.Allocator.Error!bool {
    return !try @import("may.zig").contains(trace, id, &.{}, origin);
}
