const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Field = @import("Field.zig").Field;
const ObjectBase = dsl.element("Object", struct { name: []const u8 }, dsl.list(Field, .{ .min = 1 }));
pub const Object = dsl.refine(ObjectBase, checkObject);

fn checkObject(_: ObjectBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);
    try checks.uniqueChildren(node, "Field", "name", reporter);
}
