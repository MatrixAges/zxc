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
    for (node.attributes) |item| {
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

            if (std.mem.eql(u8, name, attribute(previous, key).?)) {
                return fail(child, key, "Duplicate RX declaration", reporter);
            }
        }
    }
}

pub fn nonEmptySchema(comptime Schema: type) type {
    return dsl.refine(Schema, struct {
        fn check(_: Schema.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
            try nonEmpty(node, reporter);
        }
    }.check);
}
