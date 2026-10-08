const std = @import("std");
const program = @import("program");
const inspection = @import("inspection.zig");
pub const Case = inspection.Case;
const Marker = @typeInfo(@FieldType(inspection.Input, "marker")).pointer.child;
const Record = @typeInfo(@typeInfo(@FieldType(inspection.Input, "records")).pointer.child).pointer.child;
const Pair = @typeInfo(@typeInfo(@FieldType(inspection.Input, "pairs")).pointer.child).pointer.child;

pub fn run(memory: std.mem.Allocator, args: Case) !void {
    const prefix: [3]u64 = .{ 7, 29, 103 };
    const marker: Marker = .{ .value = 913 };
    const record: Record = .{ .values = prefix[0..args.length], .marker = &marker };
    const pair: Pair = .{ .@"0" = prefix[0..args.length], .@"1" = &marker };
    const records: [1]*const Record = .{&record};
    const pairs: [1]*const Pair = .{&pair};
    const input: inspection.Input = .{ .prefix = prefix[0..args.length], .count = args.count, .marker = &marker, .enabled = args.enabled, .label = "entry", .records = &records, .pairs = &pairs };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = 0 });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const first = program.execute(&arena, &input);

        try std.testing.expectEqualSlices(u64, &.{ 7, 29, 103 }, &prefix);
        try std.testing.expectEqual(@as(u64, 913), marker.value);
        try std.testing.expectEqual(prefix[0..args.length].ptr, input.prefix.ptr);

        const result = try first;

        try inspection.check(result, &input);

        var next = input;
        next.count += 1;
        next.label = "later";
        const later = program.execute(&arena, &next);

        try inspection.check(result, &input);
        try inspection.check(try later, &next);
        try inspection.check(result, &input);
        try std.testing.expectEqualSlices(u64, &.{ 7, 29, 103 }, &prefix);
        try std.testing.expectEqual(@as(u64, 913), marker.value);
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
}
