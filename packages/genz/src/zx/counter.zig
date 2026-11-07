const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("genz_options").generated_analysis;
const incrementing = @import("generated_counter_increment");
const Result = if (generated) @typeInfo(@typeInfo(@TypeOf(incrementing.executeState)).@"fn".return_type.?).error_union.payload else void;
const State = if (generated) @typeInfo(Result).optional.child else std.AutoHashMapUnmanaged(ir.ExprId, usize);
const Self = @This();

state: State = if (generated) .{
    .index = .{
        .count = 0,
        .keys = .{ .items = &.{}, .storage = .plain },
        .buckets = .{ .items = &.{}, .storage = .plain },
    },
    .values = .{ .items = &.{}, .storage = .plain },
} else .empty,

pub const empty: Self = .{};

pub fn increment(self: *Self, allocator: std.mem.Allocator, key: ir.ExprId) std.mem.Allocator.Error!void {
    if (!generated) {
        const count = try self.state.getOrPut(allocator, key);

        if (!count.found_existing) count.value_ptr.* = 0;

        count.value_ptr.* += 1;

        return;
    }

    const result = incrementing.executeState(allocator, .{ .state = self.state, .key = @backingInt(key), .maximum = std.math.maxInt(usize) }) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    self.state = result orelse unreachable;
}

pub fn get(self: *const Self, key: ir.ExprId) ?usize {
    if (!generated) return self.state.get(key);

    const querying = @import("generated_counter_get");
    const Input = std.meta.Child(querying.Input);
    const View = std.meta.Child(@FieldType(Input, "state"));
    const Index = std.meta.Child(@FieldType(View, "index"));
    const index: Index = .{ .count = self.state.index.count, .keys = self.state.index.keys.items, .buckets = self.state.index.buckets.items };
    const state: View = .{ .index = &index, .values = self.state.values.items };
    const input: Input = .{ .state = &state, .key = @backingInt(key) };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(querying.executeValue, fixed.allocator(), &input) catch unreachable;

    return if (result) |value| @intCast(value) else null;
}
