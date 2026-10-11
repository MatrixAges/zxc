const std = @import("std");
const Memo = @import("memo.zig");
const Self = @This();

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

fn Visit(comptime Value: type) type {
    return struct { body: u32, value: Value, state: []const u8 };
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
    /// No longer followed once a changed body met a different result than recorded.
    trace: ?*const Self,
    changed: []const bool,
    cursors: [3][]u32,
    settled: std.ArrayList(Visit(Memo.Settled)) = .empty,
    demanded: std.ArrayList(Visit(Memo.Demanded)) = .empty,
    planned: std.ArrayList(Visit(Memo.Planned)) = .empty,
    /// The state of the visit `recall` answered, which `met` records instead of the memo's.
    recalled: ?[]const u8 = null,
    key: Digest,
    identities: []const Digest,
    callees: []const []const u32,

    /// Follows `previous` when it ran for the same program shape with every body calling the same functions, so the
    /// worklist meets the bodies in the same order as long as their results agree.
    pub fn init(allocator: std.mem.Allocator, previous: ?*const Self, key: Digest, identities: []const Digest, callees: []const []const u32) std.mem.Allocator.Error!Replay {
        const changed = try allocator.alloc(bool, identities.len);
        const trace = if (previous) |value| if (std.mem.eql(u8, &value.key, &key) and value.identities.len == identities.len) value else null else null;

        for (changed, 0..) |*target, index| target.* = if (trace) |value| !std.mem.eql(u8, &value.identities[index], &identities[index]) else true;

        var result = Replay{ .allocator = allocator, .trace = trace, .changed = changed, .cursors = undefined, .key = key, .identities = identities, .callees = callees };

        for (&result.cursors) |*cursor| cursor.* = try allocator.alloc(u32, identities.len);

        if (trace) |value| {
            for (changed, 0..) |differs, index| if (differs and !std.mem.eql(u32, value.callees[index], callees[index])) {
                result.trace = null;
            };

            inline for (.{ "settled", "demanded", "planned" }, 0..) |kind, position| @memcpy(result.cursors[position], @field(value, kind).starts[0..identities.len]);
        }

        return result;
    }

    /// The result body `index` met at this visit last time, while it is unchanged and the trace is followed.
    pub fn recall(self: *Replay, comptime kind: Kind, index: usize) ?Memo.Result(kind) {
        const trace = self.trace orelse return null;

        if (self.changed[index]) return null;

        const visits = @field(trace, @tagName(kind));
        const cursor = &self.cursors[@backingInt(kind)][index];

        if (cursor.* == visits.starts[index + 1]) {
            self.trace = null;

            return null;
        }

        defer cursor.* += 1;

        self.recalled = visits.states[cursor.*];

        return visits.values[cursor.*];
    }

    /// Records the result body `index` met, in the state `recall` or the last lookup in `memo` encoded; a changed
    /// body that met another result than recorded ends the replay.
    pub fn met(self: *Replay, comptime kind: Kind, index: usize, value: Memo.Result(kind), memo: *const Memo) std.mem.Allocator.Error!void {
        const state = self.recalled orelse try self.allocator.dupe(u8, memo.lastState());

        self.recalled = null;

        try @field(self, @tagName(kind)).append(self.allocator, .{ .body = @intCast(index), .value = value, .state = state });

        const trace = self.trace orelse return;

        if (!self.changed[index]) return;

        const visits = @field(trace, @tagName(kind));
        const cursor = &self.cursors[@backingInt(kind)][index];

        if (cursor.* == visits.starts[index + 1] or !try agree(kind, self.allocator, visits.values[cursor.*], value)) {
            self.trace = null;

            return;
        }

        cursor.* += 1;
    }

    /// The trace of this analysis, for the next one.
    pub fn finish(self: *const Replay, backing: std.mem.Allocator) std.mem.Allocator.Error!Self {
        var arena = std.heap.ArenaAllocator.init(backing);

        errdefer arena.deinit();

        const allocator = arena.allocator();
        const callees = try allocator.alloc([]const u32, self.callees.len);

        for (callees, self.callees) |*target, source| target.* = try allocator.dupe(u32, source);

        return .{
            .arena = arena,
            .key = self.key,
            .identities = try allocator.dupe(Digest, self.identities),
            .callees = callees,
            .settled = try group(Memo.Settled, allocator, self.identities.len, self.settled.items),
            .demanded = try group(Memo.Demanded, allocator, self.identities.len, self.demanded.items),
            .planned = try group(Memo.Planned, allocator, self.identities.len, self.planned.items),
        };
    }
};

/// Visits sorted by body, keeping their order within each body.
fn group(comptime Value: type, allocator: std.mem.Allocator, bodies: usize, visits: []const Visit(Value)) std.mem.Allocator.Error!Visits(Value) {
    const starts = try allocator.alloc(u32, bodies + 1);
    const values = try allocator.alloc(Value, visits.len);
    const states = try allocator.alloc([]const u8, visits.len);
    const next = try allocator.alloc(u32, bodies);

    defer allocator.free(next);

    @memset(starts, 0);

    for (visits) |visit| starts[visit.body + 1] += 1;
    for (1..starts.len) |index| starts[index] += starts[index - 1];

    @memcpy(next, starts[0..bodies]);

    for (visits) |visit| {
        values[next[visit.body]] = visit.value;
        states[next[visit.body]] = try allocator.dupe(u8, visit.state);
        next[visit.body] += 1;
    }

    return .{ .starts = starts, .values = values, .states = states };
}

/// Whether two results of `kind` have the same effect: growth copies are sets, whatever order they were listed in.
pub fn agree(comptime kind: Kind, allocator: std.mem.Allocator, left: Memo.Result(kind), right: Memo.Result(kind)) std.mem.Allocator.Error!bool {
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
