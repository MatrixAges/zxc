const std = @import("std");
const dsl = @import("dsl");

pub fn fail(node: dsl.ast.Node, key: []const u8, message: []const u8, reporter: *dsl.Reporter) dsl.Error {
    for (node.attributes) |item| {
        if (std.mem.eql(u8, item.name, key)) return reporter.fail(.{
            .code = .context,
            .location = item.value_location,
            .element = node.name,
            .attribute = key,
            .message = message,
        });
    }

    return reporter.fail(.{
        .code = .context,
        .location = node.location,
        .element = node.name,
        .attribute = key,
        .message = message,
    });
}

pub fn nonEmpty(node: dsl.ast.Node, reporter: *dsl.Reporter) dsl.Error!void {
    try @import("attribute_kind.zig").validate(node, reporter);

    for (node.attributes) |item| {
        if (item.kind == .string and @import("attribute_kind.zig").value(node.name, item.name)) continue;

        if (std.mem.trim(u8, item.value, " \t\r\n").len == 0) {
            return fail(node, item.name, "RX attribute must not be empty", reporter);
        }
    }
}

pub fn attribute(node: dsl.ast.Node, name: []const u8) ?[]const u8 {
    for (node.attributes) |item| {
        if (std.mem.eql(u8, item.name, name)) return item.value;
    }

    return null;
}

pub fn uniqueChildren(node: dsl.ast.Node, tag: []const u8, key: []const u8, reporter: *dsl.Reporter) dsl.Error!void {
    for (node.children, 0..) |child, index| {
        if (!std.mem.eql(u8, child.name, tag)) continue;

        const name = attribute(child, key).?;

        for (node.children[0..index]) |previous| {
            if (!std.mem.eql(u8, previous.name, tag)) continue;

            const current_attribute = find(child, key).?;
            const previous_attribute = find(previous, key).?;

            if (current_attribute.kind == previous_attribute.kind and std.mem.eql(u8, name, attribute(previous, key).?)) {
                return fail(child, key, "Duplicate RX declaration", reporter);
            }
        }
    }
}

fn find(node: dsl.ast.Node, name: []const u8) ?dsl.ast.Attribute {
    for (node.attributes) |item| {
        if (std.mem.eql(u8, item.name, name)) return item;
    }

    return null;
}

pub fn nonEmptySchema(comptime Schema: type) type {
    return dsl.refine(Schema, struct {
        fn check(_: Schema.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
            try nonEmpty(node, reporter);
        }
    }.check);
}
