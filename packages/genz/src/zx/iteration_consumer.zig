const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Consumer = struct { symbol: ir.SymbolId, result: ir.ExprId, layout: bool = false };

pub fn lower(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId, result: ir.ExprId, layout: bool) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("iteration_consumer/seed.zig").lower(self, symbol, value, result, layout);

    const policy = @import("iteration_consumer/policy.zig");
    const selected: Consumer = .{ .symbol = symbol, .result = result, .layout = layout };
    var phase: policy.Phase = .Initial;

    while (true) switch (try policy.decide(self, selected, value, phase)) {
        .None => return null,
        .Simd => {
            if (try @import("simd/iteration.zig").lower(self, value, selected)) |vector| return vector;

            phase = .AfterSimd;
        },
        .Eligible => {
            if (try @import("iteration.zig").consume(self, value, selected)) |local| return local;

            phase = .Fallback;
        },
        .Consume => return @import("iteration.zig").consume(self, value, selected),
        .Scalar => return @import("iteration.zig").consume(self, value, .{ .symbol = symbol, .result = result }),
    };
}

pub fn projection(program: ir.Program, result: ir.ExprId, symbol: ir.SymbolId) bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_consumer/seed.zig").projection(program, result, symbol);

    return @import("iteration_consumer/policy.zig").projection(&program, result, symbol);
}

pub fn independent(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) bool {
    if (!@import("genz_options").generated_analysis) return @import("iteration_consumer/seed.zig").independent(program, id, symbol);

    return @import("iteration_consumer/policy.zig").independent(&program, id, symbol);
}

pub fn read(self: *Lower, consumer: Consumer, id: ir.ExprId, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const expression = self.program.expression(id);

    return switch (expression.value) {
        .reference => |symbol| if (symbol == consumer.symbol) state else unreachable,
        .field, .tuple_field => |field| value: {
            const target = try read(self, consumer, field.target, state);
            const type_id = self.program.expression(field.target).type_id;
            const kind = self.program.typeOf(type_id);
            const name = if (expression.value == .field) kind.object.at(field.index).name else try std.fmt.allocPrint(self.allocator, "{d}", .{field.index});
            const projected = try self.field(target, name);

            if (!self.state_active or self.state_plan.represented(self.program, type_id)) break :value projected;

            break :value fromAbi(self, expression.type_id, projected);
        },
        .index => |item| value: {
            const projected = try @import("intrinsics.zig").index(self, try @import("state_value/list.zig").items(self, self.program.expression(item.target).type_id, try read(self, consumer, item.target, state)), try self.expr(item.index));

            if (!self.state_active or !self.state_plan.represented(self.program, expression.type_id)) break :value projected;

            var body: std.ArrayList(node.Statement) = .empty;
            const converted = try @import("state_value/elements.zig").read(self, &body, self.program.expression(item.target).type_id, projected);

            break :value @import("aggregate.zig").finish(self, &body, converted);
        },
        .length => |child| self.cast(try self.typeExpr(expression.type_id), try self.field(try @import("state_value/list.zig").items(self, self.program.expression(child).type_id, try read(self, consumer, child, state)), "len")),
        else => unreachable,
    };
}

fn fromAbi(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!self.state_plan.represented(self.program, id)) return value;
    if (self.program.typeOf(id) == .list and !@import("state_value/elements.zig").inlineStored(self, id)) return @import("state_value/list.zig").borrowed(self, id, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try @import("aggregate.zig").bind(self, &body, value);
    const converted = try @import("state_value/conversion.zig").convert(self, &body, id, source, .value);

    return @import("aggregate.zig").finish(self, &body, converted);
}
