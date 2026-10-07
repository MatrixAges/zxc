const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const fixture = @import("store_fixture.zig");

fn check(allocator: std.mem.Allocator, different_path: bool, different_type: bool) !void {
    const path = if (different_path) "other.store.rx" else "state.store.rx";
    var result = try fixture.link(allocator, path, if (different_type) "u32" else "u64", false);

    defer result.deinit();

    const left = try result.module(0);
    const right = try result.module(1);

    try std.testing.expectEqual(@as(usize, 1), left.stores.count());
    try std.testing.expectEqual(@as(usize, 1), right.stores.count());
    try std.testing.expectEqualStrings("store.state.store.rx:counter", left.stores.at(0).path);
    try std.testing.expectEqualStrings(if (different_path) "store.other.store.rx:counter" else "store.state.store.rx:counter", right.stores.at(0).path);
    try std.testing.expectEqual(!different_type, left.stores.at(0).type_id == right.stores.at(0).type_id);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, left) == null);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, right) == null);
}

test "unified same Store identity shares object type across public modules" {
    try check(std.testing.allocator, false, false);
}

test "unified different Store paths preserve identity despite equal declaration name and type" {
    try check(std.testing.allocator, true, false);
}

test "unified different Store paths may have different object types" {
    try check(std.testing.allocator, true, true);
}

test "unified conflicting Store object types reject in either public order" {
    for ([_]bool{ false, true }) |reverse| {
        try std.testing.expectError(error.ConflictingStore, fixture.link(std.testing.allocator, "state.store.rx", "u32", reverse));
    }
}

test "unified shared Store linkage allocation failures release copied slots" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ false, false });
}

fn reject(allocator: std.mem.Allocator) !void {
    const result = fixture.link(allocator, "state.store.rx", "u32", false);

    if (result) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedStoreConflict;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.ConflictingStore, err);
    }
}

test "unified Store conflict releases partially linked functions" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{});
}
