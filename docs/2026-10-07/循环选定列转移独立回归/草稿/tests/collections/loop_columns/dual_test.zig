const std = @import("std");
const program = @import("program");
const seed_input = @import("seed.zig");
const allocation_testing = @import("allocation_testing");
const Case = struct { count: u64, frames: usize = 17, columns: usize, selected: u64 = 0 };

fn check(result: program.Output, seed: *const seed_input.Seed, args: Case) !void {
    const length = args.columns + args.count;

    try std.testing.expectEqual(length, result.length);
    try std.testing.expectEqual(length, result.left.len);
    try std.testing.expectEqual(length, result.right.len);
    try std.testing.expectEqualSlices(u64, result.left, result.mirror);
    try std.testing.expectEqualSlices(u64, seed.columns[0..args.columns], result.left[0..args.columns]);
    try std.testing.expectEqualSlices(u64, seed.columns[0..args.columns], result.right[0..args.columns]);

    for (0..@intCast(args.count)) |index| {
        try std.testing.expectEqual(@as(u64, @intCast(index + 11)), result.left[args.columns + index]);
        try std.testing.expectEqual(@as(u64, @intCast(index + 101)), result.right[args.columns + index]);
    }

    try std.testing.expectEqual(result.left[@intCast(args.selected)], result.left_value);
    try std.testing.expectEqual(result.right[@intCast(args.selected)], result.right_value);
}

fn run(memory: std.mem.Allocator, args: Case) !usize {
    var seed: seed_input.Seed = .{};

    seed.init();

    const input: seed_input.Input = .{ .frames = seed.frames[0..args.frames], .columns = seed.columns[0..args.columns], .count = args.count, .selected = args.selected };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.selected, input.selected);
        try std.testing.expectEqual(args.columns, input.columns.len);
        try std.testing.expectEqual(args.frames, input.frames.len);
        try std.testing.expectEqual(seed.columns[0..args.columns].ptr, input.columns.ptr);
        try std.testing.expectEqual(seed.frames[0..args.frames].ptr, input.frames.ptr);

        if (args.selected >= args.columns + args.count) {
            if (result) |_| return error.ExpectedBounds else |err| {
                if (err == error.OutOfMemory) return err;

                try std.testing.expectEqual(error.IndexOutOfBounds, err);
            }
        } else {
            const first = try result;

            try check(first, &seed, args);

            var later_input = input;
            later_input.count += 1;
            const later = program.execute(&arena, &later_input);

            try seed.unchanged();
            try check(first, &seed, args);
            try check(try later, &seed, .{ .count = args.count + 1, .frames = args.frames, .columns = args.columns, .selected = args.selected });
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return tracked.allocated_bytes;
}

fn failures(memory: std.mem.Allocator, args: Case) !void {
    _ = try run(memory, args);
}

test "two selected columns preserve shared borrowed prefixes at zero steps" {
    for ([_]usize{ 1, 17, 257 }) |columns| _ = try run(std.testing.allocator, .{ .count = 0, .columns = columns, .selected = @intCast(columns - 1) });
}

test "two selected buffers grow independently and retain prior public results" {
    for ([_]u64{ 1, 2, 3, 17, 64 }) |count| {
        for ([_]usize{ 0, 1, 257 }) |columns| _ = try run(std.testing.allocator, .{ .count = count, .columns = columns, .selected = columns + count - 1 });
    }
}

test "two selected columns report exact bounds after transfer without mutating inputs" {
    for ([_]Case{
        .{ .count = 0, .columns = 0 },
        .{ .count = 0, .columns = 17, .selected = 17 },
        .{ .count = 3, .columns = 17, .selected = 20 },
        .{ .count = 3, .columns = 17, .selected = std.math.maxInt(u64) },
    }) |args| _ = try run(std.testing.allocator, args);
}

test "two selected columns release every growth and second transfer allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 17, .columns = 17, .selected = 33 }});
}

test "two selected zero step and bounds results release every allocation failure" {
    for ([_]Case{
        .{ .count = 0, .columns = 257, .selected = 256 },
        .{ .count = 3, .columns = 17, .selected = 20 },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{args});
}

test "two selected columns handle an empty private frame stack" {
    _ = try run(std.testing.allocator, .{ .count = 64, .frames = 0, .columns = 0, .selected = 63 });
}

test "two selected column allocation cost follows output growth" {
    const short = try run(std.testing.allocator, .{ .count = 256, .columns = 17, .selected = 272 });
    const long = try run(std.testing.allocator, .{ .count = 1024, .columns = 17, .selected = 1040 });

    try std.testing.expect(long < short * 8);
}
