const std = @import("std");
const Table = @import("model.zig").Table;

pub fn structure(table: Table) bool {
    @setEvalBranchQuota(100_000);

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        if (@field(table, name).len > std.math.maxInt(u32)) return false;
    }

    if (table.kinds.len != table.types.len or table.kinds.len != table.span_start.len or table.kinds.len != table.span_end.len or table.kinds.len != table.payloads.len) return false;
    if (table.sequence_first.len != table.sequence_count.len) return false;
    if (table.projection_targets.len != table.projection_indices.len) return false;
    if (table.index_targets.len != table.index_values.len) return false;
    if (table.task_bodies.len != table.task_capture_first.len or table.task_bodies.len != table.task_capture_count.len) return false;
    if (table.parallel_first.len != table.parallel_count.len) return false;
    if (table.parallel_tasks.len != table.parallel_fields.len) return false;
    if (table.collection_kinds.len != table.collection_targets.len or table.collection_kinds.len != table.collection_first.len or table.collection_kinds.len != table.collection_count.len) return false;
    if (table.transform_kinds.len != table.transform_targets.len or table.transform_kinds.len != table.transform_bodies.len or table.transform_kinds.len != table.transform_initials.len or table.transform_kinds.len != table.transform_first.len or table.transform_kinds.len != table.transform_count.len) return false;
    if (table.scope_results.len != table.scope_first.len or table.scope_results.len != table.scope_count.len) return false;
    if (table.scope_symbols.len != table.scope_values.len or table.scope_symbols.len != table.scope_borrows.len) return false;
    if (table.iteration_initials.len != table.iteration_condition_parameters.len or table.iteration_initials.len != table.iteration_parameters.len or table.iteration_initials.len != table.iteration_conditions.len or table.iteration_initials.len != table.iteration_bodies.len or table.iteration_initials.len != table.iteration_postconditions.len) return false;
    if (table.update_targets.len != table.update_indices.len or table.update_targets.len != table.update_values.len) return false;
    if (table.call_functions.len != table.call_arguments.len or table.call_functions.len != table.call_store_first.len or table.call_functions.len != table.call_store_count.len) return false;
    if (table.unary_operators.len != table.unary_operands.len) return false;
    if (table.binary_operators.len != table.binary_left.len or table.binary_operators.len != table.binary_right.len) return false;
    if (table.conditional_conditions.len != table.conditional_yes.len or table.conditional_conditions.len != table.conditional_no.len) return false;
    if (table.match_subjects.len != table.match_fallbacks.len or table.match_subjects.len != table.match_first.len or table.match_subjects.len != table.match_count.len) return false;
    if (table.match_conditions.len != table.match_results.len) return false;
    if (table.object_first.len != table.object_count.len or table.object_first.len != table.object_evaluation_first.len or table.object_first.len != table.object_evaluation_count.len) return false;
    if (table.object_field_indices.len != table.object_field_values.len) return false;

    for (table.span_start, table.span_end) |start, end| {
        if (start > std.math.maxInt(usize) or end > std.math.maxInt(usize)) return false;
    }

    if (!segments(table.sequence_first, table.sequence_count, table.sequence_items.len)) return false;
    if (!segments(table.task_capture_first, table.task_capture_count, table.task_captures.len)) return false;
    if (!segments(table.parallel_first, table.parallel_count, table.parallel_tasks.len)) return false;
    if (!segments(table.collection_first, table.collection_count, table.collection_arguments.len)) return false;
    if (!segments(table.transform_first, table.transform_count, table.transform_parameters.len)) return false;
    if (!segments(table.scope_first, table.scope_count, table.scope_values.len)) return false;
    if (!segments(table.call_store_first, table.call_store_count, table.call_stores.len)) return false;
    if (!segments(table.match_first, table.match_count, table.match_conditions.len)) return false;
    if (!segments(table.object_first, table.object_count, table.object_field_values.len)) return false;
    if (!segments(table.object_evaluation_first, table.object_evaluation_count, table.object_evaluation_values.len)) return false;

    var counts: [31]usize = @splat(0);
    const lengths = [_]usize{ table.integers.len, table.negative_integers.len, table.floats.len, table.strings.len, table.booleans.len, table.some.len, table.captures.len, table.task_bodies.len, table.awaits.len, table.cancellations.len, table.parallel_first.len, table.optional_values.len, table.enumerations.len, table.errors.len, table.references.len, table.stores.len, table.projection_targets.len, table.index_targets.len, table.lengths.len, table.sequence_first.len, table.collection_kinds.len, table.transform_kinds.len, table.scope_results.len, table.iteration_initials.len, table.update_targets.len, table.call_functions.len, table.unary_operands.len, table.binary_left.len, table.conditional_conditions.len, table.match_subjects.len, table.object_first.len };

    for (table.kinds, table.payloads) |kind, payload| {
        const family: usize = switch (kind) {
            .None, .Unit => {
                if (payload != 0) return false;

                continue;
            },
            .Integer => 0,
            .NegativeInteger => 1,
            .Float => 2,
            .String => 3,
            .Boolean => 4,
            .Some => 5,
            .Capture => 6,
            .Task => 7,
            .AwaitTask => 8,
            .CancelTask => 9,
            .Parallel => 10,
            .OptionalValue => 11,
            .EnumValue => 12,
            .ErrorValue => 13,
            .Reference => 14,
            .StoreGet => 15,
            .Field, .TupleField => 16,
            .Index => 17,
            .Length => 18,
            .List, .Tuple, .Template => 19,
            .ListOperation => 20,
            .Transform => 21,
            .Scope => 22,
            .Iteration => 23,
            .ListUpdate => 24,
            .Call => 25,
            .Unary => 26,
            .Binary => 27,
            .Conditional => 28,
            .Match => 29,
            .Object => 30,
        };

        if (payload != counts[family] or payload >= lengths[family]) return false;

        counts[family] += 1;
    }

    return std.mem.eql(usize, &counts, &lengths);
}

fn segments(first: []const u32, count: []const u32, length: usize) bool {
    var next: usize = 0;

    for (first, count) |start, size| {
        if (start != next or size > length - next) return false;

        next += size;
    }

    return next == length;
}
