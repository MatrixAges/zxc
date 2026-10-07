const std = @import("std");
const program = @import("program");
const probe = @import("probe");
const mode = @import("options").mode;
const compound = std.mem.endsWith(u8, mode, "_add");
pub const nested = std.mem.indexOf(u8, mode, "_nested_") != null;
const sequence: []const probe.Stage = if (nested) &.{ .source, .container, .index, .value, .after } else &.{ .source, .index, .value, .after };

pub const Case = struct {
    outer: usize = 2,
    inner: usize = 3,
    selected: usize = 0,
    delta: i64 = 7,
    empty: bool = false,
    bad_parent: bool = false,
    failure: probe.Failure = .{},
};

fn plannedFailure(case: Case) ?anyerror {
    const rounds = case.outer * case.inner;

    if (rounds == 0) return null;

    const bounds = case.empty or case.selected >= 3;

    if (case.failure.occurrence == 1) {
        if (case.failure.stage == .source) return error.SourceFailure;
    }

    if (nested and case.failure.stage == .container and case.failure.occurrence == 1) return error.ContainerFailure;
    if (nested and case.bad_parent) return error.IndexOutOfBounds;

    if (case.failure.occurrence == 1) {
        if (case.failure.stage == .index) return error.IndexFailure;
    }

    if (bounds and compound) return error.IndexOutOfBounds;
    if (case.failure.stage == .value and case.failure.occurrence == 1) return error.ValueFailure;
    if (bounds) return error.IndexOutOfBounds;
    if (case.failure.stage == null or case.failure.occurrence > rounds or (!nested and case.failure.stage == .container)) return null;

    return switch (case.failure.stage.?) {
        .source => error.SourceFailure,
        .index => error.IndexFailure,
        .value => error.ValueFailure,
        .after => error.AfterFailure,
        .container => error.ContainerFailure,
    };
}

fn expectTrace(case: Case, expected: ?anyerror) !void {
    const bounds_failure = expected != null and expected.? == error.IndexOutOfBounds;
    const failure_round = if (bounds_failure) 0 else if (expected != null) case.failure.occurrence - 1 else case.outer * case.inner;
    const final_stage: probe.Stage = if (nested and case.bad_parent and bounds_failure) .container else if (bounds_failure) (if (compound) .index else .value) else case.failure.stage orelse .after;
    const final_position = std.mem.indexOfScalar(probe.Stage, sequence, final_stage) orelse 0;
    const count = if (expected != null) failure_round * sequence.len + final_position + 1 else failure_round * sequence.len;

    try std.testing.expectEqual(count, probe.calls);

    for (probe.events[0..probe.calls], 0..) |event, position| {
        const stage = sequence[position % sequence.len];

        const payload: i64 = switch (stage) {
            .source => if (case.empty) 0 else 3,
            .index => @intCast(case.selected),
            .value => case.delta,
            .after => @intCast((position / sequence.len) % case.inner),
            .container => if (case.bad_parent) 1 else 0,
        };

        try std.testing.expectEqual(stage, event.stage);
        try std.testing.expectEqual(payload, event.payload);

        const initial: i64 = if (case.empty or case.selected >= 3) 0 else ([_]i64{ -5, 3, 9 })[case.selected];
        const rounds: i64 = @intCast(position / sequence.len);
        const sample = if (stage != .source or case.empty or case.selected >= 3) 0 else if (compound) initial + rounds * case.delta else if (rounds == 0) initial else case.delta;

        try std.testing.expectEqual(sample, event.sample);
    }
}

pub fn run(memory: std.mem.Allocator, case: Case) !void {
    var storage = [_]i64{ -1234567, -5, 3, 9, 7654321 };
    const values = storage[1..][0..if (case.empty) 0 else 3];
    const input: std.meta.Child(program.Input) = .{ .values = values, .outer = @intCast(case.outer), .inner = @intCast(case.inner), .selected = @intCast(case.selected), .delta = case.delta, .enabled = !case.bad_parent };
    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();
    probe.reset(case.failure, case.selected);

    const result = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(i64, &.{ -1234567, -5, 3, 9, 7654321 }, &storage);

    const expected = plannedFailure(case);

    const actual = result catch |err| {
        if (expected != null and expected.? == err) {
            try expectTrace(case, expected);

            return;
        }

        return err;
    };

    try std.testing.expect(expected == null);
    try expectTrace(case, null);
    try std.testing.expectEqualSlices(i64, values, actual.original);
    try std.testing.expectEqualSlices(i64, values, actual.mirror);
    try std.testing.expectEqual(values.len, actual.values.len);
    try std.testing.expectEqual(@as(u64, @intCast(case.outer)), actual.steps);
    try std.testing.expectEqual(@as(i64, 0), actual.seen);

    const rounds: i64 = @intCast(case.outer * case.inner);

    for (values, actual.values, 0..) |initial, updated, position| {
        const selected = position == case.selected and rounds > 0;
        const value = if (!selected) initial else if (compound) initial + rounds * case.delta else case.delta;

        try std.testing.expectEqual(value, updated);
    }
}
