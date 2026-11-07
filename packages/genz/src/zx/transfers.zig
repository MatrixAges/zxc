const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const generated = @import("genz_options").generated_analysis;
const writing = @import("generated_transfer_append");
const State = if (generated) @typeInfo(@typeInfo(@TypeOf(writing.executeState)).@"fn".return_type.?).error_union.payload else std.ArrayList(Record);
const Self = @This();
pub const Record = struct { type_id: ir.TypeId, owner: node.ExpressionId, value: node.ExpressionId, ready: node.ExpressionId };

state: State = if (generated) .{
    .types = .{ .items = &.{}, .storage = .plain },
    .owners = .{ .items = &.{}, .storage = .plain },
    .values = .{ .items = &.{}, .storage = .plain },
    .ready = .{ .items = &.{}, .storage = .plain },
} else .empty,

pub const empty: Self = .{};

pub fn append(self: *Self, allocator: std.mem.Allocator, record: Record) std.mem.Allocator.Error!void {
    if (!generated) return self.state.append(allocator, record);

    self.state = writing.executeState(allocator, .{
        .state = self.state,
        .type_id = @backingInt(record.type_id),
        .owner = @backingInt(record.owner),
        .value = @backingInt(record.value),
        .ready = @backingInt(record.ready),
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn view(self: *const Self, comptime Target: type) Target {
    return .{ .types = self.state.types.items, .owners = self.state.owners.items, .values = self.state.values.items, .ready = self.state.ready.items };
}

pub fn len(self: *const Self) usize {
    return if (generated) self.state.types.items.len else self.state.items.len;
}

pub fn at(self: *const Self, index: usize) Record {
    if (!generated) return self.state.items[index];

    return .{
        .type_id = @fromBackingInt(self.state.types.items[index]),
        .owner = @fromBackingInt(self.state.owners.items[index]),
        .value = @fromBackingInt(self.state.values.items[index]),
        .ready = @fromBackingInt(self.state.ready.items[index]),
    };
}

pub fn iterator(self: *const Self) Iterator {
    return .{ .owner = self };
}

pub const Iterator = struct {
    owner: *const Self,
    index: usize = 0,
    pub fn next(self: *@This()) ?Record {
        if (self.index == self.owner.len()) return null;

        const value = self.owner.at(self.index);

        self.index += 1;

        return value;
    }
};
