const ir = @import("zx").ir;

pub fn isolated(program: ir.Program, function: ir.Function) bool {
    const external = function.external orelse return false;

    if (function.stores.len != 0) return false;
    if (!leaf(program, function.output_type)) return false;

    if (external.expand_tuple) {
        const input = program.typeOf(function.input_type);

        if (input != .tuple) return false;

        for (input.tuple) |child| if (!leaf(program, child)) return false;

        return true;
    }

    return leaf(program, function.input_type);
}

fn leaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |scalar| scalar != .string,
        .enumeration, .error_set, .native_reference => true,
        .optional => |child| leaf(program, child),
        else => false,
    };
}
