const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");

fn check(source: []const u8, accepted: bool) !void {
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

    if (accepted) {
        if (result.value == .diagnostic) std.debug.print("owned boundary diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
        try std.testing.expect(result.value == .contract);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings("ownership", result.value.diagnostic.code);
    }
}

test "RX consumes two distinct owned results independently" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='make_other' in={$in}/><Call fn='pop_values' in={$ctx.make}/><Call fn='pop_other' in={$ctx.make_other}/><Return value={{left: $ctx.pop_values, right: $ctx.pop_other}}/></Module>", true);
}

test "RX rejects consuming the same result twice" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='pop_values' in={$ctx.make}/><Call fn='pop_other' in={$ctx.make}/><Return value={{first: $ctx.pop_values, second: $ctx.pop_other}}/></Module>", false);
}

test "RX rejects consuming the module input" {
    try check("<Module><Call fn='borrow' in={$in}/><Call fn='pop_values' in={$in}/><Return value={$ctx.pop_values}/></Module>", false);
}

test "RX rejects consuming an owner after publishing a borrowed alias" {
    try check("<Module><Call fn='make' in={$in}/><Call fn='borrow' in={$ctx.make}/><Call fn='pop_values' in={$ctx.make}/><Return value={{changed: $ctx.pop_values, alias: $ctx.borrow}}/></Module>", false);
}
