const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const output = @import("output.zig");

fn check(source: []const u8, expected: output.Shape) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
            .{ .path = "pop_values.zx", .source = @import("rx_collection_fixtures").pop_values },
            .{ .path = "pop_other.zx", .source = @import("rx_collection_fixtures").pop_values },
            .{ .path = "make.zx", .source = @embedFile("fixtures/make.zx") },
            .{ .path = "make_other.zx", .source = @embedFile("fixtures/make.zx") },
            .{ .path = "borrow.zx", .source = @embedFile("fixtures/borrowed.zx") },
        },
    });

    defer result.deinit();

    try std.testing.expect(result.value == .contract);
    try output.check(result.value.contract.program, expected);
}

test "RX immutable pop reads independent results" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='make_other' in={$in}/><Call fn='pop_values' in={$ctx.make}/><Call fn='pop_other' in={$ctx.make_other}/><Return value={{left: $ctx.pop_values, right: $ctx.pop_other}}/></Module>", .{ .fields = &.{ .{ .name = "left", .kind = .pop }, .{ .name = "right", .kind = .pop } } });
}

test "RX immutable pop can read the same result twice" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='pop_values' in={$ctx.make}/><Call fn='pop_other' in={$ctx.make}/><Return value={{first: $ctx.pop_values, second: $ctx.pop_other}}/></Module>", .{ .fields = &.{ .{ .name = "first", .kind = .pop }, .{ .name = "second", .kind = .pop } } });
}

test "RX immutable pop can read the module input" {
    try check("<Module><Call fn='borrow' in={$in}/><Call fn='pop_values' in={$in}/><Return value={$ctx.pop_values}/></Module>", .pop);
}

test "RX immutable pop preserves a published alias" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='borrow' in={$ctx.make}/><Call fn='pop_values' in={$ctx.make}/><Return value={{changed: $ctx.pop_values, alias: $ctx.borrow}}/></Module>", .{ .fields = &.{ .{ .name = "alias", .kind = .list }, .{ .name = "changed", .kind = .pop } } });
}
