const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, scope: ir.ScopeRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, scope, false);
}

pub fn lowerValue(self: *Lower, scope: ir.ScopeRow) Lower.Error!node.ExpressionId {
    return lowerMode(self, scope, true);
}

fn lowerMode(self: *Lower, scope: ir.ScopeRow, layout: bool) Lower.Error!node.ExpressionId {
    const state_symbols = try @import("state_value/locals.zig").scope(self, scope);

    defer for (state_symbols) |symbol| {
        _ = self.state_symbols.remove(symbol);
    };

    const values = @import("value_call/root.zig");
    const stacked = try @import("value_call/locals.zig").scope(self, scope, layout);

    defer for (stacked) |symbol| {
        _ = self.stack_symbols.remove(symbol);
    };

    const result_type = self.program.expression(scope.result).type_id;
    const reuse = try @import("scope/reuse.zig").create(self, scope);

    defer if (reuse) |*plan| plan.restore(self);

    var consumed_last = false;
    var result: ?node.ExpressionId = null;

    if (scope.bindings.len != 0) {
        const binding = scope.bindings.at(scope.bindings.len - 1);

        if (binding.symbol) |symbol| {
            result = try @import("iteration_consumer.zig").lower(self, symbol, binding.value, scope.result, layout);
            consumed_last = result != null;
        }
    }

    if (result == null) result = if (layout) try values.expression(self, scope.result) else try self.expr(scope.result);

    const statements = try self.allocator.alloc([]const node.Statement, scope.bindings.len);
    var offset = scope.bindings.len;

    if (consumed_last) {
        offset -= 1;
        statements[offset] = &.{};
    }

    while (offset > 0) {
        offset -= 1;
        const binding = scope.bindings.at(offset);
        var output: std.ArrayList(node.Statement) = .empty;

        if (reuse) |*plan| if (try plan.append(self, &output, offset)) {
            statements[offset] = try output.toOwnedSlice(self.allocator);

            continue;
        };

        const route = @import("binding.zig").before(self, binding.value, binding.symbol, true);

        if (route == .Skip) {
            statements[offset] = &.{};

            continue;
        }

        if (route == .Task) {
            try @import("tasks/root.zig").bind(self, &output, self.names[@backingInt(binding.symbol.?)], binding.value, false);

            statements[offset] = try output.toOwnedSlice(self.allocator);

            continue;
        }

        const by_value = if (binding.symbol) |symbol| self.stack_symbols.contains(symbol) else false;
        const borrowed = if (binding.symbol) |symbol| try @import("value_call/locals.zig").optionalCall(self, &output, symbol, binding.value, result_type) else null;
        const value = borrowed orelse if (binding.symbol == null) try @import("iteration.zig").discard(self, binding.value) else if (by_value) try values.expression(self, binding.value) else try self.expr(binding.value);

        try @import("binding.zig").append(self, &output, .{
            .symbol = binding.symbol,
            .value = value,
            .by_value = by_value,
            .scope = true,
            .mutable = reuse != null and reuse.?.variables[offset],
        });

        statements[offset] = try output.toOwnedSlice(self.allocator);
    }

    var body: std.ArrayList(node.Statement) = .empty;

    for (statements) |chunk| try body.appendSlice(self.allocator, chunk);

    return @import("aggregate.zig").finish(self, &body, result.?);
}
