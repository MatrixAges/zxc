const std = @import("std");
const program = @import("program");
const choose = @import("choose");
const seed_input = @import("seed.zig");
const model = @import("model.zig");
const allocation_testing = @import("allocation_testing");
const Case = struct { count: u64, columns: usize, slot: u64, fail: bool = false, later_fail: bool = true, frames: usize = 17 };
const Selection = std.meta.Child(@FieldType(seed_input.Input, "selection"));

fn checkTrace(args: Case, maximum: usize) !void {
    try std.testing.expect(choose.calls <= maximum);

    if (choose.calls > 0) {
        try std.testing.expectEqual(args.slot, choose.events[0].slot);
        try std.testing.expectEqual(args.fail, choose.events[0].fail);
    }

    if (choose.calls > 1) {
        try std.testing.expectEqual(args.columns + args.count, choose.events[1].slot);
        try std.testing.expectEqual(args.later_fail, choose.events[1].fail);
    }
}

fn check(result: program.Output, seed: *const seed_input.Seed, args: Case) !void {
    try model.check(result.columns, seed.columns[0..args.columns], args.count);
    try model.check(result.mirror, seed.columns[0..args.columns], args.count);
    try std.testing.expectEqual(model.total(args.count), result.total);

    const observed = if (args.slot < args.columns) seed.columns[@intCast(args.slot)] else model.total(args.slot - args.columns + 1);

    try std.testing.expectEqual(observed, result.observed);
}

fn run(memory: std.mem.Allocator, args: Case) !void {
    var seed: seed_input.Seed = .{};

    seed.init();
    choose.reset();

    const selection: Selection = .{ .slot = args.slot, .fail = args.fail };
    const input: seed_input.Input = .{ .frames = seed.frames[0..args.frames], .columns = seed.columns[0..args.columns], .count = args.count, .selection = &selection };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.columns, input.columns.len);
        try std.testing.expectEqual(args.frames, input.frames.len);
        try std.testing.expectEqual(seed.columns[0..args.columns].ptr, input.columns.ptr);
        try std.testing.expectEqual(seed.frames[0..args.frames].ptr, input.frames.ptr);
        try std.testing.expectEqual(&selection, input.selection);
        try std.testing.expectEqual(args.slot, selection.slot);
        try std.testing.expectEqual(args.fail, selection.fail);

        if (args.fail or args.slot >= args.columns + args.count) {
            if (result) |_| return error.ExpectedConsumerFailure else |err| {
                try checkTrace(args, 1);
                if (err == error.OutOfMemory) return err;
                try std.testing.expectEqual(if (args.fail) error.SelectionFailed else error.IndexOutOfBounds, err);
                try std.testing.expectEqual(@as(usize, 1), choose.calls);
            }
        } else {
            const first = result catch |err| {
                try checkTrace(args, 1);

                return err;
            };

            try check(first, &seed, args);
            try std.testing.expectEqual(@as(usize, 1), choose.calls);
            try checkTrace(args, 1);

            const later_selection: Selection = .{ .slot = args.columns + args.count, .fail = args.later_fail };
            var later_input = input;
            later_input.selection = &later_selection;
            const later = program.execute(&arena, &later_input);

            try seed.unchanged();
            try std.testing.expectEqual(args.columns + args.count, later_selection.slot);
            try std.testing.expectEqual(args.later_fail, later_selection.fail);
            try check(first, &seed, args);
            try checkTrace(args, 2);

            if (later) |_| return error.ExpectedConsumerFailure else |err| {
                if (err == error.OutOfMemory) return err;
                try std.testing.expectEqual(if (args.later_fail) error.SelectionFailed else error.IndexOutOfBounds, err);
                try std.testing.expectEqual(@as(usize, 2), choose.calls);
            }
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}

test "native reads a borrowed selected column at zero steps through the public aggregate ABI" {
    for ([_]usize{ 1, 17, 257 }) |columns| try run(std.testing.allocator, .{ .count = 0, .columns = columns, .slot = @intCast(columns - 1) });
}

test "native consumes selected values after transfer and retains earlier results across failures" {
    for ([_]u64{ 1, 2, 3, 8, 16 }) |count| {
        for ([_]usize{ 0, 17 }) |columns| {
            for ([_]bool{ false, true }) |later_fail| try run(std.testing.allocator, .{ .count = count, .columns = columns, .slot = columns + count - 1, .later_fail = later_fail });
        }
    }
}

test "native error precedes selected column bounds after transfer" {
    try run(std.testing.allocator, .{ .count = 3, .columns = 17, .slot = 20, .fail = true });
    try run(std.testing.allocator, .{ .count = 0, .columns = 0, .slot = 0, .fail = true });
}

test "native is called exactly once before selected column bounds failure" {
    for ([_]Case{
        .{ .count = 0, .columns = 0, .slot = 0 },
        .{ .count = 3, .columns = 17, .slot = 20 },
        .{ .count = 3, .columns = 17, .slot = std.math.maxInt(u64) },
    }) |args| try run(std.testing.allocator, args);
}

test "native success retained outputs and following failure release all allocation failures" {
    for ([_]bool{ false, true }) |later_fail| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 8, .columns = 17, .slot = 24, .later_fail = later_fail }});
}

test "native failure and selected bounds release every post transfer allocation failure" {
    for ([_]Case{
        .{ .count = 3, .columns = 17, .slot = 20 },
        .{ .count = 3, .columns = 17, .slot = 20, .fail = true },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{args});
}

test "native zero step and empty seed transfer release all allocation failures" {
    for ([_]Case{
        .{ .count = 0, .columns = 257, .slot = 256 },
        .{ .count = 3, .columns = 0, .slot = 2, .frames = 0 },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{args});
}
