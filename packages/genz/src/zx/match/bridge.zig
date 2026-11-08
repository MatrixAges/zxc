const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const planning = @import("generated_match_plan");
const Plan = @typeInfo(@typeInfo(@TypeOf(planning.executeValue)).@"fn".return_type.?).error_union.payload;

pub fn plan(self: *Lower, allocator: std.mem.Allocator, selection: ir.MatchRow, layout: bool) Lower.Error!Plan {
    const Input = std.meta.Child(planning.Input);
    const Labels = std.meta.Child(@FieldType(Input, "source"));
    const Expressions = std.meta.Child(@FieldType(Labels, "expressions"));
    const expressions = zx.columns.borrow(Expressions, @as(*const ir.ExpressionTable, &self.program.expressions));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Labels, "types")), self.program.types);

    const labels: Labels = .{
        .expressions = &expressions,
        .types = &types,
        .subject = if (selection.subject) |id| @backingInt(id) else null,
        .conditions = selection.arms.conditions[0..selection.arms.len],
    };

    const input: Input = .{ .source = &labels, .results = selection.arms.results[0..selection.arms.len], .layout = layout };

    return zx.columns.invoke(planning.executeValue, allocator, @as(*const Input, &input)) catch |err| return failure(err);
}

pub fn emit(self: *Lower, allocator: std.mem.Allocator, selected: bool, count: u64, values: []const node.ExpressionId, fallback: node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_match_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);

    const input: Input = .{
        .selected = selected,
        .count = count,
        .values = view.slice(@FieldType(Input, "values"), values),
        .fallback = @backingInt(fallback),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .arm_base = @intCast(self.builder.nodes.arm_columns.count()),
    };

    const output = zx.columns.invoke(generated.executeValue, allocator, @as(*const Input, &input)) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    const arms = zx.columns.view(std.meta.Child(@FieldType(Output, "arms")), output.arms);
    @import("../../node/import_arms.zig").append(self.allocator, &self.builder.nodes.arm_columns, &arms) catch |err| return failure(err);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
