const ir = @import("zx").ir;

/// The seed uses inline input rows only when no function can publish an aggregate or an external effect.
pub fn scope(program: ir.Program) bool {
    if (program.stores.count() != 0 or !scalar(program, program.output_type)) return false;
    if (@import("../entry_flags/seed.zig").parallel(program.body.block())) return false;
    if (!expressions(program.expressions, program.contracts)) return false;

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        if (function.external != null or function.stores.count() != 0 or !scalar(program, function.output_type)) return false;
        if (@import("../entry_flags/seed.zig").parallel(function.body.block())) return false;
        if (!expressions(function.expressions, function.contracts)) return false;
    }

    return true;
}

fn scalar(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set => true,
        .optional => |child| scalar(program, child),
        else => false,
    };
}

fn expressions(table: ir.ExpressionTable, contracts: ir.ContractTable) bool {
    if (table.collection_kinds.len != 0 or table.update_targets.len != 0 or table.parallel_count.len != 0 or table.task_bodies.len != 0 or table.awaits.len != 0 or table.cancellations.len != 0 or table.stores.len != 0) return false;
    for (table.transform_kinds) |kind| if (kind != .Sort) return false;
    for (contracts.expressions) |child| if (!expressions(child.*, .{})) return false;

    return true;
}

pub fn record(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |value| value != .string and value != .void,
        .enumeration, .error_set, .list => true,
        .optional => |child| program.typeOf(child) != .object and record(program, child),
        .object => |fields| result: {
            for (0..fields.len) |index| {
                const child = fields.at(index).type_id;

                if (program.typeOf(child) == .object or !record(program, child)) break :result false;
            }

            break :result true;
        },
        else => false,
    };
}
