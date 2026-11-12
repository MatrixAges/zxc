const std = @import("std");
const ir = @import("zx").ir;
const Builder = @import("../builder.zig");
const linking = @import("../linking.zig");

pub fn plan(allocator: std.mem.Allocator, builder: *const Builder, program: ir.Program) Builder.Error!linking.Plan {
    const block = program.body.block();
    const count = block.len - 1;
    const returned = block.at(count);

    if (returned != .result or returned.result == null) return error.InvalidModule;

    const rows = try allocator.alloc(u32, program.expressions.count());

    @memset(rows, 0);

    for (0..count) |index| {
        const statement = block.at(index);

        if (statement != .constant) return error.InvalidModule;

        const source = statement.constant;
        const row = @backingInt(source.value);

        if (@backingInt(source.symbol) != index + 1 or row >= rows.len) return error.InvalidModule;

        const value = program.expressions.at(row).value;

        if (value != .tuple_field or value.tuple_field.index != index) return error.InvalidModule;
        if (@backingInt(value.tuple_field.target) >= rows.len) return error.InvalidModule;

        const target = program.expression(value.tuple_field.target).value;

        if (target != .reference or @backingInt(target.reference) != 0) return error.InvalidModule;

        rows[row] = linking.missing;
    }

    const bindings = try allocator.alloc(u32, count);
    const target = builder.symbols.view();

    for (bindings, program.symbols.names[1..block.len], program.symbols.types[1..block.len]) |*output, name, type_id| {
        output.* = linking.missing;

        for (builder.bindings.items) |binding| {
            const index = @backingInt(binding);

            if (!std.mem.eql(u8, name, target.names[index])) continue;
            if (target.types[index] != type_id) return error.InvalidModule;

            output.* = index;
        }
    }

    const table = program.expressions;
    var next_id = builder.expressions.count();

    for (rows, table.kinds, table.payloads) |*row, kind, payload| {
        if (row.* == linking.missing) continue;

        if (kind == .Reference and table.references[payload] == 0) {
            row.* = linking.missing;
        } else {
            row.* = @intCast(next_id);
            next_id += 1;
        }
    }

    return .{ .returned = returned.result.?, .rows = rows, .bindings = bindings };
}
