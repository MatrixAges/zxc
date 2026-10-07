const ir = @import("../../ir.zig");
const Storage = @import("../storage.zig");

pub fn scope(self: *Storage, value: ir.Scope) usize {
    const payload = self.scope_results.items.len;

    self.scope_results.appendAssumeCapacity(@backingInt(value.result));
    self.scope_first.appendAssumeCapacity(@intCast(self.scope_symbols.items.len));
    self.scope_count.appendAssumeCapacity(@intCast(value.bindings.len));

    for (value.bindings) |binding| {
        self.scope_symbols.appendAssumeCapacity(if (binding.symbol) |symbol| @backingInt(symbol) else null);
        self.scope_values.appendAssumeCapacity(@backingInt(binding.value));
        self.scope_borrows.appendAssumeCapacity(binding.borrow);
    }

    return payload;
}

pub fn call(self: *Storage, value: @FieldType(@FieldType(ir.Expression, "value"), "call")) usize {
    const payload = self.call_functions.items.len;

    self.call_functions.appendAssumeCapacity(@backingInt(value.function));
    self.call_arguments.appendAssumeCapacity(@backingInt(value.argument));
    self.call_store_first.appendAssumeCapacity(@intCast(self.call_stores.items.len));
    self.call_store_count.appendAssumeCapacity(@intCast(value.stores.len));
    self.call_stores.appendSliceAssumeCapacity(value.stores);

    return payload;
}

pub fn match(self: *Storage, value: ir.Match) usize {
    const payload = self.match_subjects.items.len;

    self.match_subjects.appendAssumeCapacity(if (value.subject) |subject| @backingInt(subject) else null);
    self.match_fallbacks.appendAssumeCapacity(@backingInt(value.fallback));
    self.match_first.appendAssumeCapacity(@intCast(self.match_conditions.items.len));
    self.match_count.appendAssumeCapacity(@intCast(value.arms.len));

    for (value.arms) |arm| {
        self.match_conditions.appendAssumeCapacity(@backingInt(arm.condition));
        self.match_results.appendAssumeCapacity(@backingInt(arm.result));
    }

    return payload;
}

pub fn object(self: *Storage, value: @FieldType(@FieldType(ir.Expression, "value"), "object")) usize {
    const payload = self.object_first.items.len;

    self.object_first.appendAssumeCapacity(@intCast(self.object_field_indices.items.len));
    self.object_count.appendAssumeCapacity(@intCast(value.fields.len));

    for (value.fields) |field| {
        self.object_field_indices.appendAssumeCapacity(field.index);
        self.object_field_values.appendAssumeCapacity(@backingInt(field.value));
    }

    self.object_evaluation_first.appendAssumeCapacity(@intCast(self.object_evaluation_values.items.len));
    self.object_evaluation_count.appendAssumeCapacity(@intCast(value.evaluation.len));
    for (value.evaluation) |expression| self.object_evaluation_values.appendAssumeCapacity(@backingInt(expression));

    return payload;
}
