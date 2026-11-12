const ir = @import("../../ir.zig");
const model = @import("../model.zig");
const Storage = @import("../storage.zig");
const enumeration = @import("../enumeration.zig");

pub fn sequence(self: *Storage, values: []const ir.ExprId) usize {
    const payload = sequenceHeader(self, values.len);

    for (values) |value| self.sequence_items.appendAssumeCapacity(@backingInt(value));

    return payload;
}

pub fn sequenceHeader(self: *Storage, count: usize) usize {
    const payload = self.sequence_first.items.len;

    self.sequence_first.appendAssumeCapacity(@intCast(self.sequence_items.items.len));
    self.sequence_count.appendAssumeCapacity(@intCast(count));

    return payload;
}

pub fn collection(self: *Storage, value: @FieldType(@FieldType(ir.Expression, "value"), "list_operation")) usize {
    const payload = collectionHeader(self, value.kind, value.target, value.arguments.len);

    for (value.arguments) |argument| self.collection_arguments.appendAssumeCapacity(@backingInt(argument));

    return payload;
}

const Collection = @FieldType(@FieldType(ir.Expression, "value"), "list_operation");

pub fn collectionHeader(self: *Storage, kind: @FieldType(Collection, "kind"), target: ir.ExprId, count: usize) usize {
    const payload = self.collection_kinds.items.len;

    self.collection_kinds.appendAssumeCapacity(enumeration.convert(model.CollectionKind, kind));
    self.collection_targets.appendAssumeCapacity(@backingInt(target));
    self.collection_first.appendAssumeCapacity(@intCast(self.collection_arguments.items.len));
    self.collection_count.appendAssumeCapacity(@intCast(count));

    return payload;
}

pub fn transform(self: *Storage, value: ir.Transform) usize {
    const payload = transformHeader(self, value);

    for (value.parameters) |parameter| self.transform_parameters.appendAssumeCapacity(@backingInt(parameter));

    return payload;
}

pub fn transformHeader(self: *Storage, value: ir.Transform) usize {
    const payload = self.transform_kinds.items.len;

    self.transform_kinds.appendAssumeCapacity(enumeration.convert(model.TransformKind, value.kind));
    self.transform_targets.appendAssumeCapacity(@backingInt(value.target));
    self.transform_bodies.appendAssumeCapacity(@backingInt(value.body));
    self.transform_initials.appendAssumeCapacity(if (value.initial) |initial| @backingInt(initial) else null);
    self.transform_first.appendAssumeCapacity(@intCast(self.transform_parameters.items.len));
    self.transform_count.appendAssumeCapacity(@intCast(value.parameters.len));

    return payload;
}
