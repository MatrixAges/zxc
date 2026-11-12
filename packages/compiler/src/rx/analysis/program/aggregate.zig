const std = @import("std");
const ir = @import("zx").ir;
const Builder = @import("builder.zig");
const Mapping = @import("mapping.zig");
const operands = @import("linking/operands.zig");
const Storage = ir.ExpressionStorage;
const Kind = std.meta.Child(@FieldType(ir.ExpressionTable, "kinds"));
const Value = @FieldType(ir.ExpressionRow, "value");
const collections = Storage.collection_payload;
const aggregates = Storage.aggregate_payload;

pub fn append(builder: *Builder, mapping: *const Mapping, row: ir.ExpressionRow) Builder.Error!ir.ExprId {
    const storage = &builder.expressions;

    try storage.reserveRow(builder.allocator, row);

    const kind: Kind, const payload: usize = switch (row.value) {
        .list => |items| .{ .List, try sequence(storage, mapping, items) },
        .tuple => |items| .{ .Tuple, try sequence(storage, mapping, items) },
        .template => |items| .{ .Template, try sequence(storage, mapping, items) },
        .list_operation => |operation| .{ .ListOperation, try collection(storage, mapping, operation) },
        .transform => |operation| .{ .Transform, try transform(storage, mapping, operation) },
        .scope => |value| .{ .Scope, try scope(storage, mapping, value) },
        .match_expr => |value| .{ .Match, try match(storage, mapping, value) },
        .object => |value| .{ .Object, try object(storage, mapping, value) },
        else => unreachable,
    };

    return @fromBackingInt(storage.appendHeader(kind, payload, row.type_id, row.span));
}

fn sequence(storage: *Storage, mapping: *const Mapping, source: []const ir.ExprId) Builder.Error!usize {
    try expressions(mapping, @ptrCast(source), &storage.sequence_items);

    const payload = collections.sequenceHeader(storage, source.len);

    storage.sequence_items.items.len += source.len;

    return payload;
}

fn collection(storage: *Storage, mapping: *const Mapping, source: @FieldType(Value, "list_operation")) Builder.Error!usize {
    const target = try mapping.id(source.target);

    try expressions(mapping, @ptrCast(source.arguments), &storage.collection_arguments);

    const payload = collections.collectionHeader(storage, source.kind, target, source.arguments.len);
    storage.collection_arguments.items.len += source.arguments.len;

    return payload;
}

fn transform(storage: *Storage, mapping: *const Mapping, source: ir.Transform) Builder.Error!usize {
    var mapped = source;

    mapped.target = try mapping.id(source.target);
    mapped.body = try mapping.id(source.body);
    mapped.initial = if (source.initial) |id| try mapping.id(id) else null;

    try operands.symbols(mapping, @ptrCast(source.parameters), storage.transform_parameters.unusedCapacitySlice()[0..source.parameters.len]);

    const payload = collections.transformHeader(storage, mapped);

    storage.transform_parameters.items.len += source.parameters.len;

    return payload;
}

fn scope(storage: *Storage, mapping: *const Mapping, source: @FieldType(Value, "scope")) Builder.Error!usize {
    const result = try mapping.id(source.result);
    const bindings = source.bindings;

    try operands.optionalSymbols(mapping, bindings.symbols, storage.scope_symbols.unusedCapacitySlice()[0..bindings.len]);
    try expressions(mapping, bindings.values, &storage.scope_values);

    const payload = aggregates.scopeHeader(storage, result, bindings.len);

    storage.scope_symbols.items.len += bindings.len;
    storage.scope_values.items.len += bindings.len;

    storage.scope_borrows.appendSliceAssumeCapacity(bindings.borrows);

    return payload;
}

fn match(storage: *Storage, mapping: *const Mapping, source: @FieldType(Value, "match_expr")) Builder.Error!usize {
    const subject = if (source.subject) |id| try mapping.id(id) else null;
    const fallback = try mapping.id(source.fallback);
    const arms = source.arms;

    try expressions(mapping, arms.conditions, &storage.match_conditions);
    try expressions(mapping, arms.results, &storage.match_results);

    const payload = aggregates.matchHeader(storage, subject, fallback, arms.len);
    storage.match_conditions.items.len += arms.len;
    storage.match_results.items.len += arms.len;

    return payload;
}

fn object(storage: *Storage, mapping: *const Mapping, source: @FieldType(Value, "object")) Builder.Error!usize {
    const fields = source.fields;

    try expressions(mapping, fields.values, &storage.object_field_values);
    try expressions(mapping, @ptrCast(source.evaluation), &storage.object_evaluation_values);

    const payload = aggregates.objectHeader(storage, fields.len, source.evaluation.len);

    storage.object_field_indices.appendSliceAssumeCapacity(fields.indices);

    storage.object_field_values.items.len += fields.len;
    storage.object_evaluation_values.items.len += source.evaluation.len;

    return payload;
}

fn expressions(mapping: *const Mapping, source: []const u32, storage: *std.ArrayList(u32)) Builder.Error!void {
    return operands.expressions(mapping, source, storage.unusedCapacitySlice()[0..source.len]);
}
