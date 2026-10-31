const dsl = @import("dsl");
const checks = @import("../checks.zig");
const Field = @import("../labels/Field.zig").Field;

pub fn schema(comptime name: []const u8) type {
    return dsl.element(name, struct { type: ?[]const u8 = null }, dsl.list(Field, .{}));
}

pub fn check(data: anytype, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (data.attributes.type != null and node.children.len != 0) {
        return checks.fail(node, "type", "Input and Output must use either type or Field declarations", reporter);
    }

    try checks.uniqueChildren(node, "Field", "name", reporter);
}
