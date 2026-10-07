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

    const seen = try allocator.alloc(bool, program.types.count());

    defer allocator.free(seen);

    for (0..program.types.count()) |index| {
        @memset(seen, false);
        duplicates(program, boxed, seen, @fromBackingInt(@intCast(index)));
    }

    const selected = try allocator.alloc(bool, program.types.count());

    errdefer allocator.free(selected);

    const keys = try allocator.alloc([32]u8, program.types.count());

    for (0..program.types.count()) |index| {
        const value = program.types.at(index);

        selected[index] = !boxed[index] and (value == .object or value == .tuple);

        var hash = std.crypto.hash.sha2.Sha256.init(.{});

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

fn duplicates(program: ir.Program, boxed: []bool, seen: []bool, id: ir.TypeId) void {
    const index = @backingInt(id);

    if (boxed[index]) return;

    switch (program.typeOf(id)) {
        .object, .tuple => {
            if (seen[index]) {
                mark(program, boxed, id);

                return;
            }

            seen[index] = true;
        },
        else => {},
    }

    switch (program.typeOf(id)) {
        .optional => |child| duplicates(program, boxed, seen, child),
        .object => |fields| for (0..fields.len) |position| duplicates(program, boxed, seen, fields.at(position).type_id),
        .tuple => |items| for (0..items.len) |position| duplicates(program, boxed, seen, items.at(position)),
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
    return std.fmt.allocPrint(allocator, "value_{s}_{x}", .{ base, self.keys[@backingInt(id)] });
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

fn comparisons(program: ir.Program, boxed: []bool, expressions: ir.ExpressionTable, contracts: []const ir.Contract) void {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        if (expression.value == .binary) {
            const binary = expression.value.binary;

            if (binary.operator != .equal and binary.operator != .not_equal) continue;

            const left = expressions.at(@backingInt(binary.left));
            const right = expressions.at(@backingInt(binary.right));

            if (left.value == .none or right.value == .none) continue;

            mark(program, boxed, left.type_id);
            mark(program, boxed, right.type_id);
        }
    }

    for (contracts) |contract| comparisons(program, boxed, contract.expressions, &.{});
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
