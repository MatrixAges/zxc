const std = @import("std");
const beginning = @import("generated_uniqueness_memo_begin");
const replaying = @import("generated_uniqueness_memo_replay");
const finishing = @import("generated_uniqueness_memo_finish");
const creating = @import("generated_uniqueness_memo_create");
const resetting = @import("generated_uniqueness_memo_reset");
const appending = @import("generated_uniqueness_memo_append");
const writing = @import("generated_uniqueness_memo_integer");
const packing = @import("generated_uniqueness_memo_levels");
const ordering = @import("generated_uniqueness_memo_entries");
const State = @typeInfo(@typeInfo(@TypeOf(creating.executeState)).@"fn".return_type.?).error_union.payload;
const Self = @This();

state: State,
pub fn init() Self {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const state = creating.executeState(empty.allocator(), {}) catch unreachable;

    return .{ .state = state };
}

pub fn begin(self: *Self, allocator: std.mem.Allocator, identity: []const u8, index: usize) std.mem.Allocator.Error!void {
    try self.call(allocator, beginning.executeState, .{ .state = self.state, .identity = .{ .items = identity, .storage = .plain }, .index = @intCast(index) });
}

pub fn replay(self: *Self, allocator: std.mem.Allocator, identity: []const u8, values: []const u8) std.mem.Allocator.Error!void {
    try self.call(allocator, replaying.executeState, .{ .state = self.state, .identity = .{ .items = identity, .storage = .plain }, .bytes = .{ .items = values, .storage = .plain } });
}

pub fn finish(self: *Self, allocator: std.mem.Allocator, kind: @FieldType(Input(finishing.executeState), "kind")) std.mem.Allocator.Error!void {
    try self.call(allocator, finishing.executeState, .{ .state = self.state, .kind = kind });
}

pub fn stateEnd(self: *const Self) usize {
    return @intCast(self.state.state_end);
}

pub fn reset(self: *Self) void {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    self.call(empty.allocator(), resetting.executeState, self.state) catch unreachable;
}

pub fn bytes(self: *const Self) []const u8 {
    return self.state.buffer.items[0..@intCast(self.state.end)];
}

pub fn append(self: *Self, allocator: std.mem.Allocator, values: []const u8) std.mem.Allocator.Error!void {
    try self.call(allocator, appending.executeState, .{ .state = self.state, .bytes = .{ .items = values, .storage = .plain } });
}

pub fn integer(self: *Self, allocator: std.mem.Allocator, value: u64, width: usize) std.mem.Allocator.Error!void {
    try self.call(allocator, writing.executeState, .{ .state = self.state, .value = value, .width = @as(u64, @intCast(width)) });
}

pub fn levels(self: *Self, allocator: std.mem.Allocator, values: []const u8) std.mem.Allocator.Error!void {
    try self.call(allocator, packing.executeState, .{ .state = self.state, .values = .{ .items = values, .storage = .plain } });
}

pub fn entries(self: *Self, allocator: std.mem.Allocator, records: anytype, width: usize) std.mem.Allocator.Error!void {
    const Rows = @FieldType(Input(ordering.executeState), "records");
    const values = @import("zx").columns.storage.view(@FieldType(Rows, "items"), @as([]const std.meta.Child(@TypeOf(records)), records));

    try self.call(allocator, ordering.executeState, .{ .state = self.state, .records = .{ .items = values, .storage = .owned }, .width = @as(u64, @intCast(width)) });
}

fn Input(comptime function: anytype) type {
    const parameter = @typeInfo(@TypeOf(function)).@"fn".param_types[1].?;

    return if (@typeInfo(parameter) == .pointer) std.meta.Child(parameter) else parameter;
}

fn call(self: *Self, allocator: std.mem.Allocator, comptime function: anytype, input: Input(function)) std.mem.Allocator.Error!void {
    const parameter = @typeInfo(@TypeOf(function)).@"fn".param_types[1].?;

    self.state = function(allocator, if (@typeInfo(parameter) == .pointer) &input else input) catch |err| return failure(err);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    std.debug.panic("memo encoding failed: {s}", .{@errorName(err)});
}
