const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const policy = @import("condition_policy");

pub fn condition(source: ?[]const u8, expression: anytype) bool {
    const text = source orelse return false;

    if (!expression.condition_list or expression.span.start >= text.len or text[expression.span.start] != '-') return false;

    const start = std.mem.lastIndexOfScalar(u8, text[0..expression.span.start], '\n');
    const prefix = text[if (start) |offset| offset + 1 else 0..expression.span.start];

    return std.mem.trim(u8, prefix, " \t\r").len == 0;
}

pub fn item(source: []const u8, expression: anytype, nested: bool) ?zx.Diagnostic {
    const text = source[expression.span.start..expression.span.end];
    const multiline = std.mem.indexOfAny(u8, text, "\r\n") != null;
    const width = std.unicode.utf8CountCodepoints(text) catch text.len;
    const message = policy.checkItem(expression.condition_terms, width, multiline, nested) orelse return null;

    return .{ .code = .style, .span = expression.span, .message = message };
}

pub fn pipeline(source: ?[]const u8, expression: anytype) ?zx.Diagnostic {
    var cursor = expression;
    var steps: u64 = 0;

    while (syntax.value(cursor) == .pipeline) {
        steps += 1;
        cursor = syntax.value(cursor).pipeline.input;
    }

    if (policy.checkPipeline(steps, 0, false)) |message| return .{ .code = .style, .span = expression.span, .message = message };

    const text = source orelse return null;

    cursor = expression;

    while (syntax.value(cursor) == .pipeline) {
        if (part(text, syntax.value(cursor).pipeline.stage, steps)) |issue| return issue;

        cursor = syntax.value(cursor).pipeline.input;
    }

    return part(text, cursor, steps);
}

fn part(source: []const u8, expression: anytype, steps: u64) ?zx.Diagnostic {
    const text = source[expression.span.start..expression.span.end];
    const width = std.unicode.utf8CountCodepoints(text) catch text.len;
    const message = policy.checkPipeline(steps, width, std.mem.indexOfAny(u8, text, "\r\n") != null) orelse return null;

    return .{ .code = .style, .span = expression.span, .message = message };
}

pub fn ternary(source: ?[]const u8, expression: anytype) ?zx.Diagnostic {
    const value = syntax.value(expression).conditional;
    const multiline = if (source) |text| std.mem.indexOfAny(u8, text[expression.span.start..expression.span.end], "\r\n") != null else false;
    const complex = !simple(value.condition) or !simple(value.yes) or !simple(value.no);
    const message = policy.checkTernary(multiline, complex) orelse return null;

    return .{ .code = .style, .span = expression.span, .message = message };
}

fn simple(expression: anytype) bool {
    return switch (syntax.value(expression)) {
        .identifier, .number, .string, .boolean, .null_value => true,
        .field => |value| simple(value.target),
        .index => |value| simple(value.target) and simple(value.index),
        .unary => |value| simple(value.operand),
        .binary => |value| simple(value.left) and simple(value.right),
        .call => |value| result: {
            if (!simpleValue(value.callee)) break :result false;

            for (0..value.arguments.len) |index| {
                const argument = syntax.item(value.arguments, index);

                if (!simpleValue(argument)) break :result false;
            }

            break :result true;
        },
        else => false,
    };
}

fn simpleValue(expression: anytype) bool {
    return switch (syntax.value(expression)) {
        .identifier, .number, .string, .boolean, .null_value => true,
        .field => |value| simpleValue(value.target),
        .index => |value| simpleValue(value.target) and simpleValue(value.index),
        .unary => |value| simpleValue(value.operand),
        .binary => |value| simpleValue(value.left) and simpleValue(value.right),
        else => false,
    };
}
