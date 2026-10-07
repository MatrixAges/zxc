const std = @import("std");
const f = @import("fixture.zig");

test "generated effects handle an empty function table" {
    try f.summary(&.{}, &.{}, &.{});
}

test "generated effects preserve a pure dependency chain" {
    try f.summary(&.{ .{}, .{ .effect = .{ .call = .{ .target = 0 } } }, .{ .effect = .{ .call = .{ .target = 1 } } } }, &.{ true, true, true }, &.{ true, true, true });
}

test "generated effects propagate a nonconcurrent native call through wrappers" {
    try f.summary(&.{ .{ .native = true }, .{ .effect = .{ .call = .{ .target = 0 } } }, .{ .effect = .{ .call = .{ .target = 1 } } } }, &.{ false, false, false }, &.{ false, false, false });
}

test "generated effects treat native module zero as impure while allowing explicit concurrency" {
    try f.summary(&.{ .{ .native = true, .concurrent = true }, .{ .effect = .{ .call = .{ .target = 0 } } }, .{ .effect = .{ .call = .{ .target = 1 } } } }, &.{ false, false, false }, &.{ true, true, true });
}

test "generated effects reject Store capabilities even without Store reads" {
    try f.summary(&.{ .{ .store = true }, .{ .effect = .{ .call = .{ .target = 0 } } }, .{} }, &.{ false, false, true }, &.{ false, false, true });
}

test "generated effects reject a Store read without a declared capability" {
    try f.summary(&.{.{ .effect = .store_get }}, &.{false}, &.{false});
}

test "generated effects reject bound Store calls to a pure function" {
    try f.summary(&.{ .{}, .{ .effect = .{ .call = .{ .target = 0, .bound = true } } } }, &.{ true, false }, &.{ true, false });
}

test "generated effects reject self calls" {
    try f.summary(&.{.{ .effect = .{ .call = .{ .target = 0 } } }}, &.{false}, &.{false});
}

test "generated effects reject forward calls despite a pure later target" {
    try f.summary(&.{ .{ .effect = .{ .call = .{ .target = 1 } } }, .{} }, &.{ false, true }, &.{ false, true });
}

test "generated effects reject out of range calls" {
    try f.summary(&.{.{ .effect = .{ .call = .{ .target = std.math.maxInt(u32) } } }}, &.{false}, &.{false});
}

fn taskEffect(effect: f.Effect) !void {
    try f.summary(&.{ .{ .effect = effect }, .{ .effect = .{ .call = .{ .target = 0 } } } }, &.{ false, false }, &.{ true, true });
}

test "generated pure effects reject nested Task creation while task calls permit it" {
    try taskEffect(.task);
}

test "generated pure effects reject await while task calls permit it" {
    try taskEffect(.await_task);
}

test "generated pure effects reject cancellation while task calls permit it" {
    try taskEffect(.cancel_task);
}

test "generated pure effects reject parallel expressions while task calls permit them" {
    try taskEffect(.parallel);
}

test "generated effect propagation scales across independent dependency prefixes" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]usize{ 1, 17, 257 }) |count| {
        const specifications = try arena.allocator().alloc(f.Function, count);
        const pure = try arena.allocator().alloc(bool, count);

        @memset(pure, true);

        specifications[0] = .{};

        for (1..count) |index| specifications[index] = .{ .effect = .{ .call = .{ .target = @intCast(index - 1) } } };
        try f.summary(specifications, pure, pure);

        specifications[0] = .{ .native = true, .concurrent = true };

        const impure = try arena.allocator().alloc(bool, count);

        @memset(impure, false);

        try f.summary(specifications, impure, pure);
    }
}
