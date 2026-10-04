const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "same source and path reuse the same parsed result" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    const first = try cache.get(f.helper, "helper.zx");
    const second = try cache.get(f.helper, "helper.zx");

    try std.testing.expect(first == second);
    try std.testing.expectEqual(@as(usize, 1), cache.parsed);
    try std.testing.expectEqual(@as(usize, 1), cache.reused);
}

test "equal length changed contents replace the parsed source" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    _ = try cache.get(f.helper, "helper.zx");
    const result = try cache.get(f.changed, "helper.zx");

    try std.testing.expectEqual(f.helper.len, f.changed.len);
    try std.testing.expectEqualStrings(f.changed, result.value.parsed.source);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
    try std.testing.expectEqual(@as(usize, 0), cache.reused);
}

test "identical source under different paths remains separate" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    const first = try cache.get(f.helper, "a.zx");
    const second = try cache.get(f.helper, "b.zx");

    try std.testing.expect(first != second);
    try std.testing.expectEqualStrings("a.zx", first.value.parsed.file_name);
    try std.testing.expectEqualStrings("b.zx", second.value.parsed.file_name);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
}

test "cached parse owns caller source and path buffers" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    const source = try std.testing.allocator.dupe(u8, f.helper);
    const path = try std.testing.allocator.dupe(u8, "helper.zx");

    defer std.testing.allocator.free(source);
    defer std.testing.allocator.free(path);

    const result = try cache.get(source, path);

    @memset(source, 'x');
    @memset(path, 'x');

    try std.testing.expectEqualStrings(f.helper, result.value.parsed.source);
    try std.testing.expectEqualStrings("helper.zx", result.value.parsed.file_name);
    try std.testing.expect(result == try cache.get(f.helper, "helper.zx"));
}

test "invalid parse is reused and repair invalidates it" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    const first = try cache.get(f.invalid, "helper.zx");

    try std.testing.expect(first.value == .diagnostic);
    try std.testing.expectEqual(.syntax, first.value.diagnostic.code);
    try std.testing.expect(first == try cache.get(f.invalid, "helper.zx"));

    const repaired = try cache.get(f.helper, "helper.zx");

    try std.testing.expect(repaired.value == .parsed);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
    try std.testing.expectEqual(@as(usize, 1), cache.reused);
}

test "returning to earlier content reparses latest-only cache entry" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    _ = try cache.get(f.helper, "helper.zx");
    _ = try cache.get(f.changed, "helper.zx");
    const result = try cache.get(f.helper, "helper.zx");

    try std.testing.expectEqualStrings(f.helper, result.value.parsed.source);
    try std.testing.expectEqual(@as(usize, 3), cache.parsed);
}
