const std = @import("std");
const ir = @import("zx").ir;

pub fn flat(program: ir.Program, id: ir.TypeId) bool {
    const target = program.typeOf(id);

    switch (target) {
        .object => |fields| for (0..fields.len) |view_index| {
            const field = fields.at(view_index);

            if (!leaf(program, field.type_id)) return false;
        },
        .tuple => |items| for (0..items.len) |item_index| {
            const item = items.at(item_index);

            if (!leaf(program, item)) return false;
        },
        else => return false,
    }

    return true;
}

pub fn leaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional, .list => |child| leaf(program, child),
        else => false,
    };
}

pub fn eligible(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{ iteration.condition, iteration.body }, functions, false, null);
}

pub fn shallow(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration) std.mem.Allocator.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/seed.zig").shallow(allocator, program, iteration);

    return @import("iteration_layout/generated.zig").analyze(allocator, &program, &.{ iteration.condition, iteration.body }, &.{}, false, .{ .type_id = program.expression(iteration.initial).type_id, .result = iteration.body });
}

pub fn condition(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{iteration.condition}, functions, false, null);
}

/// `safe` holds the `identity_free.functions` of the program.
pub fn deep(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, safe: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{ iteration.condition, iteration.body }, safe, true, null);
}

/// `safe` holds the `identity_free.functions` of the program.
pub fn initialValue(allocator: std.mem.Allocator, program: ir.Program, value: ir.ExprId, safe: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{value}, safe, true, null);
}

pub fn aggregate(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .object, .tuple => true,
        else => false,
    };
}

pub fn represented(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => |child| represented(program, child),
        else => aggregate(program, id),
    };
}

pub fn supported(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list => true,
        .optional => |child| supported(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |view_index| {
                const field = fields.at(view_index);

                if (!supported(program, field.type_id)) break :blk false;
            }

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |item_index| {
                const item = items.at(item_index);

                if (!supported(program, item)) break :blk false;
            }

            break :blk true;
        },
        else => leaf(program, id),
    };
}

fn analyze(allocator: std.mem.Allocator, program: ir.Program, roots: []const ir.ExprId, functions: []const bool, deep_layout: bool, root: ?ir.TypeId) std.mem.Allocator.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/seed.zig").analyze(allocator, program, roots, functions, deep_layout, root);

    return @import("iteration_layout/generated.zig").analyze(allocator, &program, roots, functions, deep_layout, if (root) |id| .{ .type_id = id, .result = roots[roots.len - 1] } else null);
}
