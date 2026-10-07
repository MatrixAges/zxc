const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (comptime !options.generated_parser) return @import("seed_tasks.zig").validate(allocator, program);

    const generated = @import("generated_ir_tasks");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const Body = std.meta.Child(@FieldType(Input, "body"));
    const table = ir.TypeTable.borrow(Table, program.types);

    const body: Body = .{
        .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
        .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
        .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
        .control = borrow.pointer(@FieldType(Body, "control"), program.body.control),
        .root = if (program.body.root) |id| @backingInt(id) else null,
    };

    const input: Input = .{ .table = &table, .body = &body, .input_type = @backingInt(program.input_type), .output_type = @backingInt(program.output_type) };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}

pub fn callSafe(allocator: std.mem.Allocator, functions: ir.FunctionTable, id: ir.FunctionId) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, functions.count());

    defer allocator.free(safe);

    for (0..functions.count()) |index| {
        const function = functions.at(index);

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
