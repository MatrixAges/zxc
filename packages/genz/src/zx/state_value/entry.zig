const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const conversion = @import("conversion_emission.zig");
const advancing = @import("generated_state_entry_advance");
const Parameter = @typeInfo(@TypeOf(advancing.executeState)).@"fn".param_types[1].?;
const Input = Child(Parameter);
const Walk = @FieldType(Input, "state");
const Cache = @import("../expression_map.zig").Map(ir.ExprId);

pub fn lower(self: *Lower, previous: *const Cache) Lower.Error!Cache {
    const Facts = std.meta.Child(@FieldType(Input, "source"));

    const source: Facts = .{
        .count = previous.state.count,
        .metadata = previous.state.metadata.items,
        .keys = previous.state.keys.items,
        .values = previous.state.values.items,
        .types = self.program.expressions.types,
    };

    const empty: Cache = .empty;

    var state: Walk = .{
        .cache = zx.columns.view(@FieldType(Walk, "cache"), empty.state),
        .cursor = 0,
        .complete = false,
        .pending = false,
        .key = 0,
        .value = 0,
        .type_id = 0,
    };

    var converted: ?u32 = null;

    while (true) {
        const input: Input = .{ .source = &source, .state = state, .converted = converted };

        state = advancing.executeState(self.allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);

        if (state.complete) break;

        converted = @backingInt(try emit(self, @fromBackingInt(state.type_id), @fromBackingInt(state.value)));
    }

    return .{ .state = zx.columns.view(@TypeOf(empty.state), state.cache) };
}

fn emit(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const entry = @import("generated_state_entry_emit");
    const EmitInput = std.meta.Child(entry.Input);
    const Context = std.meta.Child(@FieldType(EmitInput, "context"));
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = buffered.allocator();
    var boundary: conversion.Capture = undefined;

    const capture = if (self.capture) |captured| capture: {
        boundary = .{ .name = captured.name, .label = captured.label, .failure = @backingInt(captured.failure) };

        break :capture &boundary;
    } else null;

    const common = if (self.state_plan.represented(self.program, id)) try prepare(self, allocator, id, value, capture) else null;

    const context: Context = .{
        .capture = capture,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: EmitInput = .{ .context = &context, .conversion = if (common) |*prepared| prepared else null, .value = @backingInt(value) };
    const output = entry.executeIn(allocator, &input) catch |err| return failure(err);
    var body: std.ArrayList(node.Statement) = .empty;

    return conversion.apply(self, &body, &body, output);
}

fn prepare(self: *Lower, allocator: std.mem.Allocator, id: ir.TypeId, value: node.ExpressionId, capture: ?*const conversion.Capture) Lower.Error!conversion.Input {
    const entry = @import("generated_state_conversion_plan");
    const PlanInput = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(PlanInput, "types")), self.program.types);

    const input: PlanInput = .{
        .types = &types,
        .queries = zx.columns.slice(@FieldType(PlanInput, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .root = @backingInt(id),
        .mode = .Value,
    };

    const plan = entry.executeIn(allocator, &input) catch |err| return failure(err);

    return conversion.prepare(self, allocator, plan, value, capture);
}

fn Child(comptime Value: type) type {
    return if (@typeInfo(Value) == .pointer) std.meta.Child(Value) else Value;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid state entry conversion"),
    };
}
