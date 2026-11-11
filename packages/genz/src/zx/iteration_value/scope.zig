const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");
const recursive_scratch_bytes = 1024;

pub fn lower(self: *Context, scope: ir.ScopeRow) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("scope_seed.zig").lower(self, scope);

    const lowering = self.lowering;
    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [recursive_scratch_bytes]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    var entered: std.ArrayList(ir.SymbolId) = .empty;

    defer for (entered.items) |id| {
        _ = self.symbols.remove(id);
    };

    for (try locals(self, temporary, scope.bindings.symbols)) |raw| {
        const symbol: ir.SymbolId = @fromBackingInt(raw);

        if (self.symbols.contains(symbol)) continue;
        try entered.append(temporary, symbol);
        try self.symbols.put(lowering.allocator, symbol, {});
    }

    const result = try lowering.expr(scope.result);
    const bindings = try prepare(self, temporary, scope);

    return emit(lowering, temporary, result, &bindings);
}

fn locals(self: *const Context, temporary: std.mem.Allocator, symbols: []const ?u32) Lower.Error![]const u32 {
    const entry = @import("generated_iteration_scope_locals");
    const Input = std.meta.Child(entry.Input);
    const lowering = self.lowering;

    const input: Input = .{
        .symbols = symbols,
        .symbol_types = lowering.program.symbols.types,
        .type_kinds = lowering.program.types.kinds,
        .layouts = zx.columns.slice(@FieldType(Input, "layouts"), lowering.layout_types),
        .inline_lists = self.inline_lists,
    };

    return entry.executeIn(temporary, &input) catch |err| return failure(err);
}

const scope_entry = @import("generated_iteration_scope");
const ScopeInput = std.meta.Child(scope_entry.Input);
const Bindings = std.meta.Child(@FieldType(ScopeInput, "bindings"));
const Action = std.meta.Child(@FieldType(Bindings, "actions"));
const binding_entry = @import("generated_iteration_scope_binding");
const BindingInput = std.meta.Child(binding_entry.Input);

fn prepare(self: *Context, temporary: std.mem.Allocator, scope: ir.ScopeRow) Lower.Error!Bindings {
    const lowering = self.lowering;
    const actions = try temporary.alloc(Action, scope.bindings.len);
    const values = try temporary.alloc(u32, scope.bindings.len);
    const types = try temporary.alloc(?u32, scope.bindings.len);
    const names = try temporary.alloc([]const u8, scope.bindings.len);
    var offset = scope.bindings.len;

    while (offset != 0) {
        offset -= 1;
        const binding = scope.bindings.at(offset);
        const symbol = if (binding.symbol) |id| @backingInt(id) else null;

        const first: BindingInput = .{
            .phase = .Before,
            .named = symbol != null,
            .used = if (symbol) |id| lowering.used[id] else false,
            .reference = lowering.program.expressions.kinds[@backingInt(binding.value)] == .Reference,
        };

        types[offset] = null;
        names[offset] = &.{};

        if (classify(first) == .Skip) {
            actions[offset] = .Skip;
            values[offset] = 0;

            continue;
        }

        values[offset] = @backingInt(try lowering.expr(binding.value));

        actions[offset] = classify(.{
            .phase = .After,
            .named = symbol != null,
            .used = if (symbol) |id| lowering.used[id] else false,
            .reference = false,
        });

        if (actions[offset] == .Constant) {
            const id = symbol.?;
            const type_id: ir.TypeId = @fromBackingInt(lowering.program.symbols.types[id]);

            names[offset] = lowering.names[id];
            types[offset] = @backingInt(try @import("types.zig").get(self, type_id));
        }
    }

    return .{ .actions = actions, .values = values, .types = types, .names = names };
}

fn classify(input: BindingInput) Action {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(binding_entry.executeValue, empty.allocator(), &input) catch unreachable;

    return @fromBackingInt(@backingInt(result));
}

noinline fn emit(lowering: *Lower, temporary: std.mem.Allocator, result: node.ExpressionId, bindings: *const Bindings) Lower.Error!node.ExpressionId {
    const input: ScopeInput = .{
        .bindings = bindings,
        .result = @backingInt(result),
        .expression_base = @intCast(lowering.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(lowering.builder.nodes.statements.tags.items.len),
        .serial = lowering.serial,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, temporary);
    const output = scope_entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);
    const block = output.block;

    if (!block.valid) return error.OutOfMemory;

    const name = try lowering.allocator.dupe(u8, block.name);
    const names = [_][]const u8{name};
    var expressions = block.expressions.*;
    var statements = block.statements.*;
    expressions.block_label = &names;
    statements.break_value_label = &names;

    rows.appendBorrowed(lowering.allocator, &lowering.builder.nodes.statements, output.rows) catch |err| return failure(err);
    rows.appendBorrowed(lowering.allocator, &lowering.builder.nodes.statements, &statements) catch |err| return failure(err);
    rows.appendBorrowed(lowering.allocator, &lowering.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    lowering.serial = @intCast(block.serial);

    return @fromBackingInt(block.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
