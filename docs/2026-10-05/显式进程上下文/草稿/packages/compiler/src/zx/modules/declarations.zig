const std = @import("std");
const zx = @import("zx");
const Parser = @import("../frontend/parser.zig");
const naming = @import("lint");
pub const Function = struct { name: zx.ast.Name, parameters: []const *const zx.ast.Type, output: *const zx.ast.Type, allocator_argument: bool, io_argument: bool, process_argument: bool, fallible: bool };
pub const Program = struct { types: []const zx.ast.Declaration, functions: []const Function };

pub fn parse(allocator: std.mem.Allocator, source: []const u8, reporter: *zx.Reporter) zx.Error!Program {
    const lexed = try @import("../frontend/lex.zig").lex(allocator, source, reporter);
    var parser = Parser{ .allocator = allocator, .source = source, .tokens = lexed.tokens, .reporter = reporter };
    var types: std.ArrayList(zx.ast.Declaration) = .empty;
    var functions: std.ArrayList(Function) = .empty;

    while (parser.current().kind != .eof) {
        const declaration = try @import("../frontend/parser_declarations.zig").Declaration.parse(&parser);

        if (declaration == .hit) {
            if (functions.items.len != 0) return reporter.fail(.contract, declaration.hit.span, "interface types must precede function declarations");
            if (!naming.checkName(declaration.hit.name.text, .type_decl)) return reporter.fail(.naming, declaration.hit.name.span, "type names must use PascalCase");
            try types.append(allocator, declaration.hit);

            continue;
        }

        try parser.expect("export");
        try parser.expect("declare");
        try parser.expect("function");

        const name = try parser.name();

        if (!naming.checkName(name.text, .callable)) return reporter.fail(.naming, name.span, "function names must use camelCase");

        for (functions.items) |previous| {
            if (std.mem.eql(u8, previous.name.text, name.text)) return reporter.fail(.name, name.span, "duplicate native function declaration");
        }

        try parser.expect("(");

        const allocating = injected(&parser, "allocator");

        if (allocating and !parser.at(")")) try parser.expect(",");

        const uses_io = injected(&parser, "io");
        var parameters: std.ArrayList(*const zx.ast.Type) = .empty;
        var names: std.StringHashMapUnmanaged(void) = .empty;

        if (uses_io and !parser.at(")")) try parser.expect(",");

        const uses_process = injected(&parser, "process");

        if (uses_process and !parser.at(")")) try parser.expect(",");

        while (!parser.at(")")) {
            const parameter = try parser.name();

            if (!naming.checkName(parameter.text, .value)) return reporter.fail(.naming, parameter.span, "parameter names must use snake_case");

            const entry = try names.getOrPut(allocator, parameter.text);

            if (entry.found_existing) return reporter.fail(.name, parameter.span, "duplicate native parameter name");

            try parser.expect(":");
            try parameters.append(allocator, try parser.typeNode());
            if (!parser.take(",")) break;
        }

        try parser.expect(")");
        try parser.expect(":");

        const output = try parser.typeNode();
        const fallible = parser.take("throws");

        try parser.endStatement();
        try functions.append(allocator, .{ .name = name, .parameters = parameters.items, .output = output, .allocator_argument = allocating, .io_argument = uses_io, .process_argument = uses_process, .fallible = fallible });
    }

    if (types.items.len == 0 and functions.items.len == 0) return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "native interfaces must export types or functions");

    return .{ .types = types.items, .functions = functions.items };
}

fn injected(parser: *Parser, name: []const u8) bool {
    if (!parser.at(name)) return false;

    const next = parser.tokens[parser.index + 1].text(parser.source);

    if (!std.mem.eql(u8, next, ",") and !std.mem.eql(u8, next, ")")) return false;

    parser.index += 1;

    return true;
}
