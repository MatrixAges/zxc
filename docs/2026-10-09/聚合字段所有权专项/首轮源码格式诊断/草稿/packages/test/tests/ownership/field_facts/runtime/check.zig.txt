const std = @import("std");
const program = @import("program");
const kind = @import("options").kind;
pub const Case = struct { length: usize, count: u64 = 0, choice: bool = false };
const Input = @typeInfo(program.Input).pointer.child;

fn inspect(output: program.Output, input: *const Input) !void {
    if (kind == .feedback) {
        try std.testing.expectEqualSlices(u64, &.{83}, output.fresh);

        if (input.count < 3) {
            try std.testing.expectEqualSlices(u64, &.{71}, output.view);
        } else {
            try std.testing.expectEqualSlices(u64, input.values, output.view);
            try std.testing.expectEqual(input.values.ptr, output.view.ptr);
        }
    } else if (kind == .reduce) {
        try std.testing.expectEqual(1 + input.values.len, output.fresh.len);
        try std.testing.expectEqual(@as(u64, 71), output.fresh[0]);
        try std.testing.expectEqualSlices(u64, input.values, output.fresh[1..]);
        try std.testing.expectEqualSlices(u64, input.values, output.view);
        try std.testing.expectEqual(input.values.ptr, output.view.ptr);
    } else {
        try std.testing.expectEqual(input.values.len, output.fresh.len);
        for (input.values, output.fresh) |original, actual| try std.testing.expectEqual(original + 1, actual);

        if (input.choice) {
            try std.testing.expectEqualSlices(u64, input.values, output.view);
            try std.testing.expectEqual(input.values.ptr, output.view.ptr);
        } else {
            try std.testing.expectEqualSlices(u64, output.fresh, output.view);
            try std.testing.expectEqual(output.fresh.ptr, output.view.ptr);
        }

        if (input.values.len != 0) try std.testing.expect(input.values.ptr != output.fresh.ptr);
    }
}

pub fn run(memory: std.mem.Allocator, args: Case) !usize {
    var values: [4098]u64 = @splat(987654321);
    var later: [4098]u64 = @splat(987654321);

    for (values[1..][0..args.length], later[1..][0..args.length], 0..) |*value, *next, index| {
        value.* = @intCast(index % 97);
        next.* = value.* + 100;
    }

    const input: Input = .{ .values = values[1..][0..args.length], .count = args.count, .choice = args.choice };
    const second_input: Input = .{ .values = later[1..][0..args.length], .count = args.count + 1, .choice = !args.choice };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const first = try program.execute(&arena, &input);

        try inspect(first, &input);

        const second = try program.execute(&arena, &second_input);

        try inspect(second, &second_input);
        try inspect(first, &input);
        try std.testing.expectEqual(args.count, input.count);
        try std.testing.expectEqual(args.choice, input.choice);
        try std.testing.expectEqual(args.length, input.values.len);
        try std.testing.expectEqual(values[1..].ptr, input.values.ptr);

        for (input.values, second_input.values, 0..) |value, next, index| {
            try std.testing.expectEqual(@as(u64, @intCast(index % 97)), value);
            try std.testing.expectEqual(value + 100, next);
        }

        for ([_]usize{ 0, args.length + 1 }) |index| {
            try std.testing.expectEqual(@as(u64, 987654321), values[index]);
            try std.testing.expectEqual(@as(u64, 987654321), later[index]);
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return tracked.allocated_bytes;
}

pub fn allocated(memory: std.mem.Allocator, args: Case) !void {
    _ = try run(memory, args);
}
