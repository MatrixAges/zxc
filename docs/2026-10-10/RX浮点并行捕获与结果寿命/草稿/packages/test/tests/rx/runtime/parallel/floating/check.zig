const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Tracking = @import("parallel_tracking");
const pattern = @import("pattern.zig");
const Storage = @import("storage.zig");
const output = @import("output.zig");
pub const Case = pattern.Case;
pub const Kind = enum { values, threads, allocations };

fn verify(allocator: std.mem.Allocator, data: Case, observe_workers: bool) !void {
    var storage = Storage{};
    const input = try storage.input(data.input);
    const before = storage;
    const original = input;
    var tracking = Tracking{ .child = allocator };
    var arena = std.heap.ArenaAllocator.init(if (observe_workers) tracking.allocator() else allocator);

    defer arena.deinit();

    const first = program.execute(&arena, &input) catch |err| {
        try storage.expect(&before, &input, original);

        return err;
    };

    if (observe_workers) {
        const workers = tracking.workers();

        std.debug.print("RX floating worker allocations: {d}\n", .{workers});

        if (data.owned_capture) {
            try std.testing.expect(workers >= 1);
        } else try std.testing.expectEqual(@as(usize, 2), workers);
    }

    try output.expect(first, data.expected, &input, data.owned_capture);
    try storage.expect(&before, &input, original);

    const marker = data.input.marker ^ (@as(pattern.Bits, 1) << (@bitSizeOf(pattern.Bits) - 1));
    const next: pattern.Input = .{ .left = input.right, .right = input.left, .marker = @bitCast(marker) };
    const original_next = next;
    const next_expected: pattern.Values = .{ .left = data.expected.right, .right = data.expected.left, .marker = marker };

    const second = program.execute(&arena, &next) catch |err| {
        try output.expect(first, data.expected, &input, data.owned_capture);
        try storage.expect(&before, &input, original);
        try storage.expect(&before, &next, original_next);

        return err;
    };

    try output.expect(second, next_expected, &next, data.owned_capture);
    try output.expect(first, data.expected, &input, data.owned_capture);
    try storage.expect(&before, &input, original);
    try storage.expect(&before, &next, original_next);
}

pub fn check(data: Case, kind: Kind) !void {
    if (kind == .allocations) {
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, verify, .{ data, false });

        std.debug.print("RX floating allocation sweep completed\n", .{});
    } else try verify(std.testing.allocator, data, kind == .threads);
}
