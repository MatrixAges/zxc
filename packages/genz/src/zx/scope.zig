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

    const analysis = @import("iteration_layout.zig");
    const value_analysis = @import("value_call/analysis.zig");
    const values = @import("value_call/root.zig");
    var stacked: std.ArrayList(ir.SymbolId) = .empty;

    defer for (stacked.items) |symbol| {
        _ = self.stack_symbols.remove(symbol);
    };

    const result_type = self.program.expression(scope.result).type_id;
    const local_root = layout and analysis.aggregate(self, result_type);
    const projected = self.state_active and self.value_output;
    const scoped_locals = self.value_output or (self.entry_flags.scalar and !self.entry_flags.tasks);

    const scalar_entry = !layout and self.entry_flags.scalar and
        @import("types/scalar.zig").check(self.program.types, result_type);

    if ((local_root or projected) and self.projected_symbols == null) self.projected_symbols = try @import("value_call/projections.zig").symbols(self.allocator, self.program);

    if (local_root or projected or scalar_entry or scoped_locals) {
        for (0..scope.bindings.len) |record_index| {
            const binding = scope.bindings.at(record_index);

            if (binding.symbol) |symbol| {
                const type_id = self.program.symbols.at(@backingInt(symbol)).type_id;
                const snapshot = local_root and type_id == result_type;
                const kind = self.program.typeOf(type_id);
                const borrowed_tuple = binding.borrow and kind == .tuple;
                const fresh_scalar = self.entry_flags.scalar and !self.entry_flags.tasks and self.program.expression(binding.value).value == .object;

                const local_aggregate = (self.value_output or fresh_scalar) and (kind == .object or borrowed_tuple) and
                    type_id != result_type and
                    !value_analysis.containsDescendant(self.program, result_type, type_id) and
                    !value_analysis.containsDescendant(self.program, self.program.output_type, type_id);

                if (scalar_entry and kind != .object and !borrowed_tuple) continue;

                if (!snapshot and !scalar_entry and !local_aggregate and
                    !((projected or local_root) and self.projected_symbols.?[@backingInt(symbol)])) continue;

                if (@import("state_value/root.zig").selected(self, type_id)) continue;
                if (!analysis.aggregate(self, type_id) or self.stack_symbols.contains(symbol)) continue;

                const borrowed_alias = binding.borrow and kind == .object and switch (self.program.expression(binding.value).value) {
                    .reference, .field, .tuple_field, .index, .optional_value => true,
                    else => false,
                };

                if (borrowed_alias or try @import("value_call/locals.zig").borrowed(self, symbol, binding.value)) continue;
                try stacked.append(self.allocator, symbol);
                try self.stack_symbols.put(self.allocator, symbol, {});
            }
        }
    }

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

        if (binding.symbol) |symbol| {
            if (!self.used[@backingInt(symbol)] and self.program.expression(binding.value).value == .reference) {
                statements[offset] = &.{};

                continue;
            }
        }

        if (self.program.typeOf(self.program.expression(binding.value).type_id) == .task) {
            try @import("tasks/root.zig").bind(self, &output, self.names[@backingInt(binding.symbol.?)], binding.value, false);

            statements[offset] = try output.toOwnedSlice(self.allocator);

            continue;
        }

        const by_value = if (binding.symbol) |symbol| self.stack_symbols.contains(symbol) else false;
        const borrowed = if (binding.symbol) |symbol| try @import("value_call/locals.zig").optionalCall(self, &output, symbol, binding.value, result_type) else null;
        const value = borrowed orelse if (binding.symbol == null) try @import("iteration.zig").discard(self, binding.value) else if (by_value) try values.expression(self, binding.value) else try self.expr(binding.value);

        if (binding.symbol) |symbol| {
            const index = @backingInt(symbol);

            if (self.used[index]) {
                const declaration: node.Constant = .{
                    .name = self.names[index],
                    .type_expr = if (self.loop_fields != null and self.loop_fields.?.symbol(symbol)) self.loop_fields.?.layout else if (by_value) try self.layoutExpr(self.program.symbols.at(index).type_id) else try self.typeExpr(self.program.symbols.at(index).type_id),
                    .value = value,
                };

                try output.append(self.allocator, if (reuse != null and reuse.?.variables[offset]) .{ .variable = declaration } else .{ .constant = declaration });
            } else try output.append(self.allocator, .{ .discard = value });
        } else try output.append(self.allocator, .{ .discard = value });

        statements[offset] = try output.toOwnedSlice(self.allocator);
    }

    var body: std.ArrayList(node.Statement) = .empty;

    for (statements) |chunk| try body.appendSlice(self.allocator, chunk);

    return @import("aggregate.zig").finish(self, &body, result.?);
}
