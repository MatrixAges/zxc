const std = @import("std");
const f = @import("fixture.zig");

fn expectPure(args: struct { functions: []const f.Function = &.{}, root: f.Effect = .none, store: bool = false, expected: bool }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var program = try f.program(arena.allocator(), args.functions, args.root);
    program.stores = try f.stores(arena.allocator(), args.store);

    try std.testing.expectEqual(args.expected, try f.checks.parallel.programPure(std.testing.allocator, program));
}

test "generated program purity accepts a literal without functions" {
    try expectPure(.{ .expected = true });
}

test "generated program purity accepts a call through the last valid pure dependency" {
    try expectPure(.{ .functions = &.{ .{}, .{ .effect = .{ .call = .{ .target = 0 } } } }, .root = .{ .call = .{ .target = 1 } }, .expected = true });
}

test "generated program purity ignores an unused native function" {
    try expectPure(.{ .functions = &.{ .{ .native = true }, .{} }, .root = .{ .call = .{ .target = 1 } }, .expected = true });
}

test "generated program purity rejects a reachable native function" {
    try expectPure(.{ .functions = &.{ .{ .native = true }, .{ .effect = .{ .call = .{ .target = 0 } } } }, .root = .{ .call = .{ .target = 1 } }, .expected = false });
}

test "generated program purity rejects concurrent native functions as impure" {
    try expectPure(.{ .functions = &.{.{ .native = true, .concurrent = true }}, .root = .{ .call = .{ .target = 0 } }, .expected = false });
}

test "generated program purity rejects bound Store calls" {
    try expectPure(.{ .functions = &.{.{}}, .root = .{ .call = .{ .target = 0, .bound = true } }, .expected = false });
}

test "generated program purity rejects top level Store capabilities without reads" {
    try expectPure(.{ .store = true, .expected = false });
}

test "generated program purity rejects top level Store reads" {
    try expectPure(.{ .root = .store_get, .expected = false });
}

test "generated program purity rejects top level Task creation" {
    try expectPure(.{ .root = .task, .expected = false });
}

test "generated program purity rejects top level await" {
    try expectPure(.{ .root = .await_task, .expected = false });
}

test "generated program purity rejects top level cancellation" {
    try expectPure(.{ .root = .cancel_task, .expected = false });
}

test "generated program purity rejects top level parallel expressions" {
    try expectPure(.{ .root = .parallel, .expected = false });
}

test "generated program purity rejects a call into an empty table" {
    try expectPure(.{ .root = .{ .call = .{ .target = 0 } }, .expected = false });
}

test "generated program purity rejects a call exactly beyond the table" {
    try expectPure(.{ .functions = &.{.{}}, .root = .{ .call = .{ .target = 1 } }, .expected = false });
}

test "generated program purity ignores unused Store functions but rejects their calls" {
    try expectPure(.{ .functions = &.{.{ .store = true }}, .expected = true });
    try expectPure(.{ .functions = &.{.{ .store = true }}, .root = .{ .call = .{ .target = 0 } }, .expected = false });
}

test "generated program purity ignores unused Task functions" {
    try expectPure(.{ .functions = &.{.{ .effect = .task }}, .expected = true });
}
