const dsl = @import("dsl");
const checks = @import("../../../checks.zig");

const FieldBase = dsl.element("Field", struct {
    name: []const u8,
    type: []const u8,
    value: []const u8,
}, dsl.empty);

pub const Field = dsl.refine(FieldBase, checkField);

fn checkField(data: FieldBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try @import("../../../attribute_kind.zig").validate(node, reporter);

    inline for (.{ "name", "type" }) |key| {
        if (!checks.hasContent(@field(data.attributes, key))) {
            return checks.fail(node, key, "Field name and type must not be empty", reporter);
        }
    }
}
