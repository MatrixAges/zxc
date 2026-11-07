const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const seed = @import("locals_seed.zig");
const generated = @import("genz_options").generated_analysis;

pub fn statements(self: *Lower, values: ir.Block) Lower.Error![]const ir.SymbolId {
    if (!generated) return seed.statements(self, values);

    const entry = @import("generated_state_locals_statements");
    const data = facts(self, entry);

    const input: Input(entry) = .{
        .facts = &data,
        .index = self.state_symbols.current().*,
        .active = self.state_active,
        .control = zx.columns.pointer(@FieldType(Input(entry), "control"), values.control),
        .first = values.first,
        .count = values.len,
    };

    return apply(self, entry, input);
}

pub fn scope(self: *Lower, value: ir.ScopeRow) Lower.Error![]const ir.SymbolId {
    if (!generated) return seed.scope(self, value);

    const entry = @import("generated_state_locals_scope");
    const data = facts(self, entry);

    const input: Input(entry) = .{
        .facts = &data,
        .index = self.state_symbols.current().*,
        .active = self.state_active,
        .symbols = .{ .items = value.bindings.symbols, .storage = .plain },
    };

    return apply(self, entry, input);
}

pub fn parameters(self: *Lower, value: ir.Transform) Lower.Error![]const ir.SymbolId {
    if (!generated) return seed.parameters(self, value);

    const entry = @import("generated_state_locals_parameters");
    const Elements = Child(@FieldType(Input(entry), "elements"));
    const types = ir.TypeTable.borrow(Child(@FieldType(Elements, "types")), self.program.types);

    const elements: Elements = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .list = @backingInt(self.program.expression(value.target).type_id),
    };

    const data = facts(self, entry);

    const input: Input(entry) = .{
        .facts = &data,
        .index = self.state_symbols.current().*,
        .active = self.state_active,
        .elements = &elements,
        .kind = @fromBackingInt(@backingInt(value.kind)),
        .parameters = .{ .items = @as([*]const u32, @ptrCast(value.parameters.ptr))[0..value.parameters.len], .storage = .plain },
    };

    return apply(self, entry, input);
}

fn facts(self: *Lower, comptime entry: type) Child(@FieldType(Input(entry), "facts")) {
    const Facts = Child(@FieldType(Input(entry), "facts"));

    return .{
        .symbol_types = self.program.symbols.types,
        .queries = zx.columns.slice(@FieldType(Facts, "queries"), self.state_plan.queries),
    };
}

fn apply(self: *Lower, comptime entry: type, input: Input(entry)) Lower.Error![]const ir.SymbolId {
    const Parameter = @typeInfo(@TypeOf(entry.executeState)).@"fn".param_types[1].?;

    const output = entry.executeState(self.allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => @panic("invalid local state registration"),
    };

    self.state_symbols.current().* = output.index;
    comptime std.debug.assert(@typeInfo(ir.SymbolId).@"enum".tag_type == u32);

    return @as([*]const ir.SymbolId, @ptrCast(output.added.items.ptr))[0..output.added.items.len];
}

fn Input(comptime entry: type) type {
    return Child(@typeInfo(@TypeOf(entry.executeState)).@"fn".param_types[1].?);
}

fn Child(comptime Value: type) type {
    return if (@typeInfo(Value) == .pointer) std.meta.Child(Value) else Value;
}
