const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Header = struct { has_store: bool, contracts: []const ast.Contract };
const Exports = struct { declarations: []const ast.Declaration, constants: []const ast.Constant };
const Function = grammar.sequence(.{ grammar.token("export"), grammar.token("default"), grammar.required(grammar.token("function"), "expected function"), grammar.reference(Header, header), grammar.reference(ast.Block, Parser.block) });

const File = grammar.sequence(.{
    grammar.many(@import("parser_imports.zig").Import),
    grammar.reference(Exports, exports),
    grammar.optional(Function),
});

pub fn parse(parser: *Parser) zx.Error!ast.Program {
    const values = try grammar.run(File, parser, "expected a ZX file");

    if (parser.current().kind != .eof) return parser.reporter.fail(.contract, parser.current().span, "imports and types must precede the single anonymous default function");
    if (values[2]) |function| return .{ .imports = values[0], .declarations = values[1].declarations, .constants = values[1].constants, .function_start = function[0].span.start, .body = function[4], .has_store = function[3].has_store, .contracts = function[3].contracts };
    if (values[1].declarations.len == 0 and values[1].constants.len == 0) return parser.reporter.fail(.contract, parser.current().span, "a pure type file must export at least one type or enum");

    return .{ .imports = values[0], .declarations = values[1].declarations, .constants = values[1].constants, .function_start = parser.source.len, .body = null };
}

fn exports(parser: *Parser) zx.Error!Exports {
    var declarations: std.ArrayList(ast.Declaration) = .empty;
    var constants: std.ArrayList(ast.Constant) = .empty;

    while (parser.at("export") and parser.index + 1 < parser.tokens.len) {
        const kind = parser.tokens[parser.index + 1].text(parser.source);

        if (std.mem.eql(u8, kind, "type") or std.mem.eql(u8, kind, "enum")) {
            try declarations.append(parser.allocator, try grammar.run(@import("parser_declarations.zig").Declaration, parser, "expected a type or enum declaration"));
        } else if (std.mem.eql(u8, kind, "const")) {
            try constants.append(parser.allocator, try @import("parser_constants.zig").parse(parser));
        } else break;
    }

    return .{ .declarations = try declarations.toOwnedSlice(parser.allocator), .constants = try constants.toOwnedSlice(parser.allocator) };
}

fn header(parser: *Parser) zx.Error!Header {
    try parser.expect("(");
    try parser.expect("in");
    try parser.expect(":");
    try parser.expect("Input");

    var has_store = false;

    if (parser.take(",") and !parser.at(")")) {
        try parser.expect("{");
        try parser.expect("store");
        try parser.expect("}");

        has_store = true;
        _ = parser.take(",");
    }

    try parser.expect(")");
    try parser.expect(":");
    try parser.expect("Output");

    return .{ .has_store = has_store, .contracts = try @import("parser_contracts.zig").parse(parser) };
}
