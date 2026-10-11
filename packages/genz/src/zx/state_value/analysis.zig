const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

selected: []bool,
keys: [][32]u8,
pub fn create(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    const boxed = try allocator.alloc(bool, program.types.count());

    defer allocator.free(boxed);
    @memset(boxed, false);

    for (0..program.types.count()) |position| switch (program.types.at(position)) {
        .list => |child| mark(program, boxed, child),
        .task => |task| mark(program, boxed, task.result),
        else => {},
    };

    for (0..program.stores.count()) |store_index| {
        const slot = program.stores.at(store_index);

        mark(program, boxed, slot.type_id);
    }

    comparisons(program, boxed, program.expressions, program.contracts);

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);

        comparisons(program, boxed, function.expressions, function.contracts);

        for (0..function.stores.count()) |store_index| {
            const slot = function.stores.at(store_index);

            mark(program, boxed, slot.type_id);
        }

        if (function.external != null) {
            mark(program, boxed, function.input_type);
            mark(program, boxed, function.output_type);
        }
    }

    // Each output is walked in its own round; a type seen in the current round shows up twice within one output. A
    // type an earlier round reached was walked through or boxed, so whatever shows up twice within it is boxed already.
    const seen = try allocator.alloc(u32, program.types.count());

    defer allocator.free(seen);
    @memset(seen, 0);
    duplicates(program, boxed, seen, 1, program.output_type);

    for (0..program.functions.count()) |index| {
        const output = program.functions.at(index).output_type;

        if (seen[@backingInt(output)] == 0) duplicates(program, boxed, seen, @intCast(index + 2), output);
    }

    const selected = try allocator.alloc(bool, program.types.count());

    errdefer allocator.free(selected);

    const keys = try allocator.alloc([32]u8, program.types.count());

    for (0..program.types.count()) |index| {
        const value = program.types.at(index);

        selected[index] = !boxed[index] and (value == .object or value == .tuple);

        var hash = @import("zx").Sha256.init(.{});

        hash.update("state.value.origin.v1");
        hash.update(&.{@intFromBool(selected[index])});

        switch (value) {
            .optional => |child| hash.update(&keys[@backingInt(child)]),
            .object => |fields| if (selected[index]) {
                for (0..fields.len) |position| hash.update(&keys[@backingInt(fields.at(position).type_id)]);
            },
            .tuple => |items| if (selected[index]) {
                for (0..items.len) |position| hash.update(&keys[@backingInt(items.at(position))]);
            },
            else => {},
        }

        hash.final(&keys[index]);
    }

    return .{ .selected = selected, .keys = keys };
}

fn duplicates(program: ir.Program, boxed: []bool, seen: []u32, round: u32, id: ir.TypeId) void {
    const index = @backingInt(id);

    if (boxed[index]) return;

    switch (program.typeOf(id)) {
        .object, .tuple => {
            if (seen[index] == round) {
                mark(program, boxed, id);

                return;
            }

            seen[index] = round;
        },
        else => {},
    }

    switch (program.typeOf(id)) {
        .optional => |child| duplicates(program, boxed, seen, round, child),
        .object => |fields| for (0..fields.len) |position| duplicates(program, boxed, seen, round, fields.at(position).type_id),
        .tuple => |items| for (0..items.len) |position| duplicates(program, boxed, seen, round, items.at(position)),
        else => {},
    }
}

pub fn represented(self: Self, program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => |child| self.represented(program, child),
        else => self.selected[@backingInt(id)],
    };
}

pub fn name(self: Self, allocator: std.mem.Allocator, id: ir.TypeId, base: []const u8) std.mem.Allocator.Error![]const u8 {
    var hash = @import("zx").Sha256.init(.{});

    hash.update(base);
    hash.update(&.{0});
    hash.update(&self.keys[@backingInt(id)]);

    return std.fmt.allocPrint(allocator, "value_{x}", .{hash.finalResult()});
}

pub fn nested(self: Self, program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => |child| self.represented(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |view_index| {
                const field = fields.at(view_index);

                if (self.represented(program, field.type_id)) break :blk true;
            }

            break :blk false;
        },
        .tuple => |items| blk: {
            for (0..items.len) |item_index| {
                const item = items.at(item_index);

                if (self.represented(program, item)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}

/// Boxes the types compared for equality against anything but `none`; reads the kind and binary columns directly.
fn comparisons(program: ir.Program, boxed: []bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable) void {
    for (expressions.kinds, expressions.payloads) |kind, payload| {
        if (kind != .Binary) continue;

        const operator = expressions.binary_operators[payload];

        if (operator != .Equal and operator != .NotEqual) continue;

        const left = expressions.binary_left[payload];
        const right = expressions.binary_right[payload];

        if (expressions.kinds[left] == .None or expressions.kinds[right] == .None) continue;

        mark(program, boxed, @fromBackingInt(expressions.types[left]));
        mark(program, boxed, @fromBackingInt(expressions.types[right]));
    }

    for (contracts.expressions) |expressions_table| comparisons(program, boxed, expressions_table.*, .{});
}

fn mark(program: ir.Program, boxed: []bool, id: ir.TypeId) void {
    const index = @backingInt(id);

    if (boxed[index]) return;

    boxed[index] = true;

    switch (program.typeOf(id)) {
        .optional, .list => |child| mark(program, boxed, child),
        .task => |task| mark(program, boxed, task.result),
        .object => |fields| for (0..fields.len) |position| mark(program, boxed, fields.at(position).type_id),
        .tuple => |items| for (0..items.len) |position| mark(program, boxed, items.at(position)),
        else => {},
    }
}
