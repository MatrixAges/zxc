const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");

pub fn paths(self: *Lower, owner: ir.ExprId, iteration: ir.Iteration) Lower.Error![]const bool {
    if (comptime !@import("genz_options").generated_analysis) return &.{};

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    var selected: std.ArrayList([]const u32) = .empty;

    for (self.plan.renewals) |renewal| {
        if (renewal.owner == owner and !renewal.value) try selected.append(scratch.allocator(), renewal.path);
    }

    if (selected.items.len == 0) return &.{};

    const generated = @import("generated_iteration_deferred");
    const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Table = @FieldType(Input, "types");
    const table = ir.TypeTable.borrow(if (@typeInfo(Table) == .pointer) std.meta.Child(Table) else Table, self.program.types);
    const roots = [_]u32{ @backingInt(iteration.condition), @backingInt(iteration.body) };
    const program: *const ir.Program = &self.program;

    const input: Input = .{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .types = if (@typeInfo(Table) == .pointer) &table else table,
        .selected = self.state_plan.selected,
        .referenced = self.state_plan.borrowed,
        .roots = &roots,
        .state_type = @backingInt(self.program.expression(iteration.initial).type_id),
        .paths = selected.items,
    };

    const result = generated.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!result.valid) return &.{};

    return self.allocator.dupe(bool, result.paths);
}
