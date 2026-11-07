const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const reads = @import("reads.zig");
const Self = @This();
const Change = @import("../object_update.zig").Change;

scope: ir.ScopeRow,
changes: []?Change,
variables: []bool,
names: [][]const u8,
pub fn create(lowering: *Lower, scope: ir.ScopeRow) Lower.Error!?Self {
    if (!lowering.state_active or scope.bindings.len < 2 or lowering.iteration_value != null or lowering.loop_fields != null) return null;

    var present = false;

    for (0..scope.bindings.len) |index| if (candidate(lowering, scope.bindings.at(index)) != null) {
        present = true;

        break;
    };

    if (!present) return null;

    var last = try reads.collect(lowering.workspace, &lowering.program, scope);

    defer last.deinit(lowering.workspace);

    var positions: std.AutoHashMapUnmanaged(ir.SymbolId, usize) = .empty;

    defer positions.deinit(lowering.allocator);

    const changes = try lowering.allocator.alloc(?Change, scope.bindings.len);
    const variables = try lowering.allocator.alloc(bool, scope.bindings.len);
    const names = try lowering.allocator.alloc([]const u8, scope.bindings.len);

    @memset(changes, null);
    @memset(variables, false);

    for (0..scope.bindings.len) |index| {
        const binding = scope.bindings.at(index);
        const symbol = binding.symbol orelse continue;

        names[index] = lowering.names[@backingInt(symbol)];

        if (candidate(lowering, binding)) |change| {
            if (positions.get(change.previous)) |previous| {
                if (last.get(change.previous) == index) {
                    changes[index] = change;
                    variables[previous] = true;
                }
            }
        }

        try positions.put(lowering.allocator, symbol, index);
    }

    for (changes, 0..) |change, index| if (change) |update| {
        const symbol = scope.bindings.at(index).symbol.?;

        lowering.names[@backingInt(symbol)] = lowering.names[@backingInt(update.previous)];
    };

    return .{ .scope = scope, .changes = changes, .variables = variables, .names = names };
}

pub fn restore(self: *const Self, lowering: *Lower) void {
    for (0..self.scope.bindings.len) |index| if (self.scope.bindings.at(index).symbol) |symbol| {
        lowering.names[@backingInt(symbol)] = self.names[index];
    };
}

pub fn append(self: *const Self, lowering: *Lower, output: *std.ArrayList(node.Statement), index: usize) Lower.Error!bool {
    const change = self.changes[index] orelse return false;
    const field = lowering.program.typeOf(change.type_id).object.at(change.field.index);
    const value = try @import("../aggregate.zig").bind(lowering, output, try lowering.expr(change.field.value));
    const target = try lowering.builder.identifier(lowering.names[@backingInt(change.previous)]);

    lowering.used[@backingInt(change.previous)] = true;

    try output.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.field(target, field.name), .value = value } });
    try output.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.field(target, try @import("../state_value/origin.zig").name(lowering, change.type_id)), .value = try lowering.builder.expression(.null_value) } });

    return true;
}

fn candidate(lowering: *const Lower, binding: ir.ScopeBinding) ?Change {
    const symbol = binding.symbol orelse return null;
    const change = @import("../object_update.zig").match(lowering, binding.value) orelse return null;

    if (change.previous == symbol) return null;
    if (lowering.program.symbols.at(@backingInt(symbol)).type_id != change.type_id) return null;

    return change;
}
