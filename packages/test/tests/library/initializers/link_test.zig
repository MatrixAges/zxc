const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn link(allocator: std.mem.Allocator, mode: f.Mode) !void {
    var result = try f.library(allocator, mode);

    defer result.deinit();

    try f.check(&result, if (mode == .omitted) 0 else 1);
    if (mode != .omitted) try std.testing.expectEqualStrings(f.identity, result.store_initializers[0].identity);
}

test "source Store initializer remains owned after RX inference is released" {
    try link(std.testing.allocator, .single);
}

test "duplicate public modules deduplicate the same Store initializer" {
    var result = try f.library(std.testing.allocator, .duplicate);

    defer result.deinit();

    try f.check(&result, 1);
    try std.testing.expectEqual(@as(usize, 2), result.exports.len);

    var count: usize = 0;

    for (result.program.functions) |function| {
        if (std.mem.eql(u8, function.file_name, f.identity)) count += 1;
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

test "same Store identity rejects a different schema version" {
    try std.testing.expectError(error.ConflictingInitializer, f.library(std.testing.allocator, .version_conflict));
}

test "same Store identity rejects a different initial value" {
    try std.testing.expectError(error.ConflictingInitializer, f.library(std.testing.allocator, .value_conflict));
}

test "explicit host libraries may omit Store initialization" {
    try link(std.testing.allocator, .omitted);
}

test "initializer link cleans every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, link, .{f.Mode.single});
}

test "initializer deduplication cleans every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, link, .{f.Mode.duplicate});
}

fn reject(allocator: std.mem.Allocator, mode: f.Mode) !void {
    const result = f.library(allocator, mode);

    if (result) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedConflict;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.ConflictingInitializer, err);
    }
}

test "initializer version conflict cleans allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{f.Mode.version_conflict});
}

test "initializer value conflict cleans allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{f.Mode.value_conflict});
}
