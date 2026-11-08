const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
pub const Route = enum { Skip, Task, Ordinary };
pub const TypeMode = enum { None, Abi, Layout, LoopLayout };
pub const Plan = struct { kind: @import("std").meta.Tag(node.Statement), type_mode: TypeMode };

pub fn before(self: *const Lower, value: ir.ExprId, symbol: ?ir.SymbolId, scope: bool) Route {
    const expression = self.program.expression(value);

    if (scope) if (symbol) |id| {
        if (!self.used[@backingInt(id)] and expression.value == .reference) return .Skip;
    };

    return if (self.program.typeOf(expression.type_id) == .task) .Task else .Ordinary;
}

pub fn after(self: *const Lower, symbol: ?ir.SymbolId, by_value: bool, scope: bool, mutable: bool) Plan {
    const id = symbol orelse return .{ .kind = .discard, .type_mode = .None };

    if (!self.used[@backingInt(id)]) return .{ .kind = .discard, .type_mode = .None };

    return .{
        .kind = if (mutable) .variable else .constant,
        .type_mode = if (scope and self.loop_fields != null and self.loop_fields.?.symbol(id)) .LoopLayout else if (by_value) .Layout else .Abi,
    };
}
