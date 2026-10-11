const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Summaries = @import("summaries.zig");
const Hash = std.crypto.hash.Blake3;
const Self = @This();

/// Results of body analyses by the exact state they read: the body's identity, its own input summary, the output
/// summaries of its callees, and its growth copies. An analysis is a pure function of that state, so a body met again
/// in the same state replays what it passed on instead of being analyzed again; the replay meets the same
/// contributions in the same order, which keeps the worklist order and the result unchanged. Records persist across
/// builds by `save` and `load`, so an edit only analyzes the bodies whose state it changes.
pub const Settled = struct { passed: []const Function.Contribution, output: []const Level, used: bool = true };

/// A demand pass also reads the demands on its callees' inputs and its own output, and leaves its growth copies.
pub const Demanded = struct { marks: []const Function.Mark, normalized: []const Normalized, renewed: []const Renewed, grew: bool, used: bool = true };
pub const Normalized = struct { id: ir.ExprId, want: Level };
pub const Renewed = struct { key: u64, want: Level };

/// The plan of a body once every fact settled.
pub const Planned = struct { flags: []const Function.Flags, renewals: []const Function.Renewal, used: bool = true };

/// What one body reads beyond the facts other bodies hand it.
pub const State = struct {
    identity: [32]u8,
    index: usize,
    input: []const Level,
    callees: []const u32,
    normalized: *const std.AutoHashMap(ir.ExprId, Level),
    renewed: *const std.AutoHashMap(u64, Level),
};

const Digest = [32]u8;

arena: std.heap.ArenaAllocator,
settled: std.AutoHashMapUnmanaged(Digest, Settled) = .empty,
demanded: std.AutoHashMapUnmanaged(Digest, Demanded) = .empty,
planned: std.AutoHashMapUnmanaged(Digest, Planned) = .empty,
key: Digest = undefined,
order: std.ArrayList(Record) = .empty,
/// Whether bodies carry content identities, as records that outlive this program need.
persistent: bool,
/// Whether this run added records; `stale` reports whether it also left loaded ones unused.
changed: bool = false,
pub fn init(backing: std.mem.Allocator, persistent: bool) Self {
    return .{ .arena = .init(backing), .persistent = persistent };
}

pub fn deinit(self: *Self) void {
    self.arena.deinit();

    self.* = undefined;
}

