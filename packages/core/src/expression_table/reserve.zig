const std = @import("std");
const ir = @import("../ir.zig");
const Storage = @import("storage.zig");

pub fn expression(self: *Storage, allocator: std.mem.Allocator, source: ir.Expression) std.mem.Allocator.Error!void {
    @setEvalBranchQuota(100_000);

    try prepare(self, allocator, &.{ "kinds", "types", "span_start", "span_end", "payloads" }, 1);

    switch (source.value) {
        .none, .unit => {},
        .integer => try prepare(self, allocator, &.{"integers"}, 1),
        .negative_integer => try prepare(self, allocator, &.{"negative_integers"}, 1),
        .float => try prepare(self, allocator, &.{"floats"}, 1),
        .string => try prepare(self, allocator, &.{"strings"}, 1),
        .boolean => try prepare(self, allocator, &.{"booleans"}, 1),
        .some => try prepare(self, allocator, &.{"some"}, 1),
        .capture => try prepare(self, allocator, &.{"captures"}, 1),
        .await_task => try prepare(self, allocator, &.{"awaits"}, 1),
        .cancel_task => try prepare(self, allocator, &.{"cancellations"}, 1),
        .optional_value => try prepare(self, allocator, &.{"optional_values"}, 1),
        .enum_value => try prepare(self, allocator, &.{"enumerations"}, 1),
        .error_value => try prepare(self, allocator, &.{"errors"}, 1),
        .reference => try prepare(self, allocator, &.{"references"}, 1),
        .store_get => try prepare(self, allocator, &.{"stores"}, 1),
        .length => try prepare(self, allocator, &.{"lengths"}, 1),
        .field, .tuple_field => try prepare(self, allocator, &.{ "projection_targets", "projection_indices" }, 1),
        .index => try prepare(self, allocator, &.{ "index_targets", "index_values" }, 1),
        .unary => try prepare(self, allocator, &.{ "unary_operators", "unary_operands" }, 1),
        .binary => try prepare(self, allocator, &.{ "binary_operators", "binary_left", "binary_right" }, 1),
        .conditional => try prepare(self, allocator, &.{ "conditional_conditions", "conditional_yes", "conditional_no" }, 1),
        .iteration => try prepare(self, allocator, &.{ "iteration_initials", "iteration_condition_parameters", "iteration_parameters", "iteration_conditions", "iteration_bodies", "iteration_postconditions" }, 1),
        .list_update => try prepare(self, allocator, &.{ "update_targets", "update_indices", "update_values" }, 1),
        .list, .tuple, .template => |value| {
            try prepare(self, allocator, &.{ "sequence_first", "sequence_count" }, 1);
            try prepare(self, allocator, &.{"sequence_items"}, value.len);
        },
        .task => |value| {
            try prepare(self, allocator, &.{ "task_bodies", "task_capture_first", "task_capture_count" }, 1);
            try prepare(self, allocator, &.{"task_captures"}, value.captures.len);
        },
        .parallel => |value| {
            try prepare(self, allocator, &.{ "parallel_first", "parallel_count" }, 1);
            try prepare(self, allocator, &.{ "parallel_tasks", "parallel_fields" }, value.len);
        },
        .list_operation => |value| {
            try prepare(self, allocator, &.{ "collection_kinds", "collection_targets", "collection_first", "collection_count" }, 1);
            try prepare(self, allocator, &.{"collection_arguments"}, value.arguments.len);
        },
        .transform => |value| {
            try prepare(self, allocator, &.{ "transform_kinds", "transform_targets", "transform_bodies", "transform_initials", "transform_first", "transform_count" }, 1);
            try prepare(self, allocator, &.{"transform_parameters"}, value.parameters.len);
        },
        .scope => |value| {
            try prepare(self, allocator, &.{ "scope_results", "scope_first", "scope_count" }, 1);
            try prepare(self, allocator, &.{ "scope_symbols", "scope_values", "scope_borrows" }, value.bindings.len);
        },
        .call => |value| {
            try prepare(self, allocator, &.{ "call_functions", "call_arguments", "call_store_first", "call_store_count" }, 1);
            try prepare(self, allocator, &.{"call_stores"}, value.stores.len);
        },
        .match_expr => |value| {
            try prepare(self, allocator, &.{ "match_subjects", "match_fallbacks", "match_first", "match_count" }, 1);
            try prepare(self, allocator, &.{ "match_conditions", "match_results" }, value.arms.len);
        },
        .object => |value| {
            try prepare(self, allocator, &.{ "object_first", "object_count", "object_evaluation_first", "object_evaluation_count" }, 1);
            try prepare(self, allocator, &.{ "object_field_indices", "object_field_values" }, value.fields.len);
            try prepare(self, allocator, &.{"object_evaluation_values"}, value.evaluation.len);
        },
    }
}

fn prepare(self: *Storage, allocator: std.mem.Allocator, comptime names: []const []const u8, count: usize) std.mem.Allocator.Error!void {
    inline for (names) |name| {
        const length = @field(self, name).items.len;

        if (length > std.math.maxInt(u32) or count > std.math.maxInt(u32) - length) return error.OutOfMemory;
    }

    inline for (names) |name| try @field(self, name).ensureUnusedCapacity(allocator, count);
}
