const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Plan = @import("analysis.zig").Plan;
const rows = @import("../../node/import_rows.zig");

pub fn emit(self: *Lower, plan: Plan) Lower.Error!node.ExpressionId {
    const generated = @import("generated_simd_emit");
    const Input = std.meta.Child(generated.Input);
    const source = try @import("../state_value/list.zig").expression(self, @as(ir.ExprId, @fromBackingInt(plan.candidate.source)));
    const element_type = try self.typeExpr(@fromBackingInt(plan.candidate.scalar));
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const count = plan.expression.nodes.len;
    const literals = try scratch.allocator().alloc(u32, count * 2);

    @memset(literals, 0);

    for ([_][]u32{ literals[0..count], literals[count..] }) |values| {
        for (plan.expression.nodes, values) |item, *value| {
            if (item.operation == .Literal) value.* = @backingInt(try self.expr(@fromBackingInt(item.source)));
        }
    }

    const input = Input{
        .nodes = plan.expression.nodes,
        .uses_element = plan.expression.uses_element,
        .source = @backingInt(source),
        .element_type = @backingInt(element_type),
        .vector_literals = literals[0..count],
        .tail_literals = literals[count..],
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    const output = @import("zx").columns.invoke(generated.executeValue, scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const Expressions = std.meta.Child(@FieldType(std.meta.Child(generated.Output), "expressions"));
    var expressions: Expressions = undefined;

    inline for (@typeInfo(Expressions).@"struct".field_names) |name| {
        @field(expressions, name) = @field(output.expressions, name);
    }

    rows.append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    for (output.statements) |block| {
        rows.append(self.allocator, &self.builder.nodes.statements, block) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidAst => unreachable,
        };
    }

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}
