const std = @import("std");
const ir = @import("zx").ir;

/// Boxes the records no expression of the program builds: they only arrive from the host, so nothing ever writes
/// them, and a reference spares every copy of the state that holds them. A record stays a value when a record or
/// tuple within it is built, since boxing reaches everything beneath it.
pub fn mark(allocator: std.mem.Allocator, program: ir.Program, boxed: []bool) std.mem.Allocator.Error!void {
    const count = program.types.count();
    const built = try allocator.alloc(bool, count);

    defer allocator.free(built);
    @memset(built, false);
    constructions(built, program.expressions, program.contracts);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        constructions(built, function.expressions, function.contracts);
    }

    const written = try allocator.alloc(bool, count);

    defer allocator.free(written);

    @memset(written, false);

    var changed = true;

    while (changed) {
        changed = false;

        for (0..count) |index| {
            if (boxed[index] or written[index] or !writes(program, built, written, @fromBackingInt(@intCast(index)))) continue;

            written[index] = true;
            changed = true;
        }
    }

    for (0..count) |index| {
        const id: ir.TypeId = @fromBackingInt(@intCast(index));

        if (program.typeOf(id) == .object and !boxed[index] and !written[index]) @import("analysis.zig").mark(program, boxed, id);
    }
}

/// Whether a value of the type is built, or holds a value that is.
fn writes(program: ir.Program, built: []const bool, written: []const bool, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .tuple => true,
        .optional => |child| written[@backingInt(child)],
        .object => |fields| blk: {
            if (built[@backingInt(id)]) break :blk true;
            for (0..fields.len) |position| if (written[@backingInt(fields.at(position).type_id)]) break :blk true;

            break :blk false;
        },
        else => false,
    };
}

fn constructions(built: []bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable) void {
    for (expressions.kinds, expressions.types) |kind, type_id| {
        if (kind == .Object or kind == .Tuple) built[type_id] = true;
    }

    for (contracts.expressions) |table| constructions(built, table.*, .{});
}
