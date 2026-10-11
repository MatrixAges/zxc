const std = @import("std");
const ir = @import("zx").ir;
const Value = @import("lookup.zig").Value;
const lanes = 16;
/// The row columns every match of a value agrees on: its kind, and `first` or `second` where they hold the value's
/// child, scalar or length.
const Key = struct { kind: u8, first: ?u32 = null, second: ?u32 = null };

pub fn find(table: ir.TypeTable, value: Value) ?ir.TypeId {
    const key = keyOf(value) orelse return null;
    var index: usize = 0;

    // Rows are filtered on the key columns 16 at a time; only rows that pass are decoded and compared in full, in
    // ascending order, so the first match is the one a row-by-row search finds.
    while (index + lanes <= table.count()) : (index += lanes) {
        const kinds: @Vector(lanes, u8) = table.kinds[index..][0..lanes].*;
        var hits: u16 = @bitCast(kinds == @as(@Vector(lanes, u8), @splat(key.kind)));

        if (hits == 0) continue;
        if (key.first) |first| hits &= @bitCast(@as(@Vector(lanes, u32), table.first[index..][0..lanes].*) == @as(@Vector(lanes, u32), @splat(first)));
        if (key.second) |second| hits &= @bitCast(@as(@Vector(lanes, u32), table.second[index..][0..lanes].*) == @as(@Vector(lanes, u32), @splat(second)));

        while (hits != 0) : (hits &= hits - 1) {
            const row = index + @ctz(hits);

            if (matches(table.at(row), value)) return @fromBackingInt(@intCast(row));
        }
    }

    for (index..table.count()) |row| {
        if (matches(table.at(row), value)) return @fromBackingInt(@intCast(row));
    }

    return null;
}

fn keyOf(value: Value) ?Key {
    const kind: u8 = @backingInt(std.meta.activeTag(value));

    return switch (value) {
        .enumeration, .native_reference => null,
        .scalar => |scalar| .{ .kind = kind, .first = @backingInt(scalar) },
        .optional, .list => |child| .{ .kind = kind, .first = @backingInt(child) },
        .task => |task| .{ .kind = kind, .first = @backingInt(task.result), .second = @backingInt(task.errors) },
        .object => |fields| .{ .kind = kind, .second = @intCast(fields.len) },
        .tuple => |children| .{ .kind = kind, .second = @intCast(children.len) },
        .error_set => |names| .{ .kind = kind, .second = @intCast(names.len) },
    };
}

fn matches(item: ir.Type, value: Value) bool {
    return switch (value) {
        .scalar => |scalar| item == .scalar and item.scalar == scalar,
        .enumeration, .native_reference => false,
        .object => |fields| item == .object and equalFields(item.object, fields),
        .optional => |child| item == .optional and item.optional == child,
        .list => |child| item == .list and item.list == child,
        .task => |task| item == .task and item.task.result == task.result and item.task.errors == task.errors,
        .tuple => |children| item == .tuple and equalChildren(item.tuple, children),
        .error_set => |names| item == .error_set and equalNames(item.error_set, names),
    };
}

fn equalChildren(left: ir.TypeIds, right: []const ir.TypeId) bool {
    if (left.len != right.len) return false;

    for (right, 0..) |child, index| {
        if (left.at(index) != child) return false;
    }

    return true;
}

fn equalNames(left: []const []const u8, right: []const []const u8) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a, b)) return false;
    }

    return true;
}

fn equalFields(left: ir.TypeFields, right: ir.TypeFields) bool {
    return @import("zx").bytes.equal(std.mem.sliceAsBytes(left.types), std.mem.sliceAsBytes(right.types)) and equalNames(left.names, right.names);
}
