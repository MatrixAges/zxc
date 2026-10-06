const ir = @import("zx").ir;

pub fn valueBoundary(program: ir.Program, function: ir.Function) bool {
    const external = function.external orelse return false;

    if (function.stores.len != 0 or !outputLeaf(program, function.output_type)) return false;

    if (external.expand_tuple) {
        const input = program.typeOf(function.input_type);

        if (input != .tuple) return false;

        for (0..input.tuple.len) |view_index| {
            const child = input.tuple.at(view_index);

            if (!inputLeaf(program, child)) return false;
        }

        return true;
    }

    return inputLeaf(program, function.input_type);
}

pub const isolated = valueBoundary;

fn outputLeaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| outputLeaf(program, child),
        .list => |child| outputLeaf(program, child),
        else => false,
    };
}

fn inputLeaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |scalar| scalar != .string,
        .enumeration, .error_set, .native_reference => true,
        .optional => |child| inputLeaf(program, child),
        else => false,
    };
}