pub fn getSettled(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Settled {
    var hash = try self.encode(summaries, state);

    hash.update("settled");
    hash.final(&self.key);

    return use(Settled, &self.settled, self.key);
}

/// Records the analysis of the state last passed to `getSettled`.
pub fn putSettled(self: *Self, passed: []const Function.Contribution, output: []const Level) std.mem.Allocator.Error!void {
    const allocator = self.arena.allocator();

    const owned = try allocator.alloc(Function.Contribution, passed.len);

    for (passed, owned) |contribution, *target| target.* = .{ .callee = contribution.callee, .levels = try allocator.dupe(Level, contribution.levels) };

    self.changed = true;
    try self.settled.put(allocator, self.key, .{ .passed = owned, .output = try allocator.dupe(Level, output) });
}

pub fn getDemanded(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Demanded {
    var hash = try self.encode(summaries, state);

    for (state.callees) |callee| levels(&hash, summaries.inputs[callee]);

    levels(&hash, if (state.index < summaries.outputs.len) summaries.outputs[state.index] else &.{});
    hash.update("demanded");
    hash.final(&self.key);

    return use(Demanded, &self.demanded, self.key);
}

/// Records the demand pass of the state last passed to `getDemanded`, with the growth copies it left.
pub fn putDemanded(self: *Self, marks: []const Function.Mark, state: State, grew: bool) std.mem.Allocator.Error!void {
    const allocator = self.arena.allocator();
    const normalized = try allocator.alloc(Normalized, state.normalized.count());
    const renewed = try allocator.alloc(Renewed, state.renewed.count());
    var copies = state.normalized.iterator();
    var renewals = state.renewed.iterator();

    for (normalized) |*target| {
        const entry = copies.next().?;

        target.* = .{ .id = entry.key_ptr.*, .want = entry.value_ptr.* };
    }

    for (renewed) |*target| {
        const entry = renewals.next().?;

        target.* = .{ .key = entry.key_ptr.*, .want = entry.value_ptr.* };
    }

    self.changed = true;
    try self.demanded.put(allocator, self.key, .{ .marks = try allocator.dupe(Function.Mark, marks), .normalized = normalized, .renewed = renewed, .grew = grew });
}

pub fn getPlanned(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Planned {
    var hash = try self.encode(summaries, state);

    hash.update("planned");
    hash.final(&self.key);

    return use(Planned, &self.planned, self.key);
}

/// Records the plan of the state last passed to `getPlanned`.
pub fn putPlanned(self: *Self, flags: []const Function.Flags, renewals: []const Function.Renewal) std.mem.Allocator.Error!void {
    const allocator = self.arena.allocator();
    const owned = try allocator.alloc(Function.Renewal, renewals.len);

    for (renewals, owned) |renewal, *target| target.* = .{ .owner = renewal.owner, .path = try allocator.dupe(u32, renewal.path) };

    self.changed = true;
    try self.planned.put(allocator, self.key, .{ .flags = try allocator.dupe(Function.Flags, flags), .renewals = owned });
}

fn use(comptime Value: type, map: *std.AutoHashMapUnmanaged(Digest, Value), key: Digest) ?Value {
    const entry = map.getPtr(key) orelse return null;

    entry.used = true;

    return entry.*;
}

fn encode(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!Hash {
    var hash = Hash.init(.{});

    hash.update(&state.identity);
    int(&hash, state.index);
    levels(&hash, state.input);

    for (state.callees) |callee| {
        int(&hash, callee);
        levels(&hash, summaries.output[callee]);
    }

    try self.entries(ir.ExprId, &hash, state.normalized);
    try self.entries(u64, &hash, state.renewed);

    return hash;
}

const Record = struct { key: u64, level: Level };

/// Map entries in key order, so equal contents encode equally whatever order they were added in.
fn entries(self: *Self, comptime Key: type, hash: *Hash, map: *const std.AutoHashMap(Key, Level)) std.mem.Allocator.Error!void {
    self.order.clearRetainingCapacity();

    var values = map.iterator();

    while (values.next()) |entry| try self.order.append(self.arena.allocator(), .{ .key = entryKey(Key, entry.key_ptr.*), .level = entry.value_ptr.* });

    std.mem.sort(Record, self.order.items, {}, struct {
        fn less(_: void, left: Record, right: Record) bool {
            return left.key < right.key;
        }
    }.less);

    int(hash, self.order.items.len);

    for (self.order.items) |record| {
        int(hash, record.key);
        hash.update(&.{@as(u8, @as(u2, @bitCast(record.level)))});
    }
}

fn entryKey(comptime Key: type, key: Key) u64 {
    return if (Key == u64) key else @backingInt(key);
}

fn levels(hash: *Hash, values: []const Level) void {
    int(hash, values.len);

    for (values) |value| hash.update(&.{@as(u8, @as(u2, @bitCast(value)))});
}

fn int(hash: *Hash, value: u64) void {
    var bytes: [8]u8 = undefined;

    std.mem.writeInt(u64, &bytes, value, .little);
    hash.update(&bytes);
}

const magic = "zxc.uniqueness.memo.v1";

/// Whether `save` would differ from what was loaded.
pub fn stale(self: *const Self) bool {
    if (self.changed) return true;

    inline for (.{ &self.settled, &self.demanded, &self.planned }) |map| {
        var values = map.iterator();

        while (values.next()) |entry| if (!entry.value_ptr.used) return true;
    }

    return false;
}

/// The records this run used or added, for `load` in a later run.
pub fn save(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    var out: std.Io.Writer.Allocating = .init(allocator);

    errdefer out.deinit();

    const writer = &out.writer;

    writer.writeAll(magic) catch return error.OutOfMemory;
    try writeMap(Settled, writer, &self.settled);
    try writeMap(Demanded, writer, &self.demanded);
    try writeMap(Planned, writer, &self.planned);

    return out.toOwnedSlice();
}

/// Takes the records of an earlier `save`; malformed data leaves the memo as it was.
pub fn load(self: *Self, bytes: []const u8) std.mem.Allocator.Error!void {
    var reader: std.Io.Reader = .fixed(bytes);

    self.loadFrom(&reader) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => {
            self.settled.clearRetainingCapacity();
            self.demanded.clearRetainingCapacity();
            self.planned.clearRetainingCapacity();
        },
    };
}

fn loadFrom(self: *Self, reader: *std.Io.Reader) !void {
    const header = try reader.take(magic.len);

    if (!std.mem.eql(u8, header, magic)) return error.InvalidMemo;

    try self.readMap(Settled, reader, &self.settled);
    try self.readMap(Demanded, reader, &self.demanded);
    try self.readMap(Planned, reader, &self.planned);

    if (reader.seek != reader.end) return error.InvalidMemo;
}

fn writeMap(comptime Value: type, writer: *std.Io.Writer, map: *const std.AutoHashMapUnmanaged(Digest, Value)) std.mem.Allocator.Error!void {
    var count: u32 = 0;
    var values = map.iterator();

    while (values.next()) |entry| count += @intFromBool(entry.value_ptr.used);

    writeValue(writer, count) catch return error.OutOfMemory;

    values = map.iterator();

    while (values.next()) |entry| {
        if (!entry.value_ptr.used) continue;

        writer.writeAll(entry.key_ptr) catch return error.OutOfMemory;
        writeValue(writer, entry.value_ptr.*) catch return error.OutOfMemory;
    }
}

fn readMap(self: *Self, comptime Value: type, reader: *std.Io.Reader, map: *std.AutoHashMapUnmanaged(Digest, Value)) !void {
    const allocator = self.arena.allocator();
    const count = try readValue(u32, allocator, reader);

    try map.ensureUnusedCapacity(allocator, count);

    for (0..count) |_| {
        const key = (try reader.takeArray(32)).*;
        var value = try readValue(Value, allocator, reader);

        value.used = false;
        map.putAssumeCapacity(key, value);
    }
}

fn writeValue(writer: *std.Io.Writer, value: anytype) std.Io.Writer.Error!void {
    const T = @TypeOf(value);

    switch (@typeInfo(T)) {
        .@"struct" => |info| {
            if (info.layout == .@"packed") return writeValue(writer, @as(info.backing_integer.?, @bitCast(value)));

            inline for (info.field_names) |field| try writeValue(writer, @field(value, field));
        },
        .pointer => {
            try writer.writeInt(u32, @intCast(value.len), .little);

            for (value) |item| try writeValue(writer, item);
        },
        .bool => try writer.writeByte(@intFromBool(value)),
        .int => |info| try writer.writeInt(Whole(info), value, .little),
        .@"enum" => try writeValue(writer, @backingInt(value)),
        else => @compileError("unsupported memo field"),
    }
}

/// The whole-byte integer a narrower one is stored as.
fn Whole(comptime info: std.builtin.Type.Int) type {
    return @Int(info.signedness, (info.bits + 7) / 8 * 8);
}

fn readValue(comptime T: type, allocator: std.mem.Allocator, reader: *std.Io.Reader) !T {
    switch (@typeInfo(T)) {
        .@"struct" => |info| {
            if (info.layout == .@"packed") return @bitCast(try readValue(info.backing_integer.?, allocator, reader));

            var result: T = undefined;

            inline for (info.field_names) |field| @field(result, field) = try readValue(@FieldType(T, field), allocator, reader);

            return result;
        },
        .pointer => |info| {
            const values = try allocator.alloc(info.child, try readValue(u32, allocator, reader));

            for (values) |*item| item.* = try readValue(info.child, allocator, reader);

            return values;
        },
        .bool => return switch (try reader.takeByte()) {
            0 => false,
            1 => true,
            else => error.InvalidMemo,
        },
        .int => |info| return std.math.cast(T, try reader.takeInt(Whole(info), .little)) orelse error.InvalidMemo,
        .@"enum" => return @fromBackingInt(try readValue(@typeInfo(T).@"enum".tag_type, allocator, reader)),
        else => @compileError("unsupported memo field"),
    }
}
