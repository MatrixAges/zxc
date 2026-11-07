const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("genz_options").generated_analysis;
const adding = @import("generated_members_add");
const State = if (generated) @typeInfo(@typeInfo(@TypeOf(adding.executeState)).@"fn".return_type.?).error_union.payload else std.AutoHashMapUnmanaged(ir.SymbolId, void);
const Self = @This();

state: State = if (generated) .{
    .count = 0,
    .keys = .{ .items = &.{}, .storage = .plain },
    .buckets = .{ .items = &.{}, .storage = .plain },
} else .empty,

borrowed: ?*State = null,
pub const empty: Self = .{};

pub fn inherit(self: *Self) Self {
    if (!generated) return self.*;

    return .{ .borrowed = self.current() };
}

pub fn put(self: *Self, allocator: std.mem.Allocator, key: ir.SymbolId, value: void) std.mem.Allocator.Error!void {
    if (!generated) return self.state.put(allocator, key, value);

    const state = self.current();

    state.* = adding.executeState(allocator, .{ .index = state.*, .key = @backingInt(key) }) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn remove(self: *Self, key: ir.SymbolId) bool {
    if (!generated) return self.state.remove(key);

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const state = self.current();
    const result = @import("generated_members_remove").executeState(fixed.allocator(), .{ .index = state.*, .key = @backingInt(key) }) catch unreachable;

    state.* = result.index;

    return result.position != null;
}

pub fn contains(self: *const Self, key: ir.SymbolId) bool {
    if (!generated) return self.state.contains(key);

    const querying = @import("generated_members_get");
    const Input = std.meta.Child(querying.Input);
    const index = self.view(std.meta.Child(@FieldType(Input, "index")));
    const input: Input = .{ .index = &index, .key = @backingInt(key) };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(querying.executeValue, fixed.allocator(), &input) catch unreachable;

    return result != null;
}

pub fn view(self: *const Self, comptime Target: type) Target {
    const state = if (self.borrowed) |value| value else &self.state;

    return .{ .count = state.count, .keys = state.keys.items, .buckets = state.buckets.items };
}

pub fn current(self: *Self) *State {
    return self.borrowed orelse &self.state;
}
