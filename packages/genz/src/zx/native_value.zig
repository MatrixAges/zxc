const ir = @import("zx").ir;

pub fn valueBoundary(program: ir.Program, function: ir.Function) bool {
    return boundary(program, function, false);
}

pub fn isolated(program: ir.Program, function: ir.Function) bool {
    return boundary(program, function, true);
}

fn boundary(program: ir.Program, function: ir.Function, borrowed: bool) bool {
    const external = function.external orelse return false;

    if (borrowed and (external.io_argument or external.process_argument)) return false;
    if (function.stores.count() != 0 or !outputLeaf(program, function.output_type)) return false;

    if (external.expand_tuple) {
        const input = program.typeOf(function.input_type);

        if (input != .tuple) return false;

        for (0..input.tuple.len) |view_index| {
            const child = input.tuple.at(view_index);

            if (!inputLeaf(program, child, borrowed)) return false;
        }

        return true;
    }

    return inputLeaf(program, function.input_type, borrowed);
}

fn outputLeaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| outputLeaf(program, child),
        .list => |child| outputLeaf(program, child),
        else => false,
    };
}

fn inputLeaf(program: ir.Program, id: ir.TypeId, borrowed: bool) bool {
    return switch (program.typeOf(id)) {
        .scalar => |scalar| borrowed or scalar != .string,
        .enumeration, .error_set, .native_reference => true,
        .optional => |child| inputLeaf(program, child, borrowed),
        .list => |child| borrowed and inputLeaf(program, child, true),
        else => false,
    };
}
