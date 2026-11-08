const ir = @import("zx").ir;
const Lower = @import("../../lower.zig");
const Route = enum { None, Anchor, Field, Index };
pub const Plan = struct { route: Route, managed_parent: bool = false };
pub const Result = enum { Direct, Borrowed, Value, Element };

pub fn raw(self: *const Lower, id: ir.TypeId, nested: bool) bool {
    if (!self.state_active) return false;
    if (!nested) return self.state_plan.represented(self.program, id) and self.iteration_value == null and self.loop_fields == null and self.program.typeOf(id) == .object;
    if (self.iteration_value != null or self.loop_fields != null) return false;

    const kind = self.program.typeOf(id);

    return kind == .list and self.program.typeOf(kind.list) == .list and @import("../../state_value/elements.zig").inlineStored(self, id);
}

pub fn route(self: *const Lower, id: ir.ExprId) Plan {
    const expression = self.program.expression(id);
    const flags = self.plan.get(id);

    if (flags.normalize or flags.renew) return .{ .route = .None };
    if (!self.state_plan.represented(self.program, expression.type_id)) return .{ .route = .Anchor };
    if (self.cache.contains(id)) return .{ .route = .None };

    return switch (expression.value) {
        .field => .{ .route = .Field },
        .index => .{ .route = .Index, .managed_parent = self.program.typeOf(expression.type_id) == .object },
        else => .{ .route = .None },
    };
}

pub fn value(self: *const Lower, id: ir.ExprId) bool {
    return switch (self.program.expression(id).value) {
        .scope, .iteration, .list_operation => true,
        .call => |invocation| self.value_functions[@backingInt(invocation.function)],
        else => false,
    };
}

pub fn result(self: *const Lower, id: ir.TypeId, target: ir.TypeId, raw_value: bool, field: bool) Result {
    if (!self.state_active or !self.state_plan.represented(self.program, id)) return .Direct;
    if (!field) return if (raw_value) .Value else .Element;
    if (!raw_value and self.state_plan.represented(self.program, target)) return .Direct;
    if (self.program.typeOf(id) == .list and !@import("../../state_value/elements.zig").inlineStored(self, id)) return .Borrowed;

    return .Value;
}
