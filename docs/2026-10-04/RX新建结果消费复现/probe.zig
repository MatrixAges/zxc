const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("analysis");

test "ZX consumes an owned function return" {
    var result = try compiler.analyzeProject(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
        .{ .path = "make.zx", .source = @embedFile("make.zx") },
    }, .{ .entry = "main.zx" });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("ZX diagnostic: {s}\n", .{result.value.diagnostic.message});

    try std.testing.expect(result.value == .ir);
}

test "RX consumes an owned function return" {
    var parsed = try rx.parseXml(std.testing.allocator, @embedFile("main.rx"));

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{.{ .path = "make.zx", .source = @embedFile("make.zx") }},
    });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("RX diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

    try std.testing.expect(result.value == .contract);
}

test "RX still rejects consuming a borrowed function return" {
    var parsed = try rx.parseXml(std.testing.allocator, @embedFile("main.rx"));

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{.{ .path = "make.zx", .source = @embedFile("borrowed.zx") }},
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings("ownership", result.value.diagnostic.code);
}

test "RX consumes a list created in the same expression" {
    var parsed = try rx.parseXml(std.testing.allocator, "<Module><Return value='[1].pop()'/></Module>");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{},
    });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("local owned diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

    try std.testing.expect(result.value == .contract);
}

comptime {
    _ = @import("boundaries_test.zig");
}
