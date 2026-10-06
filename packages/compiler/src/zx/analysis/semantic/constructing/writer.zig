const std = @import("std");
const zx = @import("zx");
const Self = @This();
pub const Columns = @import("named_view");

pub const State = struct {
    columns: Columns = .{ .names = &.{}, .types = null },
    owns_names: bool = false,
};

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
items: *zx.ir.TypeStorage,
value: zx.ir.TypeValue,
state: *State,
pub fn deinit(self: *const Self) void {
    if (self.state.owns_names) self.allocator.free(self.state.columns.names);
}
