const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

test "successful type merge cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "nominal conflict cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

fn run(allocator: std.mem.Allocator, conflict: bool) !void {
    var left = try f.extract("shared.zx", f.declaration);

    defer left.deinit();

    var right = try f.extract("shared.zx", if (conflict) "export enum Mode { First, Third }" else f.declaration);

    defer right.deinit();

    var result = f.artifact.type_link.merge(allocator, &.{ left.value, right.value }) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expect(conflict);
        try std.testing.expectEqual(error.ConflictingNominalType, err);

        return;
    };

    defer result.deinit();

    try std.testing.expect(!conflict);
    try std.testing.expectEqual(@as(usize, 1), result.nominal_types.count());
}
