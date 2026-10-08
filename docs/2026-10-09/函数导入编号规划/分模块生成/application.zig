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
const zx_shape_67 = .{ .kind = .object, .fields = .{ .inputs = zx_shape_13, .native_modules = zx_shape_39, .outputs = zx_shape_13, }, };
const zx_shape_68 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .inputs = zx_shape_13, .outputs = zx_shape_13, }, };
const zx_shape_69 = .{ .kind = .object, .fields = .{ .functions = zx_shape_58, .natives = zx_shape_58, .state = zx_shape_29, }, };
const zx_shape_70 = .{ .kind = .object, .fields = .{ .imports = zx_shape_68, .plan = zx_shape_69, .signatures = zx_shape_67, }, };
const zx_shape_71 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .modules = zx_shape_36, .plan = zx_shape_69, .request = zx_shape_31, .signatures = zx_shape_67, }, };
const zx_shape_72 = .{ .kind = .object, .fields = .{ .imports = zx_shape_68, .modules = zx_shape_36, .plan = zx_shape_69, .request = zx_shape_31, .signatures = zx_shape_67, }, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .imports = zx_shape_68, .index = zx_shape_5, .modules = zx_shape_36, .plan = zx_shape_69, .request = zx_shape_31, .signatures = zx_shape_67, }, };
const zx_shape_74 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_75 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_76 = .{ .kind = .object, .fields = .{ .specifiers = zx_shape_14, }, };
const zx_shape_77 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_28, .source = zx_shape_14, }, };
const zx_shape_78 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_14, }, };
const zx_shape_79 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_80 = .{ .kind = .object, .fields = .{ .kinds = zx_shape_12, .scalar_count = zx_shape_5, }, };
const zx_shape_81 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_28, .source = zx_shape_12, }, };
const zx_shape_82 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_12, }, };
const zx_shape_83 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .mapping = zx_shape_28, .order = zx_shape_13, .scalar_count = zx_shape_5, }, };
const zx_shape_84 = .{ .kind = .object, .fields = .{ .request = zx_shape_31, .state = zx_shape_29, }, };
const zx_shape_85 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .plan = zx_shape_29, .request = zx_shape_31, }, };
const zx_shape_86 = .{ .kind = .object, .fields = .{ .inputs = zx_shape_13, }, };
const zx_shape_87 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_28, .source = zx_shape_13, }, };
const zx_shape_88 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_13, }, };
const zx_shape_89 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .modules = zx_shape_36, .natives = zx_shape_58, .request = zx_shape_31, .state = zx_shape_29, .type_imports = zx_shape_13, }, };
const zx_shape_90 = .{ .kind = .object, .fields = .{ .dependencies = zx_shape_59, .function_imports = zx_shape_68, .modules = zx_shape_36, .request = zx_shape_31, .signatures = zx_shape_67, .type_imports = zx_shape_13, }, };
const zx_shape_91 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, }, };
const zx_shape_92 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, .@"1" = zx_shape_1, }, };
const zx_shape_93 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_63, .@"1" = zx_shape_1, .@"2" = zx_shape_61, }, };
const zx_shape_94 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, }, };
const zx_shape_95 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_1, }, };
const zx_shape_96 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_65, .@"1" = zx_shape_1, .@"2" = zx_shape_61, }, };
const zx_shape_97 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_72, }, };
const zx_shape_98 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_72, .@"1" = zx_shape_69, }, };
const zx_shape_99 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_72, .@"1" = zx_shape_69, .@"2" = zx_shape_1, }, };
const zx_shape_100 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_72, .@"1" = zx_shape_69, .@"2" = zx_shape_1, .@"3" = zx_shape_69, }, };
const zx_shape_101 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_89, }, };
const zx_shape_102 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_89, .@"1" = zx_shape_1, }, };
const zx_shape_103 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_89, .@"1" = zx_shape_1, .@"2" = zx_shape_29, }, };
const zx_shape_104 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_89, .@"1" = zx_shape_1, .@"2" = zx_shape_29, .@"3" = zx_shape_61, }, };
const zx_shape_105 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, }, };
const zx_shape_106 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, }, };
const zx_shape_107 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, }, };
const zx_shape_108 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, }, };
const zx_shape_109 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, }, };
const zx_shape_110 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, .@"5" = zx_shape_61, }, };
const zx_shape_111 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, .@"5" = zx_shape_61, .@"6" = zx_shape_58, }, };
const zx_shape_112 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_90, .@"1" = zx_shape_58, .@"2" = zx_shape_29, .@"3" = zx_shape_29, .@"4" = zx_shape_61, .@"5" = zx_shape_61, .@"6" = zx_shape_58, .@"7" = zx_shape_69, }, };
pub const input_shape = zx_shape_90;
pub const output_shape = zx_shape_69;
pub const Input = *const (zx_abi).zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8;
pub const Output = *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = block_128: {
        const operand_125 = (try (@import("zxc_module_d3fa122cb3a556ff440eba89599331873dd240c7210454afac967f630575d7e1")).callValue(allocator, block_124: {
            const operand_121 = ((in).modules).specifiers;

            break :block_124 block_123: {
                const operand_122 = (try (allocator).create((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990));

                (operand_122).* = @as((zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990{ .specifiers = operand_121, });

                break :block_123 @as(*const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990, operand_122);
            };
        }));

        break :block_128 block_127: {
            const operand_126 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

            (operand_126).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_125);

            break :block_127 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_126);
        };
    };

    const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_120: {
        const operand_117 = (try (@import("zxc_module_9a0e9f3dd47ddf90c346cf557b26e62dd6a20ae0a9eadaa56258fc93c071354e")).callValue(allocator, block_116: {
            const operand_112 = (((in).request).table).kinds;
            const operand_113 = ((in).request).scalar_count;

            break :block_116 block_115: {
                const operand_114 = (try (allocator).create((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3));

                (operand_114).* = @as((zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3{ .kinds = operand_112, .scalar_count = operand_113, });

                break :block_115 @as(*const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3, operand_114);
            };
        }));

        break :block_120 block_119: {
            const operand_118 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_118).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_117);

            break :block_119 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_118);
        };
    };

    const value_3: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_111: {
        const operand_101 = block_100: {
            const operand_96 = (in).request;
            const operand_97 = value_2;

            break :block_100 block_99: {
                const operand_98 = (try (allocator).create((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748));

                (operand_98).* = @as((zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748{ .request = operand_96, .state = operand_97, });

                break :block_99 @as(*const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, operand_98);
            };
        };

        const operand_102 = ((operand_101).state).mapping;
        var transferred_items_103: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_102));
        var transferred_started_104 = true;
        const operand_105 = ((operand_101).state).order;
        var transferred_items_106: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_105));
        var transferred_started_107 = true;
        const operand_108 = ((operand_101).state).origins;
        var transferred_items_109: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_108));
        var transferred_started_110 = true;

        break :block_111 (try (@import("zxc_module_e3b023edff2e8ee09f999f84f8005b9ceee48441326a60ab1a72bd4b15b31ca8")).callBufferedPointer(allocator, operand_101, .{ .lane_0 = .{ .buffer = (&transferred_items_103), .started = (&transferred_started_104), }, .lane_1 = .{ .buffer = (&transferred_items_106), .started = (&transferred_started_107), }, .lane_2 = .{ .buffer = (&transferred_items_109), .started = (&transferred_started_110), }, }));
    };

    const value_4: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_95: {
        const operand_79 = block_78: {
            const operand_72 = (in).request;
            const operand_73 = value_3;
            const operand_74 = (in).modules;
            const operand_75 = value_1;

            break :block_78 block_77: {
                const operand_76 = (try (allocator).create((zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14));

                (operand_76).* = @as((zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14{ .request = operand_72, .state = operand_73, .modules = operand_74, .natives = operand_75, });

                break :block_77 @as(*const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, operand_76);
            };
        };

        const operand_80 = ((operand_79).natives).mapping;
        var transferred_items_81: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_80));
        var transferred_started_82 = true;
        const operand_83 = ((operand_79).natives).order;
        var transferred_items_84: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_83));
        var transferred_started_85 = true;
        const operand_86 = ((operand_79).state).mapping;
        var transferred_items_87: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_86));
        var transferred_started_88 = true;
        const operand_89 = ((operand_79).state).order;
        var transferred_items_90: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_89));
        var transferred_started_91 = true;
        const operand_92 = ((operand_79).state).origins;
        var transferred_items_93: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_92));
        var transferred_started_94 = true;

        break :block_95 (try (@import("zxc_module_98ae8699d7dc0062174e9b87caa0effb484c05affd474085bc4a9b359d73dda0")).callBufferedPointer(allocator, operand_79, .{ .lane_0 = .{ .buffer = (&transferred_items_81), .started = (&transferred_started_82), }, .lane_1 = .{ .buffer = (&transferred_items_84), .started = (&transferred_started_85), }, .lane_2 = .{ .buffer = (&transferred_items_87), .started = (&transferred_started_88), }, .lane_3 = .{ .buffer = (&transferred_items_90), .started = (&transferred_started_91), }, .lane_4 = .{ .buffer = (&transferred_items_93), .started = (&transferred_started_94), }, }));
    };

    const value_5: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_71: {
        const operand_55 = block_54: {
            const operand_46 = (in).request;
            const operand_47 = (value_4).state;
            const operand_48 = (in).modules;
            const operand_49 = (value_4).natives;
            const operand_50 = (in).type_imports;
            const operand_51 = (in).dependencies;

            break :block_54 block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7));

                (operand_52).* = @as((zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7{ .request = operand_46, .state = operand_47, .modules = operand_48, .natives = operand_49, .type_imports = operand_50, .dependencies = operand_51, });

                break :block_53 @as(*const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, operand_52);
            };
        };

        const operand_56 = ((operand_55).natives).mapping;
        var transferred_items_57: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_56));
        var transferred_started_58 = true;
        const operand_59 = ((operand_55).natives).order;
        var transferred_items_60: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_59));
        var transferred_started_61 = true;
        const operand_62 = ((operand_55).state).mapping;
        var transferred_items_63: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_62));
        var transferred_started_64 = true;
        const operand_65 = ((operand_55).state).order;
        var transferred_items_66: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_65));
        var transferred_started_67 = true;
        const operand_68 = ((operand_55).state).origins;
        var transferred_items_69: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_68));
        var transferred_started_70 = true;

        break :block_71 (try (@import("zxc_module_228bfd07d0549d0ad0ae3cc6ca13e01ee7ca0d3d89b0b98f762df10bdaa71a4c")).callBufferedPointer(allocator, operand_55, .{ .lane_0 = .{ .buffer = (&transferred_items_57), .started = (&transferred_started_58), }, .lane_1 = .{ .buffer = (&transferred_items_60), .started = (&transferred_started_61), }, .lane_2 = .{ .buffer = (&transferred_items_63), .started = (&transferred_started_64), }, .lane_3 = .{ .buffer = (&transferred_items_66), .started = (&transferred_started_67), }, .lane_4 = .{ .buffer = (&transferred_items_69), .started = (&transferred_started_70), }, }));
    };

    const value_6: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = block_45: {
        const operand_42 = (try (@import("zxc_module_b4cd92d1da3c10a23dd7019719c5a432a7f64fec1cf1d66b207623cae1fda6b4")).callValue(allocator, block_41: {
            const operand_38 = ((in).signatures).inputs;

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create((zx_abi).zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce));

                (operand_39).* = @as((zx_abi).zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce, (zx_abi).zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce{ .inputs = operand_38, });

                break :block_40 @as(*const (zx_abi).zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce, operand_39);
            };
        }));

        break :block_45 block_44: {
            const operand_43 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

            (operand_43).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_42);

            break :block_44 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_43);
        };
    };

    const value_7: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = block_37: {
        const operand_15 = block_14: {
            const operand_1 = (in).request;
            const operand_2 = (in).modules;
            const operand_3 = (in).signatures;
            const operand_4 = (in).function_imports;

            const operand_5 = block_11: {
                const operand_6 = (value_5).state;
                const operand_7 = (value_5).natives;
                const operand_8 = value_6;

                break :block_11 block_10: {
                    const operand_9 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                    (operand_9).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_6, .natives = operand_7, .functions = operand_8, });

                    break :block_10 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_9);
                };
            };

            break :block_14 block_13: {
                const operand_12 = (try (allocator).create((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a));

                (operand_12).* = @as((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a{ .request = operand_1, .modules = operand_2, .signatures = operand_3, .imports = operand_4, .plan = operand_5, });

                break :block_13 @as(*const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, operand_12);
            };
        };

        const operand_16 = (((operand_15).plan).functions).mapping;
        var transferred_items_17: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_16));
        var transferred_started_18 = true;
        const operand_19 = (((operand_15).plan).functions).order;
        var transferred_items_20: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_19));
        var transferred_started_21 = true;
        const operand_22 = (((operand_15).plan).natives).mapping;
        var transferred_items_23: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_22));
        var transferred_started_24 = true;
        const operand_25 = (((operand_15).plan).natives).order;
        var transferred_items_26: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_25));
        var transferred_started_27 = true;
        const operand_28 = (((operand_15).plan).state).mapping;
        var transferred_items_29: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_28));
        var transferred_started_30 = true;
        const operand_31 = (((operand_15).plan).state).order;
        var transferred_items_32: (std).ArrayList(u32) = ((std).ArrayList(u32)).fromOwnedSlice(@constCast(operand_31));
        var transferred_started_33 = true;
        const operand_34 = (((operand_15).plan).state).origins;
        var transferred_items_35: (std).ArrayList(u64) = ((std).ArrayList(u64)).fromOwnedSlice(@constCast(operand_34));
        var transferred_started_36 = true;

        break :block_37 (try (@import("zxc_module_7b3042afdc42ee0063dd49865588fe57f1f81d73bd26edc44bb0f1baad249a94")).callBufferedPointer(allocator, operand_15, .{ .lane_0 = .{ .buffer = (&transferred_items_17), .started = (&transferred_started_18), }, .lane_1 = .{ .buffer = (&transferred_items_20), .started = (&transferred_started_21), }, .lane_2 = .{ .buffer = (&transferred_items_23), .started = (&transferred_started_24), }, .lane_3 = .{ .buffer = (&transferred_items_26), .started = (&transferred_started_27), }, .lane_4 = .{ .buffer = (&transferred_items_29), .started = (&transferred_started_30), }, .lane_5 = .{ .buffer = (&transferred_items_32), .started = (&transferred_started_33), }, .lane_6 = .{ .buffer = (&transferred_items_35), .started = (&transferred_started_36), }, }));
    };

    return value_7;
}

