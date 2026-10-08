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
const zx_shape_32 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_33 = .{ .kind = .list, .child = zx_shape_32, };
const zx_shape_34 = .{ .kind = .list, .child = zx_shape_13, };
const zx_shape_35 = .{ .kind = .list, .child = zx_shape_14, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .identities = zx_shape_33, .import_names = zx_shape_14, .specifiers = zx_shape_14, .type_ids = zx_shape_34, .type_names = zx_shape_35, .type_namespaces = zx_shape_35, }, };
const zx_shape_37 = .{ .kind = .optional, .child = zx_shape_14, };
const zx_shape_38 = .{ .kind = .optional, .child = zx_shape_4, };
const zx_shape_39 = .{ .kind = .list, .child = zx_shape_38, };
const zx_shape_40 = .{ .kind = .list, .child = zx_shape_37, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .input_types = zx_shape_13, .native_concurrent = zx_shape_30, .native_errors = zx_shape_40, .native_exports = zx_shape_33, .native_fallible = zx_shape_30, .native_members = zx_shape_35, .native_modules = zx_shape_39, .output_types = zx_shape_13, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .modules = zx_shape_36, .table = zx_shape_15, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .functions = zx_shape_41, .index = zx_shape_5, .modules = zx_shape_36, }, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .modules = zx_shape_36, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .ids = zx_shape_28, .ready = zx_shape_30, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .pending = zx_shape_45, .table = zx_shape_15, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_0, }, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_0, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .pending = zx_shape_45, .remaining = zx_shape_5, .values = zx_shape_13, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, }, };
const zx_shape_51 = .{ .kind = .object, .fields = .{ .id = zx_shape_5, .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, .origins = zx_shape_23, .result = zx_shape_5, .valid = zx_shape_1, }, };
const zx_shape_52 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_53 = .{ .kind = .object, .fields = .{ .pending = zx_shape_45, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_54 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_28, .@"1" = zx_shape_54, }, };
const zx_shape_56 = .{ .kind = .optional, .child = zx_shape_1, };
const zx_shape_57 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_30, .@"1" = zx_shape_56, }, };
const zx_shape_58 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, }, };
const zx_shape_59 = .{ .kind = .object, .fields = .{ .is_native = zx_shape_30, .keys = zx_shape_14, }, };
const zx_shape_60 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .modules = zx_shape_36, .natives = zx_shape_58, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .natives = zx_shape_58, .state = zx_shape_29, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .member = zx_shape_5, .natives = zx_shape_58, .plan = zx_shape_29, .request = zx_shape_31, .values = zx_shape_13, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .modules = zx_shape_36, .natives = zx_shape_58, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_64 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .found = zx_shape_1, .index = zx_shape_5, .module = zx_shape_5, .modules = zx_shape_36, .natives = zx_shape_58, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .modules = zx_shape_36, .natives = zx_shape_58, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_66 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .member = zx_shape_5, .modules = zx_shape_36, .natives = zx_shape_58, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_67 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_68 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_69 = .{ .kind = .object, .fields = .{ .specifiers = zx_shape_14, }, };
const zx_shape_70 = .{ .kind = .object, .fields = .{ .kinds = zx_shape_12, .scalar_count = zx_shape_5, }, };
const zx_shape_71 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .scalar_count = zx_shape_5, }, };
const zx_shape_72 = .{ .kind = .object, .fields = .{ .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_74 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .modules = zx_shape_36, .natives = zx_shape_58, .request = zx_shape_31, .state = zx_shape_29, .type_imports = zx_shape_13, }, };
const zx_shape_75 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .modules = zx_shape_36, .request = zx_shape_31, .type_imports = zx_shape_13, }, };
const zx_shape_76 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, }, };
const zx_shape_77 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, .@"1" = zx_shape_1, }, };
const zx_shape_78 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, .@"1" = zx_shape_1, .@"2" = zx_shape_61, }, };
const zx_shape_79 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, }, };
const zx_shape_80 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_1, }, };
const zx_shape_81 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_1, .@"2" = zx_shape_61, }, };
const zx_shape_82 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_74, }, };
const zx_shape_83 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_74, .@"1" = zx_shape_1, }, };
const zx_shape_84 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_74, .@"1" = zx_shape_1, .@"2" = zx_shape_29, }, };
const zx_shape_85 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_74, .@"1" = zx_shape_1, .@"2" = zx_shape_29, .@"3" = zx_shape_61, }, };
const zx_shape_86 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, }, };
const zx_shape_87 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, .@"1" = zx_shape_58, }, };
const zx_shape_88 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, .@"1" = zx_shape_58, .@"2" = zx_shape_29, }, };
const zx_shape_89 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, }, };
const zx_shape_90 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, }, };
const zx_shape_91 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_75, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, .@"5" = zx_shape_61, }, };

