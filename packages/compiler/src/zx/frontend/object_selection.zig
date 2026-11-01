const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;

pub fn name(value: []const u8) bool {
    return std.mem.eql(u8, value, "pick") or std.mem.eql(u8, value, "omit");
}

pub fn matches(expression: anytype) bool {
    const value = syntax.value(expression);

    if (value != .call) return false;

    const callee = syntax.value(value.call.callee);

    return callee == .field and name(callee.field.name.text);
}

pub fn validate(expression: anytype) ?zx.Diagnostic {
    const call = syntax.value(expression).call;

    if (call.type_argument != null or call.arguments.len != 1) return issue(expression.span, "object selection requires one static field array");

    const argument = syntax.item(call.arguments, 0);
    const value = syntax.value(argument);

    if (value != .list) return issue(argument.span, "object selection fields must be a string literal array");

    for (0..value.list.len) |index| {
        const key = syntax.item(value.list, index);

        if (syntax.value(key) != .string) return issue(key.span, "object selection fields must be string literals");
    }

    return null;
}

pub fn keys(allocator: std.mem.Allocator, expression: anytype, reporter: *zx.Reporter) zx.Error![]const []const u8 {
    if (validate(expression)) |diagnostic| return reporter.fail(diagnostic.code, diagnostic.span, diagnostic.message);

    const values = syntax.value(syntax.item(syntax.value(expression).call.arguments, 0)).list;
    const result = try allocator.alloc([]const u8, values.len);

    for (result, 0..) |*key, index| {
        const source = syntax.item(values, index);
        const text = syntax.value(source).string;

        key.* = try @import("string_literal.zig").decode(allocator, text[1 .. text.len - 1]);

        for (result[0..index]) |previous| {
            if (std.mem.eql(u8, previous, key.*)) return reporter.fail(.name, source.span, "duplicate object selection field");
        }
    }

    return result;
}

fn issue(span: zx.Span, message: []const u8) zx.Diagnostic {
    return .{ .code = .type_mismatch, .span = span, .message = message };
}
