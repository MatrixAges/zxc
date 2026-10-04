const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");

pub fn parse(parser: *Parser) zx.Error![]const zx.ast.Contract {
    var contracts: std.ArrayList(zx.ast.Contract) = .empty;
    var has_ensures = false;

    while (parser.at("requires") or parser.at("ensures")) {
        const start = parser.current().span.start;

        const kind: zx.syntax.ContractKind = if (parser.take("requires")) .requires else blk: {
            try parser.expect("ensures");

            break :blk .ensures;
        };

        if (kind == .requires and has_ensures) return parser.reporter.fail(.contract, parser.current().span, "requires clauses must precede ensures clauses");

        has_ensures = has_ensures or kind == .ensures;

        try parser.expect("(");

        const predicate = try parser.expression(0);

        try parser.expect(")");
        try contracts.append(parser.allocator, .{ .kind = kind, .predicate = predicate, .span = parser.range(start) });
    }

    return contracts.toOwnedSlice(parser.allocator);
}
