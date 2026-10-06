const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_23;
pub const Output = *const (zx_abi).zx_type_22;
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
const zx_shape_18 = .{ .kind = .object, .fields = .{ .name = zx_shape_10, .type_id = zx_shape_4, }, };
const zx_shape_19 = .{ .kind = .list, .child = zx_shape_18, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .children = zx_shape_13, .fields = zx_shape_19, .first = zx_shape_4, .kind = zx_shape_11, .label = zx_shape_10, .names = zx_shape_14, .second = zx_shape_4, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .delta = zx_shape_15, .id = zx_shape_4, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_20, .tables = zx_shape_16, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_20, .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_20, .count = zx_shape_5, .equal = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_20, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .fields = zx_shape_19, .name = zx_shape_10, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .fields = zx_shape_19, .index = zx_shape_5, .name = zx_shape_10, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .fields = zx_shape_19, .index = zx_shape_5, .names = zx_shape_14, .sorted = zx_shape_19, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_23;
pub const output_shape = zx_shape_22;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_11) error{ }!u8 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as((zx_abi).zx_type_11, .Scalar))) @as(u8, 0) else (if ((operand_1 == @as((zx_abi).zx_type_11, .Object))) @as(u8, 1) else (if ((operand_1 == @as((zx_abi).zx_type_11, .Optional))) @as(u8, 2) else (if ((operand_1 == @as((zx_abi).zx_type_11, .List))) @as(u8, 3) else (if ((operand_1 == @as((zx_abi).zx_type_11, .Tuple))) @as(u8, 4) else (if ((operand_1 == @as((zx_abi).zx_type_11, .ErrorSet))) @as(u8, 5) else (if ((operand_1 == @as((zx_abi).zx_type_11, .Task))) @as(u8, 6) else (if ((operand_1 == @as((zx_abi).zx_type_11, .Enumeration))) @as(u8, 7) else @as(u8, 8)))))))));
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = ((in).tables).delta;
    const value_2: *const (zx_abi).zx_type_20 = (in).candidate;
    const value_3: u32 = (try function_1(allocator, (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((value_1).kinds).len))));

    const value_4: u32 = block_60: {
        const operand_59 = (value_2).kind;

        break :block_60 (if ((operand_59 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((value_1).field_types).len))) else (if ((operand_59 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((value_1).children).len))) else (if ((operand_59 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((value_1).names).len))) else (if ((operand_59 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((value_1).names).len))) else (value_2).first))));
    };

    const value_5: u32 = block_58: {
        const operand_57 = (value_2).kind;

        break :block_58 (if ((operand_57 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((value_2).fields).len))) else (if ((operand_57 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((value_2).children).len))) else (if ((operand_57 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((value_2).names).len))) else (if ((operand_57 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((value_2).names).len))) else (value_2).second))));
    };

    const value_7: []const []const u8 = block_56: {
        const operand_53 = (value_2).fields;
        const operand_54 = (try (allocator).alloc([]const u8, (operand_53).len));

        for (operand_53, 0..) |value_6, index_55| {
            (operand_54)[index_55] = (value_6).name;
        }

        break :block_56 operand_54;
    };

    const value_9: []const u32 = block_52: {
        const operand_49 = (value_2).fields;
        const operand_50 = (try (allocator).alloc(u32, (operand_49).len));

        for (operand_49, 0..) |value_8, index_51| {
            (operand_50)[index_51] = (value_8).type_id;
        }

        break :block_52 operand_50;
    };

    return block_48: {
        const operand_1 = value_3;
        const operand_2 = block_45: {
            const operand_3 = (block_7: {
                const operand_4 = (value_1).kinds;
                const operand_5 = (try function_2(allocator, (value_2).kind));
                const operand_6 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_4).len, 1))));

                @memcpy((operand_6)[0..(operand_4).len], operand_4);

                (operand_6)[(operand_4).len] = operand_5;

                break :block_7 @as((zx_abi).zx_type_24, .{ operand_6, {}, });
            }).@"0";
            const operand_8 = (block_12: {
                const operand_9 = (value_1).first;
                const operand_10 = value_4;
                const operand_11 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_9).len, 1))));

                @memcpy((operand_11)[0..(operand_9).len], operand_9);

                (operand_11)[(operand_9).len] = operand_10;

                break :block_12 @as((zx_abi).zx_type_25, .{ operand_11, {}, });
            }).@"0";

            const operand_13 = (block_17: {
                const operand_14 = (value_1).second;
                const operand_15 = value_5;
                const operand_16 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_14).len, 1))));

                @memcpy((operand_16)[0..(operand_14).len], operand_14);

                (operand_16)[(operand_14).len] = operand_15;

                break :block_17 @as((zx_abi).zx_type_25, .{ operand_16, {}, });
            }).@"0";
            const operand_18 = (block_22: {
                const operand_19 = (value_1).labels;
                const operand_20 = (value_2).label;
                const operand_21 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_19).len, 1))));

                @memcpy((operand_21)[0..(operand_19).len], operand_19);

                (operand_21)[(operand_19).len] = operand_20;

                break :block_22 @as((zx_abi).zx_type_26, .{ operand_21, {}, });
            }).@"0";
            const operand_23 = (block_27: {
                const operand_24 = (value_1).children;
                const operand_25 = (value_2).children;
                const operand_26 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_24).len, (operand_25).len))));

                @memcpy((operand_26)[0..(operand_24).len], operand_24);
                @memcpy((operand_26)[(operand_24).len..], operand_25);

                break :block_27 @as((zx_abi).zx_type_25, .{ operand_26, {}, });
            }).@"0";

            const operand_28 = (block_32: {
                const operand_29 = (value_1).field_names;
                const operand_30 = value_7;
                const operand_31 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_29).len, (operand_30).len))));

                @memcpy((operand_31)[0..(operand_29).len], operand_29);
                @memcpy((operand_31)[(operand_29).len..], operand_30);

                break :block_32 @as((zx_abi).zx_type_26, .{ operand_31, {}, });
            }).@"0";

            const operand_33 = (block_37: {
                const operand_34 = (value_1).field_types;
                const operand_35 = value_9;
                const operand_36 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_34).len, (operand_35).len))));

                @memcpy((operand_36)[0..(operand_34).len], operand_34);
                @memcpy((operand_36)[(operand_34).len..], operand_35);

                break :block_37 @as((zx_abi).zx_type_25, .{ operand_36, {}, });
            }).@"0";

            const operand_38 = (block_42: {
                const operand_39 = (value_1).names;
                const operand_40 = (value_2).names;
                const operand_41 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_39).len, (operand_40).len))));

                @memcpy((operand_41)[0..(operand_39).len], operand_39);
                @memcpy((operand_41)[(operand_39).len..], operand_40);

                break :block_42 @as((zx_abi).zx_type_26, .{ operand_41, {}, });
            }).@"0";

            break :block_45 block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_43).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_3, .first = operand_8, .second = operand_13, .labels = operand_18, .children = operand_23, .field_names = operand_28, .field_types = operand_33, .names = operand_38, });

                break :block_44 @as(*const (zx_abi).zx_type_15, operand_43);
            };
        };

        break :block_48 block_47: {
            const operand_46 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_46).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .id = operand_1, .delta = operand_2, });

            break :block_47 @as(*const (zx_abi).zx_type_22, operand_46);
        };
    };
}

