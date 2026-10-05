const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, scope: ir.Scope) Lower.Error!*const node.Expression {
    return lowerMode(self, scope, false);
}

pub fn lowerValue(self: *Lower, scope: ir.Scope) Lower.Error!*const node.Expression {
    return lowerMode(self, scope, true);
}

fn lowerMode(self: *Lower, scope: ir.Scope, layout: bool) Lower.Error!*const node.Expression {
    const analysis = @import("iteration_layout.zig");
    const values = @import("value_call/root.zig");
    var stacked: std.ArrayList(ir.SymbolId) = .empty;

    defer for (stacked.items) |symbol| {
        _ = self.stack_symbols.remove(symbol);
    };

    if (layout and analysis.flat(self.program, self.program.expression(scope.result).type_id)) {
        for (scope.bindings) |binding| if (binding.symbol) |symbol| {
            if (!analysis.flat(self.program, self.program.symbols[@backingInt(symbol)].type_id) or self.stack_symbols.contains(symbol)) continue;
            try stacked.append(self.allocator, symbol);
            try self.stack_symbols.put(self.allocator, symbol, {});
        };
    }

    const result = if (layout) try values.expression(self, scope.result) else try self.expr(scope.result);
    const statements = try self.allocator.alloc(?node.Statement, scope.bindings.len);
    var offset = scope.bindings.len;

    while (offset > 0) {
        offset -= 1;
        const binding = scope.bindings[offset];

        if (binding.symbol) |symbol| {
            if (!self.used[@backingInt(symbol)] and self.program.expression(binding.value).value == .reference) {
                statements[offset] = null;

                continue;
            }
        }

        const by_value = if (binding.symbol) |symbol| self.stack_symbols.contains(symbol) else false;
        const value = if (by_value) try values.expression(self, binding.value) else try self.expr(binding.value);

        if (binding.symbol) |symbol| {
            const index = @backingInt(symbol);

            if (self.used[index]) {
                statements[offset] = .{ .constant = .{
                    .name = self.names[index],
                    .type_expr = if (by_value) self.layouts[@backingInt(self.program.symbols[index].type_id)] else self.types[@backingInt(self.program.symbols[index].type_id)],
                    .value = value,
                } };
            } else statements[offset] = .{ .discard = value };
        } else statements[offset] = .{ .expression = value };
    }

    var body: std.ArrayList(node.Statement) = .empty;

    for (statements) |statement| if (statement) |value| try body.append(self.allocator, value);

    return @import("aggregate.zig").finish(self, &body, result);
}
