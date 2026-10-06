const std = @import("std");
const program = @import("program");
const model = @import("model.zig");
const seed_input = @import("seed.zig");
const probe = @import("probe");

fn trace(args: model.Case, offset: usize) !void {
    if (comptime !model.isMode("effects")) return;
    try std.testing.expect(probe.calls >= offset);
    try std.testing.expect(probe.calls <= offset + model.traceEnd(args));
    for (probe.events[offset..probe.calls], 0..) |token, index| try std.testing.expectEqual(@as(u64, @intCast(index)), token);
}

fn inspect(actual: anyerror!program.Output, seed: *const seed_input.Seed, args: model.Case, offset: usize) !?program.Output {
    try seed.unchanged();
    try trace(args, offset);

    const expected = model.failure(args);

    if (actual) |result| {
        if (expected != null) return error.ExpectedFailure;
        try model.check(result, seed, args);
        if (comptime model.isMode("effects")) try std.testing.expectEqual(offset + model.traceEnd(args), probe.calls);

        return result;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expect(expected != null);
        try std.testing.expectEqual(expected.?, err);
        if (comptime model.isMode("effects")) try std.testing.expectEqual(offset + model.traceEnd(args), probe.calls);

        return null;
    }
}

pub fn run(memory: std.mem.Allocator, args: model.Case) !void {
    var seed: seed_input.Seed = .{};

    seed.init();
    probe.reset(args.fail_token);

    const input: seed_input.Input = .{ .frames = seed.frames[0..args.frames], .columns = seed.columns[0..args.columns], .count = args.count, .selected = args.selected, .choice = args.choice };
    const original = input;

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const actual = program.execute(&arena, &input);

        try std.testing.expectEqualDeep(original, input);

        if (try inspect(actual, &seed, args, 0)) |first| {
            var next_input = input;
            var next_args = args;
            next_input.count += 1;
            next_args.count += 1;
            const next_original = next_input;
            const offset = probe.calls;
            const later = program.execute(&arena, &next_input);

            try seed.unchanged();
            try std.testing.expectEqualDeep(original, input);
            try std.testing.expectEqualDeep(next_original, next_input);
            try model.check(first, &seed, args);

            _ = try inspect(later, &seed, next_args, offset);

            try model.check(first, &seed, args);
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}
