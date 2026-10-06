const std = @import("std");
const program = @import("program");
const model = @import("model.zig");
const seed_input = @import("seed.zig");

fn inspect(actual: anyerror!program.Output, seed: *const seed_input.Seed, args: model.Case, label: []const u8) !?program.Output {
    if (actual) |result| {
        try std.testing.expect(!model.fails(args));
        try model.check(result, seed, args, label);

        return result;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expect(model.fails(args));
        try std.testing.expectEqual(error.IndexOutOfBounds, err);

        return null;
    }
}

pub fn run(memory: std.mem.Allocator, args: model.Case) !void {
    var seed: seed_input.Seed = .{};

    seed.init();

    const steps = try std.testing.allocator.alloc(u64, args.count + 1);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = model.itemAt(args, index);

    var label = "caller\x00😀".*;
    const original_label = label;
    const input: seed_input.Input = .{ .seed = seed.pointers[0..args.seed], .steps = steps[0..args.count], .label = &label };
    const original = input;

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const actual = program.execute(&arena, &input);

        try seed.unchanged();
        try std.testing.expectEqualSlices(u8, &original_label, &label);
        try std.testing.expectEqualDeep(original, input);
        for (steps, 0..) |item, index| try std.testing.expectEqual(model.itemAt(args, index), item);

        if (try inspect(actual, &seed, args, &label)) |first| {
            var later_input = input;
            var later_args = args;
            later_args.count += 1;
            later_input.steps = steps;
            later_input.label = "later\x00中文";
            const later_original = later_input;
            const later = program.execute(&arena, &later_input);

            try seed.unchanged();
            try std.testing.expectEqualSlices(u8, &original_label, &label);
            try std.testing.expectEqualDeep(original, input);
            try std.testing.expectEqualDeep(later_original, later_input);
            for (steps, 0..) |item, index| try std.testing.expectEqual(model.itemAt(args, index), item);
            try model.check(first, &seed, args, &label);

            _ = try inspect(later, &seed, later_args, later_input.label);

            try model.check(first, &seed, args, &label);
        }

        if (args.bounded) {
            const limit = 65536 + (args.count * 2 + args.seed * 2 + 1) * 1024;

            errdefer std.debug.print("count={d} allocated={d} capacity={d} limit={d}\n", .{ args.count, tracked.allocated_bytes, arena.queryCapacity(), limit });

            try std.testing.expect(tracked.allocated_bytes <= limit);
            try std.testing.expect(arena.queryCapacity() <= limit);
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}
