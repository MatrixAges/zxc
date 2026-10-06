const std = @import("std");
const f = @import("storage_append_fixture.zig");
const Mode = enum { tuple, object, enumeration, delta };

fn append(storage: *f.ir.TypeStorage, allocator: std.mem.Allocator, mode: Mode) !void {
    switch (mode) {
        .tuple => try storage.append(allocator, .{ .tuple = &.{ @fromBackingInt(@backingInt(f.ir.Scalar.u64)), @fromBackingInt(@backingInt(f.ir.Scalar.bool)) } }),
        .object => try storage.append(allocator, .{ .object = .{ .names = &.{ "count", "enabled" }, .types = &.{ @backingInt(f.ir.Scalar.u64), @backingInt(f.ir.Scalar.bool) }, .len = 2 } }),
        .enumeration => try storage.append(allocator, .{ .enumeration = .{ .name = "Extra", .members = &.{ "Third", "Fourth" } } }),
        .delta => unreachable,
    }
}

fn attempt(mode: Mode, failure_index: usize) !bool {
    var backing_vtable = std.testing.allocator.vtable.*;
    backing_vtable.resize = std.mem.Allocator.noResize;
    backing_vtable.remap = std.mem.Allocator.noRemap;
    const backing: std.mem.Allocator = .{ .ptr = std.testing.allocator.ptr, .vtable = &backing_vtable };
    var failing = std.testing.FailingAllocator.init(backing, .{});
    const allocator = failing.allocator();
    var expected = try f.seed(std.testing.allocator);

    defer expected.deinit(std.testing.allocator);

    var delta: f.ir.TypeStorage = .{};

    defer delta.deinit(std.testing.allocator);

    if (mode == .delta) {
        try f.group(&delta, std.testing.allocator, expected.count());
        try std.testing.expect(delta.view().validStructure());
    }

    var induced = false;

    {
        var storage = try f.seed(allocator);

        defer storage.deinit(allocator);

        inline for (@typeInfo(f.ir.TypeStorage).@"struct".field_names) |name| {
            const items = &@field(storage, name);

            items.shrinkAndFree(allocator, items.items.len);

            try std.testing.expectEqual(items.items.len, items.capacity);
        }

        try f.equal(storage.view(), expected.view());
        try f.valid(storage.view());

        failing.fail_index = failing.alloc_index + failure_index;

        const result = if (mode == .delta) storage.appendDelta(allocator, delta.view()) else append(&storage, allocator, mode);

        if (result) |_| {
            try std.testing.expect(!failing.has_induced_failure);
        } else |err| {
            try std.testing.expectEqual(error.OutOfMemory, err);
            try std.testing.expect(failing.has_induced_failure);
            try f.equal(storage.view(), expected.view());
            try f.valid(storage.view());

            induced = true;
            failing.fail_index = std.math.maxInt(usize);

            if (mode == .delta) {
                try storage.appendDelta(allocator, delta.view());
            } else try append(&storage, allocator, mode);
        }

        if (mode == .delta) {
            try f.group(&expected, std.testing.allocator, 0);
        } else try append(&expected, std.testing.allocator, mode);

        try f.equal(storage.view(), expected.view());
        try f.valid(storage.view());
    }

    try std.testing.expectEqual(failing.allocated_bytes, failing.freed_bytes);
    try std.testing.expectEqual(failing.allocations, failing.deallocations);

    return induced;
}

fn check(mode: Mode) !void {
    var failures: usize = 0;

    while (try attempt(mode, failures)) failures += 1;
    try std.testing.expect(failures > 1);
}

test "tuple append preserves all logical columns at every capacity failure and retries" {
    try check(.tuple);
}

test "object append preserves paired fields at every capacity failure and retries" {
    try check(.object);
}

test "enum append preserves member ranges at every capacity failure and retries" {
    try check(.enumeration);
}

test "delta append preserves all ranges and global references after every failure and retry" {
    try check(.delta);
}
