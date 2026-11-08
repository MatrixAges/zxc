const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const conversion = @import("conversion_emission.zig");
const querying = @import("generated_state_element_query");
const Query = std.meta.Child(querying.Input);
const Facts = std.meta.Child(@FieldType(Query, "source"));
const Operation = @FieldType(Query, "operation");
const Decision = @typeInfo(@typeInfo(@TypeOf(querying.executeValue)).@"fn".return_type.?).error_union.payload;

pub fn selected(self: *const Lower, list: ir.TypeId) bool {
    const entry = @import("generated_state_inline_stored");
    const Input = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const input: Input = .{ .types = &types, .selected = self.state_plan.selected, .element_storage = self.state_plan.element_storage, .list = @backingInt(list) };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch @panic("invalid inline element query");
}

pub fn elementType(self: *Lower, list: ir.TypeId) Lower.Error!node.ExpressionId {
    const decision = choice(self, list, .Type, false);

    const table = switch (decision.table) {
        .Abi => self.abi_types,
        .Layout => self.abi_layouts,
        .State => self.state_types,
    };

    return @import("../types.zig").get(self, table, @fromBackingInt(decision.type_id));
}

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId, operation: Operation) Lower.Error!node.ExpressionId {
    const decision = choice(self, list, operation, false);

    if (decision.passthrough) return value;

    return (try execute(self, body, decision, value, &.{})).value;
}

pub fn capture(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, symbol: ir.SymbolId) Lower.Error![]const u8 {
    const decision = choice(self, list, .Capture, self.used[@backingInt(symbol)]);

    if (decision.discard) return decision.discard_name;

    const name = self.names[@backingInt(symbol)];

    if (decision.passthrough) return name;

    return (try execute(self, body, decision, @fromBackingInt(0), name)).name;
}

fn choice(self: *const Lower, list: ir.TypeId, operation: Operation, used: bool) Decision {
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);

    const facts: Facts = .{
        .types = &types,
        .queries = zx.columns.slice(@FieldType(Facts, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .root = @backingInt(list),
        .mode = .Value,
    };

    const input: Query = .{ .source = &facts, .operation = operation, .active = self.state_active, .used = used };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(querying.executeValue, fixed.allocator(), &input) catch @panic("invalid element query");
}

const Result = struct { value: node.ExpressionId, name: []const u8 };

fn execute(self: *Lower, body: *std.ArrayList(node.Statement), decision: Decision, value: node.ExpressionId, name: []const u8) Lower.Error!Result {
    const entry = @import("generated_state_element_emit");
    const Input = std.meta.Child(entry.Input);
    const Choice = std.meta.Child(@FieldType(Input, "choice"));
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = buffered.allocator();
    var boundary: conversion.Capture = undefined;

    const capture_value = if (self.capture) |capture_value| boundary: {
        boundary = .{ .name = capture_value.name, .label = capture_value.label, .failure = @backingInt(capture_value.failure) };

        break :boundary &boundary;
    } else null;

    const common = if (!decision.stored) try prepare(self, allocator, decision, value, capture_value) else null;
    const layout = if (decision.stored) try @import("../types.zig").get(self, self.state_types, @fromBackingInt(decision.type_id)) else null;
    const choice_value = zx.columns.view(Choice, decision);
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("list_emission.zig").borrow(self));

    const input: Input = .{
        .choice = &choice_value,
        .conversion = if (common) |*prepared| prepared else null,
        .ast = &ast,
        .layout = if (layout) |id| @backingInt(id) else 0,
        .value = @backingInt(value),
        .name = name,
        .capture = capture_value,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const output = entry.executeIn(allocator, &input) catch |err| return failure(err);
    var prefix: std.ArrayList(node.Statement) = .empty;
    const target = if (decision.capture) &prefix else body;
    const result = try conversion.apply(self, target, target, output.result);

    if (decision.capture) try body.insertSlice(self.allocator, 0, prefix.items);

    return .{ .value = result, .name = if (decision.capture) try self.allocator.dupe(u8, output.name) else name };
}

fn prepare(self: *Lower, allocator: std.mem.Allocator, decision: Decision, value: node.ExpressionId, capture_value: ?*const conversion.Capture) Lower.Error!conversion.Input {
    const entry = @import("generated_state_conversion_plan");
    const Input = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .types = &types,
        .queries = zx.columns.slice(@FieldType(Input, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .root = decision.type_id,
        .mode = decision.mode,
    };

    const plan = entry.executeIn(allocator, &input) catch |err| return failure(err);

    return conversion.prepare(self, allocator, plan, value, capture_value);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid element emission"),
    };
}
