const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");

pub fn parse(allocator: std.mem.Allocator, attribute: rx.ast.Attribute, owner: []const u8) std.mem.Allocator.Error!frontend.ExpressionParseResult {
    return switch (attribute.kind) {
        .string => frontend.stringExpression(allocator, attribute.value, owner),
        .expression => frontend.parseExpression(allocator, attribute.value, owner),
    };
}
