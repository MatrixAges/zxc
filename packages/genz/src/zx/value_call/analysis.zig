const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const summary = try analyze(allocator, program);

    allocator.free(summary.pure);
    allocator.free(summary.local);
    allocator.free(summary.state.selected);
    allocator.free(summary.state.keys);

    return summary.values;
}

pub const Summary = struct { pure: []bool, local: []bool, values: []bool, state: @import("../state_value/analysis.zig") };

pub fn scalarLocals(program: ir.Program, pure: []const bool) bool {
    var output = program.typeOf(program.output_type);

    while (output == .optional) output = program.typeOf(output.optional);

    switch (output) {
        .scalar, .enumeration, .error_set => {},
        else => return false,
    }

    return program.stores.count() == 0 and !parallel(program.body.block()) and calls(program.expressions, program.contracts, pure);
}

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Summary {
    const state = try @import("../state_value/analysis.zig").create(allocator, program);

    errdefer allocator.free(state.selected);
    errdefer allocator.free(state.keys);

    const pure = try allocator.alloc(bool, program.functions.count());

    errdefer allocator.free(pure);

    const local = try allocator.alloc(bool, program.functions.count());

    errdefer allocator.free(local);

    const eligible = try allocator.alloc(bool, program.functions.count());

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);
        pure[index] = if (function.external != null) @import("../native_value.zig").valueBoundary(program, function) else function.stores.count() == 0 and !parallel(function.body.block()) and calls(function.expressions, function.contracts, pure[0..index]);
        local[index] = if (function.external != null) @import("../native_value.zig").isolated(program, function) else function.stores.count() == 0 and !parallel(function.body.block()) and calls(function.expressions, function.contracts, local[0..index]);
        eligible[index] = local[index] and (program.typeOf(function.output_type) == .object or state.represented(program, function.output_type));
    }

    return .{ .pure = pure, .local = local, .values = eligible, .state = state };
}

pub fn sharesAggregate(program: ir.Program, input: ir.TypeId, output: ir.TypeId) bool {
    const value = program.typeOf(input);

    if ((value == .object or value == .tuple) and contains(program, output, input)) return true;

    return switch (value) {
        .optional, .list => |child| sharesAggregate(program, child, output),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (sharesAggregate(program, fields.at(index).type_id, output)) break :blk true;

            break :blk false;
        },
        .tuple => |children| blk: {
            for (0..children.len) |index| if (sharesAggregate(program, children.at(index), output)) break :blk true;

            break :blk false;
        },
        else => false,
    };
}

pub fn containsDescendant(program: ir.Program, parent: ir.TypeId, root: ir.TypeId) bool {
    return switch (program.typeOf(parent)) {
        .optional, .list => |child| contains(program, child, root),
        .tuple => |children| blk: {
            for (0..children.len) |view_index| {
                const child = children.at(view_index);

                if (contains(program, child, root)) break :blk true;
            }

            break :blk false;
        },
        .object => |fields| blk: {
            for (0..fields.len) |item_index| {
                const field = fields.at(item_index);

                if (contains(program, field.type_id, root)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}

fn contains(program: ir.Program, child: ir.TypeId, root: ir.TypeId) bool {
    return child == root or containsDescendant(program, child, root);
}

fn calls(expressions: ir.ExpressionTable, contracts: ir.ContractTable, pure: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        switch (expression.value) {
            .task, .await_task, .cancel_task, .parallel => return false,
            .call => |value| if (!pure[@backingInt(value.function)]) return false,
            else => {},
        }
    }

    for (contracts.expressions) |expressions_table| if (!calls(expressions_table.*, .{}, pure)) return false;

    return true;
}

fn parallel(body: ir.Block) bool {
    for (0..body.len) |statement_index| {
        const statement = body.at(statement_index);

        switch (statement) {
            .parallel => return true,
            .branch => |value| if (parallel(value.yes) or parallel(value.no)) return true,
            .switch_stmt => |value| for (0..value.cases.len) |case_index| {
                const case = value.cases.at(case_index);

                if (parallel(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