fn function_3_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_23_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = ((in).tables).delta;
    const value_2: (zx_abi).value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (in).candidate;

    const value_3: u32 = block_158: {
        const operand_157 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((block_156: {
            break :block_156 value_1;
        }).kinds).len));

        break :block_158 (try function_1(allocator, operand_157));
    };

    const value_4: u32 = block_155: {
        const operand_142 = (value_2).kind;

        break :block_155 (if ((operand_142 == @as((zx_abi).zx_type_11, .Object))) block_154: {
            const operand_153 = @as(u64, ((block_152: {
                break :block_152 value_1;
            }).field_types).len);

            break :block_154 (try function_1(allocator, operand_153));
        } else (if ((operand_142 == @as((zx_abi).zx_type_11, .Tuple))) block_151: {
            const operand_150 = @as(u64, ((block_149: {
                break :block_149 value_1;
            }).children).len);

            break :block_151 (try function_1(allocator, operand_150));
        } else (if ((operand_142 == @as((zx_abi).zx_type_11, .ErrorSet))) block_148: {
            const operand_147 = @as(u64, ((block_146: {
                break :block_146 value_1;
            }).names).len);

            break :block_148 (try function_1(allocator, operand_147));
        } else (if ((operand_142 == @as((zx_abi).zx_type_11, .Enumeration))) block_145: {
            const operand_144 = @as(u64, ((block_143: {
                break :block_143 value_1;
            }).names).len);

            break :block_145 (try function_1(allocator, operand_144));
        } else (value_2).first))));
    };

    const value_5: u32 = block_141: {
        const operand_132 = (value_2).kind;

        break :block_141 (if ((operand_132 == @as((zx_abi).zx_type_11, .Object))) block_140: {
            const operand_139 = @as(u64, ((value_2).fields).len);

            break :block_140 (try function_1(allocator, operand_139));
        } else (if ((operand_132 == @as((zx_abi).zx_type_11, .Tuple))) block_138: {
            const operand_137 = @as(u64, ((value_2).children).len);

            break :block_138 (try function_1(allocator, operand_137));
        } else (if ((operand_132 == @as((zx_abi).zx_type_11, .ErrorSet))) block_136: {
            const operand_135 = @as(u64, ((value_2).names).len);

            break :block_136 (try function_1(allocator, operand_135));
        } else (if ((operand_132 == @as((zx_abi).zx_type_11, .Enumeration))) block_134: {
            const operand_133 = @as(u64, ((value_2).names).len);

            break :block_134 (try function_1(allocator, operand_133));
        } else (value_2).second))));
    };

    const value_7: []const []const u8 = block_131: {
        const operand_127 = (value_2).fields;
        const operand_129 = (try (allocator).alloc([]const u8, (operand_127).len));

        for (operand_127, 0..) |value_6, index_130| {
            (operand_129)[index_130] = (block_128: {
                break :block_128 value_6;
            }).name;
        }

        break :block_131 operand_129;
    };

    const value_9: []const u32 = block_126: {
        const operand_122 = (value_2).fields;
        const operand_124 = (try (allocator).alloc(u32, (operand_122).len));

        for (operand_122, 0..) |value_8, index_125| {
            (operand_124)[index_125] = (block_123: {
                break :block_123 value_8;
            }).type_id;
        }

        break :block_126 operand_124;
    };

    return block_121: {
        const operand_61 = block_62: {
            break :block_62 value_3;
        };
        const operand_63 = block_120: {
            const operand_64 = (block_71: {
                const operand_66 = (block_65: {
                    break :block_65 value_1;
                }).kinds;

                const operand_69 = block_68: {
                    const operand_67 = (value_2).kind;

                    break :block_68 (try function_2(allocator, operand_67));
                };

                const operand_70 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_66).len, 1))));

                @memcpy((operand_70)[0..(operand_66).len], operand_66);

                (operand_70)[(operand_66).len] = operand_69;

                break :block_71 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_70, {}, null, });
            }).@"0";

            const operand_72 = (block_78: {
                const operand_74 = (block_73: {
                    break :block_73 value_1;
                }).first;
                const operand_76 = block_75: {
                    break :block_75 value_4;
                };

                const operand_77 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_74).len, 1))));

                @memcpy((operand_77)[0..(operand_74).len], operand_74);

                (operand_77)[(operand_74).len] = operand_76;

                break :block_78 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_77, {}, null, });
            }).@"0";

            const operand_79 = (block_85: {
                const operand_81 = (block_80: {
                    break :block_80 value_1;
                }).second;
                const operand_83 = block_82: {
                    break :block_82 value_5;
                };

                const operand_84 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_81).len, 1))));

                @memcpy((operand_84)[0..(operand_81).len], operand_81);

                (operand_84)[(operand_81).len] = operand_83;

                break :block_85 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_84, {}, null, });
            }).@"0";

            const operand_86 = (block_91: {
                const operand_88 = (block_87: {
                    break :block_87 value_1;
                }).labels;

                const operand_89 = (value_2).label;
                const operand_90 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_88).len, 1))));

                @memcpy((operand_90)[0..(operand_88).len], operand_88);

                (operand_90)[(operand_88).len] = operand_89;

                break :block_91 @as((zx_abi).value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_90, {}, null, });
            }).@"0";

            const operand_92 = (block_97: {
                const operand_94 = (block_93: {
                    break :block_93 value_1;
                }).children;

                const operand_95 = (value_2).children;
                const operand_96 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_94).len, (operand_95).len))));

                @memcpy((operand_96)[0..(operand_94).len], operand_94);
                @memcpy((operand_96)[(operand_94).len..], operand_95);

                break :block_97 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_96, {}, null, });
            }).@"0";

            const operand_98 = (block_104: {
                const operand_100 = (block_99: {
                    break :block_99 value_1;
                }).field_names;

                const operand_102 = block_101: {
                    break :block_101 value_7;
                };

                const operand_103 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_100).len, (operand_102).len))));

                @memcpy((operand_103)[0..(operand_100).len], operand_100);
                @memcpy((operand_103)[(operand_100).len..], operand_102);

                break :block_104 @as((zx_abi).value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_103, {}, null, });
            }).@"0";

            const operand_105 = (block_111: {
                const operand_107 = (block_106: {
                    break :block_106 value_1;
                }).field_types;

                const operand_109 = block_108: {
                    break :block_108 value_9;
                };

                const operand_110 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_107).len, (operand_109).len))));

                @memcpy((operand_110)[0..(operand_107).len], operand_107);
                @memcpy((operand_110)[(operand_107).len..], operand_109);

                break :block_111 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_110, {}, null, });
            }).@"0";

            const operand_112 = (block_117: {
                const operand_114 = (block_113: {
                    break :block_113 value_1;
                }).names;

                const operand_115 = (value_2).names;
                const operand_116 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_114).len, (operand_115).len))));

                @memcpy((operand_116)[0..(operand_114).len], operand_114);
                @memcpy((operand_116)[(operand_114).len..], operand_115);

                break :block_117 @as((zx_abi).value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_116, {}, null, });
            }).@"0";

            break :block_120 block_119: {
                const operand_118 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_118).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_64, .first = operand_72, .second = operand_79, .labels = operand_86, .children = operand_92, .field_names = operand_98, .field_types = operand_105, .names = operand_112, });

                break :block_119 @as(*const (zx_abi).zx_type_15, operand_118);
            };
        };

        break :block_121 @as((zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .id = operand_61, .delta = operand_63, });
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_11, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_11, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_11, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_11, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_11, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_11, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_11, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_11, .Enumeration) else @as((zx_abi).zx_type_11, .NativeReference)))))))));
    };
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_17 {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_0(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_15 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_4(allocator, block_4: {
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

fn function_5_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_27_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);

    const value_2: u64 = block_58: {
        const operand_57 = (in).id;

        break :block_58 (try function_0(allocator, operand_57));
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

            break :block_28 (try function_4(allocator, operand_27));
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

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_28) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_17 = block_66: {
        const operand_62 = block_61: {
            const operand_59 = (in).tables;
            const operand_60 = (in).id;

            break :block_61 (zx_abi).zx_type_27{ .tables = operand_59, .id = operand_60, };
        };

        const operand_63 = (&operand_62);
        const operand_64 = (try function_5_value(allocator, (zx_abi).value_zx_type_27_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_63).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_63).tables).base, .delta = ((operand_63).tables).delta, .zx_origin = (operand_63).tables, }, .zx_origin = operand_63, }));

        break :block_66 (if (((operand_64).zx_origin != null)) ((operand_64).zx_origin.?).* else block_65: {
            break :block_65 (zx_abi).zx_type_17{ .delta = (operand_64).delta, .first = (operand_64).first, .kind = (operand_64).kind, .label = (operand_64).label, .second = (operand_64).second, };
        });
    };

    const value_2: (zx_abi).zx_type_20 = ((in).candidate).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_11, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_11, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((&value_1)).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return false;
    }

    const value_3: (zx_abi).zx_type_15 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_4: u64 = (try function_0(allocator, ((&value_1)).first));
    const value_5: u64 = (try function_0(allocator, ((&value_1)).second));

    const value_6: u64 = block_58: {
        const operand_57 = ((&value_1)).kind;

        break :block_58 (if ((operand_57 == @as((zx_abi).zx_type_11, .Object))) @as(u64, (((&value_2)).fields).len) else (if ((operand_57 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, (((&value_2)).children).len) else @as(u64, (((&value_2)).names).len)));
    };

    if ((value_5 != value_6)) {
        return false;
    }

    const value_12: (zx_abi).zx_type_29 = block_56: {
        const operand_9 = block_8: {
            const operand_2 = (&value_3);
            const operand_3 = (&value_2);
            const operand_4 = value_4;
            const operand_5 = value_5;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_29{ .table = operand_2, .candidate = operand_3, .first = operand_4, .count = operand_5, .index = operand_6, .equal = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef = (zx_abi).value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef{ .candidate = (zx_abi).value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .children = ((operand_9).candidate).children, .fields = ((operand_9).candidate).fields, .first = ((operand_9).candidate).first, .kind = ((operand_9).candidate).kind, .label = ((operand_9).candidate).label, .names = ((operand_9).candidate).names, .second = ((operand_9).candidate).second, .zx_origin = (operand_9).candidate, }, .count = (operand_9).count, .equal = (operand_9).equal, .first = (operand_9).first, .index = (operand_9).index, .table = (operand_9).table, .zx_origin = (&operand_9), };

        while (((state_1).equal and ((state_1).index < (state_1).count))) {
            state_1 = block_51: {
                const value_9: u64 = ((state_1).first + (state_1).index);

                const value_10: bool = block_50: {
                    const operand_15 = ((state_1).candidate).kind;

                    break :block_50 (if ((operand_15 == @as((zx_abi).zx_type_11, .Object))) (block_42: {
                        const operand_40 = block_36: {
                            const operand_34 = ((state_1).table).field_names;

                            const operand_35 = block_33: {
                                break :block_33 value_9;
                            };

                            if ((operand_35 >= (operand_34).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_36 (operand_34)[@intCast(operand_35)];
                        };
                        const operand_41 = (block_39: {
                            const operand_37 = ((state_1).candidate).fields;
                            const operand_38 = (state_1).index;

                            if ((operand_38 >= (operand_37).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_39 (operand_37)[@intCast(operand_38)];
                        }).name;

                        break :block_42 ((std).mem).eql(u8, operand_40, operand_41);
                    } and (block_46: {
                        const operand_44 = ((state_1).table).field_types;

                        const operand_45 = block_43: {
                            break :block_43 value_9;
                        };

                        if ((operand_45 >= (operand_44).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_46 (operand_44)[@intCast(operand_45)];
                    } == (block_49: {
                        const operand_47 = ((state_1).candidate).fields;
                        const operand_48 = (state_1).index;

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    }).type_id)) else (if ((operand_15 == @as((zx_abi).zx_type_11, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).table).children;

                        const operand_28 = block_26: {
                            break :block_26 value_9;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_32: {
                        const operand_30 = ((state_1).candidate).children;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    }) else block_25: {
                        const operand_23 = block_19: {
                            const operand_17 = ((state_1).table).names;

                            const operand_18 = block_16: {
                                break :block_16 value_9;
                            };

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_19 (operand_17)[@intCast(operand_18)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).candidate).names;
                            const operand_21 = (state_1).index;

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_11: (zx_abi).value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef = block_14: {
                    const operand_10 = state_1;
                    const operand_11 = ((state_1).index + @as(u64, 1));

                    const operand_12 = block_13: {
                        break :block_13 value_10;
                    };

                    break :block_14 @as((zx_abi).value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef, (zx_abi).value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef{ .candidate = (operand_10).candidate, .count = (operand_10).count, .equal = operand_12, .first = (operand_10).first, .index = operand_11, .table = (operand_10).table, });
                };

                break :block_51 value_11;
            };
        }

        break :block_56 block_55: {
            break :block_55 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_54: {
                break :block_54 (zx_abi).zx_type_29{ .candidate = (if ((((state_1).candidate).zx_origin != null)) ((state_1).candidate).zx_origin.? else block_53: {
                    const operand_52 = (try (allocator).create((zx_abi).zx_type_20));

                    (operand_52).* = (zx_abi).zx_type_20{ .children = ((state_1).candidate).children, .fields = ((state_1).candidate).fields, .first = ((state_1).candidate).first, .kind = ((state_1).candidate).kind, .label = ((state_1).candidate).label, .names = ((state_1).candidate).names, .second = ((state_1).candidate).second, };

                    break :block_53 @as(*const (zx_abi).zx_type_20, operand_52);
                }), .count = (state_1).count, .equal = (state_1).equal, .first = (state_1).first, .index = (state_1).index, .table = (state_1).table, };
            });
        };
    };

    return ((&value_12)).equal;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_23) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_21 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_57: {
            const operand_53 = false;
            const operand_54 = @as(u32, 0);

            break :block_57 block_56: {
                const operand_55 = (try (allocator).create((zx_abi).zx_type_21));

                (operand_55).* = @as((zx_abi).zx_type_21, (zx_abi).zx_type_21{ .found = operand_53, .id = operand_54, });

                break :block_56 @as(*const (zx_abi).zx_type_21, operand_55);
            };
        };
    }

    const value_1: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_7: *const (zx_abi).zx_type_30 = block_52: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_1;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = (try function_1(allocator, @as(u64, 0)));

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_30));

                (operand_13).* = @as((zx_abi).zx_type_30, (zx_abi).zx_type_30{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_30, operand_13);
            };
        };
        const state_type_18 = struct {
            children: []const u32,
            fields: []const *const (zx_abi).zx_type_18,
            first: u32,
            kind: (zx_abi).zx_type_11,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };
        const state_type_19 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_20 = struct {
            base: state_type_19,
            delta: state_type_19,
        };

        const state_type_21 = struct {
            candidate: state_type_18,
            count: u64,
            found: bool,
            id: u32,
            index: u64,
            tables: state_type_20,
        };
        const state_type_27 = struct {
            candidate: state_type_18,
            id: u32,
            tables: state_type_20,
        };

        var state_6: state_type_21 = state_type_21{ .candidate = state_type_18{ .children = ((operand_16).candidate).children, .fields = ((operand_16).candidate).fields, .first = ((operand_16).candidate).first, .kind = ((operand_16).candidate).kind, .label = ((operand_16).candidate).label, .names = ((operand_16).candidate).names, .second = ((operand_16).candidate).second, }, .count = (operand_16).count, .found = (operand_16).found, .id = (operand_16).id, .index = (operand_16).index, .tables = state_type_20{ .base = state_type_19{ .children = (((operand_16).tables).base).children, .field_names = (((operand_16).tables).base).field_names, .field_types = (((operand_16).tables).base).field_types, .first = (((operand_16).tables).base).first, .kinds = (((operand_16).tables).base).kinds, .labels = (((operand_16).tables).base).labels, .names = (((operand_16).tables).base).names, .second = (((operand_16).tables).base).second, }, .delta = state_type_19{ .children = (((operand_16).tables).delta).children, .field_names = (((operand_16).tables).delta).field_names, .field_types = (((operand_16).tables).delta).field_types, .first = (((operand_16).tables).delta).first, .kinds = (((operand_16).tables).delta).kinds, .labels = (((operand_16).tables).delta).labels, .names = (((operand_16).tables).delta).names, .second = (((operand_16).tables).delta).second, }, }, };
        var state_changed_17 = false;

        while (((!(state_6).found) and ((state_6).index < (state_6).count))) {
            state_6 = block_40: {
                const value_4: u32 = (try function_1(allocator, (state_6).index));

                const value_5: bool = block_39: {
                    const operand_32 = block_31: {
                        const operand_28 = (state_6).tables;
                        const operand_29 = value_4;
                        const operand_30 = (state_6).candidate;

                        break :block_31 state_type_27{ .tables = operand_28, .id = operand_29, .candidate = operand_30, };
                    };

                    const operand_33 = (zx_abi).zx_type_20{ .children = ((operand_32).candidate).children, .fields = ((operand_32).candidate).fields, .first = ((operand_32).candidate).first, .kind = ((operand_32).candidate).kind, .label = ((operand_32).candidate).label, .names = ((operand_32).candidate).names, .second = ((operand_32).candidate).second, };
                    const operand_34 = (zx_abi).zx_type_15{ .children = (((operand_32).tables).base).children, .field_names = (((operand_32).tables).base).field_names, .field_types = (((operand_32).tables).base).field_types, .first = (((operand_32).tables).base).first, .kinds = (((operand_32).tables).base).kinds, .labels = (((operand_32).tables).base).labels, .names = (((operand_32).tables).base).names, .second = (((operand_32).tables).base).second, };
                    const operand_35 = (zx_abi).zx_type_15{ .children = (((operand_32).tables).delta).children, .field_names = (((operand_32).tables).delta).field_names, .field_types = (((operand_32).tables).delta).field_types, .first = (((operand_32).tables).delta).first, .kinds = (((operand_32).tables).delta).kinds, .labels = (((operand_32).tables).delta).labels, .names = (((operand_32).tables).delta).names, .second = (((operand_32).tables).delta).second, };
                    const operand_36 = (zx_abi).zx_type_16{ .base = (&operand_34), .delta = (&operand_35), };
                    const operand_37 = (zx_abi).zx_type_28{ .candidate = (&operand_33), .id = (operand_32).id, .tables = (&operand_36), };
                    const operand_38 = (try function_6(allocator, (&operand_37)));

                    break :block_39 operand_38;
                };
                const value_6: state_type_21 = block_26: {
                    const operand_22 = state_6;
                    const operand_23 = ((state_6).index + @as(u64, 1));
                    const operand_24 = value_5;
                    const operand_25 = value_4;

                    break :block_26 state_type_21{ .candidate = (operand_22).candidate, .count = (operand_22).count, .found = operand_24, .id = operand_25, .index = operand_23, .tables = (operand_22).tables, };
                };

                break :block_40 value_6;
            };

            state_changed_17 = true;
        }

        break :block_52 (if (state_changed_17) block_51: {
            const operand_50 = (try (allocator).create((zx_abi).zx_type_30));

            (operand_50).* = @as((zx_abi).zx_type_30, (zx_abi).zx_type_30{ .candidate = block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_20));

                (operand_42).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .children = ((state_6).candidate).children, .fields = ((state_6).candidate).fields, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_43 @as(*const (zx_abi).zx_type_20, operand_42);
            }, .count = (state_6).count, .found = (state_6).found, .id = (state_6).id, .index = (state_6).index, .tables = block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_48).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .base = block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_44).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_45 @as(*const (zx_abi).zx_type_15, operand_44);
                }, .delta = block_47: {
                    const operand_46 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_46).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_47 @as(*const (zx_abi).zx_type_15, operand_46);
                }, });

                break :block_49 @as(*const (zx_abi).zx_type_16, operand_48);
            }, });

            break :block_51 @as(*const (zx_abi).zx_type_30, operand_50);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_7).found;
        const operand_2 = (value_7).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_21));

            (operand_3).* = @as((zx_abi).zx_type_21, (zx_abi).zx_type_21{ .found = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_21, operand_3);
        };
    };
}

