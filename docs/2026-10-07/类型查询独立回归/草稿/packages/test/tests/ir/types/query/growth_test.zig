const std = @import("std");
const f = @import("fixture.zig");
const growth = @import("growth.zig");

fn observe(shape: growth.Shape, size: usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try growth.build(arena.allocator(), shape, size);
    const before = try f.copyColumns(arena.allocator(), value.storage.view());

    try std.testing.expectEqual(value.native, try f.run(std.testing.allocator, value.storage.view(), value.root, .native_reference));
    try std.testing.expectEqual(value.list, try f.run(std.testing.allocator, value.storage.view(), value.root, .list));
    try f.unchanged(before, value.storage.view());
}

test "deep native optional chain crosses geometric growth boundaries" {
    try observe(.chain_native, 2048);
}

test "deep list optional chain crosses geometric growth boundaries" {
    try observe(.chain_list, 2048);
}

test "deep plain chain ignores targets placed after the root" {
    try observe(.chain_plain, 2048);
}

test "wide native tuple finds the target at the last pooled child" {
    try observe(.wide_native, 1024);
}

test "wide list tuple finds the target at the last pooled child" {
    try observe(.wide_list, 1024);
}

test "wide plain tuple ignores unrelated native and list rows" {
    try observe(.wide_plain, 1024);
}

test "empty wide tuple ignores prefix targets in both modes" {
    try observe(.wide_plain, 0);
}

test "shared mixed DAG propagates both targets across many rows" {
    try observe(.dag_mixed, 1024);
}

test "shared negative DAG avoids expanding duplicate paths" {
    try observe(.dag_plain, 1024);
}

test "deep task list result propagates native but not list" {
    try observe(.task_list_native, 512);
}
