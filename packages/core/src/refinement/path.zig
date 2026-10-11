const ir = @import("../ir.zig");

pub fn same(values: ir.ExpressionTable, left: ir.ExprId, right: ir.ExprId) bool {
    if (values.get(left).value != .field or values.get(right).value != .field) return false;

    var a = left;
    var b = right;
    var a_remaining = values.count();
    var b_remaining = values.count();

    while (a_remaining != 0 and b_remaining != 0) {
        const lhs = values.get(a).value;
        const rhs = values.get(b).value;

        if (lhs == .optional_value) {
            a = lhs.optional_value;
            a_remaining -= 1;
        } else if (rhs == .optional_value) {
            b = rhs.optional_value;
            b_remaining -= 1;
        } else if (lhs == .reference and rhs == .reference) {
            return lhs.reference == rhs.reference;
        } else if (lhs == .field and rhs == .field and lhs.field.index == rhs.field.index) {
            a = lhs.field.target;
            b = rhs.field.target;
            a_remaining -= 1;
            b_remaining -= 1;
        } else {
            return false;
        }
    }

    return false;
}
