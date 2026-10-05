const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
const Input = std.meta.Child(program.Input);
const Step = std.meta.Child(std.meta.Elem(@FieldType(Input, "steps")));
const row = [_]u64{ 7, 0, std.math.maxInt(u64) };
const seed_values = [_]u64{ std.math.maxInt(u64), 0, 9, 17 };

pub const Case = struct {
    count: usize,
    seed: bool = true,
    disabled: bool = false,
    empty_rows: bool = false,
    bound_capacity: bool = false,
    forbid_resize: bool = false,
};

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(allocator: std.mem.Allocator, case: Case) !void {
    const steps = try std.testing.allocator.alloc(Step, case.count);

    defer std.testing.allocator.free(steps);

    const references = try std.testing.allocator.alloc(*const Step, case.count);

    defer std.testing.allocator.free(references);

    var seed = seed_values;
    var expected: std.ArrayList(u64) = .empty;

    defer expected.deinit(std.testing.allocator);

    if (case.seed) try expected.appendSlice(std.testing.allocator, &seed);

    for (steps, references, 0..) |*step, *reference, index| {
        step.* = .{
            .enabled = !case.disabled and index % 3 != 0,
            .value = @intCast(index % 101),
            .values = row[0..if (case.empty_rows) 0 else index % 4],
        };

        reference.* = step;

        try advance(&expected, step);
    }

    var tracked = std.testing.FailingAllocator.init(allocator, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const actual = program.execute(&arena, &.{ .seed = if (case.seed) &seed else &.{}, .steps = references });

    try std.testing.expectEqualSlices(u64, &seed_values, &seed);

    for (steps, 0..) |step, index| {
        try std.testing.expectEqual(!case.disabled and index % 3 != 0, step.enabled);
        try std.testing.expectEqual(@as(u64, @intCast(index % 101)), step.value);
        try std.testing.expectEqualSlices(u64, row[0..if (case.empty_rows) 0 else index % 4], step.values);
    }

    try std.testing.expectEqualSlices(u64, expected.items, try actual);

    if (case.bound_capacity) {
        const bound = 4096 + 32 * @sizeOf(u64) * (case.count + seed.len);

        errdefer std.debug.print("mode {s}, count {d}, capacity {d}, bound {d}\n", .{ mode, case.count, arena.queryCapacity(), bound });

        try std.testing.expect(arena.queryCapacity() <= bound);
        try std.testing.expect(tracked.allocated_bytes <= bound);
        try std.testing.expect(tracked.allocations <= 64);
    }
}

fn advance(expected: *std.ArrayList(u64), step: *const Step) !void {
    const allocator = std.testing.allocator;

    if (comptime isMode("push")) {
        try expected.append(allocator, step.value);
    } else if (comptime isMode("concat")) {
        try expected.appendSlice(allocator, step.values);
    } else if (comptime isMode("select")) {
        if (step.enabled) try expected.appendSlice(allocator, step.values);
    } else if (comptime isMode("nested")) {
        if (step.enabled) {
            if (step.values.len == 0) try expected.append(allocator, step.value) else try expected.appendSlice(allocator, step.values);
        }
    } else if (comptime isMode("condition")) {
        if (expected.items.len % 2 == 0) try expected.append(allocator, step.value) else try expected.appendSlice(allocator, step.values);
    } else if (comptime isMode("argument")) {
        try expected.append(allocator, expected.items.len + step.value);
    } else if (comptime isMode("first_value")) {
        try expected.append(allocator, if (expected.items.len > 0) expected.items[0] else step.value);
    } else if (comptime isMode("stack")) {
        if (step.enabled) try expected.append(allocator, step.value) else _ = expected.pop();
    } else {
        @compileError("unknown reduce fixture mode");
    }
}
