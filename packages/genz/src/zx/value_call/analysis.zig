const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const pure = try allocator.alloc(bool, program.functions.len);

    defer allocator.free(pure);

    const eligible = try allocator.alloc(bool, program.functions.len);

    for (program.functions, 0..) |function, index| {
        pure[index] = function.external == null and function.stores.len == 0 and !parallel(function.body) and calls(function.expressions, function.contracts, pure[0..index]);
        eligible[index] = pure[index] and program.typeOf(function.output_type) == .object;
    }

    return eligible;
}

pub fn containsDescendant(program: ir.Program, parent: ir.TypeId, root: ir.TypeId) bool {
    return switch (program.typeOf(parent)) {
        .optional, .list => |child| contains(program, child, root),
        .tuple => |children| blk: {
            for (children) |child| if (contains(program, child, root)) break :blk true;

            break :blk false;
        },
        .object => |fields| blk: {
            for (fields) |field| if (contains(program, field.type_id, root)) break :blk true;

            break :blk false;
        },
        else => false,
    };
}

fn contains(program: ir.Program, child: ir.TypeId, root: ir.TypeId) bool {
    return child == root or containsDescendant(program, child, root);
}

fn calls(expressions: []const ir.Expression, contracts: []const ir.Contract, pure: []const bool) bool {
    for (expressions) |expression| switch (expression.value) {
        .call => |value| if (!pure[@intFromEnum(value.function)]) return false,
        else => {},
    };

    for (contracts) |contract| if (!calls(contract.expressions, &.{}, pure)) return false;

    return true;
}

fn parallel(body: []const ir.Statement) bool {
    for (body) |statement| switch (statement) {
        .parallel => return true,
        .branch => |value| if (parallel(value.yes) or parallel(value.no)) return true,
        .switch_stmt => |value| for (value.cases) |case| {
            if (parallel(case.body)) return true;
        },
        else => {},
    };

    return false;
}
