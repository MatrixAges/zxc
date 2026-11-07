const std = @import("std");
const zx = @import("zx");
const ast = zx.ast;
const Parser = @import("parser.zig");
const grammar = @import("combinators.zig");

pub const Declaration = struct {
    pub const Value = @FieldType(ast.Statement, "value");

    pub fn parse(parser: *Parser) zx.Error!grammar.Match(Value) {
        if (!parser.at("{") and !parser.at("[")) return .miss;

        const pattern = try parsePattern(parser);

        try parser.expect("=");

        const value = try parser.expression(0);
        var names: std.ArrayList(ast.Name) = .empty;

        if (pattern.value == .sequence) {
            for (pattern.value.sequence) |item| {
                if (item == null) {
                    try names.append(parser.allocator, .{ .text = "_", .span = pattern.span });

                    continue;
                }

                if (item.?.value != .name) {
                    names.clearRetainingCapacity();

                    break;
                }

                try names.append(parser.allocator, item.?.value.name);
            }
        }

        return .{ .hit = .{ .destructure = .{ .names = try names.toOwnedSlice(parser.allocator), .pattern = pattern, .value = value } } };
    }
};

fn parsePattern(parser: *Parser) zx.Error!*const ast.BindingPattern {
    try parser.enter();

    defer parser.depth -= 1;
    const start = parser.current().span.start;

    const value: @FieldType(ast.BindingPattern, "value") = if (parser.take("{")) object: {
        var fields: std.ArrayList(ast.BindingField) = .empty;

        while (!parser.take("}")) {
            const token = parser.current();
            const key = try parser.property();
            const alias = parser.take(":");

            if (!alias and token.kind != .identifier) return parser.reporter.fail(.syntax, key.span, "keyword properties require a binding alias");

            const child = if (alias) try parsePattern(parser) else try named(parser, key);

            try fields.append(parser.allocator, .{ .key = key, .pattern = child });
            if (parser.take("}")) break;
            try parser.expect(",");
        }

        break :object .{ .object = try fields.toOwnedSlice(parser.allocator) };
    } else if (parser.take("[")) sequence: {
        var items: std.ArrayList(?*const ast.BindingPattern) = .empty;

        while (!parser.take("]")) {
            if (parser.take(",")) {
                try items.append(parser.allocator, null);

                continue;
            }

            try items.append(parser.allocator, try parsePattern(parser));
            if (parser.take("]")) break;
            try parser.expect(",");
        }

        break :sequence .{ .sequence = try items.toOwnedSlice(parser.allocator) };
    } else .{ .name = try parser.name() };

    const result = try parser.allocator.create(ast.BindingPattern);

    result.* = .{ .span = parser.range(start), .value = value };

    return result;
}

fn named(parser: *Parser, name: ast.Name) std.mem.Allocator.Error!*const ast.BindingPattern {
    const result = try parser.allocator.create(ast.BindingPattern);

    result.* = .{ .span = name.span, .value = .{ .name = name } };

    return result;
}
