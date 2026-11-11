const std = @import("std");
const Memo = @import("memo.zig");
const Group = @import("replay/group.zig");
const Self = @This();
const Control = if (@import("genz_options").generated_analysis) @import("replay/root.zig") else @import("replay/seed.zig");
/// The results every body met in one analysis of a program, visit by visit, with the states it met them in. An
/// analysis is deterministic, so a later analysis of the same program shape takes the same path as long as its changed
/// bodies meet the results recorded for them: the unchanged bodies are then handed their recorded results without
/// computing memo keys, and when the changed bodies agree in every recorded state the whole path is known up front.
pub const Digest = [32]u8;
pub const Kind = Memo.Kind;

arena: std.heap.ArenaAllocator,
/// The program shape and exported functions the analysis ran for.
key: Digest,
identities: []Digest,
callees: []const []const u32,
settled: Visits(Memo.Settled),
demanded: Visits(Memo.Demanded),
planned: Visits(Memo.Planned),
pub fn deinit(self: *Self) void {
    self.arena.deinit();

    self.* = undefined;
}

/// Each body's results and the states it met them in, in visit order: those of body `index` are at
/// `starts[index]..starts[index + 1]`.
fn Visits(comptime Result: type) type {
    return struct {
        starts: []const u32,
        values: []Result,
        states: []const []const u8,
        const Value = Result;
    };
}

fn Log(comptime Value: type) type {
    return struct {
        owners: std.ArrayList(u32) = .empty,
        entries: std.ArrayList(Entry) = .empty,
        const Entry = struct { value: Value, state: []const u8 };

        fn append(self: *@This(), allocator: std.mem.Allocator, owner: u32, value: Value, state: []const u8) std.mem.Allocator.Error!void {
            try self.owners.ensureUnusedCapacity(allocator, 1);
            try self.entries.append(allocator, .{ .value = value, .state = state });

            self.owners.appendAssumeCapacity(owner);
        }
    };
}

/// The results and states of body `index` for `kind`.
pub fn of(self: *const Self, comptime kind: Kind, index: usize) struct { values: []Memo.Result(kind), states: []const []const u8 } {
    const visits = @field(self, @tagName(kind));
    const start = visits.starts[index];
    const end = visits.starts[index + 1];

    return .{ .values = visits.values[start..end], .states = visits.states[start..end] };
}

/// One analysis following the trace an earlier one left, and recording its own.
pub const Replay = struct {
    allocator: std.mem.Allocator,
    recording: ?std.heap.ArenaAllocator = null,
    /// No longer followed once a changed body met a different result than recorded.
    trace: ?*const Self = null,
    changed: []const bool = &.{},
    control: Control = undefined,
    settled: Log(Memo.Settled) = .{},
    demanded: Log(Memo.Demanded) = .{},
    planned: Log(Memo.Planned) = .{},
    /// The state of the visit `recall` answered, which `met` records instead of the memo's.
    recalled: ?[]const u8 = null,
    key: Digest = undefined,
    identities: []const Digest = &.{},
    callees: []const []const u32 = &.{},
    /// Follows `previous` when it ran for the same program shape with every body calling the same functions, so the
    /// worklist meets the bodies in the same order as long as their results agree.
    pub fn init(allocator: std.mem.Allocator, backing: std.mem.Allocator, previous: ?*const Self, key: Digest, identities: []const Digest, callees: []const []const u32) std.mem.Allocator.Error!Replay {
        const control = try Control.init(allocator, previous, key, identities, callees);

        return .{ .allocator = allocator, .recording = .init(backing), .trace = if (control.following()) previous else null, .changed = control.changed(), .control = control, .key = key, .identities = identities, .callees = callees };
    }

    pub fn deinit(self: *Replay) void {
        if (self.recording) |*arena| arena.deinit();
    }
    /// The result body `index` met at this visit last time, while it is unchanged and the trace is followed.
    pub fn recall(self: *Replay, comptime kind: Kind, index: usize) std.mem.Allocator.Error!?Memo.Result(kind) {
        const trace = self.trace orelse return null;
        const visits = @field(trace, @tagName(kind));
        const selected = try self.control.recall(kind, index, visits.starts[index + 1]);

        if (!self.control.following()) self.trace = null;

        const cursor = selected orelse return null;

        self.recalled = visits.states[cursor];

        return visits.values[cursor];
    }
    /// Records the result body `index` met, in the state `recall` or the last lookup in `memo` encoded; a changed
    /// body that met another result than recorded ends the replay.
    pub fn met(self: *Replay, comptime kind: Kind, index: usize, value: Memo.Result(kind), memo: *const Memo) std.mem.Allocator.Error!void {
        const recording = if (self.recording) |*arena| arena.allocator() else return;
        const state = try recording.dupe(u8, self.recalled orelse memo.lastState());

        self.recalled = null;

        try @field(self, @tagName(kind)).append(self.allocator, @intCast(index), value, state);

        const trace = self.trace orelse return;
        const visits = @field(trace, @tagName(kind));
        const selected = try self.control.expect(kind, index, visits.starts[index + 1]);

        if (!self.control.following()) self.trace = null;

        const cursor = selected orelse return;
        const matched = try agree(kind, self.allocator, visits.values[cursor], value);

        try self.control.confirm(kind, index, matched);

        if (!self.control.following()) self.trace = null;
    }
    /// The trace of this analysis, for the next one.
    pub fn finish(self: *Replay) std.mem.Allocator.Error!Self {
        const arena = &self.recording.?;
        var scratch = std.heap.ArenaAllocator.init(arena.child_allocator);

        defer scratch.deinit();

        const allocator = arena.allocator();
        const callees = try allocator.alloc([]const u32, self.callees.len);

        for (callees, self.callees) |*target, source| target.* = try allocator.dupe(u32, source);

        var result: Self = .{
            .arena = undefined,
            .key = self.key,
            .identities = try allocator.dupe(Digest, self.identities),
            .callees = callees,
            .settled = try group(Memo.Settled, allocator, &scratch, self.identities.len, self.settled),
            .demanded = try group(Memo.Demanded, allocator, &scratch, self.identities.len, self.demanded),
            .planned = try group(Memo.Planned, allocator, &scratch, self.identities.len, self.planned),
        };

        result.arena = arena.*;
        self.recording = null;

        return result;
    }
};

