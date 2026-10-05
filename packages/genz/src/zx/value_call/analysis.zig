const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const pure = try allocator.alloc(bool, program.functions.len);

    defer allocator.free(pure);

    const eligible = try allocator.alloc(bool, program.functions.len);

    for (program.functions, 0..) |function, index| {
        pure[index] = function.external == null and function.stores.len == 0 and !parallel(function.body) and calls(function.expressions, function.contracts, pure[0..index]);
        eligible[index] = pure[index] and !function.consumes_input and flatObject(program, function.output_type);
    }

    return eligible;
}

fn flatObject(program: ir.Program, id: ir.TypeId) bool {
    const value = program.typeOf(id);

    if (value != .object) return false;
    for (value.object) |field| if (!scalar(program, field.type_id)) return false;

    return true;
}

fn scalar(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |value| value != .string,
        .enumeration => true,
        .optional => |child| scalar(program, child),
        else => false,
    };
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
