const std = @import("std");
const mode = @import("options").mode;
const seed_input = @import("seed.zig");
const program = @import("program");
const Cell = seed_input.Cell;

pub const Case = struct { count: usize, seed: usize = 17, repeat: bool = false, zeros: bool = false, bounded: bool = false };

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn itemAt(args: Case, index: usize) u64 {
    return if (args.zeros) 0 else if (args.repeat) 1 else @intCast((index * 7 + 3) % 11);
}

pub fn fails(args: Case) bool {
    return args.seed == 0 and args.count != 0 and !isMode("optional");
}

pub fn check(result: program.Output, seed: *const seed_input.Seed, args: Case, label: []const u8) !void {
    var values: std.ArrayList(Cell) = .empty;

    defer values.deinit(std.testing.allocator);

    for (seed.values[0..args.seed]) |cell| try values.append(std.testing.allocator, cell);

    var seen: u64 = 0;
    var current_label = label;

    for (0..args.count) |index| {
        const item = itemAt(args, index);
        const selectable = if (isMode("prefix") and values.items.len > 1) values.items.len - 1 else values.items.len;
        const selected: usize = if (selectable == 0) 0 else @intCast(item % selectable);
        const missing = isMode("optional") and (values.items.len == 0 or selected % 2 == 1);
        const old: Cell = if (missing) .{ .value = 0, .label = current_label } else values.items[selected];
        var observed = old.value;

        if (isMode("tuple") or isMode("reference")) observed += values.items.len;
        if (isMode("prefix")) observed += selectable;
        if (isMode("offset")) observed += values.items.len - selected;
        if (isMode("nested")) observed += values.items.len + old.value + if (selected % 2 == 0) old.value else @as(u64, 0);
        if (isMode("reverse")) std.mem.reverse(Cell, values.items);
        try values.append(std.testing.allocator, .{ .value = old.value + item + 1, .label = old.label });
        if (isMode("concat")) try values.append(std.testing.allocator, .{ .value = old.value + item + 2, .label = current_label });

        seen += observed;
        current_label = old.label;
    }

    try std.testing.expectEqual(values.items.len, result.values.len);
    try std.testing.expectEqual(result.values.len, result.mirror.len);
    for (result.values, result.mirror) |value, mirror| try std.testing.expectEqualDeep(value.*, mirror.*);
    try std.testing.expectEqual(args.seed, result.original.len);
    for (result.values, values.items) |actual, expected| try std.testing.expectEqualDeep(expected, actual.*);
    for (result.original, seed.pointers[0..args.seed]) |actual, expected| try std.testing.expectEqualDeep(expected.*, actual.*);
    try std.testing.expectEqual(seen, result.seen);
    try std.testing.expectEqualStrings(current_label, result.label);
    try std.testing.expectEqual(@as(u64, @intCast(args.count)), result.count);
}
