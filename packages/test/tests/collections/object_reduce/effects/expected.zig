const std = @import("std");
const host = @import("host");

pub const Expected = struct {
    events: std.ArrayList(host.Event) = .empty,
    counts: [3]usize = .{ 0, 0, 0 },
    count: u64 = 3,
    total: u64 = 10,
    failure: ?anyerror = null,
    fn append(self: *Expected, stage: host.Stage, value: u64, requested: host.Failure) !bool {
        try self.events.append(std.testing.allocator, .{ .stage = stage, .value = value });

        self.counts[@backingInt(stage)] += 1;

        if (requested.stage != stage or self.counts[@backingInt(stage)] != requested.occurrence) return false;

        self.failure = switch (stage) {
            .subject => error.SubjectFailure,
            .pattern => error.PatternFailure,
            .amount => error.AmountFailure,
        };

        return true;
    }
    pub fn deinit(self: *Expected) void {
        self.events.deinit(std.testing.allocator);
    }
};

pub fn make(steps: []const u64, requested: host.Failure) !Expected {
    var expected = Expected{};

    errdefer expected.deinit();

    for (steps) |item| {
        if (try expected.append(.subject, item, requested)) break;
        if (item % 3 == 0) continue;
        if (try expected.append(.pattern, 1, requested)) break;
        if (try expected.append(.amount, item, requested)) break;

        const fallback = item % 3 == 2;

        expected.total += expected.count + item + (if (fallback) @as(u64, 10) else 0);
        expected.count += if (fallback) @as(u64, 2) else 1;
    }

    return expected;
}
