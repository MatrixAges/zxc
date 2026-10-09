const std = @import("std");
const ir = @import("zx").ir;
const assumption = @import("generated_refinement_assume");
const marking = @import("generated_refinement_mark");
const abi = @import("refinement/abi.zig");
const Buffers = @import("refinement/buffers.zig");
const Self = @This();
const State = abi.Output(assumption);

state: State = .{ .facts = .{ .nonnull = &.{}, .capture_errors = &.{}, .capture_results = &.{} }, .conditions = &.{}, .truths = &.{} },

buffers: Buffers = .{},
pub const Mark = abi.Output(marking);

pub fn mark(self: *const Self) Mark {
    return abi.read(marking, abi.facts(abi.Input(marking), self.state.facts));
}

pub fn restore(self: *Self, saved: Mark) void {
    const generated = @import("generated_refinement_restore");
    const Input = abi.Input(generated);

    const output = abi.read(generated, .{
        .facts = abi.facts(@FieldType(Input, "facts"), self.state.facts),
        .mark = .{ .nonnull = saved.nonnull, .captures = saved.captures },
    });

    self.state.facts = abi.facts(@FieldType(State, "facts"), output);
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.buffers.deinit(allocator);

    self.* = .{};
}

pub fn add(self: *Self, allocator: std.mem.Allocator, symbol: ir.SymbolId) std.mem.Allocator.Error!void {
    const generated = @import("generated_refinement_add");
    const Input = abi.Input(generated);

    try self.updateFacts(allocator, generated, .{ .facts = abi.facts(@FieldType(Input, "facts"), self.state.facts), .symbol = @backingInt(symbol) });
}

pub fn bind(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, value: ir.ExprId, symbols: []const ?ir.SymbolId) std.mem.Allocator.Error!void {
    const generated = @import("generated_refinement_bind");
    const Input = abi.Input(generated);

    try self.updateFacts(allocator, generated, .{
        .facts = abi.facts(@FieldType(Input, "facts"), self.state.facts),
        .expressions = abi.expressions(generated, &expressions),
        .value = @backingInt(value),
        .count = symbols.len,
        .err = if (symbols.len > 0 and symbols[0] != null) @backingInt(symbols[0].?) else null,
        .result = if (symbols.len > 1 and symbols[1] != null) @backingInt(symbols[1].?) else null,
    });
}

pub fn assume(self: *Self, allocator: std.mem.Allocator, expressions: ir.ExpressionTable, condition: ir.ExprId, truth: bool) std.mem.Allocator.Error!void {
    self.state = assumption.executeBuffered(allocator, .{
        .state = self.state,
        .expressions = abi.expressions(assumption, &expressions),
        .condition = @backingInt(condition),
        .truth = truth,
    }, Buffers.arguments(assumption, &self.buffers, "state")) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn typeOf(self: *const Self, types: ir.TypeTable, id: ir.TypeId, symbol: ir.SymbolId) ir.TypeId {
    const generated = @import("generated_refinement_type");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, types);
    const facts = abi.facts(std.meta.Child(@FieldType(Input, "facts")), self.state.facts);
    const input: Input = .{ .facts = &facts, .table = &table, .type_id = @backingInt(id), .symbol = @backingInt(symbol) };

    return @fromBackingInt(abi.read(generated, &input));
}

fn updateFacts(self: *Self, allocator: std.mem.Allocator, comptime generated: type, input: abi.Input(generated)) std.mem.Allocator.Error!void {
    const output = generated.executeBuffered(allocator, input, Buffers.arguments(generated, &self.buffers.facts, "facts")) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    self.state.facts = abi.facts(@FieldType(State, "facts"), output);
}
