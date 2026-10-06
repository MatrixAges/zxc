const ir = @import("zx").ir;

pub fn scalarBoundary(program: ir.Program, function: ir.Function) bool {
    const external = function.external orelse return false;

    if (function.stores.len != 0 or !scalarLeaf(program, function.output_type)) return false;

    if (external.expand_tuple) {
        const input = program.typeOf(function.input_type);

        if (input != .tuple) return false;

        for (0..input.tuple.len) |view_index| {
            const child = input.tuple.at(view_index);

            if (!scalarLeaf(program, child)) return false;
        }

        return true;
    }

    return scalarLeaf(program, function.input_type);
}

pub fn isolated(program: ir.Program, function: ir.Function) bool {
    const external = function.external orelse return false;

    if (function.stores.len != 0) return false;
    if (!outputLeaf(program, function.output_type)) return false;

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

fn scalarLeaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |value| value != .string,
        .enumeration, .error_set => true,
        .optional => |child| scalarLeaf(program, child),
        else => false,
    };
}

fn outputLeaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| outputLeaf(program, child),
        .list => |child| inputLeaf(program, child),
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
