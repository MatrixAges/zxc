const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .list, .child = zx_shape_0, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .list, .child = zx_shape_6, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .list, .child = zx_shape_8, };
const zx_shape_10 = .{ .kind = .scalar, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_12 = .{ .kind = .scalar, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_12, };
const zx_shape_14 = .{ .kind = .optional, .child = zx_shape_0, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_14, };
const zx_shape_16 = .{ .kind = .string, };
const zx_shape_17 = .{ .kind = .list, .child = zx_shape_16, };
const zx_shape_18 = .{ .kind = .scalar, };
const zx_shape_19 = .{ .kind = .list, .child = zx_shape_18, };
const zx_shape_20 = .{ .kind = .scalar, };
const zx_shape_21 = .{ .kind = .list, .child = zx_shape_20, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .awaits = zx_shape_1, .binary_left = zx_shape_1, .binary_operators = zx_shape_3, .binary_right = zx_shape_1, .booleans = zx_shape_5, .call_arguments = zx_shape_1, .call_functions = zx_shape_1, .call_store_count = zx_shape_1, .call_store_first = zx_shape_1, .call_stores = zx_shape_1, .cancellations = zx_shape_1, .captures = zx_shape_1, .collection_arguments = zx_shape_1, .collection_count = zx_shape_1, .collection_first = zx_shape_1, .collection_kinds = zx_shape_7, .collection_targets = zx_shape_1, .conditional_conditions = zx_shape_1, .conditional_no = zx_shape_1, .conditional_yes = zx_shape_1, .enumerations = zx_shape_1, .errors = zx_shape_1, .floats = zx_shape_9, .index_targets = zx_shape_1, .index_values = zx_shape_1, .integers = zx_shape_11, .iteration_bodies = zx_shape_1, .iteration_condition_parameters = zx_shape_1, .iteration_conditions = zx_shape_1, .iteration_initials = zx_shape_1, .iteration_parameters = zx_shape_1, .iteration_postconditions = zx_shape_5, .kinds = zx_shape_13, .lengths = zx_shape_1, .match_conditions = zx_shape_1, .match_count = zx_shape_1, .match_fallbacks = zx_shape_1, .match_first = zx_shape_1, .match_results = zx_shape_1, .match_subjects = zx_shape_15, .negative_integers = zx_shape_11, .object_count = zx_shape_1, .object_evaluation_count = zx_shape_1, .object_evaluation_first = zx_shape_1, .object_evaluation_values = zx_shape_1, .object_field_indices = zx_shape_1, .object_field_values = zx_shape_1, .object_first = zx_shape_1, .optional_values = zx_shape_1, .parallel_count = zx_shape_1, .parallel_fields = zx_shape_15, .parallel_first = zx_shape_1, .parallel_tasks = zx_shape_1, .payloads = zx_shape_1, .projection_indices = zx_shape_1, .projection_targets = zx_shape_1, .references = zx_shape_1, .scope_borrows = zx_shape_5, .scope_count = zx_shape_1, .scope_first = zx_shape_1, .scope_results = zx_shape_1, .scope_symbols = zx_shape_15, .scope_values = zx_shape_1, .sequence_count = zx_shape_1, .sequence_first = zx_shape_1, .sequence_items = zx_shape_1, .some = zx_shape_1, .span_end = zx_shape_11, .span_start = zx_shape_11, .stores = zx_shape_1, .strings = zx_shape_17, .task_bodies = zx_shape_1, .task_capture_count = zx_shape_1, .task_capture_first = zx_shape_1, .task_captures = zx_shape_1, .transform_bodies = zx_shape_1, .transform_count = zx_shape_1, .transform_first = zx_shape_1, .transform_initials = zx_shape_15, .transform_kinds = zx_shape_19, .transform_parameters = zx_shape_1, .transform_targets = zx_shape_1, .types = zx_shape_1, .unary_operands = zx_shape_1, .unary_operators = zx_shape_21, .update_indices = zx_shape_1, .update_targets = zx_shape_1, .update_values = zx_shape_1, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .expressions = zx_shape_22, .root = zx_shape_0, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .code = zx_shape_16, .end = zx_shape_10, .message = zx_shape_16, .start = zx_shape_10, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .boolean = zx_shape_4, .enumeration = zx_shape_0, .floating = zx_shape_8, .integer = zx_shape_10, .kind = zx_shape_12, .negative = zx_shape_4, .text = zx_shape_16, .type_id = zx_shape_0, }, };
const zx_shape_26 = .{ .kind = .optional, .child = zx_shape_25, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .diagnostic = zx_shape_24, .value = zx_shape_26, }, };
pub const input_shape = zx_shape_23;
pub const output_shape = zx_shape_27;
pub const Input = *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a;
pub const Output = *const (zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 {
    @setRuntimeSafety(true);

    return block_7: {
        const operand_1 = in;
        const operand_2 = (try (@import("zxc_module_edfd93588dbf88845f7b9e74df31429eb8e250b8a95090b2bdb51b6621a45210.zig")).callValue(allocator, operand_1));

        break :block_7 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8));

            (operand_5).* = (zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8{ .diagnostic = (if ((((operand_2).diagnostic).zx_origin != null)) ((operand_2).diagnostic).zx_origin.? else block_4: {
                const operand_3 = (try (allocator).create((zx_abi).zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e));

                (operand_3).* = (zx_abi).zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e{ .code = ((operand_2).diagnostic).code, .end = ((operand_2).diagnostic).end, .message = ((operand_2).diagnostic).message, .start = ((operand_2).diagnostic).start, };

                break :block_4 @as(*const (zx_abi).zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, operand_3);
            }), .value = (operand_2).value, };

            break :block_6 @as(*const (zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8, operand_5);
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 {
    return executeIn((arena).allocator(), in);
}

pub fn executeValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5 {
    @setRuntimeSafety(true);

    return block_8: {
        break :block_8 (try (@import("zxc_module_edfd93588dbf88845f7b9e74df31429eb8e250b8a95090b2bdb51b6621a45210.zig")).callValue(allocator, in));
    };
}

