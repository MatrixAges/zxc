const std = @import("std");
const creating = @import("generated_uniqueness_replay_create");
const recalling = @import("generated_uniqueness_replay_recall");
const expecting = @import("generated_uniqueness_replay_expect");
const confirming = @import("generated_uniqueness_replay_confirm");
const State = @typeInfo(@typeInfo(@TypeOf(creating.executeState)).@"fn".return_type.?).error_union.payload;
const Creation = Input(creating.executeState);
const PreviousParameter = @typeInfo(@FieldType(Creation, "previous")).optional.child;
const indirect_previous = @typeInfo(PreviousParameter) == .pointer;
const Previous = if (indirect_previous) std.meta.Child(PreviousParameter) else PreviousParameter;
const Self = @This();

allocator: std.mem.Allocator,
state: State,
pub fn init(allocator: std.mem.Allocator, previous: anytype, key: [32]u8, identities: []const [32]u8, callees: []const []const u32) std.mem.Allocator.Error!Self {
    var descriptor: Previous = undefined;

    if (previous) |value| descriptor = .{
        .key = &value.key,
        .identities = std.mem.sliceAsBytes(value.identities),
        .callees = value.callees,
        .settled = value.settled.starts,
        .demanded = value.demanded.starts,
        .planned = value.planned.starts,
    };

    const input: Creation = .{
        .previous = if (previous != null) (if (indirect_previous) &descriptor else descriptor) else null,
        .key = &key,
        .identities = std.mem.sliceAsBytes(identities),
        .callees = callees,
    };

    const parameter = @typeInfo(@TypeOf(creating.executeState)).@"fn".param_types[1].?;
    const state = creating.executeState(allocator, if (@typeInfo(parameter) == .pointer) &input else input) catch |err| return failure(err);

    return .{ .allocator = allocator, .state = state };
}

pub fn changed(self: *const Self) []const bool {
    return self.state.changed.items;
}

pub fn following(self: *const Self) bool {
    return self.state.following;
}

pub fn recall(self: *Self, comptime kind: anytype, index: usize, end: u32) std.mem.Allocator.Error!?u32 {
    return self.select(recalling, kind, index, end);
}

pub fn expect(self: *Self, comptime kind: anytype, index: usize, end: u32) std.mem.Allocator.Error!?u32 {
    return self.select(expecting, kind, index, end);
}

fn select(self: *Self, comptime entry: type, comptime kind: anytype, index: usize, end: u32) std.mem.Allocator.Error!?u32 {
    const parameter = @typeInfo(@TypeOf(entry.executeState)).@"fn".param_types[1].?;

    const input: Input(entry.executeState) = .{
        .state = self.state,
        .kind = @fromBackingInt(@backingInt(kind)),
        .index = index,
        .end = end,
    };

    const output = entry.executeState(self.allocator, if (@typeInfo(parameter) == .pointer) &input else input) catch |err| return failure(err);

    self.state = output.state;

    return output.cursor;
}

pub fn confirm(self: *Self, comptime kind: anytype, index: usize, matched: bool) std.mem.Allocator.Error!void {
    const parameter = @typeInfo(@TypeOf(confirming.executeState)).@"fn".param_types[1].?;

    const input: Input(confirming.executeState) = .{
        .state = self.state,
        .kind = @fromBackingInt(@backingInt(kind)),
        .index = index,
        .matched = matched,
    };

    self.state = confirming.executeState(self.allocator, if (@typeInfo(parameter) == .pointer) &input else input) catch |err| return failure(err);
}

fn Input(comptime function: anytype) type {
    const parameter = @typeInfo(@TypeOf(function)).@"fn".param_types[1].?;

    return if (@typeInfo(parameter) == .pointer) std.meta.Child(parameter) else parameter;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    std.debug.panic("replay state failed: {s}", .{@errorName(err)});
}
