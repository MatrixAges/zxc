const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

/// Numbers the list positions of every type depth first, so a sub-value at a path covers a contiguous slot range.
pub const Range = struct { lo: u32, hi: u32 };

types: ir.TypeTable,
counts: []const u32,
offsets: []const []const u32,
pub fn init(allocator: std.mem.Allocator, types: ir.TypeTable) std.mem.Allocator.Error!Self {
    const counts = try allocator.alloc(u32, types.count());
    const offsets = try allocator.alloc([]const u32, types.count());
    const known = try allocator.alloc(bool, types.count());

    @memset(known, false);

    for (0..types.count()) |index| _ = measure(types, counts, known, @fromBackingInt(@intCast(index)));

    for (offsets, 0..) |*target, index| {
        const len = switch (types.get(@fromBackingInt(@intCast(index)))) {
            .object => |fields| fields.len,
            .tuple => |items| items.len,
            else => 0,
        };
        const values = try allocator.alloc(u32, len);
        var total: u32 = 0;

        for (values, 0..) |*value, step| {
            value.* = total;
            total += counts[@backingInt(memberType(types, @fromBackingInt(@intCast(index)), @intCast(step)))];
        }

        target.* = values;
    }

    return .{ .types = types, .counts = counts, .offsets = offsets };
}

fn measure(types: ir.TypeTable, counts: []u32, known: []bool, type_id: ir.TypeId) u32 {
    const index = @backingInt(type_id);

    if (known[index]) return counts[index];

    const result: u32 = switch (types.get(type_id)) {
        .list => 1,
        .optional => |child| measure(types, counts, known, child),
        .object => |fields| sum: {
            var total: u32 = 0;

            for (0..fields.len) |field| total += measure(types, counts, known, fields.at(field).type_id);

            break :sum total;
        },
        .tuple => |items| sum: {
            var total: u32 = 0;

            for (0..items.len) |item| total += measure(types, counts, known, items.at(item));

            break :sum total;
        },
        else => 0,
    };

    counts[index] = result;
    known[index] = true;

    return result;
}

fn memberType(types: ir.TypeTable, type_id: ir.TypeId, step: u32) ir.TypeId {
    return switch (types.get(type_id)) {
        .object => |fields| fields.at(step).type_id,
        .tuple => |items| items.at(step),
        else => unreachable,
    };
}

pub fn count(self: Self, type_id: ir.TypeId) u32 {
    return self.counts[@backingInt(type_id)];
}

/// Slot range and type of the member `step` of a value; optionals are transparent.
pub fn member(self: Self, type_id: ir.TypeId, step: u32) struct { offset: u32, type_id: ir.TypeId } {
    const owner = self.unwrap(type_id);

    return .{ .offset = self.offsets[@backingInt(owner)][step], .type_id = memberType(self.types, owner, step) };
}

/// The member of an object or tuple whose slot range holds `slot`: the last one starting at or before it.
fn locate(self: Self, owner: ir.TypeId, slot: u32) u32 {
    const starts = self.offsets[@backingInt(owner)];
    var low: usize = 0;
    var high: usize = starts.len;

    while (high - low > 1) {
        const middle = low + (high - low) / 2;

        if (starts[middle] <= slot) low = middle else high = middle;
    }

    return @intCast(low);
}

pub fn unwrap(self: Self, type_id: ir.TypeId) ir.TypeId {
    var current = type_id;

    while (self.types.get(current) == .optional) current = self.types.get(current).optional;

    return current;
}

/// The list type stored at slot `slot` of a value of `type_id`.
pub fn listType(self: Self, type_id: ir.TypeId, slot: u32) ir.TypeId {
    var current = self.unwrap(type_id);
    var remaining = slot;

    while (self.types.get(current) != .list) {
        const selected = self.member(current, self.locate(current, remaining));

        remaining -= selected.offset;
        current = self.unwrap(selected.type_id);
    }

    return current;
}

/// Member indices leading from a value of `type_id` to slot `slot`.
pub fn path(self: Self, allocator: std.mem.Allocator, type_id: ir.TypeId, slot: u32) std.mem.Allocator.Error![]const u32 {
    var steps: std.ArrayList(u32) = .empty;
    var current = self.unwrap(type_id);
    var remaining = slot;

    while (self.types.get(current) != .list) {
        const step = self.locate(current, remaining);
        const selected = self.member(current, step);

        try steps.append(allocator, step);

        remaining -= selected.offset;
        current = self.unwrap(selected.type_id);
    }

    return steps.toOwnedSlice(allocator);
}
