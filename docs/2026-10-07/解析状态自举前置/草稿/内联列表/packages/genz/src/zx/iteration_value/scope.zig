const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Context, scope: ir.Scope) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    defer for (symbols.items) |symbol| {
        _ = self.symbols.remove(symbol);
    };

    for (scope.bindings) |binding| if (binding.symbol) |symbol| {
        if (!self.represented(lowering.program.symbols[@backingInt(symbol)].type_id) or self.symbols.contains(symbol)) continue;
        try symbols.append(lowering.allocator, symbol);
        try self.symbols.put(lowering.allocator, symbol, {});
    };

    const result = try lowering.expr(scope.result);
    const statements = try lowering.allocator.alloc(?node.Statement, scope.bindings.len);
    var offset = scope.bindings.len;

    while (offset > 0) {
        offset -= 1;
        const binding = scope.bindings[offset];

        if (binding.symbol) |symbol| {
            if (!lowering.used[@backingInt(symbol)] and lowering.program.expression(binding.value).value == .reference) {
                statements[offset] = null;

                continue;
            }
        }

        const value = try lowering.expr(binding.value);

        if (binding.symbol) |symbol| {
            const index = @backingInt(symbol);

            statements[offset] = if (lowering.used[index]) .{ .constant = .{
                .name = lowering.names[index],
                .type_expr = try @import("types.zig").get(self, lowering.program.symbols[index].type_id),
                .value = value,
            } } else .{ .discard = value };
        } else statements[offset] = .{ .expression = value };
    }

    var body: std.ArrayList(node.Statement) = .empty;

    for (statements) |statement| if (statement) |value| try body.append(lowering.allocator, value);

    return @import("../aggregate.zig").finish(lowering, &body, result);
}
