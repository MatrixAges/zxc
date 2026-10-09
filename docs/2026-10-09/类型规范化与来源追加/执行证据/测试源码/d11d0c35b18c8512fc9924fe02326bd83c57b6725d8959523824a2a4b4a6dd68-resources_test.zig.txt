const std = @import("std");
const allocation_testing = @import("allocation_testing");
const fixture = @import("fixture.zig");
const Role = enum { owner, temporary };

fn run(allocator: std.mem.Allocator, role: Role, boundary: fixture.Boundary) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner = std.heap.ArenaAllocator.init(if (role == .owner) allocator else std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(if (role == .temporary) allocator else std.testing.allocator);

    defer temporary.deinit();

    var state = try fixture.create(setup.allocator(), boundary, .repeated);
    const before = state.table.items.view();
    const origins = state.table.origins.items.view();
    state.table.allocator = owner.allocator();

    const mapping = state.table.compact(temporary.allocator(), state.first, state.origin_count) catch |err| {
        try std.testing.expectEqual(state.first, state.table.items.count());
        try std.testing.expectEqual(state.origin_count, state.table.origins.items.view().count());
        try fixture.prefixUnchanged(state);
        try fixture.pointersEqual(before, state.table.items.view());
        try fixture.pointersEqual(origins, state.table.origins.items.view());

        return err;
    };

    try fixture.prefixUnchanged(state);
    try fixture.pointersEqual(before, state.table.items.view());
    try fixture.pointersEqual(origins, state.table.origins.items.view());
    try std.testing.expectEqual(mapping[@backingInt(state.ids.record)], mapping[@backingInt(state.repeated.record)]);
    try std.testing.expect(state.table.items.view().validStructure());
}

test "in place compaction restores scalar prefix at every owner allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ Role.owner, fixture.Boundary.scalar });
}

test "in place compaction restores scalar prefix at every temporary allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ Role.temporary, fixture.Boundary.scalar });
}

test "in place compaction restores payload and nominal prefix at every owner failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ Role.owner, fixture.Boundary.full });
}

test "in place compaction restores payload and nominal prefix at every temporary failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ Role.temporary, fixture.Boundary.full });
}
