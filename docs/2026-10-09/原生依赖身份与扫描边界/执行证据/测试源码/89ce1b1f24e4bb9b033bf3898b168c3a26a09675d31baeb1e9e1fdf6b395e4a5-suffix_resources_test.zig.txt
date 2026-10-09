const std = @import("std");
const h = @import("suffix/check.zig");
const f = h.f;

fn attempt(origin: f.Origins.Origin, fail_index: usize) !usize {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    const input = try f.create(setup.allocator(), origin == .native);
    const first = @as(usize, @backingInt(input.nominal[0].id)) + 1;
    const snapshot = try h.copy(setup.allocator(), input.types);
    var items = f.Origins{ .allocator = owner.allocator() };

    try h.prefix(&items, input);

    const previous = try h.copy(setup.allocator(), items.items.view());
    var vtable = items.allocator.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    var failure = std.testing.FailingAllocator.init(.{ .ptr = items.allocator.ptr, .vtable = &vtable }, .{ .fail_index = fail_index });
    items.allocator = failure.allocator();

    var failed = false;

    items.append(input.types, first, origin) catch |err| {
        failed = true;

        try std.testing.expectEqual(error.OutOfMemory, err);
        try std.testing.expect(failure.has_induced_failure);
        try h.same(previous, items.items.view());
        try std.testing.expect(items.items.view().hasValidShape());
    };

    try std.testing.expectEqual(fail_index != std.math.maxInt(usize), failed);
    try h.same(snapshot, input.types);

    const count = failure.alloc_index;
    items.allocator = owner.allocator();

    if (failed) try items.append(input.types, first, origin);
    try h.result(items, input, first, origin, true);
    try h.same(snapshot, input.types);

    return count;
}

fn sweep(origin: f.Origins.Origin) !void {
    const count = try attempt(origin, std.math.maxInt(usize));

    try std.testing.expect(count > 0);
    for (0..count) |index| _ = try attempt(origin, index);
}

fn empty(at_end: bool) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    const input = try f.create(setup.allocator(), true);
    const first = if (at_end) input.types.count() else @as(usize, @backingInt(input.nominal[input.nominal.len - 1].id)) + 1;
    var items = f.Origins{ .allocator = owner.allocator() };

    try h.prefix(&items, input);

    const previous = try h.copy(setup.allocator(), items.items.view());
    var failure = std.testing.FailingAllocator.init(items.allocator, .{ .fail_index = 0 });
    items.allocator = failure.allocator();

    try items.append(input.types, first, f.origin(.native));
    try std.testing.expectEqual(@as(usize, 0), failure.alloc_index);
    try std.testing.expect(!failure.has_induced_failure);
    try h.same(previous, items.items.view());
}

test "source suffix allocation failures restore all columns and permit retry" {
    try sweep(f.origin(.source));
}

test "native suffix allocation failures restore all columns and permit retry" {
    try sweep(f.origin(.native));
}

test "external suffix allocation failures restore owner member and name columns and permit retry" {
    try sweep(f.origin(.external));
}

test "empty suffix preserves existing origin columns without allocating" {
    try empty(true);
}

test "non nominal trailing suffix preserves existing origin columns without allocating" {
    try empty(false);
}
