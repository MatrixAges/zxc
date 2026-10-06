const std = @import("std");
const program = @import("program");
const seed_input = @import("seed.zig");
const allocation_testing = @import("allocation_testing");
const Case = struct { count: u64, columns: usize, selected: u64 = 0, frames: usize = 17, label: []const u8 = "leaf\x00🌱" };
const initial_optional = [_]?u64{ 10, null, 30 };
const initial_texts = [_][]const u8{ "", "seed", "中文" };
const initial_flags = [_]bool{ true, false, true };

fn check(result: program.Output, args: Case) !void {
    const length = args.columns + args.count;

    try std.testing.expectEqual(length, result.optional.len);
    try std.testing.expectEqual(length, result.texts.len);
    try std.testing.expectEqual(length, result.flags.len);
    try std.testing.expectEqual(length, result.mirror.len);
    try std.testing.expectEqualSlices(?u64, initial_optional[0..args.columns], result.optional[0..args.columns]);
    try std.testing.expectEqualSlices(bool, initial_flags[0..args.columns], result.flags[0..args.columns]);
    for (0..args.columns) |index| try std.testing.expectEqualStrings(initial_texts[index], result.texts[index]);

    for (0..@intCast(args.count)) |index| {
        const expected: ?u64 = if (index % 2 == 0) @intCast(index) else null;

        try std.testing.expectEqual(expected, result.optional[args.columns + index]);
        try std.testing.expectEqual(index % 2 == 0, result.flags[args.columns + index]);
        try std.testing.expectEqualStrings(args.label, result.texts[args.columns + index]);
    }

    for (result.texts, result.mirror) |text, mirror| try std.testing.expectEqualStrings(text, mirror);
    try std.testing.expectEqual(result.optional[@intCast(args.selected)], result.observed);
}

fn run(memory: std.mem.Allocator, args: Case) !void {
    var seed: seed_input.Seed = .{};
    var optional = initial_optional;
    var texts = initial_texts;
    var flags = initial_flags;
    var label: [32]u8 = undefined;

    seed.init();
    @memcpy(label[0..args.label.len], args.label);

    const input: seed_input.Input = .{ .frames = seed.frames[0..args.frames], .optional = optional[0..args.columns], .texts = texts[0..args.columns], .flags = flags[0..args.columns], .label = label[0..args.label.len], .count = args.count, .selected = args.selected };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqualSlices(?u64, &initial_optional, &optional);
        try std.testing.expectEqualSlices(bool, &initial_flags, &flags);
        try std.testing.expectEqualStrings(args.label, label[0..args.label.len]);
        try std.testing.expectEqualStrings(args.label, input.label);
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.selected, input.selected);
        try std.testing.expectEqual(args.frames, input.frames.len);
        try std.testing.expectEqual(args.columns, input.optional.len);
        try std.testing.expectEqual(args.columns, input.texts.len);
        try std.testing.expectEqual(args.columns, input.flags.len);
        try std.testing.expectEqual(optional[0..args.columns].ptr, input.optional.ptr);
        try std.testing.expectEqual(texts[0..args.columns].ptr, input.texts.ptr);
        try std.testing.expectEqual(flags[0..args.columns].ptr, input.flags.ptr);
        for (texts, initial_texts) |text, old| try std.testing.expectEqualStrings(old, text);

        if (args.selected >= args.columns + args.count) {
            if (result) |_| return error.ExpectedBounds else |err| {
                if (err == error.OutOfMemory) return err;

                try std.testing.expectEqual(error.IndexOutOfBounds, err);
            }
        } else {
            const first = try result;

            try check(first, args);

            var later_input = input;
            later_input.count += 1;
            const later = program.execute(&arena, &later_input);

            try seed.unchanged();
            try std.testing.expectEqualSlices(?u64, &initial_optional, &optional);
            try std.testing.expectEqualSlices(bool, &initial_flags, &flags);
            try std.testing.expectEqualStrings(args.label, label[0..args.label.len]);
            try check(first, args);

            var later_args = args;
            later_args.count += 1;

            try check(try later, later_args);
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}

test "optional string and boolean columns preserve zero step borrowed values" {
    for ([_]usize{ 1, 3 }) |columns| try run(std.testing.allocator, .{ .count = 0, .columns = columns, .selected = @intCast(columns - 1) });
}

test "optional string and boolean transfers retain null and present values after later calls" {
    for ([_]u64{ 1, 2, 3, 17, 64 }) |count| {
        for ([_]usize{ 0, 1, 3 }) |columns| try run(std.testing.allocator, .{ .count = count, .columns = columns, .selected = columns + count - 1 });
    }
}

test "selected strings retain empty ASCII UTF8 and embedded null content" {
    for ([_][]const u8{ "", "plain", "中文🌱", "a\x00b" }) |label| try run(std.testing.allocator, .{ .count = 3, .columns = 3, .selected = 5, .label = label });
}

test "optional consumption reports bounds after all selected transfers" {
    for ([_]Case{
        .{ .count = 0, .columns = 0 },
        .{ .count = 3, .columns = 3, .selected = 6 },
        .{ .count = 3, .columns = 3, .selected = std.math.maxInt(u64) },
    }) |args| try run(std.testing.allocator, args);
}

test "all leaf column transfer and retained output allocation failures are released" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 17, .columns = 3, .selected = 19 }});
}

test "zero step leaf conversion and post transfer errors release every allocation failure" {
    for ([_]Case{
        .{ .count = 0, .columns = 3, .selected = 1 },
        .{ .count = 3, .columns = 3, .selected = 6, .frames = 0 },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{args});
}
