const std = @import("std");
const dsl = @import("dsl");
const Role = if (@import("rx_options").generated_rules) @import("generated_attribute_role").Output else enum { Static, Value, Expression };

pub fn value(element: []const u8, attribute: []const u8) bool {
    return role(element, attribute) == .Value;
}

fn nativeValue(element: []const u8, attribute: []const u8) bool {
    if (std.mem.eql(u8, element, "Call")) return std.mem.eql(u8, attribute, "in");
    if (std.mem.eql(u8, element, "Switch")) return std.mem.eql(u8, attribute, "on");

    inline for (.{ "Return", "Case", "Emit", "Field" }) |tag| {
        if (std.mem.eql(u8, element, tag)) return std.mem.eql(u8, attribute, "value");
    }

    return false;
}

pub fn validate(node: dsl.ast.Node, reporter: *dsl.Reporter) dsl.Error!void {
    for (node.attributes) |attribute| {
        const selected = role(node.name, attribute.name);

        if (selected == .Value) continue;

        const expression = selected == .Expression;

        if ((attribute.kind == .expression) != expression) return reporter.fail(.{
            .code = .invalid_attribute,
            .location = attribute.value_location,
            .element = node.name,
            .attribute = attribute.name,
            .message = if (expression) "This attribute requires a braced expression" else "This attribute requires a quoted static string",
        });
    }
}

fn role(element: []const u8, attribute: []const u8) Role {
    if (@import("rx_options").generated_rules) return @import("schema/scalar.zig").execute(@import("generated_attribute_role"), &.{ .element = element, .attribute = attribute });
    if (nativeValue(element, attribute)) return .Value;

    const expression = (std.mem.eql(u8, element, "Task") and std.mem.eql(u8, attribute, "out")) or
        (std.mem.eql(u8, element, "Call") and std.mem.eql(u8, attribute, "setter")) or
        (std.mem.eql(u8, element, "Store") and std.mem.eql(u8, attribute, "version")) or
        (std.mem.eql(u8, element, "Gateway") and (std.mem.eql(u8, attribute, "max_header_bytes") or std.mem.eql(u8, attribute, "max_body_bytes")));

    return if (expression) .Expression else .Static;
}
