const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const flat = @import("flat_input.zig");
const mode = @import("options").mode;
const Case = struct { count: u64, length: usize, selected: u64 = 0 };

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

fn expected(args: Case) ?u64 {
    if (!isMode("stack") and args.count > 0 and (args.length == 0 or (isMode("bounds") and args.selected >= args.length))) return null;

    var total: u64 = 0;
    var left: u64 = if (args.length == 0) 0 else args.selected * 7 + 5;
    var right = left;

    for (0..@intCast(args.count)) |_| {
        if (comptime isMode("stack")) {
            total = total * 4 + 2;
        } else if (comptime isMode("two_lanes")) {
            left += 1;
            right += 2;
            total += left + right;
        } else if (comptime isMode("old_list")) {
            const old = left;
            left += 1;
            total += old + left;
        } else if (comptime isMode("call")) {
            total += left;
            left += 1;
        } else {
            left += 1;
            total += left;
        }
    }

    return total;
}

fn run(memory: std.mem.Allocator, args: Case) !usize {
    var seed: flat.Seed = .{};

    seed.init();

    const input: flat.Input = if (comptime isMode("bounds")) .{ .frames = seed.frames[0..args.length], .count = args.count, .selected = args.selected } else .{ .frames = seed.frames[0..args.length], .count = args.count };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(seed.frames[0..args.length].ptr, input.frames.ptr);
        try std.testing.expectEqual(args.length, input.frames.len);

        if (comptime isMode("bounds")) try std.testing.expectEqual(args.selected, input.selected);

        if (expected(args)) |value| {
            try std.testing.expectEqual(value, try result);
        } else {
            if (result) |_| return error.ExpectedBounds else |err| {
                if (err == error.OutOfMemory) return err;
                try std.testing.expectEqual(error.IndexOutOfBounds, err);
            }
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return tracked.allocated_bytes;
}

fn failures(memory: std.mem.Allocator, args: Case) !void {
    _ = try run(memory, args);
}

test "aggregate loop keeps zero step empty and borrowed inputs intact" {
    for ([_]usize{ 0, 1, 17, 257 }) |length| _ = try run(std.testing.allocator, .{ .count = 0, .length = length });
}

test "aggregate loop observes first second and later value versions" {
    for ([_]u64{ 1, 2, 3, 8, 16 }) |count| {
        for ([_]usize{ 1, 17 }) |length| _ = try run(std.testing.allocator, .{ .count = count, .length = length });
    }

    if (comptime isMode("stack")) _ = try run(std.testing.allocator, .{ .count = 16, .length = 0 });
}

test "aggregate field bounds fail without mutating any input" {
    _ = try run(std.testing.allocator, .{ .count = 1, .length = 0 });

    if (comptime isMode("bounds")) {
        _ = try run(std.testing.allocator, .{ .count = 3, .length = 17, .selected = 16 });

        for ([_]u64{ 17, 18, std.math.maxInt(u64) }) |selected| _ = try run(std.testing.allocator, .{ .count = 1, .length = 17, .selected = selected });
    }
}

test "aggregate loop releases every successful execution allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 3, .length = 17 }});
}

test "aggregate loop releases initial conversion allocation failures at zero steps" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 0, .length = 257 }});
}

test "aggregate loop releases allocation failures before a semantic bounds error" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{Case{ .count = 1, .length = if (comptime isMode("bounds")) 17 else 0, .selected = 17 }});
}

test "aggregate resource observations cover fixed peak buffers and preserved fallback versions" {
    if (comptime isMode("stack") or isMode("two_lanes") or isMode("bounds")) {
        const short = try run(std.testing.allocator, .{ .count = 3, .length = 257 });
        const long = try run(std.testing.allocator, .{ .count = if (comptime isMode("stack")) 16 else 64, .length = 257 });

        try std.testing.expectEqual(short, long);
        try std.testing.expect(short > 0);
    } else {
        _ = try run(std.testing.allocator, .{ .count = 9, .length = 257 });
    }
}
