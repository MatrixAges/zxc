const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../../lower.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("seed.zig");
const finishing = @import("generated_projection_result");
pub const Result = if (generated) @typeInfo(@typeInfo(@TypeOf(finishing.executeValue)).@"fn".return_type.?).error_union.payload else seed.Result;

pub fn raw(self: *const Lower, id: ir.TypeId, nested: bool) bool {
    if (!generated) return seed.raw(self, id, nested);

    const entry = @import("generated_projection_raw");
    const Input = std.meta.Child(entry.Input);
    const facts = storage(std.meta.Child(@FieldType(Input, "storage")), self);

    const input: Input = .{
        .storage = &facts,
        .type_id = @backingInt(id),
        .query = @fromBackingInt(@intCast(@backingInt(self.state_plan.queries[@backingInt(id)]))),
        .active = self.state_active,
        .iteration = self.iteration_value != null,
        .loop_fields = self.loop_fields != null,
        .nested = nested,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}

pub fn value(self: *const Lower, id: ir.ExprId) bool {
    if (!generated) return seed.value(self, id);

    const entry = @import("generated_projection_anchor");
    const Input = std.meta.Child(entry.Input);
    const row = @backingInt(id);

    const input: Input = .{
        .kind = @fromBackingInt(@intCast(@backingInt(self.program.expressions.kinds[row]))),
        .value_function = if (self.program.expressions.kinds[row] == .Call) self.value_functions[self.program.expressions.call_functions[self.program.expressions.payloads[row]]] else false,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}

pub fn result(self: *const Lower, id: ir.TypeId, target: ir.TypeId, raw_value: bool, field: bool) Result {
    if (!generated) return seed.result(self, id, target, raw_value, field);

    const Input = std.meta.Child(finishing.Input);
    const facts = storage(std.meta.Child(@FieldType(Input, "storage")), self);

    const input: Input = .{
        .storage = &facts,
        .type_id = @backingInt(id),
        .target = @fromBackingInt(@intCast(@backingInt(self.state_plan.queries[@backingInt(target)]))),
        .result = @fromBackingInt(@intCast(@backingInt(self.state_plan.queries[@backingInt(id)]))),
        .active = self.state_active,
        .raw = raw_value,
        .field = field,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(finishing.executeValue, memory.allocator(), &input) catch unreachable;
}

fn storage(comptime T: type, self: *const Lower) T {
    return .{
        .kinds = self.program.types.kinds,
        .first = self.program.types.first,
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
    };
}
