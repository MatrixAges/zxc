const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const compiler = f.compiler;

fn library(source: []const u8) !compiler.library.Result {
    var analysis = try f.analyze("main.zx", source);

    defer analysis.deinit();

    return compiler.library.link(std.testing.allocator, &.{.{ .name = ".", .analysis = &analysis }});
}

fn expectBundle(expected: compiler.zig.LibraryBundle, actual: compiler.zig.LibraryBundle) !void {
    try std.testing.expectEqualDeep(expected.public_modules, actual.public_modules);
    try std.testing.expectEqualDeep(expected.modules, actual.modules);
    try std.testing.expectEqualStrings(expected.types, actual.types);
}

test "unified bundle cache follows same path source changes and reversion" {
    var first = try library(f.function);

    defer first.deinit();

    var changed = try library("export type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return in + 2 }\n");

    defer changed.deinit();

    var expected_first = try compiler.zig.emitLibrary(std.testing.allocator, &first);

    defer expected_first.deinit();

    var expected_changed = try compiler.zig.emitLibrary(std.testing.allocator, &changed);

    defer expected_changed.deinit();

    try std.testing.expect(!std.mem.eql(u8, expected_first.public_modules[0].file.source, expected_changed.public_modules[0].file.source));

    var cache = compiler.zig.GenerationCache.init(std.testing.allocator);

    defer cache.deinit();

    for ([_]*const compiler.library.Result{ &first, &changed, &first }, [_]compiler.zig.LibraryBundle{ expected_first, expected_changed, expected_first }) |value, expected| {
        var actual = try compiler.zig.emitLibraryCached(std.testing.allocator, value, &cache);

        defer actual.deinit();

        try expectBundle(expected, actual);
    }
}

fn coldAllocation(allocator: std.mem.Allocator, value: *const compiler.library.Result) !void {
    var cache = compiler.zig.GenerationCache.init(allocator);

    defer cache.deinit();

    var bundle = try compiler.zig.emitLibraryCached(allocator, value, &cache);

    defer bundle.deinit();
}

test "unified bundle cold cache allocation failures release cache and output" {
    var value = try library(f.function);

    defer value.deinit();

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, coldAllocation, .{&value});
}

fn warmAllocation(allocator: std.mem.Allocator, value: *const compiler.library.Result) !void {
    var cache = compiler.zig.GenerationCache.init(std.testing.allocator);

    defer cache.deinit();

    var first = try compiler.zig.emitLibraryCached(std.testing.allocator, value, &cache);

    defer first.deinit();

    var repeated = try compiler.zig.emitLibraryCached(allocator, value, &cache);

    defer repeated.deinit();

    try expectBundle(first, repeated);
}

test "unified bundle warm cache output allocation failures release partial copies" {
    var value = try library(f.function);

    defer value.deinit();

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, warmAllocation, .{&value});
}
