const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Summaries = @import("summaries.zig");
const Hash = std.crypto.hash.sha2.Sha256;
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

pub const Digest = [32]u8;
const Trace = @import("trace.zig");

arena: std.heap.ArenaAllocator,
settled: std.AutoHashMapUnmanaged(Digest, Settled) = .empty,
demanded: std.AutoHashMapUnmanaged(Digest, Demanded) = .empty,
planned: std.AutoHashMapUnmanaged(Digest, Planned) = .empty,
key: Digest = undefined,
order: std.ArrayList(Record) = .empty,
/// The bytes the next key digests, gathered so they are hashed in one call.
encoded: std.ArrayList(u8) = .empty,
/// Where the state ends in `encoded`, before the kind of record.
state_end: usize = 0,
/// Whether bodies carry content identities, as records that outlive this program need.
persistent: bool,
/// Whether this run added records; `stale` reports whether it also left loaded ones unused.
changed: bool = false,
/// The visits of the last analysis, which the next analysis of the same program follows; it is not saved.
trace: ?Trace = null,
pub fn init(backing: std.mem.Allocator, persistent: bool) Self {
    return .{ .arena = .init(backing), .persistent = persistent };
}

pub fn deinit(self: *Self) void {
    if (self.trace) |*trace| trace.deinit();

    self.arena.deinit();

    self.* = undefined;
}

pub const Kind = enum { settled, demanded, planned };

pub fn Result(comptime kind: Kind) type {
    return switch (kind) {
        .settled => Settled,
        .demanded => Demanded,
        .planned => Planned,
    };
}

/// The record of `kind` for the body `identity` in the state `state`, which `lastState` returned for an earlier
/// lookup of the same kind; the next put records under the same key.
pub fn find(self: *Self, comptime kind: Kind, identity: [32]u8, state: []const u8) std.mem.Allocator.Error!?Result(kind) {
    self.encoded.clearRetainingCapacity();

    try self.encoded.appendSlice(self.arena.allocator(), &identity);
    try self.encoded.appendSlice(self.arena.allocator(), state);
    try self.digest(@tagName(kind));

    return use(Result(kind), &@field(self, @tagName(kind)), self.key);
}

/// The state the last lookup encoded, without the body identity; valid until the next lookup.
pub fn lastState(self: *const Self) []const u8 {
    return self.encoded.items[@sizeOf(Digest)..self.state_end];
}

