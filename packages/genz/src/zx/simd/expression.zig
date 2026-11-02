const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Plan = @import("analysis.zig").Plan;

pub fn lower(self: *Lower, plan: Plan, vector_type: ?node.ExpressionId, element: node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_simd_expression");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const literals = try scratch.allocator().alloc(u32, plan.expression.nodes.len);

    @memset(literals, 0);

    for (plan.expression.nodes, literals) |item, *literal| {
        if (item.operation == .Literal) literal.* = @backingInt(try self.expr(@fromBackingInt(item.source)));
    }

    const input = Input{
        .nodes = plan.expression.nodes,
        .literals = literals,
        .element = @backingInt(element),
        .vector_type = if (vector_type) |value| @backingInt(value) else null,
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    @import("../../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, output.table) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(output.root);
}
