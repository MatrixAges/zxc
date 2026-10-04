const std = @import("std");
const f = @import("fixture.zig");

test "semantic cache populate reuse and replace clean every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "semantic cache signature rejection cleans every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

fn run(allocator: std.mem.Allocator, invalid: bool) !void {
    var cache = f.Cache.init(allocator);

    defer cache.deinit();

    var first = try f.run(allocator, &cache, f.source.helper);

    defer first.deinit();

    var second = try f.run(allocator, &cache, f.source.helper);

    defer second.deinit();

    try f.check(second, 1);

    var third = try f.run(allocator, &cache, if (invalid) f.incompatible else f.source.changed);

    defer third.deinit();

    if (invalid) {
        try std.testing.expect(third.value == .diagnostic);
        try std.testing.expectEqual(.type_mismatch, third.value.diagnostic.code);
    } else {
        try f.check(third, 2);
    }
}
