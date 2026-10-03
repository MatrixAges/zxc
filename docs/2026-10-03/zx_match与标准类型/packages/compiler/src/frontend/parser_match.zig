const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const expressions = @import("parser_expressions.zig");

pub fn parse(parser: *Parser, start: usize) zx.Error!*const zx.ast.Expression {
    const subject = if (parser.at("{")) null else try expressions.parse(parser, 0);

    try parser.expect("{");

    var arms: std.ArrayList(zx.ast.MatchArm) = .empty;

    while (!parser.at("}")) {
        if (parser.take("_")) {
            try parser.expect("=>");

            const fallback = try expressions.parse(parser, 0);
            _ = parser.take(",");

            try parser.expect("}");

            return parser.make(start, .{ .match_expr = .{ .subject = subject, .arms = try arms.toOwnedSlice(parser.allocator), .fallback = fallback } });
        }

        const condition = try expressions.pattern(parser);

        try parser.expect("=>");

        const result = try expressions.parse(parser, 0);

        try arms.append(parser.allocator, .{ .condition = condition, .result = result });
        try parser.expect(",");
    }

    return parser.reporter.fail(.syntax, parser.current().span, "match requires a final _ => result branch");
}
