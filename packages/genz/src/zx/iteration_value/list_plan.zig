const ir = @import("zx").ir;

pub fn product(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| product(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!product(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!product(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => false,
    };
}

pub fn supported(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list, .optional => |child| product(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!supported(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!supported(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => product(program, id),
    };
}
