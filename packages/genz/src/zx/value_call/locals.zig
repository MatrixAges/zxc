const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const seed = @import("locals_seed.zig");
const generated = @import("genz_options").generated_analysis;

pub fn register(self: *Lower, statements: ir.Block) Lower.Error![]const ir.SymbolId {
    if (!generated) return seed.register(self, statements);

    const entry = @import("generated_value_local_register");
    const Parameter = @typeInfo(@TypeOf(entry.executeState)).@"fn".param_types[1].?;
    const Input = Child(Parameter);
    const Facts = std.meta.Child(@FieldType(Input, "source"));
    const Walk = @FieldType(Input, "state");
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);
    const data = facts(self, Facts, &types);

    const state: Walk = .{
        .index = zx.columns.view(@FieldType(Walk, "index"), self.stack_symbols.current().*),
        .added = .{ .items = &.{}, .storage = .plain },
        .cache = cache(self, @FieldType(Walk, "cache")),
        .position = statements.first,
        .pending = false,
        .symbol = 0,
        .value = 0,
    };

    const input: Input = .{
        .source = &data,
        .control = zx.columns.pointer(@FieldType(Input, "control"), statements.control),
        .first = statements.first,
        .count = statements.len,
        .state = state,
    };

    const output = entry.executeState(self.allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);
    const current = self.stack_symbols.current();

    current.* = zx.columns.view(@TypeOf(current.*), output.index);

    publish(self, output.cache);
    comptime std.debug.assert(@typeInfo(ir.SymbolId).@"enum".tag_type == u32);

    return @as([*]const ir.SymbolId, @ptrCast(output.added.items.ptr))[0..output.added.items.len];
}

pub fn scope(self: *Lower, value: ir.ScopeRow, layout: bool) Lower.Error![]const ir.SymbolId {
    if (!generated) return seed.scope(self, value, layout);

    const creating = @import("generated_value_scope_initialize");
    const Parameter = @typeInfo(@TypeOf(creating.executeState)).@"fn".param_types[1].?;
    const Input = Child(Parameter);
    const Description = Child(@FieldType(Input, "source"));
    const Facts = Child(@FieldType(Description, "source"));
    const types = ir.TypeTable.borrow(Child(@FieldType(Facts, "types")), self.program.types);
    const data = facts(self, Facts, &types);

    const description: Description = .{
        .source = &data,
        .layouts = read(@FieldType(Description, "layouts"), self.layout_types),
        .symbols = read(@FieldType(Description, "symbols"), value.bindings.symbols),
        .values = read(@FieldType(Description, "values"), value.bindings.values),
        .borrows = read(@FieldType(Description, "borrows"), value.bindings.borrows),
        .result = @backingInt(value.result),
        .layout = layout,
    };

    const input: Input = .{
        .source = &description,
        .index = zx.columns.view(@FieldType(Input, "index"), self.stack_symbols.current().*),
        .cache = cache(self, @FieldType(Input, "cache")),
    };

    var state = creating.executeState(self.allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);

    publish(self, state.cache);

    errdefer for (state.added.items) |symbol| {
        _ = self.stack_symbols.remove(@fromBackingInt(symbol));
    };

    const stepping = @import("generated_value_scope_step");
    const StepParameter = @typeInfo(@TypeOf(stepping.executeState)).@"fn".param_types[1].?;
    const Step = Child(StepParameter);
    const step_source = zx.columns.view(Child(@FieldType(Step, "source")), description);

    while (state.phase != .Done) {
        const step: Step = .{ .source = &step_source, .state = state };

        state = stepping.executeState(self.allocator, if (@typeInfo(StepParameter) == .pointer) &step else step) catch |err| return failure(err);

        const current = self.stack_symbols.current();

        current.* = zx.columns.view(@TypeOf(current.*), state.index);

        publish(self, state.cache);
    }

    comptime std.debug.assert(@typeInfo(ir.SymbolId).@"enum".tag_type == u32);

    return @as([*]const ir.SymbolId, @ptrCast(state.added.items.ptr))[0..state.added.items.len];
}