pub fn getSettled(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Settled {
    try self.keyed(.settled, summaries, state);

    return use(Settled, &self.settled, self.key);
}

/// Whether a record of `kind` covers `state`, without marking it used.
pub fn holds(self: *Self, comptime kind: Kind, summaries: *const Summaries, state: State) std.mem.Allocator.Error!bool {
    try self.keyed(kind, summaries, state);

    return @field(self, @tagName(kind)).contains(self.key);
}

/// Sets `key` to the digest of what a body of `kind` reads in `state`.
fn keyed(self: *Self, comptime kind: Kind, summaries: *const Summaries, state: State) std.mem.Allocator.Error!void {
    try self.encode(summaries, state);

    if (kind == .demanded) {
        for (state.callees) |callee| try self.levels(summaries.inputs[callee]);
        try self.levels(if (state.index < summaries.outputs.len) summaries.outputs[state.index] else &.{});
    }

    try self.digest(@tagName(kind));
}

/// Records the analysis of the state `getSettled` digested into `key`.
pub fn putSettled(self: *Self, key: Digest, passed: []const Function.Contribution, output: []const Level) std.mem.Allocator.Error!Settled {
    const allocator = self.arena.allocator();
    const owned = try allocator.alloc(Function.Contribution, passed.len);

    for (passed, owned) |contribution, *target| target.* = .{ .callee = contribution.callee, .levels = try allocator.dupe(Level, contribution.levels) };

    const value = Settled{ .passed = owned, .output = try allocator.dupe(Level, output) };

    self.changed = true;

    try self.settled.put(allocator, key, value);

    return value;
}

pub fn getDemanded(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Demanded {
    try self.keyed(.demanded, summaries, state);

    return use(Demanded, &self.demanded, self.key);
}

/// Records the demand pass of the state `getDemanded` digested into `key`, with the growth copies it left.
pub fn putDemanded(self: *Self, key: Digest, marks: []const Function.Mark, state: State, grew: bool) std.mem.Allocator.Error!Demanded {
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

    const value = Demanded{ .marks = try allocator.dupe(Function.Mark, marks), .normalized = normalized, .renewed = renewed, .grew = grew };

    self.changed = true;

    try self.demanded.put(allocator, key, value);

    return value;
}

pub fn getPlanned(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!?Planned {
    try self.keyed(.planned, summaries, state);

    return use(Planned, &self.planned, self.key);
}

/// Records the plan of the state `getPlanned` digested into `key`.
pub fn putPlanned(self: *Self, key: Digest, flags: []const Function.Flags, renewals: []const Function.Renewal) std.mem.Allocator.Error!Planned {
    const allocator = self.arena.allocator();
    const owned = try allocator.alloc(Function.Renewal, renewals.len);

    for (renewals, owned) |renewal, *target| target.* = .{ .owner = renewal.owner, .path = try allocator.dupe(u32, renewal.path) };

    const value = Planned{ .flags = try allocator.dupe(Function.Flags, flags), .renewals = owned };

    self.changed = true;

    try self.planned.put(allocator, key, value);

    return value;
}

fn use(comptime Value: type, map: *std.AutoHashMapUnmanaged(Digest, Value), key: Digest) ?Value {
    const entry = map.getPtr(key) orelse return null;

    entry.used = true;

    return entry.*;
}

fn encode(self: *Self, summaries: *const Summaries, state: State) std.mem.Allocator.Error!void {
    self.encoded.clearRetainingCapacity();

    try self.encoded.appendSlice(self.arena.allocator(), &state.identity);
    try self.int(u32, @intCast(state.index));
    try self.levels(state.input);
    // The identity covers which functions the body calls and their signatures, so only their summaries follow.
    for (state.callees) |callee| try self.levels(summaries.output[callee]);
    try self.entries(ir.ExprId, state.normalized);
    try self.entries(u64, state.renewed);
}

/// Sets `key` to the digest of the encoded state followed by `kind`.
fn digest(self: *Self, kind: []const u8) std.mem.Allocator.Error!void {
    self.state_end = self.encoded.items.len;

    try self.encoded.appendSlice(self.arena.allocator(), kind);

    Hash.hash(self.encoded.items, &self.key, .{});
}

const Record = struct { key: u64, level: Level };

/// Map entries in key order, so equal contents encode equally whatever order they were added in.
fn entries(self: *Self, comptime Key: type, map: *const std.AutoHashMap(Key, Level)) std.mem.Allocator.Error!void {
    self.order.clearRetainingCapacity();

    var values = map.iterator();

    while (values.next()) |entry| try self.order.append(self.arena.allocator(), .{ .key = entryKey(Key, entry.key_ptr.*), .level = entry.value_ptr.* });

    std.mem.sortUnstable(Record, self.order.items, {}, struct {
        fn less(_: void, left: Record, right: Record) bool {
            return left.key < right.key;
        }
    }.less);

    try self.int(u32, @intCast(self.order.items.len));

    for (self.order.items) |record| {
        try self.int(if (Key == u64) u64 else u32, @intCast(record.key));
        try self.encoded.append(self.arena.allocator(), @as(u2, @bitCast(record.level)));
    }
}

fn entryKey(comptime Key: type, key: Key) u64 {
    return if (Key == u64) key else @backingInt(key);
}

/// The levels four to a byte; the count goes first, so the padding of the last byte is unambiguous.
fn levels(self: *Self, values: []const Level) std.mem.Allocator.Error!void {
    try self.int(u32, @intCast(values.len));

    const bytes = try self.encoded.addManyAsSlice(self.arena.allocator(), (values.len + 3) / 4);
    const whole = values.len / 4;

    // Each level sits in its own byte; four bytes read as one word fold into one byte with three shifts.
    for (bytes[0..whole], 0..) |*byte, index| {
        const word = std.mem.readInt(u32, @ptrCast(values[index * 4 ..][0..4]), .little) & 0x03030303;
        byte.* = @truncate(word | word >> 6 | word >> 12 | word >> 18);
    }

    if (whole == bytes.len) return;

    bytes[whole] = 0;

    for (values[whole * 4 ..], 0..) |value, index| bytes[whole] |= @as(u8, @as(u2, @bitCast(value))) << @intCast(index * 2);
}

fn int(self: *Self, comptime T: type, value: T) std.mem.Allocator.Error!void {
    var bytes: [@sizeOf(T)]u8 = undefined;

    std.mem.writeInt(T, &bytes, value, .little);

    try self.encoded.appendSlice(self.arena.allocator(), &bytes);
}

/// Writes a state `lastState` returned for a lookup of `kind` back into the summaries and growth copies of body `index`,
/// so the body can be analyzed in it again; false when the bytes do not describe a state of this body.
pub fn restore(comptime kind: Kind, state: []const u8, summaries: *Summaries, index: usize, callees: []const u32, normalized: *std.AutoHashMap(ir.ExprId, Level), renewed: *std.AutoHashMap(u64, Level)) std.mem.Allocator.Error!bool {
    var reader: std.Io.Reader = .fixed(state);

    return restoreFrom(kind, &reader, summaries, index, callees, normalized, renewed) catch |err| switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => false,
    };
}

fn restoreFrom(comptime kind: Kind, reader: *std.Io.Reader, summaries: *Summaries, index: usize, callees: []const u32, normalized: *std.AutoHashMap(ir.ExprId, Level), renewed: *std.AutoHashMap(u64, Level)) !bool {
    if (try reader.takeInt(u32, .little) != index) return false;
    try readLevels(reader, if (index < summaries.input.len) summaries.input[index] else &.{});
    for (callees) |callee| try readLevels(reader, summaries.output[callee]);
    try readEntries(ir.ExprId, reader, normalized);
    try readEntries(u64, reader, renewed);

    if (kind == .demanded) {
        for (callees) |callee| try readLevels(reader, summaries.inputs[callee]);
        try readLevels(reader, if (index < summaries.outputs.len) summaries.outputs[index] else &.{});
    }

    return reader.seek == reader.end;
}

fn readLevels(reader: *std.Io.Reader, values: []Level) !void {
    if (try reader.takeInt(u32, .little) != values.len) return error.InvalidState;

    const bytes = try reader.take((values.len + 3) / 4);

    for (values, 0..) |*value, position| value.* = @bitCast(@as(u2, @truncate(bytes[position / 4] >> @intCast(position % 4 * 2))));
}

fn readEntries(comptime Key: type, reader: *std.Io.Reader, map: *std.AutoHashMap(Key, Level)) !void {
    map.clearRetainingCapacity();

    for (0..try reader.takeInt(u32, .little)) |_| {
        const key = try reader.takeInt(if (Key == u64) u64 else u32, .little);
        const level = try reader.takeByte();

        try map.put(if (Key == u64) key else @fromBackingInt(key), @bitCast(std.math.cast(u2, level) orelse return error.InvalidState));
    }
}

const magic = "zxc.uniqueness.memo.v4";

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

/// The backing integer of a packed struct stored as one byte.
fn Byte(comptime T: type) ?type {
    const info = switch (@typeInfo(T)) {
        .@"struct" => |value| value,
        else => return null,
    };

    if (info.layout != .@"packed") return null;

    const backing = info.backing_integer.?;

    return if (@typeInfo(backing).int.bits <= 8 and @typeInfo(backing).int.signedness == .unsigned) backing else null;
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

            // Level and flag lists make up most of a memo; their elements are single bytes, read in one take.
            if (comptime Byte(info.child)) |Backing| {
                for (values, try reader.take(values.len)) |*item, byte| item.* = @bitCast(std.math.cast(Backing, byte) orelse return error.InvalidMemo);

                return values;
            }

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
