const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const Problem = enum { shape, binding, first, past_end, prefix };

const Case = struct {
    problem: Problem,
    fail_owner: bool = false,
    fail_temporary: bool = false,
    expected: f.Table.Error,
    owner_induced: bool = false,
    temporary_induced: bool = false,
};

fn observe(case: Case) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner_failure = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = if (case.fail_owner) 0 else std.math.maxInt(usize) });
    var temporary_failure = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = if (case.fail_temporary) 0 else std.math.maxInt(usize) });
    var owner = std.heap.ArenaAllocator.init(owner_failure.allocator());

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(temporary_failure.allocator());

    defer temporary.deinit();

    const memory = setup.allocator();
    var source = try f.Table.init(memory);
    var target = try f.Table.init(memory);
    _ = try f.fill(&source, .base);
    _ = try f.fill(&target, if (case.problem == .prefix) .optional_child else .base);

    var previous: f.ir.TypeStorage = .{};

    try previous.appendDelta(memory, target.items.view());

    var bindings = source.origins.items.view();
    var first = source.items.count();

    switch (case.problem) {
        .shape => bindings.kinds = &.{},
        .binding => bindings.names = &.{ "Mode", "DifferentNode" },
        .first => first -= 1,
        .past_end => first += 1,
        .prefix => {},
    }

    target.allocator = owner.allocator();

    try std.testing.expectError(case.expected, target.appendFrom(temporary.allocator(), source.items.view(), bindings, first));
    try std.testing.expectEqual(case.owner_induced, owner_failure.has_induced_failure);
    try std.testing.expectEqual(case.temporary_induced, temporary_failure.has_induced_failure);
    try f.columnsEqual(previous.view(), target.items.view());
}

test "invalid origin shape precedes both allocator failures" {
    try observe(.{ .problem = .shape, .fail_owner = true, .fail_temporary = true, .expected = error.InvalidModule });
}

test "origin index allocation precedes invalid binding" {
    try observe(.{ .problem = .binding, .fail_temporary = true, .expected = error.OutOfMemory, .temporary_induced = true });
}

test "invalid binding precedes mapping allocation" {
    try observe(.{ .problem = .binding, .fail_owner = true, .expected = error.InvalidModule });
}

test "origin index allocation precedes first boundary validation" {
    try observe(.{ .problem = .first, .fail_temporary = true, .expected = error.OutOfMemory, .temporary_induced = true });
}

test "incomplete target prefix is rejected before mapping allocation" {
    try observe(.{ .problem = .first, .fail_owner = true, .expected = error.InvalidModule });
}

test "prefix past source end is rejected before mapping allocation" {
    try observe(.{ .problem = .past_end, .fail_owner = true, .expected = error.InvalidModule });
}

test "mapping allocation precedes prefix content comparison" {
    try observe(.{ .problem = .prefix, .fail_owner = true, .expected = error.OutOfMemory, .owner_induced = true });
}

test "successful allocations expose the precise prefix mismatch" {
    try observe(.{ .problem = .prefix, .expected = error.InvalidModule });
}

fn allocationSweep(allocator: std.mem.Allocator, role: enum { owner, temporary }) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner = std.heap.ArenaAllocator.init(if (role == .owner) allocator else std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(if (role == .temporary) allocator else std.testing.allocator);

    defer temporary.deinit();

    var target = try f.Table.init(setup.allocator());

    _ = try f.fill(&target, .base);

    var previous: f.ir.TypeStorage = .{};

    try previous.appendDelta(setup.allocator(), target.items.view());

    target.allocator = owner.allocator();

    const mapping = target.appendFrom(temporary.allocator(), target.items.view(), target.origins.items.view(), target.items.count()) catch |err| {
        try f.columnsEqual(previous.view(), target.items.view());

        return err;
    };

    try f.identity(mapping);
    try f.columnsEqual(previous.view(), target.items.view());
}

test "complete prefix releases every owner allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, allocationSweep, .{.owner});
}

test "complete prefix releases every temporary allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, allocationSweep, .{.temporary});
}
