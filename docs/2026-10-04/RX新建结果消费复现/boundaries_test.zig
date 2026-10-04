const std = @import("std");
const rx = @import("rx");
const analysis = @import("analysis");

fn check(source: []const u8, accepted: bool) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
            .{ .path = "make.zx", .source = @embedFile("make.zx") },
            .{ .path = "borrow.zx", .source = @embedFile("borrowed.zx") },
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
    try check("<Module><Call fn='make' in='$in' out='ctx.left'/><Call fn='make' in='$in' out='ctx.right'/><Return value='{left: ctx.left.pop(), right: ctx.right.pop()}'/></Module>", true);
}

test "RX rejects consuming the same result twice" {
    try check("<Module><Call fn='make' in='$in' out='ctx.items'/><Return value='{first: ctx.items.pop(), second: ctx.items.pop()}'/></Module>", false);
}

test "RX rejects consuming the module input" {
    try check("<Module><Call fn='borrow' in='$in'/><Return value='$in.pop()'/></Module>", false);
}

test "RX rejects consuming an owner after publishing a borrowed alias" {
    try check("<Module><Call fn='make' in='$in' out='ctx.items'/><Call fn='borrow' in='ctx.items' out='ctx.alias'/><Return value='{changed: ctx.items.pop(), alias: ctx.alias}'/></Module>", false);
}
