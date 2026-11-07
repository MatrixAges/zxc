const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Change = struct { previous: ir.SymbolId, reference: ir.ExprId, field: ir.ObjectField, type_id: ir.TypeId };

pub fn lower(lowering: *Lower, id: ir.ExprId) Lower.Error!?node.ExpressionId {
    const change = match(lowering, id) orelse return null;

    if (!@import("genz_options").generated_analysis) return try @import("object_update/seed.zig").lower(lowering, change);

    return try @import("object_update/emit.zig").expression(lowering, change);
}

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    if (!lowering.state_active or lowering.iteration_value != null or lowering.loop_fields != null) return null;

    const row = lowering.program.expression(id);

    if (row.value != .object or lowering.program.typeOf(row.type_id) != .object) return null;
    if (!lowering.state_plan.selected[@backingInt(row.type_id)] or lowering.state_plan.referenced(row.type_id)) return null;
    if (!plain(lowering, id) or lowering.cache.contains(id)) return null;

    const object = row.value.object;

    if (object.fields.len < 2 or object.fields.len != lowering.program.typeOf(row.type_id).object.len) return null;

    var reference: ?ir.ExprId = null;

    for (0..object.fields.len) |index| {
        const field = object.fields.at(index);
        const projection = lowering.program.expression(field.value).value;

        if (projection != .field or projection.field.index != field.index) continue;

        const target = lowering.program.expression(projection.field.target);

        if (target.value == .reference and target.type_id == row.type_id) {
            reference = projection.field.target;

            break;
        }
    }

    const source = reference orelse return null;
    const previous = lowering.program.expression(source).value.reference;

    if (!plain(lowering, source)) return null;
    if (!lowering.state_symbols.contains(previous) or lowering.stack_symbols.contains(previous)) return null;
    if (lowering.program.symbols.at(@backingInt(previous)).type_id != row.type_id) return null;

    for (object.evaluation) |item| {
        const value = lowering.program.expression(item).value;

        if (value != .reference or value.reference != previous or !plain(lowering, item)) return null;
    }

    var changed: ?ir.ObjectField = null;

    for (0..object.fields.len) |index| {
        const field = object.fields.at(index);
        const projection = lowering.program.expression(field.value).value;

        if (projection == .field and projection.field.index == field.index and plain(lowering, field.value)) {
            const target = lowering.program.expression(projection.field.target).value;

            if (target == .reference and target.reference == previous and plain(lowering, projection.field.target)) continue;
        }

        if (changed != null) return null;

        changed = field;
    }

    return .{ .previous = previous, .reference = source, .field = changed orelse return null, .type_id = row.type_id };
}

fn plain(lowering: *const Lower, id: ir.ExprId) bool {
    const flags = lowering.plan.get(id);

    return !flags.normalize and !flags.renew;
}
