const std = @import("std");
const zx = @import("zx");
const lint = @import("lint");
const syntax = zx.syntax.borrow;
const Projection = lint.layout.Projection;

pub fn native(allocator: std.mem.Allocator, parsed: @import("parse.zig").Parsed) std.mem.Allocator.Error!Projection {
    var result = try Projection.init(allocator, parsed.source, parsed.lexed.tokens, parsed.lexed.comments);

    for (parsed.ast.imports) |item| result.excludeRange(item.span);

    for (parsed.ast.declarations) |item| {
        result.boundary(item.span.start);

        if (item.value.* == .enumeration) result.multilineEnding(item.span.end);
    }

    for (parsed.ast.constants) |item| {
        result.boundary(item.span.start);
        expression(&result, item.value);
    }

    for (parsed.ast.contracts) |item| expression(&result, item.predicate);

    if (parsed.ast.body) |value| {
        result.boundary(parsed.ast.function_start);
        block(&result, value);
    }

    return result;
}

pub fn indexed(allocator: std.mem.Allocator, source: []const u8, output: anytype) std.mem.Allocator.Error!Projection {
    var result = try Projection.init(allocator, source, output.tokens, output.comments);

    for (output.imports) |item| result.excludeRange(zx.syntax.header.span(item.span));

    for (output.declarations) |item| {
        result.boundary(@intCast(item.span.start));

        if (item.enumeration) result.multilineEnding(@intCast(item.span.end));
    }

    for (output.constants) |item| result.boundary(@intCast(item.span.start));
    if (output.body != null) result.boundary(@intCast(output.function_start));
    for (output.blocks.blocks) |item| result.excludeStart(@intCast(item.span.start), true);

    for (output.blocks.statements) |item| {
        result.boundary(@intCast(item.span.start));

        if (item.kind == .Switch) result.excludeEnding(@intCast(item.span.end), true);
    }

    for (output.blocks.names) |item| {
        if (item.kind == .Object) result.excludeStart(@intCast(item.span.start), false);
    }

    var expression_index = output.expressions.nodes.len;

    while (expression_index > 0) {
        expression_index -= 1;
        const item = output.expressions.nodes[expression_index];

        if (item.condition_list) result.condition(zx.syntax.header.span(item.span));
        if (item.kind == .List) result.list(@intCast(item.span.start), @intCast(item.count));
        if (item.kind == .Match or item.kind == .Index) result.excludeEnding(@intCast(item.span.end), item.kind == .Index);
    }

    return result;
}

fn block(result: *Projection, value: anytype) void {
    result.excludeStart(value.span.start, true);

    for (0..value.statements.len) |index| {
        const statement = syntax.item(value.statements, index);

        result.boundary(statement.span.start);

        switch (statement.value) {
            .constant => |item| expression(result, item.value),
            .destructure => |item| {
                expression(result, item.value);

                if (item.pattern) |pattern| bindingPattern(result, pattern);
            },
            .result => |item| if (item) |child| expression(result, child),
            .evaluate => |item| expression(result, item),
            .state_update => |item| {
                expression(result, item.target);
                expression(result, item.value);
            },
            .store_set => |item| {
                expression(result, item.target);
                expression(result, item.value);
            },
            .branch => |item| {
                expression(result, item.condition);
                block(result, item.yes);
                if (item.no) |child| block(result, child);
            },
            .switch_stmt => |item| {
                result.excludeEnding(statement.span.end, true);
                expression(result, item.subject);

                for (0..item.cases.len) |row| {
                    const case = syntax.item(item.cases, row);

                    if (case.value) |child| expression(result, child);

                    block(result, case.body);
                }
            },
        }
    }
}

pub fn expression(result: *Projection, value: anytype) void {
    if (value.condition_list) result.condition(value.span);

    switch (syntax.value(value)) {
        .field => |item| expression(result, item.target),
        .index => |item| {
            result.excludeEnding(value.span.end, true);
            expression(result, item.target);
            expression(result, item.index);
        },
        .capture, .task, .await_task, .cancel_task => |item| expression(result, item),
        .unary => |item| expression(result, item.operand),
        .binary => |item| {
            expression(result, item.left);
            expression(result, item.right);
        },
        .conditional => |item| {
            expression(result, item.condition);
            expression(result, item.yes);
            expression(result, item.no);
        },
        .pipeline => |item| {
            expression(result, item.input);
            expression(result, item.stage);
        },
        .lambda => |item| expression(result, item.body),
        .state_block => |item| block(result, item),
        .list => |items| {
            result.list(value.span.start, items.len);

            for (0..items.len) |index| expression(result, syntax.item(items, index));
        },
        .object => |items| for (0..items.len) |index| expression(result, syntax.item(items, index).value),
        .call => |item| {
            expression(result, item.callee);

            for (0..item.arguments.len) |index| expression(result, syntax.item(item.arguments, index));
        },
        .match_expr => |item| {
            result.excludeEnding(value.span.end, false);

            if (item.subject) |child| expression(result, child);

            for (0..item.arms.len) |index| {
                const arm = syntax.item(item.arms, index);

                expression(result, arm.condition);
                expression(result, arm.result);
            }

            expression(result, item.fallback);
        },
        else => {},
    }
}

fn bindingPattern(result: *Projection, pattern: anytype) void {
    if (syntax.bindingKind(pattern) == .object) result.excludeStart(pattern.span.start, false);

    for (0..syntax.bindingCount(pattern)) |index| {
        if (syntax.bindingChild(pattern, index)) |child| bindingPattern(result, child);
    }
}
