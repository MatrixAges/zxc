const std = @import("std");
const ir = @import("zx").ir;

pub fn expressions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const bindings = try allocator.alloc(?ir.ExprId, program.symbols.count());

    defer allocator.free(bindings);

    const repeated = try allocator.alloc(bool, program.symbols.count());

    defer allocator.free(repeated);
    @memset(bindings, null);
    @memset(repeated, false);

    const control = program.body.control;

    for (control.constant_symbols, control.constant_values) |symbol, value| bind(bindings, repeated, @fromBackingInt(symbol), @fromBackingInt(value));

    for (0..program.expressions.count()) |index| switch (program.expressions.at(index).value) {
        .scope => |scope| for (0..scope.bindings.len) |position| {
            const binding = scope.bindings.at(position);

            if (binding.symbol) |symbol| bind(bindings, repeated, symbol, binding.value);
        },
        else => {},
    };

    const result = try allocator.alloc(bool, program.expressions.count());

    @memset(result, false);

    for (result, 0..) |*alias, index| alias.* = switch (program.expressions.at(index).value) {
        .field, .tuple_field => |projection| @backingInt(projection.target) < index and result[@backingInt(projection.target)],
        .optional_value => |child| @backingInt(child) < index and result[@backingInt(child)],
        .reference => |symbol| reference: {
            const position = @backingInt(symbol);

            if (position == 0) break :reference true;
            if (repeated[position]) break :reference false;

            const value = bindings[position] orelse break :reference false;

            break :reference @backingInt(value) < index and result[@backingInt(value)];
        },
        else => false,
    };

    return result;
}

fn bind(bindings: []?ir.ExprId, repeated: []bool, symbol: ir.SymbolId, value: ir.ExprId) void {
    const index = @backingInt(symbol);

    if (bindings[index] != null) repeated[index] = true;

    bindings[index] = value;
}
