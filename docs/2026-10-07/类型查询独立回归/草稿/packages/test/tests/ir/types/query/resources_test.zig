const std = @import("std");
const allocation = @import("allocation_testing");
const f = @import("fixture.zig");
const graph = @import("graph.zig");
const growth = @import("growth.zig");

const Input = struct {
    table: f.ir.TypeTable,
    before: f.ir.TypeTable,
    root: f.ir.TypeId,
    mode: f.Mode,
    expected: bool,
};

fn query(memory: std.mem.Allocator, input: Input) !void {
    const result = f.run(memory, input.table, input.root, input.mode) catch |err| {
        try f.unchanged(input.before, input.table);

        return err;
    };

    try std.testing.expectEqual(input.expected, result);
    try f.unchanged(input.before, input.table);
}

fn publicList(memory: std.mem.Allocator, input: Input, storage: f.ir.TypeStorage) !void {
    var reporter: @import("zx").Reporter = .{};
    const types = f.frontend.types{ .allocator = memory, .reporter = &reporter, .declarations = &.{}, .items = storage };

    const result = types.containsList(input.root) catch |err| {
        try f.unchanged(input.before, input.table);

        return err;
    };

    try std.testing.expectEqual(input.expected, result);
    try f.unchanged(input.before, input.table);
}

fn failures(shape: growth.Shape, mode: f.Mode) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try growth.build(arena.allocator(), shape, 256);

    const input = Input{
        .table = value.storage.view(),
        .before = try f.copyColumns(arena.allocator(), value.storage.view()),
        .root = value.root,
        .mode = mode,
        .expected = if (mode == .native_reference) value.native else value.list,
    };

    try allocation.checkAllAllocationFailures(std.testing.allocator, query, .{input});
}

test "positive and negative slow queries release every scratch allocation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try graph.build(arena.allocator());
    const before = try f.copyColumns(arena.allocator(), value.storage.view());

    for ([_]graph.Tag{ .tuple_mixed, .object_plain, .task_object, .late_enum }) |tag| {
        const expected = graph.expected(tag);

        for (std.enums.values(f.Mode)) |mode| {
            var memory = std.testing.FailingAllocator.init(std.testing.allocator, .{});

            try query(memory.allocator(), .{
                .table = value.storage.view(),
                .before = before,
                .root = value.id(tag),
                .mode = mode,
                .expected = if (mode == .native_reference) expected.native else expected.list,
            });

            try std.testing.expect(memory.alloc_index > 0);
            try std.testing.expectEqual(memory.allocated_bytes, memory.freed_bytes);
        }
    }
}

test "native mixed DAG propagates every allocation failure without mutation" {
    try failures(.dag_mixed, .native_reference);
}

test "list mixed DAG propagates every allocation failure without mutation" {
    try failures(.dag_mixed, .list);
}

test "negative native wide tuple propagates allocation failures" {
    try failures(.wide_plain, .native_reference);
}

test "negative list wide tuple propagates allocation failures" {
    try failures(.wide_plain, .list);
}

test "native task result propagates allocation failures across deep children" {
    try failures(.task_list_native, .native_reference);
}

test "list task barrier propagates allocation failures before returning false" {
    try failures(.task_list_native, .list);
}

test "public containsList preserves allocation errors and borrowed input" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try growth.build(arena.allocator(), .dag_mixed, 256);

    const input = Input{
        .table = value.storage.view(),
        .before = try f.copyColumns(arena.allocator(), value.storage.view()),
        .root = value.root,
        .mode = .list,
        .expected = true,
    };

    try allocation.checkAllAllocationFailures(std.testing.allocator, publicList, .{ input, value.storage });
}

test "repeated reversed roots and modes do not retain flags between queries" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try graph.build(arena.allocator());
    const before = try f.copyColumns(arena.allocator(), value.storage.view());
    const tags = std.enums.values(graph.Tag);

    for (0..3) |_| {
        for (0..tags.len) |index| {
            const tag = tags[tags.len - index - 1];
            const expected = graph.expected(tag);

            for ([_]f.Mode{ .list, .native_reference }) |mode| {
                try query(std.testing.allocator, .{
                    .table = value.storage.view(),
                    .before = before,
                    .root = value.id(tag),
                    .mode = mode,
                    .expected = if (mode == .native_reference) expected.native else expected.list,
                });
            }
        }
    }
}
