const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const generated = @import("rx_options").generated_graph;

pub fn defaultTruth(allocator: std.mem.Allocator, owner: []const u8, cases: anytype) std.mem.Allocator.Error!?bool {
    var yes = false;
    var no = false;

    for (cases) |case| {
        const attribute = case.value orelse continue;
        var parsed = try @import("attribute.zig").parse(allocator, attribute, owner);

        defer parsed.deinit();

        const value = boolean(&parsed) orelse return null;
        yes = yes or value;
        no = no or !value;
    }

    return if (yes != no) !yes else null;
}

pub fn boolean(parsed: *const frontend.ExpressionInput.Result) ?bool {
    if (parsed.diagnostic() != null) return null;

    return switch (parsed.*) {
        .native => |result| if (result.value.parsed.expression.value == .boolean) result.value.parsed.expression.value.boolean else null,
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) block: {
            const node = result.output.expressions.nodes[@intCast(result.output.result)];

            break :block if (node.kind == .Boolean) node.flag else null;
        } else unreachable,
    };
}

pub fn assumeParsed(allocator: std.mem.Allocator, parsed: *const frontend.ExpressionInput.Result, present: bool, context: anytype) zx.Error!void {
    switch (parsed.*) {
        .native => |result| try assumeNative(result.value.parsed.expression, present, context),
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) {
            const node = result.output.expressions.nodes[@intCast(result.output.result)];

            if (node.kind != .Binary and node.kind != .Unary) return;

            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const view = try result.view(scratch.allocator());

            try assumeValue(scratch.allocator(), view.expression(result.output.result), present, context);
        } else unreachable,
    }
}

pub fn assumeValue(allocator: std.mem.Allocator, expression: anytype, present: bool, context: anytype) zx.Error!void {
    if (comptime !generated or @TypeOf(expression) == *const zx.ast.Expression) return assumeNative(expression, present, context);

    const view = expression.context;
    const nodes = view.storage.expressions.nodes;
    const node = nodes[expression.index];

    if (node.kind != .Binary and node.kind != .Unary) return;

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [std.heap.page_size_min / 16]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const facts = @import("generated_rx_condition_plan").executeValue(scratch.allocator(), .{
        .nodes = nodes,
        .condition = expression.index,
        .truth = present,
        .facts = .{ .first = null, .rest = &.{} },
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (facts.first) |first| try context.assumeNonNull(view.expression(first));
    for (facts.rest) |index| try context.assumeNonNull(view.expression(index));
}

fn assumeNative(expression: anytype, present: bool, context: anytype) zx.Error!void {
    const value = syntax.value(expression);

    if (value == .unary and value.unary.operator == .not) return assumeNative(value.unary.operand, !present, context);
    if (value != .binary) return;

    const binary = value.binary;

    if ((binary.operator == .logical_and and present) or (binary.operator == .logical_or and !present)) {
        try assumeNative(binary.left, present, context);
        try assumeNative(binary.right, present, context);

        return;
    }

    if (binary.operator != .equal and binary.operator != .not_equal) return;
    if ((binary.operator == .not_equal) != present) return;

    if (syntax.value(binary.left) == .null_value) {
        try context.assumeNonNull(binary.right);
    } else if (syntax.value(binary.right) == .null_value) {
        try context.assumeNonNull(binary.left);
    }
}
