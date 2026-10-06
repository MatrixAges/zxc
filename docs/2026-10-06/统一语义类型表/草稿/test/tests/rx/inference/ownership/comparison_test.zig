const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const output = @import("output.zig");

test "ZX consumes an owned function return" {
    var result = try compiler.analyzeProject(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("fixtures/main.zx") },
        .{ .path = "make.zx", .source = @embedFile("fixtures/make.zx") },
    }, .{ .entry = "main.zx" });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("ZX diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
}

test "RX consumes an owned function return" {
    var parsed = try rx.parseXml(std.testing.allocator, @embedFile("fixtures/main.rx"));

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{ .{ .path = "make.zx", .source = @embedFile("fixtures/make.zx") }, .{ .path = "pop_values.zx", .source = @import("rx_collection_fixtures").pop_values } },
    });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("RX diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .contract);
    try output.check(result.value.contract.program, .pop);
}

test "RX immutable pop reads a borrowed function return" {
    var parsed = try rx.parseXml(std.testing.allocator, @embedFile("fixtures/main.rx"));

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{ .{ .path = "make.zx", .source = @embedFile("fixtures/borrowed.zx") }, .{ .path = "pop_values.zx", .source = @import("rx_collection_fixtures").pop_values } },
    });

    defer result.deinit();

    try std.testing.expect(result.value == .contract);
    try output.check(result.value.contract.program, .pop);
}

test "RX rejects inline consumption of a list created in the same expression" {
    var parsed = try rx.parseXml(std.testing.allocator, "<Module><Return value={[1].pop()}/></Module>");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{},
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings("unsupported", result.value.diagnostic.code);
}
