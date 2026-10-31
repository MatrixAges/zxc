const std = @import("std");
const dsl = @import("dsl");
const frontend = @import("frontend");
const checks = @import("../checks.zig");

const FieldBase = dsl.element("Field", struct {
    name: []const u8,
    type: []const u8,
}, dsl.empty);

pub const Field = dsl.refine(FieldBase, checkField);

fn checkField(data: FieldBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (!frontend.binding_path.valid(data.attributes.name) or std.mem.indexOfScalar(u8, data.attributes.name, '.') != null) {
        return checks.fail(node, "name", "Field name must be one ZX identifier", reporter);
    }
}
