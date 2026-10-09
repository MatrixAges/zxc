const std = @import("std");
const program = @import("program");
const host = @import("host");
pub const method = @import("options").method;
pub const Case = struct { values: []const i64, rule: host.Rule = .all, limit: usize = 0, failure: usize = 0 };

pub fn execute(args: Case) !void {
    var storage: [8194]i64 = @splat(-987654321);

    @memcpy(storage[1..][0..args.values.len], args.values);

    const input = storage[1..][0..args.values.len];
    var expected_flags: [8192]bool = undefined;
    var expected_values: [8192]i64 = undefined;
    var count: usize = 0;
    var selected: usize = 0;
    var predicate = method == .every;
    var fails = false;

    for (args.values, 0..) |value, index| {
        count += 1;

        if (args.failure != 0 and count == args.failure) {
            fails = true;

            break;
        }

        const flag = switch (args.rule) {
            .all => true,
            .none => false,
            .positive => value > 0,
            .before => index < args.limit,
        };

        expected_flags[index] = flag;

        if (flag) {
            expected_values[selected] = value;
            selected += 1;
        }

        if (method == .every or method == .some) {
            predicate = flag;

            if (flag == (method == .some)) break;
        }
    }

    host.reset(args.rule, args.limit, args.failure);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const actual = program.execute(&arena, input);

    try std.testing.expectEqual(@as(usize, 1), host.source_calls);
    try std.testing.expectEqual(count, host.count);

    for (host.visits[0..count], 0..) |visit, index| {
        try std.testing.expectEqual(args.values[index], visit.item);
        try std.testing.expectEqual(@as(u64, @intCast(index)), visit.index);
        try std.testing.expect(visit.source.ptr == input.ptr);
        try std.testing.expectEqual(input.len, visit.source.len);
        try std.testing.expectEqualSlices(i64, args.values, visit.source);
        try std.testing.expectEqual(visit.item, visit.source[@intCast(visit.index)]);
    }

    try std.testing.expectEqualSlices(i64, args.values, input);
    try std.testing.expectEqual(@as(i64, -987654321), storage[0]);
    try std.testing.expectEqual(@as(i64, -987654321), storage[input.len + 1]);
    if (fails) return std.testing.expectError(error.CallbackFailure, actual);

    if (method == .map) {
        try std.testing.expectEqualSlices(bool, expected_flags[0..count], try actual);
    } else if (method == .filter) {
        try std.testing.expectEqualSlices(i64, expected_values[0..selected], try actual);
    } else {
        try std.testing.expectEqual(predicate, try actual);
    }
}
