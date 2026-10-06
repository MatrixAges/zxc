const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Job = std.meta.Child(std.meta.Child(program.Input));
const Result = std.meta.Child(std.meta.Child(program.Output));
const Cell = std.meta.Child(std.meta.Child(@FieldType(Job, "values")));
const State = std.meta.Child(@FieldType(Result, "empty"));
const Case = struct { count: usize, repeat: bool = false, bounded: bool = false };

fn expectState(state: *const State, expected: State) !void {
    try std.testing.expectEqualDeep(expected, state.*);
    try std.testing.expectEqual(expected.values.ptr, state.values.ptr);
    for (state.values, expected.values) |actual, owner| try std.testing.expect(actual == owner);
}

fn expectResults(results: program.Output, values: []const *const Cell, seed: u64, sum: u64) !void {
    try std.testing.expectEqual(@max(values.len, 1), results.len);

    for (results, 0..) |result, index| {
        const saved = if (values.len == 0) null else values[values.len - 1];
        const initial = seed + @as(u64, @intCast(index * 2));

        try expectState(result.empty, .{ .index = values.len, .total = seed, .values = values, .saved = null });
        try expectState(result.first, .{ .index = values.len, .total = initial + sum, .values = values, .saved = saved });
        try expectState(result.second, .{ .index = values.len, .total = initial + sum + 1, .values = values, .saved = saved });
        try std.testing.expect(result.first != result.second);

        for (results[0..index]) |prior| {
            try std.testing.expect(prior.first != result.first);
            try std.testing.expect(prior.first != result.second);
            try std.testing.expect(prior.second != result.first);
            try std.testing.expect(prior.second != result.second);
        }
    }
}

fn preserved(values: []const *const Cell, owners: [3]*const Cell, labels: [2][]const u8) !void {
    const pattern = [_]*const Cell{ owners[0], owners[1], owners[0], owners[2] };

    for (values, 0..) |value, index| try std.testing.expect(value == pattern[index % pattern.len]);
    try std.testing.expectEqual(@as(u64, 7), owners[0].value);
    try std.testing.expectEqual(@as(u64, 7), owners[1].value);
    try std.testing.expectEqual(@as(u64, 0), owners[2].value);
    try std.testing.expectEqualStrings("same", labels[0]);
    try std.testing.expectEqualStrings("same", labels[1]);
    try std.testing.expectEqualStrings("", owners[2].label);
    try std.testing.expectEqual(labels[0].ptr, owners[0].label.ptr);
    try std.testing.expectEqual(labels[1].ptr, owners[1].label.ptr);
    try std.testing.expect(owners[0] != owners[1]);
    try std.testing.expect(labels[0].ptr != labels[1].ptr);
}

fn expectJobs(jobs: []const Job, input: program.Input, values: []const *const Cell, seed: u64) !void {
    try std.testing.expectEqual(jobs.len, input.len);

    for (jobs, 0..) |job, index| {
        try std.testing.expect(input[index] == &jobs[index]);
        try std.testing.expectEqual(values.ptr, job.values.ptr);
        try std.testing.expectEqual(values.len, job.values.len);
        try std.testing.expectEqual(@as(u64, @intCast(index)), job.ordinal);
        try std.testing.expectEqual(seed, job.seed);
        try std.testing.expectEqual(if (values.len == 0) null else values[index], job.saved);
    }
}

fn run(gpa: std.mem.Allocator, case: Case) !void {
    var left_label = [_]u8{ 's', 'a', 'm', 'e' };
    var right_label = left_label;
    var left: Cell = .{ .value = 7, .label = &left_label };
    var right: Cell = .{ .value = 7, .label = &right_label };
    var zero: Cell = .{ .value = 0, .label = "" };
    const owners = [_]*const Cell{ &left, &right, &zero };
    const pattern = [_]*const Cell{ &left, &right, &left, &zero };
    const values = try std.testing.allocator.alloc(*const Cell, case.count);

    defer std.testing.allocator.free(values);

    var sum: u64 = 0;

    for (values, 0..) |*value, index| {
        value.* = pattern[index % pattern.len];
        sum += if (index % pattern.len == 3) @as(u64, 0) else 7;
    }

    const count = @max(case.count, 1);
    const seed: u64 = 91 + @as(u64, @intCast(case.count));
    const jobs = try std.testing.allocator.alloc(Job, count);

    defer std.testing.allocator.free(jobs);

    const input = try std.testing.allocator.alloc(*const Job, count);

    defer std.testing.allocator.free(input);

    for (jobs, 0..) |*job, index| {
        job.* = .{ .values = values, .ordinal = @intCast(index), .seed = seed, .saved = if (values.len == 0) null else values[index] };
        input[index] = job;
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });

    var retained: []const *const Cell = undefined;

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const executed = program.execute(&arena, input);

        try preserved(values, owners, .{ &left_label, &right_label });
        try expectJobs(jobs, input, values, seed);

        const result = try executed;

        try expectResults(result, values, seed, sum);

        if (case.repeat) {
            const later_jobs = try std.testing.allocator.dupe(Job, jobs);

            defer std.testing.allocator.free(later_jobs);

            const later_input = try std.testing.allocator.alloc(*const Job, count);

            defer std.testing.allocator.free(later_input);

            for (later_jobs, 0..) |*job, index| {
                job.seed += 4096;
                later_input[index] = job;
            }

            const later_executed = program.execute(&arena, later_input);

            try preserved(values, owners, .{ &left_label, &right_label });
            try expectJobs(jobs, input, values, seed);
            try expectJobs(later_jobs, later_input, values, seed + 4096);

            const later = try later_executed;

            try expectResults(later, values, seed + 4096, sum);
            try expectResults(result, values, seed, sum);

            for (result, later) |first, second| {
                try std.testing.expect(first.first != second.first);
                try std.testing.expect(first.second != second.second);
            }
        }

        if (case.bounded) {
            const budget = 4096 + count * (16 * @sizeOf(State) + 4 * @sizeOf(Result));

            errdefer std.debug.print("count={d} bytes={d} capacity={d} budget={d}\n", .{ case.count, tracked.allocated_bytes, arena.queryCapacity(), budget });

            try std.testing.expect(tracked.allocated_bytes <= budget);
            try std.testing.expect(arena.queryCapacity() <= budget);
        }

        retained = result[0].empty.values;
    }

    try std.testing.expectEqual(values.ptr, retained.ptr);
    try preserved(retained, owners, .{ &left_label, &right_label });
}

test "readonly object lists retain every borrowed address across escaped loop results" {
    for ([_]usize{ 0, 1, 2, 31, 128 }) |count| try run(std.testing.allocator, .{ .count = count, .repeat = true });
}

test "readonly object loop storage grows with returned results rather than inner iterations" {
    for ([_]usize{ 4, 32, 128 }) |count| try run(std.testing.allocator, .{ .count = count, .bounded = true });
}

test "readonly object loops release every failed allocation and preserve all owners" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 5 }});
}
