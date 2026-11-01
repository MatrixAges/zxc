const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const ast = zx.ast;
const grammar = @import("combinators.zig");
const Header = struct { has_store: bool, contracts: []const ast.Contract };
const Exports = struct { imports: []const ast.Import, declarations: []const ast.Declaration, constants: []const ast.Constant };
const Function = grammar.sequence(.{ grammar.token("export"), grammar.token("default"), grammar.required(grammar.token("function"), "expected function"), grammar.reference(Header, header), grammar.reference(ast.Block, Parser.block) });

pub fn parse(parser: *Parser) zx.Error!ast.Program {
    const prefix = try exports(parser);
    const function = try grammar.run(grammar.optional(Function), parser, "expected a ZX file");

    if (parser.current().kind != .eof) return parser.reporter.fail(.contract, parser.current().span, "imports and types must precede the single anonymous default function");
    if (function) |value| return .{ .imports = prefix.imports, .declarations = prefix.declarations, .constants = prefix.constants, .function_start = value[0].span.start, .body = value[4], .has_store = value[3].has_store, .contracts = value[3].contracts };

    var reexports = false;

    for (prefix.imports) |item| reexports = reexports or item.exported;
    if (prefix.declarations.len == 0 and prefix.constants.len == 0 and !reexports) return parser.reporter.fail(.contract, parser.current().span, "a pure type file must export at least one type or enum");

    return .{ .imports = prefix.imports, .declarations = prefix.declarations, .constants = prefix.constants, .function_start = parser.source.len, .body = null };
}

fn exports(parser: *Parser) zx.Error!Exports {
    var imports: std.ArrayList(ast.Import) = .empty;
    var declarations: std.ArrayList(ast.Declaration) = .empty;
    var constants: std.ArrayList(ast.Constant) = .empty;

    while (parser.index + 1 < parser.tokens.len) {
        if (parser.at("import")) {
            try imports.append(parser.allocator, try @import("parser_imports.zig").parse(parser));

            continue;
        }

        if (!parser.at("export")) break;

        const kind = parser.tokens[parser.index + 1].text(parser.source);
        const type_reexport = std.mem.eql(u8, kind, "type") and parser.index + 2 < parser.tokens.len and (std.mem.eql(u8, parser.tokens[parser.index + 2].text(parser.source), "{") or std.mem.eql(u8, parser.tokens[parser.index + 2].text(parser.source), "*"));

        if (type_reexport or std.mem.eql(u8, kind, "{") or std.mem.eql(u8, kind, "*")) {
            try imports.append(parser.allocator, try @import("parser_imports.zig").parse(parser));
        } else if (std.mem.eql(u8, kind, "type") or std.mem.eql(u8, kind, "enum")) {
            try declarations.append(parser.allocator, try grammar.run(@import("parser_declarations.zig").Declaration, parser, "expected a type or enum declaration"));
        } else if (std.mem.eql(u8, kind, "const")) {
            try constants.append(parser.allocator, try @import("parser_constants.zig").parse(parser));
        } else break;
    }

    return .{ .imports = try imports.toOwnedSlice(parser.allocator), .declarations = try declarations.toOwnedSlice(parser.allocator), .constants = try constants.toOwnedSlice(parser.allocator) };
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
