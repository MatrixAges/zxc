const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const summary = try analyze(allocator, program);

    allocator.free(summary.pure);
    allocator.free(summary.local);

    return summary.values;
}

pub const Summary = struct { pure: []bool, local: []bool, values: []bool };

pub fn scalarLocals(program: ir.Program, pure: []const bool) bool {
    switch (program.typeOf(program.output_type)) {
        .scalar, .enumeration, .error_set => {},
        else => return false,
    }

    return program.stores.len == 0 and !parallel(program.body) and calls(program.expressions, program.contracts, pure);
}

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Summary {
    const pure = try allocator.alloc(bool, program.functions.len);

    errdefer allocator.free(pure);

    const local = try allocator.alloc(bool, program.functions.len);

    errdefer allocator.free(local);

    const eligible = try allocator.alloc(bool, program.functions.len);

    for (program.functions, 0..) |function, index| {
        pure[index] = function.external == null and function.stores.len == 0 and !parallel(function.body) and calls(function.expressions, function.contracts, pure[0..index]);
        local[index] = if (function.external != null) @import("../native_value.zig").isolated(program, function) else function.stores.len == 0 and !parallel(function.body) and calls(function.expressions, function.contracts, local[0..index]);
        eligible[index] = pure[index] and program.typeOf(function.output_type) == .object;
    }

    return .{ .pure = pure, .local = local, .values = eligible };
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
        .task, .await_task, .cancel_task, .parallel => return false,
        .call => |value| if (!pure[@backingInt(value.function)]) return false,
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
