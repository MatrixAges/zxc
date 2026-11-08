const std = @import("std");
const ir = @import("zx").ir;
const calls = @import("../entry_flags/seed.zig").callsWithin;
const parallel = @import("../entry_flags/seed.zig").parallel;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const summary = try analyze(allocator, program);

    allocator.free(summary.pure);
    allocator.free(summary.local);
    allocator.free(summary.state.selected);
    allocator.free(summary.state.borrowed);
    allocator.free(summary.state.keys);
    allocator.free(summary.state.queries);
    allocator.free(summary.state.element_storage);

    return summary.values;
}

pub const Summary = struct { pure: []bool, local: []bool, values: []bool, state: @import("../state_value/analysis.zig") };

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Summary {
    return analyzeExported(allocator, program, &.{});
}

pub fn analyzeExported(allocator: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId) std.mem.Allocator.Error!Summary {
    const pure = try allocator.alloc(bool, program.functions.count());

    errdefer allocator.free(pure);

    const local = try allocator.alloc(bool, program.functions.count());

    errdefer allocator.free(local);

    const eligible = try allocator.alloc(bool, program.functions.count());

    errdefer allocator.free(eligible);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);
        pure[index] = isPure(program, function, pure[0..index]);
        local[index] = if (function.external != null) @import("../native_value.zig").isolated(program, function) else function.stores.count() == 0 and !parallel(function.body.block()) and calls(function.expressions, function.contracts, local[0..index], index);
    }

    const state = try @import("../state_value/analysis.zig").create(allocator, program, local, exported);

    errdefer allocator.free(state.selected);
    errdefer allocator.free(state.borrowed);
    errdefer allocator.free(state.keys);
    errdefer allocator.free(state.queries);
    errdefer allocator.free(state.element_storage);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        eligible[index] = local[index] and (program.typeOf(function.output_type) == .object or (function.external == null and (state.represented(program, function.output_type) or state.inlineRows(program, function.input_type))));
    }

    return .{ .pure = pure, .local = local, .values = eligible, .state = state };
}

/// Which functions are pure, without the value-state facts `analyze` also derives.
pub fn pureFunctions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const pure = try allocator.alloc(bool, program.functions.count());

    for (pure, 0..) |*target, index| target.* = isPure(program, program.functions.at(index), pure[0..index]);

    return pure;
}

/// Whether `function` is pure, given whether each function before it is.
fn isPure(program: ir.Program, function: ir.Function, before: []const bool) bool {
    if (function.external != null) return @import("../native_value.zig").valueBoundary(program, function);

    return function.stores.count() == 0 and !parallel(function.body.block()) and calls(function.expressions, function.contracts, before, before.len);
}

pub fn sharesAggregate(program: ir.Program, input: ir.TypeId, output: ir.TypeId) bool {
    if (@import("genz_options").generated_analysis) return @import("relations.zig").shared(program, input, output);

    const value = program.typeOf(input);

    if ((value == .object or value == .tuple) and contains(program, output, input)) return true;

    return switch (value) {
        .optional, .list => |child| sharesAggregate(program, child, output),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (sharesAggregate(program, fields.at(index).type_id, output)) break :blk true;

            break :blk false;
        },
        .tuple => |children| blk: {
            for (0..children.len) |index| if (sharesAggregate(program, children.at(index), output)) break :blk true;

            break :blk false;
        },
        else => false,
    };
}

pub fn containsDescendant(program: ir.Program, parent: ir.TypeId, root: ir.TypeId) bool {
    if (@import("genz_options").generated_analysis) return @import("relations.zig").descendant(program, parent, root);

    return switch (program.typeOf(parent)) {
        .optional, .list => |child| contains(program, child, root),
        .tuple => |children| blk: {
            for (0..children.len) |view_index| {
                const child = children.at(view_index);

                if (contains(program, child, root)) break :blk true;
            }

            break :blk false;
        },
        .object => |fields| blk: {
            for (0..fields.len) |item_index| {
                const field = fields.at(item_index);

                if (contains(program, field.type_id, root)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}

fn contains(program: ir.Program, child: ir.TypeId, root: ir.TypeId) bool {
    return child == root or containsDescendant(program, child, root);
}