pub fn borrowed(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId) Lower.Error!bool {
    if (!generated) return seed.borrowed(self, symbol, value);

    const entry = @import("generated_value_local_resolve");
    const Parameter = @typeInfo(@TypeOf(entry.executeState)).@"fn".param_types[1].?;
    const Input = Child(Parameter);
    const Facts = std.meta.Child(@FieldType(Input, "source"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);
    const data = facts(self, Facts, &types);

    const input: Input = .{
        .source = &data,
        .cache = cache(self, @FieldType(Input, "cache")),
        .symbol = @backingInt(symbol),
        .value = @backingInt(value),
        .phase = .None,
    };

    const output = entry.executeState(self.allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);

    publish(self, output.cache);

    return output.borrowed;
}

pub fn optionalCall(self: *Lower, body: *std.ArrayList(node.Statement), symbol: ir.SymbolId, value: ir.ExprId, boundary: ir.TypeId) Lower.Error!?node.ExpressionId {
    if (!generated) return seed.optionalCall(self, body, symbol, value, boundary);

    const entry = @import("generated_value_local_optional");
    const Input = std.meta.Child(entry.Input);
    const Facts = std.meta.Child(@FieldType(Input, "source"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);
    const data = facts(self, Facts, &types);
    const Lookup = std.meta.Child(@FieldType(Input, "cache"));
    const cached: Lookup = .{ .count = self.cache.state.count, .metadata = self.cache.state.metadata.items, .keys = self.cache.state.keys.items, .key = @backingInt(value) };
    const flags = self.plan.get(value);

    const input: Input = .{
        .source = &data,
        .cache = &cached,
        .value = @backingInt(value),
        .boundary = @backingInt(boundary),
        .used = self.used[@backingInt(symbol)],
        .normalize = flags.normalize,
        .renew = flags.renew,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const selected = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch |err| return failure(err);

    if (!selected) return null;

    return try @import("root.zig").borrowInvocation(self, body, self.program.expression(value).value.call);
}

fn read(comptime Target: type, values: anytype) Target {
    if (@typeInfo(Target) == .pointer) return zx.columns.slice(Target, values);

    return .{ .items = zx.columns.slice(@FieldType(Target, "items"), values), .storage = .plain };
}

fn cache(self: *const Lower, comptime Cache: type) Cache {
    return .{
        .aliases = if (self.input_aliases) |items| .{ .items = items, .storage = .plain } else null,
        .projected = if (self.projected_symbols) |items| .{ .items = items, .storage = .plain } else null,
    };
}

fn publish(self: *Lower, value: anytype) void {
    self.input_aliases = if (value.aliases) |items| items.items else null;
    self.projected_symbols = if (value.projected) |items| items.items else null;
}

fn facts(self: *const Lower, comptime Facts: type, types: anytype) Facts {
    return .{
        .types = types,
        .expressions = zx.columns.pointer(@FieldType(Facts, "expressions"), &self.program.expressions),
        .symbol_types = self.program.symbols.types,
        .names = self.program.symbols.names,
        .control = zx.columns.pointer(@FieldType(Facts, "control"), self.program.body.control),
        .queries = zx.columns.slice(@FieldType(Facts, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .native_modules = self.program.functions.native_modules,
        .constructed_outputs = self.constructed_outputs,
        .value_functions = self.value_functions,
        .active = self.state_active,
        .value_output = self.value_output,
        .scalar = self.entry_flags.scalar,
        .tasks = self.entry_flags.tasks,
        .output_type = @backingInt(self.program.output_type),
    };
}

fn Child(comptime Value: type) type {
    return if (@typeInfo(Value) == .pointer) std.meta.Child(Value) else Value;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid local value registration"),
    };
}
