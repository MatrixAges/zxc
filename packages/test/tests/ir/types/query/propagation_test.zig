const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");

fn observe(tag: graph.Tag) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input = try graph.build(arena.allocator());
    const table = input.storage.view();
    const root = input.id(tag);
    const expected = graph.expected(tag);
    const before = try f.copyColumns(arena.allocator(), table);

    try std.testing.expectEqual(expected.native, try f.run(std.testing.allocator, table, root, .native_reference));
    try std.testing.expectEqual(expected.list, try f.run(std.testing.allocator, table, root, .list));

    var reporter: @import("zx").Reporter = .{};
    const types = f.frontend.types{ .allocator = std.testing.allocator, .reporter = &reporter, .declarations = &.{}, .items = input.storage };

    try std.testing.expectEqual(expected.list, try types.containsList(root));
    try f.unchanged(before, table);
}

test "query modes propagate void scalar with independent graph expectations" {
    try observe(.void_scalar);
}

test "query modes propagate mode with independent graph expectations" {
    try observe(.mode);
}

test "query modes propagate errors with independent graph expectations" {
    try observe(.errors);
}

test "query modes propagate plain optional with independent graph expectations" {
    try observe(.plain_optional);
}

test "query modes propagate empty tuple with independent graph expectations" {
    try observe(.empty_tuple);
}

test "query modes propagate empty object with independent graph expectations" {
    try observe(.empty_object);
}

test "query modes propagate node with independent graph expectations" {
    try observe(.node);
}

test "query modes propagate numbers with independent graph expectations" {
    try observe(.numbers);
}

test "query modes propagate optional node with independent graph expectations" {
    try observe(.optional_node);
}

test "query modes propagate list node with independent graph expectations" {
    try observe(.list_node);
}

test "query modes propagate tuple native first with independent graph expectations" {
    try observe(.tuple_native_first);
}

test "query modes propagate tuple native last with independent graph expectations" {
    try observe(.tuple_native_last);
}

test "query modes propagate tuple plain with independent graph expectations" {
    try observe(.tuple_plain);
}

test "query modes propagate tuple list first with independent graph expectations" {
    try observe(.tuple_list_first);
}

test "query modes propagate tuple list last with independent graph expectations" {
    try observe(.tuple_list_last);
}

test "query modes propagate tuple mixed with independent graph expectations" {
    try observe(.tuple_mixed);
}

test "query modes propagate tuple shared with independent graph expectations" {
    try observe(.tuple_shared);
}

test "query modes propagate empty tuple after with independent graph expectations" {
    try observe(.empty_tuple_after);
}

test "query modes propagate object native first with independent graph expectations" {
    try observe(.object_native_first);
}

test "query modes propagate object native last with independent graph expectations" {
    try observe(.object_native_last);
}

test "query modes propagate object list last with independent graph expectations" {
    try observe(.object_list_last);
}

test "query modes propagate object mixed with independent graph expectations" {
    try observe(.object_mixed);
}

test "query modes propagate object plain with independent graph expectations" {
    try observe(.object_plain);
}

test "query modes propagate optional list node with independent graph expectations" {
    try observe(.optional_list_node);
}

test "query modes propagate optional numbers with independent graph expectations" {
    try observe(.optional_numbers);
}

test "query modes propagate optional object with independent graph expectations" {
    try observe(.optional_object);
}

test "query modes propagate task scalar with independent graph expectations" {
    try observe(.task_scalar);
}

test "query modes propagate task node with independent graph expectations" {
    try observe(.task_node);
}

test "query modes propagate task numbers with independent graph expectations" {
    try observe(.task_numbers);
}

test "query modes propagate task list node with independent graph expectations" {
    try observe(.task_list_node);
}

test "query modes propagate task object with independent graph expectations" {
    try observe(.task_object);
}

test "query modes propagate task enum with independent graph expectations" {
    try observe(.task_enum);
}

test "query modes propagate late enum with independent graph expectations" {
    try observe(.late_enum);
}

test "query modes propagate late node with independent graph expectations" {
    try observe(.late_node);
}
