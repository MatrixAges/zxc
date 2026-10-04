const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "official project checks share parsed modules and reuse them next call" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.helper);

    defer first.deinit();

    try f.check(first);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
    try std.testing.expectEqual(@as(usize, 2), cache.reused);

    var second = try f.run(std.testing.allocator, &cache, f.helper);

    defer second.deinit();

    try f.check(second);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
    try std.testing.expectEqual(@as(usize, 6), cache.reused);
}

test "normalized project paths reuse the same cache identity" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.helper);

    defer first.deinit();

    var second = try compiler.analyzeProjectWithCache(std.testing.allocator, &.{
        .{ .path = "dir/../main.zx", .source = f.main },
        .{ .path = "./helper.zx", .source = f.helper },
    }, .{ .entry = "./main.zx", .root_dir = "/project/./" }, &cache);

    defer second.deinit();

    try f.check(second);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
}

test "different project roots do not share relative source identities" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    for ([_][]const u8{ "/first", "/second" }) |root| {
        var result = try compiler.analyzeProjectWithCache(std.testing.allocator, &.{.{ .path = "helper.zx", .source = f.helper }}, .{ .entry = "helper.zx", .root_dir = root }, &cache);

        defer result.deinit();

        try f.check(result);
    }

    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
}

test "changing dependency signature reruns semantic checks on cached entry" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.helper);

    defer first.deinit();

    const incompatible = "export type Input = bool\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n  return in\n}\n";
    var second = try f.run(std.testing.allocator, &cache, incompatible);

    defer second.deinit();

    try std.testing.expect(second.value == .diagnostic);
    try std.testing.expectEqual(.type_mismatch, second.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), second.value.diagnostic.source_index);
    try std.testing.expectEqual(@as(usize, 3), cache.parsed);
}

test "parse diagnostics keep current source index when source order changes" {
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    var first = try f.run(std.testing.allocator, &cache, f.invalid);

    defer first.deinit();

    try std.testing.expectEqual(@as(?usize, 1), first.value.diagnostic.source_index);

    var second = try compiler.analyzeProjectWithCache(std.testing.allocator, &.{
        .{ .path = "helper.zx", .source = f.invalid },
        .{ .path = "main.zx", .source = f.main },
    }, .{ .entry = "main.zx", .root_dir = "/project" }, &cache);

    defer second.deinit();

    try std.testing.expectEqual(@as(?usize, 0), second.value.diagnostic.source_index);
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
}

test "previous IR survives cache replacement and destruction" {
    var result = blk: {
        var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

        defer cache.deinit();

        var first = try f.run(std.testing.allocator, &cache, f.helper);

        errdefer first.deinit();

        var second = try f.run(std.testing.allocator, &cache, f.changed);

        defer second.deinit();

        try f.check(second);
        try f.increment(second, 2);
        try f.increment(first, 1);

        break :blk first;
    };

    defer result.deinit();

    try f.check(result);
    try f.increment(result, 1);

    const generated = try compiler.zig.emit(std.testing.allocator, result.value.ir);

    defer std.testing.allocator.free(generated);

    try std.testing.expect(generated.len > 0);
    try std.testing.expectEqualStrings("/project/main.zx", result.value.ir.file_name);
}
