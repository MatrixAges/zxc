const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("lower.zig");

pub fn flat(lowering: *const @import("lower.zig"), id: ir.TypeId) bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/types_seed.zig").flat(lowering.program, id);

    return @import("iteration_layout/generated.zig").query(lowering.layout_types[@backingInt(id)], .Flat);
}

pub fn aggregate(lowering: *const @import("lower.zig"), id: ir.TypeId) bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/types_seed.zig").aggregate(lowering.program, id);

    return @import("iteration_layout/generated.zig").query(lowering.layout_types[@backingInt(id)], .Aggregate);
}

pub fn represented(lowering: *const @import("lower.zig"), id: ir.TypeId) bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/types_seed.zig").represented(lowering.program, id);

    return @import("iteration_layout/generated.zig").query(lowering.layout_types[@backingInt(id)], .Represented);
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

pub fn forwarded(lowering: *const Lower, iteration: ir.Iteration) std.mem.Allocator.Error!?ir.ExprId {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/forwarded_seed.zig").select(lowering, iteration);

    return @import("iteration_layout/generated.zig").forwarded(lowering.allocator, &lowering.program, iteration, lowering.pure_functions, lowering.value_functions);
}

pub fn abi(lowering: *const Lower, iteration: ir.Iteration, type_id: ir.TypeId) std.mem.Allocator.Error!bool {
    if (!@import("genz_options").generated_analysis) {
        return @import("iteration_layout/types_seed.zig").scalarProduct(lowering.program, type_id) and
            try deep(lowering.allocator, lowering.program, iteration, lowering.identity_free_functions);
    }

    return @import("iteration_layout/generated.zig").abi(lowering.allocator, &lowering.program, iteration, type_id, lowering.identity_free_functions);
}

/// `safe` holds the `identity_free.functions` of the program.
pub fn deep(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, safe: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{ iteration.condition, iteration.body }, safe, true, null);
}

/// `safe` holds the `identity_free.functions` of the program.
pub fn initialValue(allocator: std.mem.Allocator, program: ir.Program, value: ir.ExprId, safe: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{value}, safe, true, null);
}

fn analyze(allocator: std.mem.Allocator, program: ir.Program, roots: []const ir.ExprId, functions: []const bool, deep_layout: bool, root: ?ir.TypeId) std.mem.Allocator.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_layout/seed.zig").analyze(allocator, program, roots, functions, deep_layout, root);

    return @import("iteration_layout/generated.zig").analyze(allocator, &program, roots, functions, deep_layout, if (root) |id| .{ .type_id = id, .result = roots[roots.len - 1] } else null);
}

pub fn buffers(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, safe: []const bool, flags: []const @import("uniqueness/root.zig").Flags) std.mem.Allocator.Error!bool {
    if (comptime !@import("genz_options").generated_analysis) return false;

    return @import("iteration_layout/generated.zig").buffers(allocator, &program, iteration, safe, flags);
}
