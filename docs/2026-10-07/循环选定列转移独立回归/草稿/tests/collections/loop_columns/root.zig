const std = @import("std");
const program = @import("program");
const seed_input = @import("seed.zig");
const model = @import("model.zig");
const allocation_testing = @import("allocation_testing");
const mode = @import("options").mode;
const Case = struct { count: u64, frames: usize, columns: usize = 0 };

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

fn check(result: program.Output, seed: *const seed_input.Seed, args: Case) !void {
    if (comptime isMode("direct")) {
        try model.check(result, seed.columns[0..args.columns], args.count);
    } else if (comptime isMode("nested")) {
        try model.check(result.@"0", seed.columns[0..args.columns], args.count);
        try model.check(result.@"1".mirror, seed.columns[0..args.columns], args.count);
        try std.testing.expectEqual(model.total(args.count), result.@"1".total);
        try std.testing.expectEqual(args.columns + args.count, result.@"2");
    } else {
        try model.check(result.columns, seed.columns[0..args.columns], args.count);
        try model.check(result.mirror, seed.columns[0..args.columns], args.count);
        try std.testing.expectEqual(model.total(args.count), result.total);

        if (comptime isMode("fallback")) {
            try std.testing.expectEqual(args.frames, result.frames.len);

            for (result.frames, 0..) |frame, index| {
                try std.testing.expectEqual(@as(u64, @intCast(index * 3 + 11)), frame.position);
                try std.testing.expectEqual(@as(u64, @intCast(index * 7 + 5)), frame.count);
            }
        }
    }
}

fn run(memory: std.mem.Allocator, args: Case) !void {
    var seed: seed_input.Seed = .{};

    seed.init();

    const input: seed_input.Input = if (comptime isMode("mixed")) .{ .frames = seed.frames[0..args.frames], .count = args.count } else .{ .frames = seed.frames[0..args.frames], .columns = seed.columns[0..args.columns], .count = args.count };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const result = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.frames, input.frames.len);
        try std.testing.expectEqual(seed.frames[0..args.frames].ptr, input.frames.ptr);

        if (comptime !isMode("mixed")) {
            try std.testing.expectEqual(args.columns, input.columns.len);
            try std.testing.expectEqual(seed.columns[0..args.columns].ptr, input.columns.ptr);
        }

        const first = try result;

        try check(first, &seed, args);

        var next_input = input;
        next_input.count = args.count + 1;
        const later = program.execute(&arena, &next_input);

        try seed.unchanged();
        try check(first, &seed, args);

        const second = try later;

        try check(second, &seed, .{ .count = args.count + 1, .frames = args.frames, .columns = args.columns });
        try check(first, &seed, args);
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}

test "selected columns preserve zero step initial values and repeated projections" {
    for ([_]usize{ 0, 1, 17 }) |frames| {
        if (comptime isMode("mixed")) {
            try run(std.testing.allocator, .{ .count = 0, .frames = frames });
        } else {
            for ([_]usize{ 0, 1, 17, 257 }) |columns| try run(std.testing.allocator, .{ .count = 0, .frames = frames, .columns = columns });
        }
    }
}

test "selected scalar and list results follow independent frame snapshot recurrence" {
    for ([_]u64{ 1, 2, 3, 8, 16 }) |count| try run(std.testing.allocator, .{ .count = count, .frames = 17 });
}

test "selected results retain every borrowed prefix across column growth" {
    for ([_]usize{ 1, 17, 257 }) |frames| {
        try run(std.testing.allocator, .{ .count = 16, .frames = frames, .columns = if (comptime isMode("mixed")) 0 else 257 });
    }
}

test "empty frame stacks still produce retained public columns" {
    try run(std.testing.allocator, .{ .count = 16, .frames = 0 });
}

test "selected columns release every allocation failure in both retained calls" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 3, .frames = 17, .columns = if (comptime isMode("mixed")) 0 else 17 }});
}

test "zero step borrowed output and initial frame conversion release all allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 0, .frames = 257, .columns = if (comptime isMode("mixed")) 0 else 257 }});
}

test "selected empty initial columns release all growth and transfer failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 8, .frames = 0 }});
}
