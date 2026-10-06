const std = @import("std");
const program = @import("program");
const seed_input = @import("seed.zig");
const mode = @import("options").mode;

pub const Case = struct {
    count: u64,
    frames: usize = 17,
    columns: usize = 0,
    selected: u64 = 0,
    choice: u64 = 0,
    fail_token: u64 = std.math.maxInt(u64),
};

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn failure(args: Case) ?anyerror {
    if (comptime isMode("bounds") or isMode("effects")) {
        if (args.count != 0 and args.selected >= args.frames) {
            if (comptime isMode("effects")) {
                if (args.fail_token <= 1) return error.ProbeFailed;
            }

            return error.IndexOutOfBounds;
        }
    }

    if (comptime isMode("effects")) {
        if (args.fail_token <= args.count * 2) return error.ProbeFailed;
    }

    return null;
}

pub fn traceEnd(args: Case) usize {
    const last = if (args.count != 0 and args.selected >= args.frames) @as(u64, 1) else args.count * 2;

    return @intCast(@min(last, args.fail_token) + 1);
}

pub fn check(result: program.Output, seed: *const seed_input.Seed, args: Case) !void {
    const initial = seed.columns[0..args.columns];
    var columns: [64]u64 = undefined;
    var length: usize = 0;
    var total: u64 = 0;
    var index: u64 = 0;

    while (index < args.count) {
        if (comptime isMode("branch") or isMode("switch")) {
            if (index >= args.frames) {
                index += 1;

                continue;
            }

            const popped = seed.values[args.frames - 1 - @as(usize, @intCast(index))].count;
            const delta: u64 = if (comptime isMode("branch")) if (index % 3 == 0) 5 else if (args.choice == 0) 7 else 11 else if (args.choice == 0) 3 else if (args.choice == 1) if (index % 2 == 0) 5 else 7 else 11;

            total += popped + index + delta;
        } else if (comptime isMode("nested")) {
            total = total * 4 + index + 6;
        } else {
            total = total * 2 + index + @as(u64, if (comptime isMode("changed")) 4 else 3);

            if (comptime isMode("bounds") or isMode("effects")) total += seed.values[@intCast(args.selected)].count;
            if (comptime isMode("effects")) total += 2 * (index * 2 + 6);
        }

        columns[length] = total;
        length += 1;
        index += 1;

        if (comptime isMode("chain")) {
            total = total * 2 + index + 3;
            columns[length] = total;
            length += 1;
            index += 1;
        }
    }

    try std.testing.expectEqual(initial.len + length, result.columns.len);
    try std.testing.expectEqualSlices(u64, initial, result.columns[0..initial.len]);
    try std.testing.expectEqualSlices(u64, columns[0..length], result.columns[initial.len..]);
    try std.testing.expectEqualSlices(u64, result.columns, result.mirror);
    try std.testing.expectEqual(total, result.total);
    try std.testing.expectEqual(index, result.iterations);

    if (comptime isMode("escaping")) {
        try std.testing.expectEqual(args.frames, result.frames.len);
        for (result.frames, seed.frames[0..args.frames]) |frame, expected| try std.testing.expectEqualDeep(expected.*, frame.*);
    }
}
