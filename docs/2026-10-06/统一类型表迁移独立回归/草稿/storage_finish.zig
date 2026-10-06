const std = @import("std");
const core = @import("core");
const allocation_testing = @import("allocation_testing");

fn finish(allocator: std.mem.Allocator) !void {
    var storage: core.ir.TypeStorage = .{};

    defer storage.deinit(allocator);

    inline for (@typeInfo(core.ir.Scalar).@"enum".field_names) |name| {
        try storage.append(allocator, .{ .scalar = @field(core.ir.Scalar, name) });
    }

    const table = try storage.finish(allocator);

    defer {
        inline for (@typeInfo(core.ir.TypeTable).@"struct".field_names) |name| {
            allocator.free(@field(table, name));
        }
    }

    try std.testing.expect(table.validStructure());
    try std.testing.expectEqual(@typeInfo(core.ir.Scalar).@"enum".field_names.len, table.count());

    inline for (@typeInfo(core.ir.Scalar).@"enum".field_names, 0..) |name, index| {
        try std.testing.expectEqual(@field(core.ir.Scalar, name), table.at(index).scalar);
    }
}

test "type storage finish releases transferred columns on every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, finish, .{});
}
