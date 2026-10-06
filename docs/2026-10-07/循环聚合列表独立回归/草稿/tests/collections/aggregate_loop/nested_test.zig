const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Input = @typeInfo(@typeInfo(@TypeOf(program.execute)).@"fn".param_types[1].?).pointer.child;
const Frame = @typeInfo(@typeInfo(@FieldType(Input, "frames")).pointer.child).pointer.child;
const Meta = @typeInfo(@FieldType(Frame, "meta")).pointer.child;
const Pair = @typeInfo(@FieldType(Frame, "pair")).pointer.child;
const Case = struct { count: u64, length: usize, present: bool = false, enabled: bool = true };

fn run(memory: std.mem.Allocator, args: Case) !usize {
    var metas: [3]Meta = undefined;
    var previous: [3]Meta = undefined;
    var pairs: [3]Pair = undefined;
    var values: [3]Frame = undefined;
    var frames: [3]*const Frame = undefined;

    for (&metas, &previous, &pairs, &values, &frames, 0..) |*meta, *old, *pair, *value, *frame, index| {
        meta.* = .{ .value = @intCast(10 + index) };
        old.* = .{ .value = @intCast(30 + index) };
        pair.* = .{ .@"0" = @intCast(20 + index), .@"1" = if (index == 0) args.enabled else index % 2 == 0 };
        value.* = .{ .meta = meta, .pair = pair, .previous = if ((index == 0 and args.present) or index == 1) old else null };
        frame.* = value;
    }

    const input: Input = .{ .frames = frames[0..args.length], .count = args.count };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        for (&values, &frames, 0..) |*value, frame, index| {
            try std.testing.expectEqual(value, frame);
            try std.testing.expectEqual(&metas[index], value.meta);
            try std.testing.expectEqual(&pairs[index], value.pair);
            try std.testing.expectEqual(@as(u64, @intCast(10 + index)), value.meta.value);
            try std.testing.expectEqual(@as(u64, @intCast(20 + index)), value.pair.@"0");
            try std.testing.expectEqual(if (index == 0) args.enabled else index % 2 == 0, value.pair.@"1");
            try std.testing.expectEqual(@as(u64, @intCast(30 + index)), previous[index].value);

            if ((index == 0 and args.present) or index == 1) {
                try std.testing.expectEqual(&previous[index], value.previous.?);
            } else try std.testing.expect(value.previous == null);
        }

        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.length, input.frames.len);
        try std.testing.expectEqual(frames[0..args.length].ptr, input.frames.ptr);

        const base: u64 = if (args.length == 0) 0 else 30 + @as(u64, if (args.enabled) 2 else 5) + @as(u64, if (args.present) 30 else 0);
        var total: u64 = 0;

        for (0..@intCast(args.count)) |index| {
            const i: u64 = @intCast(index);
            total += base + 4 * i + 39 + (if (i % 2 == 1) i + 2 else 0);
        }

        try std.testing.expectEqual(total, try result);
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return tracked.allocated_bytes;
}

fn failures(memory: std.mem.Allocator, args: Case) !void {
    _ = try run(memory, args);
}

test "nested products preserve zero step initial optional and tuple inputs" {
    for ([_]usize{ 0, 1, 3 }) |length| _ = try run(std.testing.allocator, .{ .count = 0, .length = length, .present = true });
}

test "nested object tuple and optional snapshots survive field replacement and pop" {
    for ([_]u64{ 1, 2, 3, 17, 64 }) |count| {
        for ([_]usize{ 0, 1, 3 }) |length| {
            for ([_]bool{ false, true }) |present| {
                for ([_]bool{ false, true }) |enabled| _ = try run(std.testing.allocator, .{ .count = count, .length = length, .present = present, .enabled = enabled });
            }
        }
    }
}

test "nested products release each initial conversion allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 0, .length = 3, .present = true }});
}

test "nested products release each push and field update allocation failure" {
    for ([_]usize{ 0, 3 }) |length| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 3, .length = length, .present = true }});
}

test "nested product resource cost follows peak size rather than iteration count" {
    for ([_]usize{ 0, 3 }) |length| {
        const short = try run(std.testing.allocator, .{ .count = 3, .length = length, .present = true });
        const long = try run(std.testing.allocator, .{ .count = 64, .length = length, .present = true });

        try std.testing.expectEqual(short, long);
    }
}
