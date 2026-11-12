const std = @import("std");
const dsl = @import("dsl");
const Role = if (@import("rx_options").generated_rules) @import("generated_attribute_role").Output else enum { Static, Value, Expression, Type };

pub fn typeValue(element: []const u8, attribute: []const u8) bool {
    return role(element, attribute) == .Type;
}

fn nativeValue(element: []const u8, attribute: []const u8) bool {
    if (std.mem.eql(u8, element, "Call")) return std.mem.eql(u8, attribute, "in");
    if (std.mem.eql(u8, element, "Switch")) return std.mem.eql(u8, attribute, "on");

    inline for (.{ "Return", "Case", "Emit", "Field" }) |tag| {
        if (std.mem.eql(u8, element, tag)) return std.mem.eql(u8, attribute, "value");
    }

    return false;
}

pub fn validate(input: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const node = dsl.ast.view(input);

    for (0..node.attributeCount()) |index| {
        _ = try check(node.name(), node.schemaAttribute(index), reporter);
    }
}

pub fn check(element: []const u8, attribute: dsl.ast.Attribute, reporter: *dsl.Reporter) dsl.Error!Role {
    const selected = role(element, attribute.name);

    if (selected == .Value) return selected;

    const expression = selected == .Expression or selected == .Type;

    if ((attribute.kind == .expression) != expression) return reporter.fail(.{
        .code = .invalid_attribute,
        .location = attribute.value_location,
        .element = element,
        .attribute = attribute.name,
        .message = if (expression) "This attribute requires a braced expression" else "This attribute requires a quoted static string",
    });

    return selected;
}

fn role(element: []const u8, attribute: []const u8) Role {
    if (@import("rx_options").generated_rules) return @import("schema/scalar.zig").execute(@import("generated_attribute_role"), &.{ .element = element, .attribute = attribute });
    if (nativeValue(element, attribute)) return .Value;
    if (std.mem.eql(u8, element, "Field") and std.mem.eql(u8, attribute, "type")) return .Type;
    if (std.mem.eql(u8, element, "Args") and (std.mem.eql(u8, attribute, "in") or std.mem.eql(u8, attribute, "out"))) return .Type;

    const expression = (std.mem.eql(u8, element, "Task") and std.mem.eql(u8, attribute, "out")) or
        (std.mem.eql(u8, element, "If") and std.mem.eql(u8, attribute, "on")) or
        (std.mem.eql(u8, element, "Call") and std.mem.eql(u8, attribute, "setter")) or
        (std.mem.eql(u8, element, "Store") and std.mem.eql(u8, attribute, "version")) or
        (std.mem.eql(u8, element, "Gateway") and (std.mem.eql(u8, attribute, "max_header_bytes") or std.mem.eql(u8, attribute, "max_body_bytes")));

    return if (expression) .Expression else .Static;
}
