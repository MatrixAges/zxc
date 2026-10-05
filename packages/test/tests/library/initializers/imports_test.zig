const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const imported = @import("import_fixture.zig");

fn check(allocator: std.mem.Allocator, distinct: bool) !void {
    var analyzed = try imported.analyze(allocator, distinct, false);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expectEqual(@as(usize, 0), analyzed.value.ir.stores.len);
    try std.testing.expectEqual(@as(usize, if (distinct) 2 else 1), analyzed.store_initializers.len);
    if (distinct) try std.testing.expect(!std.mem.eql(u8, analyzed.store_initializers[0].identity, analyzed.store_initializers[1].identity));

    var result = try f.compiler.library.link(allocator, &.{.{ .name = "relay", .analysis = &analyzed }});

    defer result.deinit();

    try f.check(&result, if (distinct) 2 else 1);

    const bytes = try f.compiler.library.codec.encode(allocator, &result);

    defer allocator.free(bytes);

    var restored = try f.compiler.library.codec.decode(allocator, bytes);

    defer restored.deinit();

    try std.testing.expectEqualDeep(result.store_initializers, restored.store_initializers);
    try f.check(&restored, if (distinct) 2 else 1);
}

test "same compiled instance shares initializer across aliases and republication" {
    try check(std.testing.allocator, false);
}

test "distinct compiled instances keep independent Store initializers through republication" {
    try check(std.testing.allocator, true);
}

test "imported initialization metadata never grants Store calling capability" {
    var result = try imported.analyze(std.testing.allocator, false, true);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.capability, result.value.diagnostic.code);
}

test "compiled Store initialization import and republication clean partial allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{true});
}