fn function_7_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_23_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_98: {
            const operand_96 = false;
            const operand_97 = @as(u32, 0);

            break :block_98 @as((zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_96, .id = operand_97, });
        };
    }

    const value_1: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_7: (zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = block_95: {
        const operand_72 = block_71: {
            const operand_62 = (in).tables;
            const operand_63 = (in).candidate;

            const operand_64 = block_65: {
                break :block_65 value_1;
            };

            const operand_66 = @as(u64, 0);
            const operand_67 = false;

            const operand_68 = block_70: {
                const operand_69 = @as(u64, 0);

                break :block_70 (try function_1(allocator, operand_69));
            };

            break :block_71 @as((zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3, (zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3{ .tables = operand_62, .candidate = operand_63, .count = operand_64, .index = operand_66, .found = operand_67, .id = operand_68, });
        };

        var state_61: (zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = operand_72;
        var state_changed_73 = false;

        while (((!(state_61).found) and ((state_61).index < (state_61).count))) {
            state_61 = block_93: {
                const value_4: u32 = block_92: {
                    const operand_91 = (state_61).index;

                    break :block_92 (try function_1(allocator, operand_91));
                };
                const value_5: bool = block_90: {
                    const operand_86 = block_85: {
                        const operand_81 = (state_61).tables;

                        const operand_82 = block_83: {
                            break :block_83 value_4;
                        };

                        const operand_84 = (state_61).candidate;

                        break :block_85 @as((zx_abi).value_zx_type_28_867ec9aa987e04cef9004f10d74da0de91acec53c3b161384080c48e933b23d1, (zx_abi).value_zx_type_28_867ec9aa987e04cef9004f10d74da0de91acec53c3b161384080c48e933b23d1{ .tables = operand_81, .id = operand_82, .candidate = operand_84, });
                    };

                    var state_borrow_87: (zx_abi).zx_type_20 = undefined;

                    state_borrow_87 = (zx_abi).zx_type_20{ .children = ((operand_86).candidate).children, .fields = ((operand_86).candidate).fields, .first = ((operand_86).candidate).first, .kind = ((operand_86).candidate).kind, .label = ((operand_86).candidate).label, .names = ((operand_86).candidate).names, .second = ((operand_86).candidate).second, };

                    var state_borrow_88: (zx_abi).zx_type_16 = undefined;
                    state_borrow_88 = (zx_abi).zx_type_16{ .base = ((operand_86).tables).base, .delta = ((operand_86).tables).delta, };

                    var state_borrow_89: (zx_abi).zx_type_28 = undefined;

                    state_borrow_89 = (zx_abi).zx_type_28{ .candidate = (((operand_86).candidate).zx_origin orelse (&state_borrow_87)), .id = (operand_86).id, .tables = (((operand_86).tables).zx_origin orelse (&state_borrow_88)), };

                    break :block_90 (try function_6(allocator, ((operand_86).zx_origin orelse (&state_borrow_89))));
                };
                const value_6: (zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = block_80: {
                    const operand_74 = state_61;
                    const operand_75 = ((state_61).index + @as(u64, 1));

                    const operand_76 = block_77: {
                        break :block_77 value_5;
                    };
                    const operand_78 = block_79: {
                        break :block_79 value_4;
                    };

                    break :block_80 @as((zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3, (zx_abi).value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3{ .candidate = (operand_74).candidate, .count = (operand_74).count, .found = operand_76, .id = operand_78, .index = operand_75, .tables = (operand_74).tables, });
                };

                break :block_93 value_6;
            };

            state_changed_73 = true;
        }

        break :block_95 (if (state_changed_73) state_61 else operand_72);
    };

    return block_60: {
        const operand_58 = (value_7).found;
        const operand_59 = (value_7).id;

        break :block_60 @as((zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_58, .id = operand_59, });
    };
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    const value_7: *const (zx_abi).zx_type_32 = block_28: {
        const operand_11 = block_10: {
            const operand_5 = (in).fields;
            const operand_6 = (in).name;
            const operand_7 = @as(u64, 0);

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_32));

                (operand_8).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .fields = operand_5, .name = operand_6, .index = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_32, operand_8);
            };
        };
        const state_type_17 = struct {
            name: []const u8,
            type_id: u32,
        };
        const state_type_22 = struct {
            fields: []const *const (zx_abi).zx_type_18,
            index: u64,
            name: []const u8,
        };

        var state_4: state_type_22 = state_type_22{ .fields = (operand_11).fields, .index = (operand_11).index, .name = (operand_11).name, };
        var state_changed_12 = false;

        while ((!block_21: {
            const operand_19 = (block_18: {
                const operand_16 = block_15: {
                    const operand_13 = (state_4).fields;
                    const operand_14 = (state_4).index;

                    if ((operand_14 >= (operand_13).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_15 (operand_13)[@intCast(operand_14)];
                };

                break :block_18 state_type_17{ .name = (operand_16).name, .type_id = (operand_16).type_id, };
            }).name;

            const operand_20 = (state_4).name;

            break :block_21 ((std).mem).eql(u8, operand_19, operand_20);
        })) {
            state_4 = block_24: {
                const value_3: state_type_22 = state_4;
                const value_4: u64 = (value_3).index;
                const value_5: u64 = @as(u64, 1);

                const value_6: state_type_22 = block_23: {
                    break :block_23 state_type_22{ .fields = (value_3).fields, .index = (value_4 + value_5), .name = (value_3).name, };
                };

                break :block_24 value_6;
            };

            state_changed_12 = true;
        }

        break :block_28 (if (state_changed_12) block_27: {
            const operand_26 = (try (allocator).create((zx_abi).zx_type_32));

            (operand_26).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .fields = (state_4).fields, .index = (state_4).index, .name = (state_4).name, });

            break :block_27 @as(*const (zx_abi).zx_type_32, operand_26);
        } else operand_11);
    };

    return block_3: {
        const operand_1 = (value_7).fields;
        const operand_2 = (value_7).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

fn function_8_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_31) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_7: (zx_abi).zx_type_32 = block_50: {
        const operand_37 = block_36: {
            const operand_33 = (in).fields;
            const operand_34 = (in).name;
            const operand_35 = @as(u64, 0);

            break :block_36 (zx_abi).zx_type_32{ .fields = operand_33, .name = operand_34, .index = operand_35, };
        };

        var state_32: (zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .fields = (operand_37).fields, .index = (operand_37).index, .name = (operand_37).name, .zx_origin = (&operand_37), };

        while ((!block_43: {
            const operand_41 = (block_40: {
                const operand_38 = (state_32).fields;
                const operand_39 = (state_32).index;

                if ((operand_39 >= (operand_38).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_40 (operand_38)[@intCast(operand_39)];
            }).name;

            const operand_42 = (state_32).name;

            break :block_43 ((std).mem).eql(u8, operand_41, operand_42);
        })) {
            state_32 = block_47: {
                const value_3: (zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_32;
                const value_4: u64 = (value_3).index;
                const value_5: u64 = @as(u64, 1);

                const value_6: (zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_46: {
                    break :block_46 @as((zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .fields = (value_3).fields, .index = (block_44: {
                        break :block_44 value_4;
                    } + block_45: {
                        break :block_45 value_5;
                    }), .name = (value_3).name, });
                };

                break :block_47 value_6;
            };
        }

        break :block_50 block_49: {
            break :block_49 (if (((state_32).zx_origin != null)) ((state_32).zx_origin.?).* else block_48: {
                break :block_48 (zx_abi).zx_type_32{ .fields = (state_32).fields, .index = (state_32).index, .name = (state_32).name, };
            });
        };
    };

    return (block_31: {
        const operand_29 = ((&value_7)).fields;
        const operand_30 = ((&value_7)).index;

        if ((operand_30 >= (operand_29).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_31 (operand_29)[@intCast(operand_30)];
    }).*;
}

fn function_9(allocator: ((std).mem).Allocator, in: []const *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    const value_2: []const []const u8 = (block_37: {
        const operand_35 = block_34: {
            const operand_31 = in;
            const operand_32 = (try (allocator).alloc([]const u8, (operand_31).len));

            for (operand_31, 0..) |value_1, index_33| {
                (operand_32)[index_33] = (value_1).name;
            }

            break :block_34 operand_32;
        };

        const operand_36 = (try (allocator).alloc([]const u8, (operand_35).len));

        @memcpy(operand_36, operand_35);
        ((std).mem).sortUnstable([]const u8, operand_36, {}, zx_compare_10);

        break :block_37 @as((zx_abi).zx_type_26, .{ operand_36, {}, });
    }).@"0";

    const value_3: []const *const (zx_abi).zx_type_18 = block_30: {
        break :block_30 (try (allocator).dupe(*const (zx_abi).zx_type_18, (&[_]*const (zx_abi).zx_type_18{})));
    };

    const value_15: *const (zx_abi).zx_type_33 = block_29: {
        var state_1: *const (zx_abi).zx_type_33 = block_8: {
            const operand_2 = in;
            const operand_3 = value_2;
            const operand_4 = value_3;
            const operand_5 = @as(u64, 0);

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_33));

                (operand_6).* = @as((zx_abi).zx_type_33, (zx_abi).zx_type_33{ .fields = operand_2, .names = operand_3, .sorted = operand_4, .index = operand_5, });

                break :block_7 @as(*const (zx_abi).zx_type_33, operand_6);
            };
        };

        while (((state_1).index < @as(u64, ((state_1).names).len))) {
            state_1 = block_27: {
                const value_6: *const (zx_abi).zx_type_18 = (try function_8(allocator, block_26: {
                    const operand_19 = (state_1).fields;

                    const operand_20 = block_23: {
                        const operand_21 = (state_1).names;
                        const operand_22 = (state_1).index;

                        if ((operand_22 >= (operand_21).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_23 (operand_21)[@intCast(operand_22)];
                    };

                    break :block_26 block_25: {
                        const operand_24 = (try (allocator).create((zx_abi).zx_type_31));

                        (operand_24).* = @as((zx_abi).zx_type_31, (zx_abi).zx_type_31{ .fields = operand_19, .name = operand_20, });

                        break :block_25 @as(*const (zx_abi).zx_type_31, operand_24);
                    };
                }));

                const value_7: *const (zx_abi).zx_type_33 = state_1;

                _ = (value_7).sorted;

                const value_9: []const *const (zx_abi).zx_type_18 = (block_18: {
                    const operand_15 = (state_1).sorted;
                    const operand_16 = value_6;
                    const operand_17 = (try (allocator).alloc(*const (zx_abi).zx_type_18, (try ((std).math).add(usize, (operand_15).len, 1))));

                    @memcpy((operand_17)[0..(operand_15).len], operand_15);

                    (operand_17)[(operand_15).len] = operand_16;

                    break :block_18 @as((zx_abi).zx_type_34, .{ operand_17, {}, });
                }).@"0";

                const value_10: *const (zx_abi).zx_type_33 = block_14: {
                    break :block_14 block_13: {
                        const operand_12 = (try (allocator).create((zx_abi).zx_type_33));

                        (operand_12).* = @as((zx_abi).zx_type_33, (zx_abi).zx_type_33{ .fields = (value_7).fields, .index = (value_7).index, .names = (value_7).names, .sorted = value_9, });

                        break :block_13 @as(*const (zx_abi).zx_type_33, operand_12);
                    };
                };

                const value_11: *const (zx_abi).zx_type_33 = value_10;
                const value_12: u64 = (value_11).index;
                const value_13: u64 = @as(u64, 1);

                const value_14: *const (zx_abi).zx_type_33 = block_11: {
                    break :block_11 block_10: {
                        const operand_9 = (try (allocator).create((zx_abi).zx_type_33));

                        (operand_9).* = @as((zx_abi).zx_type_33, (zx_abi).zx_type_33{ .fields = (value_11).fields, .index = (value_12 + value_13), .names = (value_11).names, .sorted = (value_11).sorted, });

                        break :block_10 @as(*const (zx_abi).zx_type_33, operand_9);
                    };
                };

                break :block_27 value_14;
            };
        }

        break :block_29 state_1;
    };

    return (value_15).sorted;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_23) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_22 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: []const *const (zx_abi).zx_type_18 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (try function_9(allocator, ((in).candidate).fields)) else ((in).candidate).fields);

    const value_2: []const []const u8 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_24: {
        const operand_22 = ((in).candidate).names;
        const operand_23 = (try (allocator).alloc([]const u8, (operand_22).len));

        @memcpy(operand_23, operand_22);

        ((std).mem).sortUnstable([]const u8, operand_23, {}, zx_compare_10);

        break :block_24 @as((zx_abi).zx_type_26, .{ operand_23, {}, });
    }).@"0" else ((in).candidate).names);

    const value_3: *const (zx_abi).zx_type_20 = block_21: {
        const operand_16 = (in).candidate;
        const operand_17 = value_1;
        const operand_18 = value_2;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_19).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .children = (operand_16).children, .fields = operand_17, .first = (operand_16).first, .kind = (operand_16).kind, .label = (operand_16).label, .names = operand_18, .second = (operand_16).second, });

            break :block_20 @as(*const (zx_abi).zx_type_20, operand_19);
        };
    };

    const value_4: *const (zx_abi).zx_type_21 = (try function_7(allocator, block_15: {
        const operand_11 = (in).tables;
        const operand_12 = value_3;

        break :block_15 block_14: {
            const operand_13 = (try (allocator).create((zx_abi).zx_type_23));

            (operand_13).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .tables = operand_11, .candidate = operand_12, });

            break :block_14 @as(*const (zx_abi).zx_type_23, operand_13);
        };
    }));

    if ((value_4).found) {
        return block_10: {
            const operand_6 = ((in).tables).delta;
            const operand_7 = (value_4).id;

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_22));

                (operand_8).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .delta = operand_6, .id = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_22, operand_8);
            };
        };
    }

    return (try function_3(allocator, block_5: {
        const operand_1 = (in).tables;
        const operand_2 = value_3;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_23));

            (operand_3).* = @as((zx_abi).zx_type_23, (zx_abi).zx_type_23{ .tables = operand_1, .candidate = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_23, operand_3);
        };
    }));
}

fn zx_compare_10(context: void, left: []const u8, right: []const u8) bool {
    _ = context;

    return ((std).mem).lessThan(u8, left, right);
}
