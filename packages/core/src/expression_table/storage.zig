const std = @import("std");
const model = @import("model.zig");
const Self = @This();

kinds: std.ArrayList(model.ExpressionKind) = .empty,
types: std.ArrayList(u32) = .empty,
span_start: std.ArrayList(u64) = .empty,
span_end: std.ArrayList(u64) = .empty,
payloads: std.ArrayList(u32) = .empty,
integers: std.ArrayList(u64) = .empty,
negative_integers: std.ArrayList(u64) = .empty,
floats: std.ArrayList(f64) = .empty,
strings: std.ArrayList([]const u8) = .empty,
booleans: std.ArrayList(bool) = .empty,
some: std.ArrayList(u32) = .empty,
captures: std.ArrayList(u32) = .empty,
awaits: std.ArrayList(u32) = .empty,
cancellations: std.ArrayList(u32) = .empty,
optional_values: std.ArrayList(u32) = .empty,
enumerations: std.ArrayList(u32) = .empty,
errors: std.ArrayList(u32) = .empty,
references: std.ArrayList(u32) = .empty,
stores: std.ArrayList(u32) = .empty,
lengths: std.ArrayList(u32) = .empty,
sequence_first: std.ArrayList(u32) = .empty,
sequence_count: std.ArrayList(u32) = .empty,
sequence_items: std.ArrayList(u32) = .empty,
projection_targets: std.ArrayList(u32) = .empty,
projection_indices: std.ArrayList(u32) = .empty,
index_targets: std.ArrayList(u32) = .empty,
index_values: std.ArrayList(u32) = .empty,
task_bodies: std.ArrayList(u32) = .empty,
task_capture_first: std.ArrayList(u32) = .empty,
task_capture_count: std.ArrayList(u32) = .empty,
task_captures: std.ArrayList(u32) = .empty,
parallel_first: std.ArrayList(u32) = .empty,
parallel_count: std.ArrayList(u32) = .empty,
parallel_tasks: std.ArrayList(u32) = .empty,
parallel_fields: std.ArrayList(?u32) = .empty,
collection_kinds: std.ArrayList(model.CollectionKind) = .empty,
collection_targets: std.ArrayList(u32) = .empty,
collection_first: std.ArrayList(u32) = .empty,
collection_count: std.ArrayList(u32) = .empty,
collection_arguments: std.ArrayList(u32) = .empty,
transform_kinds: std.ArrayList(model.TransformKind) = .empty,
transform_targets: std.ArrayList(u32) = .empty,
transform_bodies: std.ArrayList(u32) = .empty,
transform_initials: std.ArrayList(?u32) = .empty,
transform_first: std.ArrayList(u32) = .empty,
transform_count: std.ArrayList(u32) = .empty,
transform_parameters: std.ArrayList(u32) = .empty,
scope_results: std.ArrayList(u32) = .empty,
scope_first: std.ArrayList(u32) = .empty,
scope_count: std.ArrayList(u32) = .empty,
scope_symbols: std.ArrayList(?u32) = .empty,
scope_values: std.ArrayList(u32) = .empty,
scope_borrows: std.ArrayList(bool) = .empty,
iteration_initials: std.ArrayList(u32) = .empty,
iteration_condition_parameters: std.ArrayList(u32) = .empty,
iteration_parameters: std.ArrayList(u32) = .empty,
iteration_conditions: std.ArrayList(u32) = .empty,
iteration_bodies: std.ArrayList(u32) = .empty,
iteration_postconditions: std.ArrayList(bool) = .empty,
update_targets: std.ArrayList(u32) = .empty,
update_indices: std.ArrayList(u32) = .empty,
update_values: std.ArrayList(u32) = .empty,
call_functions: std.ArrayList(u32) = .empty,
call_arguments: std.ArrayList(u32) = .empty,
call_store_first: std.ArrayList(u32) = .empty,
call_store_count: std.ArrayList(u32) = .empty,
call_stores: std.ArrayList(u32) = .empty,
unary_operators: std.ArrayList(model.UnaryOperator) = .empty,
unary_operands: std.ArrayList(u32) = .empty,
binary_operators: std.ArrayList(model.BinaryOperator) = .empty,
binary_left: std.ArrayList(u32) = .empty,
binary_right: std.ArrayList(u32) = .empty,
conditional_conditions: std.ArrayList(u32) = .empty,
conditional_yes: std.ArrayList(u32) = .empty,
conditional_no: std.ArrayList(u32) = .empty,
match_subjects: std.ArrayList(?u32) = .empty,
match_fallbacks: std.ArrayList(u32) = .empty,
match_first: std.ArrayList(u32) = .empty,
match_count: std.ArrayList(u32) = .empty,
match_conditions: std.ArrayList(u32) = .empty,
match_results: std.ArrayList(u32) = .empty,
object_first: std.ArrayList(u32) = .empty,
object_count: std.ArrayList(u32) = .empty,
object_field_indices: std.ArrayList(u32) = .empty,
object_field_values: std.ArrayList(u32) = .empty,
object_evaluation_first: std.ArrayList(u32) = .empty,
object_evaluation_count: std.ArrayList(u32) = .empty,
object_evaluation_values: std.ArrayList(u32) = .empty,
pub fn count(self: *const Self) usize {
    return self.kinds.items.len;
}

pub fn at(self: *const Self, index: usize) @import("row.zig").Expression {
    return self.view().at(index);
}

pub const append = @import("append.zig").expression;

pub fn view(self: *const Self) model.Table {
    @setEvalBranchQuota(100_000);

    var result: model.Table = .{};

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!model.Table {
    @setEvalBranchQuota(100_000);

    var result: model.Table = .{};

    errdefer {
        inline for (@typeInfo(model.Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| @field(result, name) = try @field(self, name).toOwnedSlice(allocator);

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    @setEvalBranchQuota(100_000);
    inline for (@typeInfo(model.Table).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
