const std = @import("std");
const Self = @This();

expressions: []const usize,
blocks: []const usize,
statements: []const usize,
edges: []const usize,
pub fn create(allocator: std.mem.Allocator, storage: anytype) std.mem.Allocator.Error!Self {
    var count: usize = 0;

    for (storage.expressions.nodes) |node| count = std.math.add(usize, count, expressionCount(node)) catch return error.OutOfMemory;
    for (storage.blocks.blocks) |node| count = std.math.add(usize, count, @intCast(node.count)) catch return error.OutOfMemory;
    for (storage.blocks.statements) |node| count = std.math.add(usize, count, statementCount(node)) catch return error.OutOfMemory;

    const edges = try allocator.alloc(usize, count);
    const expressions = try allocator.alloc(usize, storage.expressions.nodes.len);
    const blocks = try allocator.alloc(usize, storage.blocks.blocks.len);
    const statements = try allocator.alloc(usize, storage.blocks.statements.len);
    var offset: usize = 0;

    for (storage.expressions.nodes, expressions) |node, *first| {
        first.* = offset;

        const length = expressionCount(node);
        const target = edges[offset..][0..length];

        switch (node.kind) {
            .List, .Call => fill(target, node.head, storage.expressions.items),
            .Object => fill(target, node.head, storage.expressions.fields),
            .Lambda => fill(target, node.head, storage.expressions.parameters),
            .Template => fill(target, node.head, storage.expressions.parts),
            .Match => fill(target, node.head, storage.expressions.arms),
            else => {},
        }

        offset += length;
    }

    for (storage.blocks.blocks, blocks) |node, *first| {
        first.* = offset;

        const length: usize = @intCast(node.count);

        fill(edges[offset..][0..length], node.head, storage.blocks.items);

        offset += length;
    }

    for (storage.blocks.statements, statements) |node, *first| {
        first.* = offset;

        const length = statementCount(node);
        const target = edges[offset..][0..length];

        switch (node.kind) {
            .Destructure => fill(target, node.head, storage.blocks.names),
            .Switch => fill(target, node.head, storage.blocks.cases),
            else => {},
        }

        offset += length;
    }

    return .{ .expressions = expressions, .blocks = blocks, .statements = statements, .edges = edges };
}

fn fill(target: []usize, head: u64, edges: anytype) void {
    var next = head;
    var remaining = target.len;

    while (remaining != 0) {
        remaining -= 1;
        const index: usize = @intCast(next - 1);
        target[remaining] = index;
        next = edges[index].previous;
    }
}

fn expressionCount(node: anytype) usize {
    return switch (node.kind) {
        .List, .Call, .Object, .Lambda, .Template, .Match => @intCast(node.count),
        else => 0,
    };
}

fn statementCount(node: anytype) usize {
    return switch (node.kind) {
        .Destructure, .Switch => @intCast(node.count),
        else => 0,
    };
}