/// Visits sorted by body, keeping their order within each body.
fn group(comptime Value: type, allocator: std.mem.Allocator, scratch: *std.heap.ArenaAllocator, bodies: usize, log: Log(Value)) std.mem.Allocator.Error!Visits(Value) {
    _ = scratch.reset(.retain_capacity);

    const index = try Group.build(scratch.allocator(), bodies, log.owners.items);
    const values = try allocator.alloc(Value, index.items.len);
    const states = try allocator.alloc([]const u8, index.items.len);

    for (index.items, values, states) |row, *value, *state| {
        const entry = log.entries.items[row];
        value.* = entry.value;
        state.* = entry.state;
    }

    return .{ .starts = try allocator.dupe(u32, index.first), .values = values, .states = states };
}

/// Whether two results of `kind` have the same effect: growth copies are sets, whatever order they were listed in.
pub fn agree(comptime kind: Kind, allocator: std.mem.Allocator, left: Memo.Result(kind), right: Memo.Result(kind)) std.mem.Allocator.Error!bool {
    if (@import("genz_options").generated_analysis) return @import("replay/ordered.zig").agree(kind, allocator, left, right);
    if (kind != .demanded) return same(left, right);
    if (left.grew != right.grew or !same(left.marks, right.marks)) return false;

    return try sameSet(Memo.Normalized, "id", allocator, left.normalized, right.normalized) and try sameSet(Memo.Renewed, "key", allocator, left.renewed, right.renewed);
}

fn sameSet(comptime Item: type, comptime key: []const u8, allocator: std.mem.Allocator, left: []const Item, right: []const Item) std.mem.Allocator.Error!bool {
    if (left.len != right.len) return false;
    if (same(left, right)) return true;

    const sorted = [2][]Item{ try allocator.dupe(Item, left), try allocator.dupe(Item, right) };

    defer for (sorted) |items| allocator.free(items);

    for (sorted) |items| std.mem.sortUnstable(Item, items, {}, struct {
        fn less(_: void, a: Item, b: Item) bool {
            return order(@field(a, key)) < order(@field(b, key));
        }

        fn order(value: anytype) u64 {
            return if (@TypeOf(value) == u64) value else @backingInt(value);
        }
    }.less);

    return same(@as([]const Item, sorted[0]), sorted[1]);
}

/// Whether two results hold the same contents; whether a memo record was used is not part of a result.
fn same(left: anytype, right: @TypeOf(left)) bool {
    const T = @TypeOf(left);

    switch (@typeInfo(T)) {
        .@"struct" => |info| {
            if (info.layout == .@"packed") return @as(info.backing_integer.?, @bitCast(left)) == @as(info.backing_integer.?, @bitCast(right));

            inline for (info.field_names) |field| {
                if (comptime std.mem.eql(u8, field, "used")) continue;
                if (!same(@field(left, field), @field(right, field))) return false;
            }

            return true;
        },
        .pointer => {
            if (left.len != right.len) return false;
            for (left, right) |item, other| if (!same(item, other)) return false;

            return true;
        },
        else => return left == right,
    }
}
