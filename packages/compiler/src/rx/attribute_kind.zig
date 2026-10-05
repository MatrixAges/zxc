const std = @import("std");
const dsl = @import("dsl");

pub fn value(element: []const u8, attribute: []const u8) bool {
    if (std.mem.eql(u8, element, "Call")) return std.mem.eql(u8, attribute, "args");
    if (std.mem.eql(u8, element, "Switch")) return std.mem.eql(u8, attribute, "on");

    inline for (.{ "Return", "Case", "Emit", "Field" }) |tag| {
        if (std.mem.eql(u8, element, tag)) return std.mem.eql(u8, attribute, "value");
    }

    return false;
}

pub fn validate(node: dsl.ast.Node, reporter: *dsl.Reporter) dsl.Error!void {
    for (node.attributes) |attribute| {
        if (value(node.name, attribute.name)) continue;

        const expression = (std.mem.eql(u8, node.name, "Call") and std.mem.eql(u8, attribute.name, "setter")) or
            (std.mem.eql(u8, node.name, "Store") and std.mem.eql(u8, attribute.name, "version")) or
            (std.mem.eql(u8, node.name, "Gateway") and (std.mem.eql(u8, attribute.name, "max_header_bytes") or std.mem.eql(u8, attribute.name, "max_body_bytes")));

        if ((attribute.kind == .expression) != expression) return reporter.fail(.{
            .code = .invalid_attribute,
            .location = attribute.value_location,
            .element = node.name,
            .attribute = attribute.name,
            .message = if (expression) "This attribute requires a braced expression" else "This attribute requires a quoted static string",
        });
    }
}
