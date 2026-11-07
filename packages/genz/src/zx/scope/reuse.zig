const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const view = @import("../../node/view.zig");
const Self = @This();
const Change = @import("../object_update.zig").Change;

scope: ir.ScopeRow,
changes: []?Change,
variables: []bool,
names: [][]const u8,
pub fn create(lowering: *Lower, scope: ir.ScopeRow) Lower.Error!?Self {
    if (!@import("genz_options").generated_analysis) {
        const result = try @import("reuse/seed.zig").create(lowering, scope);

        return if (result) |plan| .{ .scope = plan.scope, .changes = plan.changes, .variables = plan.variables, .names = plan.names } else null;
    }

    const enabled = @import("generated_scope_reuse_enabled");
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    const flags: std.meta.Child(enabled.Input) = .{
        .state_active = lowering.state_active,
        .bindings = scope.bindings.len,
        .iteration = lowering.iteration_value != null,
        .loop_fields = lowering.loop_fields != null,
    };

    if (!(enabled.executeIn(fixed.allocator(), &flags) catch unreachable)) return null;

    const generated = @import("generated_scope_reuse");
    const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const CandidateParameter = @FieldType(Input, "candidates");
    const candidates_indirect = @typeInfo(CandidateParameter) == .pointer;
    const Candidates = if (candidates_indirect) std.meta.Child(CandidateParameter) else CandidateParameter;
    var facts: std.MultiArrayList(Fact) = .empty;

    defer facts.deinit(lowering.workspace);

    for (0..scope.bindings.len) |index| {
        const binding = scope.bindings.at(index);

        if (binding.symbol == null) continue;

        if (@import("../object_update.zig").match(lowering, binding.value)) |change| {
            try facts.append(lowering.workspace, .{
                .binding = @intCast(index),
                .previous = change.previous,
                .reference = change.reference,
                .field_index = change.field.index,
                .field_value = change.field.value,
                .type_id = change.type_id,
            });
        }
    }

    if (facts.len == 0) return null;

    const candidates: Candidates = .{
        .bindings = facts.items(.binding),
        .previous = view.slice(@FieldType(Candidates, "previous"), facts.items(.previous)),
        .types = view.slice(@FieldType(Candidates, "types"), facts.items(.type_id)),
    };

    const program: *const ir.Program = &lowering.program;

    const input: Input = .{
        .expressions = @import("zx").columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .bindings = scope.bindings.values,
        .symbols = scope.bindings.symbols,
        .symbol_types = program.symbols.types,
        .result = @backingInt(scope.result),
        .candidates = if (candidates_indirect) &candidates else candidates,
    };

    const checking = @import("generated_scope_reuse_has");

    if (!(@import("zx").columns.invoke(checking.executeValue, fixed.allocator(), &input) catch unreachable)) return null;

    const changes = try lowering.allocator.alloc(?Change, scope.bindings.len);
    const variables = try lowering.allocator.alloc(bool, scope.bindings.len);
    const names = try lowering.allocator.alloc([]const u8, scope.bindings.len);
    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);

    defer scratch.deinit();

    const result = generated.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    const plan = result orelse return null;

    @memset(changes, null);
    @memcpy(variables, plan.variables);

    for (0..scope.bindings.len) |index| {
        const binding = scope.bindings.at(index);
        const symbol = binding.symbol orelse continue;

        names[index] = lowering.names[@backingInt(symbol)];

        if (plan.changes[index]) |row| changes[index] = .{
            .previous = facts.items(.previous)[row],
            .reference = facts.items(.reference)[row],
            .field = .{ .index = facts.items(.field_index)[row], .value = facts.items(.field_value)[row] },
            .type_id = facts.items(.type_id)[row],
        };
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

const Fact = struct {
    binding: u32,
    previous: ir.SymbolId,
    reference: ir.ExprId,
    field_index: u32,
    field_value: ir.ExprId,
    type_id: ir.TypeId,
};
