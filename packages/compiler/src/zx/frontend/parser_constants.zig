const zx = @import("zx");
const Parser = @import("parser.zig");

pub fn parse(parser: *Parser) zx.Error!zx.ast.Constant {
    const start = parser.current().span.start;

    try parser.expect("export");
    try parser.expect("const");

    const name = try parser.name();

    try parser.expect(":");

    const annotation = try parser.typeNode();

    try parser.expect("=");

    const value = try parser.expression(0);

    try parser.endStatement();

    return .{ .name = name, .annotation = annotation, .value = value, .span = parser.range(start) };
}
