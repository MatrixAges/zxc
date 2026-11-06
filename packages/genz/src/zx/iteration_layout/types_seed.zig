const ir = @import("zx").ir;

pub fn flat(program: ir.Program, id: ir.TypeId) bool {
    const target = program.typeOf(id);

    switch (target) {
        .object => |fields| for (0..fields.len) |view_index| {
            const field = fields.at(view_index);

            if (!leaf(program, field.type_id)) return false;
        },
        .tuple => |items| for (0..items.len) |item_index| {
            const item = items.at(item_index);

            if (!leaf(program, item)) return false;
        },
        else => return false,
    }

    return true;
}

pub fn leaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional, .list => |child| leaf(program, child),
        else => false,
    };
}

pub fn aggregate(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .object, .tuple => true,
        else => false,
    };
}

pub fn represented(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => |child| represented(program, child),
        else => aggregate(program, id),
    };
}

pub fn supported(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list => true,
        .optional => |child| supported(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |view_index| {
                const field = fields.at(view_index);

                if (!supported(program, field.type_id)) break :blk false;
            }

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |item_index| {
                const item = items.at(item_index);

                if (!supported(program, item)) break :blk false;
            }

            break :blk true;
        },
        else => leaf(program, id),
    };
}

pub fn scalarProduct(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .object => |fields| result: {
            for (0..fields.len) |index| if (!@import("../types/scalar.zig").check(program.types, fields.at(index).type_id)) break :result false;

            break :result true;
        },
        .tuple => |items| result: {
            for (0..items.len) |index| if (!@import("../types/scalar.zig").check(program.types, items.at(index))) break :result false;

            break :result true;
        },
        else => false,
    };
}
