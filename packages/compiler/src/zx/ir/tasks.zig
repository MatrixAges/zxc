const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (program.typeOf(program.input_type) == .task or program.typeOf(program.output_type) == .task) return false;

    const uses = try allocator.alloc(usize, program.expressions.len);

    defer allocator.free(uses);
    @memset(uses, 0);

    for (program.expressions) |expression| switch (expression.value) {
        .await_task => |child| {
            const value = program.expression(child).value;

            if (value != .task and value != .reference) return false;

            uses[@backingInt(child)] += 1;
        },
        .parallel => |branches| for (branches) |branch| {
            uses[@backingInt(branch.task)] += 1;
        },
        .scope => |scope| for (scope.bindings) |binding| {
            if (program.typeOf(program.expression(binding.value).type_id) == .task) return false;
        },
        else => {},
    };

    if (!bindings(program, program.body, uses)) return false;

    for (program.expressions, uses) |expression, count| {
        if (program.typeOf(expression.type_id) == .task and count != 1) return false;
    }

    return true;
}

fn bindings(program: ir.Program, statements: []const ir.Statement, uses: []usize) bool {
    for (statements) |statement| switch (statement) {
        .constant => |binding| {
            const expression = program.expression(binding.value);

            if (program.typeOf(expression.type_id) != .task) continue;
            if (expression.value != .task) return false;

            uses[@backingInt(binding.value)] += 1;
        },
        .branch => |branch| {
            if (!bindings(program, branch.yes, uses) or !bindings(program, branch.no, uses)) return false;
        },
        .switch_stmt => |selection| for (selection.cases) |case| {
            if (!bindings(program, case.body, uses)) return false;
        },
        else => {},
    };

    return true;
}

pub fn callSafe(allocator: std.mem.Allocator, functions: []const ir.Function, id: ir.FunctionId) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, functions.len);

    defer allocator.free(safe);

    for (functions, 0..) |function, index| {
        safe[index] = function.stores.len == 0;

        if (function.external) |external| {
            safe[index] = safe[index] and external.concurrent;

            continue;
        }

        for (function.expressions) |expression| switch (expression.value) {
            .store_get => safe[index] = false,
            .call => |call| {
                const target = @backingInt(call.function);

                if (target >= index or !safe[target] or call.stores.len != 0) safe[index] = false;
            },
            else => {},
        };
    }

    return @backingInt(id) < safe.len and safe[@backingInt(id)];
}
