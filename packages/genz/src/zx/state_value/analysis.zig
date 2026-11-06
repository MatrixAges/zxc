const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

element_storage: []const bool = &.{},
selected: []bool,
borrowed: []const bool,
keys: [][32]u8,
queries: []const @import("queries.zig").Kind = &.{},
pub fn create(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    const boxed = try allocator.alloc(bool, program.types.count());

    defer allocator.free(boxed);
    @memset(boxed, false);

    const read_only = @import("read_only.zig");
    const inline_rows = read_only.scope(program);

    for (0..program.types.count()) |position| switch (program.types.at(position)) {
        .list => |child| if (!inline_rows or !read_only.record(program, child)) {
            mark(program, boxed, child);
        },
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

    try @import("frozen.zig").mark(allocator, program, boxed, inline_rows);

    const selected = try allocator.alloc(bool, program.types.count());

    errdefer allocator.free(selected);

    const borrowed = try allocator.alloc(bool, program.types.count());

    errdefer allocator.free(borrowed);
    @memset(borrowed, false);

    const keys = try allocator.alloc([32]u8, program.types.count());

    errdefer allocator.free(keys);

    for (0..program.types.count()) |index| {
        const value = program.types.at(index);

        selected[index] = value == .list or (!boxed[index] and (value == .object or value == .tuple));

        var hash = @import("zx").Sha256.init(.{});

        hash.update("state.value.origin.v12");
        hash.update(&.{@intFromBool(selected[index])});

        switch (value) {
            .optional, .list => |child| hash.update(&keys[@backingInt(child)]),
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

    const queries = try @import("queries.zig").create(allocator, program, selected);

    return .{ .selected = selected, .borrowed = borrowed, .keys = keys, .queries = queries };
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
    if (comptime @import("genz_options").generated_analysis) return @import("queries.zig").read(self.queries[@backingInt(id)], .Represented);

    return switch (program.typeOf(id)) {
        .optional => |child| self.represented(program, child),
        else => self.selected[@backingInt(id)],
    };
}

pub fn inlineRows(self: Self, program: ir.Program, id: ir.TypeId) bool {
    if (comptime @import("genz_options").generated_analysis) return @import("queries.zig").read(self.queries[@backingInt(id)], .InlineRows);

    return switch (program.typeOf(id)) {
        .list => |child| program.typeOf(child) == .object and self.selected[@backingInt(child)],
        .optional => |child| self.inlineRows(program, child),
        .object => |fields| found: {
            if (!self.selected[@backingInt(id)]) break :found false;

            for (0..fields.len) |index| if (self.inlineRows(program, fields.at(index).type_id)) break :found true;

            break :found false;
        },
        .tuple => |items| found: {
            if (!self.selected[@backingInt(id)]) break :found false;
            for (0..items.len) |index| if (self.inlineRows(program, items.at(index))) break :found true;

            break :found false;
        },
        else => false,
    };
}

pub fn referenced(self: Self, id: ir.TypeId) bool {
    const index = @backingInt(id);

    return index < self.borrowed.len and self.borrowed[index];
}

pub fn name(self: Self, allocator: std.mem.Allocator, id: ir.TypeId, base: []const u8) std.mem.Allocator.Error![]const u8 {
    var hash = @import("zx").Sha256.init(.{});

    hash.update(base);
    hash.update(&.{0});
    hash.update(&self.keys[@backingInt(id)]);

    return std.fmt.allocPrint(allocator, "value_{x}", .{hash.finalResult()});
}

pub fn nested(self: Self, program: ir.Program, id: ir.TypeId) bool {
    if (comptime @import("genz_options").generated_analysis) return @import("queries.zig").read(self.queries[@backingInt(id)], .Nested);

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

pub fn mark(program: ir.Program, boxed: []bool, id: ir.TypeId) void {
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
