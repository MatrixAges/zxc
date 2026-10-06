const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;

pub fn options(parser: *Parser) zx.Error!*const ast.Expression {
    const start = parser.current().span.start;

    try parser.expect("{");

    var fields: std.ArrayList(ast.Field) = .empty;

    while (!parser.take("}")) {
        if (parser.take("...")) {
            const value = try parser.expression(0);

            try fields.append(parser.allocator, .{ .name = .{ .text = "", .span = value.span }, .value = value, .spread = true });
        } else {
            const token = parser.current();
            const condition = parser.take("while");
            const name = if (condition) ast.Name{ .text = token.text(parser.source), .span = token.span } else try parser.name();
            const updating = std.mem.eql(u8, name.text, "next") or std.mem.eql(u8, name.text, "do");

            const value = if (parser.take(":"))
                if (updating) try @import("parser_expressions.zig").stateCallback(parser) else try parser.expression(0)

            else value: {
                if (condition) try parser.expect(":");

                break :value try parser.make(name.span.start, .{ .identifier = name });
            };

            try fields.append(parser.allocator, .{ .name = name, .value = value });
        }

        if (!parser.take(",") and !parser.at("}")) try parser.expect(",");
    }

    return parser.make(start, .{ .object = try fields.toOwnedSlice(parser.allocator) });
}

pub fn body(parser: *Parser) zx.Error!*const ast.Expression {
    const start = parser.current().span.start;

    parser.state_block_depth += 1;
    defer parser.state_block_depth -= 1;
    const block = try parser.block();

    return parser.make(start, .{ .state_block = block });
}

pub fn statement(parser: *Parser) zx.Error!@FieldType(ast.Statement, "value") {
    const target = try parser.expression(8);
    var operator: ?zx.syntax.Operator = null;

    if (!parser.take("=")) {
        const candidate = zx.syntax.Operator.parse(parser.current().text(parser.source)) orelse {
            if (target.value != .call and target.value != .await_task and target.value != .cancel_task) return parser.reporter.fail(.syntax, target.span, "expected a state update, call, await or cancel");

            try parser.endStatement();

            return .{ .evaluate = target };
        };

        switch (candidate) {
            .add, .subtract, .multiply, .divide, .remainder => {},
            else => return parser.reporter.fail(.syntax, parser.current().span, "expected a state update or a standalone call"),
        }

        parser.index += 1;

        try parser.expect("=");

        operator = candidate;
    }

    const value = try parser.expression(0);

    try parser.endStatement();

    return .{ .state_update = .{ .target = target, .value = value, .operator = operator } };
}
