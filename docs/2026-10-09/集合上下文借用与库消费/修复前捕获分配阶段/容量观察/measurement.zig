const std = @import("std");
const program = @import("program");
const fixture = @import("fixture");
const host = @import("host");

test "scalar predicate capture capacity does not grow with visits" {
    const values: [4096]i64 = @splat(64);
    var data = fixture.Data{};
    const context = data.init(1);
    var first_capacity: usize = 0;
    var last_capacity: usize = 0;

    for ([_]usize{ 0, 1, 64, 257, 4096 }) |count| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();
        host.reset(context, .none, 0);

        const value = fixture.Input{ .items = values[0..count], .context = context };
        const actual = try program.execute(&arena, &value);
        const capacity = arena.queryCapacity();

        try std.testing.expect(actual);
        try std.testing.expectEqual(count, host.calls);
        try std.testing.expect(!host.invalid_borrow);

        std.debug.print("count={d} capacity={d}\n", .{ count, capacity });

        if (count == 1) first_capacity = capacity;
        if (count == 4096) last_capacity = capacity;
    }

    try std.testing.expect(last_capacity <= first_capacity);
}
