const std = @import("std");
const program = @import("program");
const execution = @import("execution.zig");
const method = execution.method;
const samples = [_][]const i64{ &.{}, &.{0}, &.{1}, &.{-1}, &.{ 3, -1, 2 }, &.{ 47, 48, 0 }, &.{ 1, 1, 1 } };

fn check(args: execution.Case) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    _ = try execution.run(&arena, args);
}

test "empty callbacks still borrow each explicit context exactly once" {
    for (0..5) |variant| try check(.{ .values = &.{}, .variant = variant });
}

test "callbacks observe original context pointers payloads and complete values" {
    for (0..5) |variant| {
        for (samples) |values| try check(.{ .values = values, .variant = variant });
    }
}

test "context echo failures stop all callbacks without changing caller memory" {
    for (0..5) |variant| {
        for (samples) |values| try check(.{ .values = values, .variant = variant, .failure = .echo });
    }
}

test "each reachable callback failure preserves shared context and short circuits" {
    for (0..5) |variant| {
        for (samples) |values| {
            for (1..values.len + 2) |boundary| try check(.{ .values = values, .variant = variant, .failure = .callback, .fail_at = boundary });
        }
    }
}

test "later executions in one arena preserve the earlier complete result" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first: program.Output = (try execution.run(&arena, .{ .values = &.{ 1, 8, 48 }, .variant = 1 })).?;
    var saved: [3]i64 = undefined;
    const count = if (method == .map or method == .filter) first.len else 0;

    if (method == .map or method == .filter) @memcpy(saved[0..count], first);

    for (0..5) |variant| {
        _ = try execution.run(&arena, .{ .values = &.{ -1, 0, 42, 49 }, .variant = variant });
        _ = try execution.run(&arena, .{ .values = &.{ 1, 2, 3 }, .variant = variant, .failure = .echo });

        if (method == .map or method == .filter) {
            try std.testing.expectEqualSlices(i64, saved[0..count], first);
        } else {
            try std.testing.expectEqual(method == .some, first);
        }
    }
}

test "long traversal preserves one shared context and every input element" {
    var values: [4096]i64 = undefined;

    for (&values, 0..) |*item, index| item.* = if (method == .every) 64 else if (method == .some) -1 else @as(i64, @intCast(index % 113)) - 37;
    for (0..5) |variant| try check(.{ .values = &values, .variant = variant });
}
