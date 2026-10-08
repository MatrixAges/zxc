const std = @import("std");
const ir = @import("zx").ir;

pub fn path(allocator: std.mem.Allocator, program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) std.mem.Allocator.Error!?[]const usize {
    var result: std.ArrayList(usize) = .empty;

    if (!try collect(allocator, program, id, symbol, &result)) return null;

    return try result.toOwnedSlice(allocator);
}

fn collect(allocator: std.mem.Allocator, program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId, result: *std.ArrayList(usize)) std.mem.Allocator.Error!bool {
    return switch (program.expression(id).value) {
        .reference => |value| value == symbol,
        .field, .tuple_field => |field| blk: {
            if (!try collect(allocator, program, field.target, symbol, result)) break :blk false;
            try result.append(allocator, field.index);

            break :blk true;
        },
        else => false,
    };
}

pub fn select(program: ir.Program, id: ir.ExprId, remaining: []const usize) ?ir.ExprId {
    const value = program.expression(id).value;

    if (value == .scope) return select(program, value.scope.result, remaining);
    if (remaining.len == 0) return id;

    return switch (value) {
        .object => |object| blk: {
            for (0..object.fields.len) |index| {
                const field = object.fields.at(index);

                if (field.index == remaining[0]) break :blk select(program, field.value, remaining[1..]);
            }

            break :blk null;
        },
        .tuple => |items| if (remaining[0] < items.len) select(program, items[remaining[0]], remaining[1..]) else null,
        else => null,
    };
}

pub fn matches(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId, expected: []const usize) bool {
    const value = program.expression(id).value;

    if (expected.len == 0) return value == .reference and value.reference == symbol;

    return switch (value) {
        .field, .tuple_field => |field| field.index == expected[expected.len - 1] and matches(program, field.target, symbol, expected[0 .. expected.len - 1]),
        else => false,
    };
}

pub fn integer(program: ir.Program, id: ir.ExprId, expected: u64) bool {
    const value = program.expression(id).value;

    return value == .integer and value.integer == expected;
}
