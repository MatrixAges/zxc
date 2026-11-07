const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn borrow(comptime Target: type, self: *const Lower) Target {
    const rows = &self.builder.nodes.expressions;
    const conditional = &rows.payloads.conditional.fields;

    return .{
        .tags = view.slice(@FieldType(Target, "tags"), rows.tags.items),
        .offsets = rows.offsets.items,
        .tuple = view.slice(@FieldType(Target, "tuple"), rows.payloads.tuple.values.items),
        .conditional_condition = view.slice(@FieldType(Target, "conditional_condition"), conditional.condition.values.items),
        .conditional_yes = view.slice(@FieldType(Target, "conditional_yes"), conditional.yes.values.items),
        .conditional_no = view.slice(@FieldType(Target, "conditional_no"), conditional.no.values.items),
        .conditional_capture = view.slice(@FieldType(Target, "conditional_capture"), conditional.capture.values.items),
        .conditional_error_capture = view.slice(@FieldType(Target, "conditional_error_capture"), conditional.error_capture.values.items),
    };
}
