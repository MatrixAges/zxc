const std = @import("std");
const program = @import("program");
const choose = @import("choose");
const flat = @import("flat_input.zig");
const allocation_testing = @import("allocation_testing");
const Case = struct { count: u64, length: usize, slot: u64, fail: bool = false };
const Selection = @typeInfo(@FieldType(flat.Input, "selection")).pointer.child;

fn run(memory: std.mem.Allocator, args: Case) !usize {
    var seed: flat.Seed = .{};

    seed.init();
    choose.reset();

    const selection: Selection = .{ .slot = args.slot, .fail = args.fail };
    const input: flat.Input = .{ .frames = seed.frames[0..args.length], .count = args.count, .selection = &selection };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.length, input.frames.len);
        try std.testing.expectEqual(seed.frames[0..args.length].ptr, input.frames.ptr);
        try std.testing.expectEqual(&selection, input.selection);
        try std.testing.expectEqual(args.slot, selection.slot);
        try std.testing.expectEqual(args.fail, selection.fail);

        if (result) |value| {
            try std.testing.expect(!args.fail and args.slot < args.length);
            try std.testing.expectEqual(args.slot * 7 + 5 + if (args.slot == 0) args.count else 0, value);
        } else |err| {
            if (err == error.OutOfMemory) {
                try std.testing.expectEqual(@as(usize, 0), choose.calls);

                return err;
            }

            const wanted = if (args.count > 0 and args.length == 0) error.IndexOutOfBounds else if (args.fail) error.SelectionFailed else error.IndexOutOfBounds;

            try std.testing.expectEqual(wanted, err);
        }

        const called = !(args.count > 0 and args.length == 0);

        try std.testing.expectEqual(@as(usize, if (called) 1 else 0), choose.calls);

        if (called) {
            try std.testing.expectEqual(args.slot, choose.slot);
            try std.testing.expectEqual(args.fail, choose.failed);
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return tracked.allocated_bytes;
}

fn failures(memory: std.mem.Allocator, args: Case) !void {
    _ = try run(memory, args);
}

test "native consumer receives the ordinary aggregate parameter after the loop" {
    for ([_]u64{ 0, 1, 2, 17, 64 }) |count| {
        for ([_]u64{ 0, 1, 16 }) |slot| _ = try run(std.testing.allocator, .{ .count = count, .length = 17, .slot = slot });
    }
}

test "native consumer executes once before its resulting bounds check" {
    for ([_]u64{ 0, 3 }) |count| {
        for ([_]u64{ 17, std.math.maxInt(u64) }) |slot| _ = try run(std.testing.allocator, .{ .count = count, .length = 17, .slot = slot });
    }

    _ = try run(std.testing.allocator, .{ .count = 0, .length = 0, .slot = 0 });
}

test "native failure precedes consumer bounds while loop failure skips the native call" {
    _ = try run(std.testing.allocator, .{ .count = 3, .length = 17, .slot = 17, .fail = true });
    _ = try run(std.testing.allocator, .{ .count = 0, .length = 0, .slot = 0, .fail = true });
    _ = try run(std.testing.allocator, .{ .count = 3, .length = 0, .slot = 0, .fail = true });
}

test "native consumer success releases every initial conversion allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 3, .length = 257, .slot = 0 }});
}

test "native consumer errors release all allocations and retain input and call cutoff" {
    for ([_]Case{
        .{ .count = 0, .length = 257, .slot = 0 },
        .{ .count = 3, .length = 17, .slot = 17 },
        .{ .count = 3, .length = 17, .slot = 17, .fail = true },
        .{ .count = 3, .length = 0, .slot = 0, .fail = true },
    }) |args| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{args});
}

test "native consumer fixed peak cost does not grow with the loop count" {
    const short = try run(std.testing.allocator, .{ .count = 3, .length = 257, .slot = 0 });
    const long = try run(std.testing.allocator, .{ .count = 64, .length = 257, .slot = 0 });

    try std.testing.expectEqual(short, long);
}
