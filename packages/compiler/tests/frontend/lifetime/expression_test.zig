const std = @import("std");
const compiler = @import("compiler");
const allocations = @import("../../support/allocation_testing.zig");
const source = "/* owned comment */ render({ items: [3, 5], label: `outer-${match target { true => `inner-${value}`, _ => \"none\" }}` }, (item, index) => item[index] ?? 7)";

fn check(allocator: std.mem.Allocator) !void {
    var parsed = blk: {
        var caller = std.heap.ArenaAllocator.init(allocator);

        defer caller.deinit();

        const text = try caller.allocator().dupe(u8, source);
        const path = try caller.allocator().dupe(u8, "owned_expression.zx");
        const result = try compiler.parseExpression(allocator, text, path);

        @memset(text, 'x');
        @memset(path, 'x');

        break :blk result;
    };

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    const input = parsed.value.parsed;
    const call = input.expression.value.call;

    try std.testing.expectEqualStrings(source, input.source);
    try std.testing.expectEqualStrings("owned_expression.zx", input.file_name);
    try std.testing.expectEqualStrings("render", input.lexed.tokens[0].text(input.source));
    try std.testing.expectEqual(@as(usize, 1), input.lexed.comments.len);

    const comment = input.lexed.comments[0];

    try std.testing.expectEqualStrings("/* owned comment */", input.source[comment.start..comment.end]);
    try std.testing.expectEqualStrings("render", call.callee.value.identifier.text);
    try std.testing.expectEqual(@as(usize, 2), call.arguments.len);

    const fields = call.arguments[0].value.object;
    const list = fields[0].value.value.list;
    const parts = fields[1].value.value.template;
    const selection = parts[1].expression.value.match_expr;
    const nested = selection.arms[0].result.value.template;

    try std.testing.expectEqualStrings("items", fields[0].name.text);
    try std.testing.expectEqualStrings("3", list[0].value.number);
    try std.testing.expectEqualStrings("5", list[1].value.number);
    try std.testing.expectEqualStrings("label", fields[1].name.text);
    try std.testing.expectEqualStrings("outer-", parts[0].text);
    try std.testing.expectEqualStrings("target", selection.subject.?.value.identifier.text);
    try std.testing.expect(selection.arms[0].condition.value.boolean);
    try std.testing.expectEqualStrings("inner-", nested[0].text);
    try std.testing.expectEqualStrings("value", nested[1].expression.value.identifier.text);
    try std.testing.expectEqualStrings("\"none\"", selection.fallback.value.string);

    const lambda = call.arguments[1].value.lambda;
    const binary = lambda.body.value.binary;
    const index = binary.left.value.index;

    try std.testing.expectEqualStrings("item", lambda.parameters[0].text);
    try std.testing.expectEqualStrings("index", lambda.parameters[1].text);
    try std.testing.expectEqualStrings("item", index.target.value.identifier.text);
    try std.testing.expectEqualStrings("index", index.index.value.identifier.text);
    try std.testing.expectEqualStrings("7", binary.right.value.number);

    const span = nested[1].expression.span;

    try std.testing.expectEqualStrings("value", input.source[span.start..span.end]);
}

test "public expression AST outlives caller source and file name buffers" {
    try check(std.testing.allocator);
}

test "public expression AST ownership releases every allocation failure" {
    try allocations.checkAllAllocationFailures(std.testing.allocator, check, .{});
}
