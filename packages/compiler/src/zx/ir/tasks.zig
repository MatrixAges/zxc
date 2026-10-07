const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (program.typeOf(program.input_type) == .task or program.typeOf(program.output_type) == .task) return false;

    const uses = try allocator.alloc(usize, program.expressions.count());

    defer allocator.free(uses);
    @memset(uses, 0);

    for (0..program.expressions.count()) |expression_index| {
        const expression = program.expressions.at(expression_index);

        switch (expression.value) {
            .task => |task| {
                if (try ir.containsNativeReference(allocator, program.types, program.expression(task.body).type_id)) return false;
                for (task.captures) |symbol| if (try ir.containsNativeReference(allocator, program.types, program.symbols.at(@backingInt(symbol)).type_id)) return false;
            },
            .await_task, .cancel_task => |child| {
                const value = program.expression(child).value;

                if (value != .task and value != .reference) return false;

                uses[@backingInt(child)] += 1;
            },
            .parallel => |branches| for (0..branches.len) |record_index| {
                const branch = branches.at(record_index);

                uses[@backingInt(branch.task)] += 1;
            },
            .scope => |scope| for (0..scope.bindings.len) |record_index| {
                const binding = scope.bindings.at(record_index);
                const value = program.expression(binding.value);

                if (program.typeOf(value.type_id) != .task) continue;
                if (binding.symbol == null or value.value != .task) return false;

                uses[@backingInt(binding.value)] += 1;
            },
            else => {},
        }
    }

    if (!bindings(program, program.body.block(), uses)) return false;

    for (0..program.expressions.count(), uses) |expression_index, count| {
        const expression = program.expressions.at(expression_index);

        if (program.typeOf(expression.type_id) == .task and count != 1) return false;
    }

    return true;
}

fn bindings(program: ir.Program, statements: ir.Block, uses: []usize) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .constant => |binding| {
                const expression = program.expression(binding.value);

                if (program.typeOf(expression.type_id) != .task) continue;
                if (expression.value != .task) return false;

                uses[@backingInt(binding.value)] += 1;
            },
            .branch => |branch| {
                if (!bindings(program, branch.yes, uses) or !bindings(program, branch.no, uses)) return false;
            },
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (!bindings(program, case.body, uses)) return false;
            },
            else => {},
        }
    }

    return true;
}

pub fn callSafe(allocator: std.mem.Allocator, functions: []const ir.Function, id: ir.FunctionId) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, functions.len);

    defer allocator.free(safe);

    for (functions, 0..) |function, index| {
        safe[index] = function.stores.count() == 0;

        if (function.external) |external| {
            safe[index] = safe[index] and external.concurrent;

            continue;
        }

        for (0..function.expressions.count()) |expression_index| {
            const expression = function.expressions.at(expression_index);

            switch (expression.value) {
                .store_get => safe[index] = false,
                .call => |call| {
                    const target = @backingInt(call.function);

                    if (target >= index or !safe[target] or call.stores.len != 0) safe[index] = false;
                },
                else => {},
            }
        }
    }

    return @backingInt(id) < safe.len and safe[@backingInt(id)];
}
