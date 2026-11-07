const std = @import("std");
const ir = @import("zx").ir;
const rows = @import("seed_rows.zig");
const minimum_words = 8;
const list_words = 3;
const string_words = 2;
const many_constructions = 2;

/// Initial-seed equivalent of state/borrowing: one construction, managed contents, no escaping type.
pub fn create(allocator: std.mem.Allocator, program: ir.Program, boxed: []const bool) std.mem.Allocator.Error![]bool {
    const count = program.types.count();
    const counts = try allocator.alloc(u32, count);

    defer allocator.free(counts);

    const escaped = try allocator.alloc(bool, count);

    defer allocator.free(escaped);

    const constructed = try allocator.alloc(bool, count);

    defer allocator.free(constructed);

    const words = try allocator.alloc(usize, count);

    defer allocator.free(words);

    const managed = try allocator.alloc(bool, count);

    defer allocator.free(managed);

    @memset(counts, 0);
    @memset(escaped, false);
    rows.mark(program, escaped, program.output_type);

    for (0..program.functions.count()) |index| rows.mark(program, escaped, program.functions.at(index).output_type);

    for (0..count) |index| switch (program.types.at(index)) {
        .list => |child| rows.mark(program, escaped, child),
        .task => |task| rows.mark(program, escaped, task.result),
        else => {},
    };

    scan(program, boxed, program.expressions, program.contracts, counts, escaped, constructed);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        scan(program, boxed, function.expressions, function.contracts, counts, escaped, constructed);
    }

    const borrowed = try allocator.alloc(bool, count);

    for (borrowed, 0..) |*value, index| {
        const kind = program.types.at(index);
        var width: usize = 1;
        var nested = false;

        switch (kind) {
            .scalar => |scalar| width = if (scalar == .string) string_words else if (scalar == .void) 0 else 1,
            .optional => |child| {
                width = words[@backingInt(child)] + 1;
                nested = managed[@backingInt(child)];
            },
            .list => {
                width = list_words;
                nested = true;
            },
            .object => |fields| if (!boxed[index]) {
                for (0..fields.len) |field| {
                    const child = @backingInt(fields.at(field).type_id);

                    width += words[child];
                    nested = nested or managed[child];
                }
            },
            .tuple => |children| if (!boxed[index]) {
                for (0..children.len) |item| {
                    const child = @backingInt(children.at(item));

                    width += words[child];
                    nested = nested or managed[child];
                }
            },
            else => {},
        }

        value.* = kind == .object and !boxed[index] and !escaped[index] and counts[index] == 1 and nested and width >= minimum_words;
        words[index] = if (value.*) 1 else width;
        managed[index] = nested;
    }

    return borrowed;
}

fn scan(program: ir.Program, boxed: []const bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable, counts: []u32, escaped: []bool, constructed: []bool) void {
    @memset(constructed, false);

    var repeated = scanTable(program, boxed, expressions, counts, escaped, constructed);

    for (contracts.expressions) |table| repeated = scanTable(program, boxed, table.*, counts, escaped, constructed) or repeated;

    if (repeated) for (constructed, counts) |found, *value| {
        if (found) value.* = many_constructions;
    };
}

fn scanTable(program: ir.Program, boxed: []const bool, expressions: ir.ExpressionTable, counts: []u32, escaped: []bool, constructed: []bool) bool {
    var repeated = false;

    for (expressions.kinds, expressions.types, expressions.payloads) |kind, id, payload| {
        if (kind == .Object and !boxed[id]) {
            counts[id] = if (counts[id] == 0) 1 else many_constructions;
            constructed[id] = true;
        }

        switch (kind) {
            .Scope => rows.mark(program, escaped, @fromBackingInt(expressions.types[expressions.scope_results[payload]])),
            .Iteration => {
                rows.mark(program, escaped, @fromBackingInt(expressions.types[expressions.iteration_initials[payload]]));

                repeated = true;
            },
            .Transform, .Task, .Parallel => repeated = true,
            else => {},
        }
    }

    return repeated;
}

pub fn elements(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const values = try allocator.alloc(bool, program.types.count());

    @memset(values, false);
    elementUses(program.expressions, values);

    for (0..program.functions.count()) |index| elementUses(program.functions.at(index).expressions, values);

    for (values, 0..) |*value, index| switch (program.types.at(index)) {
        .list => |child| value.* = value.* or (program.typeOf(child) == .list and values[@backingInt(child)]),
        else => {},
    };

    return values;
}

fn elementUses(expressions: ir.ExpressionTable, values: []bool) void {
    for (expressions.update_targets, expressions.update_values) |target, value| {
        if (nestedAppend(expressions, value)) values[expressions.types[target]] = true;
    }
}

fn nestedAppend(expressions: ir.ExpressionTable, initial: u32) bool {
    var value = initial;
    var appended = false;

    while (true) {
        const payload = expressions.payloads[value];

        switch (expressions.kinds[value]) {
            .Scope => value = expressions.scope_results[payload],
            .TupleField => {
                const target = expressions.projection_targets[payload];

                if (expressions.projection_indices[payload] != 0 or expressions.kinds[target] != .ListOperation) return false;

                const operation = expressions.payloads[target];
                const kind = expressions.collection_kinds[operation];

                if (kind != .Push and kind != .Concat) return false;

                appended = true;
                value = expressions.collection_targets[operation];
            },
            .Index => return appended,
            else => return false,
        }
    }
}
