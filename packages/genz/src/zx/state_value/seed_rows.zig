const std = @import("std");
const ir = @import("zx").ir;

/// Initial-seed visibility and sharing proof; formal builds use Source state/visible and state/shared.
pub fn create(allocator: std.mem.Allocator, program: ir.Program, local: []const bool, exported: []const ir.FunctionId) std.mem.Allocator.Error![]bool {
    const inputs = try allocator.alloc(bool, program.types.count());

    defer allocator.free(inputs);

    const outputs = try allocator.alloc(bool, program.types.count());

    defer allocator.free(outputs);

    const visible = try allocator.alloc(bool, program.types.count());

    defer allocator.free(visible);
    @memset(inputs, false);
    @memset(outputs, false);
    @memset(visible, false);
    mark(program, inputs, program.input_type);
    mark(program, outputs, program.output_type);

    for (exported) |id| {
        const function = program.functions.at(@backingInt(id));

        mark(program, inputs, function.input_type);
        mark(program, outputs, function.output_type);
    }

    for (0..program.types.count()) |index| {
        const kind = program.types.at(index);

        if (inputs[index] and outputs[index] and (kind == .object or kind == .tuple)) mark(program, visible, @fromBackingInt(@as(u32, @intCast(index))));
    }

    for (0..program.stores.count()) |index| mark(program, visible, program.stores.at(index).type_id);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        if (function.external != null or !local[index]) mark(program, visible, function.input_type);
        if (function.external != null) mark(program, visible, function.output_type);
        if (!local[index]) for (function.expressions.types) |id| mark(program, visible, @fromBackingInt(id));
        for (0..function.stores.count()) |slot| mark(program, visible, function.stores.at(slot).type_id);
    }

    const blocked = try allocator.dupe(bool, visible);

    defer allocator.free(blocked);
    effects(program, visible, blocked, program.expressions, program.contracts, program.symbols);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        effects(program, visible, blocked, function.expressions, function.contracts, function.symbols);
    }

    const rows = try allocator.alloc(bool, program.types.count());

    for (rows, 0..) |*value, index| value.* = !blocked[index];

    return rows;
}

fn effects(program: ir.Program, visible: []const bool, blocked: []bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable, symbols: ir.SymbolTable) void {
    for (expressions.task_captures) |symbol| mark(program, blocked, symbols.at(symbol).type_id);

    @import("seed_sharing.zig").mark(program, visible, blocked, expressions);
    for (contracts.expressions) |table| effects(program, visible, blocked, table.*, .{}, symbols);
}

pub fn mark(program: ir.Program, seen: []bool, id: ir.TypeId) void {
    if (seen[@backingInt(id)]) return;

    seen[@backingInt(id)] = true;

    switch (program.typeOf(id)) {
        .list, .optional => |child| mark(program, seen, child),
        .object => |fields| for (0..fields.len) |index| mark(program, seen, fields.at(index).type_id),
        .tuple => |children| for (0..children.len) |index| mark(program, seen, children.at(index)),
        .task => |task| mark(program, seen, task.result),
        else => {},
    }
}

/// Mirrors Source row_storage without changing the layout of unrelated ABI objects.
pub fn carriers(allocator: std.mem.Allocator, program: ir.Program, boxed: []const bool, built: []bool) std.mem.Allocator.Error!void {
    const values = try allocator.alloc(bool, program.types.count());

    defer allocator.free(values);

    @memset(values, false);

    for (values, 0..) |*value, index| {
        value.* = switch (program.types.at(index)) {
            .list => |child| list: {
                const row = program.typeOf(child) == .object and !boxed[@backingInt(child)];

                if (row) built[@backingInt(child)] = true;

                break :list row or values[@backingInt(child)];
            },
            .optional => |child| values[@backingInt(child)],
            .object => |fields| object: {
                for (0..fields.len) |field| if (values[@backingInt(fields.at(field).type_id)]) break :object true;

                break :object false;
            },
            .tuple => |children| tuple: {
                for (0..children.len) |child| if (values[@backingInt(children.at(child))]) break :tuple true;

                break :tuple false;
            },
            else => false,
        };

        if (program.types.at(index) == .object and value.*) built[index] = true;
    }
}
