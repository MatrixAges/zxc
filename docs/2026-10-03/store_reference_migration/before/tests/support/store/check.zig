const std = @import("std");
const program = @import("program");

pub const Case = struct {
    initial_a: program.State,
    initial_b: program.State,
    input: program.Input,
    conflict: bool,
    expected: struct {
        pending_a: program.State,
        pending_b: program.State,
        final_a: program.State,
        final_b: program.State,
        attempts: usize,
        commits: usize,
        result: union(enum) { value: program.Output, failure: anyerror },
    },
};

const Host = struct {
    store_0: *const program.State,
    store_1: *const program.State,
    current_a: program.State,
    current_b: program.State,
    expected_a: program.State,
    expected_b: program.State,
    conflict: bool,
    attempts: usize = 0,
    commits: usize = 0,
    pub fn commit(self: *Host, pending: program.zx_pending) !void {
        self.attempts += 1;

        try std.testing.expectEqualDeep(self.store_0.*, self.current_a);
        try std.testing.expectEqualDeep(self.store_1.*, self.current_b);
        try std.testing.expect(pending.store_0 != null and pending.store_1 != null);
        try std.testing.expectEqualDeep(self.expected_a, pending.store_0.?);
        try std.testing.expectEqualDeep(self.expected_b, pending.store_1.?);
        if (self.conflict) return error.Conflict;

        self.current_a = pending.store_0.?;
        self.current_b = pending.store_1.?;
        self.commits += 1;
    }
};

pub fn check(value: Case) !void {
    try run(std.testing.allocator, value);
}

pub fn checkAllocationFailures(value: Case) !void {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{value});
}

fn run(allocator: std.mem.Allocator, value: Case) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var host = Host{
        .store_0 = &value.initial_a,
        .store_1 = &value.initial_b,
        .current_a = value.initial_a,
        .current_b = value.initial_b,
        .expected_a = value.expected.pending_a,
        .expected_b = value.expected.pending_b,
        .conflict = value.conflict,
    };

    const actual = program.execute(&arena, value.input, &host);

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) {
            try std.testing.expectEqual(@as(usize, 0), host.attempts);
            try std.testing.expectEqualDeep(value.initial_a, host.current_a);
            try std.testing.expectEqualDeep(value.initial_b, host.current_b);

            return err;
        }
    }

    switch (value.expected.result) {
        .value => |expected| try std.testing.expectEqualDeep(expected, try actual),
        .failure => |expected| try std.testing.expectError(expected, actual),
    }

    try std.testing.expectEqual(value.expected.attempts, host.attempts);
    try std.testing.expectEqual(value.expected.commits, host.commits);
    try std.testing.expectEqualDeep(value.expected.final_a, host.current_a);
    try std.testing.expectEqualDeep(value.expected.final_b, host.current_b);
}