pub const input_shape = zx_shape_75;
pub const output_shape = zx_shape_61;
pub const Input = *const (zx_abi).zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9;
pub const Output = *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = block_83: {
        const operand_80 = (try (@import("zxc_module_d3fa122cb3a556ff440eba89599331873dd240c7210454afac967f630575d7e1")).callValue(allocator, block_79: {
            const operand_76 = ((in).modules).specifiers;

            break :block_79 block_78: {
                const operand_77 = (try (allocator).create((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990));

                (operand_77).* = @as((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990{ .specifiers = operand_76, });

                break :block_78 @as(*const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, operand_77);
            };
        }));

        break :block_83 block_82: {
            const operand_81 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

            (operand_81).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_80);

            break :block_82 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_81);
        };
    };

    const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_75: {
        const operand_72 = (try (@import("zxc_module_9a0e9f3dd47ddf90c346cf557b26e62dd6a20ae0a9eadaa56258fc93c071354e")).callValue(allocator, block_71: {
            const operand_67 = (((in).request).table).kinds;
            const operand_68 = ((in).request).scalar_count;

            break :block_71 block_70: {
                const operand_69 = (try (allocator).create((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3));

                (operand_69).* = @as((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3{ .kinds = operand_67, .scalar_count = operand_68, });

                break :block_70 @as(*const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, operand_69);
            };
        }));

        break :block_75 block_74: {
            const operand_73 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_73).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_72);

            break :block_74 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_73);
        };
    };

    const value_3: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_66: {
        const operand_56 = block_55: {
            const operand_51 = (in).request;
            const operand_52 = value_2;

            break :block_55 block_54: {
                const operand_53 = (try (allocator).create((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748));

                (operand_53).* = @as((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748{ .request = operand_51, .state = operand_52, });

                break :block_54 @as(*const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, operand_53);
            };
        };

        const operand_57 = ((operand_56).state).mapping;
        var transferred_items_58: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_57));
        var transferred_started_59 = true;
        const operand_60 = ((operand_56).state).order;
        var transferred_items_61: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_60));
        var transferred_started_62 = true;
        const operand_63 = ((operand_56).state).origins;
        var transferred_items_64: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_63));
        var transferred_started_65 = true;

        break :block_66 (try (@import("zxc_module_e3b023edff2e8ee09f999f84f8005b9ceee48441326a60ab1a72bd4b15b31ca8")).callBufferedPointer(allocator, operand_56, .{ .lane_0 = .{ .buffer = (&transferred_items_58), .started = (&transferred_started_59), }, .lane_1 = .{ .buffer = (&transferred_items_61), .started = (&transferred_started_62), }, .lane_2 = .{ .buffer = (&transferred_items_64), .started = (&transferred_started_65), }, }));
    };

    const value_4: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_50: {
        const operand_34 = block_33: {
            const operand_27 = (in).request;
            const operand_28 = value_3;
            const operand_29 = (in).modules;
            const operand_30 = value_1;

            break :block_33 block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14));

                (operand_31).* = @as((zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14{ .request = operand_27, .state = operand_28, .modules = operand_29, .natives = operand_30, });

                break :block_32 @as(*const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, operand_31);
            };
        };

        const operand_35 = ((operand_34).natives).mapping;
        var transferred_items_36: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_35));
        var transferred_started_37 = true;
        const operand_38 = ((operand_34).natives).order;
        var transferred_items_39: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_38));
        var transferred_started_40 = true;
        const operand_41 = ((operand_34).state).mapping;
        var transferred_items_42: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_41));
        var transferred_started_43 = true;
        const operand_44 = ((operand_34).state).order;
        var transferred_items_45: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_44));
        var transferred_started_46 = true;
        const operand_47 = ((operand_34).state).origins;
        var transferred_items_48: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_47));
        var transferred_started_49 = true;

        break :block_50 (try (@import("zxc_module_98ae8699d7dc0062174e9b87caa0effb484c05affd474085bc4a9b359d73dda0")).callBufferedPointer(allocator, operand_34, .{ .lane_0 = .{ .buffer = (&transferred_items_36), .started = (&transferred_started_37), }, .lane_1 = .{ .buffer = (&transferred_items_39), .started = (&transferred_started_40), }, .lane_2 = .{ .buffer = (&transferred_items_42), .started = (&transferred_started_43), }, .lane_3 = .{ .buffer = (&transferred_items_45), .started = (&transferred_started_46), }, .lane_4 = .{ .buffer = (&transferred_items_48), .started = (&transferred_started_49), }, }));
    };

    const value_5: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_26: {
        const operand_10 = block_9: {
            const operand_1 = (in).request;
            const operand_2 = (value_4).state;
            const operand_3 = (in).modules;
            const operand_4 = (value_4).natives;
            const operand_5 = (in).type_imports;
            const operand_6 = (in).dependencies;

            break :block_9 block_8: {
                const operand_7 = (try (allocator).create((zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7));

                (operand_7).* = @as((zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7{ .request = operand_1, .state = operand_2, .modules = operand_3, .natives = operand_4, .type_imports = operand_5, .dependencies = operand_6, });

                break :block_8 @as(*const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, operand_7);
            };
        };

        const operand_11 = ((operand_10).natives).mapping;
        var transferred_items_12: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_11));
        var transferred_started_13 = true;
        const operand_14 = ((operand_10).natives).order;
        var transferred_items_15: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_14));
        var transferred_started_16 = true;
        const operand_17 = ((operand_10).state).mapping;
        var transferred_items_18: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_17));
        var transferred_started_19 = true;
        const operand_20 = ((operand_10).state).order;
        var transferred_items_21: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_20));
        var transferred_started_22 = true;
        const operand_23 = ((operand_10).state).origins;
        var transferred_items_24: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_23));
        var transferred_started_25 = true;

        break :block_26 (try (@import("zxc_module_228bfd07d0549d0ad0ae3cc6ca13e01ee7ca0d3d89b0b98f762df10bdaa71a4c")).callBufferedPointer(allocator, operand_10, .{ .lane_0 = .{ .buffer = (&transferred_items_12), .started = (&transferred_started_13), }, .lane_1 = .{ .buffer = (&transferred_items_15), .started = (&transferred_started_16), }, .lane_2 = .{ .buffer = (&transferred_items_18), .started = (&transferred_started_19), }, .lane_3 = .{ .buffer = (&transferred_items_21), .started = (&transferred_started_22), }, .lane_4 = .{ .buffer = (&transferred_items_24), .started = (&transferred_started_25), }, }));
    };

    return value_5;
}

