const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .field_names = zx_shape_14, .field_types = zx_shape_13, .first = zx_shape_13, .kinds = zx_shape_12, .labels = zx_shape_14, .names = zx_shape_14, .second = zx_shape_13, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .base = zx_shape_15, .delta = zx_shape_15, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .names = zx_shape_14, .types = zx_shape_13, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .fields = zx_shape_18, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .second = zx_shape_4, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .id = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .kinds = zx_shape_12, .members = zx_shape_14, .owners = zx_shape_14, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .base = zx_shape_23, .delta = zx_shape_23, }, };
const zx_shape_25 = .{ .kind = .scalar, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_25, }, };
const zx_shape_27 = .{ .kind = .scalar, };
const zx_shape_28 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .origins = zx_shape_28, .status = zx_shape_27, }, };
const zx_shape_30 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .maximum_count = zx_shape_5, .names = zx_shape_14, .origins = zx_shape_23, .roots = zx_shape_30, .scalar_count = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .ids = zx_shape_28, .ready = zx_shape_30, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .pending = zx_shape_32, .table = zx_shape_15, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_0, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_0, }, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .pending = zx_shape_32, .remaining = zx_shape_5, .values = zx_shape_13, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .id = zx_shape_5, .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, .result = zx_shape_5, .valid = zx_shape_1, }, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .pending = zx_shape_32, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_41 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_41, }, };
const zx_shape_43 = .{ .kind = .optional, .child = zx_shape_1, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_43, }, };
const zx_shape_45 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_46 = .{ .kind = .list, .child = zx_shape_45, };
const zx_shape_47 = .{ .kind = .list, .child = zx_shape_13, };
const zx_shape_48 = .{ .kind = .list, .child = zx_shape_14, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .identities = zx_shape_46, .import_names = zx_shape_14, .specifiers = zx_shape_14, .type_ids = zx_shape_47, .type_names = zx_shape_48, .type_namespaces = zx_shape_48, }, };
const zx_shape_50 = .{ .kind = .optional, .child = zx_shape_14, };
const zx_shape_51 = .{ .kind = .optional, .child = zx_shape_4, };
const zx_shape_52 = .{ .kind = .list, .child = zx_shape_51, };
const zx_shape_53 = .{ .kind = .list, .child = zx_shape_50, };
const zx_shape_54 = .{ .kind = .object, .fields = .{ .input_types = zx_shape_13, .native_concurrent = zx_shape_30, .native_errors = zx_shape_53, .native_exports = zx_shape_46, .native_fallible = zx_shape_30, .native_members = zx_shape_48, .native_modules = zx_shape_52, .output_types = zx_shape_13, }, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .modules = zx_shape_49, .table = zx_shape_15, }, };
const zx_shape_56 = .{ .kind = .object, .fields = .{ .functions = zx_shape_54, .index = zx_shape_5, .modules = zx_shape_49, }, };
const zx_shape_57 = .{ .kind = .object, .fields = .{ .modules = zx_shape_49, .request = zx_shape_31, .selected = zx_shape_30, .state = zx_shape_29, }, };
const zx_shape_58 = .{ .kind = .object, .fields = .{ .selected = zx_shape_30, .state = zx_shape_29, }, };
const zx_shape_59 = .{ .kind = .object, .fields = .{ .including = zx_shape_1, .index = zx_shape_5, .member = zx_shape_5, .modules = zx_shape_49, .plan = zx_shape_29, .request = zx_shape_31, .selected = zx_shape_30, }, };
const zx_shape_60 = .{ .kind = .object, .fields = .{ .kinds = zx_shape_12, .scalar_count = zx_shape_5, }, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .scalar_count = zx_shape_5, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_64 = .{ .kind = .object, .fields = .{ .specifiers = zx_shape_14, }, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .modules = zx_shape_49, .request = zx_shape_31, }, };
const zx_shape_66 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_57, }, };
const zx_shape_67 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_57, .@"1" = zx_shape_1, }, };
const zx_shape_68 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_57, .@"1" = zx_shape_1, .@"2" = zx_shape_58, }, };
const zx_shape_69 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, }, };
const zx_shape_70 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_29, }, };
const zx_shape_71 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_29, .@"2" = zx_shape_29, }, };
const zx_shape_72 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_29, .@"2" = zx_shape_29, .@"3" = zx_shape_30, }, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_29, .@"2" = zx_shape_29, .@"3" = zx_shape_30, .@"4" = zx_shape_58, }, };
pub const input_shape = zx_shape_65;
pub const output_shape = zx_shape_58;
pub const Input = *const (zx_abi).zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0;
pub const Output = *const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_54: {
        const operand_51 = (try (@import("zxc_module_9a0e9f3dd47ddf90c346cf557b26e62dd6a20ae0a9eadaa56258fc93c071354e")).callValue(allocator, block_50: {
            const operand_46 = (((in).request).table).kinds;
            const operand_47 = ((in).request).scalar_count;

            break :block_50 block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3));

                (operand_48).* = @as((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3{ .kinds = operand_46, .scalar_count = operand_47, });

                break :block_49 @as(*const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, operand_48);
            };
        }));

        break :block_54 block_53: {
            const operand_52 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_52).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_51);

            break :block_53 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_52);
        };
    };

    const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_45: {
        const operand_35 = block_34: {
            const operand_30 = (in).request;
            const operand_31 = value_1;

            break :block_34 block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748));

                (operand_32).* = @as((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748{ .request = operand_30, .state = operand_31, });

                break :block_33 @as(*const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, operand_32);
            };
        };

        const operand_36 = ((operand_35).state).mapping;
        var transferred_items_37: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_36));
        var transferred_started_38 = true;
        const operand_39 = ((operand_35).state).order;
        var transferred_items_40: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_39));
        var transferred_started_41 = true;
        const operand_42 = ((operand_35).state).origins;
        var transferred_items_43: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_42));
        var transferred_started_44 = true;

        break :block_45 (try (@import("zxc_module_e3b023edff2e8ee09f999f84f8005b9ceee48441326a60ab1a72bd4b15b31ca8")).callBufferedPointer(allocator, operand_35, .{ .lane_0 = .{ .buffer = (&transferred_items_37), .started = (&transferred_started_38), }, .lane_1 = .{ .buffer = (&transferred_items_40), .started = (&transferred_started_41), }, .lane_2 = .{ .buffer = (&transferred_items_43), .started = (&transferred_started_44), }, }));
    };

    const value_3: []const bool = (try (@import("zxc_module_625db3434c47211f6ed3e1a86953de6b7b303899c03606e0ccc48bcd2d517a28")).call(allocator, block_29: {
        const operand_26 = ((in).modules).specifiers;

        break :block_29 block_28: {
            const operand_27 = (try (allocator).create((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990));

            (operand_27).* = @as((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990{ .specifiers = operand_26, });

            break :block_28 @as(*const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, operand_27);
        };
    }));

    const value_4: *const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e = block_25: {
        const operand_8 = block_7: {
            const operand_1 = (in).request;
            const operand_2 = value_2;
            const operand_3 = (in).modules;
            const operand_4 = value_3;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744));

                (operand_5).* = @as((zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744{ .request = operand_1, .state = operand_2, .modules = operand_3, .selected = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, operand_5);
            };
        };

        const operand_9 = (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0{ .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_8).modules).identities, .import_names = ((operand_8).modules).import_names, .specifiers = ((operand_8).modules).specifiers, .type_ids = ((operand_8).modules).type_ids, .type_names = ((operand_8).modules).type_names, .type_namespaces = ((operand_8).modules).type_namespaces, .zx_origin = (operand_8).modules, }, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_8).request).maximum_count, .names = ((operand_8).request).names, .origins = ((operand_8).request).origins, .roots = ((operand_8).request).roots, .scalar_count = ((operand_8).request).scalar_count, .table = ((operand_8).request).table, .zx_origin = (operand_8).request, }, .selected = (operand_8).selected, .state = (operand_8).state, .zx_origin = operand_8, };
        const operand_10 = (operand_9).selected;
        var transferred_items_11: (std).ArrayList(bool) = ((std).ArrayList(bool)).fromOwnedSlice(@constCast(operand_10));
        var transferred_started_12 = true;
        const operand_13 = ((operand_9).state).mapping;
        var transferred_items_14: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_13));
        var transferred_started_15 = true;
        const operand_16 = ((operand_9).state).order;
        var transferred_items_17: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_16));
        var transferred_started_18 = true;
        const operand_19 = ((operand_9).state).origins;
        var transferred_items_20: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_19));
        var transferred_started_21 = true;
        const operand_22 = (try (@import("zxc_module_98ae8699d7dc0062174e9b87caa0effb484c05affd474085bc4a9b359d73dda0")).callBuffered(allocator, operand_9, .{ .lane_0 = .{ .buffer = (&transferred_items_11), .started = (&transferred_started_12), }, .lane_1 = .{ .buffer = (&transferred_items_14), .started = (&transferred_started_15), }, .lane_2 = .{ .buffer = (&transferred_items_17), .started = (&transferred_started_18), }, .lane_3 = .{ .buffer = (&transferred_items_20), .started = (&transferred_started_21), }, }));

        break :block_25 (if (((operand_22).zx_origin != null)) (operand_22).zx_origin.? else block_24: {
            const operand_23 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

            (operand_23).* = (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .selected = (operand_22).selected, .state = (operand_22).state, };

            break :block_24 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_23);
        });
    };

    return value_4;
}

