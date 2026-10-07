const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_native_1 = @import("integers");
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
const zx_shape_22 = .{ .kind = .scalar, };
const zx_shape_23 = .{ .kind = .scalar, };
const zx_shape_24 = .{ .kind = .scalar, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .start = zx_shape_5, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .dollar = zx_shape_1, .kind = zx_shape_23, .line_break = zx_shape_1, .span = zx_shape_25, .symbol = zx_shape_24, .word = zx_shape_22, }, };
const zx_shape_27 = .{ .kind = .scalar, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .last_byte = zx_shape_2, .phase = zx_shape_27, .separators_valid = zx_shape_1, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .diagnostic = zx_shape_10, .end = zx_shape_5, }, };
const zx_shape_30 = .{ .kind = .scalar, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .end = zx_shape_5, .message = zx_shape_10, .start = zx_shape_5, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .braces = zx_shape_5, .depth = zx_shape_5, .mode = zx_shape_30, .start = zx_shape_5, }, };
const zx_shape_33 = .{ .kind = .list, .child = zx_shape_32, };
const zx_shape_34 = .{ .kind = .list, .child = zx_shape_26, };
const zx_shape_35 = .{ .kind = .list, .child = zx_shape_25, };
const zx_shape_36 = .{ .kind = .object, .fields = .{ .ahead_one = zx_shape_2, .ahead_two = zx_shape_2, .braces = zx_shape_5, .comments = zx_shape_35, .depth = zx_shape_5, .diagnostic = zx_shape_31, .dollar = zx_shape_1, .frames = zx_shape_33, .keyword = zx_shape_22, .line_break = zx_shape_1, .mode = zx_shape_30, .number = zx_shape_28, .offset = zx_shape_5, .skip_until = zx_shape_5, .source_length = zx_shape_5, .start = zx_shape_5, .symbol = zx_shape_24, .tokens = zx_shape_34, .warmed = zx_shape_2, }, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .after = zx_shape_2, .byte = zx_shape_2, .has_after = zx_shape_1, .has_next = zx_shape_1, .next = zx_shape_2, .state = zx_shape_36, }, };
const zx_shape_38 = .{ .kind = .object, .fields = .{ .comments = zx_shape_35, .diagnostic = zx_shape_31, .tokens = zx_shape_34, }, };
const zx_shape_39 = .{ .kind = .scalar, };
const zx_shape_40 = .{ .kind = .scalar, };
const zx_shape_41 = .{ .kind = .object, .fields = .{ .child = zx_shape_5, .count = zx_shape_5, .head = zx_shape_5, .kind = zx_shape_39, .name = zx_shape_25, }, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .name = zx_shape_25, .previous = zx_shape_5, .value = zx_shape_5, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .previous = zx_shape_5, .value = zx_shape_5, }, };
const zx_shape_44 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .fields = zx_shape_44, .heads = zx_shape_44, .items = zx_shape_44, }, };
const zx_shape_46 = .{ .kind = .list, .child = zx_shape_41, };
const zx_shape_47 = .{ .kind = .list, .child = zx_shape_42, };
const zx_shape_48 = .{ .kind = .list, .child = zx_shape_43, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .fields = zx_shape_47, .items = zx_shape_48, .nodes = zx_shape_46, }, };
const zx_shape_50 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .field = zx_shape_25, .head = zx_shape_5, .kind = zx_shape_39, .name = zx_shape_25, .optional = zx_shape_1, }, };
const zx_shape_51 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .diagnostic = zx_shape_31, .index = zx_shape_5, .name = zx_shape_25, .phase = zx_shape_40, .result = zx_shape_5, .start = zx_shape_5, .token = zx_shape_26, }, };
const zx_shape_52 = .{ .kind = .list, .child = zx_shape_50, };
const zx_shape_53 = .{ .kind = .object, .fields = .{ .control = zx_shape_51, .frames = zx_shape_52, .tree = zx_shape_49, }, };
const zx_shape_54 = .{ .kind = .scalar, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enumeration = zx_shape_1, .first = zx_shape_5, .name = zx_shape_25, .span = zx_shape_25, .value = zx_shape_5, }, };
const zx_shape_56 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .depth = zx_shape_5, .diagnostic = zx_shape_31, .enumeration = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .last_end = zx_shape_5, .name = zx_shape_25, .opening = zx_shape_5, .opening_index = zx_shape_5, .phase = zx_shape_54, .start = zx_shape_5, .token = zx_shape_26, .type_diagnostic = zx_shape_1, }, };
const zx_shape_57 = .{ .kind = .list, .child = zx_shape_55, };
const zx_shape_58 = .{ .kind = .object, .fields = .{ .control = zx_shape_56, .declarations = zx_shape_57, .members = zx_shape_35, .types = zx_shape_53, }, };
const zx_shape_59 = .{ .kind = .scalar, };
const zx_shape_60 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .start = zx_shape_5, .text = zx_shape_10, }, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .enumeration = zx_shape_1, .index = zx_shape_5, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .child = zx_shape_61, .count = zx_shape_5, .kind = zx_shape_59, .name = zx_shape_60, .position = zx_shape_5, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .name = zx_shape_60, .next = zx_shape_5, .value = zx_shape_61, }, };
const zx_shape_64 = .{ .kind = .object, .fields = .{ .next = zx_shape_5, .value = zx_shape_61, }, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .name = zx_shape_60, .value = zx_shape_61, }, };
const zx_shape_66 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, }, };
const zx_shape_67 = .{ .kind = .list, .child = zx_shape_62, };
const zx_shape_68 = .{ .kind = .list, .child = zx_shape_63, };
const zx_shape_69 = .{ .kind = .list, .child = zx_shape_64, };
const zx_shape_70 = .{ .kind = .list, .child = zx_shape_65, };
const zx_shape_71 = .{ .kind = .list, .child = zx_shape_66, };
const zx_shape_72 = .{ .kind = .list, .child = zx_shape_60, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .declarations = zx_shape_70, .enumerations = zx_shape_71, .fields = zx_shape_68, .items = zx_shape_69, .members = zx_shape_72, .nodes = zx_shape_67, }, };
const zx_shape_74 = .{ .kind = .object, .fields = .{ .bytes = zx_shape_12, .declarations = zx_shape_57, .members = zx_shape_35, .order = zx_shape_45, .types = zx_shape_49, }, };
const zx_shape_75 = .{ .kind = .optional, .child = zx_shape_73, };
const zx_shape_76 = .{ .kind = .object, .fields = .{ .indexed = zx_shape_74, .native = zx_shape_75, }, };
const zx_shape_77 = .{ .kind = .scalar, };
const zx_shape_78 = .{ .kind = .object, .fields = .{ .ids = zx_shape_13, .names = zx_shape_14, }, };
const zx_shape_79 = .{ .kind = .object, .fields = .{ .aliases = zx_shape_78, .base = zx_shape_15, .native_interface = zx_shape_1, .resolved = zx_shape_78, .source = zx_shape_76, .visiting = zx_shape_14, }, };
const zx_shape_80 = .{ .kind = .object, .fields = .{ .children = zx_shape_5, .count = zx_shape_5, .declaration = zx_shape_60, .fields = zx_shape_5, .index = zx_shape_5, .list = zx_shape_1, .name = zx_shape_60, .operation = zx_shape_77, .position = zx_shape_5, .reference = zx_shape_61, .waiting = zx_shape_1, }, };
const zx_shape_81 = .{ .kind = .list, .child = zx_shape_80, };
const zx_shape_82 = .{ .kind = .object, .fields = .{ .active = zx_shape_14, .cache = zx_shape_78, .context = zx_shape_79, .delta = zx_shape_15, .diagnostic = zx_shape_31, .frames = zx_shape_81, .result = zx_shape_4, .scratch = zx_shape_18, }, };
const zx_shape_83 = .{ .kind = .object, .fields = .{ .context = zx_shape_79, .initialize = zx_shape_1, .name = zx_shape_60, .named = zx_shape_1, .reference = zx_shape_61, }, };
const zx_shape_84 = .{ .kind = .object, .fields = .{ .cache = zx_shape_78, .delta = zx_shape_15, .diagnostic = zx_shape_31, .id = zx_shape_4, }, };
const zx_shape_85 = .{ .kind = .object, .fields = .{ .name = zx_shape_60, .operation = zx_shape_77, .reference = zx_shape_61, }, };
const zx_shape_86 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .name = zx_shape_60, .state = zx_shape_82, }, };
const zx_shape_87 = .{ .kind = .object, .fields = .{ .source = zx_shape_12, .span = zx_shape_25, }, };
const zx_shape_88 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_12, }, };
const zx_shape_89 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .source = zx_shape_76, }, };
const zx_shape_90 = .{ .kind = .object, .fields = .{ .limit = zx_shape_5, .name = zx_shape_10, .source = zx_shape_76, }, };
const zx_shape_91 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, }, };
const zx_shape_92 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .name = zx_shape_10, .selected = zx_shape_5, .source = zx_shape_76, }, };
const zx_shape_93 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .state = zx_shape_82, }, };
const zx_shape_94 = .{ .kind = .object, .fields = .{ .name = zx_shape_10, .names = zx_shape_14, }, };
const zx_shape_95 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .name = zx_shape_10, .names = zx_shape_14, }, };
const zx_shape_96 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_14, }, };
const zx_shape_97 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .state = zx_shape_82, }, };
const zx_shape_98 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_99 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_100 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_101 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_100, }, };
const zx_shape_102 = .{ .kind = .optional, .child = zx_shape_80, };
const zx_shape_103 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_81, .@"1" = zx_shape_102, }, };
const zx_shape_104 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .field_names = zx_shape_14, .field_types = zx_shape_13, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .offset = zx_shape_5, .second = zx_shape_4, }, };
const zx_shape_105 = .{ .kind = .object, .fields = .{ .left = zx_shape_104, .right = zx_shape_104, }, };
const zx_shape_106 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_104, .right = zx_shape_104, }, };
const zx_shape_107 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_108 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_109 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .tables = zx_shape_16, }, };
const zx_shape_110 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_111 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .delta = zx_shape_15, }, };
const zx_shape_112 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_113 = .{ .kind = .object, .fields = .{ .left = zx_shape_10, .right = zx_shape_10, }, };
const zx_shape_114 = .{ .kind = .object, .fields = .{ .equal = zx_shape_1, .index = zx_shape_5, .left = zx_shape_10, .limit = zx_shape_5, .right = zx_shape_10, }, };
const zx_shape_115 = .{ .kind = .object, .fields = .{ .building = zx_shape_1, .count = zx_shape_5, .names = zx_shape_14, .remaining = zx_shape_5, .root = zx_shape_5, .sifting = zx_shape_1, .types = zx_shape_13, }, };
const zx_shape_116 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, }, };
const zx_shape_117 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .table = zx_shape_15, }, };
const zx_shape_118 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .diagnostic = zx_shape_116, .id = zx_shape_4, }, };
const zx_shape_119 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_120 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_121 = .{ .kind = .object, .fields = .{ .flags = zx_shape_120, .index = zx_shape_5, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_122 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .count = zx_shape_5, .flags = zx_shape_120, .found = zx_shape_1, .index = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_123 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_124 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .index = zx_shape_5, .limit = zx_shape_5, .tables = zx_shape_16, .target = zx_shape_11, }, };
const zx_shape_125 = .{ .kind = .object, .fields = .{ .first = zx_shape_5, .flags = zx_shape_120, .index = zx_shape_5, .limit = zx_shape_5, .native_references = zx_shape_1, .tables = zx_shape_16, }, };
const zx_shape_126 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_120, .@"1" = zx_shape_0, }, };
const zx_shape_127 = .{ .kind = .scalar, };
const zx_shape_128 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .found = zx_shape_1, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_129 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .state = zx_shape_82, }, };
const zx_shape_130 = .{ .kind = .object, .fields = .{ .enumeration = zx_shape_5, .index = zx_shape_5, .source = zx_shape_76, }, };
const zx_shape_131 = .{ .kind = .object, .fields = .{ .reference = zx_shape_61, .source = zx_shape_76, }, };
const zx_shape_132 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .diagnostic = zx_shape_31, .enumeration = zx_shape_5, .index = zx_shape_5, .names = zx_shape_14, .source = zx_shape_76, }, };
const zx_shape_133 = .{ .kind = .object, .fields = .{ .cache = zx_shape_78, .name = zx_shape_10, }, };
const zx_shape_134 = .{ .kind = .object, .fields = .{ .cache = zx_shape_78, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .name = zx_shape_10, }, };
const zx_shape_135 = .{ .kind = .object, .fields = .{ .frame = zx_shape_80, .state = zx_shape_82, }, };
const zx_shape_136 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_81, .@"1" = zx_shape_0, }, };
const zx_shape_137 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_13, }, };
const zx_shape_138 = .{ .kind = .object, .fields = .{ .position = zx_shape_5, .source = zx_shape_76, }, };
const zx_shape_139 = .{ .kind = .object, .fields = .{ .initialize = zx_shape_1, .state = zx_shape_82, }, };
const zx_shape_140 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_83, }, };
const zx_shape_141 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_83, .@"1" = zx_shape_82, }, };
const zx_shape_142 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_83, .@"1" = zx_shape_82, .@"2" = zx_shape_84, }, };

pub const input_shape = zx_shape_83;
pub const output_shape = zx_shape_84;
pub const Input = *const (zx_abi).zx_type_83;
pub const Output = *const (zx_abi).zx_type_84;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_85) error{ OutOfMemory, }!*const (zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    return block_20: {
        const operand_1 = (in).operation;
        const operand_2 = (in).reference;
        const operand_3 = (in).name;

        const operand_4 = block_10: {
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_8).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_5, .start = operand_6, .end = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_60, operand_8);
            };
        };

        const operand_11 = false;
        const operand_12 = @as(u64, 0);
        const operand_13 = @as(u64, 0);
        const operand_14 = @as(u64, 0);
        const operand_15 = false;
        const operand_16 = @as(u64, 0);
        const operand_17 = @as(u64, 0);

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_80));

            (operand_18).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .operation = operand_1, .reference = operand_2, .name = operand_3, .declaration = operand_4, .waiting = operand_11, .index = operand_12, .position = operand_13, .count = operand_14, .list = operand_15, .children = operand_16, .fields = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_80, operand_18);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_85) error{ OutOfMemory, }!(zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    return block_38: {
        const operand_21 = (in).operation;
        const operand_22 = (in).reference;
        const operand_23 = (in).name;

        const operand_24 = block_30: {
            const operand_25 = @as([]const u8, "");
            const operand_26 = @as(u64, 0);
            const operand_27 = @as(u64, 0);

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_28).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_25, .start = operand_26, .end = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_60, operand_28);
            };
        };

        const operand_31 = false;
        const operand_32 = @as(u64, 0);
        const operand_33 = @as(u64, 0);
        const operand_34 = @as(u64, 0);
        const operand_35 = false;
        const operand_36 = @as(u64, 0);
        const operand_37 = @as(u64, 0);

        break :block_38 (zx_abi).zx_type_80{ .operation = operand_21, .reference = operand_22, .name = operand_23, .declaration = operand_24, .waiting = operand_31, .index = operand_32, .position = operand_33, .count = operand_34, .list = operand_35, .children = operand_36, .fields = operand_37, };
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_83) error{ OutOfMemory, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_124: {
        const operand_106 = block_107: {
            break :block_107 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_108 = block_109: {
            break :block_109 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_110 = block_111: {
            break :block_111 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_112 = block_113: {
            break :block_113 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_114 = block_115: {
            break :block_115 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_116 = block_117: {
            break :block_117 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_118 = block_119: {
            break :block_119 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_120 = block_121: {
            break :block_121 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_124 block_123: {
            const operand_122 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_122).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_106, .first = operand_108, .second = operand_110, .labels = operand_112, .children = operand_114, .field_types = operand_116, .field_names = operand_118, .names = operand_120, });

            break :block_123 @as(*const (zx_abi).zx_type_15, operand_122);
        };
    };

    const value_2: *const (zx_abi).zx_type_15 = block_105: {
        const operand_43 = block_55: {
            const operand_44 = @as(u8, 0);
            const operand_45 = @as(u8, 0);
            const operand_46 = @as(u8, 0);
            const operand_47 = @as(u8, 0);
            const operand_48 = @as(u8, 0);
            const operand_49 = @as(u8, 0);
            const operand_50 = @as(u8, 0);
            const operand_51 = @as(u8, 0);
            const operand_52 = @as(u8, 0);
            const operand_53 = @as(u8, 0);
            const operand_54 = @as(u8, 0);

            break :block_55 (try (allocator).dupe(u8, (&[_]u8{operand_44, operand_45, operand_46, operand_47, operand_48, operand_49, operand_50, operand_51, operand_52, operand_53, operand_54, })));
        };
        const operand_56 = block_68: {
            const operand_57 = @as(u32, 0);
            const operand_58 = @as(u32, 1);
            const operand_59 = @as(u32, 2);
            const operand_60 = @as(u32, 3);
            const operand_61 = @as(u32, 4);
            const operand_62 = @as(u32, 5);
            const operand_63 = @as(u32, 6);
            const operand_64 = @as(u32, 7);
            const operand_65 = @as(u32, 8);
            const operand_66 = @as(u32, 9);
            const operand_67 = @as(u32, 10);

            break :block_68 (try (allocator).dupe(u32, (&[_]u32{operand_57, operand_58, operand_59, operand_60, operand_61, operand_62, operand_63, operand_64, operand_65, operand_66, operand_67, })));
        };
        const operand_69 = block_81: {
            const operand_70 = @as(u32, 0);
            const operand_71 = @as(u32, 0);
            const operand_72 = @as(u32, 0);
            const operand_73 = @as(u32, 0);
            const operand_74 = @as(u32, 0);
            const operand_75 = @as(u32, 0);
            const operand_76 = @as(u32, 0);
            const operand_77 = @as(u32, 0);
            const operand_78 = @as(u32, 0);
            const operand_79 = @as(u32, 0);
            const operand_80 = @as(u32, 0);

            break :block_81 (try (allocator).dupe(u32, (&[_]u32{operand_70, operand_71, operand_72, operand_73, operand_74, operand_75, operand_76, operand_77, operand_78, operand_79, operand_80, })));
        };
        const operand_82 = block_94: {
            const operand_83 = @as([]const u8, "");
            const operand_84 = @as([]const u8, "");
            const operand_85 = @as([]const u8, "");
            const operand_86 = @as([]const u8, "");
            const operand_87 = @as([]const u8, "");
            const operand_88 = @as([]const u8, "");
            const operand_89 = @as([]const u8, "");
            const operand_90 = @as([]const u8, "");
            const operand_91 = @as([]const u8, "");
            const operand_92 = @as([]const u8, "");
            const operand_93 = @as([]const u8, "");

            break :block_94 (try (allocator).dupe([]const u8, (&[_][]const u8{operand_83, operand_84, operand_85, operand_86, operand_87, operand_88, operand_89, operand_90, operand_91, operand_92, operand_93, })));
        };

        const operand_95 = block_96: {
            break :block_96 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_97 = block_98: {
            break :block_98 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_99 = block_100: {
            break :block_100 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_101 = block_102: {
            break :block_102 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_105 block_104: {
            const operand_103 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_103).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_43, .first = operand_56, .second = operand_69, .labels = operand_82, .children = operand_95, .field_types = operand_97, .field_names = operand_99, .names = operand_101, });

            break :block_104 @as(*const (zx_abi).zx_type_15, operand_103);
        };
    };

    const value_3: (zx_abi).zx_type_77 = (if ((in).named) @as((zx_abi).zx_type_77, .Name) else @as((zx_abi).zx_type_77, .Node));

    const value_4: []const *const (zx_abi).zx_type_80 = (if ((in).initialize) block_34: {
        break :block_34 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{})));
    } else block_42: {
        const operand_41 = (try function_0(allocator, block_40: {
            const operand_35 = value_3;
            const operand_36 = (in).name;
            const operand_37 = (in).reference;

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_85));

                (operand_38).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_35, .name = operand_36, .reference = operand_37, });

                break :block_39 @as(*const (zx_abi).zx_type_85, operand_38);
            };
        }));

        break :block_42 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{operand_41, })));
    });

    return block_33: {
        const operand_1 = (in).context;
        const operand_2 = (if (((in).initialize and (@as(u64, ((((in).context).base).kinds).len) == @as(u64, 0)))) value_2 else value_1);

        const operand_3 = block_10: {
            const operand_4 = block_5: {
                break :block_5 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            const operand_6 = block_7: {
                break :block_7 (try (allocator).dupe(u32, (&[_]u32{})));
            };

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_8).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_4, .ids = operand_6, });

                break :block_9 @as(*const (zx_abi).zx_type_78, operand_8);
            };
        };

        const operand_11 = value_4;

        const operand_12 = block_19: {
            const operand_13 = block_14: {
                break :block_14 (try (allocator).dupe(u32, (&[_]u32{})));
            };
            const operand_15 = block_16: {
                break :block_16 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            break :block_19 block_18: {
                const operand_17 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_17).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_13, .names = operand_15, });

                break :block_18 @as(*const (zx_abi).zx_type_18, operand_17);
            };
        };

        const operand_20 = block_21: {
            break :block_21 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_22 = @as(u32, 0);

        const operand_23 = block_30: {
            const operand_24 = @as([]const u8, "");
            const operand_25 = @as([]const u8, "");
            const operand_26 = @as(u64, 0);
            const operand_27 = @as(u64, 0);

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_28).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_24, .message = operand_25, .start = operand_26, .end = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_31, operand_28);
            };
        };

        break :block_33 block_32: {
            const operand_31 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_31).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .context = operand_1, .delta = operand_2, .cache = operand_3, .frames = operand_11, .scratch = operand_12, .active = operand_20, .result = operand_22, .diagnostic = operand_23, });

            break :block_32 @as(*const (zx_abi).zx_type_82, operand_31);
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_251: {
        const operand_233 = block_234: {
            break :block_234 (try (allocator).dupe(u8, (&[_]u8{})));
        };
        const operand_235 = block_236: {
            break :block_236 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_237 = block_238: {
            break :block_238 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_239 = block_240: {
            break :block_240 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };
        const operand_241 = block_242: {
            break :block_242 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_243 = block_244: {
            break :block_244 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_245 = block_246: {
            break :block_246 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_247 = block_248: {
            break :block_248 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_251 block_250: {
            const operand_249 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_249).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_233, .first = operand_235, .second = operand_237, .labels = operand_239, .children = operand_241, .field_types = operand_243, .field_names = operand_245, .names = operand_247, });

            break :block_250 @as(*const (zx_abi).zx_type_15, operand_249);
        };
    };

    const value_2: *const (zx_abi).zx_type_15 = block_232: {
        const operand_170 = block_182: {
            const operand_171 = @as(u8, 0);
            const operand_172 = @as(u8, 0);
            const operand_173 = @as(u8, 0);
            const operand_174 = @as(u8, 0);
            const operand_175 = @as(u8, 0);
            const operand_176 = @as(u8, 0);
            const operand_177 = @as(u8, 0);
            const operand_178 = @as(u8, 0);
            const operand_179 = @as(u8, 0);
            const operand_180 = @as(u8, 0);
            const operand_181 = @as(u8, 0);

            break :block_182 (try (allocator).dupe(u8, (&[_]u8{operand_171, operand_172, operand_173, operand_174, operand_175, operand_176, operand_177, operand_178, operand_179, operand_180, operand_181, })));
        };
        const operand_183 = block_195: {
            const operand_184 = @as(u32, 0);
            const operand_185 = @as(u32, 1);
            const operand_186 = @as(u32, 2);
            const operand_187 = @as(u32, 3);
            const operand_188 = @as(u32, 4);
            const operand_189 = @as(u32, 5);
            const operand_190 = @as(u32, 6);
            const operand_191 = @as(u32, 7);
            const operand_192 = @as(u32, 8);
            const operand_193 = @as(u32, 9);
            const operand_194 = @as(u32, 10);

            break :block_195 (try (allocator).dupe(u32, (&[_]u32{operand_184, operand_185, operand_186, operand_187, operand_188, operand_189, operand_190, operand_191, operand_192, operand_193, operand_194, })));
        };
        const operand_196 = block_208: {
            const operand_197 = @as(u32, 0);
            const operand_198 = @as(u32, 0);
            const operand_199 = @as(u32, 0);
            const operand_200 = @as(u32, 0);
            const operand_201 = @as(u32, 0);
            const operand_202 = @as(u32, 0);
            const operand_203 = @as(u32, 0);
            const operand_204 = @as(u32, 0);
            const operand_205 = @as(u32, 0);
            const operand_206 = @as(u32, 0);
            const operand_207 = @as(u32, 0);

            break :block_208 (try (allocator).dupe(u32, (&[_]u32{operand_197, operand_198, operand_199, operand_200, operand_201, operand_202, operand_203, operand_204, operand_205, operand_206, operand_207, })));
        };

        const operand_209 = block_221: {
            const operand_210 = @as([]const u8, "");
            const operand_211 = @as([]const u8, "");
            const operand_212 = @as([]const u8, "");
            const operand_213 = @as([]const u8, "");
            const operand_214 = @as([]const u8, "");
            const operand_215 = @as([]const u8, "");
            const operand_216 = @as([]const u8, "");
            const operand_217 = @as([]const u8, "");
            const operand_218 = @as([]const u8, "");
            const operand_219 = @as([]const u8, "");
            const operand_220 = @as([]const u8, "");

            break :block_221 (try (allocator).dupe([]const u8, (&[_][]const u8{operand_210, operand_211, operand_212, operand_213, operand_214, operand_215, operand_216, operand_217, operand_218, operand_219, operand_220, })));
        };
        const operand_222 = block_223: {
            break :block_223 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_224 = block_225: {
            break :block_225 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_226 = block_227: {
            break :block_227 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_228 = block_229: {
            break :block_229 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_232 block_231: {
            const operand_230 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_230).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_170, .first = operand_183, .second = operand_196, .labels = operand_209, .children = operand_222, .field_types = operand_224, .field_names = operand_226, .names = operand_228, });

            break :block_231 @as(*const (zx_abi).zx_type_15, operand_230);
        };
    };

    const value_3: (zx_abi).zx_type_77 = (if ((in).named) @as((zx_abi).zx_type_77, .Name) else @as((zx_abi).zx_type_77, .Node));

    const value_4: []const *const (zx_abi).zx_type_80 = (if ((in).initialize) block_159: {
        break :block_159 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{})));
    } else block_169: {
        const operand_168 = block_167: {
            const operand_165 = block_164: {
                const operand_160 = block_161: {
                    break :block_161 value_3;
                };

                const operand_162 = (in).name;
                const operand_163 = (in).reference;

                break :block_164 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_160, .name = operand_162, .reference = operand_163, });
            };

            var state_borrow_166: (zx_abi).zx_type_85 = undefined;

            state_borrow_166 = (zx_abi).zx_type_85{ .name = (operand_165).name, .operation = (operand_165).operation, .reference = (operand_165).reference, };

            break :block_167 (try function_0(allocator, ((operand_165).zx_origin orelse (&state_borrow_166))));
        };

        break :block_169 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{operand_168, })));
    });

    return block_158: {
        const operand_125 = (in).context;

        const operand_126 = (if (((in).initialize and (@as(u64, ((((in).context).base).kinds).len) == @as(u64, 0)))) block_127: {
            break :block_127 value_2;
        } else block_128: {
            break :block_128 value_1;
        });

        const operand_129 = block_136: {
            const operand_130 = block_131: {
                break :block_131 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };
            const operand_132 = block_133: {
                break :block_133 (try (allocator).dupe(u32, (&[_]u32{})));
            };

            break :block_136 block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_134).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_130, .ids = operand_132, });

                break :block_135 @as(*const (zx_abi).zx_type_78, operand_134);
            };
        };

        const operand_137 = block_138: {
            break :block_138 value_4;
        };
        const operand_139 = block_146: {
            const operand_140 = block_141: {
                break :block_141 (try (allocator).dupe(u32, (&[_]u32{})));
            };

            const operand_142 = block_143: {
                break :block_143 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            break :block_146 block_145: {
                const operand_144 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_144).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_140, .names = operand_142, });

                break :block_145 @as(*const (zx_abi).zx_type_18, operand_144);
            };
        };
        const operand_147 = block_148: {
            break :block_148 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_149 = @as(u32, 0);

        const operand_150 = block_157: {
            const operand_151 = @as([]const u8, "");
            const operand_152 = @as([]const u8, "");
            const operand_153 = @as(u64, 0);
            const operand_154 = @as(u64, 0);

            break :block_157 block_156: {
                const operand_155 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_155).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_151, .message = operand_152, .start = operand_153, .end = operand_154, });

                break :block_156 @as(*const (zx_abi).zx_type_31, operand_155);
            };
        };

        break :block_158 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .context = operand_125, .delta = operand_126, .cache = operand_129, .frames = operand_137, .scratch = operand_139, .active = operand_147, .result = operand_149, .diagnostic = operand_150, });
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    _ = buffers;

    const value_1: *const (zx_abi).zx_type_15 = block_378: {
        const operand_360 = block_361: {
            break :block_361 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        const operand_362 = block_363: {
            break :block_363 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_364 = block_365: {
            break :block_365 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_366 = block_367: {
            break :block_367 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_368 = block_369: {
            break :block_369 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_370 = block_371: {
            break :block_371 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_372 = block_373: {
            break :block_373 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_374 = block_375: {
            break :block_375 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_378 block_377: {
            const operand_376 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_376).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_360, .first = operand_362, .second = operand_364, .labels = operand_366, .children = operand_368, .field_types = operand_370, .field_names = operand_372, .names = operand_374, });

            break :block_377 @as(*const (zx_abi).zx_type_15, operand_376);
        };
    };

    const value_2: *const (zx_abi).zx_type_15 = block_359: {
        const operand_297 = block_309: {
            const operand_298 = @as(u8, 0);
            const operand_299 = @as(u8, 0);
            const operand_300 = @as(u8, 0);
            const operand_301 = @as(u8, 0);
            const operand_302 = @as(u8, 0);
            const operand_303 = @as(u8, 0);
            const operand_304 = @as(u8, 0);
            const operand_305 = @as(u8, 0);
            const operand_306 = @as(u8, 0);
            const operand_307 = @as(u8, 0);
            const operand_308 = @as(u8, 0);

            break :block_309 (try (allocator).dupe(u8, (&[_]u8{operand_298, operand_299, operand_300, operand_301, operand_302, operand_303, operand_304, operand_305, operand_306, operand_307, operand_308, })));
        };
        const operand_310 = block_322: {
            const operand_311 = @as(u32, 0);
            const operand_312 = @as(u32, 1);
            const operand_313 = @as(u32, 2);
            const operand_314 = @as(u32, 3);
            const operand_315 = @as(u32, 4);
            const operand_316 = @as(u32, 5);
            const operand_317 = @as(u32, 6);
            const operand_318 = @as(u32, 7);
            const operand_319 = @as(u32, 8);
            const operand_320 = @as(u32, 9);
            const operand_321 = @as(u32, 10);

            break :block_322 (try (allocator).dupe(u32, (&[_]u32{operand_311, operand_312, operand_313, operand_314, operand_315, operand_316, operand_317, operand_318, operand_319, operand_320, operand_321, })));
        };
        const operand_323 = block_335: {
            const operand_324 = @as(u32, 0);
            const operand_325 = @as(u32, 0);
            const operand_326 = @as(u32, 0);
            const operand_327 = @as(u32, 0);
            const operand_328 = @as(u32, 0);
            const operand_329 = @as(u32, 0);
            const operand_330 = @as(u32, 0);
            const operand_331 = @as(u32, 0);
            const operand_332 = @as(u32, 0);
            const operand_333 = @as(u32, 0);
            const operand_334 = @as(u32, 0);

            break :block_335 (try (allocator).dupe(u32, (&[_]u32{operand_324, operand_325, operand_326, operand_327, operand_328, operand_329, operand_330, operand_331, operand_332, operand_333, operand_334, })));
        };
        const operand_336 = block_348: {
            const operand_337 = @as([]const u8, "");
            const operand_338 = @as([]const u8, "");
            const operand_339 = @as([]const u8, "");
            const operand_340 = @as([]const u8, "");
            const operand_341 = @as([]const u8, "");
            const operand_342 = @as([]const u8, "");
            const operand_343 = @as([]const u8, "");
            const operand_344 = @as([]const u8, "");
            const operand_345 = @as([]const u8, "");
            const operand_346 = @as([]const u8, "");
            const operand_347 = @as([]const u8, "");

            break :block_348 (try (allocator).dupe([]const u8, (&[_][]const u8{operand_337, operand_338, operand_339, operand_340, operand_341, operand_342, operand_343, operand_344, operand_345, operand_346, operand_347, })));
        };

        const operand_349 = block_350: {
            break :block_350 (try (allocator).dupe(u32, (&[_]u32{})));
        };
        const operand_351 = block_352: {
            break :block_352 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        const operand_353 = block_354: {
            break :block_354 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_355 = block_356: {
            break :block_356 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        break :block_359 block_358: {
            const operand_357 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_357).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_297, .first = operand_310, .second = operand_323, .labels = operand_336, .children = operand_349, .field_types = operand_351, .field_names = operand_353, .names = operand_355, });

            break :block_358 @as(*const (zx_abi).zx_type_15, operand_357);
        };
    };

    const value_3: (zx_abi).zx_type_77 = (if ((in).named) @as((zx_abi).zx_type_77, .Name) else @as((zx_abi).zx_type_77, .Node));

    const value_4: []const *const (zx_abi).zx_type_80 = (if ((in).initialize) block_286: {
        break :block_286 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{})));
    } else block_296: {
        const operand_295 = block_294: {
            const operand_292 = block_291: {
                const operand_287 = block_288: {
                    break :block_288 value_3;
                };

                const operand_289 = (in).name;
                const operand_290 = (in).reference;

                break :block_291 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_287, .name = operand_289, .reference = operand_290, });
            };

            var state_borrow_293: (zx_abi).zx_type_85 = undefined;

            state_borrow_293 = (zx_abi).zx_type_85{ .name = (operand_292).name, .operation = (operand_292).operation, .reference = (operand_292).reference, };

            break :block_294 (try function_0(allocator, ((operand_292).zx_origin orelse (&state_borrow_293))));
        };

        break :block_296 (try (allocator).dupe(*const (zx_abi).zx_type_80, (&[_]*const (zx_abi).zx_type_80{operand_295, })));
    });

    return block_285: {
        const operand_252 = (in).context;

        const operand_253 = (if (((in).initialize and (@as(u64, ((((in).context).base).kinds).len) == @as(u64, 0)))) block_254: {
            break :block_254 value_2;
        } else block_255: {
            break :block_255 value_1;
        });

        const operand_256 = block_263: {
            const operand_257 = block_258: {
                break :block_258 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };
            const operand_259 = block_260: {
                break :block_260 (try (allocator).dupe(u32, (&[_]u32{})));
            };

            break :block_263 block_262: {
                const operand_261 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_261).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_257, .ids = operand_259, });

                break :block_262 @as(*const (zx_abi).zx_type_78, operand_261);
            };
        };
        const operand_264 = block_265: {
            break :block_265 value_4;
        };
        const operand_266 = block_273: {
            const operand_267 = block_268: {
                break :block_268 (try (allocator).dupe(u32, (&[_]u32{})));
            };
            const operand_269 = block_270: {
                break :block_270 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            break :block_273 block_272: {
                const operand_271 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_271).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_267, .names = operand_269, });

                break :block_272 @as(*const (zx_abi).zx_type_18, operand_271);
            };
        };
        const operand_274 = block_275: {
            break :block_275 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        const operand_276 = @as(u32, 0);

        const operand_277 = block_284: {
            const operand_278 = @as([]const u8, "");
            const operand_279 = @as([]const u8, "");
            const operand_280 = @as(u64, 0);
            const operand_281 = @as(u64, 0);

            break :block_284 block_283: {
                const operand_282 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_282).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_278, .message = operand_279, .start = operand_280, .end = operand_281, });

                break :block_283 @as(*const (zx_abi).zx_type_31, operand_282);
            };
        };

        break :block_285 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .context = operand_252, .delta = operand_253, .cache = operand_256, .frames = operand_264, .scratch = operand_266, .active = operand_274, .result = operand_276, .diagnostic = operand_277, });
    };
}

fn function_2(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_85) error{ OutOfMemory, }!*const (zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    return block_20: {
        const operand_1 = (in).operation;
        const operand_2 = (in).reference;
        const operand_3 = (in).name;

        const operand_4 = block_10: {
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_8).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_5, .start = operand_6, .end = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_60, operand_8);
            };
        };

        const operand_11 = false;
        const operand_12 = @as(u64, 0);
        const operand_13 = @as(u64, 0);
        const operand_14 = @as(u64, 0);
        const operand_15 = false;
        const operand_16 = @as(u64, 0);
        const operand_17 = @as(u64, 0);

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_80));

            (operand_18).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .operation = operand_1, .reference = operand_2, .name = operand_3, .declaration = operand_4, .waiting = operand_11, .index = operand_12, .position = operand_13, .count = operand_14, .list = operand_15, .children = operand_16, .fields = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_80, operand_18);
        };
    };
}

fn function_2_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_85) error{ OutOfMemory, }!(zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    return block_38: {
        const operand_21 = (in).operation;
        const operand_22 = (in).reference;
        const operand_23 = (in).name;

        const operand_24 = block_30: {
            const operand_25 = @as([]const u8, "");
            const operand_26 = @as(u64, 0);
            const operand_27 = @as(u64, 0);

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_28).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_25, .start = operand_26, .end = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_60, operand_28);
            };
        };

        const operand_31 = false;
        const operand_32 = @as(u64, 0);
        const operand_33 = @as(u64, 0);
        const operand_34 = @as(u64, 0);
        const operand_35 = false;
        const operand_36 = @as(u64, 0);
        const operand_37 = @as(u64, 0);

        break :block_38 (zx_abi).zx_type_80{ .operation = operand_21, .reference = operand_22, .name = operand_23, .declaration = operand_24, .waiting = operand_31, .index = operand_32, .position = operand_33, .count = operand_34, .list = operand_35, .children = operand_36, .fields = operand_37, };
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: []const u8) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_41: {
        const operand_1 = in;

        break :block_41 (if (block_40: {
            const operand_38 = operand_1;
            const operand_39 = @as([]const u8, "void");

            break :block_40 ((std).mem).eql(u8, operand_38, operand_39);
        }) @as(u64, 1) else (if (block_37: {
            const operand_35 = operand_1;
            const operand_36 = @as([]const u8, "bool");

            break :block_37 ((std).mem).eql(u8, operand_35, operand_36);
        }) @as(u64, 2) else (if (block_34: {
            const operand_32 = operand_1;
            const operand_33 = @as([]const u8, "boolean");

            break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
        }) @as(u64, 2) else (if (block_31: {
            const operand_29 = operand_1;
            const operand_30 = @as([]const u8, "u8");

            break :block_31 ((std).mem).eql(u8, operand_29, operand_30);
        }) @as(u64, 3) else (if (block_28: {
            const operand_26 = operand_1;
            const operand_27 = @as([]const u8, "u16");

            break :block_28 ((std).mem).eql(u8, operand_26, operand_27);
        }) @as(u64, 4) else (if (block_25: {
            const operand_23 = operand_1;
            const operand_24 = @as([]const u8, "u32");

            break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
        }) @as(u64, 5) else (if (block_22: {
            const operand_20 = operand_1;
            const operand_21 = @as([]const u8, "u64");

            break :block_22 ((std).mem).eql(u8, operand_20, operand_21);
        }) @as(u64, 6) else (if (block_19: {
            const operand_17 = operand_1;
            const operand_18 = @as([]const u8, "i32");

            break :block_19 ((std).mem).eql(u8, operand_17, operand_18);
        }) @as(u64, 7) else (if (block_16: {
            const operand_14 = operand_1;
            const operand_15 = @as([]const u8, "i64");

            break :block_16 ((std).mem).eql(u8, operand_14, operand_15);
        }) @as(u64, 8) else (if (block_13: {
            const operand_11 = operand_1;
            const operand_12 = @as([]const u8, "f32");

            break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
        }) @as(u64, 9) else (if (block_10: {
            const operand_8 = operand_1;
            const operand_9 = @as([]const u8, "f64");

            break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
        }) @as(u64, 10) else (if (block_7: {
            const operand_5 = operand_1;
            const operand_6 = @as([]const u8, "number");

            break :block_7 ((std).mem).eql(u8, operand_5, operand_6);
        }) @as(u64, 10) else (if (block_4: {
            const operand_2 = operand_1;
            const operand_3 = @as([]const u8, "string");

            break :block_4 ((std).mem).eql(u8, operand_2, operand_3);
        }) @as(u64, 11) else @as(u64, 0))))))))))))));
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_86) error{ OutOfMemory, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    return block_12: {
        const operand_1 = (in).state;

        const operand_2 = block_9: {
            const operand_3 = (in).code;
            const operand_4 = (in).message;
            const operand_5 = ((in).name).start;
            const operand_6 = ((in).name).end;

            break :block_9 block_8: {
                const operand_7 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_7).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_3, .message = operand_4, .start = operand_5, .end = operand_6, });

                break :block_8 @as(*const (zx_abi).zx_type_31, operand_7);
            };
        };

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_10).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = operand_2, .frames = (operand_1).frames, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_11 @as(*const (zx_abi).zx_type_82, operand_10);
        };
    };
}

fn function_4_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_22: {
        const operand_13 = (in).state;

        const operand_14 = block_21: {
            const operand_15 = (in).code;
            const operand_16 = (in).message;
            const operand_17 = ((in).name).start;
            const operand_18 = ((in).name).end;

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_19).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_15, .message = operand_16, .start = operand_17, .end = operand_18, });

                break :block_20 @as(*const (zx_abi).zx_type_31, operand_19);
            };
        };

        break :block_22 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_13).active, .cache = (operand_13).cache, .context = (operand_13).context, .delta = (operand_13).delta, .diagnostic = operand_14, .frames = (operand_13).frames, .result = (operand_13).result, .scratch = (operand_13).scratch, });
    };
}

fn function_4_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_32: {
        const operand_23 = (in).state;

        const operand_24 = block_31: {
            const operand_25 = (in).code;
            const operand_26 = (in).message;
            const operand_27 = ((in).name).start;
            const operand_28 = ((in).name).end;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_29).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_25, .message = operand_26, .start = operand_27, .end = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_31, operand_29);
            };
        };

        break :block_32 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_23).active, .cache = (operand_23).cache, .context = (operand_23).context, .delta = (operand_23).delta, .diagnostic = operand_24, .frames = (operand_23).frames, .result = (operand_23).result, .scratch = (operand_23).scratch, });
    };
}

fn function_5(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeBase64(allocator, in));

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidPadding, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeBase64(allocator, in));

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: []const u8) error{ OutOfMemory, Overflow, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeHex(allocator, in));

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidCharacter, InvalidHex, InvalidLength, NoSpaceLeft, OutOfMemory, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeHex(allocator, in));

    return native_result;
}

fn function_9(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).encodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_10(allocator: ((std).mem).Allocator, in: []const u8) error{ InvalidUtf8, }![]const u8 {
    const native_result = (try ((zx_native_0).encoding).decodeUtf8(in));

    _ = allocator;

    return native_result;
}

fn function_11(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_87) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_60 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = (try function_10(allocator, block_14: {
        const operand_7 = (in).source;
        const operand_8 = ((in).span).start;
        const operand_9 = (((in).span).end - ((in).span).start);

        const operand_11 = block_10: {
            break :block_10 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        if (((operand_8 > (operand_7).len) or (operand_9 > ((operand_7).len - operand_8)))) {
            return error.IndexOutOfBounds;
        }

        const operand_12 = @as(usize, @intCast(operand_8));
        const operand_13 = @as(usize, @intCast(operand_9));
        _ = (try ((std).math).add(usize, ((operand_7).len - operand_13), (operand_11).len));

        break :block_14 (operand_7)[operand_12..(operand_12 + operand_13)];
    }));

    return block_6: {
        const operand_1 = value_1;
        const operand_2 = ((in).span).start;
        const operand_3 = ((in).span).end;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_60));

            (operand_4).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_1, .start = operand_2, .end = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_60, operand_4);
        };
    };
}

fn function_11_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_87) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).zx_type_60 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = (try function_10(allocator, block_26: {
        const operand_19 = (in).source;
        const operand_20 = ((in).span).start;
        const operand_21 = (((in).span).end - ((in).span).start);

        const operand_23 = block_22: {
            break :block_22 (try (allocator).dupe(u8, (&[_]u8{})));
        };

        if (((operand_20 > (operand_19).len) or (operand_21 > ((operand_19).len - operand_20)))) {
            return error.IndexOutOfBounds;
        }

        const operand_24 = @as(usize, @intCast(operand_20));
        const operand_25 = @as(usize, @intCast(operand_21));

        _ = (try ((std).math).add(usize, ((operand_19).len - operand_25), (operand_23).len));

        break :block_26 (operand_19)[operand_24..(operand_24 + operand_25)];
    }));

    return block_18: {
        const operand_15 = value_1;
        const operand_16 = ((in).span).start;
        const operand_17 = ((in).span).end;

        break :block_18 (zx_abi).zx_type_60{ .text = operand_15, .start = operand_16, .end = operand_17, };
    };
}

fn function_12(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_89) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_65 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return block_21: {
            const operand_19 = (value_1.?).declarations;
            const operand_20 = (in).index;

            if ((operand_20 >= (operand_19).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_21 (operand_19)[@intCast(operand_20)];
        };
    }

    const value_2: *const (zx_abi).zx_type_55 = block_18: {
        const operand_16 = (((in).source).indexed).declarations;
        const operand_17 = (in).index;

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    };

    return block_15: {
        const operand_1 = (try function_11(allocator, block_6: {
            const operand_2 = (((in).source).indexed).bytes;
            const operand_3 = (value_2).name;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_4).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_2, .span = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_87, operand_4);
            };
        }));

        const operand_7 = block_12: {
            const operand_8 = (value_2).enumeration;
            const operand_9 = (if ((value_2).enumeration) (in).index else (value_2).value);

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_10).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_8, .index = operand_9, });

                break :block_11 @as(*const (zx_abi).zx_type_61, operand_10);
            };
        };

        break :block_15 block_14: {
            const operand_13 = (try (allocator).create((zx_abi).zx_type_65));

            (operand_13).* = @as((zx_abi).zx_type_65, (zx_abi).zx_type_65{ .name = operand_1, .value = operand_7, });

            break :block_14 @as(*const (zx_abi).zx_type_65, operand_13);
        };
    };
}

fn function_12_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_89) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).zx_type_65 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return (block_40: {
            const operand_38 = (value_1.?).declarations;
            const operand_39 = (in).index;

            if ((operand_39 >= (operand_38).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_40 (operand_38)[@intCast(operand_39)];
        }).*;
    }

    const value_2: (zx_abi).zx_type_55 = (block_37: {
        const operand_35 = (((in).source).indexed).declarations;
        const operand_36 = (in).index;

        if ((operand_36 >= (operand_35).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_37 (operand_35)[@intCast(operand_36)];
    }).*;

    return block_34: {
        const operand_22 = (try function_11(allocator, block_27: {
            const operand_23 = (((in).source).indexed).bytes;
            const operand_24 = ((&value_2)).name;

            break :block_27 block_26: {
                const operand_25 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_25).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_23, .span = operand_24, });

                break :block_26 @as(*const (zx_abi).zx_type_87, operand_25);
            };
        }));

        const operand_28 = block_33: {
            const operand_29 = ((&value_2)).enumeration;
            const operand_30 = (if (((&value_2)).enumeration) (in).index else ((&value_2)).value);

            break :block_33 block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_31).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_29, .index = operand_30, });

                break :block_32 @as(*const (zx_abi).zx_type_61, operand_31);
            };
        };

        break :block_34 (zx_abi).zx_type_65{ .name = operand_22, .value = operand_28, };
    };
}

fn function_13(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_90) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_91 {
    @setRuntimeSafety(true);

    const value_16: *const (zx_abi).zx_type_92 = block_35: {
        var state_6: *const (zx_abi).zx_type_92 = block_15: {
            const operand_7 = (in).source;
            const operand_8 = (in).name;
            const operand_9 = (in).limit;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = @as(u64, 0);

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_92));

                (operand_13).* = @as((zx_abi).zx_type_92, (zx_abi).zx_type_92{ .source = operand_7, .name = operand_8, .limit = operand_9, .index = operand_10, .found = operand_11, .selected = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_92, operand_13);
            };
        };

        while (((!(state_6).found) and ((state_6).index < (state_6).limit))) {
            state_6 = block_33: {
                const value_3: *const (zx_abi).zx_type_65 = (try function_12(allocator, block_32: {
                    const operand_28 = (state_6).source;
                    const operand_29 = (state_6).index;

                    break :block_32 block_31: {
                        const operand_30 = (try (allocator).create((zx_abi).zx_type_89));

                        (operand_30).* = @as((zx_abi).zx_type_89, (zx_abi).zx_type_89{ .source = operand_28, .index = operand_29, });

                        break :block_31 @as(*const (zx_abi).zx_type_89, operand_30);
                    };
                }));

                const value_4: *const (zx_abi).zx_type_92 = state_6;

                _ = (value_4).found;

                const value_6: bool = block_27: {
                    const operand_25 = ((value_3).name).text;
                    const operand_26 = (state_6).name;

                    break :block_27 ((std).mem).eql(u8, operand_25, operand_26);
                };

                const value_7: *const (zx_abi).zx_type_92 = block_24: {
                    break :block_24 block_23: {
                        const operand_22 = (try (allocator).create((zx_abi).zx_type_92));

                        (operand_22).* = @as((zx_abi).zx_type_92, (zx_abi).zx_type_92{ .found = value_6, .index = (value_4).index, .limit = (value_4).limit, .name = (value_4).name, .selected = (value_4).selected, .source = (value_4).source, });

                        break :block_23 @as(*const (zx_abi).zx_type_92, operand_22);
                    };
                };
                const value_8: *const (zx_abi).zx_type_92 = value_7;
                _ = (value_8).selected;
                const value_10: u64 = (value_7).index;

                const value_11: *const (zx_abi).zx_type_92 = block_21: {
                    break :block_21 block_20: {
                        const operand_19 = (try (allocator).create((zx_abi).zx_type_92));

                        (operand_19).* = @as((zx_abi).zx_type_92, (zx_abi).zx_type_92{ .found = (value_8).found, .index = (value_8).index, .limit = (value_8).limit, .name = (value_8).name, .selected = value_10, .source = (value_8).source, });

                        break :block_20 @as(*const (zx_abi).zx_type_92, operand_19);
                    };
                };

                const value_12: *const (zx_abi).zx_type_92 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: *const (zx_abi).zx_type_92 = block_18: {
                    break :block_18 block_17: {
                        const operand_16 = (try (allocator).create((zx_abi).zx_type_92));

                        (operand_16).* = @as((zx_abi).zx_type_92, (zx_abi).zx_type_92{ .found = (value_12).found, .index = (value_13 + value_14), .limit = (value_12).limit, .name = (value_12).name, .selected = (value_12).selected, .source = (value_12).source, });

                        break :block_17 @as(*const (zx_abi).zx_type_92, operand_16);
                    };
                };

                break :block_33 value_15;
            };
        }

        break :block_35 state_6;
    };

    return block_5: {
        const operand_1 = (value_16).found;
        const operand_2 = (value_16).selected;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_91));

            (operand_3).* = @as((zx_abi).zx_type_91, (zx_abi).zx_type_91{ .found = operand_1, .index = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_91, operand_3);
        };
    };
}

fn function_13_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_16: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_69: {
        const operand_47 = block_46: {
            const operand_40 = (in).source;
            const operand_41 = (in).name;
            const operand_42 = (in).limit;
            const operand_43 = @as(u64, 0);
            const operand_44 = false;
            const operand_45 = @as(u64, 0);

            break :block_46 @as((zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .source = operand_40, .name = operand_41, .limit = operand_42, .index = operand_43, .found = operand_44, .selected = operand_45, });
        };

        var state_39: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_47;
        var state_changed_48 = false;

        while (((!(state_39).found) and ((state_39).index < (state_39).limit))) {
            state_39 = block_67: {
                const value_3: *const (zx_abi).zx_type_65 = block_66: {
                    const operand_63 = block_62: {
                        const operand_60 = (state_39).source;
                        const operand_61 = (state_39).index;

                        break :block_62 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_60, .index = operand_61, });
                    };

                    break :block_66 (try function_12(allocator, (if (((operand_63).zx_origin != null)) (operand_63).zx_origin.? else block_65: {
                        const operand_64 = (try (allocator).create((zx_abi).zx_type_89));

                        (operand_64).* = (zx_abi).zx_type_89{ .index = (operand_63).index, .source = (operand_63).source, };

                        break :block_65 @as(*const (zx_abi).zx_type_89, operand_64);
                    })));
                };

                const value_4: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_39;

                _ = (value_4).found;

                const value_6: bool = block_59: {
                    const operand_57 = ((block_56: {
                        break :block_56 value_3;
                    }).name).text;

                    const operand_58 = (state_39).name;

                    break :block_59 ((std).mem).eql(u8, operand_57, operand_58);
                };

                const value_7: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_55: {
                    break :block_55 @as((zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .found = block_54: {
                        break :block_54 value_6;
                    }, .index = (value_4).index, .limit = (value_4).limit, .name = (value_4).name, .selected = (value_4).selected, .source = (value_4).source, });
                };

                const value_8: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_7;

                _ = (value_8).selected;

                const value_10: u64 = (value_7).index;

                const value_11: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_53: {
                    break :block_53 @as((zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .found = (value_8).found, .index = (value_8).index, .limit = (value_8).limit, .name = (value_8).name, .selected = block_52: {
                        break :block_52 value_10;
                    }, .source = (value_8).source, });
                };

                const value_12: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_51: {
                    break :block_51 @as((zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .found = (value_12).found, .index = (block_49: {
                        break :block_49 value_13;
                    } + block_50: {
                        break :block_50 value_14;
                    }), .limit = (value_12).limit, .name = (value_12).name, .selected = (value_12).selected, .source = (value_12).source, });
                };

                break :block_67 value_15;
            };

            state_changed_48 = true;
        }

        break :block_69 (if (state_changed_48) state_39 else operand_47);
    };

    return block_38: {
        const operand_36 = (value_16).found;
        const operand_37 = (value_16).selected;

        break :block_38 @as((zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_36, .index = operand_37, });
    };
}

fn function_14(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_93) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_65 = (try function_12(allocator, block_28: {
        const operand_24 = (((in).state).context).source;
        const operand_25 = (in).index;

        break :block_28 block_27: {
            const operand_26 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_26).* = @as((zx_abi).zx_type_89, (zx_abi).zx_type_89{ .source = operand_24, .index = operand_25, });

            break :block_27 @as(*const (zx_abi).zx_type_89, operand_26);
        };
    }));

    if ((((try function_3(allocator, ((value_1).name).text)) != @as(u64, 0)) or block_16: {
        const operand_14 = ((value_1).name).text;
        const operand_15 = @as([]const u8, "Array");

        break :block_16 ((std).mem).eql(u8, operand_14, operand_15);
    })) {
        return (try function_4(allocator, block_23: {
            const operand_17 = (in).state;
            const operand_18 = @as([]const u8, "name");
            const operand_19 = @as([]const u8, "a type cannot replace a built-in scalar");
            const operand_20 = (value_1).name;

            break :block_23 block_22: {
                const operand_21 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_21).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_17, .code = operand_18, .message = operand_19, .name = operand_20, });

                break :block_22 @as(*const (zx_abi).zx_type_86, operand_21);
            };
        }));
    }

    const value_2: *const (zx_abi).zx_type_91 = (try function_13(allocator, block_13: {
        const operand_8 = (((in).state).context).source;
        const operand_9 = ((value_1).name).text;
        const operand_10 = (in).index;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_90));

            (operand_11).* = @as((zx_abi).zx_type_90, (zx_abi).zx_type_90{ .source = operand_8, .name = operand_9, .limit = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_90, operand_11);
        };
    }));

    if ((value_2).found) {
        return (try function_4(allocator, block_7: {
            const operand_1 = (in).state;
            const operand_2 = @as([]const u8, "name");
            const operand_3 = @as([]const u8, "duplicate type declaration");
            const operand_4 = (value_1).name;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_5).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_1, .code = operand_2, .message = operand_3, .name = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_86, operand_5);
            };
        }));
    }

    return (in).state;
}

fn function_14_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_65 = block_62: {
        const operand_59 = block_58: {
            const operand_56 = (((in).state).context).source;
            const operand_57 = (in).index;

            break :block_58 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_56, .index = operand_57, });
        };

        break :block_62 (try function_12(allocator, (if (((operand_59).zx_origin != null)) (operand_59).zx_origin.? else block_61: {
            const operand_60 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_60).* = (zx_abi).zx_type_89{ .index = (operand_59).index, .source = (operand_59).source, };

            break :block_61 @as(*const (zx_abi).zx_type_89, operand_60);
        })));
    };

    if (((block_44: {
        const operand_43 = ((block_42: {
            break :block_42 value_1;
        }).name).text;

        break :block_44 (try function_3(allocator, operand_43));
    } != @as(u64, 0)) or block_48: {
        const operand_46 = ((block_45: {
            break :block_45 value_1;
        }).name).text;

        const operand_47 = @as([]const u8, "Array");

        break :block_48 ((std).mem).eql(u8, operand_46, operand_47);
    })) {
        return block_55: {
            break :block_55 (try function_4_value(allocator, block_54: {
                const operand_49 = (in).state;
                const operand_50 = @as([]const u8, "name");
                const operand_51 = @as([]const u8, "a type cannot replace a built-in scalar");

                const operand_52 = (block_53: {
                    break :block_53 value_1;
                }).name;

                break :block_54 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_49, .code = operand_50, .message = operand_51, .name = operand_52, });
            }));
        };
    }

    const value_2: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_41: {
        break :block_41 (try function_13_value(allocator, block_40: {
            const operand_36 = (((in).state).context).source;

            const operand_37 = ((block_38: {
                break :block_38 value_1;
            }).name).text;

            const operand_39 = (in).index;

            break :block_40 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_36, .name = operand_37, .limit = operand_39, });
        }));
    };

    if ((value_2).found) {
        return block_35: {
            break :block_35 (try function_4_value(allocator, block_34: {
                const operand_29 = (in).state;
                const operand_30 = @as([]const u8, "name");
                const operand_31 = @as([]const u8, "duplicate type declaration");

                const operand_32 = (block_33: {
                    break :block_33 value_1;
                }).name;

                break :block_34 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_29, .code = operand_30, .message = operand_31, .name = operand_32, });
            }));
        };
    }

    return (in).state;
}

fn function_14_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_65 = block_96: {
        const operand_93 = block_92: {
            const operand_90 = (((in).state).context).source;
            const operand_91 = (in).index;

            break :block_92 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_90, .index = operand_91, });
        };

        break :block_96 (try function_12(allocator, (if (((operand_93).zx_origin != null)) (operand_93).zx_origin.? else block_95: {
            const operand_94 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_94).* = (zx_abi).zx_type_89{ .index = (operand_93).index, .source = (operand_93).source, };

            break :block_95 @as(*const (zx_abi).zx_type_89, operand_94);
        })));
    };

    if (((block_78: {
        const operand_77 = ((block_76: {
            break :block_76 value_1;
        }).name).text;

        break :block_78 (try function_3(allocator, operand_77));
    } != @as(u64, 0)) or block_82: {
        const operand_80 = ((block_79: {
            break :block_79 value_1;
        }).name).text;

        const operand_81 = @as([]const u8, "Array");

        break :block_82 ((std).mem).eql(u8, operand_80, operand_81);
    })) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_89: {
            break :block_89 (try function_4_buffered(allocator, block_88: {
                const operand_83 = (in).state;
                const operand_84 = @as([]const u8, "name");
                const operand_85 = @as([]const u8, "a type cannot replace a built-in scalar");

                const operand_86 = (block_87: {
                    break :block_87 value_1;
                }).name;

                break :block_88 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_83, .code = operand_84, .message = operand_85, .name = operand_86, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_2: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_75: {
        break :block_75 (try function_13_value(allocator, block_74: {
            const operand_70 = (((in).state).context).source;

            const operand_71 = ((block_72: {
                break :block_72 value_1;
            }).name).text;

            const operand_73 = (in).index;

            break :block_74 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_70, .name = operand_71, .limit = operand_73, });
        }));
    };

    if ((value_2).found) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_69: {
            break :block_69 (try function_4_buffered(allocator, block_68: {
                const operand_63 = (in).state;
                const operand_64 = @as([]const u8, "name");
                const operand_65 = @as([]const u8, "duplicate type declaration");

                const operand_66 = (block_67: {
                    break :block_67 value_1;
                }).name;

                break :block_68 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_63, .code = operand_64, .message = operand_65, .name = operand_66, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    return (in).state;
}

fn function_15(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_94) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_20: {
        const operand_7 = block_6: {
            const operand_2 = (in).names;
            const operand_3 = (in).name;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 (zx_abi).zx_type_95{ .names = operand_2, .name = operand_3, .index = operand_4, .found = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .found = (operand_7).found, .index = (operand_7).index, .name = (operand_7).name, .names = (operand_7).names, .zx_origin = (&operand_7), };

        while (((!(state_1).found) and ((state_1).index < @as(u64, ((state_1).names).len)))) {
            state_1 = block_19: {
                const value_3: (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;
                _ = (value_3).found;

                const value_5: bool = block_18: {
                    const operand_16 = block_15: {
                        const operand_13 = (state_1).names;
                        const operand_14 = (state_1).index;

                        if ((operand_14 >= (operand_13).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_15 (operand_13)[@intCast(operand_14)];
                    };

                    const operand_17 = (state_1).name;

                    break :block_18 ((std).mem).eql(u8, operand_16, operand_17);
                };

                const value_6: (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .found = block_11: {
                        break :block_11 value_5;
                    }, .index = (value_3).index, .name = (value_3).name, .names = (value_3).names, });
                };

                const value_7: (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_6;
                const value_8: u64 = (value_7).index;
                const value_9: u64 = @as(u64, 1);

                const value_10: (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .found = (value_7).found, .index = (block_8: {
                        break :block_8 value_8;
                    } + block_9: {
                        break :block_9 value_9;
                    }), .name = (value_7).name, .names = (value_7).names, });
                };

                break :block_19 value_10;
            };
        }

        break :block_20 (state_1).found;
    };
}

fn function_16(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_76) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: ?*const (zx_abi).zx_type_73 = (in).native;

    return (if ((value_1 != null)) @as(u64, ((value_1.?).declarations).len) else @as(u64, (((in).indexed).declarations).len));
}

fn function_17(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_93) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_62: {
        const operand_60 = ((((in).state).context).aliases).names;
        const operand_61 = (in).index;

        if ((operand_61 >= (operand_60).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_62 (operand_60)[@intCast(operand_61)];
    };

    if ((((try function_3(allocator, value_1)) != @as(u64, 0)) or block_46: {
        const operand_44 = value_1;
        const operand_45 = @as([]const u8, "Array");

        break :block_46 ((std).mem).eql(u8, operand_44, operand_45);
    })) {
        return (try function_4(allocator, block_59: {
            const operand_47 = (in).state;
            const operand_48 = @as([]const u8, "name");
            const operand_49 = @as([]const u8, "an imported type cannot replace a built-in type");

            const operand_50 = block_56: {
                const operand_51 = value_1;
                const operand_52 = @as(u64, 0);
                const operand_53 = @as(u64, 0);

                break :block_56 block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_54).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_51, .start = operand_52, .end = operand_53, });

                    break :block_55 @as(*const (zx_abi).zx_type_60, operand_54);
                };
            };

            break :block_59 block_58: {
                const operand_57 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_57).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_47, .code = operand_48, .message = operand_49, .name = operand_50, });

                break :block_58 @as(*const (zx_abi).zx_type_86, operand_57);
            };
        }));
    }

    const value_2: []const []const u8 = block_43: {
        const operand_36 = ((((in).state).context).aliases).names;
        const operand_37 = @as(u64, 0);
        const operand_38 = (in).index;

        const operand_40 = block_39: {
            break :block_39 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_37 > (operand_36).len) or (operand_38 > ((operand_36).len - operand_37)))) {
            return error.IndexOutOfBounds;
        }

        const operand_41 = @as(usize, @intCast(operand_37));
        const operand_42 = @as(usize, @intCast(operand_38));

        _ = (try ((std).math).add(usize, ((operand_36).len - operand_42), (operand_40).len));

        break :block_43 (operand_36)[operand_41..(operand_41 + operand_42)];
    };

    if (block_22: {
        const operand_19 = value_2;
        const operand_20 = value_1;
        const operand_21 = (zx_abi).zx_type_94{ .names = operand_19, .name = operand_20, };

        break :block_22 (try function_15(allocator, (&operand_21)));
    }) {
        return (try function_4(allocator, block_35: {
            const operand_23 = (in).state;
            const operand_24 = @as([]const u8, "name");
            const operand_25 = @as([]const u8, "duplicate imported type name");

            const operand_26 = block_32: {
                const operand_27 = value_1;
                const operand_28 = @as(u64, 0);
                const operand_29 = @as(u64, 0);

                break :block_32 block_31: {
                    const operand_30 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_30).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_27, .start = operand_28, .end = operand_29, });

                    break :block_31 @as(*const (zx_abi).zx_type_60, operand_30);
                };
            };

            break :block_35 block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_33).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_23, .code = operand_24, .message = operand_25, .name = operand_26, });

                break :block_34 @as(*const (zx_abi).zx_type_86, operand_33);
            };
        }));
    }

    const value_3: *const (zx_abi).zx_type_91 = (try function_13(allocator, block_18: {
        const operand_13 = (((in).state).context).source;
        const operand_14 = value_1;
        const operand_15 = (try function_16(allocator, (((in).state).context).source));

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_90));

            (operand_16).* = @as((zx_abi).zx_type_90, (zx_abi).zx_type_90{ .source = operand_13, .name = operand_14, .limit = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_90, operand_16);
        };
    }));

    if ((value_3).found) {
        const value_4: *const (zx_abi).zx_type_65 = (try function_12(allocator, block_12: {
            const operand_8 = (((in).state).context).source;
            const operand_9 = (value_3).index;

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_89));

                (operand_10).* = @as((zx_abi).zx_type_89, (zx_abi).zx_type_89{ .source = operand_8, .index = operand_9, });

                break :block_11 @as(*const (zx_abi).zx_type_89, operand_10);
            };
        }));

        return (try function_4(allocator, block_7: {
            const operand_1 = (in).state;
            const operand_2 = @as([]const u8, "name");
            const operand_3 = @as([]const u8, "a local type cannot replace an imported type");
            const operand_4 = (value_4).name;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_5).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_1, .code = operand_2, .message = operand_3, .name = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_86, operand_5);
            };
        }));
    }

    return (in).state;
}

fn function_17_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_134: {
        const operand_132 = ((((in).state).context).aliases).names;
        const operand_133 = (in).index;

        if ((operand_133 >= (operand_132).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_134 (operand_132)[@intCast(operand_133)];
    };

    if (((block_114: {
        const operand_113 = block_112: {
            break :block_112 value_1;
        };

        break :block_114 (try function_3(allocator, operand_113));
    } != @as(u64, 0)) or block_118: {
        const operand_116 = block_115: {
            break :block_115 value_1;
        };

        const operand_117 = @as([]const u8, "Array");

        break :block_118 ((std).mem).eql(u8, operand_116, operand_117);
    })) {
        return block_131: {
            break :block_131 (try function_4_value(allocator, block_130: {
                const operand_119 = (in).state;
                const operand_120 = @as([]const u8, "name");
                const operand_121 = @as([]const u8, "an imported type cannot replace a built-in type");

                const operand_122 = block_129: {
                    const operand_123 = block_124: {
                        break :block_124 value_1;
                    };

                    const operand_125 = @as(u64, 0);
                    const operand_126 = @as(u64, 0);

                    break :block_129 block_128: {
                        const operand_127 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_127).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_123, .start = operand_125, .end = operand_126, });

                        break :block_128 @as(*const (zx_abi).zx_type_60, operand_127);
                    };
                };

                break :block_130 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_119, .code = operand_120, .message = operand_121, .name = operand_122, });
            }));
        };
    }

    const value_2: []const []const u8 = block_111: {
        const operand_104 = ((((in).state).context).aliases).names;
        const operand_105 = @as(u64, 0);
        const operand_106 = (in).index;

        const operand_108 = block_107: {
            break :block_107 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_105 > (operand_104).len) or (operand_106 > ((operand_104).len - operand_105)))) {
            return error.IndexOutOfBounds;
        }

        const operand_109 = @as(usize, @intCast(operand_105));
        const operand_110 = @as(usize, @intCast(operand_106));

        _ = (try ((std).math).add(usize, ((operand_104).len - operand_110), (operand_108).len));

        break :block_111 (operand_104)[operand_109..(operand_109 + operand_110)];
    };

    if (block_90: {
        const operand_86 = block_85: {
            break :block_85 value_2;
        };

        const operand_88 = block_87: {
            break :block_87 value_1;
        };

        const operand_89 = (zx_abi).zx_type_94{ .names = operand_86, .name = operand_88, };

        break :block_90 (try function_15(allocator, (&operand_89)));
    }) {
        return block_103: {
            break :block_103 (try function_4_value(allocator, block_102: {
                const operand_91 = (in).state;
                const operand_92 = @as([]const u8, "name");
                const operand_93 = @as([]const u8, "duplicate imported type name");

                const operand_94 = block_101: {
                    const operand_95 = block_96: {
                        break :block_96 value_1;
                    };

                    const operand_97 = @as(u64, 0);
                    const operand_98 = @as(u64, 0);

                    break :block_101 block_100: {
                        const operand_99 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_99).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_95, .start = operand_97, .end = operand_98, });

                        break :block_100 @as(*const (zx_abi).zx_type_60, operand_99);
                    };
                };

                break :block_102 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_91, .code = operand_92, .message = operand_93, .name = operand_94, });
            }));
        };
    }

    const value_3: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_84: {
        break :block_84 (try function_13_value(allocator, block_83: {
            const operand_77 = (((in).state).context).source;

            const operand_78 = block_79: {
                break :block_79 value_1;
            };

            const operand_80 = block_82: {
                const operand_81 = (((in).state).context).source;

                break :block_82 (try function_16(allocator, operand_81));
            };

            break :block_83 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_77, .name = operand_78, .limit = operand_80, });
        }));
    };

    if ((value_3).found) {
        const value_4: *const (zx_abi).zx_type_65 = block_76: {
            const operand_73 = block_72: {
                const operand_70 = (((in).state).context).source;
                const operand_71 = (value_3).index;

                break :block_72 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_70, .index = operand_71, });
            };

            break :block_76 (try function_12(allocator, (if (((operand_73).zx_origin != null)) (operand_73).zx_origin.? else block_75: {
                const operand_74 = (try (allocator).create((zx_abi).zx_type_89));

                (operand_74).* = (zx_abi).zx_type_89{ .index = (operand_73).index, .source = (operand_73).source, };

                break :block_75 @as(*const (zx_abi).zx_type_89, operand_74);
            })));
        };

        return block_69: {
            break :block_69 (try function_4_value(allocator, block_68: {
                const operand_63 = (in).state;
                const operand_64 = @as([]const u8, "name");
                const operand_65 = @as([]const u8, "a local type cannot replace an imported type");

                const operand_66 = (block_67: {
                    break :block_67 value_4;
                }).name;

                break :block_68 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_63, .code = operand_64, .message = operand_65, .name = operand_66, });
            }));
        };
    }

    return (in).state;
}

fn function_17_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_206: {
        const operand_204 = ((((in).state).context).aliases).names;
        const operand_205 = (in).index;

        if ((operand_205 >= (operand_204).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_206 (operand_204)[@intCast(operand_205)];
    };

    if (((block_186: {
        const operand_185 = block_184: {
            break :block_184 value_1;
        };

        break :block_186 (try function_3(allocator, operand_185));
    } != @as(u64, 0)) or block_190: {
        const operand_188 = block_187: {
            break :block_187 value_1;
        };

        const operand_189 = @as([]const u8, "Array");

        break :block_190 ((std).mem).eql(u8, operand_188, operand_189);
    })) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_203: {
            break :block_203 (try function_4_buffered(allocator, block_202: {
                const operand_191 = (in).state;
                const operand_192 = @as([]const u8, "name");
                const operand_193 = @as([]const u8, "an imported type cannot replace a built-in type");

                const operand_194 = block_201: {
                    const operand_195 = block_196: {
                        break :block_196 value_1;
                    };

                    const operand_197 = @as(u64, 0);
                    const operand_198 = @as(u64, 0);

                    break :block_201 block_200: {
                        const operand_199 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_199).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_195, .start = operand_197, .end = operand_198, });

                        break :block_200 @as(*const (zx_abi).zx_type_60, operand_199);
                    };
                };

                break :block_202 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_191, .code = operand_192, .message = operand_193, .name = operand_194, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = null, .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_2: []const []const u8 = block_183: {
        const operand_176 = ((((in).state).context).aliases).names;
        const operand_177 = @as(u64, 0);
        const operand_178 = (in).index;

        const operand_180 = block_179: {
            break :block_179 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_177 > (operand_176).len) or (operand_178 > ((operand_176).len - operand_177)))) {
            return error.IndexOutOfBounds;
        }

        const operand_181 = @as(usize, @intCast(operand_177));
        const operand_182 = @as(usize, @intCast(operand_178));

        _ = (try ((std).math).add(usize, ((operand_176).len - operand_182), (operand_180).len));

        break :block_183 (operand_176)[operand_181..(operand_181 + operand_182)];
    };

    if (block_162: {
        const operand_158 = block_157: {
            break :block_157 value_2;
        };

        const operand_160 = block_159: {
            break :block_159 value_1;
        };

        const operand_161 = (zx_abi).zx_type_94{ .names = operand_158, .name = operand_160, };

        break :block_162 (try function_15(allocator, (&operand_161)));
    }) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_175: {
            break :block_175 (try function_4_buffered(allocator, block_174: {
                const operand_163 = (in).state;
                const operand_164 = @as([]const u8, "name");
                const operand_165 = @as([]const u8, "duplicate imported type name");

                const operand_166 = block_173: {
                    const operand_167 = block_168: {
                        break :block_168 value_1;
                    };

                    const operand_169 = @as(u64, 0);
                    const operand_170 = @as(u64, 0);

                    break :block_173 block_172: {
                        const operand_171 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_171).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_167, .start = operand_169, .end = operand_170, });

                        break :block_172 @as(*const (zx_abi).zx_type_60, operand_171);
                    };
                };

                break :block_174 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_163, .code = operand_164, .message = operand_165, .name = operand_166, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = null, .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_3: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_156: {
        break :block_156 (try function_13_value(allocator, block_155: {
            const operand_149 = (((in).state).context).source;

            const operand_150 = block_151: {
                break :block_151 value_1;
            };

            const operand_152 = block_154: {
                const operand_153 = (((in).state).context).source;

                break :block_154 (try function_16(allocator, operand_153));
            };

            break :block_155 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_149, .name = operand_150, .limit = operand_152, });
        }));
    };

    if ((value_3).found) {
        const value_4: *const (zx_abi).zx_type_65 = block_148: {
            const operand_145 = block_144: {
                const operand_142 = (((in).state).context).source;
                const operand_143 = (value_3).index;

                break :block_144 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_142, .index = operand_143, });
            };

            break :block_148 (try function_12(allocator, (if (((operand_145).zx_origin != null)) (operand_145).zx_origin.? else block_147: {
                const operand_146 = (try (allocator).create((zx_abi).zx_type_89));

                (operand_146).* = (zx_abi).zx_type_89{ .index = (operand_145).index, .source = (operand_145).source, };

                break :block_147 @as(*const (zx_abi).zx_type_89, operand_146);
            })));
        };

        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_141: {
            break :block_141 (try function_4_buffered(allocator, block_140: {
                const operand_135 = (in).state;
                const operand_136 = @as([]const u8, "name");
                const operand_137 = @as([]const u8, "a local type cannot replace an imported type");

                const operand_138 = (block_139: {
                    break :block_139 value_4;
                }).name;

                break :block_140 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_135, .code = operand_136, .message = operand_137, .name = operand_138, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = null, .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    return (in).state;
}

fn function_18(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_11: *const (zx_abi).zx_type_93 = block_47: {
        var state_25: *const (zx_abi).zx_type_93 = block_30: {
            const operand_26 = in;
            const operand_27 = @as(u64, 0);

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_93));

                (operand_28).* = @as((zx_abi).zx_type_93, (zx_abi).zx_type_93{ .state = operand_26, .index = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_93, operand_28);
            };
        };

        while ((((state_25).index < @as(u64, (((((state_25).state).context).aliases).names).len)) and block_33: {
            const operand_31 = (((state_25).state).diagnostic).message;
            const operand_32 = @as([]const u8, "");

            break :block_33 ((std).mem).eql(u8, operand_31, operand_32);
        })) {
            state_25 = block_45: {
                const value_3: *const (zx_abi).zx_type_93 = state_25;

                _ = (value_3).state;

                const value_5: *const (zx_abi).zx_type_82 = (try function_17(allocator, block_44: {
                    const operand_40 = (state_25).state;
                    const operand_41 = (state_25).index;

                    break :block_44 block_43: {
                        const operand_42 = (try (allocator).create((zx_abi).zx_type_93));

                        (operand_42).* = @as((zx_abi).zx_type_93, (zx_abi).zx_type_93{ .state = operand_40, .index = operand_41, });

                        break :block_43 @as(*const (zx_abi).zx_type_93, operand_42);
                    };
                }));

                const value_6: *const (zx_abi).zx_type_93 = block_39: {
                    break :block_39 block_38: {
                        const operand_37 = (try (allocator).create((zx_abi).zx_type_93));

                        (operand_37).* = @as((zx_abi).zx_type_93, (zx_abi).zx_type_93{ .index = (value_3).index, .state = value_5, });

                        break :block_38 @as(*const (zx_abi).zx_type_93, operand_37);
                    };
                };
                const value_7: *const (zx_abi).zx_type_93 = value_6;
                const value_8: u64 = (value_7).index;
                const value_9: u64 = @as(u64, 1);

                const value_10: *const (zx_abi).zx_type_93 = block_36: {
                    break :block_36 block_35: {
                        const operand_34 = (try (allocator).create((zx_abi).zx_type_93));

                        (operand_34).* = @as((zx_abi).zx_type_93, (zx_abi).zx_type_93{ .index = (value_8 + value_9), .state = (value_7).state, });

                        break :block_35 @as(*const (zx_abi).zx_type_93, operand_34);
                    };
                };

                break :block_45 value_10;
            };
        }

        break :block_47 state_25;
    };

    const value_22: *const (zx_abi).zx_type_97 = block_24: {
        var state_1: *const (zx_abi).zx_type_97 = block_7: {
            const operand_2 = (value_11).state;
            const operand_3 = @as(u64, 0);
            const operand_4 = (try function_16(allocator, ((in).context).source));

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_97));

                (operand_5).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .state = operand_2, .index = operand_3, .count = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_97, operand_5);
            };
        };

        while ((((state_1).index < (state_1).count) and block_10: {
            const operand_8 = (((state_1).state).diagnostic).message;
            const operand_9 = @as([]const u8, "");

            break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
        })) {
            state_1 = block_22: {
                const value_14: *const (zx_abi).zx_type_97 = state_1;
                _ = (value_14).state;

                const value_16: *const (zx_abi).zx_type_82 = (try function_14(allocator, block_21: {
                    const operand_17 = (state_1).state;
                    const operand_18 = (state_1).index;

                    break :block_21 block_20: {
                        const operand_19 = (try (allocator).create((zx_abi).zx_type_93));

                        (operand_19).* = @as((zx_abi).zx_type_93, (zx_abi).zx_type_93{ .state = operand_17, .index = operand_18, });

                        break :block_20 @as(*const (zx_abi).zx_type_93, operand_19);
                    };
                }));

                const value_17: *const (zx_abi).zx_type_97 = block_16: {
                    break :block_16 block_15: {
                        const operand_14 = (try (allocator).create((zx_abi).zx_type_97));

                        (operand_14).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .count = (value_14).count, .index = (value_14).index, .state = value_16, });

                        break :block_15 @as(*const (zx_abi).zx_type_97, operand_14);
                    };
                };
                const value_18: *const (zx_abi).zx_type_97 = value_17;
                const value_19: u64 = (value_18).index;
                const value_20: u64 = @as(u64, 1);

                const value_21: *const (zx_abi).zx_type_97 = block_13: {
                    break :block_13 block_12: {
                        const operand_11 = (try (allocator).create((zx_abi).zx_type_97));

                        (operand_11).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .count = (value_18).count, .index = (value_19 + value_20), .state = (value_18).state, });

                        break :block_12 @as(*const (zx_abi).zx_type_97, operand_11);
                    };
                };

                break :block_22 value_21;
            };
        }

        break :block_24 state_1;
    };

    return (value_22).state;
}

fn function_18_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_11: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = block_90: {
        const operand_75 = block_74: {
            const operand_72 = in;
            const operand_73 = @as(u64, 0);

            break :block_74 @as((zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_72, .index = operand_73, });
        };

        var state_71: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = operand_75;
        var state_changed_76 = false;

        while ((((state_71).index < @as(u64, (((((state_71).state).context).aliases).names).len)) and block_79: {
            const operand_77 = (((state_71).state).diagnostic).message;
            const operand_78 = @as([]const u8, "");

            break :block_79 ((std).mem).eql(u8, operand_77, operand_78);
        })) {
            state_71 = block_88: {
                const value_3: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = state_71;

                _ = (value_3).state;

                const value_5: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_87: {
                    break :block_87 (try function_17_value(allocator, block_86: {
                        const operand_84 = (state_71).state;
                        const operand_85 = (state_71).index;

                        break :block_86 @as((zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_84, .index = operand_85, });
                    }));
                };

                const value_6: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = block_83: {
                    break :block_83 @as((zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .index = (value_3).index, .state = value_5, });
                };

                const value_7: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = value_6;
                const value_8: u64 = (value_7).index;
                const value_9: u64 = @as(u64, 1);

                const value_10: (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = block_82: {
                    break :block_82 @as((zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .index = (block_80: {
                        break :block_80 value_8;
                    } + block_81: {
                        break :block_81 value_9;
                    }), .state = (value_7).state, });
                };

                break :block_88 value_10;
            };

            state_changed_76 = true;
        }

        break :block_90 (if (state_changed_76) state_71 else operand_75);
    };

    const value_22: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_70: {
        const operand_55 = block_54: {
            const operand_49 = (value_11).state;
            const operand_50 = @as(u64, 0);

            const operand_51 = block_53: {
                const operand_52 = ((in).context).source;

                break :block_53 (try function_16(allocator, operand_52));
            };

            break :block_54 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .state = operand_49, .index = operand_50, .count = operand_51, });
        };

        var state_48: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = operand_55;
        var state_changed_56 = false;

        while ((((state_48).index < (state_48).count) and block_59: {
            const operand_57 = (((state_48).state).diagnostic).message;
            const operand_58 = @as([]const u8, "");

            break :block_59 ((std).mem).eql(u8, operand_57, operand_58);
        })) {
            state_48 = block_68: {
                const value_14: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = state_48;

                _ = (value_14).state;

                const value_16: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_67: {
                    break :block_67 (try function_14_value(allocator, block_66: {
                        const operand_64 = (state_48).state;
                        const operand_65 = (state_48).index;

                        break :block_66 @as((zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_64, .index = operand_65, });
                    }));
                };
                const value_17: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_63: {
                    break :block_63 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .count = (value_14).count, .index = (value_14).index, .state = value_16, });
                };

                const value_18: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = value_17;
                const value_19: u64 = (value_18).index;
                const value_20: u64 = @as(u64, 1);

                const value_21: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_62: {
                    break :block_62 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .count = (value_18).count, .index = (block_60: {
                        break :block_60 value_19;
                    } + block_61: {
                        break :block_61 value_20;
                    }), .state = (value_18).state, });
                };

                break :block_68 value_21;
            };

            state_changed_56 = true;
        }

        break :block_70 (if (state_changed_56) state_48 else operand_55);
    };

    return (value_22).state;
}

fn function_19(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_80) error{ IndexOutOfBounds, }!*const (zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_3: {
        const operand_1 = in;
        const operand_2 = (@as(u64, (in).len) - @as(u64, 1));

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

fn function_19_value(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_80) error{ IndexOutOfBounds, }!(zx_abi).zx_type_80 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (block_6: {
        const operand_4 = in;
        const operand_5 = (@as(u64, (in).len) - @as(u64, 1));

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    }).*;
}

fn function_20(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    return block_24: {
        const operand_1 = in;
        const operand_2 = block_15: {
            const operand_3 = (block_7: {
                const operand_4 = ((in).cache).names;
                const operand_5 = ((value_1).name).text;
                const operand_6 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_4).len, 1))));

                @memcpy((operand_6)[0..(operand_4).len], operand_4);

                (operand_6)[(operand_4).len] = operand_5;

                break :block_7 @as((zx_abi).zx_type_98, .{ operand_6, {}, });
            }).@"0";
            const operand_8 = (block_12: {
                const operand_9 = ((in).cache).ids;
                const operand_10 = (in).result;
                const operand_11 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_9).len, 1))));

                @memcpy((operand_11)[0..(operand_9).len], operand_9);

                (operand_11)[(operand_9).len] = operand_10;

                break :block_12 @as((zx_abi).zx_type_99, .{ operand_11, {}, });
            }).@"0";

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_13).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_3, .ids = operand_8, });

                break :block_14 @as(*const (zx_abi).zx_type_78, operand_13);
            };
        };
        const operand_16 = (block_18: {
            const operand_17 = (in).active;

            break :block_18 @as((zx_abi).zx_type_101, (if (((operand_17).len == 0)) .{ operand_17, null, } else .{ (operand_17)[0..((operand_17).len - 1)], (operand_17)[((operand_17).len - 1)], }));
        }).@"0";

        const operand_19 = (block_21: {
            const operand_20 = (in).frames;

            break :block_21 @as((zx_abi).zx_type_103, (if (((operand_20).len == 0)) .{ operand_20, null, } else .{ (operand_20)[0..((operand_20).len - 1)], (operand_20)[((operand_20).len - 1)], }));
        }).@"0";

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_22).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = operand_16, .cache = operand_2, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_19, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_23 @as(*const (zx_abi).zx_type_82, operand_22);
        };
    };
}

fn function_20_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_49: {
        const operand_48 = (in).frames;

        break :block_49 (try function_19(allocator, operand_48));
    };

    return block_47: {
        const operand_25 = in;
        const operand_26 = block_40: {
            const operand_27 = (block_32: {
                const operand_28 = ((in).cache).names;

                const operand_30 = ((block_29: {
                    break :block_29 value_1;
                }).name).text;

                const operand_31 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_28).len, 1))));

                @memcpy((operand_31)[0..(operand_28).len], operand_28);

                (operand_31)[(operand_28).len] = operand_30;

                break :block_32 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_31, {}, null, });
            }).@"0";

            const operand_33 = (block_37: {
                const operand_34 = ((in).cache).ids;
                const operand_35 = (in).result;
                const operand_36 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_34).len, 1))));

                @memcpy((operand_36)[0..(operand_34).len], operand_34);

                (operand_36)[(operand_34).len] = operand_35;

                break :block_37 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_36, {}, null, });
            }).@"0";

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_38).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_27, .ids = operand_33, });

                break :block_39 @as(*const (zx_abi).zx_type_78, operand_38);
            };
        };

        const operand_41 = (block_43: {
            const operand_42 = (in).active;

            break :block_43 @as((zx_abi).value_zx_type_101_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_42).len == 0)) .{ operand_42, null, null, } else .{ (operand_42)[0..((operand_42).len - 1)], (operand_42)[((operand_42).len - 1)], null, }));
        }).@"0";

        const operand_44 = (block_46: {
            const operand_45 = (in).frames;

            break :block_46 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_45).len == 0)) .{ operand_45, null, null, } else .{ (operand_45)[0..((operand_45).len - 1)], (operand_45)[((operand_45).len - 1)], null, }));
        }).@"0";

        break :block_47 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = operand_41, .cache = operand_26, .context = (operand_25).context, .delta = (operand_25).delta, .diagnostic = (operand_25).diagnostic, .frames = operand_44, .result = (operand_25).result, .scratch = (operand_25).scratch, });
    };
}

fn function_20_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_81: {
        const operand_80 = (in).frames;

        break :block_81 (try function_19(allocator, operand_80));
    };

    return block_79: {
        const operand_50 = in;
        const operand_51 = block_72: {
            const operand_52 = @as([]const []const u8, (if (((buffers).lane_2 != null)) block_56: {
                const operand_53 = ((in).cache).names;

                const operand_55 = ((block_54: {
                    break :block_54 value_1;
                }).name).text;

                _ = (try ((std).math).add(usize, (operand_53).len, 1));

                if ((!(((buffers).lane_2.?).started).*)) {
                    (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_53));
                    (((buffers).lane_2.?).started).* = true;
                } else {
                    (((((buffers).lane_2.?).buffer).*).items).len = (operand_53).len;
                }

                (try ((((buffers).lane_2.?).buffer).*).append(allocator, operand_55));

                break :block_56 ((((buffers).lane_2.?).buffer).*).items;
            } else (block_61: {
                const operand_57 = ((in).cache).names;

                const operand_59 = ((block_58: {
                    break :block_58 value_1;
                }).name).text;

                const operand_60 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_57).len, 1))));

                @memcpy((operand_60)[0..(operand_57).len], operand_57);
                (operand_60)[(operand_57).len] = operand_59;

                break :block_61 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_60, {}, null, });
            }).@"0"));

            const operand_62 = @as([]const u32, (if (((buffers).lane_1 != null)) block_65: {
                const operand_63 = ((in).cache).ids;
                const operand_64 = (in).result;

                _ = (try ((std).math).add(usize, (operand_63).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_63));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_63).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_64));

                break :block_65 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_69: {
                const operand_66 = ((in).cache).ids;
                const operand_67 = (in).result;
                const operand_68 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_66).len, 1))));

                @memcpy((operand_68)[0..(operand_66).len], operand_66);

                (operand_68)[(operand_66).len] = operand_67;

                break :block_69 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_68, {}, null, });
            }).@"0"));

            break :block_72 block_71: {
                const operand_70 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_70).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .names = operand_52, .ids = operand_62, });

                break :block_71 @as(*const (zx_abi).zx_type_78, operand_70);
            };
        };
        const operand_73 = (block_75: {
            const operand_74 = (in).active;

            break :block_75 @as((zx_abi).value_zx_type_101_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_74).len == 0)) .{ operand_74, null, null, } else .{ (operand_74)[0..((operand_74).len - 1)], (operand_74)[((operand_74).len - 1)], null, }));
        }).@"0";

        const operand_76 = (block_78: {
            const operand_77 = (in).frames;

            break :block_78 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_77).len == 0)) .{ operand_77, null, null, } else .{ (operand_77)[0..((operand_77).len - 1)], (operand_77)[((operand_77).len - 1)], null, }));
        }).@"0";

        break :block_79 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = operand_73, .cache = operand_51, .context = (operand_50).context, .delta = (operand_50).delta, .diagnostic = (operand_50).diagnostic, .frames = operand_76, .result = (operand_50).result, .scratch = (operand_50).scratch, });
    };
}

fn function_21(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_1).widen(in);

    _ = allocator;

    return native_result;
}

fn function_22(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_1).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_23(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{ OutOfMemory, }!*const (zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    const value_1: u64 = block_15: {
        const operand_14 = (in).kind;

        break :block_15 (if ((operand_14 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_14 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_13: {
        const operand_1 = (in).kind;
        const operand_2 = (in).first;
        const operand_3 = (in).second;
        const operand_4 = (in).label;
        const operand_5 = @as(u64, 0);
        const operand_6 = value_1;
        const operand_7 = (in).children;
        const operand_8 = ((in).fields).names;
        const operand_9 = ((in).fields).types;
        const operand_10 = (in).names;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_104));

            (operand_11).* = @as((zx_abi).zx_type_104, (zx_abi).zx_type_104{ .kind = operand_1, .first = operand_2, .second = operand_3, .label = operand_4, .offset = operand_5, .count = operand_6, .children = operand_7, .field_names = operand_8, .field_types = operand_9, .names = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_104, operand_11);
        };
    };
}

fn function_23_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19) error{ OutOfMemory, }!(zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = block_28: {
        const operand_27 = (in).kind;

        break :block_28 (if ((operand_27 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_27 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_26: {
        const operand_16 = (in).kind;
        const operand_17 = (in).first;
        const operand_18 = (in).second;
        const operand_19 = (in).label;
        const operand_20 = @as(u64, 0);
        const operand_21 = value_1;
        const operand_22 = (in).children;
        const operand_23 = ((in).fields).names;
        const operand_24 = ((in).fields).types;
        const operand_25 = (in).names;

        break :block_26 (zx_abi).zx_type_104{ .kind = operand_16, .first = operand_17, .second = operand_18, .label = operand_19, .offset = operand_20, .count = operand_21, .children = operand_22, .field_names = operand_23, .field_types = operand_24, .names = operand_25, };
    };
}

fn function_23_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_19, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    const value_1: u64 = block_41: {
        const operand_40 = (in).kind;

        break :block_41 (if ((operand_40 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((in).fields).names).len) else (if ((operand_40 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, ((in).children).len) else @as(u64, ((in).names).len)));
    };

    return block_39: {
        const operand_29 = (in).kind;
        const operand_30 = (in).first;
        const operand_31 = (in).second;
        const operand_32 = (in).label;
        const operand_33 = @as(u64, 0);
        const operand_34 = value_1;
        const operand_35 = (in).children;
        const operand_36 = ((in).fields).names;
        const operand_37 = ((in).fields).types;
        const operand_38 = (in).names;

        break :block_39 (zx_abi).zx_type_104{ .kind = operand_29, .first = operand_30, .second = operand_31, .label = operand_32, .offset = operand_33, .count = operand_34, .children = operand_35, .field_names = operand_36, .field_types = operand_37, .names = operand_38, };
    };
}

fn function_24(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_105) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_104 = ((in).left).*;
    const value_2: (zx_abi).zx_type_104 = ((in).right).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_11, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_11, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_11, .NativeReference))) {
        return block_61: {
            const operand_59 = ((&value_1)).label;
            const operand_60 = ((&value_2)).label;

            break :block_61 ((std).mem).eql(u8, operand_59, operand_60);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_11, .Enumeration)) and (!block_58: {
        const operand_56 = ((&value_1)).label;
        const operand_57 = ((&value_2)).label;

        break :block_58 ((std).mem).eql(u8, operand_56, operand_57);
    }))) {
        return false;
    }

    if ((((&value_1)).count != ((&value_2)).count)) {
        return false;
    }

    return block_55: {
        const operand_7 = block_6: {
            const operand_2 = (&value_1);
            const operand_3 = (&value_2);
            const operand_4 = @as(u64, 0);
            const operand_5 = true;

            break :block_6 (zx_abi).zx_type_106{ .left = operand_2, .right = operand_3, .index = operand_4, .equal = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (operand_7).equal, .index = (operand_7).index, .left = (operand_7).left, .right = (operand_7).right, .zx_origin = (&operand_7), };

        while (((state_1).equal and ((state_1).index < ((state_1).left).count))) {
            state_1 = block_54: {
                const value_5: u64 = (((state_1).left).offset + (state_1).index);
                const value_6: u64 = (((state_1).right).offset + (state_1).index);

                const value_7: bool = block_53: {
                    const operand_14 = ((state_1).left).kind;

                    break :block_53 (if ((operand_14 == @as((zx_abi).zx_type_11, .Object))) (block_44: {
                        const operand_42 = block_37: {
                            const operand_35 = ((state_1).left).field_names;

                            const operand_36 = block_34: {
                                break :block_34 value_5;
                            };

                            if ((operand_36 >= (operand_35).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_37 (operand_35)[@intCast(operand_36)];
                        };
                        const operand_43 = block_41: {
                            const operand_39 = ((state_1).right).field_names;

                            const operand_40 = block_38: {
                                break :block_38 value_6;
                            };

                            if ((operand_40 >= (operand_39).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_41 (operand_39)[@intCast(operand_40)];
                        };

                        break :block_44 ((std).mem).eql(u8, operand_42, operand_43);
                    } and (block_48: {
                        const operand_46 = ((state_1).left).field_types;

                        const operand_47 = block_45: {
                            break :block_45 value_5;
                        };

                        if ((operand_47 >= (operand_46).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_48 (operand_46)[@intCast(operand_47)];
                    } == block_52: {
                        const operand_50 = ((state_1).right).field_types;

                        const operand_51 = block_49: {
                            break :block_49 value_6;
                        };

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    })) else (if ((operand_14 == @as((zx_abi).zx_type_11, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).left).children;

                        const operand_28 = block_26: {
                            break :block_26 value_5;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_33: {
                        const operand_31 = ((state_1).right).children;

                        const operand_32 = block_30: {
                            break :block_30 value_6;
                        };

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    }) else block_25: {
                        const operand_23 = block_18: {
                            const operand_16 = ((state_1).left).names;

                            const operand_17 = block_15: {
                                break :block_15 value_5;
                            };

                            if ((operand_17 >= (operand_16).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_18 (operand_16)[@intCast(operand_17)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).right).names;

                            const operand_21 = block_19: {
                                break :block_19 value_6;
                            };

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_8: (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_1;

                _ = (value_8).equal;

                const value_10: bool = block_13: {
                    break :block_13 value_7;
                };

                const value_11: (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = block_11: {
                        break :block_11 value_10;
                    }, .index = (value_8).index, .left = (value_8).left, .right = (value_8).right, });
                };

                const value_12: (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .equal = (value_12).equal, .index = (block_8: {
                        break :block_8 value_13;
                    } + block_9: {
                        break :block_9 value_14;
                    }), .left = (value_12).left, .right = (value_12).right, });
                };

                break :block_54 value_15;
            };
        }

        break :block_55 (state_1).equal;
    };
}

fn function_25(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_26(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_107) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    return block_31: {
        const operand_1 = (try function_25(allocator, block_4: {
            const operand_2 = ((in).table).kinds;
            const operand_3 = (in).index;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = ((in).table).first;
            const operand_7 = (in).index;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = ((in).table).second;
            const operand_11 = (in).index;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = ((in).table).labels;
            const operand_15 = (in).index;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };
        const operand_17 = (try function_21(allocator, block_20: {
            const operand_18 = ((in).table).first;
            const operand_19 = (in).index;

            if ((operand_19 >= (operand_18).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_20 (operand_18)[@intCast(operand_19)];
        }));

        const operand_21 = (try function_21(allocator, block_24: {
            const operand_22 = ((in).table).second;
            const operand_23 = (in).index;

            if ((operand_23 >= (operand_22).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_24 (operand_22)[@intCast(operand_23)];
        }));

        const operand_25 = ((in).table).children;
        const operand_26 = ((in).table).field_names;
        const operand_27 = ((in).table).field_types;
        const operand_28 = ((in).table).names;

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_104));

            (operand_29).* = @as((zx_abi).zx_type_104, (zx_abi).zx_type_104{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .offset = operand_17, .count = operand_21, .children = operand_25, .field_names = operand_26, .field_types = operand_27, .names = operand_28, });

            break :block_30 @as(*const (zx_abi).zx_type_104, operand_29);
        };
    };
}

fn function_26_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_107) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    return block_60: {
        const operand_32 = (try function_25(allocator, block_35: {
            const operand_33 = ((in).table).kinds;
            const operand_34 = (in).index;

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        }));

        const operand_36 = block_39: {
            const operand_37 = ((in).table).first;
            const operand_38 = (in).index;

            if ((operand_38 >= (operand_37).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_39 (operand_37)[@intCast(operand_38)];
        };
        const operand_40 = block_43: {
            const operand_41 = ((in).table).second;
            const operand_42 = (in).index;

            if ((operand_42 >= (operand_41).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_43 (operand_41)[@intCast(operand_42)];
        };
        const operand_44 = block_47: {
            const operand_45 = ((in).table).labels;
            const operand_46 = (in).index;

            if ((operand_46 >= (operand_45).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_47 (operand_45)[@intCast(operand_46)];
        };
        const operand_48 = (try function_21(allocator, block_51: {
            const operand_49 = ((in).table).first;
            const operand_50 = (in).index;

            if ((operand_50 >= (operand_49).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_51 (operand_49)[@intCast(operand_50)];
        }));

        const operand_52 = (try function_21(allocator, block_55: {
            const operand_53 = ((in).table).second;
            const operand_54 = (in).index;

            if ((operand_54 >= (operand_53).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_55 (operand_53)[@intCast(operand_54)];
        }));

        const operand_56 = ((in).table).children;
        const operand_57 = ((in).table).field_names;
        const operand_58 = ((in).table).field_types;
        const operand_59 = ((in).table).names;

        break :block_60 (zx_abi).zx_type_104{ .kind = operand_32, .first = operand_36, .second = operand_40, .label = operand_44, .offset = operand_48, .count = operand_52, .children = operand_56, .field_names = operand_57, .field_types = operand_58, .names = operand_59, };
    };
}

fn function_26_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_107, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_104 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_89: {
        const operand_61 = (try function_25(allocator, block_64: {
            const operand_62 = ((in).table).kinds;
            const operand_63 = (in).index;

            if ((operand_63 >= (operand_62).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_64 (operand_62)[@intCast(operand_63)];
        }));

        const operand_65 = block_68: {
            const operand_66 = ((in).table).first;
            const operand_67 = (in).index;

            if ((operand_67 >= (operand_66).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_68 (operand_66)[@intCast(operand_67)];
        };
        const operand_69 = block_72: {
            const operand_70 = ((in).table).second;
            const operand_71 = (in).index;

            if ((operand_71 >= (operand_70).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_72 (operand_70)[@intCast(operand_71)];
        };
        const operand_73 = block_76: {
            const operand_74 = ((in).table).labels;
            const operand_75 = (in).index;

            if ((operand_75 >= (operand_74).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_76 (operand_74)[@intCast(operand_75)];
        };
        const operand_77 = (try function_21(allocator, block_80: {
            const operand_78 = ((in).table).first;
            const operand_79 = (in).index;

            if ((operand_79 >= (operand_78).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_80 (operand_78)[@intCast(operand_79)];
        }));

        const operand_81 = (try function_21(allocator, block_84: {
            const operand_82 = ((in).table).second;
            const operand_83 = (in).index;

            if ((operand_83 >= (operand_82).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_84 (operand_82)[@intCast(operand_83)];
        }));

        const operand_85 = ((in).table).children;
        const operand_86 = ((in).table).field_names;
        const operand_87 = ((in).table).field_types;
        const operand_88 = ((in).table).names;

        break :block_89 (zx_abi).zx_type_104{ .kind = operand_61, .first = operand_65, .second = operand_69, .label = operand_73, .offset = operand_77, .count = operand_81, .children = operand_85, .field_names = operand_86, .field_types = operand_87, .names = operand_88, };
    };
}

fn function_27(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_108) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_21(allocator, (in).id));
    const value_2: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_3: bool = (value_1 >= value_2);
    const value_4: (zx_abi).zx_type_15 = (if (value_3) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: u64 = (if (value_3) (value_1 - value_2) else value_1);

    return block_9: {
        const operand_1 = (&value_4);
        const operand_2 = value_5;
        const operand_3 = (zx_abi).zx_type_107{ .table = operand_1, .index = operand_2, };
        const operand_4 = (try function_26_value(allocator, (&operand_3)));
        const operand_5 = (&operand_4);
        const operand_6 = (try function_23_value(allocator, (in).candidate));
        const operand_7 = (&operand_6);
        const operand_8 = (zx_abi).zx_type_105{ .left = operand_5, .right = operand_7, };

        break :block_9 (try function_24(allocator, (&operand_8)));
    };
}

fn function_28(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_109) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_20 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_61: {
            const operand_57 = false;
            const operand_58 = @as(u32, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_59).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .found = operand_57, .id = operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_20, operand_59);
            };
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: *const (zx_abi).zx_type_110 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_110));

                (operand_13).* = @as((zx_abi).zx_type_110, (zx_abi).zx_type_110{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_110, operand_13);
            };
        };
        const state_type_18 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_19 = struct {
            children: []const u32,
            fields: state_type_18,
            first: u32,
            kind: (zx_abi).zx_type_11,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };
        const state_type_20 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_21 = struct {
            base: state_type_20,
            delta: state_type_20,
        };

        const state_type_22 = struct {
            candidate: state_type_19,
            count: u64,
            found: bool,
            id: u32,
            index: u64,
            tables: state_type_21,
        };
        const state_type_28 = struct {
            candidate: state_type_19,
            id: u32,
            tables: state_type_21,
        };

        var state_6: state_type_22 = state_type_22{ .candidate = state_type_19{ .children = ((operand_16).candidate).children, .fields = state_type_18{ .names = (((operand_16).candidate).fields).names, .types = (((operand_16).candidate).fields).types, }, .first = ((operand_16).candidate).first, .kind = ((operand_16).candidate).kind, .label = ((operand_16).candidate).label, .names = ((operand_16).candidate).names, .second = ((operand_16).candidate).second, }, .count = (operand_16).count, .found = (operand_16).found, .id = (operand_16).id, .index = (operand_16).index, .tables = state_type_21{ .base = state_type_20{ .children = (((operand_16).tables).base).children, .field_names = (((operand_16).tables).base).field_names, .field_types = (((operand_16).tables).base).field_types, .first = (((operand_16).tables).base).first, .kinds = (((operand_16).tables).base).kinds, .labels = (((operand_16).tables).base).labels, .names = (((operand_16).tables).base).names, .second = (((operand_16).tables).base).second, }, .delta = state_type_20{ .children = (((operand_16).tables).delta).children, .field_names = (((operand_16).tables).delta).field_names, .field_types = (((operand_16).tables).delta).field_types, .first = (((operand_16).tables).delta).first, .kinds = (((operand_16).tables).delta).kinds, .labels = (((operand_16).tables).delta).labels, .names = (((operand_16).tables).delta).names, .second = (((operand_16).tables).delta).second, }, }, };
        var state_changed_17 = false;

        while (((!(state_6).found) and ((state_6).index < (state_6).count))) {
            state_6 = block_42: {
                const value_5: u32 = (try function_22(allocator, (state_6).index));

                const value_6: bool = block_41: {
                    const operand_33 = block_32: {
                        const operand_29 = (state_6).tables;
                        const operand_30 = value_5;
                        const operand_31 = (state_6).candidate;

                        break :block_32 state_type_28{ .tables = operand_29, .id = operand_30, .candidate = operand_31, };
                    };

                    const operand_34 = (zx_abi).zx_type_18{ .names = (((operand_33).candidate).fields).names, .types = (((operand_33).candidate).fields).types, };
                    const operand_35 = (zx_abi).zx_type_19{ .children = ((operand_33).candidate).children, .fields = (&operand_34), .first = ((operand_33).candidate).first, .kind = ((operand_33).candidate).kind, .label = ((operand_33).candidate).label, .names = ((operand_33).candidate).names, .second = ((operand_33).candidate).second, };
                    const operand_36 = (zx_abi).zx_type_15{ .children = (((operand_33).tables).base).children, .field_names = (((operand_33).tables).base).field_names, .field_types = (((operand_33).tables).base).field_types, .first = (((operand_33).tables).base).first, .kinds = (((operand_33).tables).base).kinds, .labels = (((operand_33).tables).base).labels, .names = (((operand_33).tables).base).names, .second = (((operand_33).tables).base).second, };
                    const operand_37 = (zx_abi).zx_type_15{ .children = (((operand_33).tables).delta).children, .field_names = (((operand_33).tables).delta).field_names, .field_types = (((operand_33).tables).delta).field_types, .first = (((operand_33).tables).delta).first, .kinds = (((operand_33).tables).delta).kinds, .labels = (((operand_33).tables).delta).labels, .names = (((operand_33).tables).delta).names, .second = (((operand_33).tables).delta).second, };
                    const operand_38 = (zx_abi).zx_type_16{ .base = (&operand_36), .delta = (&operand_37), };
                    const operand_39 = (zx_abi).zx_type_108{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_27(allocator, (&operand_39)));

                    break :block_41 operand_40;
                };
                const value_7: state_type_22 = block_27: {
                    const operand_23 = state_6;
                    const operand_24 = ((state_6).index + @as(u64, 1));
                    const operand_25 = value_6;
                    const operand_26 = value_5;

                    break :block_27 state_type_22{ .candidate = (operand_23).candidate, .count = (operand_23).count, .found = operand_25, .id = operand_26, .index = operand_24, .tables = (operand_23).tables, };
                };

                break :block_42 value_7;
            };

            state_changed_17 = true;
        }

        break :block_56 (if (state_changed_17) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_110));

            (operand_54).* = @as((zx_abi).zx_type_110, (zx_abi).zx_type_110{ .candidate = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_46).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = ((state_6).candidate).children, .fields = block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_44).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_45 @as(*const (zx_abi).zx_type_18, operand_44);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_47 @as(*const (zx_abi).zx_type_19, operand_46);
            }, .count = (state_6).count, .found = (state_6).found, .id = (state_6).id, .index = (state_6).index, .tables = block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_52).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_48).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_49 @as(*const (zx_abi).zx_type_15, operand_48);
                }, .delta = block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_50).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_51 @as(*const (zx_abi).zx_type_15, operand_50);
                }, });

                break :block_53 @as(*const (zx_abi).zx_type_16, operand_52);
            }, });

            break :block_55 @as(*const (zx_abi).zx_type_110, operand_54);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_8).found;
        const operand_2 = (value_8).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_3).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .found = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_20, operand_3);
        };
    };
}

fn function_28_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_105: {
            const operand_103 = false;
            const operand_104 = @as(u32, 0);

            break :block_105 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_103, .id = operand_104, });
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: (zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = block_102: {
        const operand_75 = block_74: {
            const operand_66 = (in).tables;
            const operand_67 = (in).candidate;

            const operand_68 = block_69: {
                break :block_69 value_2;
            };

            const operand_70 = @as(u64, 0);
            const operand_71 = false;

            const operand_72 = block_73: {
                break :block_73 value_1;
            };

            break :block_74 @as((zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3, (zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3{ .tables = operand_66, .candidate = operand_67, .count = operand_68, .index = operand_70, .found = operand_71, .id = operand_72, });
        };

        var state_65: (zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_100: {
                const value_5: u32 = block_99: {
                    const operand_98 = (state_65).index;

                    break :block_99 (try function_22(allocator, operand_98));
                };
                const value_6: bool = block_97: {
                    const operand_84 = (state_65).tables;
                    var state_borrow_85: (zx_abi).zx_type_16 = undefined;
                    state_borrow_85 = (zx_abi).zx_type_16{ .base = (operand_84).base, .delta = (operand_84).delta, };

                    const operand_86 = ((operand_84).zx_origin orelse (&state_borrow_85));

                    const operand_88 = block_87: {
                        break :block_87 value_5;
                    };

                    const operand_89 = (state_65).candidate;
                    var state_borrow_90: (zx_abi).zx_type_19 = undefined;

                    state_borrow_90 = (zx_abi).zx_type_19{ .children = (operand_89).children, .fields = (operand_89).fields, .first = (operand_89).first, .kind = (operand_89).kind, .label = (operand_89).label, .names = (operand_89).names, .second = (operand_89).second, };

                    const operand_91 = ((operand_89).zx_origin orelse (&state_borrow_90));
                    const operand_92 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_86).base, .delta = (operand_86).delta, .zx_origin = operand_86, };
                    var state_borrow_93: (zx_abi).zx_type_16 = undefined;

                    state_borrow_93 = (zx_abi).zx_type_16{ .base = (operand_92).base, .delta = (operand_92).delta, };

                    const operand_94 = (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .children = (operand_91).children, .fields = (operand_91).fields, .first = (operand_91).first, .kind = (operand_91).kind, .label = (operand_91).label, .names = (operand_91).names, .second = (operand_91).second, .zx_origin = operand_91, };
                    var state_borrow_95: (zx_abi).zx_type_19 = undefined;
                    state_borrow_95 = (zx_abi).zx_type_19{ .children = (operand_94).children, .fields = (operand_94).fields, .first = (operand_94).first, .kind = (operand_94).kind, .label = (operand_94).label, .names = (operand_94).names, .second = (operand_94).second, };

                    const operand_96 = (zx_abi).zx_type_108{ .tables = ((operand_92).zx_origin orelse (&state_borrow_93)), .id = operand_88, .candidate = ((operand_94).zx_origin orelse (&state_borrow_95)), };

                    break :block_97 (try function_27(allocator, (&operand_96)));
                };
                const value_7: (zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3, (zx_abi).value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3{ .candidate = (operand_77).candidate, .count = (operand_77).count, .found = operand_79, .id = operand_81, .index = operand_78, .tables = (operand_77).tables, });
                };

                break :block_100 value_7;
            };

            state_changed_76 = true;
        }

        break :block_102 (if (state_changed_76) state_65 else operand_75);
    };

    return block_64: {
        const operand_62 = (value_8).found;
        const operand_63 = (value_8).id;

        break :block_64 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_62, .id = operand_63, });
    };
}

fn function_29(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_111) error{ IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_49: {
        const operand_48 = ((in).candidate).kind;

        break :block_49 (if ((operand_48 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_48 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_48 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_48 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_47: {
        const operand_46 = ((in).candidate).kind;

        break :block_47 (if ((operand_46 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_46 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_45: {
        const operand_44 = ((in).candidate).kind;

        break :block_45 (if ((operand_44 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_44 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_43: {
        const operand_1 = (block_5: {
            const operand_2 = ((in).delta).kinds;
            const operand_3 = value_1;
            const operand_4 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_2).len, 1))));

            @memcpy((operand_4)[0..(operand_2).len], operand_2);

            (operand_4)[(operand_2).len] = operand_3;

            break :block_5 @as((zx_abi).zx_type_112, .{ operand_4, {}, });
        }).@"0";

        const operand_6 = (block_10: {
            const operand_7 = ((in).delta).first;
            const operand_8 = value_3;
            const operand_9 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_7).len, 1))));

            @memcpy((operand_9)[0..(operand_7).len], operand_7);

            (operand_9)[(operand_7).len] = operand_8;

            break :block_10 @as((zx_abi).zx_type_99, .{ operand_9, {}, });
        }).@"0";

        const operand_11 = (block_15: {
            const operand_12 = ((in).delta).second;
            const operand_13 = value_4;
            const operand_14 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_12).len, 1))));

            @memcpy((operand_14)[0..(operand_12).len], operand_12);

            (operand_14)[(operand_12).len] = operand_13;

            break :block_15 @as((zx_abi).zx_type_99, .{ operand_14, {}, });
        }).@"0";
        const operand_16 = (block_20: {
            const operand_17 = ((in).delta).labels;
            const operand_18 = ((in).candidate).label;
            const operand_19 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_17).len, 1))));

            @memcpy((operand_19)[0..(operand_17).len], operand_17);

            (operand_19)[(operand_17).len] = operand_18;

            break :block_20 @as((zx_abi).zx_type_98, .{ operand_19, {}, });
        }).@"0";

        const operand_21 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) (block_25: {
            const operand_22 = ((in).delta).children;
            const operand_23 = ((in).candidate).children;
            const operand_24 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_22).len, (operand_23).len))));

            @memcpy((operand_24)[0..(operand_22).len], operand_22);
            @memcpy((operand_24)[(operand_22).len..], operand_23);

            break :block_25 @as((zx_abi).zx_type_99, .{ operand_24, {}, });
        }).@"0" else ((in).delta).children);

        const operand_26 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_30: {
            const operand_27 = ((in).delta).field_types;
            const operand_28 = (((in).candidate).fields).types;
            const operand_29 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_27).len, (operand_28).len))));

            @memcpy((operand_29)[0..(operand_27).len], operand_27);
            @memcpy((operand_29)[(operand_27).len..], operand_28);

            break :block_30 @as((zx_abi).zx_type_99, .{ operand_29, {}, });
        }).@"0" else ((in).delta).field_types);

        const operand_31 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_35: {
            const operand_32 = ((in).delta).field_names;
            const operand_33 = (((in).candidate).fields).names;
            const operand_34 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_32).len, (operand_33).len))));

            @memcpy((operand_34)[0..(operand_32).len], operand_32);
            @memcpy((operand_34)[(operand_32).len..], operand_33);

            break :block_35 @as((zx_abi).zx_type_98, .{ operand_34, {}, });
        }).@"0" else ((in).delta).field_names);

        const operand_36 = (if (value_2) (block_40: {
            const operand_37 = ((in).delta).names;
            const operand_38 = ((in).candidate).names;
            const operand_39 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_37).len, (operand_38).len))));

            @memcpy((operand_39)[0..(operand_37).len], operand_37);
            @memcpy((operand_39)[(operand_37).len..], operand_38);

            break :block_40 @as((zx_abi).zx_type_98, .{ operand_39, {}, });
        }).@"0" else ((in).delta).names);

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_41).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_1, .first = operand_6, .second = operand_11, .labels = operand_16, .children = operand_21, .field_types = operand_26, .field_names = operand_31, .names = operand_36, });

            break :block_42 @as(*const (zx_abi).zx_type_15, operand_41);
        };
    };
}

fn function_29_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_111) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_96: {
        const operand_95 = ((in).candidate).kind;

        break :block_96 (if ((operand_95 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_95 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_95 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_95 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_94: {
        const operand_93 = ((in).candidate).kind;

        break :block_94 (if ((operand_93 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_93 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_92: {
        const operand_91 = ((in).candidate).kind;

        break :block_92 (if ((operand_91 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_91 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_90: {
        const operand_50 = (block_54: {
            const operand_51 = ((in).delta).kinds;
            const operand_52 = value_1;
            const operand_53 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_51).len, 1))));

            @memcpy((operand_53)[0..(operand_51).len], operand_51);

            (operand_53)[(operand_51).len] = operand_52;

            break :block_54 @as((zx_abi).zx_type_112, .{ operand_53, {}, });
        }).@"0";

        const operand_55 = (block_59: {
            const operand_56 = ((in).delta).first;
            const operand_57 = value_3;
            const operand_58 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_56).len, 1))));

            @memcpy((operand_58)[0..(operand_56).len], operand_56);

            (operand_58)[(operand_56).len] = operand_57;

            break :block_59 @as((zx_abi).zx_type_99, .{ operand_58, {}, });
        }).@"0";

        const operand_60 = (block_64: {
            const operand_61 = ((in).delta).second;
            const operand_62 = value_4;
            const operand_63 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_61).len, 1))));

            @memcpy((operand_63)[0..(operand_61).len], operand_61);

            (operand_63)[(operand_61).len] = operand_62;

            break :block_64 @as((zx_abi).zx_type_99, .{ operand_63, {}, });
        }).@"0";
        const operand_65 = (block_69: {
            const operand_66 = ((in).delta).labels;
            const operand_67 = ((in).candidate).label;
            const operand_68 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_66).len, 1))));

            @memcpy((operand_68)[0..(operand_66).len], operand_66);

            (operand_68)[(operand_66).len] = operand_67;

            break :block_69 @as((zx_abi).zx_type_98, .{ operand_68, {}, });
        }).@"0";

        const operand_70 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) (block_74: {
            const operand_71 = ((in).delta).children;
            const operand_72 = ((in).candidate).children;
            const operand_73 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_71).len, (operand_72).len))));

            @memcpy((operand_73)[0..(operand_71).len], operand_71);
            @memcpy((operand_73)[(operand_71).len..], operand_72);

            break :block_74 @as((zx_abi).zx_type_99, .{ operand_73, {}, });
        }).@"0" else ((in).delta).children);

        const operand_75 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_79: {
            const operand_76 = ((in).delta).field_types;
            const operand_77 = (((in).candidate).fields).types;
            const operand_78 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_76).len, (operand_77).len))));

            @memcpy((operand_78)[0..(operand_76).len], operand_76);
            @memcpy((operand_78)[(operand_76).len..], operand_77);

            break :block_79 @as((zx_abi).zx_type_99, .{ operand_78, {}, });
        }).@"0" else ((in).delta).field_types);

        const operand_80 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (block_84: {
            const operand_81 = ((in).delta).field_names;
            const operand_82 = (((in).candidate).fields).names;
            const operand_83 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_81).len, (operand_82).len))));

            @memcpy((operand_83)[0..(operand_81).len], operand_81);
            @memcpy((operand_83)[(operand_81).len..], operand_82);

            break :block_84 @as((zx_abi).zx_type_98, .{ operand_83, {}, });
        }).@"0" else ((in).delta).field_names);

        const operand_85 = (if (value_2) (block_89: {
            const operand_86 = ((in).delta).names;
            const operand_87 = ((in).candidate).names;
            const operand_88 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_86).len, (operand_87).len))));

            @memcpy((operand_88)[0..(operand_86).len], operand_86);
            @memcpy((operand_88)[(operand_86).len..], operand_87);

            break :block_89 @as((zx_abi).zx_type_98, .{ operand_88, {}, });
        }).@"0" else ((in).delta).names);

        break :block_90 (zx_abi).zx_type_15{ .kinds = operand_50, .first = operand_55, .second = operand_60, .labels = operand_65, .children = operand_70, .field_types = operand_75, .field_names = operand_80, .names = operand_85, };
    };
}

fn function_29_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_111, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: u8 = block_167: {
        const operand_166 = ((in).candidate).kind;

        break :block_167 (if ((operand_166 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_166 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_166 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_166 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };

    const value_2: bool = ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)));

    const value_3: u32 = block_165: {
        const operand_164 = ((in).candidate).kind;

        break :block_165 (if ((operand_164 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, (((in).delta).field_types).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).delta).children).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else (if ((operand_164 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).delta).names).len))) else ((in).candidate).first))));
    };

    const value_4: u32 = block_163: {
        const operand_162 = ((in).candidate).kind;

        break :block_163 (if ((operand_162 == @as((zx_abi).zx_type_11, .Object))) (try function_22(allocator, @as(u64, ((((in).candidate).fields).names).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .Tuple))) (try function_22(allocator, @as(u64, (((in).candidate).children).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else (if ((operand_162 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_22(allocator, @as(u64, (((in).candidate).names).len))) else ((in).candidate).second))));
    };

    return block_161: {
        const operand_97 = @as([]const u8, (if (((buffers).lane_4 != null)) block_100: {
            const operand_98 = ((in).delta).kinds;
            const operand_99 = value_1;

            _ = (try ((std).math).add(usize, (operand_98).len, 1));

            if ((!(((buffers).lane_4.?).started).*)) {
                (try ((((buffers).lane_4.?).buffer).*).appendSlice(allocator, operand_98));
                (((buffers).lane_4.?).started).* = true;
            } else {
                (((((buffers).lane_4.?).buffer).*).items).len = (operand_98).len;
            }

            (try ((((buffers).lane_4.?).buffer).*).append(allocator, operand_99));

            break :block_100 ((((buffers).lane_4.?).buffer).*).items;
        } else (block_104: {
            const operand_101 = ((in).delta).kinds;
            const operand_102 = value_1;
            const operand_103 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_101).len, 1))));

            @memcpy((operand_103)[0..(operand_101).len], operand_101);

            (operand_103)[(operand_101).len] = operand_102;

            break :block_104 @as((zx_abi).zx_type_112, .{ operand_103, {}, });
        }).@"0"));

        const operand_105 = @as([]const u32, (if (((buffers).lane_3 != null)) block_108: {
            const operand_106 = ((in).delta).first;
            const operand_107 = value_3;

            _ = (try ((std).math).add(usize, (operand_106).len, 1));

            if ((!(((buffers).lane_3.?).started).*)) {
                (try ((((buffers).lane_3.?).buffer).*).appendSlice(allocator, operand_106));
                (((buffers).lane_3.?).started).* = true;
            } else {
                (((((buffers).lane_3.?).buffer).*).items).len = (operand_106).len;
            }

            (try ((((buffers).lane_3.?).buffer).*).append(allocator, operand_107));

            break :block_108 ((((buffers).lane_3.?).buffer).*).items;
        } else (block_112: {
            const operand_109 = ((in).delta).first;
            const operand_110 = value_3;
            const operand_111 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_109).len, 1))));

            @memcpy((operand_111)[0..(operand_109).len], operand_109);

            (operand_111)[(operand_109).len] = operand_110;

            break :block_112 @as((zx_abi).zx_type_99, .{ operand_111, {}, });
        }).@"0"));

        const operand_113 = @as([]const u32, (if (((buffers).lane_7 != null)) block_116: {
            const operand_114 = ((in).delta).second;
            const operand_115 = value_4;

            _ = (try ((std).math).add(usize, (operand_114).len, 1));

            if ((!(((buffers).lane_7.?).started).*)) {
                (try ((((buffers).lane_7.?).buffer).*).appendSlice(allocator, operand_114));
                (((buffers).lane_7.?).started).* = true;
            } else {
                (((((buffers).lane_7.?).buffer).*).items).len = (operand_114).len;
            }

            (try ((((buffers).lane_7.?).buffer).*).append(allocator, operand_115));

            break :block_116 ((((buffers).lane_7.?).buffer).*).items;
        } else (block_120: {
            const operand_117 = ((in).delta).second;
            const operand_118 = value_4;
            const operand_119 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_117).len, 1))));

            @memcpy((operand_119)[0..(operand_117).len], operand_117);

            (operand_119)[(operand_117).len] = operand_118;

            break :block_120 @as((zx_abi).zx_type_99, .{ operand_119, {}, });
        }).@"0"));

        const operand_121 = @as([]const []const u8, (if (((buffers).lane_5 != null)) block_124: {
            const operand_122 = ((in).delta).labels;
            const operand_123 = ((in).candidate).label;

            _ = (try ((std).math).add(usize, (operand_122).len, 1));

            if ((!(((buffers).lane_5.?).started).*)) {
                (try ((((buffers).lane_5.?).buffer).*).appendSlice(allocator, operand_122));
                (((buffers).lane_5.?).started).* = true;
            } else {
                (((((buffers).lane_5.?).buffer).*).items).len = (operand_122).len;
            }

            (try ((((buffers).lane_5.?).buffer).*).append(allocator, operand_123));

            break :block_124 ((((buffers).lane_5.?).buffer).*).items;
        } else (block_128: {
            const operand_125 = ((in).delta).labels;
            const operand_126 = ((in).candidate).label;
            const operand_127 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_125).len, 1))));

            @memcpy((operand_127)[0..(operand_125).len], operand_125);

            (operand_127)[(operand_125).len] = operand_126;

            break :block_128 @as((zx_abi).zx_type_98, .{ operand_127, {}, });
        }).@"0"));

        const operand_129 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) @as([]const u32, (if (((buffers).lane_0 != null)) block_132: {
            const operand_130 = ((in).delta).children;
            const operand_131 = ((in).candidate).children;

            _ = (try ((std).math).add(usize, (operand_130).len, (operand_131).len));

            if ((!(((buffers).lane_0.?).started).*)) {
                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_130));
                (((buffers).lane_0.?).started).* = true;
            } else {
                (((((buffers).lane_0.?).buffer).*).items).len = (operand_130).len;
            }

            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_131));

            break :block_132 ((((buffers).lane_0.?).buffer).*).items;
        } else (block_136: {
            const operand_133 = ((in).delta).children;
            const operand_134 = ((in).candidate).children;
            const operand_135 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_133).len, (operand_134).len))));

            @memcpy((operand_135)[0..(operand_133).len], operand_133);
            @memcpy((operand_135)[(operand_133).len..], operand_134);

            break :block_136 @as((zx_abi).zx_type_99, .{ operand_135, {}, });
        }).@"0")) else ((in).delta).children);

        const operand_137 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) @as([]const u32, (if (((buffers).lane_2 != null)) block_140: {
            const operand_138 = ((in).delta).field_types;
            const operand_139 = (((in).candidate).fields).types;

            _ = (try ((std).math).add(usize, (operand_138).len, (operand_139).len));

            if ((!(((buffers).lane_2.?).started).*)) {
                (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_138));
                (((buffers).lane_2.?).started).* = true;
            } else {
                (((((buffers).lane_2.?).buffer).*).items).len = (operand_138).len;
            }

            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_139));

            break :block_140 ((((buffers).lane_2.?).buffer).*).items;
        } else (block_144: {
            const operand_141 = ((in).delta).field_types;
            const operand_142 = (((in).candidate).fields).types;
            const operand_143 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_141).len, (operand_142).len))));

            @memcpy((operand_143)[0..(operand_141).len], operand_141);
            @memcpy((operand_143)[(operand_141).len..], operand_142);

            break :block_144 @as((zx_abi).zx_type_99, .{ operand_143, {}, });
        }).@"0")) else ((in).delta).field_types);

        const operand_145 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) @as([]const []const u8, (if (((buffers).lane_1 != null)) block_148: {
            const operand_146 = ((in).delta).field_names;
            const operand_147 = (((in).candidate).fields).names;

            _ = (try ((std).math).add(usize, (operand_146).len, (operand_147).len));

            if ((!(((buffers).lane_1.?).started).*)) {
                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_146));
                (((buffers).lane_1.?).started).* = true;
            } else {
                (((((buffers).lane_1.?).buffer).*).items).len = (operand_146).len;
            }

            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_147));

            break :block_148 ((((buffers).lane_1.?).buffer).*).items;
        } else (block_152: {
            const operand_149 = ((in).delta).field_names;
            const operand_150 = (((in).candidate).fields).names;
            const operand_151 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_149).len, (operand_150).len))));

            @memcpy((operand_151)[0..(operand_149).len], operand_149);
            @memcpy((operand_151)[(operand_149).len..], operand_150);

            break :block_152 @as((zx_abi).zx_type_98, .{ operand_151, {}, });
        }).@"0")) else ((in).delta).field_names);

        const operand_153 = (if (value_2) @as([]const []const u8, (if (((buffers).lane_6 != null)) block_156: {
            const operand_154 = ((in).delta).names;
            const operand_155 = ((in).candidate).names;

            _ = (try ((std).math).add(usize, (operand_154).len, (operand_155).len));

            if ((!(((buffers).lane_6.?).started).*)) {
                (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_154));
                (((buffers).lane_6.?).started).* = true;
            } else {
                (((((buffers).lane_6.?).buffer).*).items).len = (operand_154).len;
            }

            (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_155));

            break :block_156 ((((buffers).lane_6.?).buffer).*).items;
        } else (block_160: {
            const operand_157 = ((in).delta).names;
            const operand_158 = ((in).candidate).names;
            const operand_159 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_157).len, (operand_158).len))));

            @memcpy((operand_159)[0..(operand_157).len], operand_157);
            @memcpy((operand_159)[(operand_157).len..], operand_158);

            break :block_160 @as((zx_abi).zx_type_98, .{ operand_159, {}, });
        }).@"0")) else ((in).delta).names);

        break :block_161 (zx_abi).zx_type_15{ .kinds = operand_97, .first = operand_105, .second = operand_113, .labels = operand_121, .children = operand_129, .field_types = operand_137, .field_names = operand_145, .names = operand_153, };
    };
}

fn function_30(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_113) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = (if ((@as(u64, ((in).left).len) < @as(u64, ((in).right).len))) @as(u64, ((in).left).len) else @as(u64, ((in).right).len));

    const value_13: (zx_abi).zx_type_114 = block_30: {
        const operand_14 = block_13: {
            const operand_8 = (in).left;
            const operand_9 = (in).right;
            const operand_10 = @as(u64, 0);
            const operand_11 = value_1;
            const operand_12 = true;

            break :block_13 (zx_abi).zx_type_114{ .left = operand_8, .right = operand_9, .index = operand_10, .limit = operand_11, .equal = operand_12, };
        };

        var state_7: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = (operand_14).equal, .index = (operand_14).index, .left = (operand_14).left, .limit = (operand_14).limit, .right = (operand_14).right, .zx_origin = (&operand_14), };

        while (((state_7).equal and ((state_7).index < (state_7).limit))) {
            state_7 = block_27: {
                const value_4: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_7;
                _ = (value_4).equal;

                const value_6: bool = (block_23: {
                    const operand_21 = (state_7).left;
                    const operand_22 = (state_7).index;

                    if ((operand_22 >= (operand_21).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_23 (operand_21)[@intCast(operand_22)];
                } == block_26: {
                    const operand_24 = (state_7).right;
                    const operand_25 = (state_7).index;

                    if ((operand_25 >= (operand_24).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_26 (operand_24)[@intCast(operand_25)];
                });

                const value_7: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = block_19: {
                        break :block_19 value_6;
                    }, .index = (value_4).index, .left = (value_4).left, .limit = (value_4).limit, .right = (value_4).right, });
                };

                const value_12: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((value_7).equal) block_18: {
                    const value_8: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_7;
                    const value_9: u64 = (value_8).index;
                    const value_10: u64 = @as(u64, 1);

                    const value_11: (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_17: {
                        break :block_17 @as((zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .equal = (value_8).equal, .index = (block_15: {
                            break :block_15 value_9;
                        } + block_16: {
                            break :block_16 value_10;
                        }), .left = (value_8).left, .limit = (value_8).limit, .right = (value_8).right, });
                    };

                    break :block_18 value_11;
                } else value_7);

                break :block_27 value_12;
            };
        }

        break :block_30 block_29: {
            break :block_29 (if (((state_7).zx_origin != null)) ((state_7).zx_origin.?).* else block_28: {
                break :block_28 (zx_abi).zx_type_114{ .equal = (state_7).equal, .index = (state_7).index, .left = (state_7).left, .limit = (state_7).limit, .right = (state_7).right, };
            });
        };
    };

    return (if ((((&value_13)).index == ((&value_13)).limit)) (@as(u64, (((&value_13)).left).len) < @as(u64, (((&value_13)).right).len)) else (block_3: {
        const operand_1 = ((&value_13)).left;
        const operand_2 = ((&value_13)).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } < block_6: {
        const operand_4 = ((&value_13)).right;
        const operand_5 = ((&value_13)).index;

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    }));
}

fn function_31(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return in;
    }

    const value_103: *const (zx_abi).zx_type_115 = block_155: {
        const operand_17 = block_16: {
            const operand_7 = (in).names;
            const operand_8 = (in).types;
            const operand_9 = @as(u64, ((in).names).len);
            const operand_10 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_11 = @as(u64, 0);
            const operand_12 = true;
            const operand_13 = false;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_115));

                (operand_14).* = @as((zx_abi).zx_type_115, (zx_abi).zx_type_115{ .names = operand_7, .types = operand_8, .count = operand_9, .remaining = operand_10, .root = operand_11, .building = operand_12, .sifting = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_115, operand_14);
            };
        };

        var state_items_19: [][]const u8 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_6: (zx_abi).zx_type_115 = (operand_17).*;
        var state_changed_18 = false;

        while (((((&state_6)).building or (((&state_6)).count > @as(u64, 1))) or ((&state_6)).sifting)) {
            state_6 = block_151: {
                const value_102: (zx_abi).zx_type_115 = (if (((&state_6)).sifting) block_94: {
                    const value_45: (zx_abi).zx_type_115 = (if ((((&state_6)).root >= @divTrunc(((&state_6)).count, @as(u64, 2)))) block_24: {
                        const value_3: (zx_abi).zx_type_115 = ((&state_6)).*;

                        _ = ((&value_3)).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).zx_type_115 = block_23: {
                            break :block_23 (zx_abi).zx_type_115{ .building = ((&value_3)).building, .count = ((&value_3)).count, .names = ((&value_3)).names, .remaining = ((&value_3)).remaining, .root = ((&value_3)).root, .sifting = value_5, .types = ((&value_3)).types, };
                        };

                        break :block_24 ((&value_6)).*;
                    } else block_93: {
                        const value_7: u64 = ((((&state_6)).root * @as(u64, 2)) + @as(u64, 1));
                        const value_8: u64 = (value_7 + @as(u64, 1));

                        const value_9: u64 = (if (((value_8 < ((&state_6)).count) and block_92: {
                            const operand_86 = block_85: {
                                const operand_83 = ((&state_6)).names;
                                const operand_84 = value_7;

                                if ((operand_84 >= (operand_83).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_85 (operand_83)[@intCast(operand_84)];
                            };
                            const operand_90 = block_89: {
                                const operand_87 = ((&state_6)).names;
                                const operand_88 = value_8;

                                if ((operand_88 >= (operand_87).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_89 (operand_87)[@intCast(operand_88)];
                            };

                            const operand_91 = (zx_abi).zx_type_113{ .left = operand_86, .right = operand_90, };

                            break :block_92 (try function_30(allocator, (&operand_91)));
                        })) value_8 else value_7);

                        const value_44: (zx_abi).zx_type_115 = (if (block_34: {
                            const operand_28 = block_27: {
                                const operand_25 = ((&state_6)).names;
                                const operand_26 = ((&state_6)).root;

                                if ((operand_26 >= (operand_25).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_27 (operand_25)[@intCast(operand_26)];
                            };
                            const operand_32 = block_31: {
                                const operand_29 = ((&state_6)).names;
                                const operand_30 = value_9;

                                if ((operand_30 >= (operand_29).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_31 (operand_29)[@intCast(operand_30)];
                            };

                            const operand_33 = (zx_abi).zx_type_113{ .left = operand_28, .right = operand_32, };

                            break :block_34 (try function_30(allocator, (&operand_33)));
                        }) block_80: {
                            const value_10: []const u8 = block_79: {
                                const operand_77 = ((&state_6)).names;
                                const operand_78 = ((&state_6)).root;

                                if ((operand_78 >= (operand_77).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_79 (operand_77)[@intCast(operand_78)];
                            };
                            const value_11: u32 = block_76: {
                                const operand_74 = ((&state_6)).types;
                                const operand_75 = ((&state_6)).root;

                                if ((operand_75 >= (operand_74).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_76 (operand_74)[@intCast(operand_75)];
                            };
                            const value_12: (zx_abi).zx_type_115 = ((&state_6)).*;
                            const value_13: []const []const u8 = ((&value_12)).names;
                            const value_14: u64 = ((&state_6)).root;

                            _ = block_73: {
                                const operand_71 = value_13;
                                const operand_72 = value_14;

                                if ((operand_72 >= (operand_71).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_73 (operand_71)[@intCast(operand_72)];
                            };
                            const value_16: []const u8 = block_70: {
                                const operand_68 = ((&state_6)).names;
                                const operand_69 = value_9;

                                if ((operand_69 >= (operand_68).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_70 (operand_68)[@intCast(operand_69)];
                            };
                            const value_17: (zx_abi).zx_type_115 = block_67: {
                                break :block_67 (zx_abi).zx_type_115{ .building = ((&value_12)).building, .count = ((&value_12)).count, .names = block_66: {
                                    const operand_63 = value_13;
                                    const operand_64 = value_14;
                                    const operand_65 = value_16;

                                    if ((operand_64 >= (operand_63).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_20)) {
                                        state_items_19 = (try (allocator).dupe([]const u8, operand_63));
                                        state_items_started_20 = true;
                                    }

                                    (state_items_19)[@intCast(operand_64)] = operand_65;

                                    break :block_66 state_items_19;
                                }, .remaining = ((&value_12)).remaining, .root = ((&value_12)).root, .sifting = ((&value_12)).sifting, .types = ((&value_12)).types, };
                            };

                            const value_18: (zx_abi).zx_type_115 = ((&value_17)).*;
                            const value_19: []const u32 = ((&value_18)).types;
                            const value_20: u64 = ((&value_17)).root;

                            _ = block_62: {
                                const operand_60 = value_19;
                                const operand_61 = value_20;

                                if ((operand_61 >= (operand_60).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_62 (operand_60)[@intCast(operand_61)];
                            };
                            const value_22: u32 = block_59: {
                                const operand_57 = ((&value_17)).types;
                                const operand_58 = value_9;

                                if ((operand_58 >= (operand_57).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_59 (operand_57)[@intCast(operand_58)];
                            };
                            const value_23: (zx_abi).zx_type_115 = block_56: {
                                break :block_56 (zx_abi).zx_type_115{ .building = ((&value_18)).building, .count = ((&value_18)).count, .names = ((&value_18)).names, .remaining = ((&value_18)).remaining, .root = ((&value_18)).root, .sifting = ((&value_18)).sifting, .types = block_55: {
                                    const operand_52 = value_19;
                                    const operand_53 = value_20;
                                    const operand_54 = value_22;

                                    if ((operand_53 >= (operand_52).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_22)) {
                                        state_items_21 = (try (allocator).dupe(u32, operand_52));
                                        state_items_started_22 = true;
                                    }

                                    (state_items_21)[@intCast(operand_53)] = operand_54;

                                    break :block_55 state_items_21;
                                }, };
                            };
                            const value_24: (zx_abi).zx_type_115 = ((&value_23)).*;
                            const value_25: []const []const u8 = ((&value_24)).names;
                            const value_26: u64 = value_9;
                            _ = block_51: {
                                const operand_49 = value_25;
                                const operand_50 = value_26;

                                if ((operand_50 >= (operand_49).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_51 (operand_49)[@intCast(operand_50)];
                            };
                            const value_28: []const u8 = value_10;

                            const value_29: (zx_abi).zx_type_115 = block_48: {
                                break :block_48 (zx_abi).zx_type_115{ .building = ((&value_24)).building, .count = ((&value_24)).count, .names = block_47: {
                                    const operand_44 = value_25;
                                    const operand_45 = value_26;
                                    const operand_46 = value_28;

                                    if ((operand_45 >= (operand_44).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_20)) {
                                        state_items_19 = (try (allocator).dupe([]const u8, operand_44));
                                        state_items_started_20 = true;
                                    }

                                    (state_items_19)[@intCast(operand_45)] = operand_46;

                                    break :block_47 state_items_19;
                                }, .remaining = ((&value_24)).remaining, .root = ((&value_24)).root, .sifting = ((&value_24)).sifting, .types = ((&value_24)).types, };
                            };

                            const value_30: (zx_abi).zx_type_115 = ((&value_29)).*;
                            const value_31: []const u32 = ((&value_30)).types;
                            const value_32: u64 = value_9;
                            _ = block_43: {
                                const operand_41 = value_31;
                                const operand_42 = value_32;

                                if ((operand_42 >= (operand_41).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_43 (operand_41)[@intCast(operand_42)];
                            };
                            const value_34: u32 = value_11;

                            const value_35: (zx_abi).zx_type_115 = block_40: {
                                break :block_40 (zx_abi).zx_type_115{ .building = ((&value_30)).building, .count = ((&value_30)).count, .names = ((&value_30)).names, .remaining = ((&value_30)).remaining, .root = ((&value_30)).root, .sifting = ((&value_30)).sifting, .types = block_39: {
                                    const operand_36 = value_31;
                                    const operand_37 = value_32;
                                    const operand_38 = value_34;

                                    if ((operand_37 >= (operand_36).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_22)) {
                                        state_items_21 = (try (allocator).dupe(u32, operand_36));
                                        state_items_started_22 = true;
                                    }

                                    (state_items_21)[@intCast(operand_37)] = operand_38;

                                    break :block_39 state_items_21;
                                }, };
                            };
                            const value_36: (zx_abi).zx_type_115 = ((&value_35)).*;

                            _ = ((&value_36)).root;
                            const value_38: u64 = value_9;

                            const value_39: (zx_abi).zx_type_115 = block_35: {
                                break :block_35 (zx_abi).zx_type_115{ .building = ((&value_36)).building, .count = ((&value_36)).count, .names = ((&value_36)).names, .remaining = ((&value_36)).remaining, .root = value_38, .sifting = ((&value_36)).sifting, .types = ((&value_36)).types, };
                            };

                            break :block_80 ((&value_39)).*;
                        } else block_82: {
                            const value_40: (zx_abi).zx_type_115 = ((&state_6)).*;
                            _ = ((&value_40)).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).zx_type_115 = block_81: {
                                break :block_81 (zx_abi).zx_type_115{ .building = ((&value_40)).building, .count = ((&value_40)).count, .names = ((&value_40)).names, .remaining = ((&value_40)).remaining, .root = ((&value_40)).root, .sifting = value_42, .types = ((&value_40)).types, };
                            };

                            break :block_82 ((&value_43)).*;
                        });

                        break :block_93 ((&value_44)).*;
                    });

                    break :block_94 ((&value_45)).*;
                } else block_150: {
                    const value_101: (zx_abi).zx_type_115 = (if (((&state_6)).building) block_101: {
                        const value_62: (zx_abi).zx_type_115 = (if ((((&state_6)).remaining == @as(u64, 0))) block_96: {
                            const value_46: (zx_abi).zx_type_115 = ((&state_6)).*;
                            _ = ((&value_46)).building;
                            const value_48: bool = false;

                            const value_49: (zx_abi).zx_type_115 = block_95: {
                                break :block_95 (zx_abi).zx_type_115{ .building = value_48, .count = ((&value_46)).count, .names = ((&value_46)).names, .remaining = ((&value_46)).remaining, .root = ((&value_46)).root, .sifting = ((&value_46)).sifting, .types = ((&value_46)).types, };
                            };

                            break :block_96 ((&value_49)).*;
                        } else block_100: {
                            const value_50: (zx_abi).zx_type_115 = ((&state_6)).*;
                            const value_51: u64 = ((&value_50)).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).zx_type_115 = block_99: {
                                break :block_99 (zx_abi).zx_type_115{ .building = ((&value_50)).building, .count = ((&value_50)).count, .names = ((&value_50)).names, .remaining = (value_51 - value_52), .root = ((&value_50)).root, .sifting = ((&value_50)).sifting, .types = ((&value_50)).types, };
                            };
                            const value_54: (zx_abi).zx_type_115 = ((&value_53)).*;

                            _ = ((&value_54)).root;

                            const value_56: u64 = ((&value_53)).remaining;

                            const value_57: (zx_abi).zx_type_115 = block_98: {
                                break :block_98 (zx_abi).zx_type_115{ .building = ((&value_54)).building, .count = ((&value_54)).count, .names = ((&value_54)).names, .remaining = ((&value_54)).remaining, .root = value_56, .sifting = ((&value_54)).sifting, .types = ((&value_54)).types, };
                            };
                            const value_58: (zx_abi).zx_type_115 = ((&value_57)).*;

                            _ = ((&value_58)).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).zx_type_115 = block_97: {
                                break :block_97 (zx_abi).zx_type_115{ .building = ((&value_58)).building, .count = ((&value_58)).count, .names = ((&value_58)).names, .remaining = ((&value_58)).remaining, .root = ((&value_58)).root, .sifting = value_60, .types = ((&value_58)).types, };
                            };

                            break :block_100 ((&value_61)).*;
                        });

                        break :block_101 ((&value_62)).*;
                    } else block_149: {
                        const value_63: (zx_abi).zx_type_115 = ((&state_6)).*;
                        const value_64: u64 = ((&value_63)).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).zx_type_115 = block_148: {
                            break :block_148 (zx_abi).zx_type_115{ .building = ((&value_63)).building, .count = (value_64 - value_65), .names = ((&value_63)).names, .remaining = ((&value_63)).remaining, .root = ((&value_63)).root, .sifting = ((&value_63)).sifting, .types = ((&value_63)).types, };
                        };
                        const value_67: []const u8 = block_147: {
                            const operand_145 = ((&value_66)).names;
                            const operand_146 = @as(u64, 0);

                            if ((operand_146 >= (operand_145).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_147 (operand_145)[@intCast(operand_146)];
                        };
                        const value_68: u32 = block_144: {
                            const operand_142 = ((&value_66)).types;
                            const operand_143 = @as(u64, 0);

                            if ((operand_143 >= (operand_142).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_144 (operand_142)[@intCast(operand_143)];
                        };

                        const value_69: (zx_abi).zx_type_115 = ((&value_66)).*;
                        const value_70: []const []const u8 = ((&value_69)).names;
                        const value_71: u64 = @as(u64, 0);

                        _ = block_141: {
                            const operand_139 = value_70;
                            const operand_140 = value_71;

                            if ((operand_140 >= (operand_139).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_141 (operand_139)[@intCast(operand_140)];
                        };
                        const value_73: []const u8 = block_138: {
                            const operand_136 = ((&value_66)).names;
                            const operand_137 = ((&value_66)).count;

                            if ((operand_137 >= (operand_136).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_138 (operand_136)[@intCast(operand_137)];
                        };
                        const value_74: (zx_abi).zx_type_115 = block_135: {
                            break :block_135 (zx_abi).zx_type_115{ .building = ((&value_69)).building, .count = ((&value_69)).count, .names = block_134: {
                                const operand_131 = value_70;
                                const operand_132 = value_71;
                                const operand_133 = value_73;

                                if ((operand_132 >= (operand_131).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_20)) {
                                    state_items_19 = (try (allocator).dupe([]const u8, operand_131));
                                    state_items_started_20 = true;
                                }

                                (state_items_19)[@intCast(operand_132)] = operand_133;

                                break :block_134 state_items_19;
                            }, .remaining = ((&value_69)).remaining, .root = ((&value_69)).root, .sifting = ((&value_69)).sifting, .types = ((&value_69)).types, };
                        };

                        const value_75: (zx_abi).zx_type_115 = ((&value_74)).*;
                        const value_76: []const u32 = ((&value_75)).types;
                        const value_77: u64 = @as(u64, 0);

                        _ = block_130: {
                            const operand_128 = value_76;
                            const operand_129 = value_77;

                            if ((operand_129 >= (operand_128).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_130 (operand_128)[@intCast(operand_129)];
                        };
                        const value_79: u32 = block_127: {
                            const operand_125 = ((&value_74)).types;
                            const operand_126 = ((&value_74)).count;

                            if ((operand_126 >= (operand_125).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_127 (operand_125)[@intCast(operand_126)];
                        };
                        const value_80: (zx_abi).zx_type_115 = block_124: {
                            break :block_124 (zx_abi).zx_type_115{ .building = ((&value_75)).building, .count = ((&value_75)).count, .names = ((&value_75)).names, .remaining = ((&value_75)).remaining, .root = ((&value_75)).root, .sifting = ((&value_75)).sifting, .types = block_123: {
                                const operand_120 = value_76;
                                const operand_121 = value_77;
                                const operand_122 = value_79;

                                if ((operand_121 >= (operand_120).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_22)) {
                                    state_items_21 = (try (allocator).dupe(u32, operand_120));
                                    state_items_started_22 = true;
                                }

                                (state_items_21)[@intCast(operand_121)] = operand_122;

                                break :block_123 state_items_21;
                            }, };
                        };

                        const value_81: (zx_abi).zx_type_115 = ((&value_80)).*;
                        const value_82: []const []const u8 = ((&value_81)).names;
                        const value_83: u64 = ((&value_80)).count;

                        _ = block_119: {
                            const operand_117 = value_82;
                            const operand_118 = value_83;

                            if ((operand_118 >= (operand_117).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_119 (operand_117)[@intCast(operand_118)];
                        };
                        const value_85: []const u8 = value_67;

                        const value_86: (zx_abi).zx_type_115 = block_116: {
                            break :block_116 (zx_abi).zx_type_115{ .building = ((&value_81)).building, .count = ((&value_81)).count, .names = block_115: {
                                const operand_112 = value_82;
                                const operand_113 = value_83;
                                const operand_114 = value_85;

                                if ((operand_113 >= (operand_112).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_20)) {
                                    state_items_19 = (try (allocator).dupe([]const u8, operand_112));
                                    state_items_started_20 = true;
                                }

                                (state_items_19)[@intCast(operand_113)] = operand_114;

                                break :block_115 state_items_19;
                            }, .remaining = ((&value_81)).remaining, .root = ((&value_81)).root, .sifting = ((&value_81)).sifting, .types = ((&value_81)).types, };
                        };

                        const value_87: (zx_abi).zx_type_115 = ((&value_86)).*;
                        const value_88: []const u32 = ((&value_87)).types;
                        const value_89: u64 = ((&value_86)).count;

                        _ = block_111: {
                            const operand_109 = value_88;
                            const operand_110 = value_89;

                            if ((operand_110 >= (operand_109).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_111 (operand_109)[@intCast(operand_110)];
                        };

                        const value_91: u32 = value_68;

                        const value_92: (zx_abi).zx_type_115 = block_108: {
                            break :block_108 (zx_abi).zx_type_115{ .building = ((&value_87)).building, .count = ((&value_87)).count, .names = ((&value_87)).names, .remaining = ((&value_87)).remaining, .root = ((&value_87)).root, .sifting = ((&value_87)).sifting, .types = block_107: {
                                const operand_104 = value_88;
                                const operand_105 = value_89;
                                const operand_106 = value_91;

                                if ((operand_105 >= (operand_104).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_22)) {
                                    state_items_21 = (try (allocator).dupe(u32, operand_104));
                                    state_items_started_22 = true;
                                }

                                (state_items_21)[@intCast(operand_105)] = operand_106;

                                break :block_107 state_items_21;
                            }, };
                        };
                        const value_93: (zx_abi).zx_type_115 = ((&value_92)).*;

                        _ = ((&value_93)).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).zx_type_115 = block_103: {
                            break :block_103 (zx_abi).zx_type_115{ .building = ((&value_93)).building, .count = ((&value_93)).count, .names = ((&value_93)).names, .remaining = ((&value_93)).remaining, .root = value_95, .sifting = ((&value_93)).sifting, .types = ((&value_93)).types, };
                        };

                        const value_97: (zx_abi).zx_type_115 = ((&value_96)).*;

                        _ = ((&value_97)).sifting;

                        const value_99: bool = true;

                        const value_100: (zx_abi).zx_type_115 = block_102: {
                            break :block_102 (zx_abi).zx_type_115{ .building = ((&value_97)).building, .count = ((&value_97)).count, .names = ((&value_97)).names, .remaining = ((&value_97)).remaining, .root = ((&value_97)).root, .sifting = value_99, .types = ((&value_97)).types, };
                        };

                        break :block_149 ((&value_100)).*;
                    });

                    break :block_150 ((&value_101)).*;
                });

                break :block_151 ((&value_102)).*;
            };

            state_changed_18 = true;
        }

        break :block_155 (if (state_changed_18) block_154: {
            const operand_153 = (try (allocator).create((zx_abi).zx_type_115));

            (operand_153).* = @as((zx_abi).zx_type_115, state_6);

            break :block_154 @as(*const (zx_abi).zx_type_115, operand_153);
        } else operand_17);
    };

    return block_5: {
        const operand_1 = (value_103).names;
        const operand_2 = (value_103).types;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_3).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_1, .types = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_18, operand_3);
        };
    };
}

fn function_31_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).names).len) < @as(u64, 2))) {
        return (in).*;
    }

    const value_103: (zx_abi).zx_type_115 = block_372: {
        const operand_168 = block_167: {
            const operand_160 = (in).names;
            const operand_161 = (in).types;
            const operand_162 = @as(u64, ((in).names).len);
            const operand_163 = @divTrunc(@as(u64, ((in).names).len), @as(u64, 2));
            const operand_164 = @as(u64, 0);
            const operand_165 = true;
            const operand_166 = false;

            break :block_167 (zx_abi).zx_type_115{ .names = operand_160, .types = operand_161, .count = operand_162, .remaining = operand_163, .root = operand_164, .building = operand_165, .sifting = operand_166, };
        };

        var state_items_169: [][]const u8 = undefined;
        var state_items_started_170 = false;
        var state_items_171: []u32 = undefined;
        var state_items_started_172 = false;
        var state_159: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (operand_168).building, .count = (operand_168).count, .names = (operand_168).names, .remaining = (operand_168).remaining, .root = (operand_168).root, .sifting = (operand_168).sifting, .types = (operand_168).types, .zx_origin = (&operand_168), };

        while ((((state_159).building or ((state_159).count > @as(u64, 1))) or (state_159).sifting)) {
            state_159 = block_369: {
                const value_102: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).sifting) block_281: {
                    const value_45: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).root >= @divTrunc((state_159).count, @as(u64, 2)))) block_175: {
                        const value_3: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        _ = (value_3).sifting;
                        const value_5: bool = false;

                        const value_6: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_174: {
                            break :block_174 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_3).building, .count = (value_3).count, .names = (value_3).names, .remaining = (value_3).remaining, .root = (value_3).root, .sifting = block_173: {
                                break :block_173 value_5;
                            }, .types = (value_3).types, });
                        };

                        break :block_175 value_6;
                    } else block_280: {
                        const value_7: u64 = (((state_159).root * @as(u64, 2)) + @as(u64, 1));

                        const value_8: u64 = (block_279: {
                            break :block_279 value_7;
                        } + @as(u64, 1));
                        const value_9: u64 = (if (((block_264: {
                            break :block_264 value_8;
                        } < (state_159).count) and block_276: {
                            const operand_269 = block_268: {
                                const operand_266 = (state_159).names;

                                const operand_267 = block_265: {
                                    break :block_265 value_7;
                                };

                                if ((operand_267 >= (operand_266).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_268 (operand_266)[@intCast(operand_267)];
                            };
                            const operand_274 = block_273: {
                                const operand_271 = (state_159).names;

                                const operand_272 = block_270: {
                                    break :block_270 value_8;
                                };

                                if ((operand_272 >= (operand_271).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_273 (operand_271)[@intCast(operand_272)];
                            };

                            const operand_275 = (zx_abi).zx_type_113{ .left = operand_269, .right = operand_274, };

                            break :block_276 (try function_30(allocator, (&operand_275)));
                        })) block_277: {
                            break :block_277 value_8;
                        } else block_278: {
                            break :block_278 value_7;
                        });

                        const value_44: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (block_186: {
                            const operand_179 = block_178: {
                                const operand_176 = (state_159).names;
                                const operand_177 = (state_159).root;

                                if ((operand_177 >= (operand_176).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_178 (operand_176)[@intCast(operand_177)];
                            };
                            const operand_184 = block_183: {
                                const operand_181 = (state_159).names;

                                const operand_182 = block_180: {
                                    break :block_180 value_9;
                                };

                                if ((operand_182 >= (operand_181).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_183 (operand_181)[@intCast(operand_182)];
                            };

                            const operand_185 = (zx_abi).zx_type_113{ .left = operand_179, .right = operand_184, };

                            break :block_186 (try function_30(allocator, (&operand_185)));
                        }) block_260: {
                            const value_10: []const u8 = block_259: {
                                const operand_257 = (state_159).names;
                                const operand_258 = (state_159).root;

                                if ((operand_258 >= (operand_257).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_259 (operand_257)[@intCast(operand_258)];
                            };
                            const value_11: u32 = block_256: {
                                const operand_254 = (state_159).types;
                                const operand_255 = (state_159).root;

                                if ((operand_255 >= (operand_254).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_256 (operand_254)[@intCast(operand_255)];
                            };
                            const value_12: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_13: []const []const u8 = (value_12).names;
                            const value_14: u64 = (state_159).root;
                            _ = block_253: {
                                const operand_251 = block_249: {
                                    break :block_249 value_13;
                                };
                                const operand_252 = block_250: {
                                    break :block_250 value_14;
                                };

                                if ((operand_252 >= (operand_251).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_253 (operand_251)[@intCast(operand_252)];
                            };
                            const value_16: []const u8 = block_248: {
                                const operand_246 = (state_159).names;

                                const operand_247 = block_245: {
                                    break :block_245 value_9;
                                };

                                if ((operand_247 >= (operand_246).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_248 (operand_246)[@intCast(operand_247)];
                            };
                            const value_17: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_244: {
                                break :block_244 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_12).building, .count = (value_12).count, .names = block_243: {
                                    const operand_238 = block_237: {
                                        break :block_237 value_13;
                                    };
                                    const operand_240 = block_239: {
                                        break :block_239 value_14;
                                    };
                                    const operand_242 = block_241: {
                                        break :block_241 value_16;
                                    };

                                    if ((operand_240 >= (operand_238).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_170)) {
                                        state_items_169 = (try (allocator).dupe([]const u8, operand_238));
                                        state_items_started_170 = true;
                                    }

                                    (state_items_169)[@intCast(operand_240)] = operand_242;
                                    break :block_243 state_items_169;
                                }, .remaining = (value_12).remaining, .root = (value_12).root, .sifting = (value_12).sifting, .types = (value_12).types, });
                            };
                            const value_18: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_17;
                            const value_19: []const u32 = (value_18).types;
                            const value_20: u64 = (value_17).root;
                            _ = block_236: {
                                const operand_234 = block_232: {
                                    break :block_232 value_19;
                                };
                                const operand_235 = block_233: {
                                    break :block_233 value_20;
                                };

                                if ((operand_235 >= (operand_234).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_236 (operand_234)[@intCast(operand_235)];
                            };
                            const value_22: u32 = block_231: {
                                const operand_229 = (value_17).types;

                                const operand_230 = block_228: {
                                    break :block_228 value_9;
                                };

                                if ((operand_230 >= (operand_229).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_231 (operand_229)[@intCast(operand_230)];
                            };
                            const value_23: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_227: {
                                break :block_227 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_18).building, .count = (value_18).count, .names = (value_18).names, .remaining = (value_18).remaining, .root = (value_18).root, .sifting = (value_18).sifting, .types = block_226: {
                                    const operand_221 = block_220: {
                                        break :block_220 value_19;
                                    };
                                    const operand_223 = block_222: {
                                        break :block_222 value_20;
                                    };
                                    const operand_225 = block_224: {
                                        break :block_224 value_22;
                                    };

                                    if ((operand_223 >= (operand_221).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_172)) {
                                        state_items_171 = (try (allocator).dupe(u32, operand_221));
                                        state_items_started_172 = true;
                                    }

                                    (state_items_171)[@intCast(operand_223)] = operand_225;

                                    break :block_226 state_items_171;
                                }, });
                            };
                            const value_24: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_23;
                            const value_25: []const []const u8 = (value_24).names;

                            const value_26: u64 = block_219: {
                                break :block_219 value_9;
                            };
                            _ = block_218: {
                                const operand_216 = block_214: {
                                    break :block_214 value_25;
                                };
                                const operand_217 = block_215: {
                                    break :block_215 value_26;
                                };

                                if ((operand_217 >= (operand_216).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_218 (operand_216)[@intCast(operand_217)];
                            };
                            const value_28: []const u8 = block_213: {
                                break :block_213 value_10;
                            };
                            const value_29: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_212: {
                                break :block_212 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_24).building, .count = (value_24).count, .names = block_211: {
                                    const operand_206 = block_205: {
                                        break :block_205 value_25;
                                    };
                                    const operand_208 = block_207: {
                                        break :block_207 value_26;
                                    };
                                    const operand_210 = block_209: {
                                        break :block_209 value_28;
                                    };

                                    if ((operand_208 >= (operand_206).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_170)) {
                                        state_items_169 = (try (allocator).dupe([]const u8, operand_206));
                                        state_items_started_170 = true;
                                    }

                                    (state_items_169)[@intCast(operand_208)] = operand_210;
                                    break :block_211 state_items_169;
                                }, .remaining = (value_24).remaining, .root = (value_24).root, .sifting = (value_24).sifting, .types = (value_24).types, });
                            };
                            const value_30: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_29;
                            const value_31: []const u32 = (value_30).types;
                            const value_32: u64 = block_204: {
                                break :block_204 value_9;
                            };
                            _ = block_203: {
                                const operand_201 = block_199: {
                                    break :block_199 value_31;
                                };
                                const operand_202 = block_200: {
                                    break :block_200 value_32;
                                };

                                if ((operand_202 >= (operand_201).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_203 (operand_201)[@intCast(operand_202)];
                            };
                            const value_34: u32 = block_198: {
                                break :block_198 value_11;
                            };
                            const value_35: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_197: {
                                break :block_197 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_30).building, .count = (value_30).count, .names = (value_30).names, .remaining = (value_30).remaining, .root = (value_30).root, .sifting = (value_30).sifting, .types = block_196: {
                                    const operand_191 = block_190: {
                                        break :block_190 value_31;
                                    };
                                    const operand_193 = block_192: {
                                        break :block_192 value_32;
                                    };
                                    const operand_195 = block_194: {
                                        break :block_194 value_34;
                                    };

                                    if ((operand_193 >= (operand_191).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    if ((!state_items_started_172)) {
                                        state_items_171 = (try (allocator).dupe(u32, operand_191));
                                        state_items_started_172 = true;
                                    }

                                    (state_items_171)[@intCast(operand_193)] = operand_195;

                                    break :block_196 state_items_171;
                                }, });
                            };
                            const value_36: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_35;
                            _ = (value_36).root;

                            const value_38: u64 = block_189: {
                                break :block_189 value_9;
                            };
                            const value_39: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_188: {
                                break :block_188 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_36).building, .count = (value_36).count, .names = (value_36).names, .remaining = (value_36).remaining, .root = block_187: {
                                    break :block_187 value_38;
                                }, .sifting = (value_36).sifting, .types = (value_36).types, });
                            };

                            break :block_260 value_39;
                        } else block_263: {
                            const value_40: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_40).sifting;
                            const value_42: bool = false;

                            const value_43: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_262: {
                                break :block_262 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_40).building, .count = (value_40).count, .names = (value_40).names, .remaining = (value_40).remaining, .root = (value_40).root, .sifting = block_261: {
                                    break :block_261 value_42;
                                }, .types = (value_40).types, });
                            };

                            break :block_263 value_43;
                        });

                        break :block_280 value_44;
                    });

                    break :block_281 value_45;
                } else block_368: {
                    const value_101: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((state_159).building) block_293: {
                        const value_62: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if (((state_159).remaining == @as(u64, 0))) block_284: {
                            const value_46: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            _ = (value_46).building;
                            const value_48: bool = false;

                            const value_49: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_283: {
                                break :block_283 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = block_282: {
                                    break :block_282 value_48;
                                }, .count = (value_46).count, .names = (value_46).names, .remaining = (value_46).remaining, .root = (value_46).root, .sifting = (value_46).sifting, .types = (value_46).types, });
                            };

                            break :block_284 value_49;
                        } else block_292: {
                            const value_50: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                            const value_51: u64 = (value_50).remaining;
                            const value_52: u64 = @as(u64, 1);

                            const value_53: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_291: {
                                break :block_291 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_50).building, .count = (value_50).count, .names = (value_50).names, .remaining = (block_289: {
                                    break :block_289 value_51;
                                } - block_290: {
                                    break :block_290 value_52;
                                }), .root = (value_50).root, .sifting = (value_50).sifting, .types = (value_50).types, });
                            };
                            const value_54: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_53;
                            _ = (value_54).root;
                            const value_56: u64 = (value_53).remaining;

                            const value_57: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_288: {
                                break :block_288 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_54).building, .count = (value_54).count, .names = (value_54).names, .remaining = (value_54).remaining, .root = block_287: {
                                    break :block_287 value_56;
                                }, .sifting = (value_54).sifting, .types = (value_54).types, });
                            };
                            const value_58: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_57;

                            _ = (value_58).sifting;
                            const value_60: bool = true;

                            const value_61: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_286: {
                                break :block_286 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_58).building, .count = (value_58).count, .names = (value_58).names, .remaining = (value_58).remaining, .root = (value_58).root, .sifting = block_285: {
                                    break :block_285 value_60;
                                }, .types = (value_58).types, });
                            };

                            break :block_292 value_61;
                        });

                        break :block_293 value_62;
                    } else block_367: {
                        const value_63: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_159;
                        const value_64: u64 = (value_63).count;
                        const value_65: u64 = @as(u64, 1);

                        const value_66: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_366: {
                            break :block_366 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_63).building, .count = (block_364: {
                                break :block_364 value_64;
                            } - block_365: {
                                break :block_365 value_65;
                            }), .names = (value_63).names, .remaining = (value_63).remaining, .root = (value_63).root, .sifting = (value_63).sifting, .types = (value_63).types, });
                        };
                        const value_67: []const u8 = block_363: {
                            const operand_361 = (value_66).names;
                            const operand_362 = @as(u64, 0);

                            if ((operand_362 >= (operand_361).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_363 (operand_361)[@intCast(operand_362)];
                        };
                        const value_68: u32 = block_360: {
                            const operand_358 = (value_66).types;
                            const operand_359 = @as(u64, 0);

                            if ((operand_359 >= (operand_358).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_360 (operand_358)[@intCast(operand_359)];
                        };
                        const value_69: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_66;
                        const value_70: []const []const u8 = (value_69).names;
                        const value_71: u64 = @as(u64, 0);

                        _ = block_357: {
                            const operand_355 = block_353: {
                                break :block_353 value_70;
                            };
                            const operand_356 = block_354: {
                                break :block_354 value_71;
                            };

                            if ((operand_356 >= (operand_355).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_357 (operand_355)[@intCast(operand_356)];
                        };
                        const value_73: []const u8 = block_352: {
                            const operand_350 = (value_66).names;
                            const operand_351 = (value_66).count;

                            if ((operand_351 >= (operand_350).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_352 (operand_350)[@intCast(operand_351)];
                        };
                        const value_74: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_349: {
                            break :block_349 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_69).building, .count = (value_69).count, .names = block_348: {
                                const operand_343 = block_342: {
                                    break :block_342 value_70;
                                };
                                const operand_345 = block_344: {
                                    break :block_344 value_71;
                                };
                                const operand_347 = block_346: {
                                    break :block_346 value_73;
                                };

                                if ((operand_345 >= (operand_343).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_170)) {
                                    state_items_169 = (try (allocator).dupe([]const u8, operand_343));
                                    state_items_started_170 = true;
                                }

                                (state_items_169)[@intCast(operand_345)] = operand_347;
                                break :block_348 state_items_169;
                            }, .remaining = (value_69).remaining, .root = (value_69).root, .sifting = (value_69).sifting, .types = (value_69).types, });
                        };

                        const value_75: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_74;
                        const value_76: []const u32 = (value_75).types;
                        const value_77: u64 = @as(u64, 0);
                        _ = block_341: {
                            const operand_339 = block_337: {
                                break :block_337 value_76;
                            };
                            const operand_340 = block_338: {
                                break :block_338 value_77;
                            };

                            if ((operand_340 >= (operand_339).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_341 (operand_339)[@intCast(operand_340)];
                        };
                        const value_79: u32 = block_336: {
                            const operand_334 = (value_74).types;
                            const operand_335 = (value_74).count;

                            if ((operand_335 >= (operand_334).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_336 (operand_334)[@intCast(operand_335)];
                        };
                        const value_80: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_333: {
                            break :block_333 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_75).building, .count = (value_75).count, .names = (value_75).names, .remaining = (value_75).remaining, .root = (value_75).root, .sifting = (value_75).sifting, .types = block_332: {
                                const operand_327 = block_326: {
                                    break :block_326 value_76;
                                };
                                const operand_329 = block_328: {
                                    break :block_328 value_77;
                                };
                                const operand_331 = block_330: {
                                    break :block_330 value_79;
                                };

                                if ((operand_329 >= (operand_327).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_172)) {
                                    state_items_171 = (try (allocator).dupe(u32, operand_327));
                                    state_items_started_172 = true;
                                }

                                (state_items_171)[@intCast(operand_329)] = operand_331;

                                break :block_332 state_items_171;
                            }, });
                        };
                        const value_81: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_80;
                        const value_82: []const []const u8 = (value_81).names;
                        const value_83: u64 = (value_80).count;

                        _ = block_325: {
                            const operand_323 = block_321: {
                                break :block_321 value_82;
                            };
                            const operand_324 = block_322: {
                                break :block_322 value_83;
                            };

                            if ((operand_324 >= (operand_323).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_325 (operand_323)[@intCast(operand_324)];
                        };
                        const value_85: []const u8 = block_320: {
                            break :block_320 value_67;
                        };
                        const value_86: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_319: {
                            break :block_319 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_81).building, .count = (value_81).count, .names = block_318: {
                                const operand_313 = block_312: {
                                    break :block_312 value_82;
                                };
                                const operand_315 = block_314: {
                                    break :block_314 value_83;
                                };
                                const operand_317 = block_316: {
                                    break :block_316 value_85;
                                };

                                if ((operand_315 >= (operand_313).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_170)) {
                                    state_items_169 = (try (allocator).dupe([]const u8, operand_313));
                                    state_items_started_170 = true;
                                }

                                (state_items_169)[@intCast(operand_315)] = operand_317;

                                break :block_318 state_items_169;
                            }, .remaining = (value_81).remaining, .root = (value_81).root, .sifting = (value_81).sifting, .types = (value_81).types, });
                        };
                        const value_87: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_86;
                        const value_88: []const u32 = (value_87).types;
                        const value_89: u64 = (value_86).count;

                        _ = block_311: {
                            const operand_309 = block_307: {
                                break :block_307 value_88;
                            };
                            const operand_310 = block_308: {
                                break :block_308 value_89;
                            };

                            if ((operand_310 >= (operand_309).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_311 (operand_309)[@intCast(operand_310)];
                        };
                        const value_91: u32 = block_306: {
                            break :block_306 value_68;
                        };
                        const value_92: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_305: {
                            break :block_305 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_87).building, .count = (value_87).count, .names = (value_87).names, .remaining = (value_87).remaining, .root = (value_87).root, .sifting = (value_87).sifting, .types = block_304: {
                                const operand_299 = block_298: {
                                    break :block_298 value_88;
                                };
                                const operand_301 = block_300: {
                                    break :block_300 value_89;
                                };
                                const operand_303 = block_302: {
                                    break :block_302 value_91;
                                };

                                if ((operand_301 >= (operand_299).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_172)) {
                                    state_items_171 = (try (allocator).dupe(u32, operand_299));
                                    state_items_started_172 = true;
                                }

                                (state_items_171)[@intCast(operand_301)] = operand_303;

                                break :block_304 state_items_171;
                            }, });
                        };
                        const value_93: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_92;
                        _ = (value_93).root;
                        const value_95: u64 = @as(u64, 0);

                        const value_96: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_297: {
                            break :block_297 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_93).building, .count = (value_93).count, .names = (value_93).names, .remaining = (value_93).remaining, .root = block_296: {
                                break :block_296 value_95;
                            }, .sifting = (value_93).sifting, .types = (value_93).types, });
                        };
                        const value_97: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_96;

                        _ = (value_97).sifting;
                        const value_99: bool = true;

                        const value_100: (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_295: {
                            break :block_295 @as((zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .building = (value_97).building, .count = (value_97).count, .names = (value_97).names, .remaining = (value_97).remaining, .root = (value_97).root, .sifting = block_294: {
                                break :block_294 value_99;
                            }, .types = (value_97).types, });
                        };

                        break :block_367 value_100;
                    });

                    break :block_368 value_101;
                });

                break :block_369 value_102;
            };
        }

        break :block_372 block_371: {
            break :block_371 (if (((state_159).zx_origin != null)) ((state_159).zx_origin.?).* else block_370: {
                break :block_370 (zx_abi).zx_type_115{ .building = (state_159).building, .count = (state_159).count, .names = (state_159).names, .remaining = (state_159).remaining, .root = (state_159).root, .sifting = (state_159).sifting, .types = (state_159).types, };
            });
        };
    };

    return block_158: {
        const operand_156 = ((&value_103)).names;
        const operand_157 = ((&value_103)).types;

        break :block_158 (zx_abi).zx_type_18{ .names = operand_156, .types = operand_157, };
    };
}

fn function_32(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_109) error{ IntegerOverflow, }!u32 {
    @setRuntimeSafety(true);

    const value_1: u32 = (try function_22(allocator, ((@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len)) + @as(u64, 1))));

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) {
        _ = (try function_22(allocator, ((@as(u64, ((((in).tables).base).children).len) + @as(u64, ((((in).tables).delta).children).len)) + @as(u64, (((in).candidate).children).len))));
    } else {
        if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) {
            _ = (try function_22(allocator, ((@as(u64, ((((in).tables).base).field_types).len) + @as(u64, ((((in).tables).delta).field_types).len)) + @as(u64, ((((in).candidate).fields).types).len))));
            _ = (try function_22(allocator, ((@as(u64, ((((in).tables).base).field_names).len) + @as(u64, ((((in).tables).delta).field_names).len)) + @as(u64, ((((in).candidate).fields).names).len))));
        } else {
            if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)))) {
                _ = (try function_22(allocator, ((@as(u64, ((((in).tables).base).names).len) + @as(u64, ((((in).tables).delta).names).len)) + @as(u64, (((in).candidate).names).len))));
            }
        }
    }

    return (value_1 - @as(u32, 1));
}

fn function_33(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_119) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_17 {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_21(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_15 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_25(allocator, block_4: {
            const operand_2 = (value_4).kinds;
            const operand_3 = value_5;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = (value_4).first;
            const operand_7 = value_5;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = (value_4).second;
            const operand_11 = value_5;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = (value_4).labels;
            const operand_15 = value_5;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        const operand_17 = value_3;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_18).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .delta = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_17, operand_18);
        };
    };
}

fn function_33_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);

    const value_2: u64 = block_58: {
        const operand_57 = (in).id;

        break :block_58 (try function_21(allocator, operand_57));
    };

    const value_3: bool = (block_55: {
        break :block_55 value_2;
    } >= block_56: {
        break :block_56 value_1;
    });

    const value_4: (zx_abi).zx_type_15 = (if (block_54: {
        break :block_54 value_3;
    }) (((in).tables).delta).* else (((in).tables).base).*);

    const value_5: u64 = (if (block_50: {
        break :block_50 value_3;
    }) (block_51: {
        break :block_51 value_2;
    } - block_52: {
        break :block_52 value_1;
    }) else block_53: {
        break :block_53 value_2;
    });

    return block_49: {
        const operand_21 = block_28: {
            const operand_27 = block_26: {
                const operand_24 = (block_22: {
                    break :block_22 (&value_4);
                }).kinds;

                const operand_25 = block_23: {
                    break :block_23 value_5;
                };

                if ((operand_25 >= (operand_24).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_26 (operand_24)[@intCast(operand_25)];
            };

            break :block_28 (try function_25(allocator, operand_27));
        };

        const operand_29 = block_34: {
            const operand_32 = (block_30: {
                break :block_30 (&value_4);
            }).first;

            const operand_33 = block_31: {
                break :block_31 value_5;
            };

            if ((operand_33 >= (operand_32).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_34 (operand_32)[@intCast(operand_33)];
        };
        const operand_35 = block_40: {
            const operand_38 = (block_36: {
                break :block_36 (&value_4);
            }).second;

            const operand_39 = block_37: {
                break :block_37 value_5;
            };

            if ((operand_39 >= (operand_38).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_40 (operand_38)[@intCast(operand_39)];
        };
        const operand_41 = block_46: {
            const operand_44 = (block_42: {
                break :block_42 (&value_4);
            }).labels;

            const operand_45 = block_43: {
                break :block_43 value_5;
            };

            if ((operand_45 >= (operand_44).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_46 (operand_44)[@intCast(operand_45)];
        };

        const operand_47 = block_48: {
            break :block_48 value_3;
        };

        break :block_49 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .kind = operand_21, .first = operand_29, .second = operand_35, .label = operand_41, .delta = operand_47, });
    };
}

fn function_34(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_121) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_17 = block_34: {
        const operand_28 = (in).tables;
        const operand_29 = (try function_22(allocator, (in).index));
        const operand_30 = (zx_abi).zx_type_119{ .tables = operand_28, .id = operand_29, };
        const operand_31 = (&operand_30);
        const operand_32 = (try function_33_value(allocator, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_31).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_31).tables).base, .delta = ((operand_31).tables).delta, .zx_origin = (operand_31).tables, }, .zx_origin = operand_31, }));

        break :block_34 (if (((operand_32).zx_origin != null)) ((operand_32).zx_origin.?).* else block_33: {
            break :block_33 (zx_abi).zx_type_17{ .delta = (operand_32).delta, .first = (operand_32).first, .kind = (operand_32).kind, .label = (operand_32).label, .second = (operand_32).second, };
        });
    };

    const value_2: (zx_abi).zx_type_11 = ((&value_1)).kind;
    const value_3: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if ((value_2 == value_3)) {
        return true;
    }

    if (((value_2 == @as((zx_abi).zx_type_11, .Optional)) or ((in).native_references and ((value_2 == @as((zx_abi).zx_type_11, .List)) or (value_2 == @as((zx_abi).zx_type_11, .Task)))))) {
        return block_27: {
            const operand_25 = (in).flags;
            const operand_26 = (try function_21(allocator, ((&value_1)).first));

            if ((operand_26 >= (operand_25).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_27 (operand_25)[@intCast(operand_26)];
        };
    }

    if (((value_2 != @as((zx_abi).zx_type_11, .Tuple)) and (value_2 != @as((zx_abi).zx_type_11, .Object)))) {
        return false;
    }

    const value_4: (zx_abi).zx_type_15 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_5: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_11, .Tuple))) ((&value_4)).children else ((&value_4)).field_types);

    return block_24: {
        const operand_9 = block_8: {
            const operand_2 = (in).flags;
            const operand_3 = value_5;
            const operand_4 = (try function_21(allocator, ((&value_1)).first));
            const operand_5 = (try function_21(allocator, ((&value_1)).second));
            const operand_6 = @as(u64, 0);
            const operand_7 = false;

            break :block_8 (zx_abi).zx_type_122{ .flags = operand_2, .children = operand_3, .offset = operand_4, .count = operand_5, .index = operand_6, .found = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (operand_9).children, .count = (operand_9).count, .flags = (operand_9).flags, .found = (operand_9).found, .index = (operand_9).index, .offset = (operand_9).offset, .zx_origin = (&operand_9), };

        while (((!(state_1).found) and ((state_1).index < (state_1).count))) {
            state_1 = block_23: {
                const value_8: (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_1;
                _ = (value_8).found;

                const value_10: bool = block_22: {
                    const operand_20 = (state_1).flags;

                    const operand_21 = block_19: {
                        const operand_18 = block_17: {
                            const operand_15 = (state_1).children;
                            const operand_16 = ((state_1).offset + (state_1).index);

                            if ((operand_16 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_17 (operand_15)[@intCast(operand_16)];
                        };

                        break :block_19 (try function_21(allocator, operand_18));
                    };

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };

                const value_11: (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_8).children, .count = (value_8).count, .flags = (value_8).flags, .found = block_13: {
                        break :block_13 value_10;
                    }, .index = (value_8).index, .offset = (value_8).offset, });
                };

                const value_12: (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .children = (value_12).children, .count = (value_12).count, .flags = (value_12).flags, .found = (value_12).found, .index = (block_10: {
                        break :block_10 value_13;
                    } + block_11: {
                        break :block_11 value_14;
                    }), .offset = (value_12).offset, });
                };

                break :block_23 value_15;
            };
        }

        break :block_24 (state_1).found;
    };
}

fn function_35(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_123) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!bool {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_21(allocator, (in).id));
    const value_2: (zx_abi).zx_type_11 = (if ((in).native_references) @as((zx_abi).zx_type_11, .NativeReference) else @as((zx_abi).zx_type_11, .List));

    if (((block_68: {
        const operand_62 = (in).tables;
        const operand_63 = (in).id;
        const operand_64 = (zx_abi).zx_type_119{ .tables = operand_62, .id = operand_63, };
        const operand_65 = (&operand_64);
        const operand_66 = (try function_33_value(allocator, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_65).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_65).tables).base, .delta = ((operand_65).tables).delta, .zx_origin = (operand_65).tables, }, .zx_origin = operand_65, }));

        break :block_68 (if (((operand_66).zx_origin != null)) ((operand_66).zx_origin.?).* else block_67: {
            break :block_67 (zx_abi).zx_type_17{ .delta = (operand_66).delta, .first = (operand_66).first, .kind = (operand_66).kind, .label = (operand_66).label, .second = (operand_66).second, };
        });
    }).kind == value_2)) {
        return true;
    }

    const value_13: (zx_abi).zx_type_124 = block_61: {
        const operand_44 = block_43: {
            const operand_38 = (in).tables;
            const operand_39 = value_1;
            const operand_40 = value_2;
            const operand_41 = @as(u64, 0);
            const operand_42 = false;

            break :block_43 (zx_abi).zx_type_124{ .tables = operand_38, .limit = operand_39, .target = operand_40, .index = operand_41, .found = operand_42, };
        };

        var state_37: (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = (operand_44).found, .index = (operand_44).index, .limit = (operand_44).limit, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_44).tables).base, .delta = ((operand_44).tables).delta, .zx_origin = (operand_44).tables, }, .target = (operand_44).target, .zx_origin = (&operand_44), };

        while (((!(state_37).found) and ((state_37).index < (state_37).limit))) {
            state_37 = block_56: {
                const value_5: (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = state_37;
                _ = (value_5).found;

                const value_7: bool = ((block_55: {
                    break :block_55 (try function_33_value(allocator, block_54: {
                        const operand_50 = (state_37).tables;

                        const operand_51 = block_53: {
                            const operand_52 = (state_37).index;

                            break :block_53 (try function_22(allocator, operand_52));
                        };

                        break :block_54 @as((zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_50, .id = operand_51, });
                    }));
                }).kind == (state_37).target);

                const value_8: (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = block_49: {
                    break :block_49 @as((zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc, (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = block_48: {
                        break :block_48 value_7;
                    }, .index = (value_5).index, .limit = (value_5).limit, .tables = (value_5).tables, .target = (value_5).target, });
                };
                const value_9: (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = value_8;
                const value_10: u64 = (value_9).index;
                const value_11: u64 = @as(u64, 1);

                const value_12: (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = block_47: {
                    break :block_47 @as((zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc, (zx_abi).value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc{ .found = (value_9).found, .index = (block_45: {
                        break :block_45 value_10;
                    } + block_46: {
                        break :block_46 value_11;
                    }), .limit = (value_9).limit, .tables = (value_9).tables, .target = (value_9).target, });
                };

                break :block_56 value_12;
            };
        }

        break :block_61 block_60: {
            break :block_60 (if (((state_37).zx_origin != null)) ((state_37).zx_origin.?).* else block_59: {
                break :block_59 (zx_abi).zx_type_124{ .found = (state_37).found, .index = (state_37).index, .limit = (state_37).limit, .tables = (if ((((state_37).tables).zx_origin != null)) ((state_37).tables).zx_origin.? else block_58: {
                    const operand_57 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_57).* = (zx_abi).zx_type_16{ .base = ((state_37).tables).base, .delta = ((state_37).tables).delta, };

                    break :block_58 @as(*const (zx_abi).zx_type_16, operand_57);
                }), .target = (state_37).target, };
            });
        };
    };

    if ((!((&value_13)).found)) {
        return false;
    }

    const value_14: []const bool = @as([]const bool, (comptime (&[_]bool{})));

    return block_36: {
        const operand_9 = block_8: {
            const operand_2 = (in).tables;
            const operand_3 = @as(u64, 0);
            const operand_4 = (((&value_13)).index - @as(u64, 1));
            const operand_5 = (value_1 + @as(u64, 1));
            const operand_6 = value_14;
            const operand_7 = (in).native_references;

            break :block_8 (zx_abi).zx_type_125{ .tables = operand_2, .index = operand_3, .first = operand_4, .limit = operand_5, .flags = operand_6, .native_references = operand_7, };
        };

        var state_capacity_10: (std).ArrayList(bool) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (operand_9).first, .flags = (operand_9).flags, .index = (operand_9).index, .limit = (operand_9).limit, .native_references = (operand_9).native_references, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_9).tables).base, .delta = ((operand_9).tables).delta, .zx_origin = (operand_9).tables, }, .zx_origin = (&operand_9), };

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_31: {
                const value_17: bool = (((state_1).index >= (state_1).first) and block_30: {
                    const operand_21 = (state_1).tables;
                    var state_borrow_22: (zx_abi).zx_type_16 = undefined;

                    state_borrow_22 = (zx_abi).zx_type_16{ .base = (operand_21).base, .delta = (operand_21).delta, };

                    const operand_23 = ((operand_21).zx_origin orelse (&state_borrow_22));
                    const operand_24 = (state_1).index;
                    const operand_25 = (state_1).flags;
                    const operand_26 = (state_1).native_references;
                    const operand_27 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_23).base, .delta = (operand_23).delta, .zx_origin = operand_23, };
                    var state_borrow_28: (zx_abi).zx_type_16 = undefined;

                    state_borrow_28 = (zx_abi).zx_type_16{ .base = (operand_27).base, .delta = (operand_27).delta, };

                    const operand_29 = (zx_abi).zx_type_121{ .tables = ((operand_27).zx_origin orelse (&state_borrow_28)), .index = operand_24, .flags = operand_25, .native_references = operand_26, };

                    break :block_30 (try function_34(allocator, (&operand_29)));
                });

                const value_18: (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = state_1;

                _ = (value_18).flags;

                const value_20: []const bool = (block_20: {
                    const operand_17 = (state_1).flags;

                    const operand_19 = block_18: {
                        break :block_18 value_17;
                    };

                    _ = (try ((std).math).add(usize, (operand_17).len, 1));

                    if ((!state_capacity_started_11)) {
                        (try (state_capacity_10).appendSlice(allocator, operand_17));

                        state_capacity_started_11 = true;
                    } else {
                        ((state_capacity_10).items).len = (operand_17).len;
                    }

                    (try (state_capacity_10).append(allocator, operand_19));

                    break :block_20 @as((zx_abi).value_zx_type_126_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                }).@"0";

                const value_21: (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (value_18).first, .flags = block_15: {
                        break :block_15 value_20;
                    }, .index = (value_18).index, .limit = (value_18).limit, .native_references = (value_18).native_references, .tables = (value_18).tables, });
                };

                const value_22: (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = value_21;
                const value_23: u64 = (value_22).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e, (zx_abi).value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e{ .first = (value_22).first, .flags = (value_22).flags, .index = (block_12: {
                        break :block_12 value_23;
                    } + block_13: {
                        break :block_13 value_24;
                    }), .limit = (value_22).limit, .native_references = (value_22).native_references, .tables = (value_22).tables, });
                };

                break :block_31 value_25;
            };
        }

        break :block_36 block_35: {
            const operand_33 = (state_1).flags;

            const operand_34 = block_32: {
                break :block_32 value_1;
            };

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        };
    };
}

fn function_36(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_109) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_127 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Optional)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .List)))) {
        if (((block_32: {
            const operand_26 = (in).tables;
            const operand_27 = ((in).candidate).first;
            const operand_28 = (zx_abi).zx_type_119{ .tables = operand_26, .id = operand_27, };
            const operand_29 = (&operand_28);
            const operand_30 = (try function_33_value(allocator, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_29).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_29).tables).base, .delta = ((operand_29).tables).delta, .zx_origin = (operand_29).tables, }, .zx_origin = operand_29, }));

            break :block_32 (if (((operand_30).zx_origin != null)) ((operand_30).zx_origin.?).* else block_31: {
                break :block_31 (zx_abi).zx_type_17{ .delta = (operand_30).delta, .first = (operand_30).first, .kind = (operand_30).kind, .label = (operand_30).label, .second = (operand_30).second, };
            });
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return @as((zx_abi).zx_type_127, .TaskContainer);
        }

        return (if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .List)) and (((in).candidate).first == @as(u32, 0)))) @as((zx_abi).zx_type_127, .VoidList) else @as((zx_abi).zx_type_127, .None));
    }

    if (((((in).candidate).kind != @as((zx_abi).zx_type_11, .Tuple)) and (((in).candidate).kind != @as((zx_abi).zx_type_11, .Object)))) {
        return @as((zx_abi).zx_type_127, .None);
    }

    const value_1: []const u32 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) ((in).candidate).children else (((in).candidate).fields).types);

    const value_12: (zx_abi).zx_type_128 = block_25: {
        const operand_7 = block_6: {
            const operand_2 = (in).tables;
            const operand_3 = value_1;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 (zx_abi).zx_type_128{ .tables = operand_2, .children = operand_3, .index = operand_4, .found = operand_5, };
        };

        var state_1: (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (operand_7).children, .found = (operand_7).found, .index = (operand_7).index, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_7).tables).base, .delta = ((operand_7).tables).delta, .zx_origin = (operand_7).tables, }, .zx_origin = (&operand_7), };

        while (((!(state_1).found) and ((state_1).index < @as(u64, ((state_1).children).len)))) {
            state_1 = block_20: {
                const value_4: (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = state_1;
                _ = (value_4).found;

                const value_6: bool = ((block_19: {
                    break :block_19 (try function_33_value(allocator, block_18: {
                        const operand_13 = (state_1).tables;

                        const operand_14 = block_17: {
                            const operand_15 = (state_1).children;
                            const operand_16 = (state_1).index;

                            if ((operand_16 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_17 (operand_15)[@intCast(operand_16)];
                        };

                        break :block_18 @as((zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_13, .id = operand_14, });
                    }));
                }).kind == @as((zx_abi).zx_type_11, .Task));

                const value_7: (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363, (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (value_4).children, .found = block_11: {
                        break :block_11 value_6;
                    }, .index = (value_4).index, .tables = (value_4).tables, });
                };

                const value_8: (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = value_7;
                const value_9: u64 = (value_8).index;
                const value_10: u64 = @as(u64, 1);

                const value_11: (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = block_10: {
                    break :block_10 @as((zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363, (zx_abi).value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363{ .children = (value_8).children, .found = (value_8).found, .index = (block_8: {
                        break :block_8 value_9;
                    } + block_9: {
                        break :block_9 value_10;
                    }), .tables = (value_8).tables, });
                };

                break :block_20 value_11;
            };
        }

        break :block_25 block_24: {
            break :block_24 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_23: {
                break :block_23 (zx_abi).zx_type_128{ .children = (state_1).children, .found = (state_1).found, .index = (state_1).index, .tables = (if ((((state_1).tables).zx_origin != null)) ((state_1).tables).zx_origin.? else block_22: {
                    const operand_21 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_21).* = (zx_abi).zx_type_16{ .base = ((state_1).tables).base, .delta = ((state_1).tables).delta, };

                    break :block_22 @as(*const (zx_abi).zx_type_16, operand_21);
                }), };
            });
        };
    };

    if ((!((&value_12)).found)) {
        return @as((zx_abi).zx_type_127, .None);
    }

    return (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Tuple))) @as((zx_abi).zx_type_127, .TaskTuple) else @as((zx_abi).zx_type_127, .TaskObject));
}

fn function_37(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_109) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_116 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_127 = (try function_36(allocator, in));

    if ((value_1 == @as((zx_abi).zx_type_127, .TaskContainer))) {
        return block_32: {
            const operand_28 = @as([]const u8, "ownership");
            const operand_29 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_116));

                (operand_30).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_28, .message = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_116, operand_30);
            };
        };
    } else {
        if ((value_1 == @as((zx_abi).zx_type_127, .VoidList))) {
            return block_37: {
                const operand_33 = @as([]const u8, "type_mismatch");
                const operand_34 = @as([]const u8, "lists cannot contain void");

                break :block_37 block_36: {
                    const operand_35 = (try (allocator).create((zx_abi).zx_type_116));

                    (operand_35).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_33, .message = operand_34, });

                    break :block_36 @as(*const (zx_abi).zx_type_116, operand_35);
                };
            };
        } else {
            if ((value_1 == @as((zx_abi).zx_type_127, .TaskTuple))) {
                return block_42: {
                    const operand_38 = @as([]const u8, "ownership");
                    const operand_39 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_42 block_41: {
                        const operand_40 = (try (allocator).create((zx_abi).zx_type_116));

                        (operand_40).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_38, .message = operand_39, });

                        break :block_41 @as(*const (zx_abi).zx_type_116, operand_40);
                    };
                };
            } else {
                if ((value_1 == @as((zx_abi).zx_type_127, .TaskObject))) {
                    return block_47: {
                        const operand_43 = @as([]const u8, "ownership");
                        const operand_44 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_47 block_46: {
                            const operand_45 = (try (allocator).create((zx_abi).zx_type_116));

                            (operand_45).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_43, .message = operand_44, });

                            break :block_46 @as(*const (zx_abi).zx_type_116, operand_45);
                        };
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_22: {
            const operand_18 = (in).tables;
            const operand_19 = ((in).candidate).first;
            const operand_20 = true;
            const operand_21 = (zx_abi).zx_type_123{ .tables = operand_18, .id = operand_19, .native_references = operand_20, };

            break :block_22 (try function_35(allocator, (&operand_21)));
        }) {
            return block_27: {
                const operand_23 = @as([]const u8, "capability");
                const operand_24 = @as([]const u8, "tasks cannot return host references");

                break :block_27 block_26: {
                    const operand_25 = (try (allocator).create((zx_abi).zx_type_116));

                    (operand_25).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_23, .message = operand_24, });

                    break :block_26 @as(*const (zx_abi).zx_type_116, operand_25);
                };
            };
        }

        if (((block_12: {
            const operand_6 = (in).tables;
            const operand_7 = ((in).candidate).first;
            const operand_8 = (zx_abi).zx_type_119{ .tables = operand_6, .id = operand_7, };
            const operand_9 = (&operand_8);
            const operand_10 = (try function_33_value(allocator, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_9).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_9).tables).base, .delta = ((operand_9).tables).delta, .zx_origin = (operand_9).tables, }, .zx_origin = operand_9, }));

            break :block_12 (if (((operand_10).zx_origin != null)) ((operand_10).zx_origin.?).* else block_11: {
                break :block_11 (zx_abi).zx_type_17{ .delta = (operand_10).delta, .first = (operand_10).first, .kind = (operand_10).kind, .label = (operand_10).label, .second = (operand_10).second, };
            });
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return block_17: {
                const operand_13 = @as([]const u8, "ownership");
                const operand_14 = @as([]const u8, "a task cannot return another task");

                break :block_17 block_16: {
                    const operand_15 = (try (allocator).create((zx_abi).zx_type_116));

                    (operand_15).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_13, .message = operand_14, });

                    break :block_16 @as(*const (zx_abi).zx_type_116, operand_15);
                };
            };
        }
    }

    return block_5: {
        const operand_1 = @as([]const u8, "");
        const operand_2 = @as([]const u8, "");

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_116));

            (operand_3).* = @as((zx_abi).zx_type_116, (zx_abi).zx_type_116{ .code = operand_1, .message = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_116, operand_3);
        };
    };
}

fn function_37_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_127 = block_90: {
        const operand_86 = in;
        var state_borrow_87: (zx_abi).zx_type_19 = undefined;

        state_borrow_87 = (zx_abi).zx_type_19{ .children = ((operand_86).candidate).children, .fields = ((operand_86).candidate).fields, .first = ((operand_86).candidate).first, .kind = ((operand_86).candidate).kind, .label = ((operand_86).candidate).label, .names = ((operand_86).candidate).names, .second = ((operand_86).candidate).second, };

        var state_borrow_88: (zx_abi).zx_type_16 = undefined;
        state_borrow_88 = (zx_abi).zx_type_16{ .base = ((operand_86).tables).base, .delta = ((operand_86).tables).delta, };

        var state_borrow_89: (zx_abi).zx_type_109 = undefined;

        state_borrow_89 = (zx_abi).zx_type_109{ .candidate = (((operand_86).candidate).zx_origin orelse (&state_borrow_87)), .tables = (((operand_86).tables).zx_origin orelse (&state_borrow_88)), };

        break :block_90 (try function_36(allocator, ((operand_86).zx_origin orelse (&state_borrow_89))));
    };

    if ((block_70: {
        break :block_70 value_1;
    } == @as((zx_abi).zx_type_127, .TaskContainer))) {
        return block_73: {
            const operand_71 = @as([]const u8, "ownership");
            const operand_72 = @as([]const u8, "tasks cannot be placed in containers");

            break :block_73 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_71, .message = operand_72, });
        };
    } else {
        if ((block_74: {
            break :block_74 value_1;
        } == @as((zx_abi).zx_type_127, .VoidList))) {
            return block_77: {
                const operand_75 = @as([]const u8, "type_mismatch");
                const operand_76 = @as([]const u8, "lists cannot contain void");

                break :block_77 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_75, .message = operand_76, });
            };
        } else {
            if ((block_78: {
                break :block_78 value_1;
            } == @as((zx_abi).zx_type_127, .TaskTuple))) {
                return block_81: {
                    const operand_79 = @as([]const u8, "ownership");
                    const operand_80 = @as([]const u8, "tasks cannot be placed in tuples");

                    break :block_81 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_79, .message = operand_80, });
                };
            } else {
                if ((block_82: {
                    break :block_82 value_1;
                } == @as((zx_abi).zx_type_127, .TaskObject))) {
                    return block_85: {
                        const operand_83 = @as([]const u8, "ownership");
                        const operand_84 = @as([]const u8, "tasks cannot be placed in objects");

                        break :block_85 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_83, .message = operand_84, });
                    };
                }
            }
        }
    }

    if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Task))) {
        if (block_66: {
            const operand_58 = (in).tables;
            var state_borrow_59: (zx_abi).zx_type_16 = undefined;
            state_borrow_59 = (zx_abi).zx_type_16{ .base = (operand_58).base, .delta = (operand_58).delta, };

            const operand_60 = ((operand_58).zx_origin orelse (&state_borrow_59));
            const operand_61 = ((in).candidate).first;
            const operand_62 = true;
            const operand_63 = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = (operand_60).base, .delta = (operand_60).delta, .zx_origin = operand_60, };
            var state_borrow_64: (zx_abi).zx_type_16 = undefined;
            state_borrow_64 = (zx_abi).zx_type_16{ .base = (operand_63).base, .delta = (operand_63).delta, };

            const operand_65 = (zx_abi).zx_type_123{ .tables = ((operand_63).zx_origin orelse (&state_borrow_64)), .id = operand_61, .native_references = operand_62, };

            break :block_66 (try function_35(allocator, (&operand_65)));
        }) {
            return block_69: {
                const operand_67 = @as([]const u8, "capability");
                const operand_68 = @as([]const u8, "tasks cannot return host references");

                break :block_69 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_67, .message = operand_68, });
            };
        }

        if (((block_54: {
            break :block_54 (try function_33_value(allocator, block_53: {
                const operand_51 = (in).tables;
                const operand_52 = ((in).candidate).first;

                break :block_53 @as((zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_51, .id = operand_52, });
            }));
        }).kind == @as((zx_abi).zx_type_11, .Task))) {
            return block_57: {
                const operand_55 = @as([]const u8, "ownership");
                const operand_56 = @as([]const u8, "a task cannot return another task");

                break :block_57 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_55, .message = operand_56, });
            };
        }
    }

    return block_50: {
        const operand_48 = @as([]const u8, "");
        const operand_49 = @as([]const u8, "");

        break :block_50 @as((zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .code = operand_48, .message = operand_49, });
    };
}

fn function_38(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_109) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_118 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_116 = (try function_37(allocator, in));

    if ((!block_34: {
        const operand_32 = (value_1).message;
        const operand_33 = @as([]const u8, "");

        break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
    })) {
        return block_40: {
            const operand_35 = ((in).tables).delta;
            const operand_36 = @as(u32, 0);
            const operand_37 = value_1;

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_118));

                (operand_38).* = @as((zx_abi).zx_type_118, (zx_abi).zx_type_118{ .delta = operand_35, .id = operand_36, .diagnostic = operand_37, });

                break :block_39 @as(*const (zx_abi).zx_type_118, operand_38);
            };
        };
    }

    const value_2: *const (zx_abi).zx_type_19 = block_31: {
        const operand_23 = (in).candidate;
        const operand_24 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (try function_31(allocator, ((in).candidate).fields)) else ((in).candidate).fields);

        const operand_25 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_28: {
            const operand_26 = ((in).candidate).names;
            const operand_27 = (try (allocator).alloc([]const u8, (operand_26).len));

            @memcpy(operand_27, operand_26);
            ((std).mem).sortUnstable([]const u8, operand_27, {}, zx_compare_10);

            break :block_28 @as((zx_abi).zx_type_98, .{ operand_27, {}, });
        }).@"0" else ((in).candidate).names);

        break :block_31 block_30: {
            const operand_29 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_29).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (operand_23).children, .fields = operand_24, .first = (operand_23).first, .kind = (operand_23).kind, .label = (operand_23).label, .names = operand_25, .second = (operand_23).second, });

            break :block_30 @as(*const (zx_abi).zx_type_19, operand_29);
        };
    };

    const value_3: *const (zx_abi).zx_type_20 = (try function_28(allocator, block_22: {
        const operand_18 = (in).tables;
        const operand_19 = value_2;

        break :block_22 block_21: {
            const operand_20 = (try (allocator).create((zx_abi).zx_type_109));

            (operand_20).* = @as((zx_abi).zx_type_109, (zx_abi).zx_type_109{ .tables = operand_18, .candidate = operand_19, });

            break :block_21 @as(*const (zx_abi).zx_type_109, operand_20);
        };
    }));

    if ((value_3).found) {
        return block_17: {
            const operand_12 = ((in).tables).delta;
            const operand_13 = (value_3).id;
            const operand_14 = value_1;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_118));

                (operand_15).* = @as((zx_abi).zx_type_118, (zx_abi).zx_type_118{ .delta = operand_12, .id = operand_13, .diagnostic = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_118, operand_15);
            };
        };
    }

    const value_4: u32 = (try function_32(allocator, in));

    return block_11: {
        const operand_1 = (try function_29(allocator, block_6: {
            const operand_2 = ((in).tables).delta;
            const operand_3 = value_2;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_111));

                (operand_4).* = @as((zx_abi).zx_type_111, (zx_abi).zx_type_111{ .delta = operand_2, .candidate = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_111, operand_4);
            };
        }));

        const operand_7 = value_4;
        const operand_8 = value_1;

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_118));

            (operand_9).* = @as((zx_abi).zx_type_118, (zx_abi).zx_type_118{ .delta = operand_1, .id = operand_7, .diagnostic = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_118, operand_9);
        };
    };
}

fn function_38_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_82: {
        break :block_82 (try function_37_value(allocator, in));
    };

    if ((!block_77: {
        const operand_75 = (value_1).message;
        const operand_76 = @as([]const u8, "");

        break :block_77 ((std).mem).eql(u8, operand_75, operand_76);
    })) {
        return block_81: {
            const operand_78 = ((in).tables).delta;
            const operand_79 = @as(u32, 0);
            const operand_80 = value_1;

            break :block_81 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_78, .id = operand_79, .diagnostic = operand_80, });
        };
    }

    const value_2: (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_74: {
        const operand_66 = (in).candidate;

        const operand_67 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) block_69: {
            const operand_68 = ((in).candidate).fields;

            break :block_69 (try function_31(allocator, operand_68));
        } else ((in).candidate).fields);

        const operand_70 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_73: {
            const operand_71 = ((in).candidate).names;
            const operand_72 = (try (allocator).alloc([]const u8, (operand_71).len));

            @memcpy(operand_72, operand_71);
            ((std).mem).sortUnstable([]const u8, operand_72, {}, zx_compare_10);

            break :block_73 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_72, {}, null, });
        }).@"0" else ((in).candidate).names);

        break :block_74 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .children = (operand_66).children, .fields = operand_67, .first = (operand_66).first, .kind = (operand_66).kind, .label = (operand_66).label, .names = operand_70, .second = (operand_66).second, });
    };

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_65: {
        break :block_65 (try function_28_value(allocator, block_64: {
            const operand_62 = (in).tables;
            const operand_63 = value_2;

            break :block_64 @as((zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e, (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e{ .tables = operand_62, .candidate = operand_63, });
        }));
    };

    if ((value_3).found) {
        return block_61: {
            const operand_58 = ((in).tables).delta;
            const operand_59 = (value_3).id;
            const operand_60 = value_1;

            break :block_61 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_58, .id = operand_59, .diagnostic = operand_60, });
        };
    }

    const value_4: u32 = block_57: {
        const operand_53 = in;
        var state_borrow_54: (zx_abi).zx_type_19 = undefined;

        state_borrow_54 = (zx_abi).zx_type_19{ .children = ((operand_53).candidate).children, .fields = ((operand_53).candidate).fields, .first = ((operand_53).candidate).first, .kind = ((operand_53).candidate).kind, .label = ((operand_53).candidate).label, .names = ((operand_53).candidate).names, .second = ((operand_53).candidate).second, };

        var state_borrow_55: (zx_abi).zx_type_16 = undefined;
        state_borrow_55 = (zx_abi).zx_type_16{ .base = ((operand_53).tables).base, .delta = ((operand_53).tables).delta, };

        var state_borrow_56: (zx_abi).zx_type_109 = undefined;

        state_borrow_56 = (zx_abi).zx_type_109{ .candidate = (((operand_53).candidate).zx_origin orelse (&state_borrow_54)), .tables = (((operand_53).tables).zx_origin orelse (&state_borrow_55)), };

        break :block_57 (try function_32(allocator, ((operand_53).zx_origin orelse (&state_borrow_56))));
    };

    return block_52: {
        const operand_41 = block_48: {
            const operand_45 = block_44: {
                const operand_42 = ((in).tables).delta;
                const operand_43 = value_2;

                break :block_44 @as((zx_abi).value_zx_type_111_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b, (zx_abi).value_zx_type_111_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b{ .delta = operand_42, .candidate = operand_43, });
            };

            var state_borrow_46: (zx_abi).zx_type_19 = undefined;

            state_borrow_46 = (zx_abi).zx_type_19{ .children = ((operand_45).candidate).children, .fields = ((operand_45).candidate).fields, .first = ((operand_45).candidate).first, .kind = ((operand_45).candidate).kind, .label = ((operand_45).candidate).label, .names = ((operand_45).candidate).names, .second = ((operand_45).candidate).second, };

            var state_borrow_47: (zx_abi).zx_type_111 = undefined;

            state_borrow_47 = (zx_abi).zx_type_111{ .candidate = (((operand_45).candidate).zx_origin orelse (&state_borrow_46)), .delta = (operand_45).delta, };

            break :block_48 (try function_29(allocator, ((operand_45).zx_origin orelse (&state_borrow_47))));
        };

        const operand_49 = block_50: {
            break :block_50 value_4;
        };

        const operand_51 = value_1;

        break :block_52 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_41, .id = operand_49, .diagnostic = operand_51, });
    };
}

fn function_38_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_126: {
        break :block_126 (try function_37_value(allocator, in));
    };

    if ((!block_121: {
        const operand_119 = (value_1).message;
        const operand_120 = @as([]const u8, "");

        break :block_121 ((std).mem).eql(u8, operand_119, operand_120);
    })) {
        return block_125: {
            const operand_122 = ((in).tables).delta;
            const operand_123 = @as(u32, 0);
            const operand_124 = value_1;

            break :block_125 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_122, .id = operand_123, .diagnostic = operand_124, });
        };
    }

    const value_2: (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_118: {
        const operand_110 = (in).candidate;

        const operand_111 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) block_113: {
            const operand_112 = ((in).candidate).fields;

            break :block_113 (try function_31(allocator, operand_112));
        } else ((in).candidate).fields);

        const operand_114 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_117: {
            const operand_115 = ((in).candidate).names;
            const operand_116 = (try (allocator).alloc([]const u8, (operand_115).len));

            @memcpy(operand_116, operand_115);
            ((std).mem).sortUnstable([]const u8, operand_116, {}, zx_compare_10);

            break :block_117 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_116, {}, null, });
        }).@"0" else ((in).candidate).names);

        break :block_118 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .children = (operand_110).children, .fields = operand_111, .first = (operand_110).first, .kind = (operand_110).kind, .label = (operand_110).label, .names = operand_114, .second = (operand_110).second, });
    };

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_109: {
        break :block_109 (try function_28_value(allocator, block_108: {
            const operand_106 = (in).tables;
            const operand_107 = value_2;

            break :block_108 @as((zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e, (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e{ .tables = operand_106, .candidate = operand_107, });
        }));
    };

    if ((value_3).found) {
        return block_105: {
            const operand_102 = ((in).tables).delta;
            const operand_103 = (value_3).id;
            const operand_104 = value_1;

            break :block_105 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_102, .id = operand_103, .diagnostic = operand_104, });
        };
    }

    const value_4: u32 = block_101: {
        const operand_97 = in;
        var state_borrow_98: (zx_abi).zx_type_19 = undefined;
        state_borrow_98 = (zx_abi).zx_type_19{ .children = ((operand_97).candidate).children, .fields = ((operand_97).candidate).fields, .first = ((operand_97).candidate).first, .kind = ((operand_97).candidate).kind, .label = ((operand_97).candidate).label, .names = ((operand_97).candidate).names, .second = ((operand_97).candidate).second, };

        var state_borrow_99: (zx_abi).zx_type_16 = undefined;
        state_borrow_99 = (zx_abi).zx_type_16{ .base = ((operand_97).tables).base, .delta = ((operand_97).tables).delta, };

        var state_borrow_100: (zx_abi).zx_type_109 = undefined;

        state_borrow_100 = (zx_abi).zx_type_109{ .candidate = (((operand_97).candidate).zx_origin orelse (&state_borrow_98)), .tables = (((operand_97).tables).zx_origin orelse (&state_borrow_99)), };

        break :block_101 (try function_32(allocator, ((operand_97).zx_origin orelse (&state_borrow_100))));
    };

    return block_96: {
        const operand_83 = block_92: {
            const operand_91 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_91).* = @as((zx_abi).zx_type_15, block_90: {
                const operand_87 = block_86: {
                    const operand_84 = ((in).tables).delta;
                    const operand_85 = value_2;

                    break :block_86 @as((zx_abi).value_zx_type_111_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b, (zx_abi).value_zx_type_111_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b{ .delta = operand_84, .candidate = operand_85, });
                };

                var state_borrow_88: (zx_abi).zx_type_19 = undefined;

                state_borrow_88 = (zx_abi).zx_type_19{ .children = ((operand_87).candidate).children, .fields = ((operand_87).candidate).fields, .first = ((operand_87).candidate).first, .kind = ((operand_87).candidate).kind, .label = ((operand_87).candidate).label, .names = ((operand_87).candidate).names, .second = ((operand_87).candidate).second, };

                var state_borrow_89: (zx_abi).zx_type_111 = undefined;

                state_borrow_89 = (zx_abi).zx_type_111{ .candidate = (((operand_87).candidate).zx_origin orelse (&state_borrow_88)), .delta = (operand_87).delta, };

                break :block_90 (try function_29_buffered(allocator, ((operand_87).zx_origin orelse (&state_borrow_89)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), }));
            });

            break :block_92 @as(*const (zx_abi).zx_type_15, operand_91);
        };

        const operand_93 = block_94: {
            break :block_94 value_4;
        };

        const operand_95 = value_1;

        break :block_96 @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .delta = operand_83, .id = operand_93, .diagnostic = operand_95, });
    };
}

fn function_39(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_129) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_118 = (try function_38(allocator, block_24: {
        const operand_15 = block_20: {
            const operand_16 = (((in).state).context).base;
            const operand_17 = ((in).state).delta;

            break :block_20 block_19: {
                const operand_18 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_18).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = operand_16, .delta = operand_17, });

                break :block_19 @as(*const (zx_abi).zx_type_16, operand_18);
            };
        };

        const operand_21 = (in).candidate;

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_109));

            (operand_22).* = @as((zx_abi).zx_type_109, (zx_abi).zx_type_109{ .tables = operand_15, .candidate = operand_21, });

            break :block_23 @as(*const (zx_abi).zx_type_109, operand_22);
        };
    }));

    return block_14: {
        const operand_1 = (in).state;
        const operand_2 = (value_1).delta;
        const operand_3 = (value_1).id;

        const operand_4 = block_11: {
            const operand_5 = ((value_1).diagnostic).code;
            const operand_6 = ((value_1).diagnostic).message;
            const operand_7 = @as(u64, 0);
            const operand_8 = @as(u64, 0);

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_9).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_5, .message = operand_6, .start = operand_7, .end = operand_8, });

                break :block_10 @as(*const (zx_abi).zx_type_31, operand_9);
            };
        };

        break :block_14 block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_12).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = operand_2, .diagnostic = operand_4, .frames = (operand_1).frames, .result = operand_3, .scratch = (operand_1).scratch, });

            break :block_13 @as(*const (zx_abi).zx_type_82, operand_12);
        };
    };
}

fn function_39_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = block_43: {
        break :block_43 (try function_38_value(allocator, block_42: {
            const operand_37 = block_40: {
                const operand_38 = (((in).state).context).base;
                const operand_39 = ((in).state).delta;

                break :block_40 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = operand_38, .delta = operand_39, });
            };

            const operand_41 = (in).candidate;

            break :block_42 @as((zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e, (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e{ .tables = operand_37, .candidate = operand_41, });
        }));
    };

    return block_36: {
        const operand_25 = (in).state;
        const operand_26 = (value_1).delta;
        const operand_27 = (value_1).id;

        const operand_28 = block_35: {
            const operand_29 = ((value_1).diagnostic).code;
            const operand_30 = ((value_1).diagnostic).message;
            const operand_31 = @as(u64, 0);
            const operand_32 = @as(u64, 0);

            break :block_35 block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_33).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_29, .message = operand_30, .start = operand_31, .end = operand_32, });

                break :block_34 @as(*const (zx_abi).zx_type_31, operand_33);
            };
        };

        break :block_36 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_25).active, .cache = (operand_25).cache, .context = (operand_25).context, .delta = operand_26, .diagnostic = operand_28, .frames = (operand_25).frames, .result = operand_27, .scratch = (operand_25).scratch, });
    };
}

fn function_39_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = @as((zx_abi).value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, block_62: {
        break :block_62 (try function_38_buffered(allocator, block_61: {
            const operand_56 = block_59: {
                const operand_57 = (((in).state).context).base;
                const operand_58 = ((in).state).delta;

                break :block_59 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = operand_57, .delta = operand_58, });
            };

            const operand_60 = (in).candidate;

            break :block_61 @as((zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e, (zx_abi).value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e{ .tables = operand_56, .candidate = operand_60, });
        }, .{ .lane_0 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_1 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_2 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_3 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_4 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_5 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_6 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_7 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), }));
    });

    return block_55: {
        const operand_44 = (in).state;
        const operand_45 = (value_1).delta;
        const operand_46 = (value_1).id;

        const operand_47 = block_54: {
            const operand_48 = ((value_1).diagnostic).code;
            const operand_49 = ((value_1).diagnostic).message;
            const operand_50 = @as(u64, 0);
            const operand_51 = @as(u64, 0);

            break :block_54 block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_31));

                (operand_52).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_48, .message = operand_49, .start = operand_50, .end = operand_51, });

                break :block_53 @as(*const (zx_abi).zx_type_31, operand_52);
            };
        };

        break :block_55 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_44).active, .cache = (operand_44).cache, .context = (operand_44).context, .delta = operand_45, .diagnostic = operand_47, .frames = (operand_44).frames, .result = operand_46, .scratch = (operand_44).scratch, });
    };
}

fn function_40(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_130) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_60 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return block_17: {
            const operand_15 = (value_1.?).members;

            const operand_16 = ((block_14: {
                const operand_12 = (value_1.?).enumerations;
                const operand_13 = (in).enumeration;

                if ((operand_13 >= (operand_12).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_14 (operand_12)[@intCast(operand_13)];
            }).first + (in).index);

            if ((operand_16 >= (operand_15).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_17 (operand_15)[@intCast(operand_16)];
        };
    }

    const value_2: *const (zx_abi).zx_type_55 = block_11: {
        const operand_9 = (((in).source).indexed).declarations;
        const operand_10 = (in).enumeration;

        if ((operand_10 >= (operand_9).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_11 (operand_9)[@intCast(operand_10)];
    };

    return (try function_11(allocator, block_8: {
        const operand_1 = (((in).source).indexed).bytes;

        const operand_2 = block_5: {
            const operand_3 = (((in).source).indexed).members;
            const operand_4 = ((value_2).first + (in).index);

            if ((operand_4 >= (operand_3).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_5 (operand_3)[@intCast(operand_4)];
        };

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_87));

            (operand_6).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_1, .span = operand_2, });

            break :block_7 @as(*const (zx_abi).zx_type_87, operand_6);
        };
    }));
}

fn function_40_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_130) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).zx_type_60 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return (block_33: {
            const operand_31 = (value_1.?).members;

            const operand_32 = ((block_30: {
                const operand_28 = (value_1.?).enumerations;
                const operand_29 = (in).enumeration;

                if ((operand_29 >= (operand_28).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_30 (operand_28)[@intCast(operand_29)];
            }).first + (in).index);

            if ((operand_32 >= (operand_31).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_33 (operand_31)[@intCast(operand_32)];
        }).*;
    }

    const value_2: (zx_abi).zx_type_55 = (block_27: {
        const operand_25 = (((in).source).indexed).declarations;
        const operand_26 = (in).enumeration;

        if ((operand_26 >= (operand_25).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_27 (operand_25)[@intCast(operand_26)];
    }).*;

    return block_24: {
        const operand_18 = (((in).source).indexed).bytes;

        const operand_22 = block_21: {
            const operand_19 = (((in).source).indexed).members;
            const operand_20 = (((&value_2)).first + (in).index);

            if ((operand_20 >= (operand_19).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_21 (operand_19)[@intCast(operand_20)];
        };

        const operand_23 = (zx_abi).zx_type_87{ .source = operand_18, .span = operand_22, };

        break :block_24 (try function_11_value(allocator, (&operand_23)));
    };
}

fn function_41(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_131) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_62 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if (((in).reference).enumeration) {
        const value_2: u64 = (if ((value_1 != null)) (block_51: {
            const operand_49 = (value_1.?).enumerations;
            const operand_50 = ((in).reference).index;

            if ((operand_50 >= (operand_49).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_51 (operand_49)[@intCast(operand_50)];
        }).count else (block_54: {
            const operand_52 = (((in).source).indexed).declarations;
            const operand_53 = ((in).reference).index;

            if ((operand_53 >= (operand_52).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_54 (operand_52)[@intCast(operand_53)];
        }).count);

        return block_48: {
            const operand_30 = @as((zx_abi).zx_type_59, .Enumeration);

            const operand_31 = block_37: {
                const operand_32 = @as([]const u8, "");
                const operand_33 = @as(u64, 0);
                const operand_34 = @as(u64, 0);

                break :block_37 block_36: {
                    const operand_35 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_35).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_32, .start = operand_33, .end = operand_34, });

                    break :block_36 @as(*const (zx_abi).zx_type_60, operand_35);
                };
            };
            const operand_38 = block_43: {
                const operand_39 = false;
                const operand_40 = @as(u64, 0);

                break :block_43 block_42: {
                    const operand_41 = (try (allocator).create((zx_abi).zx_type_61));

                    (operand_41).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_39, .index = operand_40, });

                    break :block_42 @as(*const (zx_abi).zx_type_61, operand_41);
                };
            };

            const operand_44 = value_2;
            const operand_45 = @as(u64, 0);

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_62));

                (operand_46).* = @as((zx_abi).zx_type_62, (zx_abi).zx_type_62{ .kind = operand_30, .name = operand_31, .child = operand_38, .count = operand_44, .position = operand_45, });

                break :block_47 @as(*const (zx_abi).zx_type_62, operand_46);
            };
        };
    }

    if ((value_1 != null)) {
        return block_29: {
            const operand_27 = (value_1.?).nodes;
            const operand_28 = ((in).reference).index;

            if ((operand_28 >= (operand_27).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_29 (operand_27)[@intCast(operand_28)];
        };
    }

    const value_3: *const (zx_abi).zx_type_41 = block_26: {
        const operand_24 = ((((in).source).indexed).types).nodes;
        const operand_25 = ((in).reference).index;

        if ((operand_25 >= (operand_24).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_26 (operand_24)[@intCast(operand_25)];
    };

    const value_4: (zx_abi).zx_type_59 = block_23: {
        const operand_22 = (value_3).kind;

        break :block_23 (if ((operand_22 == @as((zx_abi).zx_type_39, .Named))) @as((zx_abi).zx_type_59, .Named) else (if ((operand_22 == @as((zx_abi).zx_type_39, .Object))) @as((zx_abi).zx_type_59, .Object) else (if ((operand_22 == @as((zx_abi).zx_type_39, .Optional))) @as((zx_abi).zx_type_59, .Optional) else (if ((operand_22 == @as((zx_abi).zx_type_39, .List))) @as((zx_abi).zx_type_59, .List) else (if ((operand_22 == @as((zx_abi).zx_type_39, .Tuple))) @as((zx_abi).zx_type_59, .Tuple) else @as((zx_abi).zx_type_59, .Application))))));
    };

    return block_21: {
        const operand_1 = value_4;

        const operand_2 = (try function_11(allocator, block_7: {
            const operand_3 = (((in).source).indexed).bytes;
            const operand_4 = (value_3).name;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_5).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_3, .span = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_87, operand_5);
            };
        }));

        const operand_8 = block_13: {
            const operand_9 = false;
            const operand_10 = (value_3).child;

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_11).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_9, .index = operand_10, });

                break :block_12 @as(*const (zx_abi).zx_type_61, operand_11);
            };
        };

        const operand_14 = (value_3).count;

        const operand_15 = block_18: {
            const operand_16 = ((((in).source).indexed).order).heads;
            const operand_17 = ((in).reference).index;

            if ((operand_17 >= (operand_16).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_18 (operand_16)[@intCast(operand_17)];
        };

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_62));

            (operand_19).* = @as((zx_abi).zx_type_62, (zx_abi).zx_type_62{ .kind = operand_1, .name = operand_2, .child = operand_8, .count = operand_14, .position = operand_15, });

            break :block_20 @as(*const (zx_abi).zx_type_62, operand_19);
        };
    };
}

fn function_41_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_131) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).zx_type_62 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if (((in).reference).enumeration) {
        const value_2: u64 = (if ((value_1 != null)) (block_101: {
            const operand_99 = (value_1.?).enumerations;
            const operand_100 = ((in).reference).index;

            if ((operand_100 >= (operand_99).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_101 (operand_99)[@intCast(operand_100)];
        }).count else (block_104: {
            const operand_102 = (((in).source).indexed).declarations;
            const operand_103 = ((in).reference).index;

            if ((operand_103 >= (operand_102).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_104 (operand_102)[@intCast(operand_103)];
        }).count);

        return block_98: {
            const operand_82 = @as((zx_abi).zx_type_59, .Enumeration);

            const operand_83 = block_89: {
                const operand_84 = @as([]const u8, "");
                const operand_85 = @as(u64, 0);
                const operand_86 = @as(u64, 0);

                break :block_89 block_88: {
                    const operand_87 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_87).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_84, .start = operand_85, .end = operand_86, });

                    break :block_88 @as(*const (zx_abi).zx_type_60, operand_87);
                };
            };
            const operand_90 = block_95: {
                const operand_91 = false;
                const operand_92 = @as(u64, 0);

                break :block_95 block_94: {
                    const operand_93 = (try (allocator).create((zx_abi).zx_type_61));

                    (operand_93).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_91, .index = operand_92, });

                    break :block_94 @as(*const (zx_abi).zx_type_61, operand_93);
                };
            };

            const operand_96 = value_2;
            const operand_97 = @as(u64, 0);

            break :block_98 (zx_abi).zx_type_62{ .kind = operand_82, .name = operand_83, .child = operand_90, .count = operand_96, .position = operand_97, };
        };
    }

    if ((value_1 != null)) {
        return (block_81: {
            const operand_79 = (value_1.?).nodes;
            const operand_80 = ((in).reference).index;

            if ((operand_80 >= (operand_79).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_81 (operand_79)[@intCast(operand_80)];
        }).*;
    }

    const value_3: (zx_abi).zx_type_41 = (block_78: {
        const operand_76 = ((((in).source).indexed).types).nodes;
        const operand_77 = ((in).reference).index;

        if ((operand_77 >= (operand_76).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_78 (operand_76)[@intCast(operand_77)];
    }).*;

    const value_4: (zx_abi).zx_type_59 = block_75: {
        const operand_74 = ((&value_3)).kind;

        break :block_75 (if ((operand_74 == @as((zx_abi).zx_type_39, .Named))) @as((zx_abi).zx_type_59, .Named) else (if ((operand_74 == @as((zx_abi).zx_type_39, .Object))) @as((zx_abi).zx_type_59, .Object) else (if ((operand_74 == @as((zx_abi).zx_type_39, .Optional))) @as((zx_abi).zx_type_59, .Optional) else (if ((operand_74 == @as((zx_abi).zx_type_39, .List))) @as((zx_abi).zx_type_59, .List) else (if ((operand_74 == @as((zx_abi).zx_type_39, .Tuple))) @as((zx_abi).zx_type_59, .Tuple) else @as((zx_abi).zx_type_59, .Application))))));
    };

    return block_73: {
        const operand_55 = value_4;

        const operand_56 = (try function_11(allocator, block_61: {
            const operand_57 = (((in).source).indexed).bytes;
            const operand_58 = ((&value_3)).name;

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_59).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_57, .span = operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_87, operand_59);
            };
        }));

        const operand_62 = block_67: {
            const operand_63 = false;
            const operand_64 = ((&value_3)).child;

            break :block_67 block_66: {
                const operand_65 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_65).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_63, .index = operand_64, });

                break :block_66 @as(*const (zx_abi).zx_type_61, operand_65);
            };
        };

        const operand_68 = ((&value_3)).count;

        const operand_69 = block_72: {
            const operand_70 = ((((in).source).indexed).order).heads;
            const operand_71 = ((in).reference).index;

            if ((operand_71 >= (operand_70).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_72 (operand_70)[@intCast(operand_71)];
        };

        break :block_73 (zx_abi).zx_type_62{ .kind = operand_55, .name = operand_56, .child = operand_62, .count = operand_68, .position = operand_69, };
    };
}

fn function_42(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    const value_2: *const (zx_abi).zx_type_62 = (try function_41(allocator, block_92: {
        const operand_88 = ((in).context).source;
        const operand_89 = (value_1).reference;

        break :block_92 block_91: {
            const operand_90 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_90).* = @as((zx_abi).zx_type_131, (zx_abi).zx_type_131{ .source = operand_88, .reference = operand_89, });

            break :block_91 @as(*const (zx_abi).zx_type_131, operand_90);
        };
    }));

    if (((value_2).count == @as(u64, 0))) {
        return (try function_4(allocator, block_87: {
            const operand_81 = in;
            const operand_82 = @as([]const u8, "type_mismatch");
            const operand_83 = @as([]const u8, "an enum must have at least one member");
            const operand_84 = (value_1).declaration;

            break :block_87 block_86: {
                const operand_85 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_85).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_81, .code = operand_82, .message = operand_83, .name = operand_84, });

                break :block_86 @as(*const (zx_abi).zx_type_86, operand_85);
            };
        }));
    }

    const value_3: []const []const u8 = block_80: {
        break :block_80 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_20: *const (zx_abi).zx_type_132 = block_79: {
        var state_32: *const (zx_abi).zx_type_132 = block_41: {
            const operand_33 = ((in).context).source;
            const operand_34 = ((value_1).reference).index;
            const operand_35 = @as(u64, 0);
            const operand_36 = (value_2).count;
            const operand_37 = value_3;
            const operand_38 = (in).diagnostic;

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create((zx_abi).zx_type_132));

                (operand_39).* = @as((zx_abi).zx_type_132, (zx_abi).zx_type_132{ .source = operand_33, .enumeration = operand_34, .index = operand_35, .count = operand_36, .names = operand_37, .diagnostic = operand_38, });

                break :block_40 @as(*const (zx_abi).zx_type_132, operand_39);
            };
        };

        while ((((state_32).index < (state_32).count) and block_44: {
            const operand_42 = ((state_32).diagnostic).message;
            const operand_43 = @as([]const u8, "");

            break :block_44 ((std).mem).eql(u8, operand_42, operand_43);
        })) {
            state_32 = block_77: {
                const value_6: *const (zx_abi).zx_type_60 = (try function_40(allocator, block_76: {
                    const operand_71 = (state_32).source;
                    const operand_72 = (state_32).enumeration;
                    const operand_73 = (state_32).index;

                    break :block_76 block_75: {
                        const operand_74 = (try (allocator).create((zx_abi).zx_type_130));

                        (operand_74).* = @as((zx_abi).zx_type_130, (zx_abi).zx_type_130{ .source = operand_71, .enumeration = operand_72, .index = operand_73, });

                        break :block_75 @as(*const (zx_abi).zx_type_130, operand_74);
                    };
                }));

                const value_19: *const (zx_abi).zx_type_132 = (if (block_48: {
                    const operand_45 = (state_32).names;
                    const operand_46 = (value_6).text;
                    const operand_47 = (zx_abi).zx_type_94{ .names = operand_45, .name = operand_46, };

                    break :block_48 (try function_15(allocator, (&operand_47)));
                }) block_59: {
                    const value_7: *const (zx_abi).zx_type_132 = state_32;
                    _ = (value_7).diagnostic;

                    const value_9: *const (zx_abi).zx_type_31 = block_58: {
                        const operand_52 = @as([]const u8, "name");
                        const operand_53 = @as([]const u8, "duplicate enum member");
                        const operand_54 = (value_6).start;
                        const operand_55 = (value_6).end;

                        break :block_58 block_57: {
                            const operand_56 = (try (allocator).create((zx_abi).zx_type_31));

                            (operand_56).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_52, .message = operand_53, .start = operand_54, .end = operand_55, });

                            break :block_57 @as(*const (zx_abi).zx_type_31, operand_56);
                        };
                    };
                    const value_10: *const (zx_abi).zx_type_132 = block_51: {
                        break :block_51 block_50: {
                            const operand_49 = (try (allocator).create((zx_abi).zx_type_132));

                            (operand_49).* = @as((zx_abi).zx_type_132, (zx_abi).zx_type_132{ .count = (value_7).count, .diagnostic = value_9, .enumeration = (value_7).enumeration, .index = (value_7).index, .names = (value_7).names, .source = (value_7).source, });

                            break :block_50 @as(*const (zx_abi).zx_type_132, operand_49);
                        };
                    };

                    break :block_59 value_10;
                } else block_70: {
                    const value_11: *const (zx_abi).zx_type_132 = state_32;
                    _ = (value_11).names;

                    const value_13: []const []const u8 = (block_69: {
                        const operand_66 = (state_32).names;
                        const operand_67 = (value_6).text;
                        const operand_68 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_66).len, 1))));

                        @memcpy((operand_68)[0..(operand_66).len], operand_66);

                        (operand_68)[(operand_66).len] = operand_67;

                        break :block_69 @as((zx_abi).zx_type_98, .{ operand_68, {}, });
                    }).@"0";

                    const value_14: *const (zx_abi).zx_type_132 = block_65: {
                        break :block_65 block_64: {
                            const operand_63 = (try (allocator).create((zx_abi).zx_type_132));

                            (operand_63).* = @as((zx_abi).zx_type_132, (zx_abi).zx_type_132{ .count = (value_11).count, .diagnostic = (value_11).diagnostic, .enumeration = (value_11).enumeration, .index = (value_11).index, .names = value_13, .source = (value_11).source, });

                            break :block_64 @as(*const (zx_abi).zx_type_132, operand_63);
                        };
                    };
                    const value_15: *const (zx_abi).zx_type_132 = value_14;
                    const value_16: u64 = (value_15).index;
                    const value_17: u64 = @as(u64, 1);

                    const value_18: *const (zx_abi).zx_type_132 = block_62: {
                        break :block_62 block_61: {
                            const operand_60 = (try (allocator).create((zx_abi).zx_type_132));

                            (operand_60).* = @as((zx_abi).zx_type_132, (zx_abi).zx_type_132{ .count = (value_15).count, .diagnostic = (value_15).diagnostic, .enumeration = (value_15).enumeration, .index = (value_16 + value_17), .names = (value_15).names, .source = (value_15).source, });

                            break :block_61 @as(*const (zx_abi).zx_type_132, operand_60);
                        };
                    };

                    break :block_70 value_18;
                });

                break :block_77 value_19;
            };
        }

        break :block_79 state_32;
    };

    if ((!block_26: {
        const operand_24 = ((value_20).diagnostic).message;
        const operand_25 = @as([]const u8, "");

        break :block_26 ((std).mem).eql(u8, operand_24, operand_25);
    })) {
        return block_31: {
            const operand_27 = in;
            const operand_28 = (value_20).diagnostic;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_29).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_27).active, .cache = (operand_27).cache, .context = (operand_27).context, .delta = (operand_27).delta, .diagnostic = operand_28, .frames = (operand_27).frames, .result = (operand_27).result, .scratch = (operand_27).scratch, });

                break :block_30 @as(*const (zx_abi).zx_type_82, operand_29);
            };
        };
    }

    return (try function_39(allocator, block_23: {
        const operand_1 = in;

        const operand_2 = block_20: {
            const operand_3 = @as((zx_abi).zx_type_11, .Enumeration);
            const operand_4 = @as(u32, 0);
            const operand_5 = @as(u32, 0);
            const operand_6 = ((value_1).declaration).text;

            const operand_7 = block_8: {
                break :block_8 (try (allocator).dupe(u32, (&[_]u32{})));
            };
            const operand_9 = block_16: {
                const operand_10 = block_11: {
                    break :block_11 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };
                const operand_12 = block_13: {
                    break :block_13 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_16 block_15: {
                    const operand_14 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_14).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_10, .types = operand_12, });

                    break :block_15 @as(*const (zx_abi).zx_type_18, operand_14);
                };
            };

            const operand_17 = (value_20).names;

            break :block_20 block_19: {
                const operand_18 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_18).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kind = operand_3, .first = operand_4, .second = operand_5, .label = operand_6, .children = operand_7, .fields = operand_9, .names = operand_17, });

                break :block_19 @as(*const (zx_abi).zx_type_19, operand_18);
            };
        };

        break :block_23 block_22: {
            const operand_21 = (try (allocator).create((zx_abi).zx_type_129));

            (operand_21).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .state = operand_1, .candidate = operand_2, });

            break :block_22 @as(*const (zx_abi).zx_type_129, operand_21);
        };
    }));
}

fn function_42_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_193: {
        const operand_192 = (in).frames;

        break :block_193 (try function_19(allocator, operand_192));
    };

    const value_2: *const (zx_abi).zx_type_62 = block_191: {
        const operand_188 = block_187: {
            const operand_184 = ((in).context).source;

            const operand_185 = (block_186: {
                break :block_186 value_1;
            }).reference;

            break :block_187 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_184, .reference = operand_185, });
        };

        break :block_191 (try function_41(allocator, (if (((operand_188).zx_origin != null)) (operand_188).zx_origin.? else block_190: {
            const operand_189 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_189).* = (zx_abi).zx_type_131{ .reference = (operand_188).reference, .source = (operand_188).source, };

            break :block_190 @as(*const (zx_abi).zx_type_131, operand_189);
        })));
    };

    if (((block_176: {
        break :block_176 value_2;
    }).count == @as(u64, 0))) {
        return block_183: {
            break :block_183 (try function_4_value(allocator, block_182: {
                const operand_177 = in;
                const operand_178 = @as([]const u8, "type_mismatch");
                const operand_179 = @as([]const u8, "an enum must have at least one member");

                const operand_180 = (block_181: {
                    break :block_181 value_1;
                }).declaration;

                break :block_182 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_177, .code = operand_178, .message = operand_179, .name = operand_180, });
            }));
        };
    }

    const value_3: []const []const u8 = block_175: {
        break :block_175 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_20: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_174: {
        const operand_131 = block_130: {
            const operand_121 = ((in).context).source;

            const operand_122 = ((block_123: {
                break :block_123 value_1;
            }).reference).index;

            const operand_124 = @as(u64, 0);

            const operand_125 = (block_126: {
                break :block_126 value_2;
            }).count;

            const operand_127 = block_128: {
                break :block_128 value_3;
            };

            const operand_129 = (in).diagnostic;

            break :block_130 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .source = operand_121, .enumeration = operand_122, .index = operand_124, .count = operand_125, .names = operand_127, .diagnostic = operand_129, });
        };

        var state_120: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_131;
        var state_changed_132 = false;

        while ((((state_120).index < (state_120).count) and block_135: {
            const operand_133 = ((state_120).diagnostic).message;
            const operand_134 = @as([]const u8, "");

            break :block_135 ((std).mem).eql(u8, operand_133, operand_134);
        })) {
            state_120 = block_172: {
                const value_6: *const (zx_abi).zx_type_60 = block_171: {
                    const operand_168 = block_167: {
                        const operand_164 = (state_120).source;
                        const operand_165 = (state_120).enumeration;
                        const operand_166 = (state_120).index;

                        break :block_167 @as((zx_abi).value_zx_type_130_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_130_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_164, .enumeration = operand_165, .index = operand_166, });
                    };

                    break :block_171 (try function_40(allocator, (if (((operand_168).zx_origin != null)) (operand_168).zx_origin.? else block_170: {
                        const operand_169 = (try (allocator).create((zx_abi).zx_type_130));

                        (operand_169).* = (zx_abi).zx_type_130{ .enumeration = (operand_168).enumeration, .index = (operand_168).index, .source = (operand_168).source, };

                        break :block_170 @as(*const (zx_abi).zx_type_130, operand_169);
                    })));
                };
                const value_19: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_140: {
                    const operand_136 = (state_120).names;

                    const operand_138 = (block_137: {
                        break :block_137 value_6;
                    }).text;

                    const operand_139 = (zx_abi).zx_type_94{ .names = operand_136, .name = operand_138, };

                    break :block_140 (try function_15(allocator, (&operand_139)));
                }) block_152: {
                    const value_7: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_120;

                    _ = (value_7).diagnostic;

                    const value_9: *const (zx_abi).zx_type_31 = block_151: {
                        const operand_143 = @as([]const u8, "name");
                        const operand_144 = @as([]const u8, "duplicate enum member");
                        const operand_145 = (block_146: {
                            break :block_146 value_6;
                        }).start;

                        const operand_147 = (block_148: {
                            break :block_148 value_6;
                        }).end;

                        break :block_151 block_150: {
                            const operand_149 = (try (allocator).create((zx_abi).zx_type_31));

                            (operand_149).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_143, .message = operand_144, .start = operand_145, .end = operand_147, });

                            break :block_150 @as(*const (zx_abi).zx_type_31, operand_149);
                        };
                    };

                    const value_10: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_142: {
                        break :block_142 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_7).count, .diagnostic = block_141: {
                            break :block_141 value_9;
                        }, .enumeration = (value_7).enumeration, .index = (value_7).index, .names = (value_7).names, .source = (value_7).source, });
                    };

                    break :block_152 value_10;
                } else block_163: {
                    const value_11: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_120;

                    _ = (value_11).names;

                    const value_13: []const []const u8 = (block_162: {
                        const operand_158 = (state_120).names;

                        const operand_160 = (block_159: {
                            break :block_159 value_6;
                        }).text;

                        const operand_161 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_158).len, 1))));

                        @memcpy((operand_161)[0..(operand_158).len], operand_158);

                        (operand_161)[(operand_158).len] = operand_160;

                        break :block_162 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_161, {}, null, });
                    }).@"0";

                    const value_14: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_157: {
                        break :block_157 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_11).count, .diagnostic = (value_11).diagnostic, .enumeration = (value_11).enumeration, .index = (value_11).index, .names = block_156: {
                            break :block_156 value_13;
                        }, .source = (value_11).source, });
                    };

                    const value_15: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_14;
                    const value_16: u64 = (value_15).index;
                    const value_17: u64 = @as(u64, 1);

                    const value_18: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_155: {
                        break :block_155 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_15).count, .diagnostic = (value_15).diagnostic, .enumeration = (value_15).enumeration, .index = (block_153: {
                            break :block_153 value_16;
                        } + block_154: {
                            break :block_154 value_17;
                        }), .names = (value_15).names, .source = (value_15).source, });
                    };

                    break :block_163 value_18;
                });

                break :block_172 value_19;
            };

            state_changed_132 = true;
        }

        break :block_174 (if (state_changed_132) state_120 else operand_131);
    };

    if ((!block_116: {
        const operand_114 = ((value_20).diagnostic).message;
        const operand_115 = @as([]const u8, "");

        break :block_116 ((std).mem).eql(u8, operand_114, operand_115);
    })) {
        return block_119: {
            const operand_117 = in;
            const operand_118 = (value_20).diagnostic;

            break :block_119 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_117).active, .cache = (operand_117).cache, .context = (operand_117).context, .delta = (operand_117).delta, .diagnostic = operand_118, .frames = (operand_117).frames, .result = (operand_117).result, .scratch = (operand_117).scratch, });
        };
    }

    return block_113: {
        break :block_113 (try function_39_value(allocator, block_112: {
            const operand_93 = in;

            const operand_94 = block_111: {
                const operand_95 = @as((zx_abi).zx_type_11, .Enumeration);
                const operand_96 = @as(u32, 0);
                const operand_97 = @as(u32, 0);

                const operand_98 = ((block_99: {
                    break :block_99 value_1;
                }).declaration).text;

                const operand_100 = block_101: {
                    break :block_101 (try (allocator).dupe(u32, (&[_]u32{})));
                };
                const operand_102 = block_109: {
                    const operand_103 = block_104: {
                        break :block_104 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };
                    const operand_105 = block_106: {
                        break :block_106 (try (allocator).dupe(u32, (&[_]u32{})));
                    };

                    break :block_109 block_108: {
                        const operand_107 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_107).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_103, .types = operand_105, });

                        break :block_108 @as(*const (zx_abi).zx_type_18, operand_107);
                    };
                };

                const operand_110 = (value_20).names;

                break :block_111 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_95, .first = operand_96, .second = operand_97, .label = operand_98, .children = operand_100, .fields = operand_102, .names = operand_110, });
            };

            break :block_112 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_93, .candidate = operand_94, });
        }));
    };
}

fn function_42_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_294: {
        const operand_293 = (in).frames;

        break :block_294 (try function_19(allocator, operand_293));
    };

    const value_2: *const (zx_abi).zx_type_62 = block_292: {
        const operand_289 = block_288: {
            const operand_285 = ((in).context).source;

            const operand_286 = (block_287: {
                break :block_287 value_1;
            }).reference;

            break :block_288 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_285, .reference = operand_286, });
        };

        break :block_292 (try function_41(allocator, (if (((operand_289).zx_origin != null)) (operand_289).zx_origin.? else block_291: {
            const operand_290 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_290).* = (zx_abi).zx_type_131{ .reference = (operand_289).reference, .source = (operand_289).source, };

            break :block_291 @as(*const (zx_abi).zx_type_131, operand_290);
        })));
    };

    if (((block_277: {
        break :block_277 value_2;
    }).count == @as(u64, 0))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_284: {
            break :block_284 (try function_4_buffered(allocator, block_283: {
                const operand_278 = in;
                const operand_279 = @as([]const u8, "type_mismatch");
                const operand_280 = @as([]const u8, "an enum must have at least one member");

                const operand_281 = (block_282: {
                    break :block_282 value_1;
                }).declaration;

                break :block_283 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_278, .code = operand_279, .message = operand_280, .name = operand_281, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_3: []const []const u8 = block_276: {
        break :block_276 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
    };

    const value_20: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_275: {
        const operand_232 = block_231: {
            const operand_222 = ((in).context).source;

            const operand_223 = ((block_224: {
                break :block_224 value_1;
            }).reference).index;

            const operand_225 = @as(u64, 0);

            const operand_226 = (block_227: {
                break :block_227 value_2;
            }).count;

            const operand_228 = block_229: {
                break :block_229 value_3;
            };

            const operand_230 = (in).diagnostic;

            break :block_231 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .source = operand_222, .enumeration = operand_223, .index = operand_225, .count = operand_226, .names = operand_228, .diagnostic = operand_230, });
        };

        var state_221: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = operand_232;
        var state_changed_233 = false;

        while ((((state_221).index < (state_221).count) and block_236: {
            const operand_234 = ((state_221).diagnostic).message;
            const operand_235 = @as([]const u8, "");

            break :block_236 ((std).mem).eql(u8, operand_234, operand_235);
        })) {
            state_221 = block_273: {
                const value_6: *const (zx_abi).zx_type_60 = block_272: {
                    const operand_269 = block_268: {
                        const operand_265 = (state_221).source;
                        const operand_266 = (state_221).enumeration;
                        const operand_267 = (state_221).index;

                        break :block_268 @as((zx_abi).value_zx_type_130_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_130_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_265, .enumeration = operand_266, .index = operand_267, });
                    };

                    break :block_272 (try function_40(allocator, (if (((operand_269).zx_origin != null)) (operand_269).zx_origin.? else block_271: {
                        const operand_270 = (try (allocator).create((zx_abi).zx_type_130));

                        (operand_270).* = (zx_abi).zx_type_130{ .enumeration = (operand_269).enumeration, .index = (operand_269).index, .source = (operand_269).source, };

                        break :block_271 @as(*const (zx_abi).zx_type_130, operand_270);
                    })));
                };
                const value_19: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = (if (block_241: {
                    const operand_237 = (state_221).names;

                    const operand_239 = (block_238: {
                        break :block_238 value_6;
                    }).text;

                    const operand_240 = (zx_abi).zx_type_94{ .names = operand_237, .name = operand_239, };

                    break :block_241 (try function_15(allocator, (&operand_240)));
                }) block_253: {
                    const value_7: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_221;

                    _ = (value_7).diagnostic;

                    const value_9: *const (zx_abi).zx_type_31 = block_252: {
                        const operand_244 = @as([]const u8, "name");
                        const operand_245 = @as([]const u8, "duplicate enum member");
                        const operand_246 = (block_247: {
                            break :block_247 value_6;
                        }).start;

                        const operand_248 = (block_249: {
                            break :block_249 value_6;
                        }).end;

                        break :block_252 block_251: {
                            const operand_250 = (try (allocator).create((zx_abi).zx_type_31));

                            (operand_250).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .code = operand_244, .message = operand_245, .start = operand_246, .end = operand_248, });

                            break :block_251 @as(*const (zx_abi).zx_type_31, operand_250);
                        };
                    };

                    const value_10: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_243: {
                        break :block_243 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_7).count, .diagnostic = block_242: {
                            break :block_242 value_9;
                        }, .enumeration = (value_7).enumeration, .index = (value_7).index, .names = (value_7).names, .source = (value_7).source, });
                    };

                    break :block_253 value_10;
                } else block_264: {
                    const value_11: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = state_221;

                    _ = (value_11).names;

                    const value_13: []const []const u8 = (block_263: {
                        const operand_259 = (state_221).names;

                        const operand_261 = (block_260: {
                            break :block_260 value_6;
                        }).text;

                        const operand_262 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_259).len, 1))));

                        @memcpy((operand_262)[0..(operand_259).len], operand_259);

                        (operand_262)[(operand_259).len] = operand_261;

                        break :block_263 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_262, {}, null, });
                    }).@"0";

                    const value_14: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_258: {
                        break :block_258 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_11).count, .diagnostic = (value_11).diagnostic, .enumeration = (value_11).enumeration, .index = (value_11).index, .names = block_257: {
                            break :block_257 value_13;
                        }, .source = (value_11).source, });
                    };

                    const value_15: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = value_14;
                    const value_16: u64 = (value_15).index;
                    const value_17: u64 = @as(u64, 1);

                    const value_18: (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = block_256: {
                        break :block_256 @as((zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .count = (value_15).count, .diagnostic = (value_15).diagnostic, .enumeration = (value_15).enumeration, .index = (block_254: {
                            break :block_254 value_16;
                        } + block_255: {
                            break :block_255 value_17;
                        }), .names = (value_15).names, .source = (value_15).source, });
                    };

                    break :block_264 value_18;
                });

                break :block_273 value_19;
            };

            state_changed_233 = true;
        }

        break :block_275 (if (state_changed_233) state_221 else operand_232);
    };

    if ((!block_217: {
        const operand_215 = ((value_20).diagnostic).message;
        const operand_216 = @as([]const u8, "");

        break :block_217 ((std).mem).eql(u8, operand_215, operand_216);
    })) {
        return block_220: {
            const operand_218 = in;
            const operand_219 = (value_20).diagnostic;

            break :block_220 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_218).active, .cache = (operand_218).cache, .context = (operand_218).context, .delta = (operand_218).delta, .diagnostic = operand_219, .frames = (operand_218).frames, .result = (operand_218).result, .scratch = (operand_218).scratch, });
        };
    }

    return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_214: {
        break :block_214 (try function_39_buffered(allocator, block_213: {
            const operand_194 = in;

            const operand_195 = block_212: {
                const operand_196 = @as((zx_abi).zx_type_11, .Enumeration);
                const operand_197 = @as(u32, 0);
                const operand_198 = @as(u32, 0);

                const operand_199 = ((block_200: {
                    break :block_200 value_1;
                }).declaration).text;

                const operand_201 = block_202: {
                    break :block_202 (try (allocator).dupe(u32, (&[_]u32{})));
                };
                const operand_203 = block_210: {
                    const operand_204 = block_205: {
                        break :block_205 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };
                    const operand_206 = block_207: {
                        break :block_207 (try (allocator).dupe(u32, (&[_]u32{})));
                    };

                    break :block_210 block_209: {
                        const operand_208 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_208).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_204, .types = operand_206, });

                        break :block_209 @as(*const (zx_abi).zx_type_18, operand_208);
                    };
                };

                const operand_211 = (value_20).names;

                break :block_212 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_196, .first = operand_197, .second = operand_198, .label = operand_199, .children = operand_201, .fields = operand_203, .names = operand_211, });
            };

            break :block_213 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_194, .candidate = operand_195, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });
}

fn function_43(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_133) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_20 {
    @setRuntimeSafety(true);

    const value_1: u32 = @as(u32, 0);

    const value_16: *const (zx_abi).zx_type_134 = block_37: {
        const operand_15 = block_14: {
            const operand_7 = (in).cache;
            const operand_8 = (in).name;
            const operand_9 = @as(u64, 0);
            const operand_10 = false;
            const operand_11 = value_1;

            break :block_14 block_13: {
                const operand_12 = (try (allocator).create((zx_abi).zx_type_134));

                (operand_12).* = @as((zx_abi).zx_type_134, (zx_abi).zx_type_134{ .cache = operand_7, .name = operand_8, .index = operand_9, .found = operand_10, .id = operand_11, });

                break :block_13 @as(*const (zx_abi).zx_type_134, operand_12);
            };
        };
        const state_type_17 = struct {
            ids: []const u32,
            names: []const []const u8,
        };
        const state_type_18 = struct {
            cache: state_type_17,
            found: bool,
            id: u32,
            index: u64,
            name: []const u8,
        };

        var state_6: state_type_18 = state_type_18{ .cache = state_type_17{ .ids = ((operand_15).cache).ids, .names = ((operand_15).cache).names, }, .found = (operand_15).found, .id = (operand_15).id, .index = (operand_15).index, .name = (operand_15).name, };
        var state_changed_16 = false;

        while (((!(state_6).found) and ((state_6).index < @as(u64, (((state_6).cache).names).len)))) {
            state_6 = block_31: {
                const value_4: state_type_18 = state_6;
                _ = (value_4).found;

                const value_6: bool = block_30: {
                    const operand_28 = block_27: {
                        const operand_25 = ((state_6).cache).names;
                        const operand_26 = (state_6).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };

                    const operand_29 = (state_6).name;

                    break :block_30 ((std).mem).eql(u8, operand_28, operand_29);
                };
                const value_7: state_type_18 = block_24: {
                    break :block_24 state_type_18{ .cache = (value_4).cache, .found = value_6, .id = (value_4).id, .index = (value_4).index, .name = (value_4).name, };
                };
                const value_8: state_type_18 = value_7;

                _ = (value_8).id;

                const value_10: u32 = block_23: {
                    const operand_21 = ((value_7).cache).ids;
                    const operand_22 = (value_7).index;

                    if ((operand_22 >= (operand_21).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_23 (operand_21)[@intCast(operand_22)];
                };
                const value_11: state_type_18 = block_20: {
                    break :block_20 state_type_18{ .cache = (value_8).cache, .found = (value_8).found, .id = value_10, .index = (value_8).index, .name = (value_8).name, };
                };
                const value_12: state_type_18 = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: state_type_18 = block_19: {
                    break :block_19 state_type_18{ .cache = (value_12).cache, .found = (value_12).found, .id = (value_12).id, .index = (value_13 + value_14), .name = (value_12).name, };
                };

                break :block_31 value_15;
            };

            state_changed_16 = true;
        }

        break :block_37 (if (state_changed_16) block_36: {
            const operand_35 = (try (allocator).create((zx_abi).zx_type_134));

            (operand_35).* = @as((zx_abi).zx_type_134, (zx_abi).zx_type_134{ .cache = block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_33).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = ((state_6).cache).ids, .names = ((state_6).cache).names, });

                break :block_34 @as(*const (zx_abi).zx_type_78, operand_33);
            }, .found = (state_6).found, .id = (state_6).id, .index = (state_6).index, .name = (state_6).name, });

            break :block_36 @as(*const (zx_abi).zx_type_134, operand_35);
        } else operand_15);
    };

    return block_5: {
        const operand_1 = (value_16).found;
        const operand_2 = (value_16).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_3).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .found = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_20, operand_3);
        };
    };
}

fn function_43_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u32 = @as(u32, 0);

    const value_16: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_69: {
        const operand_49 = block_48: {
            const operand_42 = (in).cache;
            const operand_43 = (in).name;
            const operand_44 = @as(u64, 0);
            const operand_45 = false;

            const operand_46 = block_47: {
                break :block_47 value_1;
            };

            break :block_48 @as((zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .cache = operand_42, .name = operand_43, .index = operand_44, .found = operand_45, .id = operand_46, });
        };

        var state_41: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_49;
        var state_changed_50 = false;

        while (((!(state_41).found) and ((state_41).index < @as(u64, (((state_41).cache).names).len)))) {
            state_41 = block_67: {
                const value_4: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_41;

                _ = (value_4).found;

                const value_6: bool = block_66: {
                    const operand_64 = block_63: {
                        const operand_61 = ((state_41).cache).names;
                        const operand_62 = (state_41).index;

                        if ((operand_62 >= (operand_61).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_63 (operand_61)[@intCast(operand_62)];
                    };

                    const operand_65 = (state_41).name;

                    break :block_66 ((std).mem).eql(u8, operand_64, operand_65);
                };

                const value_7: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_60: {
                    break :block_60 @as((zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .cache = (value_4).cache, .found = block_59: {
                        break :block_59 value_6;
                    }, .id = (value_4).id, .index = (value_4).index, .name = (value_4).name, });
                };
                const value_8: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_7;

                _ = (value_8).id;

                const value_10: u32 = block_58: {
                    const operand_56 = ((value_7).cache).ids;
                    const operand_57 = (value_7).index;

                    if ((operand_57 >= (operand_56).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_58 (operand_56)[@intCast(operand_57)];
                };

                const value_11: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_55: {
                    break :block_55 @as((zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .cache = (value_8).cache, .found = (value_8).found, .id = block_54: {
                        break :block_54 value_10;
                    }, .index = (value_8).index, .name = (value_8).name, });
                };

                const value_12: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_11;
                const value_13: u64 = (value_12).index;
                const value_14: u64 = @as(u64, 1);

                const value_15: (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_53: {
                    break :block_53 @as((zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .cache = (value_12).cache, .found = (value_12).found, .id = (value_12).id, .index = (block_51: {
                        break :block_51 value_13;
                    } + block_52: {
                        break :block_52 value_14;
                    }), .name = (value_12).name, });
                };

                break :block_67 value_15;
            };

            state_changed_50 = true;
        }

        break :block_69 (if (state_changed_50) state_41 else operand_49);
    };

    return block_40: {
        const operand_38 = (value_16).found;
        const operand_39 = (value_16).id;

        break :block_40 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_38, .id = operand_39, });
    };
}

fn function_44(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_135) error{ OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    return block_11: {
        const operand_1 = (in).state;

        const operand_2 = (block_8: {
            const operand_5 = (block_4: {
                const operand_3 = ((in).state).frames;

                break :block_4 @as((zx_abi).zx_type_103, (if (((operand_3).len == 0)) .{ operand_3, null, } else .{ (operand_3)[0..((operand_3).len - 1)], (operand_3)[((operand_3).len - 1)], }));
            }).@"0";

            const operand_6 = (in).frame;
            const operand_7 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_5).len, 1))));

            @memcpy((operand_7)[0..(operand_5).len], operand_5);

            (operand_7)[(operand_5).len] = operand_6;

            break :block_8 @as((zx_abi).zx_type_136, .{ operand_7, {}, });
        }).@"0";

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_9).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_2, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_10 @as(*const (zx_abi).zx_type_82, operand_9);
        };
    };
}

fn function_44_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77) error{ OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_20: {
        const operand_12 = (in).state;

        const operand_13 = (block_19: {
            const operand_16 = (block_15: {
                const operand_14 = ((in).state).frames;

                break :block_15 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_14).len == 0)) .{ operand_14, null, null, } else .{ (operand_14)[0..((operand_14).len - 1)], (operand_14)[((operand_14).len - 1)], null, }));
            }).@"0";

            const operand_17 = (in).frame;
            const operand_18 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_16).len, 1))));

            @memcpy((operand_18)[0..(operand_16).len], operand_16);

            (operand_18)[(operand_16).len] = operand_17;

            break :block_19 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_18, {}, null, });
        }).@"0";

        break :block_20 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_12).active, .cache = (operand_12).cache, .context = (operand_12).context, .delta = (operand_12).delta, .diagnostic = (operand_12).diagnostic, .frames = operand_13, .result = (operand_12).result, .scratch = (operand_12).scratch, });
    };
}

fn function_44_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_34: {
        const operand_21 = (in).state;

        const operand_22 = @as([]const *const (zx_abi).zx_type_80, (if (((buffers).lane_33 != null)) block_27: {
            const operand_25 = (block_24: {
                const operand_23 = ((in).state).frames;

                break :block_24 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_23).len == 0)) .{ operand_23, null, null, } else .{ (operand_23)[0..((operand_23).len - 1)], (operand_23)[((operand_23).len - 1)], null, }));
            }).@"0";

            const operand_26 = (in).frame;

            _ = (try ((std).math).add(usize, (operand_25).len, 1));

            if ((!(((buffers).lane_33.?).started).*)) {
                (try ((((buffers).lane_33.?).buffer).*).appendSlice(allocator, operand_25));
                (((buffers).lane_33.?).started).* = true;
            } else {
                (((((buffers).lane_33.?).buffer).*).items).len = (operand_25).len;
            }

            (try ((((buffers).lane_33.?).buffer).*).append(allocator, operand_26));

            break :block_27 ((((buffers).lane_33.?).buffer).*).items;
        } else (block_33: {
            const operand_30 = (block_29: {
                const operand_28 = ((in).state).frames;

                break :block_29 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_28).len == 0)) .{ operand_28, null, null, } else .{ (operand_28)[0..((operand_28).len - 1)], (operand_28)[((operand_28).len - 1)], null, }));
            }).@"0";

            const operand_31 = (in).frame;
            const operand_32 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_30).len, 1))));

            @memcpy((operand_32)[0..(operand_30).len], operand_30);

            (operand_32)[(operand_30).len] = operand_31;

            break :block_33 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_32, {}, null, });
        }).@"0"));

        break :block_34 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_21).active, .cache = (operand_21).cache, .context = (operand_21).context, .delta = (operand_21).delta, .diagnostic = (operand_21).diagnostic, .frames = operand_22, .result = (operand_21).result, .scratch = (operand_21).scratch, });
    };
}

fn function_45(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));
    const value_2: u64 = (try function_3(allocator, ((value_1).name).text));

    if ((value_2 != @as(u64, 0))) {
        return block_153: {
            const operand_146 = in;
            const operand_147 = (try function_22(allocator, (value_2 - @as(u64, 1))));

            const operand_148 = (block_150: {
                const operand_149 = (in).frames;

                break :block_150 @as((zx_abi).zx_type_103, (if (((operand_149).len == 0)) .{ operand_149, null, } else .{ (operand_149)[0..((operand_149).len - 1)], (operand_149)[((operand_149).len - 1)], }));
            }).@"0";

            break :block_153 block_152: {
                const operand_151 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_151).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_146).active, .cache = (operand_146).cache, .context = (operand_146).context, .delta = (operand_146).delta, .diagnostic = (operand_146).diagnostic, .frames = operand_148, .result = operand_147, .scratch = (operand_146).scratch, });

                break :block_152 @as(*const (zx_abi).zx_type_82, operand_151);
            };
        };
    }

    const value_3: *const (zx_abi).zx_type_20 = (try function_43(allocator, block_145: {
        const operand_141 = (in).cache;
        const operand_142 = ((value_1).name).text;

        break :block_145 block_144: {
            const operand_143 = (try (allocator).create((zx_abi).zx_type_133));

            (operand_143).* = @as((zx_abi).zx_type_133, (zx_abi).zx_type_133{ .cache = operand_141, .name = operand_142, });

            break :block_144 @as(*const (zx_abi).zx_type_133, operand_143);
        };
    }));

    const value_4: *const (zx_abi).zx_type_20 = (if ((value_3).found) value_3 else (try function_43(allocator, block_140: {
        const operand_136 = ((in).context).resolved;
        const operand_137 = ((value_1).name).text;

        break :block_140 block_139: {
            const operand_138 = (try (allocator).create((zx_abi).zx_type_133));

            (operand_138).* = @as((zx_abi).zx_type_133, (zx_abi).zx_type_133{ .cache = operand_136, .name = operand_137, });

            break :block_139 @as(*const (zx_abi).zx_type_133, operand_138);
        };
    })));

    if ((value_4).found) {
        return block_135: {
            const operand_128 = in;
            const operand_129 = (value_4).id;

            const operand_130 = (block_132: {
                const operand_131 = (in).frames;

                break :block_132 @as((zx_abi).zx_type_103, (if (((operand_131).len == 0)) .{ operand_131, null, } else .{ (operand_131)[0..((operand_131).len - 1)], (operand_131)[((operand_131).len - 1)], }));
            }).@"0";

            break :block_135 block_134: {
                const operand_133 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_133).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_128).active, .cache = (operand_128).cache, .context = (operand_128).context, .delta = (operand_128).delta, .diagnostic = (operand_128).diagnostic, .frames = operand_130, .result = operand_129, .scratch = (operand_128).scratch, });

                break :block_134 @as(*const (zx_abi).zx_type_82, operand_133);
            };
        };
    }

    const value_5: *const (zx_abi).zx_type_20 = (try function_43(allocator, block_127: {
        const operand_123 = ((in).context).aliases;
        const operand_124 = ((value_1).name).text;

        break :block_127 block_126: {
            const operand_125 = (try (allocator).create((zx_abi).zx_type_133));

            (operand_125).* = @as((zx_abi).zx_type_133, (zx_abi).zx_type_133{ .cache = operand_123, .name = operand_124, });

            break :block_126 @as(*const (zx_abi).zx_type_133, operand_125);
        };
    }));

    if ((value_5).found) {
        return block_122: {
            const operand_115 = in;
            const operand_116 = (value_5).id;

            const operand_117 = (block_119: {
                const operand_118 = (in).frames;

                break :block_119 @as((zx_abi).zx_type_103, (if (((operand_118).len == 0)) .{ operand_118, null, } else .{ (operand_118)[0..((operand_118).len - 1)], (operand_118)[((operand_118).len - 1)], }));
            }).@"0";

            break :block_122 block_121: {
                const operand_120 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_120).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_115).active, .cache = (operand_115).cache, .context = (operand_115).context, .delta = (operand_115).delta, .diagnostic = (operand_115).diagnostic, .frames = operand_117, .result = operand_116, .scratch = (operand_115).scratch, });

                break :block_121 @as(*const (zx_abi).zx_type_82, operand_120);
            };
        };
    }

    if ((block_103: {
        const operand_100 = (in).active;
        const operand_101 = ((value_1).name).text;
        const operand_102 = (zx_abi).zx_type_94{ .names = operand_100, .name = operand_101, };

        break :block_103 (try function_15(allocator, (&operand_102)));
    } or block_107: {
        const operand_104 = ((in).context).visiting;
        const operand_105 = ((value_1).name).text;
        const operand_106 = (zx_abi).zx_type_94{ .names = operand_104, .name = operand_105, };

        break :block_107 (try function_15(allocator, (&operand_106)));
    })) {
        return (try function_4(allocator, block_114: {
            const operand_108 = in;
            const operand_109 = @as([]const u8, "type_mismatch");
            const operand_110 = @as([]const u8, "recursive type aliases are not supported");
            const operand_111 = (value_1).name;

            break :block_114 block_113: {
                const operand_112 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_112).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_108, .code = operand_109, .message = operand_110, .name = operand_111, });

                break :block_113 @as(*const (zx_abi).zx_type_86, operand_112);
            };
        }));
    }

    if (((@as(u64, ((in).active).len) + @as(u64, (((in).context).visiting).len)) >= @as(u64, 256))) {
        return (try function_4(allocator, block_99: {
            const operand_93 = in;
            const operand_94 = @as([]const u8, "unsupported");
            const operand_95 = @as([]const u8, "type alias nesting exceeds 256 levels");
            const operand_96 = (value_1).name;

            break :block_99 block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_97).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_93, .code = operand_94, .message = operand_95, .name = operand_96, });

                break :block_98 @as(*const (zx_abi).zx_type_86, operand_97);
            };
        }));
    }

    const value_6: *const (zx_abi).zx_type_91 = (try function_13(allocator, block_92: {
        const operand_87 = ((in).context).source;
        const operand_88 = ((value_1).name).text;
        const operand_89 = (try function_16(allocator, ((in).context).source));

        break :block_92 block_91: {
            const operand_90 = (try (allocator).create((zx_abi).zx_type_90));

            (operand_90).* = @as((zx_abi).zx_type_90, (zx_abi).zx_type_90{ .source = operand_87, .name = operand_88, .limit = operand_89, });

            break :block_91 @as(*const (zx_abi).zx_type_90, operand_90);
        };
    }));

    if ((!(value_6).found)) {
        return (try function_4(allocator, block_86: {
            const operand_80 = in;
            const operand_81 = @as([]const u8, "name");
            const operand_82 = @as([]const u8, "unknown or unsupported type");
            const operand_83 = (value_1).name;

            break :block_86 block_85: {
                const operand_84 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_84).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_80, .code = operand_81, .message = operand_82, .name = operand_83, });

                break :block_85 @as(*const (zx_abi).zx_type_86, operand_84);
            };
        }));
    }

    const value_7: *const (zx_abi).zx_type_65 = (try function_12(allocator, block_79: {
        const operand_75 = ((in).context).source;
        const operand_76 = (value_6).index;

        break :block_79 block_78: {
            const operand_77 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_77).* = @as((zx_abi).zx_type_89, (zx_abi).zx_type_89{ .source = operand_75, .index = operand_76, });

            break :block_78 @as(*const (zx_abi).zx_type_89, operand_77);
        };
    }));

    const value_8: *const (zx_abi).zx_type_82 = (try function_44(allocator, block_74: {
        const operand_54 = block_63: {
            const operand_55 = in;

            const operand_56 = (block_60: {
                const operand_57 = (in).active;
                const operand_58 = ((value_1).name).text;
                const operand_59 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_57).len, 1))));

                @memcpy((operand_59)[0..(operand_57).len], operand_57);
                (operand_59)[(operand_57).len] = operand_58;

                break :block_60 @as((zx_abi).zx_type_98, .{ operand_59, {}, });
            }).@"0";

            break :block_63 block_62: {
                const operand_61 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_61).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = operand_56, .cache = (operand_55).cache, .context = (operand_55).context, .delta = (operand_55).delta, .diagnostic = (operand_55).diagnostic, .frames = (operand_55).frames, .result = (operand_55).result, .scratch = (operand_55).scratch, });

                break :block_62 @as(*const (zx_abi).zx_type_82, operand_61);
            };
        };
        const operand_64 = block_71: {
            const operand_65 = value_1;
            const operand_66 = @as((zx_abi).zx_type_77, .FinishName);
            const operand_67 = (value_7).value;
            const operand_68 = (value_7).name;

            break :block_71 block_70: {
                const operand_69 = (try (allocator).create((zx_abi).zx_type_80));

                (operand_69).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_65).children, .count = (operand_65).count, .declaration = operand_68, .fields = (operand_65).fields, .index = (operand_65).index, .list = (operand_65).list, .name = (operand_65).name, .operation = operand_66, .position = (operand_65).position, .reference = operand_67, .waiting = (operand_65).waiting, });

                break :block_70 @as(*const (zx_abi).zx_type_80, operand_69);
            };
        };

        break :block_74 block_73: {
            const operand_72 = (try (allocator).create((zx_abi).zx_type_135));

            (operand_72).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_54, .frame = operand_64, });

            break :block_73 @as(*const (zx_abi).zx_type_135, operand_72);
        };
    }));

    const value_9: *const (zx_abi).zx_type_62 = (try function_41(allocator, block_53: {
        const operand_49 = ((in).context).source;
        const operand_50 = (value_7).value;

        break :block_53 block_52: {
            const operand_51 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_51).* = @as((zx_abi).zx_type_131, (zx_abi).zx_type_131{ .source = operand_49, .reference = operand_50, });

            break :block_52 @as(*const (zx_abi).zx_type_131, operand_51);
        };
    }));

    if (((((in).context).native_interface and ((value_9).kind == @as((zx_abi).zx_type_59, .Named))) and block_24: {
        const operand_22 = ((value_9).name).text;
        const operand_23 = @as([]const u8, "opaque");

        break :block_24 ((std).mem).eql(u8, operand_22, operand_23);
    })) {
        return (try function_39(allocator, block_48: {
            const operand_25 = value_8;

            const operand_26 = block_45: {
                const operand_27 = @as((zx_abi).zx_type_11, .NativeReference);
                const operand_28 = @as(u32, 0);
                const operand_29 = @as(u32, 0);
                const operand_30 = ((value_7).name).text;

                const operand_31 = block_32: {
                    break :block_32 (try (allocator).dupe(u32, (&[_]u32{})));
                };
                const operand_33 = block_40: {
                    const operand_34 = block_35: {
                        break :block_35 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };
                    const operand_36 = block_37: {
                        break :block_37 (try (allocator).dupe(u32, (&[_]u32{})));
                    };

                    break :block_40 block_39: {
                        const operand_38 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_38).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_34, .types = operand_36, });

                        break :block_39 @as(*const (zx_abi).zx_type_18, operand_38);
                    };
                };
                const operand_41 = block_42: {
                    break :block_42 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                break :block_45 block_44: {
                    const operand_43 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_43).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kind = operand_27, .first = operand_28, .second = operand_29, .label = operand_30, .children = operand_31, .fields = operand_33, .names = operand_41, });

                    break :block_44 @as(*const (zx_abi).zx_type_19, operand_43);
                };
            };

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_129));

                (operand_46).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .state = operand_25, .candidate = operand_26, });

                break :block_47 @as(*const (zx_abi).zx_type_129, operand_46);
            };
        }));
    }

    if (((value_9).kind == @as((zx_abi).zx_type_59, .Enumeration))) {
        return (try function_42(allocator, value_8));
    }

    const value_10: *const (zx_abi).zx_type_80 = (try function_2(allocator, block_21: {
        const operand_10 = @as((zx_abi).zx_type_77, .Node);

        const operand_11 = block_17: {
            const operand_12 = @as([]const u8, "");
            const operand_13 = @as(u64, 0);
            const operand_14 = @as(u64, 0);

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_15).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_12, .start = operand_13, .end = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_60, operand_15);
            };
        };

        const operand_18 = (value_7).value;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_85));

            (operand_19).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_10, .name = operand_11, .reference = operand_18, });

            break :block_20 @as(*const (zx_abi).zx_type_85, operand_19);
        };
    }));

    return block_9: {
        const operand_1 = value_8;

        const operand_2 = (block_6: {
            const operand_3 = (value_8).frames;
            const operand_4 = value_10;
            const operand_5 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_3).len, 1))));

            @memcpy((operand_5)[0..(operand_3).len], operand_3);

            (operand_5)[(operand_3).len] = operand_4;

            break :block_6 @as((zx_abi).zx_type_136, .{ operand_5, {}, });
        }).@"0";

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_7).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_2, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_8 @as(*const (zx_abi).zx_type_82, operand_7);
        };
    };
}

fn function_45_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_322: {
        const operand_321 = (in).frames;

        break :block_322 (try function_19(allocator, operand_321));
    };

    const value_2: u64 = block_320: {
        const operand_319 = ((block_318: {
            break :block_318 value_1;
        }).name).text;

        break :block_320 (try function_3(allocator, operand_319));
    };

    if ((block_308: {
        break :block_308 value_2;
    } != @as(u64, 0))) {
        return block_317: {
            const operand_309 = in;

            const operand_310 = block_313: {
                const operand_312 = (block_311: {
                    break :block_311 value_2;
                } - @as(u64, 1));

                break :block_313 (try function_22(allocator, operand_312));
            };
            const operand_314 = (block_316: {
                const operand_315 = (in).frames;

                break :block_316 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_315).len == 0)) .{ operand_315, null, null, } else .{ (operand_315)[0..((operand_315).len - 1)], (operand_315)[((operand_315).len - 1)], null, }));
            }).@"0";

            break :block_317 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_309).active, .cache = (operand_309).cache, .context = (operand_309).context, .delta = (operand_309).delta, .diagnostic = (operand_309).diagnostic, .frames = operand_314, .result = operand_310, .scratch = (operand_309).scratch, });
        };
    }

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_307: {
        break :block_307 (try function_43_value(allocator, block_306: {
            const operand_303 = (in).cache;

            const operand_304 = ((block_305: {
                break :block_305 value_1;
            }).name).text;

            break :block_306 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_303, .name = operand_304, });
        }));
    };

    const value_4: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (if ((value_3).found) value_3 else block_302: {
        break :block_302 (try function_43_value(allocator, block_301: {
            const operand_298 = ((in).context).resolved;

            const operand_299 = ((block_300: {
                break :block_300 value_1;
            }).name).text;

            break :block_301 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_298, .name = operand_299, });
        }));
    });

    if ((value_4).found) {
        return block_297: {
            const operand_292 = in;
            const operand_293 = (value_4).id;

            const operand_294 = (block_296: {
                const operand_295 = (in).frames;

                break :block_296 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_295).len == 0)) .{ operand_295, null, null, } else .{ (operand_295)[0..((operand_295).len - 1)], (operand_295)[((operand_295).len - 1)], null, }));
            }).@"0";

            break :block_297 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_292).active, .cache = (operand_292).cache, .context = (operand_292).context, .delta = (operand_292).delta, .diagnostic = (operand_292).diagnostic, .frames = operand_294, .result = operand_293, .scratch = (operand_292).scratch, });
        };
    }

    const value_5: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_291: {
        break :block_291 (try function_43_value(allocator, block_290: {
            const operand_287 = ((in).context).aliases;

            const operand_288 = ((block_289: {
                break :block_289 value_1;
            }).name).text;

            break :block_290 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_287, .name = operand_288, });
        }));
    };

    if ((value_5).found) {
        return block_286: {
            const operand_281 = in;
            const operand_282 = (value_5).id;

            const operand_283 = (block_285: {
                const operand_284 = (in).frames;

                break :block_285 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_284).len == 0)) .{ operand_284, null, null, } else .{ (operand_284)[0..((operand_284).len - 1)], (operand_284)[((operand_284).len - 1)], null, }));
            }).@"0";

            break :block_286 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_281).active, .cache = (operand_281).cache, .context = (operand_281).context, .delta = (operand_281).delta, .diagnostic = (operand_281).diagnostic, .frames = operand_283, .result = operand_282, .scratch = (operand_281).scratch, });
        };
    }

    if ((block_268: {
        const operand_264 = (in).active;

        const operand_266 = ((block_265: {
            break :block_265 value_1;
        }).name).text;

        const operand_267 = (zx_abi).zx_type_94{ .names = operand_264, .name = operand_266, };

        break :block_268 (try function_15(allocator, (&operand_267)));
    } or block_273: {
        const operand_269 = ((in).context).visiting;

        const operand_271 = ((block_270: {
            break :block_270 value_1;
        }).name).text;

        const operand_272 = (zx_abi).zx_type_94{ .names = operand_269, .name = operand_271, };

        break :block_273 (try function_15(allocator, (&operand_272)));
    })) {
        return block_280: {
            break :block_280 (try function_4_value(allocator, block_279: {
                const operand_274 = in;
                const operand_275 = @as([]const u8, "type_mismatch");
                const operand_276 = @as([]const u8, "recursive type aliases are not supported");

                const operand_277 = (block_278: {
                    break :block_278 value_1;
                }).name;

                break :block_279 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_274, .code = operand_275, .message = operand_276, .name = operand_277, });
            }));
        };
    }

    if (((@as(u64, ((in).active).len) + @as(u64, (((in).context).visiting).len)) >= @as(u64, 256))) {
        return block_263: {
            break :block_263 (try function_4_value(allocator, block_262: {
                const operand_257 = in;
                const operand_258 = @as([]const u8, "unsupported");
                const operand_259 = @as([]const u8, "type alias nesting exceeds 256 levels");

                const operand_260 = (block_261: {
                    break :block_261 value_1;
                }).name;

                break :block_262 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_257, .code = operand_258, .message = operand_259, .name = operand_260, });
            }));
        };
    }

    const value_6: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_256: {
        break :block_256 (try function_13_value(allocator, block_255: {
            const operand_249 = ((in).context).source;

            const operand_250 = ((block_251: {
                break :block_251 value_1;
            }).name).text;

            const operand_252 = block_254: {
                const operand_253 = ((in).context).source;

                break :block_254 (try function_16(allocator, operand_253));
            };

            break :block_255 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_249, .name = operand_250, .limit = operand_252, });
        }));
    };

    if ((!(value_6).found)) {
        return block_248: {
            break :block_248 (try function_4_value(allocator, block_247: {
                const operand_242 = in;
                const operand_243 = @as([]const u8, "name");
                const operand_244 = @as([]const u8, "unknown or unsupported type");

                const operand_245 = (block_246: {
                    break :block_246 value_1;
                }).name;

                break :block_247 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_242, .code = operand_243, .message = operand_244, .name = operand_245, });
            }));
        };
    }

    const value_7: *const (zx_abi).zx_type_65 = block_241: {
        const operand_238 = block_237: {
            const operand_235 = ((in).context).source;
            const operand_236 = (value_6).index;

            break :block_237 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_235, .index = operand_236, });
        };

        break :block_241 (try function_12(allocator, (if (((operand_238).zx_origin != null)) (operand_238).zx_origin.? else block_240: {
            const operand_239 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_239).* = (zx_abi).zx_type_89{ .index = (operand_238).index, .source = (operand_238).source, };

            break :block_240 @as(*const (zx_abi).zx_type_89, operand_239);
        })));
    };

    const value_8: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_234: {
        break :block_234 (try function_44_value(allocator, block_233: {
            const operand_213 = block_221: {
                const operand_214 = in;

                const operand_215 = (block_220: {
                    const operand_216 = (in).active;

                    const operand_218 = ((block_217: {
                        break :block_217 value_1;
                    }).name).text;

                    const operand_219 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_216).len, 1))));

                    @memcpy((operand_219)[0..(operand_216).len], operand_216);
                    (operand_219)[(operand_216).len] = operand_218;

                    break :block_220 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_219, {}, null, });
                }).@"0";

                break :block_221 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = operand_215, .cache = (operand_214).cache, .context = (operand_214).context, .delta = (operand_214).delta, .diagnostic = (operand_214).diagnostic, .frames = (operand_214).frames, .result = (operand_214).result, .scratch = (operand_214).scratch, });
            };

            const operand_222 = block_232: {
                const operand_223 = block_224: {
                    break :block_224 value_1;
                };

                const operand_225 = @as((zx_abi).zx_type_77, .FinishName);

                const operand_226 = (block_227: {
                    break :block_227 value_7;
                }).value;

                const operand_228 = (block_229: {
                    break :block_229 value_7;
                }).name;

                break :block_232 block_231: {
                    const operand_230 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_230).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_223).children, .count = (operand_223).count, .declaration = operand_228, .fields = (operand_223).fields, .index = (operand_223).index, .list = (operand_223).list, .name = (operand_223).name, .operation = operand_225, .position = (operand_223).position, .reference = operand_226, .waiting = (operand_223).waiting, });

                    break :block_231 @as(*const (zx_abi).zx_type_80, operand_230);
                };
            };

            break :block_233 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_213, .frame = operand_222, });
        }));
    };

    const value_9: *const (zx_abi).zx_type_62 = block_212: {
        const operand_209 = block_208: {
            const operand_205 = ((in).context).source;

            const operand_206 = (block_207: {
                break :block_207 value_7;
            }).value;

            break :block_208 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_205, .reference = operand_206, });
        };

        break :block_212 (try function_41(allocator, (if (((operand_209).zx_origin != null)) (operand_209).zx_origin.? else block_211: {
            const operand_210 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_210).* = (zx_abi).zx_type_131{ .reference = (operand_209).reference, .source = (operand_209).source, };

            break :block_211 @as(*const (zx_abi).zx_type_131, operand_210);
        })));
    };

    if (((((in).context).native_interface and ((block_178: {
        break :block_178 value_9;
    }).kind == @as((zx_abi).zx_type_59, .Named))) and block_182: {
        const operand_180 = ((block_179: {
            break :block_179 value_9;
        }).name).text;

        const operand_181 = @as([]const u8, "opaque");

        break :block_182 ((std).mem).eql(u8, operand_180, operand_181);
    })) {
        return block_204: {
            break :block_204 (try function_39_value(allocator, block_203: {
                const operand_183 = value_8;

                const operand_184 = block_202: {
                    const operand_185 = @as((zx_abi).zx_type_11, .NativeReference);
                    const operand_186 = @as(u32, 0);
                    const operand_187 = @as(u32, 0);

                    const operand_188 = ((block_189: {
                        break :block_189 value_7;
                    }).name).text;

                    const operand_190 = block_191: {
                        break :block_191 (try (allocator).dupe(u32, (&[_]u32{})));
                    };
                    const operand_192 = block_199: {
                        const operand_193 = block_194: {
                            break :block_194 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                        };
                        const operand_195 = block_196: {
                            break :block_196 (try (allocator).dupe(u32, (&[_]u32{})));
                        };

                        break :block_199 block_198: {
                            const operand_197 = (try (allocator).create((zx_abi).zx_type_18));

                            (operand_197).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_193, .types = operand_195, });

                            break :block_198 @as(*const (zx_abi).zx_type_18, operand_197);
                        };
                    };
                    const operand_200 = block_201: {
                        break :block_201 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };

                    break :block_202 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_185, .first = operand_186, .second = operand_187, .label = operand_188, .children = operand_190, .fields = operand_192, .names = operand_200, });
                };

                break :block_203 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_183, .candidate = operand_184, });
            }));
        };
    }

    if (((block_176: {
        break :block_176 value_9;
    }).kind == @as((zx_abi).zx_type_59, .Enumeration))) {
        return block_177: {
            break :block_177 (try function_42_value(allocator, value_8));
        };
    }

    const value_10: *const (zx_abi).zx_type_80 = block_175: {
        const operand_173 = block_172: {
            const operand_162 = @as((zx_abi).zx_type_77, .Node);

            const operand_163 = block_169: {
                const operand_164 = @as([]const u8, "");
                const operand_165 = @as(u64, 0);
                const operand_166 = @as(u64, 0);

                break :block_169 block_168: {
                    const operand_167 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_167).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_164, .start = operand_165, .end = operand_166, });

                    break :block_168 @as(*const (zx_abi).zx_type_60, operand_167);
                };
            };

            const operand_170 = (block_171: {
                break :block_171 value_7;
            }).value;

            break :block_172 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_162, .name = operand_163, .reference = operand_170, });
        };

        var state_borrow_174: (zx_abi).zx_type_85 = undefined;

        state_borrow_174 = (zx_abi).zx_type_85{ .name = (operand_173).name, .operation = (operand_173).operation, .reference = (operand_173).reference, };

        break :block_175 (try function_2(allocator, ((operand_173).zx_origin orelse (&state_borrow_174))));
    };

    return block_161: {
        const operand_154 = value_8;

        const operand_155 = (block_160: {
            const operand_156 = (value_8).frames;

            const operand_158 = block_157: {
                break :block_157 value_10;
            };

            const operand_159 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_156).len, 1))));

            @memcpy((operand_159)[0..(operand_156).len], operand_156);

            (operand_159)[(operand_156).len] = operand_158;

            break :block_160 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_159, {}, null, });
        }).@"0";

        break :block_161 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_154).active, .cache = (operand_154).cache, .context = (operand_154).context, .delta = (operand_154).delta, .diagnostic = (operand_154).diagnostic, .frames = operand_155, .result = (operand_154).result, .scratch = (operand_154).scratch, });
    };
}

fn function_45_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_499: {
        const operand_498 = (in).frames;

        break :block_499 (try function_19(allocator, operand_498));
    };

    const value_2: u64 = block_497: {
        const operand_496 = ((block_495: {
            break :block_495 value_1;
        }).name).text;

        break :block_497 (try function_3(allocator, operand_496));
    };

    if ((block_485: {
        break :block_485 value_2;
    } != @as(u64, 0))) {
        return block_494: {
            const operand_486 = in;

            const operand_487 = block_490: {
                const operand_489 = (block_488: {
                    break :block_488 value_2;
                } - @as(u64, 1));

                break :block_490 (try function_22(allocator, operand_489));
            };

            const operand_491 = (block_493: {
                const operand_492 = (in).frames;

                break :block_493 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_492).len == 0)) .{ operand_492, null, null, } else .{ (operand_492)[0..((operand_492).len - 1)], (operand_492)[((operand_492).len - 1)], null, }));
            }).@"0";

            break :block_494 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_486).active, .cache = (operand_486).cache, .context = (operand_486).context, .delta = (operand_486).delta, .diagnostic = (operand_486).diagnostic, .frames = operand_491, .result = operand_487, .scratch = (operand_486).scratch, });
        };
    }

    const value_3: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_484: {
        break :block_484 (try function_43_value(allocator, block_483: {
            const operand_480 = (in).cache;

            const operand_481 = ((block_482: {
                break :block_482 value_1;
            }).name).text;

            break :block_483 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_480, .name = operand_481, });
        }));
    };

    const value_4: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (if ((value_3).found) value_3 else block_479: {
        break :block_479 (try function_43_value(allocator, block_478: {
            const operand_475 = ((in).context).resolved;

            const operand_476 = ((block_477: {
                break :block_477 value_1;
            }).name).text;

            break :block_478 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_475, .name = operand_476, });
        }));
    });

    if ((value_4).found) {
        return block_474: {
            const operand_469 = in;
            const operand_470 = (value_4).id;

            const operand_471 = (block_473: {
                const operand_472 = (in).frames;

                break :block_473 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_472).len == 0)) .{ operand_472, null, null, } else .{ (operand_472)[0..((operand_472).len - 1)], (operand_472)[((operand_472).len - 1)], null, }));
            }).@"0";

            break :block_474 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_469).active, .cache = (operand_469).cache, .context = (operand_469).context, .delta = (operand_469).delta, .diagnostic = (operand_469).diagnostic, .frames = operand_471, .result = operand_470, .scratch = (operand_469).scratch, });
        };
    }

    const value_5: (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_468: {
        break :block_468 (try function_43_value(allocator, block_467: {
            const operand_464 = ((in).context).aliases;

            const operand_465 = ((block_466: {
                break :block_466 value_1;
            }).name).text;

            break :block_467 @as((zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .cache = operand_464, .name = operand_465, });
        }));
    };

    if ((value_5).found) {
        return block_463: {
            const operand_458 = in;
            const operand_459 = (value_5).id;

            const operand_460 = (block_462: {
                const operand_461 = (in).frames;

                break :block_462 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_461).len == 0)) .{ operand_461, null, null, } else .{ (operand_461)[0..((operand_461).len - 1)], (operand_461)[((operand_461).len - 1)], null, }));
            }).@"0";

            break :block_463 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_458).active, .cache = (operand_458).cache, .context = (operand_458).context, .delta = (operand_458).delta, .diagnostic = (operand_458).diagnostic, .frames = operand_460, .result = operand_459, .scratch = (operand_458).scratch, });
        };
    }

    if ((block_445: {
        const operand_441 = (in).active;

        const operand_443 = ((block_442: {
            break :block_442 value_1;
        }).name).text;

        const operand_444 = (zx_abi).zx_type_94{ .names = operand_441, .name = operand_443, };

        break :block_445 (try function_15(allocator, (&operand_444)));
    } or block_450: {
        const operand_446 = ((in).context).visiting;

        const operand_448 = ((block_447: {
            break :block_447 value_1;
        }).name).text;

        const operand_449 = (zx_abi).zx_type_94{ .names = operand_446, .name = operand_448, };

        break :block_450 (try function_15(allocator, (&operand_449)));
    })) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_457: {
            break :block_457 (try function_4_buffered(allocator, block_456: {
                const operand_451 = in;
                const operand_452 = @as([]const u8, "type_mismatch");
                const operand_453 = @as([]const u8, "recursive type aliases are not supported");

                const operand_454 = (block_455: {
                    break :block_455 value_1;
                }).name;

                break :block_456 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_451, .code = operand_452, .message = operand_453, .name = operand_454, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    if (((@as(u64, ((in).active).len) + @as(u64, (((in).context).visiting).len)) >= @as(u64, 256))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_440: {
            break :block_440 (try function_4_buffered(allocator, block_439: {
                const operand_434 = in;
                const operand_435 = @as([]const u8, "unsupported");
                const operand_436 = @as([]const u8, "type alias nesting exceeds 256 levels");

                const operand_437 = (block_438: {
                    break :block_438 value_1;
                }).name;

                break :block_439 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_434, .code = operand_435, .message = operand_436, .name = operand_437, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_6: (zx_abi).value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_433: {
        break :block_433 (try function_13_value(allocator, block_432: {
            const operand_426 = ((in).context).source;

            const operand_427 = ((block_428: {
                break :block_428 value_1;
            }).name).text;

            const operand_429 = block_431: {
                const operand_430 = ((in).context).source;

                break :block_431 (try function_16(allocator, operand_430));
            };

            break :block_432 @as((zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .source = operand_426, .name = operand_427, .limit = operand_429, });
        }));
    };

    if ((!(value_6).found)) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_425: {
            break :block_425 (try function_4_buffered(allocator, block_424: {
                const operand_419 = in;
                const operand_420 = @as([]const u8, "name");
                const operand_421 = @as([]const u8, "unknown or unsupported type");

                const operand_422 = (block_423: {
                    break :block_423 value_1;
                }).name;

                break :block_424 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_419, .code = operand_420, .message = operand_421, .name = operand_422, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_7: *const (zx_abi).zx_type_65 = block_418: {
        const operand_415 = block_414: {
            const operand_412 = ((in).context).source;
            const operand_413 = (value_6).index;

            break :block_414 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_412, .index = operand_413, });
        };

        break :block_418 (try function_12(allocator, (if (((operand_415).zx_origin != null)) (operand_415).zx_origin.? else block_417: {
            const operand_416 = (try (allocator).create((zx_abi).zx_type_89));

            (operand_416).* = (zx_abi).zx_type_89{ .index = (operand_415).index, .source = (operand_415).source, };

            break :block_417 @as(*const (zx_abi).zx_type_89, operand_416);
        })));
    };

    const value_8: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_411: {
        break :block_411 (try function_44_buffered(allocator, block_410: {
            const operand_386 = block_398: {
                const operand_387 = in;

                const operand_388 = @as([]const []const u8, (if (((buffers).lane_0 != null)) block_392: {
                    const operand_389 = (in).active;

                    const operand_391 = ((block_390: {
                        break :block_390 value_1;
                    }).name).text;

                    _ = (try ((std).math).add(usize, (operand_389).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_389));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_389).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_391));

                    break :block_392 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_397: {
                    const operand_393 = (in).active;

                    const operand_395 = ((block_394: {
                        break :block_394 value_1;
                    }).name).text;

                    const operand_396 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_393).len, 1))));

                    @memcpy((operand_396)[0..(operand_393).len], operand_393);

                    (operand_396)[(operand_393).len] = operand_395;

                    break :block_397 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_396, {}, null, });
                }).@"0"));

                break :block_398 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = operand_388, .cache = (operand_387).cache, .context = (operand_387).context, .delta = (operand_387).delta, .diagnostic = (operand_387).diagnostic, .frames = (operand_387).frames, .result = (operand_387).result, .scratch = (operand_387).scratch, });
            };

            const operand_399 = block_409: {
                const operand_400 = block_401: {
                    break :block_401 value_1;
                };

                const operand_402 = @as((zx_abi).zx_type_77, .FinishName);

                const operand_403 = (block_404: {
                    break :block_404 value_7;
                }).value;

                const operand_405 = (block_406: {
                    break :block_406 value_7;
                }).name;

                break :block_409 block_408: {
                    const operand_407 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_407).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_400).children, .count = (operand_400).count, .declaration = operand_405, .fields = (operand_400).fields, .index = (operand_400).index, .list = (operand_400).list, .name = (operand_400).name, .operation = operand_402, .position = (operand_400).position, .reference = operand_403, .waiting = (operand_400).waiting, });

                    break :block_408 @as(*const (zx_abi).zx_type_80, operand_407);
                };
            };

            break :block_410 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_386, .frame = operand_399, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });

    const value_9: *const (zx_abi).zx_type_62 = block_385: {
        const operand_382 = block_381: {
            const operand_378 = ((in).context).source;

            const operand_379 = (block_380: {
                break :block_380 value_7;
            }).value;

            break :block_381 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_378, .reference = operand_379, });
        };

        break :block_385 (try function_41(allocator, (if (((operand_382).zx_origin != null)) (operand_382).zx_origin.? else block_384: {
            const operand_383 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_383).* = (zx_abi).zx_type_131{ .reference = (operand_382).reference, .source = (operand_382).source, };

            break :block_384 @as(*const (zx_abi).zx_type_131, operand_383);
        })));
    };

    if (((((in).context).native_interface and ((block_351: {
        break :block_351 value_9;
    }).kind == @as((zx_abi).zx_type_59, .Named))) and block_355: {
        const operand_353 = ((block_352: {
            break :block_352 value_9;
        }).name).text;

        const operand_354 = @as([]const u8, "opaque");

        break :block_355 ((std).mem).eql(u8, operand_353, operand_354);
    })) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_377: {
            break :block_377 (try function_39_buffered(allocator, block_376: {
                const operand_356 = value_8;

                const operand_357 = block_375: {
                    const operand_358 = @as((zx_abi).zx_type_11, .NativeReference);
                    const operand_359 = @as(u32, 0);
                    const operand_360 = @as(u32, 0);

                    const operand_361 = ((block_362: {
                        break :block_362 value_7;
                    }).name).text;
                    const operand_363 = block_364: {
                        break :block_364 (try (allocator).dupe(u32, (&[_]u32{})));
                    };
                    const operand_365 = block_372: {
                        const operand_366 = block_367: {
                            break :block_367 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                        };
                        const operand_368 = block_369: {
                            break :block_369 (try (allocator).dupe(u32, (&[_]u32{})));
                        };

                        break :block_372 block_371: {
                            const operand_370 = (try (allocator).create((zx_abi).zx_type_18));

                            (operand_370).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_366, .types = operand_368, });

                            break :block_371 @as(*const (zx_abi).zx_type_18, operand_370);
                        };
                    };
                    const operand_373 = block_374: {
                        break :block_374 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };

                    break :block_375 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_358, .first = operand_359, .second = operand_360, .label = operand_361, .children = operand_363, .fields = operand_365, .names = operand_373, });
                };

                break :block_376 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_356, .candidate = operand_357, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    if (((block_349: {
        break :block_349 value_9;
    }).kind == @as((zx_abi).zx_type_59, .Enumeration))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_350: {
            break :block_350 (try function_42_buffered(allocator, value_8, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_10: *const (zx_abi).zx_type_80 = block_348: {
        const operand_346 = block_345: {
            const operand_335 = @as((zx_abi).zx_type_77, .Node);

            const operand_336 = block_342: {
                const operand_337 = @as([]const u8, "");
                const operand_338 = @as(u64, 0);
                const operand_339 = @as(u64, 0);

                break :block_342 block_341: {
                    const operand_340 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_340).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_337, .start = operand_338, .end = operand_339, });

                    break :block_341 @as(*const (zx_abi).zx_type_60, operand_340);
                };
            };

            const operand_343 = (block_344: {
                break :block_344 value_7;
            }).value;

            break :block_345 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_335, .name = operand_336, .reference = operand_343, });
        };

        var state_borrow_347: (zx_abi).zx_type_85 = undefined;

        state_borrow_347 = (zx_abi).zx_type_85{ .name = (operand_346).name, .operation = (operand_346).operation, .reference = (operand_346).reference, };

        break :block_348 (try function_2(allocator, ((operand_346).zx_origin orelse (&state_borrow_347))));
    };

    return block_334: {
        const operand_323 = value_8;

        const operand_324 = @as([]const *const (zx_abi).zx_type_80, (if (((buffers).lane_33 != null)) block_328: {
            const operand_325 = (value_8).frames;

            const operand_327 = block_326: {
                break :block_326 value_10;
            };

            _ = (try ((std).math).add(usize, (operand_325).len, 1));

            if ((!(((buffers).lane_33.?).started).*)) {
                (try ((((buffers).lane_33.?).buffer).*).appendSlice(allocator, operand_325));
                (((buffers).lane_33.?).started).* = true;
            } else {
                (((((buffers).lane_33.?).buffer).*).items).len = (operand_325).len;
            }

            (try ((((buffers).lane_33.?).buffer).*).append(allocator, operand_327));

            break :block_328 ((((buffers).lane_33.?).buffer).*).items;
        } else (block_333: {
            const operand_329 = (value_8).frames;

            const operand_331 = block_330: {
                break :block_330 value_10;
            };

            const operand_332 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_329).len, 1))));

            @memcpy((operand_332)[0..(operand_329).len], operand_329);

            (operand_332)[(operand_329).len] = operand_331;

            break :block_333 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_332, {}, null, });
        }).@"0"));

        break :block_334 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_323).active, .cache = (operand_323).cache, .context = (operand_323).context, .delta = (operand_323).delta, .diagnostic = (operand_323).diagnostic, .frames = operand_324, .result = (operand_323).result, .scratch = (operand_323).scratch, });
    };
}

fn function_46(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    const value_2: *const (zx_abi).zx_type_62 = (try function_41(allocator, block_85: {
        const operand_81 = ((in).context).source;
        const operand_82 = (value_1).reference;

        break :block_85 block_84: {
            const operand_83 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_83).* = @as((zx_abi).zx_type_131, (zx_abi).zx_type_131{ .source = operand_81, .reference = operand_82, });

            break :block_84 @as(*const (zx_abi).zx_type_131, operand_83);
        };
    }));

    if (((value_2).kind == @as((zx_abi).zx_type_59, .Named))) {
        return (try function_44(allocator, block_80: {
            const operand_70 = in;

            const operand_71 = block_77: {
                const operand_72 = value_1;
                const operand_73 = @as((zx_abi).zx_type_77, .Name);
                const operand_74 = (value_2).name;

                break :block_77 block_76: {
                    const operand_75 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_75).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_72).children, .count = (operand_72).count, .declaration = (operand_72).declaration, .fields = (operand_72).fields, .index = (operand_72).index, .list = (operand_72).list, .name = operand_74, .operation = operand_73, .position = (operand_72).position, .reference = (operand_72).reference, .waiting = (operand_72).waiting, });

                    break :block_76 @as(*const (zx_abi).zx_type_80, operand_75);
                };
            };

            break :block_80 block_79: {
                const operand_78 = (try (allocator).create((zx_abi).zx_type_135));

                (operand_78).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_70, .frame = operand_71, });

                break :block_79 @as(*const (zx_abi).zx_type_135, operand_78);
            };
        }));
    }

    if (((((value_2).kind == @as((zx_abi).zx_type_59, .Optional)) or ((value_2).kind == @as((zx_abi).zx_type_59, .List))) or ((value_2).kind == @as((zx_abi).zx_type_59, .Application)))) {
        if ((((value_2).kind == @as((zx_abi).zx_type_59, .Application)) and (!block_62: {
            const operand_60 = ((value_2).name).text;
            const operand_61 = @as([]const u8, "Array");

            break :block_62 ((std).mem).eql(u8, operand_60, operand_61);
        }))) {
            return (try function_4(allocator, block_69: {
                const operand_63 = in;
                const operand_64 = @as([]const u8, "unsupported");
                const operand_65 = @as([]const u8, "generic and database types are not enabled");
                const operand_66 = (value_2).name;

                break :block_69 block_68: {
                    const operand_67 = (try (allocator).create((zx_abi).zx_type_86));

                    (operand_67).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_63, .code = operand_64, .message = operand_65, .name = operand_66, });

                    break :block_68 @as(*const (zx_abi).zx_type_86, operand_67);
                };
            }));
        }

        const value_3: *const (zx_abi).zx_type_82 = (try function_44(allocator, block_59: {
            const operand_49 = in;
            const operand_50 = block_56: {
                const operand_51 = value_1;
                const operand_52 = @as((zx_abi).zx_type_77, .Wrap);
                const operand_53 = ((value_2).kind != @as((zx_abi).zx_type_59, .Optional));

                break :block_56 block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_54).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_51).children, .count = (operand_51).count, .declaration = (operand_51).declaration, .fields = (operand_51).fields, .index = (operand_51).index, .list = operand_53, .name = (operand_51).name, .operation = operand_52, .position = (operand_51).position, .reference = (operand_51).reference, .waiting = (operand_51).waiting, });

                    break :block_55 @as(*const (zx_abi).zx_type_80, operand_54);
                };
            };

            break :block_59 block_58: {
                const operand_57 = (try (allocator).create((zx_abi).zx_type_135));

                (operand_57).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_49, .frame = operand_50, });

                break :block_58 @as(*const (zx_abi).zx_type_135, operand_57);
            };
        }));

        const value_4: *const (zx_abi).zx_type_80 = (try function_2(allocator, block_48: {
            const operand_37 = @as((zx_abi).zx_type_77, .Node);

            const operand_38 = block_44: {
                const operand_39 = @as([]const u8, "");
                const operand_40 = @as(u64, 0);
                const operand_41 = @as(u64, 0);

                break :block_44 block_43: {
                    const operand_42 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_42).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_39, .start = operand_40, .end = operand_41, });

                    break :block_43 @as(*const (zx_abi).zx_type_60, operand_42);
                };
            };

            const operand_45 = (value_2).child;

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_85));

                (operand_46).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_37, .name = operand_38, .reference = operand_45, });

                break :block_47 @as(*const (zx_abi).zx_type_85, operand_46);
            };
        }));

        return block_36: {
            const operand_28 = value_3;

            const operand_29 = (block_33: {
                const operand_30 = (value_3).frames;
                const operand_31 = value_4;
                const operand_32 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_30).len, 1))));

                @memcpy((operand_32)[0..(operand_30).len], operand_30);

                (operand_32)[(operand_30).len] = operand_31;

                break :block_33 @as((zx_abi).zx_type_136, .{ operand_32, {}, });
            }).@"0";

            break :block_36 block_35: {
                const operand_34 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_34).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_28).active, .cache = (operand_28).cache, .context = (operand_28).context, .delta = (operand_28).delta, .diagnostic = (operand_28).diagnostic, .frames = operand_29, .result = (operand_28).result, .scratch = (operand_28).scratch, });

                break :block_35 @as(*const (zx_abi).zx_type_82, operand_34);
            };
        };
    }

    if ((((value_2).kind == @as((zx_abi).zx_type_59, .Tuple)) or ((value_2).kind == @as((zx_abi).zx_type_59, .Object)))) {
        return (try function_44(allocator, block_27: {
            const operand_14 = in;

            const operand_15 = block_24: {
                const operand_16 = value_1;
                const operand_17 = (if (((value_2).kind == @as((zx_abi).zx_type_59, .Tuple))) @as((zx_abi).zx_type_77, .Tuple) else @as((zx_abi).zx_type_77, .Object));
                const operand_18 = (value_2).count;
                const operand_19 = (value_2).position;
                const operand_20 = @as(u64, (((in).scratch).types).len);
                const operand_21 = @as(u64, (((in).scratch).names).len);

                break :block_24 block_23: {
                    const operand_22 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_22).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = operand_20, .count = operand_18, .declaration = (operand_16).declaration, .fields = operand_21, .index = (operand_16).index, .list = (operand_16).list, .name = (operand_16).name, .operation = operand_17, .position = operand_19, .reference = (operand_16).reference, .waiting = (operand_16).waiting, });

                    break :block_23 @as(*const (zx_abi).zx_type_80, operand_22);
                };
            };

            break :block_27 block_26: {
                const operand_25 = (try (allocator).create((zx_abi).zx_type_135));

                (operand_25).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_14, .frame = operand_15, });

                break :block_26 @as(*const (zx_abi).zx_type_135, operand_25);
            };
        }));
    }

    return (try function_4(allocator, block_13: {
        const operand_1 = in;
        const operand_2 = @as([]const u8, "type_mismatch");
        const operand_3 = @as([]const u8, "enum types require a named declaration");

        const operand_4 = block_10: {
            const operand_5 = @as([]const u8, "");
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_8).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_5, .start = operand_6, .end = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_60, operand_8);
            };
        };

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_86));

            (operand_11).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_1, .code = operand_2, .message = operand_3, .name = operand_4, });

            break :block_12 @as(*const (zx_abi).zx_type_86, operand_11);
        };
    }));
}

fn function_46_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_188: {
        const operand_187 = (in).frames;

        break :block_188 (try function_19(allocator, operand_187));
    };

    const value_2: *const (zx_abi).zx_type_62 = block_186: {
        const operand_183 = block_182: {
            const operand_179 = ((in).context).source;

            const operand_180 = (block_181: {
                break :block_181 value_1;
            }).reference;

            break :block_182 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_179, .reference = operand_180, });
        };

        break :block_186 (try function_41(allocator, (if (((operand_183).zx_origin != null)) (operand_183).zx_origin.? else block_185: {
            const operand_184 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_184).* = (zx_abi).zx_type_131{ .reference = (operand_183).reference, .source = (operand_183).source, };

            break :block_185 @as(*const (zx_abi).zx_type_131, operand_184);
        })));
    };

    if (((block_166: {
        break :block_166 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Named))) {
        return block_178: {
            break :block_178 (try function_44_value(allocator, block_177: {
                const operand_167 = in;

                const operand_168 = block_176: {
                    const operand_169 = block_170: {
                        break :block_170 value_1;
                    };

                    const operand_171 = @as((zx_abi).zx_type_77, .Name);

                    const operand_172 = (block_173: {
                        break :block_173 value_2;
                    }).name;

                    break :block_176 block_175: {
                        const operand_174 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_174).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_169).children, .count = (operand_169).count, .declaration = (operand_169).declaration, .fields = (operand_169).fields, .index = (operand_169).index, .list = (operand_169).list, .name = operand_172, .operation = operand_171, .position = (operand_169).position, .reference = (operand_169).reference, .waiting = (operand_169).waiting, });

                        break :block_175 @as(*const (zx_abi).zx_type_80, operand_174);
                    };
                };

                break :block_177 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_167, .frame = operand_168, });
            }));
        };
    }

    if (((((block_117: {
        break :block_117 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Optional)) or ((block_118: {
        break :block_118 value_2;
    }).kind == @as((zx_abi).zx_type_59, .List))) or ((block_119: {
        break :block_119 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Application)))) {
        if ((((block_154: {
            break :block_154 value_2;
        }).kind == @as((zx_abi).zx_type_59, .Application)) and (!block_158: {
            const operand_156 = ((block_155: {
                break :block_155 value_2;
            }).name).text;

            const operand_157 = @as([]const u8, "Array");

            break :block_158 ((std).mem).eql(u8, operand_156, operand_157);
        }))) {
            return block_165: {
                break :block_165 (try function_4_value(allocator, block_164: {
                    const operand_159 = in;
                    const operand_160 = @as([]const u8, "unsupported");
                    const operand_161 = @as([]const u8, "generic and database types are not enabled");

                    const operand_162 = (block_163: {
                        break :block_163 value_2;
                    }).name;

                    break :block_164 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_159, .code = operand_160, .message = operand_161, .name = operand_162, });
                }));
            };
        }

        const value_3: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_153: {
            break :block_153 (try function_44_value(allocator, block_152: {
                const operand_142 = in;

                const operand_143 = block_151: {
                    const operand_144 = block_145: {
                        break :block_145 value_1;
                    };

                    const operand_146 = @as((zx_abi).zx_type_77, .Wrap);

                    const operand_147 = ((block_148: {
                        break :block_148 value_2;
                    }).kind != @as((zx_abi).zx_type_59, .Optional));

                    break :block_151 block_150: {
                        const operand_149 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_149).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_144).children, .count = (operand_144).count, .declaration = (operand_144).declaration, .fields = (operand_144).fields, .index = (operand_144).index, .list = operand_147, .name = (operand_144).name, .operation = operand_146, .position = (operand_144).position, .reference = (operand_144).reference, .waiting = (operand_144).waiting, });

                        break :block_150 @as(*const (zx_abi).zx_type_80, operand_149);
                    };
                };

                break :block_152 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_142, .frame = operand_143, });
            }));
        };

        const value_4: *const (zx_abi).zx_type_80 = block_141: {
            const operand_139 = block_138: {
                const operand_128 = @as((zx_abi).zx_type_77, .Node);

                const operand_129 = block_135: {
                    const operand_130 = @as([]const u8, "");
                    const operand_131 = @as(u64, 0);
                    const operand_132 = @as(u64, 0);

                    break :block_135 block_134: {
                        const operand_133 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_133).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_130, .start = operand_131, .end = operand_132, });

                        break :block_134 @as(*const (zx_abi).zx_type_60, operand_133);
                    };
                };
                const operand_136 = (block_137: {
                    break :block_137 value_2;
                }).child;

                break :block_138 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_128, .name = operand_129, .reference = operand_136, });
            };

            var state_borrow_140: (zx_abi).zx_type_85 = undefined;

            state_borrow_140 = (zx_abi).zx_type_85{ .name = (operand_139).name, .operation = (operand_139).operation, .reference = (operand_139).reference, };

            break :block_141 (try function_2(allocator, ((operand_139).zx_origin orelse (&state_borrow_140))));
        };

        return block_127: {
            const operand_120 = value_3;

            const operand_121 = (block_126: {
                const operand_122 = (value_3).frames;

                const operand_124 = block_123: {
                    break :block_123 value_4;
                };

                const operand_125 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_122).len, 1))));

                @memcpy((operand_125)[0..(operand_122).len], operand_122);

                (operand_125)[(operand_122).len] = operand_124;

                break :block_126 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_125, {}, null, });
            }).@"0";

            break :block_127 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_120).active, .cache = (operand_120).cache, .context = (operand_120).context, .delta = (operand_120).delta, .diagnostic = (operand_120).diagnostic, .frames = operand_121, .result = (operand_120).result, .scratch = (operand_120).scratch, });
        };
    }

    if ((((block_98: {
        break :block_98 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Tuple)) or ((block_99: {
        break :block_99 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Object)))) {
        return block_116: {
            break :block_116 (try function_44_value(allocator, block_115: {
                const operand_100 = in;

                const operand_101 = block_114: {
                    const operand_102 = block_103: {
                        break :block_103 value_1;
                    };
                    const operand_104 = (if (((block_105: {
                        break :block_105 value_2;
                    }).kind == @as((zx_abi).zx_type_59, .Tuple))) @as((zx_abi).zx_type_77, .Tuple) else @as((zx_abi).zx_type_77, .Object));

                    const operand_106 = (block_107: {
                        break :block_107 value_2;
                    }).count;

                    const operand_108 = (block_109: {
                        break :block_109 value_2;
                    }).position;

                    const operand_110 = @as(u64, (((in).scratch).types).len);
                    const operand_111 = @as(u64, (((in).scratch).names).len);

                    break :block_114 block_113: {
                        const operand_112 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_112).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = operand_110, .count = operand_106, .declaration = (operand_102).declaration, .fields = operand_111, .index = (operand_102).index, .list = (operand_102).list, .name = (operand_102).name, .operation = operand_104, .position = operand_108, .reference = (operand_102).reference, .waiting = (operand_102).waiting, });

                        break :block_113 @as(*const (zx_abi).zx_type_80, operand_112);
                    };
                };

                break :block_115 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_100, .frame = operand_101, });
            }));
        };
    }

    return block_97: {
        break :block_97 (try function_4_value(allocator, block_96: {
            const operand_86 = in;
            const operand_87 = @as([]const u8, "type_mismatch");
            const operand_88 = @as([]const u8, "enum types require a named declaration");

            const operand_89 = block_95: {
                const operand_90 = @as([]const u8, "");
                const operand_91 = @as(u64, 0);
                const operand_92 = @as(u64, 0);

                break :block_95 block_94: {
                    const operand_93 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_93).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_90, .start = operand_91, .end = operand_92, });

                    break :block_94 @as(*const (zx_abi).zx_type_60, operand_93);
                };
            };

            break :block_96 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_86, .code = operand_87, .message = operand_88, .name = operand_89, });
        }));
    };
}

fn function_46_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_295: {
        const operand_294 = (in).frames;

        break :block_295 (try function_19(allocator, operand_294));
    };

    const value_2: *const (zx_abi).zx_type_62 = block_293: {
        const operand_290 = block_289: {
            const operand_286 = ((in).context).source;

            const operand_287 = (block_288: {
                break :block_288 value_1;
            }).reference;

            break :block_289 @as((zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_286, .reference = operand_287, });
        };

        break :block_293 (try function_41(allocator, (if (((operand_290).zx_origin != null)) (operand_290).zx_origin.? else block_292: {
            const operand_291 = (try (allocator).create((zx_abi).zx_type_131));

            (operand_291).* = (zx_abi).zx_type_131{ .reference = (operand_290).reference, .source = (operand_290).source, };

            break :block_292 @as(*const (zx_abi).zx_type_131, operand_291);
        })));
    };

    if (((block_273: {
        break :block_273 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Named))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_285: {
            break :block_285 (try function_44_buffered(allocator, block_284: {
                const operand_274 = in;

                const operand_275 = block_283: {
                    const operand_276 = block_277: {
                        break :block_277 value_1;
                    };

                    const operand_278 = @as((zx_abi).zx_type_77, .Name);

                    const operand_279 = (block_280: {
                        break :block_280 value_2;
                    }).name;

                    break :block_283 block_282: {
                        const operand_281 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_281).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_276).children, .count = (operand_276).count, .declaration = (operand_276).declaration, .fields = (operand_276).fields, .index = (operand_276).index, .list = (operand_276).list, .name = operand_279, .operation = operand_278, .position = (operand_276).position, .reference = (operand_276).reference, .waiting = (operand_276).waiting, });

                        break :block_282 @as(*const (zx_abi).zx_type_80, operand_281);
                    };
                };

                break :block_284 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_274, .frame = operand_275, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    if (((((block_220: {
        break :block_220 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Optional)) or ((block_221: {
        break :block_221 value_2;
    }).kind == @as((zx_abi).zx_type_59, .List))) or ((block_222: {
        break :block_222 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Application)))) {
        if ((((block_261: {
            break :block_261 value_2;
        }).kind == @as((zx_abi).zx_type_59, .Application)) and (!block_265: {
            const operand_263 = ((block_262: {
                break :block_262 value_2;
            }).name).text;

            const operand_264 = @as([]const u8, "Array");

            break :block_265 ((std).mem).eql(u8, operand_263, operand_264);
        }))) {
            return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_272: {
                break :block_272 (try function_4_buffered(allocator, block_271: {
                    const operand_266 = in;
                    const operand_267 = @as([]const u8, "unsupported");
                    const operand_268 = @as([]const u8, "generic and database types are not enabled");

                    const operand_269 = (block_270: {
                        break :block_270 value_2;
                    }).name;

                    break :block_271 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_266, .code = operand_267, .message = operand_268, .name = operand_269, });
                }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
            });
        }

        const value_3: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_260: {
            break :block_260 (try function_44_buffered(allocator, block_259: {
                const operand_249 = in;

                const operand_250 = block_258: {
                    const operand_251 = block_252: {
                        break :block_252 value_1;
                    };

                    const operand_253 = @as((zx_abi).zx_type_77, .Wrap);

                    const operand_254 = ((block_255: {
                        break :block_255 value_2;
                    }).kind != @as((zx_abi).zx_type_59, .Optional));

                    break :block_258 block_257: {
                        const operand_256 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_256).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_251).children, .count = (operand_251).count, .declaration = (operand_251).declaration, .fields = (operand_251).fields, .index = (operand_251).index, .list = operand_254, .name = (operand_251).name, .operation = operand_253, .position = (operand_251).position, .reference = (operand_251).reference, .waiting = (operand_251).waiting, });

                        break :block_257 @as(*const (zx_abi).zx_type_80, operand_256);
                    };
                };

                break :block_259 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_249, .frame = operand_250, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });

        const value_4: *const (zx_abi).zx_type_80 = block_248: {
            const operand_246 = block_245: {
                const operand_235 = @as((zx_abi).zx_type_77, .Node);

                const operand_236 = block_242: {
                    const operand_237 = @as([]const u8, "");
                    const operand_238 = @as(u64, 0);
                    const operand_239 = @as(u64, 0);

                    break :block_242 block_241: {
                        const operand_240 = (try (allocator).create((zx_abi).zx_type_60));

                        (operand_240).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_237, .start = operand_238, .end = operand_239, });

                        break :block_241 @as(*const (zx_abi).zx_type_60, operand_240);
                    };
                };
                const operand_243 = (block_244: {
                    break :block_244 value_2;
                }).child;

                break :block_245 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_235, .name = operand_236, .reference = operand_243, });
            };

            var state_borrow_247: (zx_abi).zx_type_85 = undefined;

            state_borrow_247 = (zx_abi).zx_type_85{ .name = (operand_246).name, .operation = (operand_246).operation, .reference = (operand_246).reference, };

            break :block_248 (try function_2(allocator, ((operand_246).zx_origin orelse (&state_borrow_247))));
        };

        return block_234: {
            const operand_223 = value_3;

            const operand_224 = @as([]const *const (zx_abi).zx_type_80, (if (((buffers).lane_33 != null)) block_228: {
                const operand_225 = (value_3).frames;

                const operand_227 = block_226: {
                    break :block_226 value_4;
                };

                _ = (try ((std).math).add(usize, (operand_225).len, 1));

                if ((!(((buffers).lane_33.?).started).*)) {
                    (try ((((buffers).lane_33.?).buffer).*).appendSlice(allocator, operand_225));
                    (((buffers).lane_33.?).started).* = true;
                } else {
                    (((((buffers).lane_33.?).buffer).*).items).len = (operand_225).len;
                }

                (try ((((buffers).lane_33.?).buffer).*).append(allocator, operand_227));

                break :block_228 ((((buffers).lane_33.?).buffer).*).items;
            } else (block_233: {
                const operand_229 = (value_3).frames;

                const operand_231 = block_230: {
                    break :block_230 value_4;
                };

                const operand_232 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_229).len, 1))));

                @memcpy((operand_232)[0..(operand_229).len], operand_229);

                (operand_232)[(operand_229).len] = operand_231;

                break :block_233 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_232, {}, null, });
            }).@"0"));

            break :block_234 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_223).active, .cache = (operand_223).cache, .context = (operand_223).context, .delta = (operand_223).delta, .diagnostic = (operand_223).diagnostic, .frames = operand_224, .result = (operand_223).result, .scratch = (operand_223).scratch, });
        };
    }

    if ((((block_201: {
        break :block_201 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Tuple)) or ((block_202: {
        break :block_202 value_2;
    }).kind == @as((zx_abi).zx_type_59, .Object)))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_219: {
            break :block_219 (try function_44_buffered(allocator, block_218: {
                const operand_203 = in;

                const operand_204 = block_217: {
                    const operand_205 = block_206: {
                        break :block_206 value_1;
                    };
                    const operand_207 = (if (((block_208: {
                        break :block_208 value_2;
                    }).kind == @as((zx_abi).zx_type_59, .Tuple))) @as((zx_abi).zx_type_77, .Tuple) else @as((zx_abi).zx_type_77, .Object));

                    const operand_209 = (block_210: {
                        break :block_210 value_2;
                    }).count;

                    const operand_211 = (block_212: {
                        break :block_212 value_2;
                    }).position;

                    const operand_213 = @as(u64, (((in).scratch).types).len);
                    const operand_214 = @as(u64, (((in).scratch).names).len);

                    break :block_217 block_216: {
                        const operand_215 = (try (allocator).create((zx_abi).zx_type_80));

                        (operand_215).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = operand_213, .count = operand_209, .declaration = (operand_205).declaration, .fields = operand_214, .index = (operand_205).index, .list = (operand_205).list, .name = (operand_205).name, .operation = operand_207, .position = operand_211, .reference = (operand_205).reference, .waiting = (operand_205).waiting, });

                        break :block_216 @as(*const (zx_abi).zx_type_80, operand_215);
                    };
                };

                break :block_218 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_203, .frame = operand_204, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_200: {
        break :block_200 (try function_4_buffered(allocator, block_199: {
            const operand_189 = in;
            const operand_190 = @as([]const u8, "type_mismatch");
            const operand_191 = @as([]const u8, "enum types require a named declaration");

            const operand_192 = block_198: {
                const operand_193 = @as([]const u8, "");
                const operand_194 = @as(u64, 0);
                const operand_195 = @as(u64, 0);

                break :block_198 block_197: {
                    const operand_196 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_196).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_193, .start = operand_194, .end = operand_195, });

                    break :block_197 @as(*const (zx_abi).zx_type_60, operand_196);
                };
            };

            break :block_199 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_189, .code = operand_190, .message = operand_191, .name = operand_192, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });
}

fn function_47(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    const value_2: []const u32 = block_69: {
        const operand_62 = ((in).scratch).types;
        const operand_63 = (value_1).children;
        const operand_64 = (@as(u64, (((in).scratch).types).len) - (value_1).children);

        const operand_66 = block_65: {
            break :block_65 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        if (((operand_63 > (operand_62).len) or (operand_64 > ((operand_62).len - operand_63)))) {
            return error.IndexOutOfBounds;
        }

        const operand_67 = @as(usize, @intCast(operand_63));
        const operand_68 = @as(usize, @intCast(operand_64));

        _ = (try ((std).math).add(usize, ((operand_62).len - operand_68), (operand_66).len));

        break :block_69 (operand_62)[operand_67..(operand_67 + operand_68)];
    };

    const value_3: []const []const u8 = block_61: {
        const operand_54 = ((in).scratch).names;
        const operand_55 = (value_1).fields;
        const operand_56 = (@as(u64, (((in).scratch).names).len) - (value_1).fields);

        const operand_58 = block_57: {
            break :block_57 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_55 > (operand_54).len) or (operand_56 > ((operand_54).len - operand_55)))) {
            return error.IndexOutOfBounds;
        }

        const operand_59 = @as(usize, @intCast(operand_55));
        const operand_60 = @as(usize, @intCast(operand_56));

        _ = (try ((std).math).add(usize, ((operand_54).len - operand_60), (operand_58).len));

        break :block_61 (operand_54)[operand_59..(operand_59 + operand_60)];
    };

    const value_4: bool = ((value_1).operation == @as((zx_abi).zx_type_77, .Object));

    const value_5: *const (zx_abi).zx_type_82 = (try function_39(allocator, block_53: {
        const operand_30 = in;

        const operand_31 = block_50: {
            const operand_32 = (if (value_4) @as((zx_abi).zx_type_11, .Object) else @as((zx_abi).zx_type_11, .Tuple));
            const operand_33 = @as(u32, 0);
            const operand_34 = @as(u32, 0);
            const operand_35 = @as([]const u8, "");

            const operand_36 = (if (value_4) block_37: {
                break :block_37 (try (allocator).dupe(u32, (&[_]u32{})));
            } else value_2);

            const operand_38 = block_45: {
                const operand_39 = (if (value_4) value_3 else block_40: {
                    break :block_40 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                });

                const operand_41 = (if (value_4) value_2 else block_42: {
                    break :block_42 (try (allocator).dupe(u32, (&[_]u32{})));
                });

                break :block_45 block_44: {
                    const operand_43 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_43).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_39, .types = operand_41, });

                    break :block_44 @as(*const (zx_abi).zx_type_18, operand_43);
                };
            };
            const operand_46 = block_47: {
                break :block_47 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            break :block_50 block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_48).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kind = operand_32, .first = operand_33, .second = operand_34, .label = operand_35, .children = operand_36, .fields = operand_38, .names = operand_46, });

                break :block_49 @as(*const (zx_abi).zx_type_19, operand_48);
            };
        };

        break :block_53 block_52: {
            const operand_51 = (try (allocator).create((zx_abi).zx_type_129));

            (operand_51).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .state = operand_30, .candidate = operand_31, });

            break :block_52 @as(*const (zx_abi).zx_type_129, operand_51);
        };
    }));

    return block_29: {
        const operand_1 = value_5;
        const operand_2 = block_23: {
            const operand_3 = block_11: {
                const operand_4 = ((in).scratch).types;
                const operand_5 = @as(u64, 0);
                const operand_6 = (value_1).children;

                const operand_8 = block_7: {
                    break :block_7 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                if (((operand_5 > (operand_4).len) or (operand_6 > ((operand_4).len - operand_5)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_9 = @as(usize, @intCast(operand_5));
                const operand_10 = @as(usize, @intCast(operand_6));

                _ = (try ((std).math).add(usize, ((operand_4).len - operand_10), (operand_8).len));

                break :block_11 (operand_4)[operand_9..(operand_9 + operand_10)];
            };
            const operand_12 = block_20: {
                const operand_13 = ((in).scratch).names;
                const operand_14 = @as(u64, 0);
                const operand_15 = (value_1).fields;

                const operand_17 = block_16: {
                    break :block_16 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                if (((operand_14 > (operand_13).len) or (operand_15 > ((operand_13).len - operand_14)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_18 = @as(usize, @intCast(operand_14));
                const operand_19 = @as(usize, @intCast(operand_15));

                _ = (try ((std).math).add(usize, ((operand_13).len - operand_19), (operand_17).len));

                break :block_20 (operand_13)[operand_18..(operand_18 + operand_19)];
            };

            break :block_23 block_22: {
                const operand_21 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_21).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_3, .names = operand_12, });

                break :block_22 @as(*const (zx_abi).zx_type_18, operand_21);
            };
        };

        const operand_24 = (block_26: {
            const operand_25 = (value_5).frames;

            break :block_26 @as((zx_abi).zx_type_103, (if (((operand_25).len == 0)) .{ operand_25, null, } else .{ (operand_25)[0..((operand_25).len - 1)], (operand_25)[((operand_25).len - 1)], }));
        }).@"0";

        break :block_29 block_28: {
            const operand_27 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_27).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_24, .result = (operand_1).result, .scratch = operand_2, });

            break :block_28 @as(*const (zx_abi).zx_type_82, operand_27);
        };
    };
}

fn function_47_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_149: {
        const operand_148 = (in).frames;

        break :block_149 (try function_19(allocator, operand_148));
    };

    const value_2: []const u32 = block_147: {
        const operand_138 = ((in).scratch).types;

        const operand_140 = (block_139: {
            break :block_139 value_1;
        }).children;

        const operand_142 = (@as(u64, (((in).scratch).types).len) - (block_141: {
            break :block_141 value_1;
        }).children);

        const operand_144 = block_143: {
            break :block_143 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        if (((operand_140 > (operand_138).len) or (operand_142 > ((operand_138).len - operand_140)))) {
            return error.IndexOutOfBounds;
        }

        const operand_145 = @as(usize, @intCast(operand_140));
        const operand_146 = @as(usize, @intCast(operand_142));

        _ = (try ((std).math).add(usize, ((operand_138).len - operand_146), (operand_144).len));

        break :block_147 (operand_138)[operand_145..(operand_145 + operand_146)];
    };

    const value_3: []const []const u8 = block_137: {
        const operand_128 = ((in).scratch).names;

        const operand_130 = (block_129: {
            break :block_129 value_1;
        }).fields;

        const operand_132 = (@as(u64, (((in).scratch).names).len) - (block_131: {
            break :block_131 value_1;
        }).fields);

        const operand_134 = block_133: {
            break :block_133 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_130 > (operand_128).len) or (operand_132 > ((operand_128).len - operand_130)))) {
            return error.IndexOutOfBounds;
        }

        const operand_135 = @as(usize, @intCast(operand_130));
        const operand_136 = @as(usize, @intCast(operand_132));

        _ = (try ((std).math).add(usize, ((operand_128).len - operand_136), (operand_134).len));

        break :block_137 (operand_128)[operand_135..(operand_135 + operand_136)];
    };

    const value_4: bool = ((block_127: {
        break :block_127 value_1;
    }).operation == @as((zx_abi).zx_type_77, .Object));

    const value_5: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_126: {
        break :block_126 (try function_39_value(allocator, block_125: {
            const operand_99 = in;

            const operand_100 = block_124: {
                const operand_101 = (if (block_102: {
                    break :block_102 value_4;
                }) @as((zx_abi).zx_type_11, .Object) else @as((zx_abi).zx_type_11, .Tuple));

                const operand_103 = @as(u32, 0);
                const operand_104 = @as(u32, 0);
                const operand_105 = @as([]const u8, "");

                const operand_106 = (if (block_107: {
                    break :block_107 value_4;
                }) block_108: {
                    break :block_108 (try (allocator).dupe(u32, (&[_]u32{})));
                } else block_109: {
                    break :block_109 value_2;
                });

                const operand_110 = block_121: {
                    const operand_111 = (if (block_112: {
                        break :block_112 value_4;
                    }) block_113: {
                        break :block_113 value_3;
                    } else block_114: {
                        break :block_114 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    });

                    const operand_115 = (if (block_116: {
                        break :block_116 value_4;
                    }) block_117: {
                        break :block_117 value_2;
                    } else block_118: {
                        break :block_118 (try (allocator).dupe(u32, (&[_]u32{})));
                    });

                    break :block_121 block_120: {
                        const operand_119 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_119).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_111, .types = operand_115, });

                        break :block_120 @as(*const (zx_abi).zx_type_18, operand_119);
                    };
                };
                const operand_122 = block_123: {
                    break :block_123 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                break :block_124 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_101, .first = operand_103, .second = operand_104, .label = operand_105, .children = operand_106, .fields = operand_110, .names = operand_122, });
            };

            break :block_125 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_99, .candidate = operand_100, });
        }));
    };

    return block_98: {
        const operand_70 = value_5;
        const operand_71 = block_94: {
            const operand_72 = block_81: {
                const operand_73 = ((in).scratch).types;
                const operand_74 = @as(u64, 0);

                const operand_76 = (block_75: {
                    break :block_75 value_1;
                }).children;

                const operand_78 = block_77: {
                    break :block_77 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                if (((operand_74 > (operand_73).len) or (operand_76 > ((operand_73).len - operand_74)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_79 = @as(usize, @intCast(operand_74));
                const operand_80 = @as(usize, @intCast(operand_76));

                _ = (try ((std).math).add(usize, ((operand_73).len - operand_80), (operand_78).len));

                break :block_81 (operand_73)[operand_79..(operand_79 + operand_80)];
            };
            const operand_82 = block_91: {
                const operand_83 = ((in).scratch).names;
                const operand_84 = @as(u64, 0);

                const operand_86 = (block_85: {
                    break :block_85 value_1;
                }).fields;

                const operand_88 = block_87: {
                    break :block_87 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                if (((operand_84 > (operand_83).len) or (operand_86 > ((operand_83).len - operand_84)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_89 = @as(usize, @intCast(operand_84));
                const operand_90 = @as(usize, @intCast(operand_86));
                _ = (try ((std).math).add(usize, ((operand_83).len - operand_90), (operand_88).len));

                break :block_91 (operand_83)[operand_89..(operand_89 + operand_90)];
            };

            break :block_94 block_93: {
                const operand_92 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_92).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_72, .names = operand_82, });

                break :block_93 @as(*const (zx_abi).zx_type_18, operand_92);
            };
        };

        const operand_95 = (block_97: {
            const operand_96 = (value_5).frames;

            break :block_97 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_96).len == 0)) .{ operand_96, null, null, } else .{ (operand_96)[0..((operand_96).len - 1)], (operand_96)[((operand_96).len - 1)], null, }));
        }).@"0";

        break :block_98 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_70).active, .cache = (operand_70).cache, .context = (operand_70).context, .delta = (operand_70).delta, .diagnostic = (operand_70).diagnostic, .frames = operand_95, .result = (operand_70).result, .scratch = operand_71, });
    };
}

fn function_47_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_229: {
        const operand_228 = (in).frames;

        break :block_229 (try function_19(allocator, operand_228));
    };

    const value_2: []const u32 = block_227: {
        const operand_218 = ((in).scratch).types;

        const operand_220 = (block_219: {
            break :block_219 value_1;
        }).children;

        const operand_222 = (@as(u64, (((in).scratch).types).len) - (block_221: {
            break :block_221 value_1;
        }).children);

        const operand_224 = block_223: {
            break :block_223 (try (allocator).dupe(u32, (&[_]u32{})));
        };

        if (((operand_220 > (operand_218).len) or (operand_222 > ((operand_218).len - operand_220)))) {
            return error.IndexOutOfBounds;
        }

        const operand_225 = @as(usize, @intCast(operand_220));
        const operand_226 = @as(usize, @intCast(operand_222));

        _ = (try ((std).math).add(usize, ((operand_218).len - operand_226), (operand_224).len));

        break :block_227 (operand_218)[operand_225..(operand_225 + operand_226)];
    };

    const value_3: []const []const u8 = block_217: {
        const operand_208 = ((in).scratch).names;

        const operand_210 = (block_209: {
            break :block_209 value_1;
        }).fields;

        const operand_212 = (@as(u64, (((in).scratch).names).len) - (block_211: {
            break :block_211 value_1;
        }).fields);

        const operand_214 = block_213: {
            break :block_213 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_210 > (operand_208).len) or (operand_212 > ((operand_208).len - operand_210)))) {
            return error.IndexOutOfBounds;
        }

        const operand_215 = @as(usize, @intCast(operand_210));
        const operand_216 = @as(usize, @intCast(operand_212));

        _ = (try ((std).math).add(usize, ((operand_208).len - operand_216), (operand_214).len));

        break :block_217 (operand_208)[operand_215..(operand_215 + operand_216)];
    };

    const value_4: bool = ((block_207: {
        break :block_207 value_1;
    }).operation == @as((zx_abi).zx_type_77, .Object));

    const value_5: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_206: {
        break :block_206 (try function_39_buffered(allocator, block_205: {
            const operand_179 = in;

            const operand_180 = block_204: {
                const operand_181 = (if (block_182: {
                    break :block_182 value_4;
                }) @as((zx_abi).zx_type_11, .Object) else @as((zx_abi).zx_type_11, .Tuple));

                const operand_183 = @as(u32, 0);
                const operand_184 = @as(u32, 0);
                const operand_185 = @as([]const u8, "");

                const operand_186 = (if (block_187: {
                    break :block_187 value_4;
                }) block_188: {
                    break :block_188 (try (allocator).dupe(u32, (&[_]u32{})));
                } else block_189: {
                    break :block_189 value_2;
                });

                const operand_190 = block_201: {
                    const operand_191 = (if (block_192: {
                        break :block_192 value_4;
                    }) block_193: {
                        break :block_193 value_3;
                    } else block_194: {
                        break :block_194 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    });

                    const operand_195 = (if (block_196: {
                        break :block_196 value_4;
                    }) block_197: {
                        break :block_197 value_2;
                    } else block_198: {
                        break :block_198 (try (allocator).dupe(u32, (&[_]u32{})));
                    });

                    break :block_201 block_200: {
                        const operand_199 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_199).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_191, .types = operand_195, });

                        break :block_200 @as(*const (zx_abi).zx_type_18, operand_199);
                    };
                };
                const operand_202 = block_203: {
                    break :block_203 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                break :block_204 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_181, .first = operand_183, .second = operand_184, .label = operand_185, .children = operand_186, .fields = operand_190, .names = operand_202, });
            };

            break :block_205 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_179, .candidate = operand_180, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = null, .lane_35 = null, }));
    });

    return block_178: {
        const operand_150 = value_5;
        const operand_151 = block_174: {
            const operand_152 = block_161: {
                const operand_153 = ((in).scratch).types;
                const operand_154 = @as(u64, 0);

                const operand_156 = (block_155: {
                    break :block_155 value_1;
                }).children;

                const operand_158 = block_157: {
                    break :block_157 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                if (((operand_154 > (operand_153).len) or (operand_156 > ((operand_153).len - operand_154)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_159 = @as(usize, @intCast(operand_154));
                const operand_160 = @as(usize, @intCast(operand_156));

                _ = (try ((std).math).add(usize, ((operand_153).len - operand_160), (operand_158).len));

                break :block_161 (operand_153)[operand_159..(operand_159 + operand_160)];
            };
            const operand_162 = block_171: {
                const operand_163 = ((in).scratch).names;
                const operand_164 = @as(u64, 0);

                const operand_166 = (block_165: {
                    break :block_165 value_1;
                }).fields;

                const operand_168 = block_167: {
                    break :block_167 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                if (((operand_164 > (operand_163).len) or (operand_166 > ((operand_163).len - operand_164)))) {
                    return error.IndexOutOfBounds;
                }

                const operand_169 = @as(usize, @intCast(operand_164));
                const operand_170 = @as(usize, @intCast(operand_166));

                _ = (try ((std).math).add(usize, ((operand_163).len - operand_170), (operand_168).len));

                break :block_171 (operand_163)[operand_169..(operand_169 + operand_170)];
            };

            break :block_174 block_173: {
                const operand_172 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_172).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_152, .names = operand_162, });

                break :block_173 @as(*const (zx_abi).zx_type_18, operand_172);
            };
        };

        const operand_175 = (block_177: {
            const operand_176 = (value_5).frames;

            break :block_177 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_176).len == 0)) .{ operand_176, null, null, } else .{ (operand_176)[0..((operand_176).len - 1)], (operand_176)[((operand_176).len - 1)], null, }));
        }).@"0";

        break :block_178 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_150).active, .cache = (operand_150).cache, .context = (operand_150).context, .delta = (operand_150).delta, .diagnostic = (operand_150).diagnostic, .frames = operand_175, .result = (operand_150).result, .scratch = operand_151, });
    };
}

fn function_48(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_138) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_63 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return block_25: {
            const operand_23 = (value_1.?).fields;
            const operand_24 = ((in).position - @as(u64, 1));

            if ((operand_24 >= (operand_23).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_25 (operand_23)[@intCast(operand_24)];
        };
    }

    const value_2: *const (zx_abi).zx_type_42 = block_22: {
        const operand_20 = ((((in).source).indexed).types).fields;
        const operand_21 = ((in).position - @as(u64, 1));

        if ((operand_21 >= (operand_20).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_22 (operand_20)[@intCast(operand_21)];
    };

    return block_19: {
        const operand_1 = (try function_11(allocator, block_6: {
            const operand_2 = (((in).source).indexed).bytes;
            const operand_3 = (value_2).name;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_4).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_2, .span = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_87, operand_4);
            };
        }));

        const operand_7 = block_12: {
            const operand_8 = false;
            const operand_9 = (value_2).value;

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_10).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_8, .index = operand_9, });

                break :block_11 @as(*const (zx_abi).zx_type_61, operand_10);
            };
        };
        const operand_13 = block_16: {
            const operand_14 = ((((in).source).indexed).order).fields;
            const operand_15 = ((in).position - @as(u64, 1));

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        break :block_19 block_18: {
            const operand_17 = (try (allocator).create((zx_abi).zx_type_63));

            (operand_17).* = @as((zx_abi).zx_type_63, (zx_abi).zx_type_63{ .name = operand_1, .value = operand_7, .next = operand_13, });

            break :block_18 @as(*const (zx_abi).zx_type_63, operand_17);
        };
    };
}

fn function_48_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_138) error{ IndexOutOfBounds, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).zx_type_63 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return (block_48: {
            const operand_46 = (value_1.?).fields;
            const operand_47 = ((in).position - @as(u64, 1));

            if ((operand_47 >= (operand_46).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_48 (operand_46)[@intCast(operand_47)];
        }).*;
    }

    const value_2: (zx_abi).zx_type_42 = (block_45: {
        const operand_43 = ((((in).source).indexed).types).fields;
        const operand_44 = ((in).position - @as(u64, 1));

        if ((operand_44 >= (operand_43).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_45 (operand_43)[@intCast(operand_44)];
    }).*;

    return block_42: {
        const operand_26 = (try function_11(allocator, block_31: {
            const operand_27 = (((in).source).indexed).bytes;
            const operand_28 = ((&value_2)).name;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_87));

                (operand_29).* = @as((zx_abi).zx_type_87, (zx_abi).zx_type_87{ .source = operand_27, .span = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_87, operand_29);
            };
        }));

        const operand_32 = block_37: {
            const operand_33 = false;
            const operand_34 = ((&value_2)).value;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_35).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_33, .index = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_61, operand_35);
            };
        };
        const operand_38 = block_41: {
            const operand_39 = ((((in).source).indexed).order).fields;
            const operand_40 = ((in).position - @as(u64, 1));

            if ((operand_40 >= (operand_39).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_41 (operand_39)[@intCast(operand_40)];
        };

        break :block_42 (zx_abi).zx_type_63{ .name = operand_26, .value = operand_32, .next = operand_38, };
    };
}

fn function_49(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    if (((value_1).waiting and ((in).result == @as(u32, 0)))) {
        return (try function_4(allocator, block_93: {
            const operand_87 = in;
            const operand_88 = @as([]const u8, "type_mismatch");
            const operand_89 = @as([]const u8, "object fields cannot have type void");
            const operand_90 = (value_1).name;

            break :block_93 block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_91).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_87, .code = operand_88, .message = operand_89, .name = operand_90, });

                break :block_92 @as(*const (zx_abi).zx_type_86, operand_91);
            };
        }));
    }

    const value_2: *const (zx_abi).zx_type_82 = (if ((value_1).waiting) (try function_44(allocator, block_86: {
        const operand_58 = block_76: {
            const operand_59 = in;
            const operand_60 = block_73: {
                const operand_61 = (block_65: {
                    const operand_62 = ((in).scratch).types;
                    const operand_63 = (in).result;
                    const operand_64 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_62).len, 1))));

                    @memcpy((operand_64)[0..(operand_62).len], operand_62);

                    (operand_64)[(operand_62).len] = operand_63;

                    break :block_65 @as((zx_abi).zx_type_99, .{ operand_64, {}, });
                }).@"0";
                const operand_66 = (block_70: {
                    const operand_67 = ((in).scratch).names;
                    const operand_68 = ((value_1).name).text;
                    const operand_69 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_67).len, 1))));

                    @memcpy((operand_69)[0..(operand_67).len], operand_67);

                    (operand_69)[(operand_67).len] = operand_68;

                    break :block_70 @as((zx_abi).zx_type_98, .{ operand_69, {}, });
                }).@"0";

                break :block_73 block_72: {
                    const operand_71 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_71).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_61, .names = operand_66, });

                    break :block_72 @as(*const (zx_abi).zx_type_18, operand_71);
                };
            };

            break :block_76 block_75: {
                const operand_74 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_74).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_59).active, .cache = (operand_59).cache, .context = (operand_59).context, .delta = (operand_59).delta, .diagnostic = (operand_59).diagnostic, .frames = (operand_59).frames, .result = (operand_59).result, .scratch = operand_60, });

                break :block_75 @as(*const (zx_abi).zx_type_82, operand_74);
            };
        };
        const operand_77 = block_83: {
            const operand_78 = value_1;
            const operand_79 = ((value_1).index + @as(u64, 1));
            const operand_80 = false;

            break :block_83 block_82: {
                const operand_81 = (try (allocator).create((zx_abi).zx_type_80));

                (operand_81).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_78).children, .count = (operand_78).count, .declaration = (operand_78).declaration, .fields = (operand_78).fields, .index = operand_79, .list = (operand_78).list, .name = (operand_78).name, .operation = (operand_78).operation, .position = (operand_78).position, .reference = (operand_78).reference, .waiting = operand_80, });

                break :block_82 @as(*const (zx_abi).zx_type_80, operand_81);
            };
        };

        break :block_86 block_85: {
            const operand_84 = (try (allocator).create((zx_abi).zx_type_135));

            (operand_84).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_58, .frame = operand_77, });

            break :block_85 @as(*const (zx_abi).zx_type_135, operand_84);
        };
    })) else in);

    const value_3: *const (zx_abi).zx_type_80 = (try function_19(allocator, (value_2).frames));

    if (((value_3).index == (value_3).count)) {
        return (try function_47(allocator, value_2));
    }

    const value_4: *const (zx_abi).zx_type_63 = (try function_48(allocator, block_57: {
        const operand_53 = ((value_2).context).source;
        const operand_54 = (value_3).position;

        break :block_57 block_56: {
            const operand_55 = (try (allocator).create((zx_abi).zx_type_138));

            (operand_55).* = @as((zx_abi).zx_type_138, (zx_abi).zx_type_138{ .source = operand_53, .position = operand_54, });

            break :block_56 @as(*const (zx_abi).zx_type_138, operand_55);
        };
    }));

    const value_5: []const []const u8 = block_52: {
        const operand_45 = ((value_2).scratch).names;
        const operand_46 = (value_3).fields;
        const operand_47 = (@as(u64, (((value_2).scratch).names).len) - (value_3).fields);

        const operand_49 = block_48: {
            break :block_48 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_46 > (operand_45).len) or (operand_47 > ((operand_45).len - operand_46)))) {
            return error.IndexOutOfBounds;
        }

        const operand_50 = @as(usize, @intCast(operand_46));
        const operand_51 = @as(usize, @intCast(operand_47));

        _ = (try ((std).math).add(usize, ((operand_45).len - operand_51), (operand_49).len));

        break :block_52 (operand_45)[operand_50..(operand_50 + operand_51)];
    };

    if (block_37: {
        const operand_34 = value_5;
        const operand_35 = ((value_4).name).text;
        const operand_36 = (zx_abi).zx_type_94{ .names = operand_34, .name = operand_35, };

        break :block_37 (try function_15(allocator, (&operand_36)));
    }) {
        return (try function_4(allocator, block_44: {
            const operand_38 = value_2;
            const operand_39 = @as([]const u8, "name");
            const operand_40 = @as([]const u8, "duplicate object field");
            const operand_41 = (value_4).name;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_86));

                (operand_42).* = @as((zx_abi).zx_type_86, (zx_abi).zx_type_86{ .state = operand_38, .code = operand_39, .message = operand_40, .name = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_86, operand_42);
            };
        }));
    }

    const value_6: *const (zx_abi).zx_type_82 = (try function_44(allocator, block_33: {
        const operand_22 = value_2;

        const operand_23 = block_30: {
            const operand_24 = value_3;
            const operand_25 = (value_4).name;
            const operand_26 = (value_4).next;
            const operand_27 = true;

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_80));

                (operand_28).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_24).children, .count = (operand_24).count, .declaration = (operand_24).declaration, .fields = (operand_24).fields, .index = (operand_24).index, .list = (operand_24).list, .name = operand_25, .operation = (operand_24).operation, .position = operand_26, .reference = (operand_24).reference, .waiting = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_80, operand_28);
            };
        };

        break :block_33 block_32: {
            const operand_31 = (try (allocator).create((zx_abi).zx_type_135));

            (operand_31).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_22, .frame = operand_23, });

            break :block_32 @as(*const (zx_abi).zx_type_135, operand_31);
        };
    }));

    const value_7: *const (zx_abi).zx_type_80 = (try function_2(allocator, block_21: {
        const operand_10 = @as((zx_abi).zx_type_77, .Node);

        const operand_11 = block_17: {
            const operand_12 = @as([]const u8, "");
            const operand_13 = @as(u64, 0);
            const operand_14 = @as(u64, 0);

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_15).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_12, .start = operand_13, .end = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_60, operand_15);
            };
        };

        const operand_18 = (value_4).value;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_85));

            (operand_19).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_10, .name = operand_11, .reference = operand_18, });

            break :block_20 @as(*const (zx_abi).zx_type_85, operand_19);
        };
    }));

    return block_9: {
        const operand_1 = value_6;

        const operand_2 = (block_6: {
            const operand_3 = (value_6).frames;
            const operand_4 = value_7;
            const operand_5 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_3).len, 1))));

            @memcpy((operand_5)[0..(operand_3).len], operand_3);

            (operand_5)[(operand_3).len] = operand_4;

            break :block_6 @as((zx_abi).zx_type_136, .{ operand_5, {}, });
        }).@"0";

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_7).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_2, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_8 @as(*const (zx_abi).zx_type_82, operand_7);
        };
    };
}

fn function_49_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_205: {
        const operand_204 = (in).frames;

        break :block_205 (try function_19(allocator, operand_204));
    };

    if (((block_196: {
        break :block_196 value_1;
    }).waiting and ((in).result == @as(u32, 0)))) {
        return block_203: {
            break :block_203 (try function_4_value(allocator, block_202: {
                const operand_197 = in;
                const operand_198 = @as([]const u8, "type_mismatch");
                const operand_199 = @as([]const u8, "object fields cannot have type void");

                const operand_200 = (block_201: {
                    break :block_201 value_1;
                }).name;

                break :block_202 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_197, .code = operand_198, .message = operand_199, .name = operand_200, });
            }));
        };
    }

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if ((block_166: {
        break :block_166 value_1;
    }).waiting) block_195: {
        break :block_195 (try function_44_value(allocator, block_194: {
            const operand_167 = block_184: {
                const operand_168 = in;
                const operand_169 = block_183: {
                    const operand_170 = (block_174: {
                        const operand_171 = ((in).scratch).types;
                        const operand_172 = (in).result;
                        const operand_173 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_171).len, 1))));

                        @memcpy((operand_173)[0..(operand_171).len], operand_171);
                        (operand_173)[(operand_171).len] = operand_172;

                        break :block_174 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_173, {}, null, });
                    }).@"0";
                    const operand_175 = (block_180: {
                        const operand_176 = ((in).scratch).names;

                        const operand_178 = ((block_177: {
                            break :block_177 value_1;
                        }).name).text;

                        const operand_179 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_176).len, 1))));

                        @memcpy((operand_179)[0..(operand_176).len], operand_176);

                        (operand_179)[(operand_176).len] = operand_178;

                        break :block_180 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_179, {}, null, });
                    }).@"0";

                    break :block_183 block_182: {
                        const operand_181 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_181).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_170, .names = operand_175, });

                        break :block_182 @as(*const (zx_abi).zx_type_18, operand_181);
                    };
                };

                break :block_184 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_168).active, .cache = (operand_168).cache, .context = (operand_168).context, .delta = (operand_168).delta, .diagnostic = (operand_168).diagnostic, .frames = (operand_168).frames, .result = (operand_168).result, .scratch = operand_169, });
            };

            const operand_185 = block_193: {
                const operand_186 = block_187: {
                    break :block_187 value_1;
                };
                const operand_188 = ((block_189: {
                    break :block_189 value_1;
                }).index + @as(u64, 1));

                const operand_190 = false;

                break :block_193 block_192: {
                    const operand_191 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_191).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_186).children, .count = (operand_186).count, .declaration = (operand_186).declaration, .fields = (operand_186).fields, .index = operand_188, .list = (operand_186).list, .name = (operand_186).name, .operation = (operand_186).operation, .position = (operand_186).position, .reference = (operand_186).reference, .waiting = operand_190, });

                    break :block_192 @as(*const (zx_abi).zx_type_80, operand_191);
                };
            };

            break :block_194 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_167, .frame = operand_185, });
        }));
    } else in);

    const value_3: *const (zx_abi).zx_type_80 = block_165: {
        const operand_164 = (value_2).frames;

        break :block_165 (try function_19(allocator, operand_164));
    };

    if (((block_161: {
        break :block_161 value_3;
    }).index == (block_162: {
        break :block_162 value_3;
    }).count)) {
        return block_163: {
            break :block_163 (try function_47_value(allocator, value_2));
        };
    }

    const value_4: *const (zx_abi).zx_type_63 = block_160: {
        const operand_157 = block_156: {
            const operand_153 = ((value_2).context).source;

            const operand_154 = (block_155: {
                break :block_155 value_3;
            }).position;

            break :block_156 @as((zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_153, .position = operand_154, });
        };

        break :block_160 (try function_48(allocator, (if (((operand_157).zx_origin != null)) (operand_157).zx_origin.? else block_159: {
            const operand_158 = (try (allocator).create((zx_abi).zx_type_138));

            (operand_158).* = (zx_abi).zx_type_138{ .position = (operand_157).position, .source = (operand_157).source, };

            break :block_159 @as(*const (zx_abi).zx_type_138, operand_158);
        })));
    };

    const value_5: []const []const u8 = block_152: {
        const operand_143 = ((value_2).scratch).names;

        const operand_145 = (block_144: {
            break :block_144 value_3;
        }).fields;

        const operand_147 = (@as(u64, (((value_2).scratch).names).len) - (block_146: {
            break :block_146 value_3;
        }).fields);

        const operand_149 = block_148: {
            break :block_148 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_145 > (operand_143).len) or (operand_147 > ((operand_143).len - operand_145)))) {
            return error.IndexOutOfBounds;
        }

        const operand_150 = @as(usize, @intCast(operand_145));
        const operand_151 = @as(usize, @intCast(operand_147));

        _ = (try ((std).math).add(usize, ((operand_143).len - operand_151), (operand_149).len));

        break :block_152 (operand_143)[operand_150..(operand_150 + operand_151)];
    };

    if (block_135: {
        const operand_131 = block_130: {
            break :block_130 value_5;
        };

        const operand_133 = ((block_132: {
            break :block_132 value_4;
        }).name).text;

        const operand_134 = (zx_abi).zx_type_94{ .names = operand_131, .name = operand_133, };

        break :block_135 (try function_15(allocator, (&operand_134)));
    }) {
        return block_142: {
            break :block_142 (try function_4_value(allocator, block_141: {
                const operand_136 = value_2;
                const operand_137 = @as([]const u8, "name");
                const operand_138 = @as([]const u8, "duplicate object field");

                const operand_139 = (block_140: {
                    break :block_140 value_4;
                }).name;

                break :block_141 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_136, .code = operand_137, .message = operand_138, .name = operand_139, });
            }));
        };
    }

    const value_6: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_129: {
        break :block_129 (try function_44_value(allocator, block_128: {
            const operand_116 = value_2;

            const operand_117 = block_127: {
                const operand_118 = block_119: {
                    break :block_119 value_3;
                };
                const operand_120 = (block_121: {
                    break :block_121 value_4;
                }).name;

                const operand_122 = (block_123: {
                    break :block_123 value_4;
                }).next;

                const operand_124 = true;

                break :block_127 block_126: {
                    const operand_125 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_125).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_118).children, .count = (operand_118).count, .declaration = (operand_118).declaration, .fields = (operand_118).fields, .index = (operand_118).index, .list = (operand_118).list, .name = operand_120, .operation = (operand_118).operation, .position = operand_122, .reference = (operand_118).reference, .waiting = operand_124, });

                    break :block_126 @as(*const (zx_abi).zx_type_80, operand_125);
                };
            };

            break :block_128 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_116, .frame = operand_117, });
        }));
    };

    const value_7: *const (zx_abi).zx_type_80 = block_115: {
        const operand_113 = block_112: {
            const operand_102 = @as((zx_abi).zx_type_77, .Node);

            const operand_103 = block_109: {
                const operand_104 = @as([]const u8, "");
                const operand_105 = @as(u64, 0);
                const operand_106 = @as(u64, 0);

                break :block_109 block_108: {
                    const operand_107 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_107).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_104, .start = operand_105, .end = operand_106, });

                    break :block_108 @as(*const (zx_abi).zx_type_60, operand_107);
                };
            };

            const operand_110 = (block_111: {
                break :block_111 value_4;
            }).value;

            break :block_112 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_102, .name = operand_103, .reference = operand_110, });
        };

        var state_borrow_114: (zx_abi).zx_type_85 = undefined;

        state_borrow_114 = (zx_abi).zx_type_85{ .name = (operand_113).name, .operation = (operand_113).operation, .reference = (operand_113).reference, };

        break :block_115 (try function_2(allocator, ((operand_113).zx_origin orelse (&state_borrow_114))));
    };

    return block_101: {
        const operand_94 = value_6;

        const operand_95 = (block_100: {
            const operand_96 = (value_6).frames;

            const operand_98 = block_97: {
                break :block_97 value_7;
            };

            const operand_99 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_96).len, 1))));

            @memcpy((operand_99)[0..(operand_96).len], operand_96);

            (operand_99)[(operand_96).len] = operand_98;

            break :block_100 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_99, {}, null, });
        }).@"0";

        break :block_101 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_94).active, .cache = (operand_94).cache, .context = (operand_94).context, .delta = (operand_94).delta, .diagnostic = (operand_94).diagnostic, .frames = operand_95, .result = (operand_94).result, .scratch = (operand_94).scratch, });
    };
}

fn function_49_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_328: {
        const operand_327 = (in).frames;

        break :block_328 (try function_19(allocator, operand_327));
    };

    if (((block_319: {
        break :block_319 value_1;
    }).waiting and ((in).result == @as(u32, 0)))) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_326: {
            break :block_326 (try function_4_buffered(allocator, block_325: {
                const operand_320 = in;
                const operand_321 = @as([]const u8, "type_mismatch");
                const operand_322 = @as([]const u8, "object fields cannot have type void");

                const operand_323 = (block_324: {
                    break :block_324 value_1;
                }).name;

                break :block_325 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_320, .code = operand_321, .message = operand_322, .name = operand_323, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if ((block_282: {
        break :block_282 value_1;
    }).waiting) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_318: {
        break :block_318 (try function_44_buffered(allocator, block_317: {
            const operand_283 = block_307: {
                const operand_284 = in;
                const operand_285 = block_306: {
                    const operand_286 = @as([]const u32, (if (((buffers).lane_35 != null)) block_289: {
                        const operand_287 = ((in).scratch).types;
                        const operand_288 = (in).result;
                        _ = (try ((std).math).add(usize, (operand_287).len, 1));

                        if ((!(((buffers).lane_35.?).started).*)) {
                            (try ((((buffers).lane_35.?).buffer).*).appendSlice(allocator, operand_287));
                            (((buffers).lane_35.?).started).* = true;
                        } else {
                            (((((buffers).lane_35.?).buffer).*).items).len = (operand_287).len;
                        }

                        (try ((((buffers).lane_35.?).buffer).*).append(allocator, operand_288));

                        break :block_289 ((((buffers).lane_35.?).buffer).*).items;
                    } else (block_293: {
                        const operand_290 = ((in).scratch).types;
                        const operand_291 = (in).result;
                        const operand_292 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_290).len, 1))));

                        @memcpy((operand_292)[0..(operand_290).len], operand_290);
                        (operand_292)[(operand_290).len] = operand_291;

                        break :block_293 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_292, {}, null, });
                    }).@"0"));

                    const operand_294 = @as([]const []const u8, (if (((buffers).lane_34 != null)) block_298: {
                        const operand_295 = ((in).scratch).names;

                        const operand_297 = ((block_296: {
                            break :block_296 value_1;
                        }).name).text;

                        _ = (try ((std).math).add(usize, (operand_295).len, 1));

                        if ((!(((buffers).lane_34.?).started).*)) {
                            (try ((((buffers).lane_34.?).buffer).*).appendSlice(allocator, operand_295));
                            (((buffers).lane_34.?).started).* = true;
                        } else {
                            (((((buffers).lane_34.?).buffer).*).items).len = (operand_295).len;
                        }

                        (try ((((buffers).lane_34.?).buffer).*).append(allocator, operand_297));

                        break :block_298 ((((buffers).lane_34.?).buffer).*).items;
                    } else (block_303: {
                        const operand_299 = ((in).scratch).names;

                        const operand_301 = ((block_300: {
                            break :block_300 value_1;
                        }).name).text;

                        const operand_302 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_299).len, 1))));

                        @memcpy((operand_302)[0..(operand_299).len], operand_299);

                        (operand_302)[(operand_299).len] = operand_301;

                        break :block_303 @as((zx_abi).value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_302, {}, null, });
                    }).@"0"));

                    break :block_306 block_305: {
                        const operand_304 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_304).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .types = operand_286, .names = operand_294, });

                        break :block_305 @as(*const (zx_abi).zx_type_18, operand_304);
                    };
                };

                break :block_307 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_284).active, .cache = (operand_284).cache, .context = (operand_284).context, .delta = (operand_284).delta, .diagnostic = (operand_284).diagnostic, .frames = (operand_284).frames, .result = (operand_284).result, .scratch = operand_285, });
            };

            const operand_308 = block_316: {
                const operand_309 = block_310: {
                    break :block_310 value_1;
                };
                const operand_311 = ((block_312: {
                    break :block_312 value_1;
                }).index + @as(u64, 1));

                const operand_313 = false;

                break :block_316 block_315: {
                    const operand_314 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_314).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_309).children, .count = (operand_309).count, .declaration = (operand_309).declaration, .fields = (operand_309).fields, .index = operand_311, .list = (operand_309).list, .name = (operand_309).name, .operation = (operand_309).operation, .position = (operand_309).position, .reference = (operand_309).reference, .waiting = operand_313, });

                    break :block_315 @as(*const (zx_abi).zx_type_80, operand_314);
                };
            };

            break :block_317 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_283, .frame = operand_308, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    }) else in);

    const value_3: *const (zx_abi).zx_type_80 = block_281: {
        const operand_280 = (value_2).frames;

        break :block_281 (try function_19(allocator, operand_280));
    };

    if (((block_277: {
        break :block_277 value_3;
    }).index == (block_278: {
        break :block_278 value_3;
    }).count)) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_279: {
            break :block_279 (try function_47_buffered(allocator, value_2, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_4: *const (zx_abi).zx_type_63 = block_276: {
        const operand_273 = block_272: {
            const operand_269 = ((value_2).context).source;

            const operand_270 = (block_271: {
                break :block_271 value_3;
            }).position;

            break :block_272 @as((zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_269, .position = operand_270, });
        };

        break :block_276 (try function_48(allocator, (if (((operand_273).zx_origin != null)) (operand_273).zx_origin.? else block_275: {
            const operand_274 = (try (allocator).create((zx_abi).zx_type_138));

            (operand_274).* = (zx_abi).zx_type_138{ .position = (operand_273).position, .source = (operand_273).source, };

            break :block_275 @as(*const (zx_abi).zx_type_138, operand_274);
        })));
    };

    const value_5: []const []const u8 = block_268: {
        const operand_259 = ((value_2).scratch).names;

        const operand_261 = (block_260: {
            break :block_260 value_3;
        }).fields;

        const operand_263 = (@as(u64, (((value_2).scratch).names).len) - (block_262: {
            break :block_262 value_3;
        }).fields);

        const operand_265 = block_264: {
            break :block_264 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
        };

        if (((operand_261 > (operand_259).len) or (operand_263 > ((operand_259).len - operand_261)))) {
            return error.IndexOutOfBounds;
        }

        const operand_266 = @as(usize, @intCast(operand_261));
        const operand_267 = @as(usize, @intCast(operand_263));

        _ = (try ((std).math).add(usize, ((operand_259).len - operand_267), (operand_265).len));

        break :block_268 (operand_259)[operand_266..(operand_266 + operand_267)];
    };

    if (block_251: {
        const operand_247 = block_246: {
            break :block_246 value_5;
        };

        const operand_249 = ((block_248: {
            break :block_248 value_4;
        }).name).text;

        const operand_250 = (zx_abi).zx_type_94{ .names = operand_247, .name = operand_249, };

        break :block_251 (try function_15(allocator, (&operand_250)));
    }) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_258: {
            break :block_258 (try function_4_buffered(allocator, block_257: {
                const operand_252 = value_2;
                const operand_253 = @as([]const u8, "name");
                const operand_254 = @as([]const u8, "duplicate object field");

                const operand_255 = (block_256: {
                    break :block_256 value_4;
                }).name;

                break :block_257 @as((zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5, (zx_abi).value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5{ .state = operand_252, .code = operand_253, .message = operand_254, .name = operand_255, });
            }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_6: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_245: {
        break :block_245 (try function_44_buffered(allocator, block_244: {
            const operand_232 = value_2;

            const operand_233 = block_243: {
                const operand_234 = block_235: {
                    break :block_235 value_3;
                };
                const operand_236 = (block_237: {
                    break :block_237 value_4;
                }).name;

                const operand_238 = (block_239: {
                    break :block_239 value_4;
                }).next;

                const operand_240 = true;

                break :block_243 block_242: {
                    const operand_241 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_241).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_234).children, .count = (operand_234).count, .declaration = (operand_234).declaration, .fields = (operand_234).fields, .index = (operand_234).index, .list = (operand_234).list, .name = operand_236, .operation = (operand_234).operation, .position = operand_238, .reference = (operand_234).reference, .waiting = operand_240, });

                    break :block_242 @as(*const (zx_abi).zx_type_80, operand_241);
                };
            };

            break :block_244 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_232, .frame = operand_233, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });

    const value_7: *const (zx_abi).zx_type_80 = block_231: {
        const operand_229 = block_228: {
            const operand_218 = @as((zx_abi).zx_type_77, .Node);

            const operand_219 = block_225: {
                const operand_220 = @as([]const u8, "");
                const operand_221 = @as(u64, 0);
                const operand_222 = @as(u64, 0);

                break :block_225 block_224: {
                    const operand_223 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_223).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_220, .start = operand_221, .end = operand_222, });

                    break :block_224 @as(*const (zx_abi).zx_type_60, operand_223);
                };
            };

            const operand_226 = (block_227: {
                break :block_227 value_4;
            }).value;

            break :block_228 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_218, .name = operand_219, .reference = operand_226, });
        };

        var state_borrow_230: (zx_abi).zx_type_85 = undefined;

        state_borrow_230 = (zx_abi).zx_type_85{ .name = (operand_229).name, .operation = (operand_229).operation, .reference = (operand_229).reference, };

        break :block_231 (try function_2(allocator, ((operand_229).zx_origin orelse (&state_borrow_230))));
    };

    return block_217: {
        const operand_206 = value_6;

        const operand_207 = @as([]const *const (zx_abi).zx_type_80, (if (((buffers).lane_33 != null)) block_211: {
            const operand_208 = (value_6).frames;

            const operand_210 = block_209: {
                break :block_209 value_7;
            };

            _ = (try ((std).math).add(usize, (operand_208).len, 1));

            if ((!(((buffers).lane_33.?).started).*)) {
                (try ((((buffers).lane_33.?).buffer).*).appendSlice(allocator, operand_208));
                (((buffers).lane_33.?).started).* = true;
            } else {
                (((((buffers).lane_33.?).buffer).*).items).len = (operand_208).len;
            }

            (try ((((buffers).lane_33.?).buffer).*).append(allocator, operand_210));

            break :block_211 ((((buffers).lane_33.?).buffer).*).items;
        } else (block_216: {
            const operand_212 = (value_6).frames;

            const operand_214 = block_213: {
                break :block_213 value_7;
            };

            const operand_215 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_212).len, 1))));

            @memcpy((operand_215)[0..(operand_212).len], operand_212);

            (operand_215)[(operand_212).len] = operand_214;

            break :block_216 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_215, {}, null, });
        }).@"0"));

        break :block_217 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_206).active, .cache = (operand_206).cache, .context = (operand_206).context, .delta = (operand_206).delta, .diagnostic = (operand_206).diagnostic, .frames = operand_207, .result = (operand_206).result, .scratch = (operand_206).scratch, });
    };
}

fn function_50(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_138) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_64 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return block_19: {
            const operand_17 = (value_1.?).items;
            const operand_18 = ((in).position - @as(u64, 1));

            if ((operand_18 >= (operand_17).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_19 (operand_17)[@intCast(operand_18)];
        };
    }

    return block_16: {
        const operand_1 = block_9: {
            const operand_2 = false;

            const operand_3 = (block_6: {
                const operand_4 = ((((in).source).indexed).types).items;
                const operand_5 = ((in).position - @as(u64, 1));

                if ((operand_5 >= (operand_4).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_6 (operand_4)[@intCast(operand_5)];
            }).value;

            break :block_9 block_8: {
                const operand_7 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_7).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_2, .index = operand_3, });

                break :block_8 @as(*const (zx_abi).zx_type_61, operand_7);
            };
        };
        const operand_10 = block_13: {
            const operand_11 = ((((in).source).indexed).order).items;
            const operand_12 = ((in).position - @as(u64, 1));

            if ((operand_12 >= (operand_11).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_13 (operand_11)[@intCast(operand_12)];
        };

        break :block_16 block_15: {
            const operand_14 = (try (allocator).create((zx_abi).zx_type_64));

            (operand_14).* = @as((zx_abi).zx_type_64, (zx_abi).zx_type_64{ .value = operand_1, .next = operand_10, });

            break :block_15 @as(*const (zx_abi).zx_type_64, operand_14);
        };
    };
}

fn function_50_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_138) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_64 {
    @setRuntimeSafety(true);

    const value_1: ?*const (zx_abi).zx_type_73 = ((in).source).native;

    if ((value_1 != null)) {
        return (block_36: {
            const operand_34 = (value_1.?).items;
            const operand_35 = ((in).position - @as(u64, 1));

            if ((operand_35 >= (operand_34).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_36 (operand_34)[@intCast(operand_35)];
        }).*;
    }

    return block_33: {
        const operand_20 = block_28: {
            const operand_21 = false;

            const operand_22 = (block_25: {
                const operand_23 = ((((in).source).indexed).types).items;
                const operand_24 = ((in).position - @as(u64, 1));

                if ((operand_24 >= (operand_23).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_25 (operand_23)[@intCast(operand_24)];
            }).value;

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_61));

                (operand_26).* = @as((zx_abi).zx_type_61, (zx_abi).zx_type_61{ .enumeration = operand_21, .index = operand_22, });

                break :block_27 @as(*const (zx_abi).zx_type_61, operand_26);
            };
        };
        const operand_29 = block_32: {
            const operand_30 = ((((in).source).indexed).order).items;
            const operand_31 = ((in).position - @as(u64, 1));

            if ((operand_31 >= (operand_30).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_32 (operand_30)[@intCast(operand_31)];
        };

        break :block_33 (zx_abi).zx_type_64{ .value = operand_20, .next = operand_29, };
    };
}

fn function_51(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    const value_2: *const (zx_abi).zx_type_82 = (if ((value_1).waiting) (try function_44(allocator, block_62: {
        const operand_38 = block_52: {
            const operand_39 = in;
            const operand_40 = block_49: {
                const operand_41 = (in).scratch;

                const operand_42 = (block_46: {
                    const operand_43 = ((in).scratch).types;
                    const operand_44 = (in).result;
                    const operand_45 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_43).len, 1))));

                    @memcpy((operand_45)[0..(operand_43).len], operand_43);

                    (operand_45)[(operand_43).len] = operand_44;

                    break :block_46 @as((zx_abi).zx_type_99, .{ operand_45, {}, });
                }).@"0";

                break :block_49 block_48: {
                    const operand_47 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_47).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (operand_41).names, .types = operand_42, });

                    break :block_48 @as(*const (zx_abi).zx_type_18, operand_47);
                };
            };

            break :block_52 block_51: {
                const operand_50 = (try (allocator).create((zx_abi).zx_type_82));
                (operand_50).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_39).active, .cache = (operand_39).cache, .context = (operand_39).context, .delta = (operand_39).delta, .diagnostic = (operand_39).diagnostic, .frames = (operand_39).frames, .result = (operand_39).result, .scratch = operand_40, });

                break :block_51 @as(*const (zx_abi).zx_type_82, operand_50);
            };
        };
        const operand_53 = block_59: {
            const operand_54 = value_1;
            const operand_55 = ((value_1).index + @as(u64, 1));
            const operand_56 = false;

            break :block_59 block_58: {
                const operand_57 = (try (allocator).create((zx_abi).zx_type_80));

                (operand_57).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_54).children, .count = (operand_54).count, .declaration = (operand_54).declaration, .fields = (operand_54).fields, .index = operand_55, .list = (operand_54).list, .name = (operand_54).name, .operation = (operand_54).operation, .position = (operand_54).position, .reference = (operand_54).reference, .waiting = operand_56, });

                break :block_58 @as(*const (zx_abi).zx_type_80, operand_57);
            };
        };

        break :block_62 block_61: {
            const operand_60 = (try (allocator).create((zx_abi).zx_type_135));

            (operand_60).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_38, .frame = operand_53, });

            break :block_61 @as(*const (zx_abi).zx_type_135, operand_60);
        };
    })) else in);

    const value_3: *const (zx_abi).zx_type_80 = (try function_19(allocator, (value_2).frames));

    if (((value_3).index == (value_3).count)) {
        return (try function_47(allocator, value_2));
    }

    const value_4: *const (zx_abi).zx_type_64 = (try function_50(allocator, block_37: {
        const operand_33 = ((value_2).context).source;
        const operand_34 = (value_3).position;

        break :block_37 block_36: {
            const operand_35 = (try (allocator).create((zx_abi).zx_type_138));

            (operand_35).* = @as((zx_abi).zx_type_138, (zx_abi).zx_type_138{ .source = operand_33, .position = operand_34, });

            break :block_36 @as(*const (zx_abi).zx_type_138, operand_35);
        };
    }));

    const value_5: *const (zx_abi).zx_type_82 = (try function_44(allocator, block_32: {
        const operand_22 = value_2;

        const operand_23 = block_29: {
            const operand_24 = value_3;
            const operand_25 = (value_4).next;
            const operand_26 = true;

            break :block_29 block_28: {
                const operand_27 = (try (allocator).create((zx_abi).zx_type_80));

                (operand_27).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_24).children, .count = (operand_24).count, .declaration = (operand_24).declaration, .fields = (operand_24).fields, .index = (operand_24).index, .list = (operand_24).list, .name = (operand_24).name, .operation = (operand_24).operation, .position = operand_25, .reference = (operand_24).reference, .waiting = operand_26, });

                break :block_28 @as(*const (zx_abi).zx_type_80, operand_27);
            };
        };

        break :block_32 block_31: {
            const operand_30 = (try (allocator).create((zx_abi).zx_type_135));

            (operand_30).* = @as((zx_abi).zx_type_135, (zx_abi).zx_type_135{ .state = operand_22, .frame = operand_23, });

            break :block_31 @as(*const (zx_abi).zx_type_135, operand_30);
        };
    }));

    const value_6: *const (zx_abi).zx_type_80 = (try function_2(allocator, block_21: {
        const operand_10 = @as((zx_abi).zx_type_77, .Node);

        const operand_11 = block_17: {
            const operand_12 = @as([]const u8, "");
            const operand_13 = @as(u64, 0);
            const operand_14 = @as(u64, 0);

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_60));

                (operand_15).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_12, .start = operand_13, .end = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_60, operand_15);
            };
        };

        const operand_18 = (value_4).value;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_85));

            (operand_19).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_10, .name = operand_11, .reference = operand_18, });

            break :block_20 @as(*const (zx_abi).zx_type_85, operand_19);
        };
    }));

    return block_9: {
        const operand_1 = value_5;

        const operand_2 = (block_6: {
            const operand_3 = (value_5).frames;
            const operand_4 = value_6;
            const operand_5 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_3).len, 1))));

            @memcpy((operand_5)[0..(operand_3).len], operand_3);

            (operand_5)[(operand_3).len] = operand_4;

            break :block_6 @as((zx_abi).zx_type_136, .{ operand_5, {}, });
        }).@"0";

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_7).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_2, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_8 @as(*const (zx_abi).zx_type_82, operand_7);
        };
    };
}

fn function_51_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_135: {
        const operand_134 = (in).frames;

        break :block_135 (try function_19(allocator, operand_134));
    };

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if ((block_109: {
        break :block_109 value_1;
    }).waiting) block_133: {
        break :block_133 (try function_44_value(allocator, block_132: {
            const operand_110 = block_122: {
                const operand_111 = in;
                const operand_112 = block_121: {
                    const operand_113 = (in).scratch;

                    const operand_114 = (block_118: {
                        const operand_115 = ((in).scratch).types;
                        const operand_116 = (in).result;
                        const operand_117 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_115).len, 1))));

                        @memcpy((operand_117)[0..(operand_115).len], operand_115);

                        (operand_117)[(operand_115).len] = operand_116;

                        break :block_118 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_117, {}, null, });
                    }).@"0";

                    break :block_121 block_120: {
                        const operand_119 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_119).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (operand_113).names, .types = operand_114, });

                        break :block_120 @as(*const (zx_abi).zx_type_18, operand_119);
                    };
                };

                break :block_122 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_111).active, .cache = (operand_111).cache, .context = (operand_111).context, .delta = (operand_111).delta, .diagnostic = (operand_111).diagnostic, .frames = (operand_111).frames, .result = (operand_111).result, .scratch = operand_112, });
            };

            const operand_123 = block_131: {
                const operand_124 = block_125: {
                    break :block_125 value_1;
                };
                const operand_126 = ((block_127: {
                    break :block_127 value_1;
                }).index + @as(u64, 1));

                const operand_128 = false;

                break :block_131 block_130: {
                    const operand_129 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_129).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_124).children, .count = (operand_124).count, .declaration = (operand_124).declaration, .fields = (operand_124).fields, .index = operand_126, .list = (operand_124).list, .name = (operand_124).name, .operation = (operand_124).operation, .position = (operand_124).position, .reference = (operand_124).reference, .waiting = operand_128, });

                    break :block_130 @as(*const (zx_abi).zx_type_80, operand_129);
                };
            };

            break :block_132 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_110, .frame = operand_123, });
        }));
    } else in);

    const value_3: *const (zx_abi).zx_type_80 = block_108: {
        const operand_107 = (value_2).frames;

        break :block_108 (try function_19(allocator, operand_107));
    };

    if (((block_104: {
        break :block_104 value_3;
    }).index == (block_105: {
        break :block_105 value_3;
    }).count)) {
        return block_106: {
            break :block_106 (try function_47_value(allocator, value_2));
        };
    }

    const value_4: *const (zx_abi).zx_type_64 = block_103: {
        const operand_101 = block_100: {
            const operand_97 = ((value_2).context).source;

            const operand_98 = (block_99: {
                break :block_99 value_3;
            }).position;

            break :block_100 @as((zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_97, .position = operand_98, });
        };

        var state_borrow_102: (zx_abi).zx_type_138 = undefined;

        state_borrow_102 = (zx_abi).zx_type_138{ .position = (operand_101).position, .source = (operand_101).source, };

        break :block_103 (try function_50(allocator, ((operand_101).zx_origin orelse (&state_borrow_102))));
    };

    const value_5: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_96: {
        break :block_96 (try function_44_value(allocator, block_95: {
            const operand_85 = value_2;

            const operand_86 = block_94: {
                const operand_87 = block_88: {
                    break :block_88 value_3;
                };
                const operand_89 = (block_90: {
                    break :block_90 value_4;
                }).next;

                const operand_91 = true;

                break :block_94 block_93: {
                    const operand_92 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_92).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_87).children, .count = (operand_87).count, .declaration = (operand_87).declaration, .fields = (operand_87).fields, .index = (operand_87).index, .list = (operand_87).list, .name = (operand_87).name, .operation = (operand_87).operation, .position = operand_89, .reference = (operand_87).reference, .waiting = operand_91, });

                    break :block_93 @as(*const (zx_abi).zx_type_80, operand_92);
                };
            };

            break :block_95 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_85, .frame = operand_86, });
        }));
    };

    const value_6: *const (zx_abi).zx_type_80 = block_84: {
        const operand_82 = block_81: {
            const operand_71 = @as((zx_abi).zx_type_77, .Node);

            const operand_72 = block_78: {
                const operand_73 = @as([]const u8, "");
                const operand_74 = @as(u64, 0);
                const operand_75 = @as(u64, 0);

                break :block_78 block_77: {
                    const operand_76 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_76).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_73, .start = operand_74, .end = operand_75, });

                    break :block_77 @as(*const (zx_abi).zx_type_60, operand_76);
                };
            };

            const operand_79 = (block_80: {
                break :block_80 value_4;
            }).value;

            break :block_81 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_71, .name = operand_72, .reference = operand_79, });
        };

        var state_borrow_83: (zx_abi).zx_type_85 = undefined;

        state_borrow_83 = (zx_abi).zx_type_85{ .name = (operand_82).name, .operation = (operand_82).operation, .reference = (operand_82).reference, };

        break :block_84 (try function_2(allocator, ((operand_82).zx_origin orelse (&state_borrow_83))));
    };

    return block_70: {
        const operand_63 = value_5;

        const operand_64 = (block_69: {
            const operand_65 = (value_5).frames;

            const operand_67 = block_66: {
                break :block_66 value_6;
            };

            const operand_68 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_65).len, 1))));

            @memcpy((operand_68)[0..(operand_65).len], operand_65);

            (operand_68)[(operand_65).len] = operand_67;

            break :block_69 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_68, {}, null, });
        }).@"0";

        break :block_70 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_63).active, .cache = (operand_63).cache, .context = (operand_63).context, .delta = (operand_63).delta, .diagnostic = (operand_63).diagnostic, .frames = operand_64, .result = (operand_63).result, .scratch = (operand_63).scratch, });
    };
}

fn function_51_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_215: {
        const operand_214 = (in).frames;

        break :block_215 (try function_19(allocator, operand_214));
    };

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (if ((block_186: {
        break :block_186 value_1;
    }).waiting) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_213: {
        break :block_213 (try function_44_buffered(allocator, block_212: {
            const operand_187 = block_202: {
                const operand_188 = in;
                const operand_189 = block_201: {
                    const operand_190 = (in).scratch;

                    const operand_191 = @as([]const u32, (if (((buffers).lane_35 != null)) block_194: {
                        const operand_192 = ((in).scratch).types;
                        const operand_193 = (in).result;
                        _ = (try ((std).math).add(usize, (operand_192).len, 1));

                        if ((!(((buffers).lane_35.?).started).*)) {
                            (try ((((buffers).lane_35.?).buffer).*).appendSlice(allocator, operand_192));
                            (((buffers).lane_35.?).started).* = true;
                        } else {
                            (((((buffers).lane_35.?).buffer).*).items).len = (operand_192).len;
                        }

                        (try ((((buffers).lane_35.?).buffer).*).append(allocator, operand_193));

                        break :block_194 ((((buffers).lane_35.?).buffer).*).items;
                    } else (block_198: {
                        const operand_195 = ((in).scratch).types;
                        const operand_196 = (in).result;
                        const operand_197 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_195).len, 1))));

                        @memcpy((operand_197)[0..(operand_195).len], operand_195);

                        (operand_197)[(operand_195).len] = operand_196;

                        break :block_198 @as((zx_abi).value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_197, {}, null, });
                    }).@"0"));

                    break :block_201 block_200: {
                        const operand_199 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_199).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = (operand_190).names, .types = operand_191, });

                        break :block_200 @as(*const (zx_abi).zx_type_18, operand_199);
                    };
                };

                break :block_202 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_188).active, .cache = (operand_188).cache, .context = (operand_188).context, .delta = (operand_188).delta, .diagnostic = (operand_188).diagnostic, .frames = (operand_188).frames, .result = (operand_188).result, .scratch = operand_189, });
            };

            const operand_203 = block_211: {
                const operand_204 = block_205: {
                    break :block_205 value_1;
                };
                const operand_206 = ((block_207: {
                    break :block_207 value_1;
                }).index + @as(u64, 1));

                const operand_208 = false;

                break :block_211 block_210: {
                    const operand_209 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_209).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_204).children, .count = (operand_204).count, .declaration = (operand_204).declaration, .fields = (operand_204).fields, .index = operand_206, .list = (operand_204).list, .name = (operand_204).name, .operation = (operand_204).operation, .position = (operand_204).position, .reference = (operand_204).reference, .waiting = operand_208, });

                    break :block_210 @as(*const (zx_abi).zx_type_80, operand_209);
                };
            };

            break :block_212 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_187, .frame = operand_203, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    }) else in);

    const value_3: *const (zx_abi).zx_type_80 = block_185: {
        const operand_184 = (value_2).frames;

        break :block_185 (try function_19(allocator, operand_184));
    };

    if (((block_181: {
        break :block_181 value_3;
    }).index == (block_182: {
        break :block_182 value_3;
    }).count)) {
        return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_183: {
            break :block_183 (try function_47_buffered(allocator, value_2, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        });
    }

    const value_4: *const (zx_abi).zx_type_64 = block_180: {
        const operand_178 = block_177: {
            const operand_174 = ((value_2).context).source;

            const operand_175 = (block_176: {
                break :block_176 value_3;
            }).position;

            break :block_177 @as((zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_174, .position = operand_175, });
        };

        var state_borrow_179: (zx_abi).zx_type_138 = undefined;

        state_borrow_179 = (zx_abi).zx_type_138{ .position = (operand_178).position, .source = (operand_178).source, };

        break :block_180 (try function_50(allocator, ((operand_178).zx_origin orelse (&state_borrow_179))));
    };

    const value_5: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_173: {
        break :block_173 (try function_44_buffered(allocator, block_172: {
            const operand_162 = value_2;

            const operand_163 = block_171: {
                const operand_164 = block_165: {
                    break :block_165 value_3;
                };
                const operand_166 = (block_167: {
                    break :block_167 value_4;
                }).next;

                const operand_168 = true;

                break :block_171 block_170: {
                    const operand_169 = (try (allocator).create((zx_abi).zx_type_80));

                    (operand_169).* = @as((zx_abi).zx_type_80, (zx_abi).zx_type_80{ .children = (operand_164).children, .count = (operand_164).count, .declaration = (operand_164).declaration, .fields = (operand_164).fields, .index = (operand_164).index, .list = (operand_164).list, .name = (operand_164).name, .operation = (operand_164).operation, .position = operand_166, .reference = (operand_164).reference, .waiting = operand_168, });

                    break :block_170 @as(*const (zx_abi).zx_type_80, operand_169);
                };
            };

            break :block_172 @as((zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77, (zx_abi).value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77{ .state = operand_162, .frame = operand_163, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });

    const value_6: *const (zx_abi).zx_type_80 = block_161: {
        const operand_159 = block_158: {
            const operand_148 = @as((zx_abi).zx_type_77, .Node);

            const operand_149 = block_155: {
                const operand_150 = @as([]const u8, "");
                const operand_151 = @as(u64, 0);
                const operand_152 = @as(u64, 0);

                break :block_155 block_154: {
                    const operand_153 = (try (allocator).create((zx_abi).zx_type_60));

                    (operand_153).* = @as((zx_abi).zx_type_60, (zx_abi).zx_type_60{ .text = operand_150, .start = operand_151, .end = operand_152, });

                    break :block_154 @as(*const (zx_abi).zx_type_60, operand_153);
                };
            };

            const operand_156 = (block_157: {
                break :block_157 value_4;
            }).value;

            break :block_158 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_148, .name = operand_149, .reference = operand_156, });
        };

        var state_borrow_160: (zx_abi).zx_type_85 = undefined;

        state_borrow_160 = (zx_abi).zx_type_85{ .name = (operand_159).name, .operation = (operand_159).operation, .reference = (operand_159).reference, };

        break :block_161 (try function_2(allocator, ((operand_159).zx_origin orelse (&state_borrow_160))));
    };

    return block_147: {
        const operand_136 = value_5;

        const operand_137 = @as([]const *const (zx_abi).zx_type_80, (if (((buffers).lane_33 != null)) block_141: {
            const operand_138 = (value_5).frames;

            const operand_140 = block_139: {
                break :block_139 value_6;
            };

            _ = (try ((std).math).add(usize, (operand_138).len, 1));

            if ((!(((buffers).lane_33.?).started).*)) {
                (try ((((buffers).lane_33.?).buffer).*).appendSlice(allocator, operand_138));
                (((buffers).lane_33.?).started).* = true;
            } else {
                (((((buffers).lane_33.?).buffer).*).items).len = (operand_138).len;
            }

            (try ((((buffers).lane_33.?).buffer).*).append(allocator, operand_140));

            break :block_141 ((((buffers).lane_33.?).buffer).*).items;
        } else (block_146: {
            const operand_142 = (value_5).frames;

            const operand_144 = block_143: {
                break :block_143 value_6;
            };

            const operand_145 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_142).len, 1))));

            @memcpy((operand_145)[0..(operand_142).len], operand_142);

            (operand_145)[(operand_142).len] = operand_144;

            break :block_146 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_145, {}, null, });
        }).@"0"));

        break :block_147 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_136).active, .cache = (operand_136).cache, .context = (operand_136).context, .delta = (operand_136).delta, .diagnostic = (operand_136).diagnostic, .frames = operand_137, .result = (operand_136).result, .scratch = (operand_136).scratch, });
    };
}

fn function_52(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ OutOfMemory, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    return block_7: {
        const operand_1 = in;

        const operand_2 = (block_4: {
            const operand_3 = (in).frames;

            break :block_4 @as((zx_abi).zx_type_103, (if (((operand_3).len == 0)) .{ operand_3, null, } else .{ (operand_3)[0..((operand_3).len - 1)], (operand_3)[((operand_3).len - 1)], }));
        }).@"0";

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_82));

            (operand_5).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_1).active, .cache = (operand_1).cache, .context = (operand_1).context, .delta = (operand_1).delta, .diagnostic = (operand_1).diagnostic, .frames = operand_2, .result = (operand_1).result, .scratch = (operand_1).scratch, });

            break :block_6 @as(*const (zx_abi).zx_type_82, operand_5);
        };
    };
}

fn function_52_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_12: {
        const operand_8 = in;

        const operand_9 = (block_11: {
            const operand_10 = (in).frames;

            break :block_11 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_10).len == 0)) .{ operand_10, null, null, } else .{ (operand_10)[0..((operand_10).len - 1)], (operand_10)[((operand_10).len - 1)], null, }));
        }).@"0";

        break :block_12 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_8).active, .cache = (operand_8).cache, .context = (operand_8).context, .delta = (operand_8).delta, .diagnostic = (operand_8).diagnostic, .frames = operand_9, .result = (operand_8).result, .scratch = (operand_8).scratch, });
    };
}

fn function_52_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_17: {
        const operand_13 = in;

        const operand_14 = (block_16: {
            const operand_15 = (in).frames;

            break :block_16 @as((zx_abi).value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_15).len == 0)) .{ operand_15, null, null, } else .{ (operand_15)[0..((operand_15).len - 1)], (operand_15)[((operand_15).len - 1)], null, }));
        }).@"0";

        break :block_17 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_13).active, .cache = (operand_13).cache, .context = (operand_13).context, .delta = (operand_13).delta, .diagnostic = (operand_13).diagnostic, .frames = operand_14, .result = (operand_13).result, .scratch = (operand_13).scratch, });
    };
}

fn function_53(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = (try function_19(allocator, (in).frames));

    const value_2: *const (zx_abi).zx_type_82 = (try function_39(allocator, block_24: {
        const operand_1 = in;
        const operand_2 = block_21: {
            const operand_3 = (if ((value_1).list) @as((zx_abi).zx_type_11, .List) else @as((zx_abi).zx_type_11, .Optional));
            const operand_4 = (in).result;
            const operand_5 = @as(u32, 0);
            const operand_6 = @as([]const u8, "");

            const operand_7 = block_8: {
                break :block_8 (try (allocator).dupe(u32, (&[_]u32{})));
            };
            const operand_9 = block_16: {
                const operand_10 = block_11: {
                    break :block_11 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };
                const operand_12 = block_13: {
                    break :block_13 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_16 block_15: {
                    const operand_14 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_14).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_10, .types = operand_12, });

                    break :block_15 @as(*const (zx_abi).zx_type_18, operand_14);
                };
            };
            const operand_17 = block_18: {
                break :block_18 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
            };

            break :block_21 block_20: {
                const operand_19 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_19).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .kind = operand_3, .first = operand_4, .second = operand_5, .label = operand_6, .children = operand_7, .fields = operand_9, .names = operand_17, });

                break :block_20 @as(*const (zx_abi).zx_type_19, operand_19);
            };
        };

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_129));

            (operand_22).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .state = operand_1, .candidate = operand_2, });

            break :block_23 @as(*const (zx_abi).zx_type_129, operand_22);
        };
    }));

    return (try function_52(allocator, value_2));
}

fn function_53_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_49: {
        const operand_48 = (in).frames;

        break :block_49 (try function_19(allocator, operand_48));
    };

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_47: {
        break :block_47 (try function_39_value(allocator, block_46: {
            const operand_26 = in;

            const operand_27 = block_45: {
                const operand_28 = (if ((block_29: {
                    break :block_29 value_1;
                }).list) @as((zx_abi).zx_type_11, .List) else @as((zx_abi).zx_type_11, .Optional));

                const operand_30 = (in).result;
                const operand_31 = @as(u32, 0);
                const operand_32 = @as([]const u8, "");

                const operand_33 = block_34: {
                    break :block_34 (try (allocator).dupe(u32, (&[_]u32{})));
                };
                const operand_35 = block_42: {
                    const operand_36 = block_37: {
                        break :block_37 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };
                    const operand_38 = block_39: {
                        break :block_39 (try (allocator).dupe(u32, (&[_]u32{})));
                    };

                    break :block_42 block_41: {
                        const operand_40 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_40).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_36, .types = operand_38, });

                        break :block_41 @as(*const (zx_abi).zx_type_18, operand_40);
                    };
                };
                const operand_43 = block_44: {
                    break :block_44 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                break :block_45 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_28, .first = operand_30, .second = operand_31, .label = operand_32, .children = operand_33, .fields = operand_35, .names = operand_43, });
            };

            break :block_46 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_26, .candidate = operand_27, });
        }));
    };

    return block_25: {
        break :block_25 (try function_52_value(allocator, value_2));
    };
}

fn function_53_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_15: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_16: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_55),
        started: *bool,
    },
    lane_17: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_25),
        started: *bool,
    },
    lane_18: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_19: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_20: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_21: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_42),
        started: *bool,
    },
    lane_22: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_43),
        started: *bool,
    },
    lane_23: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_41),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_80 = block_74: {
        const operand_73 = (in).frames;

        break :block_74 (try function_19(allocator, operand_73));
    };

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_72: {
        break :block_72 (try function_39_buffered(allocator, block_71: {
            const operand_51 = in;

            const operand_52 = block_70: {
                const operand_53 = (if ((block_54: {
                    break :block_54 value_1;
                }).list) @as((zx_abi).zx_type_11, .List) else @as((zx_abi).zx_type_11, .Optional));

                const operand_55 = (in).result;
                const operand_56 = @as(u32, 0);
                const operand_57 = @as([]const u8, "");
                const operand_58 = block_59: {
                    break :block_59 (try (allocator).dupe(u32, (&[_]u32{})));
                };
                const operand_60 = block_67: {
                    const operand_61 = block_62: {
                        break :block_62 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                    };

                    const operand_63 = block_64: {
                        break :block_64 (try (allocator).dupe(u32, (&[_]u32{})));
                    };

                    break :block_67 block_66: {
                        const operand_65 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_65).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_61, .types = operand_63, });

                        break :block_66 @as(*const (zx_abi).zx_type_18, operand_65);
                    };
                };
                const operand_68 = block_69: {
                    break :block_69 (try (allocator).dupe([]const u8, (&[_][]const u8{})));
                };

                break :block_70 @as((zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .kind = operand_53, .first = operand_55, .second = operand_56, .label = operand_57, .children = operand_58, .fields = operand_60, .names = operand_68, });
            };

            break :block_71 @as((zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920, (zx_abi).value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920{ .state = operand_51, .candidate = operand_52, });
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });

    return @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_50: {
        break :block_50 (try function_52_buffered(allocator, value_2, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = (if (((buffers).lane_15 != null)) .{ .buffer = (&(((buffers).lane_15.?).buffer).*), .started = (&(((buffers).lane_15.?).started).*), } else null), .lane_16 = (if (((buffers).lane_16 != null)) .{ .buffer = (&(((buffers).lane_16.?).buffer).*), .started = (&(((buffers).lane_16.?).started).*), } else null), .lane_17 = (if (((buffers).lane_17 != null)) .{ .buffer = (&(((buffers).lane_17.?).buffer).*), .started = (&(((buffers).lane_17.?).started).*), } else null), .lane_18 = (if (((buffers).lane_18 != null)) .{ .buffer = (&(((buffers).lane_18.?).buffer).*), .started = (&(((buffers).lane_18.?).started).*), } else null), .lane_19 = (if (((buffers).lane_19 != null)) .{ .buffer = (&(((buffers).lane_19.?).buffer).*), .started = (&(((buffers).lane_19.?).started).*), } else null), .lane_20 = (if (((buffers).lane_20 != null)) .{ .buffer = (&(((buffers).lane_20.?).buffer).*), .started = (&(((buffers).lane_20.?).started).*), } else null), .lane_21 = (if (((buffers).lane_21 != null)) .{ .buffer = (&(((buffers).lane_21.?).buffer).*), .started = (&(((buffers).lane_21.?).started).*), } else null), .lane_22 = (if (((buffers).lane_22 != null)) .{ .buffer = (&(((buffers).lane_22.?).buffer).*), .started = (&(((buffers).lane_22.?).started).*), } else null), .lane_23 = (if (((buffers).lane_23 != null)) .{ .buffer = (&(((buffers).lane_23.?).buffer).*), .started = (&(((buffers).lane_23.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
    });
}

fn function_54(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    return block_3: {
        const operand_2 = (block_1: {
            break :block_1 (try function_19_value(allocator, (in).frames));
        }).operation;

        break :block_3 (if ((operand_2 == @as((zx_abi).zx_type_77, .Name))) (try function_45(allocator, in)) else (if ((operand_2 == @as((zx_abi).zx_type_77, .FinishName))) (try function_20(allocator, in)) else (if ((operand_2 == @as((zx_abi).zx_type_77, .Node))) (try function_46(allocator, in)) else (if ((operand_2 == @as((zx_abi).zx_type_77, .Wrap))) (try function_53(allocator, in)) else (if ((operand_2 == @as((zx_abi).zx_type_77, .Tuple))) (try function_51(allocator, in)) else (try function_49(allocator, in)))))));
    };
}

fn function_54_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_13: {
        const operand_6 = (block_5: {
            const operand_4 = (in).frames;

            break :block_5 (try function_19_value(allocator, operand_4));
        }).operation;

        break :block_13 (if ((operand_6 == @as((zx_abi).zx_type_77, .Name))) block_12: {
            break :block_12 (try function_45_value(allocator, in));
        } else (if ((operand_6 == @as((zx_abi).zx_type_77, .FinishName))) block_11: {
            break :block_11 (try function_20_value(allocator, in));
        } else (if ((operand_6 == @as((zx_abi).zx_type_77, .Node))) block_10: {
            break :block_10 (try function_46_value(allocator, in));
        } else (if ((operand_6 == @as((zx_abi).zx_type_77, .Wrap))) block_9: {
            break :block_9 (try function_53_value(allocator, in));
        } else (if ((operand_6 == @as((zx_abi).zx_type_77, .Tuple))) block_8: {
            break :block_8 (try function_51_value(allocator, in));
        } else block_7: {
            break :block_7 (try function_49_value(allocator, in));
        })))));
    };
}

fn function_54_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_7: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_8: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_9: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_10: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_11: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_12: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_13: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_14: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_24: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_25: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_26: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_27: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_28: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_29: ?struct {
        buffer: *(std).ArrayList(u8),
        started: *bool,
    },
    lane_30: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_31: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_32: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_33: ?struct {
        buffer: *(std).ArrayList(*const (zx_abi).zx_type_80),
        started: *bool,
    },
    lane_34: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
    lane_35: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_23: {
        const operand_16 = (block_15: {
            const operand_14 = (in).frames;

            break :block_15 (try function_19_value(allocator, operand_14));
        }).operation;

        break :block_23 (if ((operand_16 == @as((zx_abi).zx_type_77, .Name))) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_22: {
            break :block_22 (try function_45_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }) else (if ((operand_16 == @as((zx_abi).zx_type_77, .FinishName))) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_21: {
            break :block_21 (try function_20_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }) else (if ((operand_16 == @as((zx_abi).zx_type_77, .Node))) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_20: {
            break :block_20 (try function_46_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }) else (if ((operand_16 == @as((zx_abi).zx_type_77, .Wrap))) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_19: {
            break :block_19 (try function_53_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }) else (if ((operand_16 == @as((zx_abi).zx_type_77, .Tuple))) @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_18: {
            break :block_18 (try function_51_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_15 = null, .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }) else @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_17: {
            break :block_17 (try function_49_buffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), .lane_7 = (if (((buffers).lane_7 != null)) .{ .buffer = (&(((buffers).lane_7.?).buffer).*), .started = (&(((buffers).lane_7.?).started).*), } else null), .lane_8 = (if (((buffers).lane_8 != null)) .{ .buffer = (&(((buffers).lane_8.?).buffer).*), .started = (&(((buffers).lane_8.?).started).*), } else null), .lane_9 = (if (((buffers).lane_9 != null)) .{ .buffer = (&(((buffers).lane_9.?).buffer).*), .started = (&(((buffers).lane_9.?).started).*), } else null), .lane_10 = (if (((buffers).lane_10 != null)) .{ .buffer = (&(((buffers).lane_10.?).buffer).*), .started = (&(((buffers).lane_10.?).started).*), } else null), .lane_11 = (if (((buffers).lane_11 != null)) .{ .buffer = (&(((buffers).lane_11.?).buffer).*), .started = (&(((buffers).lane_11.?).started).*), } else null), .lane_12 = (if (((buffers).lane_12 != null)) .{ .buffer = (&(((buffers).lane_12.?).buffer).*), .started = (&(((buffers).lane_12.?).started).*), } else null), .lane_13 = (if (((buffers).lane_13 != null)) .{ .buffer = (&(((buffers).lane_13.?).buffer).*), .started = (&(((buffers).lane_13.?).started).*), } else null), .lane_14 = (if (((buffers).lane_14 != null)) .{ .buffer = (&(((buffers).lane_14.?).buffer).*), .started = (&(((buffers).lane_14.?).started).*), } else null), .lane_16 = null, .lane_17 = null, .lane_18 = null, .lane_19 = null, .lane_20 = null, .lane_21 = null, .lane_22 = null, .lane_23 = null, .lane_24 = (if (((buffers).lane_24 != null)) .{ .buffer = (&(((buffers).lane_24.?).buffer).*), .started = (&(((buffers).lane_24.?).started).*), } else null), .lane_25 = (if (((buffers).lane_25 != null)) .{ .buffer = (&(((buffers).lane_25.?).buffer).*), .started = (&(((buffers).lane_25.?).started).*), } else null), .lane_26 = (if (((buffers).lane_26 != null)) .{ .buffer = (&(((buffers).lane_26.?).buffer).*), .started = (&(((buffers).lane_26.?).started).*), } else null), .lane_27 = (if (((buffers).lane_27 != null)) .{ .buffer = (&(((buffers).lane_27.?).buffer).*), .started = (&(((buffers).lane_27.?).started).*), } else null), .lane_28 = (if (((buffers).lane_28 != null)) .{ .buffer = (&(((buffers).lane_28.?).buffer).*), .started = (&(((buffers).lane_28.?).started).*), } else null), .lane_29 = (if (((buffers).lane_29 != null)) .{ .buffer = (&(((buffers).lane_29.?).buffer).*), .started = (&(((buffers).lane_29.?).started).*), } else null), .lane_30 = (if (((buffers).lane_30 != null)) .{ .buffer = (&(((buffers).lane_30.?).buffer).*), .started = (&(((buffers).lane_30.?).started).*), } else null), .lane_31 = (if (((buffers).lane_31 != null)) .{ .buffer = (&(((buffers).lane_31.?).buffer).*), .started = (&(((buffers).lane_31.?).started).*), } else null), .lane_32 = (if (((buffers).lane_32 != null)) .{ .buffer = (&(((buffers).lane_32.?).buffer).*), .started = (&(((buffers).lane_32.?).started).*), } else null), .lane_33 = (if (((buffers).lane_33 != null)) .{ .buffer = (&(((buffers).lane_33.?).buffer).*), .started = (&(((buffers).lane_33.?).started).*), } else null), .lane_34 = (if (((buffers).lane_34 != null)) .{ .buffer = (&(((buffers).lane_34.?).buffer).*), .started = (&(((buffers).lane_34.?).started).*), } else null), .lane_35 = (if (((buffers).lane_35 != null)) .{ .buffer = (&(((buffers).lane_35.?).buffer).*), .started = (&(((buffers).lane_35.?).started).*), } else null), }));
        }))))));
    };
}

fn function_55(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_82) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_82 {
    @setRuntimeSafety(true);

    return block_166: {
        const operand_2 = in;
        var state_capacity_4: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_5 = false;

        defer (state_capacity_4).deinit(allocator);

        var state_capacity_6: (std).ArrayList(u32) = .empty;
        var state_capacity_started_7 = false;

        defer (state_capacity_6).deinit(allocator);

        var state_capacity_8: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_9 = false;

        defer (state_capacity_8).deinit(allocator);

        var state_capacity_10: (std).ArrayList(u32) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_capacity_12: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_13 = false;

        defer (state_capacity_12).deinit(allocator);

        var state_capacity_14: (std).ArrayList(u32) = .empty;
        var state_capacity_started_15 = false;

        defer (state_capacity_14).deinit(allocator);

        var state_capacity_16: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_17 = false;

        defer (state_capacity_16).deinit(allocator);

        var state_capacity_18: (std).ArrayList(u32) = .empty;
        var state_capacity_started_19 = false;

        defer (state_capacity_18).deinit(allocator);

        var state_capacity_20: (std).ArrayList(u32) = .empty;
        var state_capacity_started_21 = false;

        defer (state_capacity_20).deinit(allocator);

        var state_capacity_22: (std).ArrayList(u8) = .empty;
        var state_capacity_started_23 = false;

        defer (state_capacity_22).deinit(allocator);

        var state_capacity_24: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_25 = false;

        defer (state_capacity_24).deinit(allocator);

        var state_capacity_26: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_27 = false;

        defer (state_capacity_26).deinit(allocator);

        var state_capacity_28: (std).ArrayList(u32) = .empty;
        var state_capacity_started_29 = false;

        defer (state_capacity_28).deinit(allocator);

        var state_capacity_30: (std).ArrayList(u32) = .empty;
        var state_capacity_started_31 = false;

        defer (state_capacity_30).deinit(allocator);

        var state_capacity_32: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_33 = false;

        defer (state_capacity_32).deinit(allocator);

        var state_capacity_34: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_35 = false;

        defer (state_capacity_34).deinit(allocator);

        var state_capacity_36: (std).ArrayList(u32) = .empty;
        var state_capacity_started_37 = false;

        defer (state_capacity_36).deinit(allocator);

        var state_capacity_38: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_39 = false;

        defer (state_capacity_38).deinit(allocator);

        var state_capacity_40: (std).ArrayList(u32) = .empty;
        var state_capacity_started_41 = false;

        defer (state_capacity_40).deinit(allocator);

        var state_capacity_42: (std).ArrayList(u32) = .empty;
        var state_capacity_started_43 = false;

        defer (state_capacity_42).deinit(allocator);

        var state_capacity_44: (std).ArrayList(u8) = .empty;
        var state_capacity_started_45 = false;

        defer (state_capacity_44).deinit(allocator);

        var state_capacity_46: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_47 = false;

        defer (state_capacity_46).deinit(allocator);

        var state_capacity_48: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_49 = false;

        defer (state_capacity_48).deinit(allocator);

        var state_capacity_50: (std).ArrayList(u32) = .empty;
        var state_capacity_started_51 = false;

        defer (state_capacity_50).deinit(allocator);

        var state_capacity_52: (std).ArrayList(*const (zx_abi).zx_type_80) = .empty;
        var state_capacity_started_53 = false;

        defer (state_capacity_52).deinit(allocator);

        var state_capacity_54: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_55 = false;

        defer (state_capacity_54).deinit(allocator);

        var state_capacity_56: (std).ArrayList(u32) = .empty;
        var state_capacity_started_57 = false;

        defer (state_capacity_56).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_2).active, .cache = (operand_2).cache, .context = (operand_2).context, .delta = (operand_2).delta, .diagnostic = (operand_2).diagnostic, .frames = (operand_2).frames, .result = (operand_2).result, .scratch = (operand_2).scratch, .zx_origin = operand_2, };
        var state_changed_3 = false;

        while (((@as(u64, ((state_1).frames).len) != @as(u64, 0)) and block_60: {
            const operand_58 = ((state_1).diagnostic).message;
            const operand_59 = @as([]const u8, "");

            break :block_60 ((std).mem).eql(u8, operand_58, operand_59);
        })) {
            state_1 = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_61: {
                break :block_61 (try function_54_buffered(allocator, state_1, .{ .lane_0 = .{ .buffer = (&state_capacity_4), .started = (&state_capacity_started_5), }, .lane_1 = .{ .buffer = (&state_capacity_6), .started = (&state_capacity_started_7), }, .lane_2 = .{ .buffer = (&state_capacity_8), .started = (&state_capacity_started_9), }, .lane_3 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, .lane_4 = .{ .buffer = (&state_capacity_12), .started = (&state_capacity_started_13), }, .lane_5 = .{ .buffer = (&state_capacity_14), .started = (&state_capacity_started_15), }, .lane_6 = .{ .buffer = (&state_capacity_16), .started = (&state_capacity_started_17), }, .lane_7 = .{ .buffer = (&state_capacity_18), .started = (&state_capacity_started_19), }, .lane_8 = .{ .buffer = (&state_capacity_20), .started = (&state_capacity_started_21), }, .lane_9 = .{ .buffer = (&state_capacity_22), .started = (&state_capacity_started_23), }, .lane_10 = .{ .buffer = (&state_capacity_24), .started = (&state_capacity_started_25), }, .lane_11 = .{ .buffer = (&state_capacity_26), .started = (&state_capacity_started_27), }, .lane_12 = .{ .buffer = (&state_capacity_28), .started = (&state_capacity_started_29), }, .lane_13 = .{ .buffer = (&state_capacity_30), .started = (&state_capacity_started_31), }, .lane_14 = .{ .buffer = (&state_capacity_32), .started = (&state_capacity_started_33), }, .lane_24 = .{ .buffer = (&state_capacity_34), .started = (&state_capacity_started_35), }, .lane_25 = .{ .buffer = (&state_capacity_36), .started = (&state_capacity_started_37), }, .lane_26 = .{ .buffer = (&state_capacity_38), .started = (&state_capacity_started_39), }, .lane_27 = .{ .buffer = (&state_capacity_40), .started = (&state_capacity_started_41), }, .lane_28 = .{ .buffer = (&state_capacity_42), .started = (&state_capacity_started_43), }, .lane_29 = .{ .buffer = (&state_capacity_44), .started = (&state_capacity_started_45), }, .lane_30 = .{ .buffer = (&state_capacity_46), .started = (&state_capacity_started_47), }, .lane_31 = .{ .buffer = (&state_capacity_48), .started = (&state_capacity_started_49), }, .lane_32 = .{ .buffer = (&state_capacity_50), .started = (&state_capacity_started_51), }, .lane_33 = .{ .buffer = (&state_capacity_52), .started = (&state_capacity_started_53), }, .lane_34 = .{ .buffer = (&state_capacity_54), .started = (&state_capacity_started_55), }, .lane_35 = .{ .buffer = (&state_capacity_56), .started = (&state_capacity_started_57), }, }));
            });

            state_changed_3 = true;
        }

        var state_owned_62: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_62);

        if (state_capacity_started_5) {
            ((state_capacity_4).items).len = ((state_1).active).len;
            state_owned_62 = (try (state_capacity_4).toOwnedSlice(allocator));
        }

        if (state_capacity_started_5) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = state_owned_62, .cache = (state_1).cache, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_63: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_63);

        if (state_capacity_started_7) {
            ((state_capacity_6).items).len = (((state_1).cache).ids).len;
            state_owned_63 = (try (state_capacity_6).toOwnedSlice(allocator));
        }

        if (state_capacity_started_7) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = block_65: {
                const operand_64 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_64).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_63, .names = ((state_1).cache).names, });

                break :block_65 @as(*const (zx_abi).zx_type_78, operand_64);
            }, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_66: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_66);

        if (state_capacity_started_9) {
            ((state_capacity_8).items).len = (((state_1).cache).names).len;
            state_owned_66 = (try (state_capacity_8).toOwnedSlice(allocator));
        }

        if (state_capacity_started_9) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = block_68: {
                const operand_67 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_67).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = ((state_1).cache).ids, .names = state_owned_66, });

                break :block_68 @as(*const (zx_abi).zx_type_78, operand_67);
            }, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_69: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_69);

        if (state_capacity_started_11) {
            ((state_capacity_10).items).len = ((((state_1).context).aliases).ids).len;
            state_owned_69 = (try (state_capacity_10).toOwnedSlice(allocator));
        }

        if (state_capacity_started_11) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_73: {
                const operand_72 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_72).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = block_71: {
                    const operand_70 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_70).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_69, .names = (((state_1).context).aliases).names, });

                    break :block_71 @as(*const (zx_abi).zx_type_78, operand_70);
                }, .base = ((state_1).context).base, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_73 @as(*const (zx_abi).zx_type_79, operand_72);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_74: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_74);

        if (state_capacity_started_13) {
            ((state_capacity_12).items).len = ((((state_1).context).aliases).names).len;
            state_owned_74 = (try (state_capacity_12).toOwnedSlice(allocator));
        }

        if (state_capacity_started_13) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_78: {
                const operand_77 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_77).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = block_76: {
                    const operand_75 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_75).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = (((state_1).context).aliases).ids, .names = state_owned_74, });

                    break :block_76 @as(*const (zx_abi).zx_type_78, operand_75);
                }, .base = ((state_1).context).base, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_78 @as(*const (zx_abi).zx_type_79, operand_77);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_79: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_79);

        if (state_capacity_started_15) {
            ((state_capacity_14).items).len = ((((state_1).context).base).children).len;
            state_owned_79 = (try (state_capacity_14).toOwnedSlice(allocator));
        }

        if (state_capacity_started_15) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_83: {
                const operand_82 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_82).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_81: {
                    const operand_80 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_80).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_79, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_81 @as(*const (zx_abi).zx_type_15, operand_80);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_83 @as(*const (zx_abi).zx_type_79, operand_82);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_84: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_84);

        if (state_capacity_started_17) {
            ((state_capacity_16).items).len = ((((state_1).context).base).field_names).len;
            state_owned_84 = (try (state_capacity_16).toOwnedSlice(allocator));
        }

        if (state_capacity_started_17) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_88: {
                const operand_87 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_87).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_86: {
                    const operand_85 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_85).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = state_owned_84, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_86 @as(*const (zx_abi).zx_type_15, operand_85);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_88 @as(*const (zx_abi).zx_type_79, operand_87);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_89: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_89);

        if (state_capacity_started_19) {
            ((state_capacity_18).items).len = ((((state_1).context).base).field_types).len;
            state_owned_89 = (try (state_capacity_18).toOwnedSlice(allocator));
        }

        if (state_capacity_started_19) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_93: {
                const operand_92 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_92).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_91: {
                    const operand_90 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_90).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = state_owned_89, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_91 @as(*const (zx_abi).zx_type_15, operand_90);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_93 @as(*const (zx_abi).zx_type_79, operand_92);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_94: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_94);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = ((((state_1).context).base).first).len;
            state_owned_94 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_97).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_96: {
                    const operand_95 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_95).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = state_owned_94, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_96 @as(*const (zx_abi).zx_type_15, operand_95);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_98 @as(*const (zx_abi).zx_type_79, operand_97);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_99: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_99);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = ((((state_1).context).base).kinds).len;
            state_owned_99 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_103: {
                const operand_102 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_102).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_101: {
                    const operand_100 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_100).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = state_owned_99, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_101 @as(*const (zx_abi).zx_type_15, operand_100);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_103 @as(*const (zx_abi).zx_type_79, operand_102);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_104: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_104);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = ((((state_1).context).base).labels).len;
            state_owned_104 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_108: {
                const operand_107 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_107).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_106: {
                    const operand_105 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_105).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = state_owned_104, .names = (((state_1).context).base).names, .second = (((state_1).context).base).second, });

                    break :block_106 @as(*const (zx_abi).zx_type_15, operand_105);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_108 @as(*const (zx_abi).zx_type_79, operand_107);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_109: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_109);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = ((((state_1).context).base).names).len;
            state_owned_109 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_113: {
                const operand_112 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_112).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_111: {
                    const operand_110 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_110).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = state_owned_109, .second = (((state_1).context).base).second, });

                    break :block_111 @as(*const (zx_abi).zx_type_15, operand_110);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_113 @as(*const (zx_abi).zx_type_79, operand_112);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_114: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_114);

        if (state_capacity_started_29) {
            ((state_capacity_28).items).len = ((((state_1).context).base).second).len;
            state_owned_114 = (try (state_capacity_28).toOwnedSlice(allocator));
        }

        if (state_capacity_started_29) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_118: {
                const operand_117 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_117).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = block_116: {
                    const operand_115 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_115).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_1).context).base).children, .field_names = (((state_1).context).base).field_names, .field_types = (((state_1).context).base).field_types, .first = (((state_1).context).base).first, .kinds = (((state_1).context).base).kinds, .labels = (((state_1).context).base).labels, .names = (((state_1).context).base).names, .second = state_owned_114, });

                    break :block_116 @as(*const (zx_abi).zx_type_15, operand_115);
                }, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_118 @as(*const (zx_abi).zx_type_79, operand_117);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_119: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_119);

        if (state_capacity_started_31) {
            ((state_capacity_30).items).len = ((((state_1).context).resolved).ids).len;
            state_owned_119 = (try (state_capacity_30).toOwnedSlice(allocator));
        }

        if (state_capacity_started_31) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_123: {
                const operand_122 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_122).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = ((state_1).context).base, .native_interface = ((state_1).context).native_interface, .resolved = block_121: {
                    const operand_120 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_120).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_119, .names = (((state_1).context).resolved).names, });

                    break :block_121 @as(*const (zx_abi).zx_type_78, operand_120);
                }, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_123 @as(*const (zx_abi).zx_type_79, operand_122);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_124: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_124);

        if (state_capacity_started_33) {
            ((state_capacity_32).items).len = ((((state_1).context).resolved).names).len;
            state_owned_124 = (try (state_capacity_32).toOwnedSlice(allocator));
        }

        if (state_capacity_started_33) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_128: {
                const operand_127 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_127).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = ((state_1).context).base, .native_interface = ((state_1).context).native_interface, .resolved = block_126: {
                    const operand_125 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_125).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = (((state_1).context).resolved).ids, .names = state_owned_124, });

                    break :block_126 @as(*const (zx_abi).zx_type_78, operand_125);
                }, .source = ((state_1).context).source, .visiting = ((state_1).context).visiting, });

                break :block_128 @as(*const (zx_abi).zx_type_79, operand_127);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_129: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_129);

        if (state_capacity_started_35) {
            ((state_capacity_34).items).len = (((state_1).context).visiting).len;
            state_owned_129 = (try (state_capacity_34).toOwnedSlice(allocator));
        }

        if (state_capacity_started_35) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = block_131: {
                const operand_130 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_130).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_1).context).aliases, .base = ((state_1).context).base, .native_interface = ((state_1).context).native_interface, .resolved = ((state_1).context).resolved, .source = ((state_1).context).source, .visiting = state_owned_129, });

                break :block_131 @as(*const (zx_abi).zx_type_79, operand_130);
            }, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_132: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_132);

        if (state_capacity_started_37) {
            ((state_capacity_36).items).len = (((state_1).delta).children).len;
            state_owned_132 = (try (state_capacity_36).toOwnedSlice(allocator));
        }

        if (state_capacity_started_37) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_134: {
                const operand_133 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_133).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_132, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_134 @as(*const (zx_abi).zx_type_15, operand_133);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_135: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_135);

        if (state_capacity_started_39) {
            ((state_capacity_38).items).len = (((state_1).delta).field_names).len;
            state_owned_135 = (try (state_capacity_38).toOwnedSlice(allocator));
        }

        if (state_capacity_started_39) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_137: {
                const operand_136 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_136).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = state_owned_135, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_137 @as(*const (zx_abi).zx_type_15, operand_136);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_138: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_138);

        if (state_capacity_started_41) {
            ((state_capacity_40).items).len = (((state_1).delta).field_types).len;
            state_owned_138 = (try (state_capacity_40).toOwnedSlice(allocator));
        }

        if (state_capacity_started_41) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_140: {
                const operand_139 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_139).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = state_owned_138, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_140 @as(*const (zx_abi).zx_type_15, operand_139);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_141: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_141);

        if (state_capacity_started_43) {
            ((state_capacity_42).items).len = (((state_1).delta).first).len;
            state_owned_141 = (try (state_capacity_42).toOwnedSlice(allocator));
        }

        if (state_capacity_started_43) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_143: {
                const operand_142 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_142).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = state_owned_141, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_143 @as(*const (zx_abi).zx_type_15, operand_142);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_144: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_144);

        if (state_capacity_started_45) {
            ((state_capacity_44).items).len = (((state_1).delta).kinds).len;
            state_owned_144 = (try (state_capacity_44).toOwnedSlice(allocator));
        }

        if (state_capacity_started_45) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_146: {
                const operand_145 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_145).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = state_owned_144, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_146 @as(*const (zx_abi).zx_type_15, operand_145);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_147: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_147);

        if (state_capacity_started_47) {
            ((state_capacity_46).items).len = (((state_1).delta).labels).len;
            state_owned_147 = (try (state_capacity_46).toOwnedSlice(allocator));
        }

        if (state_capacity_started_47) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_149: {
                const operand_148 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_148).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = state_owned_147, .names = ((state_1).delta).names, .second = ((state_1).delta).second, });

                break :block_149 @as(*const (zx_abi).zx_type_15, operand_148);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_150: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_150);

        if (state_capacity_started_49) {
            ((state_capacity_48).items).len = (((state_1).delta).names).len;
            state_owned_150 = (try (state_capacity_48).toOwnedSlice(allocator));
        }

        if (state_capacity_started_49) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_152: {
                const operand_151 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_151).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = state_owned_150, .second = ((state_1).delta).second, });

                break :block_152 @as(*const (zx_abi).zx_type_15, operand_151);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_153: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_153);

        if (state_capacity_started_51) {
            ((state_capacity_50).items).len = (((state_1).delta).second).len;
            state_owned_153 = (try (state_capacity_50).toOwnedSlice(allocator));
        }

        if (state_capacity_started_51) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = block_155: {
                const operand_154 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_154).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_1).delta).children, .field_names = ((state_1).delta).field_names, .field_types = ((state_1).delta).field_types, .first = ((state_1).delta).first, .kinds = ((state_1).delta).kinds, .labels = ((state_1).delta).labels, .names = ((state_1).delta).names, .second = state_owned_153, });

                break :block_155 @as(*const (zx_abi).zx_type_15, operand_154);
            }, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_156: []const *const (zx_abi).zx_type_80 = (&[_]*const (zx_abi).zx_type_80{});

        errdefer (allocator).free(state_owned_156);

        if (state_capacity_started_53) {
            ((state_capacity_52).items).len = ((state_1).frames).len;
            state_owned_156 = (try (state_capacity_52).toOwnedSlice(allocator));
        }

        if (state_capacity_started_53) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = state_owned_156, .result = (state_1).result, .scratch = (state_1).scratch, };
        }

        var state_owned_157: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_157);

        if (state_capacity_started_55) {
            ((state_capacity_54).items).len = (((state_1).scratch).names).len;
            state_owned_157 = (try (state_capacity_54).toOwnedSlice(allocator));
        }

        if (state_capacity_started_55) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = block_159: {
                const operand_158 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_158).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = state_owned_157, .types = ((state_1).scratch).types, });

                break :block_159 @as(*const (zx_abi).zx_type_18, operand_158);
            }, };
        }

        var state_owned_160: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_160);

        if (state_capacity_started_57) {
            ((state_capacity_56).items).len = (((state_1).scratch).types).len;
            state_owned_160 = (try (state_capacity_56).toOwnedSlice(allocator));
        }

        if (state_capacity_started_57) {
            state_1 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = block_162: {
                const operand_161 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_161).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = ((state_1).scratch).names, .types = state_owned_160, });

                break :block_162 @as(*const (zx_abi).zx_type_18, operand_161);
            }, };
        }

        break :block_166 (if (state_changed_3) block_165: {
            break :block_165 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_164: {
                const operand_163 = (try (allocator).create((zx_abi).zx_type_82));

                (operand_163).* = (zx_abi).zx_type_82{ .active = (state_1).active, .cache = (state_1).cache, .context = (state_1).context, .delta = (state_1).delta, .diagnostic = (state_1).diagnostic, .frames = (state_1).frames, .result = (state_1).result, .scratch = (state_1).scratch, };

                break :block_164 @as(*const (zx_abi).zx_type_82, operand_163);
            });
        } else operand_2);
    };
}

fn function_55_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b {
    @setRuntimeSafety(true);

    return block_330: {
        const operand_168 = in;
        var state_capacity_170: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_171 = false;

        defer (state_capacity_170).deinit(allocator);

        var state_capacity_172: (std).ArrayList(u32) = .empty;
        var state_capacity_started_173 = false;

        defer (state_capacity_172).deinit(allocator);

        var state_capacity_174: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_175 = false;

        defer (state_capacity_174).deinit(allocator);

        var state_capacity_176: (std).ArrayList(u32) = .empty;
        var state_capacity_started_177 = false;

        defer (state_capacity_176).deinit(allocator);

        var state_capacity_178: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_179 = false;

        defer (state_capacity_178).deinit(allocator);

        var state_capacity_180: (std).ArrayList(u32) = .empty;
        var state_capacity_started_181 = false;

        defer (state_capacity_180).deinit(allocator);

        var state_capacity_182: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_183 = false;

        defer (state_capacity_182).deinit(allocator);

        var state_capacity_184: (std).ArrayList(u32) = .empty;
        var state_capacity_started_185 = false;

        defer (state_capacity_184).deinit(allocator);

        var state_capacity_186: (std).ArrayList(u32) = .empty;
        var state_capacity_started_187 = false;

        defer (state_capacity_186).deinit(allocator);

        var state_capacity_188: (std).ArrayList(u8) = .empty;
        var state_capacity_started_189 = false;

        defer (state_capacity_188).deinit(allocator);

        var state_capacity_190: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_191 = false;

        defer (state_capacity_190).deinit(allocator);

        var state_capacity_192: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_193 = false;

        defer (state_capacity_192).deinit(allocator);

        var state_capacity_194: (std).ArrayList(u32) = .empty;
        var state_capacity_started_195 = false;

        defer (state_capacity_194).deinit(allocator);

        var state_capacity_196: (std).ArrayList(u32) = .empty;
        var state_capacity_started_197 = false;

        defer (state_capacity_196).deinit(allocator);

        var state_capacity_198: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_199 = false;

        defer (state_capacity_198).deinit(allocator);

        var state_capacity_200: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_201 = false;

        defer (state_capacity_200).deinit(allocator);

        var state_capacity_202: (std).ArrayList(u32) = .empty;
        var state_capacity_started_203 = false;

        defer (state_capacity_202).deinit(allocator);

        var state_capacity_204: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_205 = false;

        defer (state_capacity_204).deinit(allocator);

        var state_capacity_206: (std).ArrayList(u32) = .empty;
        var state_capacity_started_207 = false;

        defer (state_capacity_206).deinit(allocator);

        var state_capacity_208: (std).ArrayList(u32) = .empty;
        var state_capacity_started_209 = false;

        defer (state_capacity_208).deinit(allocator);

        var state_capacity_210: (std).ArrayList(u8) = .empty;
        var state_capacity_started_211 = false;

        defer (state_capacity_210).deinit(allocator);

        var state_capacity_212: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_213 = false;

        defer (state_capacity_212).deinit(allocator);

        var state_capacity_214: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_215 = false;

        defer (state_capacity_214).deinit(allocator);

        var state_capacity_216: (std).ArrayList(u32) = .empty;
        var state_capacity_started_217 = false;

        defer (state_capacity_216).deinit(allocator);

        var state_capacity_218: (std).ArrayList(*const (zx_abi).zx_type_80) = .empty;
        var state_capacity_started_219 = false;

        defer (state_capacity_218).deinit(allocator);

        var state_capacity_220: (std).ArrayList([]const u8) = .empty;
        var state_capacity_started_221 = false;

        defer (state_capacity_220).deinit(allocator);

        var state_capacity_222: (std).ArrayList(u32) = .empty;
        var state_capacity_started_223 = false;

        defer (state_capacity_222).deinit(allocator);

        var state_167: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = operand_168;
        var state_changed_169 = false;

        while (((@as(u64, ((state_167).frames).len) != @as(u64, 0)) and block_226: {
            const operand_224 = ((state_167).diagnostic).message;
            const operand_225 = @as([]const u8, "");

            break :block_226 ((std).mem).eql(u8, operand_224, operand_225);
        })) {
            state_167 = @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, block_227: {
                break :block_227 (try function_54_buffered(allocator, state_167, .{ .lane_0 = .{ .buffer = (&state_capacity_170), .started = (&state_capacity_started_171), }, .lane_1 = .{ .buffer = (&state_capacity_172), .started = (&state_capacity_started_173), }, .lane_2 = .{ .buffer = (&state_capacity_174), .started = (&state_capacity_started_175), }, .lane_3 = .{ .buffer = (&state_capacity_176), .started = (&state_capacity_started_177), }, .lane_4 = .{ .buffer = (&state_capacity_178), .started = (&state_capacity_started_179), }, .lane_5 = .{ .buffer = (&state_capacity_180), .started = (&state_capacity_started_181), }, .lane_6 = .{ .buffer = (&state_capacity_182), .started = (&state_capacity_started_183), }, .lane_7 = .{ .buffer = (&state_capacity_184), .started = (&state_capacity_started_185), }, .lane_8 = .{ .buffer = (&state_capacity_186), .started = (&state_capacity_started_187), }, .lane_9 = .{ .buffer = (&state_capacity_188), .started = (&state_capacity_started_189), }, .lane_10 = .{ .buffer = (&state_capacity_190), .started = (&state_capacity_started_191), }, .lane_11 = .{ .buffer = (&state_capacity_192), .started = (&state_capacity_started_193), }, .lane_12 = .{ .buffer = (&state_capacity_194), .started = (&state_capacity_started_195), }, .lane_13 = .{ .buffer = (&state_capacity_196), .started = (&state_capacity_started_197), }, .lane_14 = .{ .buffer = (&state_capacity_198), .started = (&state_capacity_started_199), }, .lane_24 = .{ .buffer = (&state_capacity_200), .started = (&state_capacity_started_201), }, .lane_25 = .{ .buffer = (&state_capacity_202), .started = (&state_capacity_started_203), }, .lane_26 = .{ .buffer = (&state_capacity_204), .started = (&state_capacity_started_205), }, .lane_27 = .{ .buffer = (&state_capacity_206), .started = (&state_capacity_started_207), }, .lane_28 = .{ .buffer = (&state_capacity_208), .started = (&state_capacity_started_209), }, .lane_29 = .{ .buffer = (&state_capacity_210), .started = (&state_capacity_started_211), }, .lane_30 = .{ .buffer = (&state_capacity_212), .started = (&state_capacity_started_213), }, .lane_31 = .{ .buffer = (&state_capacity_214), .started = (&state_capacity_started_215), }, .lane_32 = .{ .buffer = (&state_capacity_216), .started = (&state_capacity_started_217), }, .lane_33 = .{ .buffer = (&state_capacity_218), .started = (&state_capacity_started_219), }, .lane_34 = .{ .buffer = (&state_capacity_220), .started = (&state_capacity_started_221), }, .lane_35 = .{ .buffer = (&state_capacity_222), .started = (&state_capacity_started_223), }, }));
            });

            state_changed_169 = true;
        }

        var state_owned_228: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_228);

        if (state_capacity_started_171) {
            ((state_capacity_170).items).len = ((state_167).active).len;
            state_owned_228 = (try (state_capacity_170).toOwnedSlice(allocator));
        }

        if (state_capacity_started_171) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = state_owned_228, .cache = (state_167).cache, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_229: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_229);

        if (state_capacity_started_173) {
            ((state_capacity_172).items).len = (((state_167).cache).ids).len;
            state_owned_229 = (try (state_capacity_172).toOwnedSlice(allocator));
        }

        if (state_capacity_started_173) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = block_231: {
                const operand_230 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_230).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_229, .names = ((state_167).cache).names, });

                break :block_231 @as(*const (zx_abi).zx_type_78, operand_230);
            }, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_232: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_232);

        if (state_capacity_started_175) {
            ((state_capacity_174).items).len = (((state_167).cache).names).len;
            state_owned_232 = (try (state_capacity_174).toOwnedSlice(allocator));
        }

        if (state_capacity_started_175) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = block_234: {
                const operand_233 = (try (allocator).create((zx_abi).zx_type_78));

                (operand_233).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = ((state_167).cache).ids, .names = state_owned_232, });

                break :block_234 @as(*const (zx_abi).zx_type_78, operand_233);
            }, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_235: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_235);

        if (state_capacity_started_177) {
            ((state_capacity_176).items).len = ((((state_167).context).aliases).ids).len;
            state_owned_235 = (try (state_capacity_176).toOwnedSlice(allocator));
        }

        if (state_capacity_started_177) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_239: {
                const operand_238 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_238).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = block_237: {
                    const operand_236 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_236).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_235, .names = (((state_167).context).aliases).names, });

                    break :block_237 @as(*const (zx_abi).zx_type_78, operand_236);
                }, .base = ((state_167).context).base, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_239 @as(*const (zx_abi).zx_type_79, operand_238);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_240: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_240);

        if (state_capacity_started_179) {
            ((state_capacity_178).items).len = ((((state_167).context).aliases).names).len;
            state_owned_240 = (try (state_capacity_178).toOwnedSlice(allocator));
        }

        if (state_capacity_started_179) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_244: {
                const operand_243 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_243).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = block_242: {
                    const operand_241 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_241).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = (((state_167).context).aliases).ids, .names = state_owned_240, });

                    break :block_242 @as(*const (zx_abi).zx_type_78, operand_241);
                }, .base = ((state_167).context).base, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_244 @as(*const (zx_abi).zx_type_79, operand_243);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_245: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_245);

        if (state_capacity_started_181) {
            ((state_capacity_180).items).len = ((((state_167).context).base).children).len;
            state_owned_245 = (try (state_capacity_180).toOwnedSlice(allocator));
        }

        if (state_capacity_started_181) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_249: {
                const operand_248 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_248).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_247: {
                    const operand_246 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_246).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_245, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_247 @as(*const (zx_abi).zx_type_15, operand_246);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_249 @as(*const (zx_abi).zx_type_79, operand_248);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_250: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_250);

        if (state_capacity_started_183) {
            ((state_capacity_182).items).len = ((((state_167).context).base).field_names).len;
            state_owned_250 = (try (state_capacity_182).toOwnedSlice(allocator));
        }

        if (state_capacity_started_183) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_254: {
                const operand_253 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_253).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_252: {
                    const operand_251 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_251).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = state_owned_250, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_252 @as(*const (zx_abi).zx_type_15, operand_251);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_254 @as(*const (zx_abi).zx_type_79, operand_253);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_255: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_255);

        if (state_capacity_started_185) {
            ((state_capacity_184).items).len = ((((state_167).context).base).field_types).len;
            state_owned_255 = (try (state_capacity_184).toOwnedSlice(allocator));
        }

        if (state_capacity_started_185) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_259: {
                const operand_258 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_258).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_257: {
                    const operand_256 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_256).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = state_owned_255, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_257 @as(*const (zx_abi).zx_type_15, operand_256);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_259 @as(*const (zx_abi).zx_type_79, operand_258);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_260: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_260);

        if (state_capacity_started_187) {
            ((state_capacity_186).items).len = ((((state_167).context).base).first).len;
            state_owned_260 = (try (state_capacity_186).toOwnedSlice(allocator));
        }

        if (state_capacity_started_187) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_264: {
                const operand_263 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_263).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_262: {
                    const operand_261 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_261).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = state_owned_260, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_262 @as(*const (zx_abi).zx_type_15, operand_261);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_264 @as(*const (zx_abi).zx_type_79, operand_263);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_265: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_265);

        if (state_capacity_started_189) {
            ((state_capacity_188).items).len = ((((state_167).context).base).kinds).len;
            state_owned_265 = (try (state_capacity_188).toOwnedSlice(allocator));
        }

        if (state_capacity_started_189) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_269: {
                const operand_268 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_268).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_267: {
                    const operand_266 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_266).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = state_owned_265, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_267 @as(*const (zx_abi).zx_type_15, operand_266);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_269 @as(*const (zx_abi).zx_type_79, operand_268);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_270: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_270);

        if (state_capacity_started_191) {
            ((state_capacity_190).items).len = ((((state_167).context).base).labels).len;
            state_owned_270 = (try (state_capacity_190).toOwnedSlice(allocator));
        }

        if (state_capacity_started_191) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_274: {
                const operand_273 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_273).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_272: {
                    const operand_271 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_271).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = state_owned_270, .names = (((state_167).context).base).names, .second = (((state_167).context).base).second, });

                    break :block_272 @as(*const (zx_abi).zx_type_15, operand_271);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_274 @as(*const (zx_abi).zx_type_79, operand_273);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_275: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_275);

        if (state_capacity_started_193) {
            ((state_capacity_192).items).len = ((((state_167).context).base).names).len;
            state_owned_275 = (try (state_capacity_192).toOwnedSlice(allocator));
        }

        if (state_capacity_started_193) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_279: {
                const operand_278 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_278).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_277: {
                    const operand_276 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_276).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = state_owned_275, .second = (((state_167).context).base).second, });

                    break :block_277 @as(*const (zx_abi).zx_type_15, operand_276);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_279 @as(*const (zx_abi).zx_type_79, operand_278);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_280: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_280);

        if (state_capacity_started_195) {
            ((state_capacity_194).items).len = ((((state_167).context).base).second).len;
            state_owned_280 = (try (state_capacity_194).toOwnedSlice(allocator));
        }

        if (state_capacity_started_195) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_284: {
                const operand_283 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_283).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = block_282: {
                    const operand_281 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_281).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_167).context).base).children, .field_names = (((state_167).context).base).field_names, .field_types = (((state_167).context).base).field_types, .first = (((state_167).context).base).first, .kinds = (((state_167).context).base).kinds, .labels = (((state_167).context).base).labels, .names = (((state_167).context).base).names, .second = state_owned_280, });

                    break :block_282 @as(*const (zx_abi).zx_type_15, operand_281);
                }, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_284 @as(*const (zx_abi).zx_type_79, operand_283);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_285: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_285);

        if (state_capacity_started_197) {
            ((state_capacity_196).items).len = ((((state_167).context).resolved).ids).len;
            state_owned_285 = (try (state_capacity_196).toOwnedSlice(allocator));
        }

        if (state_capacity_started_197) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_289: {
                const operand_288 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_288).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = ((state_167).context).base, .native_interface = ((state_167).context).native_interface, .resolved = block_287: {
                    const operand_286 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_286).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = state_owned_285, .names = (((state_167).context).resolved).names, });

                    break :block_287 @as(*const (zx_abi).zx_type_78, operand_286);
                }, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_289 @as(*const (zx_abi).zx_type_79, operand_288);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_290: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_290);

        if (state_capacity_started_199) {
            ((state_capacity_198).items).len = ((((state_167).context).resolved).names).len;
            state_owned_290 = (try (state_capacity_198).toOwnedSlice(allocator));
        }

        if (state_capacity_started_199) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_294: {
                const operand_293 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_293).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = ((state_167).context).base, .native_interface = ((state_167).context).native_interface, .resolved = block_292: {
                    const operand_291 = (try (allocator).create((zx_abi).zx_type_78));

                    (operand_291).* = @as((zx_abi).zx_type_78, (zx_abi).zx_type_78{ .ids = (((state_167).context).resolved).ids, .names = state_owned_290, });

                    break :block_292 @as(*const (zx_abi).zx_type_78, operand_291);
                }, .source = ((state_167).context).source, .visiting = ((state_167).context).visiting, });

                break :block_294 @as(*const (zx_abi).zx_type_79, operand_293);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_295: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_295);

        if (state_capacity_started_201) {
            ((state_capacity_200).items).len = (((state_167).context).visiting).len;
            state_owned_295 = (try (state_capacity_200).toOwnedSlice(allocator));
        }

        if (state_capacity_started_201) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = block_297: {
                const operand_296 = (try (allocator).create((zx_abi).zx_type_79));

                (operand_296).* = @as((zx_abi).zx_type_79, (zx_abi).zx_type_79{ .aliases = ((state_167).context).aliases, .base = ((state_167).context).base, .native_interface = ((state_167).context).native_interface, .resolved = ((state_167).context).resolved, .source = ((state_167).context).source, .visiting = state_owned_295, });

                break :block_297 @as(*const (zx_abi).zx_type_79, operand_296);
            }, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_298: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_298);

        if (state_capacity_started_203) {
            ((state_capacity_202).items).len = (((state_167).delta).children).len;
            state_owned_298 = (try (state_capacity_202).toOwnedSlice(allocator));
        }

        if (state_capacity_started_203) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_300: {
                const operand_299 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_299).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = state_owned_298, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_300 @as(*const (zx_abi).zx_type_15, operand_299);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_301: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_301);

        if (state_capacity_started_205) {
            ((state_capacity_204).items).len = (((state_167).delta).field_names).len;
            state_owned_301 = (try (state_capacity_204).toOwnedSlice(allocator));
        }

        if (state_capacity_started_205) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_303: {
                const operand_302 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_302).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = state_owned_301, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_303 @as(*const (zx_abi).zx_type_15, operand_302);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_304: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_304);

        if (state_capacity_started_207) {
            ((state_capacity_206).items).len = (((state_167).delta).field_types).len;
            state_owned_304 = (try (state_capacity_206).toOwnedSlice(allocator));
        }

        if (state_capacity_started_207) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_306: {
                const operand_305 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_305).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = state_owned_304, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_306 @as(*const (zx_abi).zx_type_15, operand_305);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_307: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_307);

        if (state_capacity_started_209) {
            ((state_capacity_208).items).len = (((state_167).delta).first).len;
            state_owned_307 = (try (state_capacity_208).toOwnedSlice(allocator));
        }

        if (state_capacity_started_209) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_309: {
                const operand_308 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_308).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = state_owned_307, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_309 @as(*const (zx_abi).zx_type_15, operand_308);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_310: []const u8 = (&[_]u8{});

        errdefer (allocator).free(state_owned_310);

        if (state_capacity_started_211) {
            ((state_capacity_210).items).len = (((state_167).delta).kinds).len;
            state_owned_310 = (try (state_capacity_210).toOwnedSlice(allocator));
        }

        if (state_capacity_started_211) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_312: {
                const operand_311 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_311).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = state_owned_310, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_312 @as(*const (zx_abi).zx_type_15, operand_311);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_313: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_313);

        if (state_capacity_started_213) {
            ((state_capacity_212).items).len = (((state_167).delta).labels).len;
            state_owned_313 = (try (state_capacity_212).toOwnedSlice(allocator));
        }

        if (state_capacity_started_213) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_315: {
                const operand_314 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_314).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = state_owned_313, .names = ((state_167).delta).names, .second = ((state_167).delta).second, });

                break :block_315 @as(*const (zx_abi).zx_type_15, operand_314);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_316: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_316);

        if (state_capacity_started_215) {
            ((state_capacity_214).items).len = (((state_167).delta).names).len;
            state_owned_316 = (try (state_capacity_214).toOwnedSlice(allocator));
        }

        if (state_capacity_started_215) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_318: {
                const operand_317 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_317).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = state_owned_316, .second = ((state_167).delta).second, });

                break :block_318 @as(*const (zx_abi).zx_type_15, operand_317);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_319: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_319);

        if (state_capacity_started_217) {
            ((state_capacity_216).items).len = (((state_167).delta).second).len;
            state_owned_319 = (try (state_capacity_216).toOwnedSlice(allocator));
        }

        if (state_capacity_started_217) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = block_321: {
                const operand_320 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_320).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = ((state_167).delta).children, .field_names = ((state_167).delta).field_names, .field_types = ((state_167).delta).field_types, .first = ((state_167).delta).first, .kinds = ((state_167).delta).kinds, .labels = ((state_167).delta).labels, .names = ((state_167).delta).names, .second = state_owned_319, });

                break :block_321 @as(*const (zx_abi).zx_type_15, operand_320);
            }, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_322: []const *const (zx_abi).zx_type_80 = (&[_]*const (zx_abi).zx_type_80{});

        errdefer (allocator).free(state_owned_322);

        if (state_capacity_started_219) {
            ((state_capacity_218).items).len = ((state_167).frames).len;
            state_owned_322 = (try (state_capacity_218).toOwnedSlice(allocator));
        }

        if (state_capacity_started_219) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = state_owned_322, .result = (state_167).result, .scratch = (state_167).scratch, };
        }

        var state_owned_323: []const []const u8 = (&[_][]const u8{});

        errdefer (allocator).free(state_owned_323);

        if (state_capacity_started_221) {
            ((state_capacity_220).items).len = (((state_167).scratch).names).len;
            state_owned_323 = (try (state_capacity_220).toOwnedSlice(allocator));
        }

        if (state_capacity_started_221) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = block_325: {
                const operand_324 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_324).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = state_owned_323, .types = ((state_167).scratch).types, });

                break :block_325 @as(*const (zx_abi).zx_type_18, operand_324);
            }, };
        }

        var state_owned_326: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_326);

        if (state_capacity_started_223) {
            ((state_capacity_222).items).len = (((state_167).scratch).types).len;
            state_owned_326 = (try (state_capacity_222).toOwnedSlice(allocator));
        }

        if (state_capacity_started_223) {
            state_167 = (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (state_167).active, .cache = (state_167).cache, .context = (state_167).context, .delta = (state_167).delta, .diagnostic = (state_167).diagnostic, .frames = (state_167).frames, .result = (state_167).result, .scratch = block_328: {
                const operand_327 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_327).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = ((state_167).scratch).names, .types = state_owned_326, });

                break :block_328 @as(*const (zx_abi).zx_type_18, operand_327);
            }, };
        }

        break :block_330 (if (state_changed_169) state_167 else operand_168);
    };
}

fn function_56(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_139) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_84 {
    @setRuntimeSafety(true);

    if ((!(in).initialize)) {
        const value_1: *const (zx_abi).zx_type_82 = (try function_55(allocator, (in).state));

        return block_53: {
            const operand_47 = (value_1).delta;
            const operand_48 = (value_1).cache;
            const operand_49 = (value_1).result;
            const operand_50 = (value_1).diagnostic;

            break :block_53 block_52: {
                const operand_51 = (try (allocator).create((zx_abi).zx_type_84));

                (operand_51).* = @as((zx_abi).zx_type_84, (zx_abi).zx_type_84{ .delta = operand_47, .cache = operand_48, .id = operand_49, .diagnostic = operand_50, });

                break :block_52 @as(*const (zx_abi).zx_type_84, operand_51);
            };
        };
    }

    const value_2: *const (zx_abi).zx_type_82 = (try function_18(allocator, (in).state));

    const value_15: *const (zx_abi).zx_type_97 = block_46: {
        var state_8: *const (zx_abi).zx_type_97 = block_14: {
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = (try function_16(allocator, (((in).state).context).source));

            break :block_14 block_13: {
                const operand_12 = (try (allocator).create((zx_abi).zx_type_97));

                (operand_12).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .state = operand_9, .index = operand_10, .count = operand_11, });

                break :block_13 @as(*const (zx_abi).zx_type_97, operand_12);
            };
        };

        while ((((state_8).index < (state_8).count) and block_17: {
            const operand_15 = (((state_8).state).diagnostic).message;
            const operand_16 = @as([]const u8, "");

            break :block_17 ((std).mem).eql(u8, operand_15, operand_16);
        })) {
            state_8 = block_44: {
                const value_5: *const (zx_abi).zx_type_65 = (try function_12(allocator, block_43: {
                    const operand_39 = (((state_8).state).context).source;
                    const operand_40 = (state_8).index;

                    break :block_43 block_42: {
                        const operand_41 = (try (allocator).create((zx_abi).zx_type_89));

                        (operand_41).* = @as((zx_abi).zx_type_89, (zx_abi).zx_type_89{ .source = operand_39, .index = operand_40, });

                        break :block_42 @as(*const (zx_abi).zx_type_89, operand_41);
                    };
                }));

                const value_6: *const (zx_abi).zx_type_80 = (try function_2(allocator, block_38: {
                    const operand_33 = @as((zx_abi).zx_type_77, .Name);
                    const operand_34 = (value_5).name;
                    const operand_35 = (value_5).value;

                    break :block_38 block_37: {
                        const operand_36 = (try (allocator).create((zx_abi).zx_type_85));

                        (operand_36).* = @as((zx_abi).zx_type_85, (zx_abi).zx_type_85{ .operation = operand_33, .name = operand_34, .reference = operand_35, });

                        break :block_37 @as(*const (zx_abi).zx_type_85, operand_36);
                    };
                }));

                const value_7: *const (zx_abi).zx_type_97 = state_8;

                _ = (value_7).state;

                const value_9: *const (zx_abi).zx_type_82 = (try function_55(allocator, block_32: {
                    const operand_24 = (state_8).state;

                    const operand_25 = (block_29: {
                        const operand_26 = ((state_8).state).frames;
                        const operand_27 = value_6;
                        const operand_28 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_26).len, 1))));

                        @memcpy((operand_28)[0..(operand_26).len], operand_26);
                        (operand_28)[(operand_26).len] = operand_27;

                        break :block_29 @as((zx_abi).zx_type_136, .{ operand_28, {}, });
                    }).@"0";

                    break :block_32 block_31: {
                        const operand_30 = (try (allocator).create((zx_abi).zx_type_82));

                        (operand_30).* = @as((zx_abi).zx_type_82, (zx_abi).zx_type_82{ .active = (operand_24).active, .cache = (operand_24).cache, .context = (operand_24).context, .delta = (operand_24).delta, .diagnostic = (operand_24).diagnostic, .frames = operand_25, .result = (operand_24).result, .scratch = (operand_24).scratch, });

                        break :block_31 @as(*const (zx_abi).zx_type_82, operand_30);
                    };
                }));

                const value_10: *const (zx_abi).zx_type_97 = block_23: {
                    break :block_23 block_22: {
                        const operand_21 = (try (allocator).create((zx_abi).zx_type_97));

                        (operand_21).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .count = (value_7).count, .index = (value_7).index, .state = value_9, });

                        break :block_22 @as(*const (zx_abi).zx_type_97, operand_21);
                    };
                };

                const value_11: *const (zx_abi).zx_type_97 = value_10;
                const value_12: u64 = (value_11).index;
                const value_13: u64 = @as(u64, 1);

                const value_14: *const (zx_abi).zx_type_97 = block_20: {
                    break :block_20 block_19: {
                        const operand_18 = (try (allocator).create((zx_abi).zx_type_97));

                        (operand_18).* = @as((zx_abi).zx_type_97, (zx_abi).zx_type_97{ .count = (value_11).count, .index = (value_12 + value_13), .state = (value_11).state, });

                        break :block_19 @as(*const (zx_abi).zx_type_97, operand_18);
                    };
                };

                break :block_44 value_14;
            };
        }

        break :block_46 state_8;
    };

    return block_7: {
        const operand_1 = ((value_15).state).delta;
        const operand_2 = ((value_15).state).cache;
        const operand_3 = ((value_15).state).result;
        const operand_4 = ((value_15).state).diagnostic;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_84));

            (operand_5).* = @as((zx_abi).zx_type_84, (zx_abi).zx_type_84{ .delta = operand_1, .cache = operand_2, .id = operand_3, .diagnostic = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_84, operand_5);
        };
    };
}

fn function_56_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_139_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    if ((!(in).initialize)) {
        const value_1: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_109: {
            break :block_109 (try function_55_value(allocator, (in).state));
        };

        return block_108: {
            const operand_104 = (value_1).delta;
            const operand_105 = (value_1).cache;
            const operand_106 = (value_1).result;
            const operand_107 = (value_1).diagnostic;

            break :block_108 @as((zx_abi).value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .delta = operand_104, .cache = operand_105, .id = operand_106, .diagnostic = operand_107, });
        };
    }

    const value_2: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_103: {
        break :block_103 (try function_18_value(allocator, (in).state));
    };

    const value_15: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_102: {
        const operand_66 = block_65: {
            const operand_60 = value_2;
            const operand_61 = @as(u64, 0);

            const operand_62 = block_64: {
                const operand_63 = (((in).state).context).source;

                break :block_64 (try function_16(allocator, operand_63));
            };

            break :block_65 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .state = operand_60, .index = operand_61, .count = operand_62, });
        };

        var state_59: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = operand_66;
        var state_changed_67 = false;

        while ((((state_59).index < (state_59).count) and block_70: {
            const operand_68 = (((state_59).state).diagnostic).message;
            const operand_69 = @as([]const u8, "");

            break :block_70 ((std).mem).eql(u8, operand_68, operand_69);
        })) {
            state_59 = block_100: {
                const value_5: *const (zx_abi).zx_type_65 = block_99: {
                    const operand_96 = block_95: {
                        const operand_93 = (((state_59).state).context).source;
                        const operand_94 = (state_59).index;

                        break :block_95 @as((zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .source = operand_93, .index = operand_94, });
                    };

                    break :block_99 (try function_12(allocator, (if (((operand_96).zx_origin != null)) (operand_96).zx_origin.? else block_98: {
                        const operand_97 = (try (allocator).create((zx_abi).zx_type_89));

                        (operand_97).* = (zx_abi).zx_type_89{ .index = (operand_96).index, .source = (operand_96).source, };

                        break :block_98 @as(*const (zx_abi).zx_type_89, operand_97);
                    })));
                };
                const value_6: *const (zx_abi).zx_type_80 = block_92: {
                    const operand_90 = block_89: {
                        const operand_84 = @as((zx_abi).zx_type_77, .Name);

                        const operand_85 = (block_86: {
                            break :block_86 value_5;
                        }).name;

                        const operand_87 = (block_88: {
                            break :block_88 value_5;
                        }).value;

                        break :block_89 @as((zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .operation = operand_84, .name = operand_85, .reference = operand_87, });
                    };

                    var state_borrow_91: (zx_abi).zx_type_85 = undefined;

                    state_borrow_91 = (zx_abi).zx_type_85{ .name = (operand_90).name, .operation = (operand_90).operation, .reference = (operand_90).reference, };

                    break :block_92 (try function_2(allocator, ((operand_90).zx_origin orelse (&state_borrow_91))));
                };

                const value_7: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = state_59;

                _ = (value_7).state;

                const value_9: (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = block_83: {
                    break :block_83 (try function_55_value(allocator, block_82: {
                        const operand_75 = (state_59).state;

                        const operand_76 = (block_81: {
                            const operand_77 = ((state_59).state).frames;

                            const operand_79 = block_78: {
                                break :block_78 value_6;
                            };

                            const operand_80 = (try (allocator).alloc(*const (zx_abi).zx_type_80, (try ((std).math).add(usize, (operand_77).len, 1))));

                            @memcpy((operand_80)[0..(operand_77).len], operand_77);
                            (operand_80)[(operand_77).len] = operand_79;

                            break :block_81 @as((zx_abi).value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_80, {}, null, });
                        }).@"0";

                        break :block_82 @as((zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, (zx_abi).value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b{ .active = (operand_75).active, .cache = (operand_75).cache, .context = (operand_75).context, .delta = (operand_75).delta, .diagnostic = (operand_75).diagnostic, .frames = operand_76, .result = (operand_75).result, .scratch = (operand_75).scratch, });
                    }));
                };

                const value_10: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_74: {
                    break :block_74 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .count = (value_7).count, .index = (value_7).index, .state = value_9, });
                };

                const value_11: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = value_10;
                const value_12: u64 = (value_11).index;
                const value_13: u64 = @as(u64, 1);

                const value_14: (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = block_73: {
                    break :block_73 @as((zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13, (zx_abi).value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13{ .count = (value_11).count, .index = (block_71: {
                        break :block_71 value_12;
                    } + block_72: {
                        break :block_72 value_13;
                    }), .state = (value_11).state, });
                };

                break :block_100 value_14;
            };

            state_changed_67 = true;
        }

        break :block_102 (if (state_changed_67) state_59 else operand_66);
    };

    return block_58: {
        const operand_54 = ((value_15).state).delta;
        const operand_55 = ((value_15).state).cache;
        const operand_56 = ((value_15).state).result;
        const operand_57 = ((value_15).state).diagnostic;

        break :block_58 @as((zx_abi).value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .delta = operand_54, .cache = operand_55, .id = operand_56, .diagnostic = operand_57, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_83) error{ IndexOutOfBounds, IntegerOverflow, InvalidUtf8, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_84 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_82 = (try function_1(allocator, in));

    const value_2: *const (zx_abi).zx_type_84 = (try function_56(allocator, block_5: {
        const operand_1 = value_1;
        const operand_2 = (in).initialize;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_139));

            (operand_3).* = @as((zx_abi).zx_type_139, (zx_abi).zx_type_139{ .state = operand_1, .initialize = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_139, operand_3);
        };
    }));

    return value_2;
}

fn zx_compare_10(context: void, left: []const u8, right: []const u8) bool {
    _ = context;

    return ((std).mem).lessThan(u8, left, right);
}
