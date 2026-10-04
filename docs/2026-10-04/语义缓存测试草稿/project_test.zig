const std = @import("std");
const f = @import("fixture.zig");

test "unchanged project reuses both semantic artifacts" {
    var cache = f.Cache.init(std.testing.allocator);

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer first.deinit();

    try f.check(first, 1);
    try std.testing.expectEqual(@as(usize, 2), cache.analyzed);
    try std.testing.expectEqual(@as(usize, 0), cache.reused);

    var second = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer second.deinit();

    try f.check(second, 1);
    try std.testing.expectEqual(@as(usize, 2), cache.analyzed);
    try std.testing.expectEqual(@as(usize, 2), cache.reused);
}

test "changed helper body preserves caller reuse but updates function IR" {
    var cache = f.Cache.init(std.testing.allocator);

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer first.deinit();

    var second = try f.run(std.testing.allocator, &cache, f.source.changed);

    defer second.deinit();

    try f.check(first, 1);
    try f.check(second, 2);
    try std.testing.expectEqual(@as(usize, 3), cache.analyzed);
    try std.testing.expectEqual(@as(usize, 1), cache.reused);
}

test "incompatible dependency signature is diagnosed and repair reuses valid cache" {
    var cache = f.Cache.init(std.testing.allocator);

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer first.deinit();

    var invalid = try f.run(std.testing.allocator, &cache, f.incompatible);

    defer invalid.deinit();

    try std.testing.expect(invalid.value == .diagnostic);
    try std.testing.expectEqual(.type_mismatch, invalid.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), invalid.value.diagnostic.source_index);
    try std.testing.expectEqual(@as(usize, 0), cache.reused);

    var repaired = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer repaired.deinit();

    try f.check(repaired, 1);
    try std.testing.expectEqual(@as(usize, 2), cache.reused);
}

test "reordered sources and normalized paths retain semantic reuse" {
    var cache = f.Cache.init(std.testing.allocator);

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.source.helper);

    defer first.deinit();

    var second = try f.compiler.project.analyzeIncremental(std.testing.allocator, &.{
        .{ .path = "./helper.zx", .source = f.source.helper },
        .{ .path = "dir/../main.zx", .source = f.source.main },
    }, .{ .entry = "./main.zx", .root_dir = "/project/./" }, &cache);

    defer second.deinit();

    try f.check(second, 1);
    try std.testing.expectEqual(@as(usize, 2), cache.analyzed);
    try std.testing.expectEqual(@as(usize, 2), cache.reused);
}

test "cache hit result outlives replacement and cache destruction" {
    var result = block: {
        var cache = f.Cache.init(std.testing.allocator);

        defer cache.deinit();

        var first = try f.run(std.testing.allocator, &cache, f.source.helper);

        defer first.deinit();

        var hit = try f.run(std.testing.allocator, &cache, f.source.helper);

        errdefer hit.deinit();

        var changed = try f.run(std.testing.allocator, &cache, f.source.changed);

        defer changed.deinit();

        try f.check(changed, 2);

        break :block hit;
    };

    defer result.deinit();

    try f.check(result, 1);

    const generated = try f.compiler.zig.emit(std.testing.allocator, result.value.ir);

    defer std.testing.allocator.free(generated);

    try std.testing.expect(generated.len != 0);
}
