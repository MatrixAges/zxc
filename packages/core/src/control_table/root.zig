const std = @import("std");
const ir = @import("../ir.zig");
const Table = @import("model.zig").Table;
const read = @import("read.zig");
const Self = @This();

control: *const Table = &.{},

root: ?ir.BlockId = null,
pub fn block(self: Self) read.Block {
    return if (self.root) |id| read.block(self.control, id) else .{ .control = self.control, .first = 0, .len = 0 };
}

pub fn validStructure(self: Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!bool {
    if (!self.control.validStructure()) return false;

    const root = self.root orelse return self.control.block_first.len == 0;
    const count = self.control.block_first.len;

    if (@backingInt(root) >= count) return false;

    const states = try allocator.alloc(BlockState, count);

    defer allocator.free(states);
    @memset(states, .{});
    states[@backingInt(root)].owned = true;

    for (self.control.block_first, self.control.block_count, 0..) |first, size, parent| {
        for (self.control.statement_kinds[first..][0..size], self.control.statement_payloads[first..][0..size]) |kind, payload| switch (kind) {
            .Branch => {
                if (!attach(states, parent, self.control.branch_yes[payload])) return false;
                if (!attach(states, parent, self.control.branch_no[payload])) return false;
            },
            .Switch => {
                const start = self.control.selection_first[payload];
                const length = self.control.selection_count[payload];

                for (self.control.case_bodies[start..][0..length]) |child| {
                    if (!attach(states, parent, child)) return false;
                }
            },
            else => {},
        };
    }

    for (states) |state| if (!state.owned) return false;

    return true;
}

const BlockState = struct {
    owned: bool = false,
    depth: u16 = 0,
};

fn attach(states: []BlockState, parent: usize, child: u32) bool {
    if (states[child].owned) return false;

    states[child].owned = true;
    states[parent].depth = @max(states[parent].depth, states[child].depth + 1);

    return states[parent].depth <= 256;
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.Statement) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    const root = try storage.appendBlock(allocator, values);

    return storage.finish(allocator, root);
}
