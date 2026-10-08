const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

test "native namespace result owns member paths after input release" {
    var result = block: {
        var input = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer input.deinit();

        const memory = input.allocator();
        const parts = try memory.alloc([]const u8, 3);
        const expected: []const []const u8 = &.{ "outer", "\xe4\xb8\xad", "api-unit" };

        for (parts, expected) |*part, text| part.* = try memory.dupe(u8, text);

        const declaration = try memory.dupe(u8, f.valid);
        var value = try f.analyze(std.testing.allocator, .{ .namespace = parts, .declaration = declaration });

        errdefer value.deinit();

        for (parts) |part| @memset(@constCast(part), 'x');

        @memset(declaration, 'x');

        break :block value;
    };

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try f.inspect(std.testing.allocator, result.value.ir, &.{ "outer", "\xe4\xb8\xad", "api-unit" });
}

test "native namespace success releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{f.Case{ .namespace = &.{ "outer", "\xe4\xb8\xad", "api-unit" } }});
}

test "native namespace short circuit releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{f.Case{ .namespace = &.{ "outer", "" }, .declaration = "export declare function apply(input: Missing): Missing\n", .expected = .module }});
}

test "type only namespace rejection releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{f.Case{ .namespace = &.{ "outer", "\xf0\x9f\x99" }, .type_only = true, .expected = .module }});
}
