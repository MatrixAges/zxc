const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_22;
pub const Output = *const (zx_abi).zx_type_21;
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
const zx_shape_22 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .tables = zx_shape_16, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_24 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_0, }, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_0, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .id = zx_shape_4, .tables = zx_shape_16, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .equal = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .table = zx_shape_15, }, };
const zx_shape_29 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_19, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_16, }, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .fields = zx_shape_18, .name = zx_shape_10, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .fields = zx_shape_18, .index = zx_shape_5, .name = zx_shape_10, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .fields = zx_shape_18, .index = zx_shape_5, .names = zx_shape_14, .sorted = zx_shape_13, }, };
pub const input_shape = zx_shape_22;
pub const output_shape = zx_shape_21;

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

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_22) error{ IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_21 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = ((in).tables).delta;
    const value_2: *const (zx_abi).zx_type_19 = (in).candidate;
    const value_3: u32 = (try function_1(allocator, (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((value_1).kinds).len))));

    const value_4: u32 = block_52: {
        const operand_51 = (value_2).kind;

        break :block_52 (if ((operand_51 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, ((value_1).field_types).len))) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((value_1).children).len))) else (if ((operand_51 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((value_1).names).len))) else (if ((operand_51 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((value_1).names).len))) else (value_2).first))));
    };

    const value_5: u32 = block_50: {
        const operand_49 = (value_2).kind;

        break :block_50 (if ((operand_49 == @as((zx_abi).zx_type_11, .Object))) (try function_1(allocator, @as(u64, (((value_2).fields).names).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .Tuple))) (try function_1(allocator, @as(u64, ((value_2).children).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .ErrorSet))) (try function_1(allocator, @as(u64, ((value_2).names).len))) else (if ((operand_49 == @as((zx_abi).zx_type_11, .Enumeration))) (try function_1(allocator, @as(u64, ((value_2).names).len))) else (value_2).second))));
    };

    const value_6: []const []const u8 = ((value_2).fields).names;
    const value_7: []const u32 = ((value_2).fields).types;

    return block_48: {
        const operand_1 = value_3;
        const operand_2 = block_45: {
            const operand_3 = (block_7: {
                const operand_4 = (value_1).kinds;
                const operand_5 = (try function_2(allocator, (value_2).kind));
                const operand_6 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_4).len, 1))));

                @memcpy((operand_6)[0..(operand_4).len], operand_4);

                (operand_6)[(operand_4).len] = operand_5;

                break :block_7 @as((zx_abi).zx_type_23, .{ operand_6, {}, });
            }).@"0";
            const operand_8 = (block_12: {
                const operand_9 = (value_1).first;
                const operand_10 = value_4;
                const operand_11 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_9).len, 1))));

                @memcpy((operand_11)[0..(operand_9).len], operand_9);

                (operand_11)[(operand_9).len] = operand_10;

                break :block_12 @as((zx_abi).zx_type_24, .{ operand_11, {}, });
            }).@"0";

            const operand_13 = (block_17: {
                const operand_14 = (value_1).second;
                const operand_15 = value_5;
                const operand_16 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_14).len, 1))));

                @memcpy((operand_16)[0..(operand_14).len], operand_14);

                (operand_16)[(operand_14).len] = operand_15;

                break :block_17 @as((zx_abi).zx_type_24, .{ operand_16, {}, });
            }).@"0";
            const operand_18 = (block_22: {
                const operand_19 = (value_1).labels;
                const operand_20 = (value_2).label;
                const operand_21 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_19).len, 1))));

                @memcpy((operand_21)[0..(operand_19).len], operand_19);

                (operand_21)[(operand_19).len] = operand_20;

                break :block_22 @as((zx_abi).zx_type_25, .{ operand_21, {}, });
            }).@"0";
            const operand_23 = (block_27: {
                const operand_24 = (value_1).children;
                const operand_25 = (value_2).children;
                const operand_26 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_24).len, (operand_25).len))));

                @memcpy((operand_26)[0..(operand_24).len], operand_24);
                @memcpy((operand_26)[(operand_24).len..], operand_25);

                break :block_27 @as((zx_abi).zx_type_24, .{ operand_26, {}, });
            }).@"0";

            const operand_28 = (block_32: {
                const operand_29 = (value_1).field_names;
                const operand_30 = value_6;
                const operand_31 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_29).len, (operand_30).len))));

                @memcpy((operand_31)[0..(operand_29).len], operand_29);
                @memcpy((operand_31)[(operand_29).len..], operand_30);

                break :block_32 @as((zx_abi).zx_type_25, .{ operand_31, {}, });
            }).@"0";

            const operand_33 = (block_37: {
                const operand_34 = (value_1).field_types;
                const operand_35 = value_7;
                const operand_36 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_34).len, (operand_35).len))));

                @memcpy((operand_36)[0..(operand_34).len], operand_34);
                @memcpy((operand_36)[(operand_34).len..], operand_35);

                break :block_37 @as((zx_abi).zx_type_24, .{ operand_36, {}, });
            }).@"0";

            const operand_38 = (block_42: {
                const operand_39 = (value_1).names;
                const operand_40 = (value_2).names;
                const operand_41 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_39).len, (operand_40).len))));

                @memcpy((operand_41)[0..(operand_39).len], operand_39);
                @memcpy((operand_41)[(operand_39).len..], operand_40);

                break :block_42 @as((zx_abi).zx_type_25, .{ operand_41, {}, });
            }).@"0";

            break :block_45 block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_43).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_3, .first = operand_8, .second = operand_13, .labels = operand_18, .children = operand_23, .field_names = operand_28, .field_types = operand_33, .names = operand_38, });

                break :block_44 @as(*const (zx_abi).zx_type_15, operand_43);
            };
        };

        break :block_48 block_47: {
            const operand_46 = (try (allocator).create((zx_abi).zx_type_21));

            (operand_46).* = @as((zx_abi).zx_type_21, (zx_abi).zx_type_21{ .id = operand_1, .delta = operand_2, });

            break :block_47 @as(*const (zx_abi).zx_type_21, operand_46);
        };
    };
}

fn function_3_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_22_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = ((in).tables).delta;
    const value_2: (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = (in).candidate;

    const value_3: u32 = block_140: {
        const operand_139 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((block_138: {
            break :block_138 value_1;
        }).kinds).len));

        break :block_140 (try function_1(allocator, operand_139));
    };

    const value_4: u32 = block_137: {
        const operand_124 = (value_2).kind;

        break :block_137 (if ((operand_124 == @as((zx_abi).zx_type_11, .Object))) block_136: {
            const operand_135 = @as(u64, ((block_134: {
                break :block_134 value_1;
            }).field_types).len);

            break :block_136 (try function_1(allocator, operand_135));
        } else (if ((operand_124 == @as((zx_abi).zx_type_11, .Tuple))) block_133: {
            const operand_132 = @as(u64, ((block_131: {
                break :block_131 value_1;
            }).children).len);

            break :block_133 (try function_1(allocator, operand_132));
        } else (if ((operand_124 == @as((zx_abi).zx_type_11, .ErrorSet))) block_130: {
            const operand_129 = @as(u64, ((block_128: {
                break :block_128 value_1;
            }).names).len);

            break :block_130 (try function_1(allocator, operand_129));
        } else (if ((operand_124 == @as((zx_abi).zx_type_11, .Enumeration))) block_127: {
            const operand_126 = @as(u64, ((block_125: {
                break :block_125 value_1;
            }).names).len);

            break :block_127 (try function_1(allocator, operand_126));
        } else (value_2).first))));
    };

    const value_5: u32 = block_123: {
        const operand_114 = (value_2).kind;

        break :block_123 (if ((operand_114 == @as((zx_abi).zx_type_11, .Object))) block_122: {
            const operand_121 = @as(u64, (((value_2).fields).names).len);

            break :block_122 (try function_1(allocator, operand_121));
        } else (if ((operand_114 == @as((zx_abi).zx_type_11, .Tuple))) block_120: {
            const operand_119 = @as(u64, ((value_2).children).len);

            break :block_120 (try function_1(allocator, operand_119));
        } else (if ((operand_114 == @as((zx_abi).zx_type_11, .ErrorSet))) block_118: {
            const operand_117 = @as(u64, ((value_2).names).len);

            break :block_118 (try function_1(allocator, operand_117));
        } else (if ((operand_114 == @as((zx_abi).zx_type_11, .Enumeration))) block_116: {
            const operand_115 = @as(u64, ((value_2).names).len);

            break :block_116 (try function_1(allocator, operand_115));
        } else (value_2).second))));
    };

    const value_6: []const []const u8 = ((value_2).fields).names;
    const value_7: []const u32 = ((value_2).fields).types;

    return block_113: {
        const operand_53 = block_54: {
            break :block_54 value_3;
        };
        const operand_55 = block_112: {
            const operand_56 = (block_63: {
                const operand_58 = (block_57: {
                    break :block_57 value_1;
                }).kinds;
                const operand_61 = block_60: {
                    const operand_59 = (value_2).kind;

                    break :block_60 (try function_2(allocator, operand_59));
                };

                const operand_62 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_58).len, 1))));

                @memcpy((operand_62)[0..(operand_58).len], operand_58);

                (operand_62)[(operand_58).len] = operand_61;

                break :block_63 @as((zx_abi).value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_62, {}, null, });
            }).@"0";

            const operand_64 = (block_70: {
                const operand_66 = (block_65: {
                    break :block_65 value_1;
                }).first;

                const operand_68 = block_67: {
                    break :block_67 value_4;
                };

                const operand_69 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_66).len, 1))));

                @memcpy((operand_69)[0..(operand_66).len], operand_66);

                (operand_69)[(operand_66).len] = operand_68;

                break :block_70 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_69, {}, null, });
            }).@"0";

            const operand_71 = (block_77: {
                const operand_73 = (block_72: {
                    break :block_72 value_1;
                }).second;
                const operand_75 = block_74: {
                    break :block_74 value_5;
                };

                const operand_76 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_73).len, 1))));

                @memcpy((operand_76)[0..(operand_73).len], operand_73);

                (operand_76)[(operand_73).len] = operand_75;

                break :block_77 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_76, {}, null, });
            }).@"0";

            const operand_78 = (block_83: {
                const operand_80 = (block_79: {
                    break :block_79 value_1;
                }).labels;

                const operand_81 = (value_2).label;
                const operand_82 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_80).len, 1))));

                @memcpy((operand_82)[0..(operand_80).len], operand_80);

                (operand_82)[(operand_80).len] = operand_81;

                break :block_83 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_82, {}, null, });
            }).@"0";

            const operand_84 = (block_89: {
                const operand_86 = (block_85: {
                    break :block_85 value_1;
                }).children;

                const operand_87 = (value_2).children;
                const operand_88 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_86).len, (operand_87).len))));

                @memcpy((operand_88)[0..(operand_86).len], operand_86);
                @memcpy((operand_88)[(operand_86).len..], operand_87);

                break :block_89 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_88, {}, null, });
            }).@"0";

            const operand_90 = (block_96: {
                const operand_92 = (block_91: {
                    break :block_91 value_1;
                }).field_names;
                const operand_94 = block_93: {
                    break :block_93 value_6;
                };

                const operand_95 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_92).len, (operand_94).len))));

                @memcpy((operand_95)[0..(operand_92).len], operand_92);
                @memcpy((operand_95)[(operand_92).len..], operand_94);

                break :block_96 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_95, {}, null, });
            }).@"0";

            const operand_97 = (block_103: {
                const operand_99 = (block_98: {
                    break :block_98 value_1;
                }).field_types;

                const operand_101 = block_100: {
                    break :block_100 value_7;
                };

                const operand_102 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_99).len, (operand_101).len))));

                @memcpy((operand_102)[0..(operand_99).len], operand_99);
                @memcpy((operand_102)[(operand_99).len..], operand_101);

                break :block_103 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_102, {}, null, });
            }).@"0";
            const operand_104 = (block_109: {
                const operand_106 = (block_105: {
                    break :block_105 value_1;
                }).names;

                const operand_107 = (value_2).names;
                const operand_108 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_106).len, (operand_107).len))));

                @memcpy((operand_108)[0..(operand_106).len], operand_106);
                @memcpy((operand_108)[(operand_106).len..], operand_107);

                break :block_109 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_108, {}, null, });
            }).@"0";

            break :block_112 block_111: {
                const operand_110 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_110).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_56, .first = operand_64, .second = operand_71, .labels = operand_78, .children = operand_84, .field_names = operand_90, .field_types = operand_97, .names = operand_104, });

                break :block_111 @as(*const (zx_abi).zx_type_15, operand_110);
            };
        };

        break :block_113 @as((zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .id = operand_53, .delta = operand_55, });
    };
}

fn function_3_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_22_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22, buffers: struct {
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
}) error{ IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = ((in).tables).delta;
    const value_2: (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = (in).candidate;

    const value_3: u32 = block_266: {
        const operand_265 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((block_264: {
            break :block_264 value_1;
        }).kinds).len));

        break :block_266 (try function_1(allocator, operand_265));
    };

    const value_4: u32 = block_263: {
        const operand_250 = (value_2).kind;

        break :block_263 (if ((operand_250 == @as((zx_abi).zx_type_11, .Object))) block_262: {
            const operand_261 = @as(u64, ((block_260: {
                break :block_260 value_1;
            }).field_types).len);

            break :block_262 (try function_1(allocator, operand_261));
        } else (if ((operand_250 == @as((zx_abi).zx_type_11, .Tuple))) block_259: {
            const operand_258 = @as(u64, ((block_257: {
                break :block_257 value_1;
            }).children).len);

            break :block_259 (try function_1(allocator, operand_258));
        } else (if ((operand_250 == @as((zx_abi).zx_type_11, .ErrorSet))) block_256: {
            const operand_255 = @as(u64, ((block_254: {
                break :block_254 value_1;
            }).names).len);

            break :block_256 (try function_1(allocator, operand_255));
        } else (if ((operand_250 == @as((zx_abi).zx_type_11, .Enumeration))) block_253: {
            const operand_252 = @as(u64, ((block_251: {
                break :block_251 value_1;
            }).names).len);

            break :block_253 (try function_1(allocator, operand_252));
        } else (value_2).first))));
    };

    const value_5: u32 = block_249: {
        const operand_240 = (value_2).kind;

        break :block_249 (if ((operand_240 == @as((zx_abi).zx_type_11, .Object))) block_248: {
            const operand_247 = @as(u64, (((value_2).fields).names).len);

            break :block_248 (try function_1(allocator, operand_247));
        } else (if ((operand_240 == @as((zx_abi).zx_type_11, .Tuple))) block_246: {
            const operand_245 = @as(u64, ((value_2).children).len);

            break :block_246 (try function_1(allocator, operand_245));
        } else (if ((operand_240 == @as((zx_abi).zx_type_11, .ErrorSet))) block_244: {
            const operand_243 = @as(u64, ((value_2).names).len);

            break :block_244 (try function_1(allocator, operand_243));
        } else (if ((operand_240 == @as((zx_abi).zx_type_11, .Enumeration))) block_242: {
            const operand_241 = @as(u64, ((value_2).names).len);

            break :block_242 (try function_1(allocator, operand_241));
        } else (value_2).second))));
    };

    const value_6: []const []const u8 = ((value_2).fields).names;
    const value_7: []const u32 = ((value_2).fields).types;

    return block_239: {
        const operand_141 = block_142: {
            break :block_142 value_3;
        };
        const operand_143 = block_238: {
            const operand_144 = @as([]const u8, (if (((buffers).lane_4 != null)) block_150: {
                const operand_146 = (block_145: {
                    break :block_145 value_1;
                }).kinds;
                const operand_149 = block_148: {
                    const operand_147 = (value_2).kind;

                    break :block_148 (try function_2(allocator, operand_147));
                };

                _ = (try ((std).math).add(usize, (operand_146).len, 1));

                if ((!(((buffers).lane_4.?).started).*)) {
                    (try ((((buffers).lane_4.?).buffer).*).appendSlice(allocator, operand_146));
                    (((buffers).lane_4.?).started).* = true;
                } else {
                    (((((buffers).lane_4.?).buffer).*).items).len = (operand_146).len;
                }

                (try ((((buffers).lane_4.?).buffer).*).append(allocator, operand_149));

                break :block_150 ((((buffers).lane_4.?).buffer).*).items;
            } else (block_157: {
                const operand_152 = (block_151: {
                    break :block_151 value_1;
                }).kinds;

                const operand_155 = block_154: {
                    const operand_153 = (value_2).kind;

                    break :block_154 (try function_2(allocator, operand_153));
                };

                const operand_156 = (try (allocator).alloc(u8, (try ((std).math).add(usize, (operand_152).len, 1))));

                @memcpy((operand_156)[0..(operand_152).len], operand_152);

                (operand_156)[(operand_152).len] = operand_155;

                break :block_157 @as((zx_abi).value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_156, {}, null, });
            }).@"0"));

            const operand_158 = @as([]const u32, (if (((buffers).lane_3 != null)) block_163: {
                const operand_160 = (block_159: {
                    break :block_159 value_1;
                }).first;

                const operand_162 = block_161: {
                    break :block_161 value_4;
                };

                _ = (try ((std).math).add(usize, (operand_160).len, 1));

                if ((!(((buffers).lane_3.?).started).*)) {
                    (try ((((buffers).lane_3.?).buffer).*).appendSlice(allocator, operand_160));
                    (((buffers).lane_3.?).started).* = true;
                } else {
                    (((((buffers).lane_3.?).buffer).*).items).len = (operand_160).len;
                }

                (try ((((buffers).lane_3.?).buffer).*).append(allocator, operand_162));

                break :block_163 ((((buffers).lane_3.?).buffer).*).items;
            } else (block_169: {
                const operand_165 = (block_164: {
                    break :block_164 value_1;
                }).first;
                const operand_167 = block_166: {
                    break :block_166 value_4;
                };

                const operand_168 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_165).len, 1))));

                @memcpy((operand_168)[0..(operand_165).len], operand_165);

                (operand_168)[(operand_165).len] = operand_167;

                break :block_169 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_168, {}, null, });
            }).@"0"));

            const operand_170 = @as([]const u32, (if (((buffers).lane_7 != null)) block_175: {
                const operand_172 = (block_171: {
                    break :block_171 value_1;
                }).second;
                const operand_174 = block_173: {
                    break :block_173 value_5;
                };

                _ = (try ((std).math).add(usize, (operand_172).len, 1));

                if ((!(((buffers).lane_7.?).started).*)) {
                    (try ((((buffers).lane_7.?).buffer).*).appendSlice(allocator, operand_172));
                    (((buffers).lane_7.?).started).* = true;
                } else {
                    (((((buffers).lane_7.?).buffer).*).items).len = (operand_172).len;
                }

                (try ((((buffers).lane_7.?).buffer).*).append(allocator, operand_174));

                break :block_175 ((((buffers).lane_7.?).buffer).*).items;
            } else (block_181: {
                const operand_177 = (block_176: {
                    break :block_176 value_1;
                }).second;

                const operand_179 = block_178: {
                    break :block_178 value_5;
                };

                const operand_180 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_177).len, 1))));

                @memcpy((operand_180)[0..(operand_177).len], operand_177);

                (operand_180)[(operand_177).len] = operand_179;

                break :block_181 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_180, {}, null, });
            }).@"0"));

            const operand_182 = @as([]const []const u8, (if (((buffers).lane_5 != null)) block_186: {
                const operand_184 = (block_183: {
                    break :block_183 value_1;
                }).labels;

                const operand_185 = (value_2).label;

                _ = (try ((std).math).add(usize, (operand_184).len, 1));

                if ((!(((buffers).lane_5.?).started).*)) {
                    (try ((((buffers).lane_5.?).buffer).*).appendSlice(allocator, operand_184));
                    (((buffers).lane_5.?).started).* = true;
                } else {
                    (((((buffers).lane_5.?).buffer).*).items).len = (operand_184).len;
                }

                (try ((((buffers).lane_5.?).buffer).*).append(allocator, operand_185));

                break :block_186 ((((buffers).lane_5.?).buffer).*).items;
            } else (block_191: {
                const operand_188 = (block_187: {
                    break :block_187 value_1;
                }).labels;

                const operand_189 = (value_2).label;
                const operand_190 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_188).len, 1))));

                @memcpy((operand_190)[0..(operand_188).len], operand_188);

                (operand_190)[(operand_188).len] = operand_189;

                break :block_191 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_190, {}, null, });
            }).@"0"));

            const operand_192 = @as([]const u32, (if (((buffers).lane_0 != null)) block_196: {
                const operand_194 = (block_193: {
                    break :block_193 value_1;
                }).children;

                const operand_195 = (value_2).children;

                _ = (try ((std).math).add(usize, (operand_194).len, (operand_195).len));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_194));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_194).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_195));

                break :block_196 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_201: {
                const operand_198 = (block_197: {
                    break :block_197 value_1;
                }).children;

                const operand_199 = (value_2).children;
                const operand_200 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_198).len, (operand_199).len))));

                @memcpy((operand_200)[0..(operand_198).len], operand_198);
                @memcpy((operand_200)[(operand_198).len..], operand_199);

                break :block_201 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_200, {}, null, });
            }).@"0"));

            const operand_202 = @as([]const []const u8, (if (((buffers).lane_1 != null)) block_207: {
                const operand_204 = (block_203: {
                    break :block_203 value_1;
                }).field_names;

                const operand_206 = block_205: {
                    break :block_205 value_6;
                };

                _ = (try ((std).math).add(usize, (operand_204).len, (operand_206).len));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_204));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_204).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_206));

                break :block_207 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_213: {
                const operand_209 = (block_208: {
                    break :block_208 value_1;
                }).field_names;
                const operand_211 = block_210: {
                    break :block_210 value_6;
                };

                const operand_212 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_209).len, (operand_211).len))));

                @memcpy((operand_212)[0..(operand_209).len], operand_209);
                @memcpy((operand_212)[(operand_209).len..], operand_211);

                break :block_213 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_212, {}, null, });
            }).@"0"));

            const operand_214 = @as([]const u32, (if (((buffers).lane_2 != null)) block_219: {
                const operand_216 = (block_215: {
                    break :block_215 value_1;
                }).field_types;

                const operand_218 = block_217: {
                    break :block_217 value_7;
                };

                _ = (try ((std).math).add(usize, (operand_216).len, (operand_218).len));

                if ((!(((buffers).lane_2.?).started).*)) {
                    (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_216));
                    (((buffers).lane_2.?).started).* = true;
                } else {
                    (((((buffers).lane_2.?).buffer).*).items).len = (operand_216).len;
                }

                (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_218));

                break :block_219 ((((buffers).lane_2.?).buffer).*).items;
            } else (block_225: {
                const operand_221 = (block_220: {
                    break :block_220 value_1;
                }).field_types;

                const operand_223 = block_222: {
                    break :block_222 value_7;
                };

                const operand_224 = (try (allocator).alloc(u32, (try ((std).math).add(usize, (operand_221).len, (operand_223).len))));

                @memcpy((operand_224)[0..(operand_221).len], operand_221);
                @memcpy((operand_224)[(operand_221).len..], operand_223);

                break :block_225 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_224, {}, null, });
            }).@"0"));

            const operand_226 = @as([]const []const u8, (if (((buffers).lane_6 != null)) block_230: {
                const operand_228 = (block_227: {
                    break :block_227 value_1;
                }).names;

                const operand_229 = (value_2).names;

                _ = (try ((std).math).add(usize, (operand_228).len, (operand_229).len));

                if ((!(((buffers).lane_6.?).started).*)) {
                    (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_228));
                    (((buffers).lane_6.?).started).* = true;
                } else {
                    (((((buffers).lane_6.?).buffer).*).items).len = (operand_228).len;
                }

                (try ((((buffers).lane_6.?).buffer).*).appendSlice(allocator, operand_229));

                break :block_230 ((((buffers).lane_6.?).buffer).*).items;
            } else (block_235: {
                const operand_232 = (block_231: {
                    break :block_231 value_1;
                }).names;

                const operand_233 = (value_2).names;
                const operand_234 = (try (allocator).alloc([]const u8, (try ((std).math).add(usize, (operand_232).len, (operand_233).len))));

                @memcpy((operand_234)[0..(operand_232).len], operand_232);
                @memcpy((operand_234)[(operand_232).len..], operand_233);

                break :block_235 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_234, {}, null, });
            }).@"0"));

            break :block_238 block_237: {
                const operand_236 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_236).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .kinds = operand_144, .first = operand_158, .second = operand_170, .labels = operand_182, .children = operand_192, .field_names = operand_202, .field_types = operand_214, .names = operand_226, });

                break :block_237 @as(*const (zx_abi).zx_type_15, operand_236);
            };
        };

        break :block_239 @as((zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .id = operand_141, .delta = operand_143, });
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

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_26) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_17 {
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

fn function_5_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_26_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
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

fn function_6(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_27) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_17 = block_74: {
        const operand_70 = block_69: {
            const operand_67 = (in).tables;
            const operand_68 = (in).id;

            break :block_69 (zx_abi).zx_type_26{ .tables = operand_67, .id = operand_68, };
        };

        const operand_71 = (&operand_70);
        const operand_72 = (try function_5_value(allocator, (zx_abi).value_zx_type_26_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_71).id, .tables = (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_71).tables).base, .delta = ((operand_71).tables).delta, .zx_origin = (operand_71).tables, }, .zx_origin = operand_71, }));

        break :block_74 (if (((operand_72).zx_origin != null)) ((operand_72).zx_origin.?).* else block_73: {
            break :block_73 (zx_abi).zx_type_17{ .delta = (operand_72).delta, .first = (operand_72).first, .kind = (operand_72).kind, .label = (operand_72).label, .second = (operand_72).second, };
        });
    };

    const value_2: (zx_abi).zx_type_19 = ((in).candidate).*;

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
        return block_66: {
            const operand_64 = ((&value_1)).label;
            const operand_65 = ((&value_2)).label;

            break :block_66 ((std).mem).eql(u8, operand_64, operand_65);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_11, .Enumeration)) and (!block_63: {
        const operand_61 = ((&value_1)).label;
        const operand_62 = ((&value_2)).label;

        break :block_63 ((std).mem).eql(u8, operand_61, operand_62);
    }))) {
        return false;
    }

    const value_3: (zx_abi).zx_type_15 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_4: u64 = (try function_0(allocator, ((&value_1)).first));
    const value_5: u64 = (try function_0(allocator, ((&value_1)).second));

    const value_6: u64 = block_60: {
        const operand_59 = ((&value_1)).kind;

        break :block_60 (if ((operand_59 == @as((zx_abi).zx_type_11, .Object))) @as(u64, ((((&value_2)).fields).names).len) else (if ((operand_59 == @as((zx_abi).zx_type_11, .Tuple))) @as(u64, (((&value_2)).children).len) else @as(u64, (((&value_2)).names).len)));
    };

    if ((value_5 != value_6)) {
        return false;
    }

    const value_12: (zx_abi).zx_type_28 = block_58: {
        const operand_9 = block_8: {
            const operand_2 = (&value_3);
            const operand_3 = (&value_2);
            const operand_4 = value_4;
            const operand_5 = value_5;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_28{ .table = operand_2, .candidate = operand_3, .first = operand_4, .count = operand_5, .index = operand_6, .equal = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = (zx_abi).value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (zx_abi).value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_9).candidate).children, .fields = (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_9).candidate).fields).names, .types = (((operand_9).candidate).fields).types, .zx_origin = ((operand_9).candidate).fields, }, .first = ((operand_9).candidate).first, .kind = ((operand_9).candidate).kind, .label = ((operand_9).candidate).label, .names = ((operand_9).candidate).names, .second = ((operand_9).candidate).second, .zx_origin = (operand_9).candidate, }, .count = (operand_9).count, .equal = (operand_9).equal, .first = (operand_9).first, .index = (operand_9).index, .table = (operand_9).table, .zx_origin = (&operand_9), };

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
                        const operand_41 = block_39: {
                            const operand_37 = (((state_1).candidate).fields).names;
                            const operand_38 = (state_1).index;

                            if ((operand_38 >= (operand_37).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_39 (operand_37)[@intCast(operand_38)];
                        };

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
                    } == block_49: {
                        const operand_47 = (((state_1).candidate).fields).types;
                        const operand_48 = (state_1).index;

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    })) else (if ((operand_15 == @as((zx_abi).zx_type_11, .Tuple))) (block_29: {
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
                const value_11: (zx_abi).value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = block_14: {
                    const operand_10 = state_1;
                    const operand_11 = ((state_1).index + @as(u64, 1));

                    const operand_12 = block_13: {
                        break :block_13 value_10;
                    };

                    break :block_14 @as((zx_abi).value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf, (zx_abi).value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (operand_10).candidate, .count = (operand_10).count, .equal = operand_12, .first = (operand_10).first, .index = operand_11, .table = (operand_10).table, });
                };

                break :block_51 value_11;
            };
        }

        break :block_58 block_57: {
            break :block_57 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_56: {
                break :block_56 (zx_abi).zx_type_28{ .candidate = (if ((((state_1).candidate).zx_origin != null)) ((state_1).candidate).zx_origin.? else block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_19));

                    (operand_54).* = (zx_abi).zx_type_19{ .children = ((state_1).candidate).children, .fields = (if (((((state_1).candidate).fields).zx_origin != null)) (((state_1).candidate).fields).zx_origin.? else block_53: {
                        const operand_52 = (try (allocator).create((zx_abi).zx_type_18));

                        (operand_52).* = (zx_abi).zx_type_18{ .names = (((state_1).candidate).fields).names, .types = (((state_1).candidate).fields).types, };

                        break :block_53 @as(*const (zx_abi).zx_type_18, operand_52);
                    }), .first = ((state_1).candidate).first, .kind = ((state_1).candidate).kind, .label = ((state_1).candidate).label, .names = ((state_1).candidate).names, .second = ((state_1).candidate).second, };

                    break :block_55 @as(*const (zx_abi).zx_type_19, operand_54);
                }), .count = (state_1).count, .equal = (state_1).equal, .first = (state_1).first, .index = (state_1).index, .table = (state_1).table, };
            });
        };
    };

    return ((&value_12)).equal;
}

fn function_7(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_20 {
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

    const value_8: *const (zx_abi).zx_type_29 = block_56: {
        const operand_16 = block_15: {
            const operand_7 = (in).tables;
            const operand_8 = (in).candidate;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);
            const operand_11 = false;
            const operand_12 = value_1;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_29));

                (operand_13).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .tables = operand_7, .candidate = operand_8, .count = operand_9, .index = operand_10, .found = operand_11, .id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_29, operand_13);
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
                const value_5: u32 = (try function_1(allocator, (state_6).index));

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
                    const operand_39 = (zx_abi).zx_type_27{ .candidate = (&operand_35), .id = (operand_33).id, .tables = (&operand_38), };
                    const operand_40 = (try function_6(allocator, (&operand_39)));

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
            const operand_54 = (try (allocator).create((zx_abi).zx_type_29));

            (operand_54).* = @as((zx_abi).zx_type_29, (zx_abi).zx_type_29{ .candidate = block_47: {
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

            break :block_55 @as(*const (zx_abi).zx_type_29, operand_54);
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

fn function_7_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_22_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    if (((((in).candidate).kind == @as((zx_abi).zx_type_11, .Enumeration)) or (((in).candidate).kind == @as((zx_abi).zx_type_11, .NativeReference)))) {
        return block_102: {
            const operand_100 = false;
            const operand_101 = @as(u32, 0);

            break :block_102 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_100, .id = operand_101, });
        };
    }

    const value_1: u32 = @as(u32, 0);
    const value_2: u64 = (@as(u64, ((((in).tables).base).kinds).len) + @as(u64, ((((in).tables).delta).kinds).len));

    const value_8: (zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_99: {
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

            break :block_74 @as((zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .tables = operand_66, .candidate = operand_67, .count = operand_68, .index = operand_70, .found = operand_71, .id = operand_72, });
        };

        var state_65: (zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = operand_75;
        var state_changed_76 = false;

        while (((!(state_65).found) and ((state_65).index < (state_65).count))) {
            state_65 = block_97: {
                const value_5: u32 = block_96: {
                    const operand_95 = (state_65).index;

                    break :block_96 (try function_1(allocator, operand_95));
                };
                const value_6: bool = block_94: {
                    const operand_89 = block_88: {
                        const operand_84 = (state_65).tables;

                        const operand_85 = block_86: {
                            break :block_86 value_5;
                        };

                        const operand_87 = (state_65).candidate;

                        break :block_88 @as((zx_abi).value_zx_type_27_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e, (zx_abi).value_zx_type_27_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e{ .tables = operand_84, .id = operand_85, .candidate = operand_87, });
                    };

                    var state_borrow_90: (zx_abi).zx_type_18 = undefined;

                    state_borrow_90 = (zx_abi).zx_type_18{ .names = (((operand_89).candidate).fields).names, .types = (((operand_89).candidate).fields).types, };

                    var state_borrow_91: (zx_abi).zx_type_19 = undefined;
                    state_borrow_91 = (zx_abi).zx_type_19{ .children = ((operand_89).candidate).children, .fields = ((((operand_89).candidate).fields).zx_origin orelse (&state_borrow_90)), .first = ((operand_89).candidate).first, .kind = ((operand_89).candidate).kind, .label = ((operand_89).candidate).label, .names = ((operand_89).candidate).names, .second = ((operand_89).candidate).second, };

                    var state_borrow_92: (zx_abi).zx_type_16 = undefined;
                    state_borrow_92 = (zx_abi).zx_type_16{ .base = ((operand_89).tables).base, .delta = ((operand_89).tables).delta, };

                    var state_borrow_93: (zx_abi).zx_type_27 = undefined;

                    state_borrow_93 = (zx_abi).zx_type_27{ .candidate = (((operand_89).candidate).zx_origin orelse (&state_borrow_91)), .id = (operand_89).id, .tables = (((operand_89).tables).zx_origin orelse (&state_borrow_92)), };

                    break :block_94 (try function_6(allocator, ((operand_89).zx_origin orelse (&state_borrow_93))));
                };
                const value_7: (zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = block_83: {
                    const operand_77 = state_65;
                    const operand_78 = ((state_65).index + @as(u64, 1));

                    const operand_79 = block_80: {
                        break :block_80 value_6;
                    };
                    const operand_81 = block_82: {
                        break :block_82 value_5;
                    };

                    break :block_83 @as((zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775, (zx_abi).value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775{ .candidate = (operand_77).candidate, .count = (operand_77).count, .found = operand_79, .id = operand_81, .index = operand_78, .tables = (operand_77).tables, });
                };

                break :block_97 value_7;
            };

            state_changed_76 = true;
        }

        break :block_99 (if (state_changed_76) state_65 else operand_75);
    };

    return block_64: {
        const operand_62 = (value_8).found;
        const operand_63 = (value_8).id;

        break :block_64 @as((zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .found = operand_62, .id = operand_63, });
    };
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_30) error{ IndexOutOfBounds, OutOfMemory, }!u32 {
    @setRuntimeSafety(true);

    const value_7: (zx_abi).zx_type_31 = block_24: {
        const operand_9 = block_8: {
            const operand_5 = (in).fields;
            const operand_6 = (in).name;
            const operand_7 = @as(u64, 0);

            break :block_8 (zx_abi).zx_type_31{ .fields = operand_5, .name = operand_6, .index = operand_7, };
        };

        var state_4: (zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268 = (zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268{ .fields = (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = ((operand_9).fields).names, .types = ((operand_9).fields).types, .zx_origin = (operand_9).fields, }, .index = (operand_9).index, .name = (operand_9).name, .zx_origin = (&operand_9), };

        while ((!block_15: {
            const operand_13 = block_12: {
                const operand_10 = ((state_4).fields).names;
                const operand_11 = (state_4).index;

                if ((operand_11 >= (operand_10).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_12 (operand_10)[@intCast(operand_11)];
            };

            const operand_14 = (state_4).name;

            break :block_15 ((std).mem).eql(u8, operand_13, operand_14);
        })) {
            state_4 = block_19: {
                const value_3: (zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268 = state_4;
                const value_4: u64 = (value_3).index;
                const value_5: u64 = @as(u64, 1);

                const value_6: (zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268, (zx_abi).value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268{ .fields = (value_3).fields, .index = (block_16: {
                        break :block_16 value_4;
                    } + block_17: {
                        break :block_17 value_5;
                    }), .name = (value_3).name, });
                };

                break :block_19 value_6;
            };
        }

        break :block_24 block_23: {
            break :block_23 (if (((state_4).zx_origin != null)) ((state_4).zx_origin.?).* else block_22: {
                break :block_22 (zx_abi).zx_type_31{ .fields = (if ((((state_4).fields).zx_origin != null)) ((state_4).fields).zx_origin.? else block_21: {
                    const operand_20 = (try (allocator).create((zx_abi).zx_type_18));

                    (operand_20).* = (zx_abi).zx_type_18{ .names = ((state_4).fields).names, .types = ((state_4).fields).types, };

                    break :block_21 @as(*const (zx_abi).zx_type_18, operand_20);
                }), .index = (state_4).index, .name = (state_4).name, };
            });
        };
    };

    return block_3: {
        const operand_1 = (((&value_7)).fields).types;
        const operand_2 = ((&value_7)).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

fn function_9(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    const value_1: []const []const u8 = (block_49: {
        const operand_47 = (in).names;
        const operand_48 = (try (allocator).alloc([]const u8, (operand_47).len));

        @memcpy(operand_48, operand_47);
        ((std).mem).sortUnstable([]const u8, operand_48, {}, zx_compare_10);

        break :block_49 @as((zx_abi).zx_type_25, .{ operand_48, {}, });
    }).@"0";

    const value_2: []const u32 = block_46: {
        break :block_46 (try (allocator).dupe(u32, (&[_]u32{})));
    };

    const value_14: *const (zx_abi).zx_type_32 = block_45: {
        const operand_14 = block_13: {
            const operand_7 = in;
            const operand_8 = value_1;
            const operand_9 = value_2;
            const operand_10 = @as(u64, 0);

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create((zx_abi).zx_type_32));

                (operand_11).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .fields = operand_7, .names = operand_8, .sorted = operand_9, .index = operand_10, });

                break :block_12 @as(*const (zx_abi).zx_type_32, operand_11);
            };
        };

        var state_capacity_16: (std).ArrayList(u32) = .empty;
        var state_capacity_started_17 = false;

        defer (state_capacity_16).deinit(allocator);

        const state_type_18 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_19 = struct {
            fields: state_type_18,
            index: u64,
            names: []const []const u8,
            sorted: []const u32,
        };

        const state_type_22 = struct { []const u32, void, };

        const state_type_26 = struct {
            fields: state_type_18,
            name: []const u8,
        };

        var state_6: state_type_19 = state_type_19{ .fields = state_type_18{ .names = ((operand_14).fields).names, .types = ((operand_14).fields).types, }, .index = (operand_14).index, .names = (operand_14).names, .sorted = (operand_14).sorted, };
        var state_changed_15 = false;

        while (((state_6).index < @as(u64, ((state_6).names).len))) {
            state_6 = block_38: {
                const value_5: u32 = block_37: {
                    const operand_33 = block_32: {
                        const operand_27 = (state_6).fields;

                        const operand_31 = block_30: {
                            const operand_28 = (state_6).names;
                            const operand_29 = (state_6).index;

                            if ((operand_29 >= (operand_28).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_30 (operand_28)[@intCast(operand_29)];
                        };

                        break :block_32 state_type_26{ .fields = operand_27, .name = operand_31, };
                    };

                    const operand_34 = (zx_abi).zx_type_18{ .names = ((operand_33).fields).names, .types = ((operand_33).fields).types, };
                    const operand_35 = (zx_abi).zx_type_30{ .fields = (&operand_34), .name = (operand_33).name, };
                    const operand_36 = (try function_8(allocator, (&operand_35)));

                    break :block_37 operand_36;
                };
                const value_6: state_type_19 = state_6;

                _ = (value_6).sorted;

                const value_8: []const u32 = (block_25: {
                    const operand_23 = (state_6).sorted;
                    const operand_24 = value_5;
                    _ = (try ((std).math).add(usize, (operand_23).len, 1));

                    if ((!state_capacity_started_17)) {
                        (try (state_capacity_16).appendSlice(allocator, operand_23));

                        state_capacity_started_17 = true;
                    } else {
                        ((state_capacity_16).items).len = (operand_23).len;
                    }

                    (try (state_capacity_16).append(allocator, operand_24));

                    break :block_25 @as(state_type_22, .{ (state_capacity_16).items, {}, });
                }).@"0";
                const value_9: state_type_19 = block_21: {
                    break :block_21 state_type_19{ .fields = (value_6).fields, .index = (value_6).index, .names = (value_6).names, .sorted = value_8, };
                };
                const value_10: state_type_19 = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: state_type_19 = block_20: {
                    break :block_20 state_type_19{ .fields = (value_10).fields, .index = (value_11 + value_12), .names = (value_10).names, .sorted = (value_10).sorted, };
                };

                break :block_38 value_13;
            };

            state_changed_15 = true;
        }

        var state_owned_39: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_39);

        if (state_capacity_started_17) {
            ((state_capacity_16).items).len = ((state_6).sorted).len;
            state_owned_39 = (try (state_capacity_16).toOwnedSlice(allocator));
        }

        if (state_capacity_started_17) {
            (state_6).sorted = state_owned_39;
        }

        break :block_45 (if (state_changed_15) block_44: {
            const operand_43 = (try (allocator).create((zx_abi).zx_type_32));

            (operand_43).* = @as((zx_abi).zx_type_32, (zx_abi).zx_type_32{ .fields = block_42: {
                const operand_41 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_41).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = ((state_6).fields).names, .types = ((state_6).fields).types, });

                break :block_42 @as(*const (zx_abi).zx_type_18, operand_41);
            }, .index = (state_6).index, .names = (state_6).names, .sorted = (state_6).sorted, });

            break :block_44 @as(*const (zx_abi).zx_type_32, operand_43);
        } else operand_14);
    };

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = (value_14).sorted;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_3).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .names = operand_1, .types = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_18, operand_3);
        };
    };
}

fn function_9_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: []const []const u8 = (block_92: {
        const operand_90 = (in).names;
        const operand_91 = (try (allocator).alloc([]const u8, (operand_90).len));

        @memcpy(operand_91, operand_90);

        ((std).mem).sortUnstable([]const u8, operand_91, {}, zx_compare_10);

        break :block_92 @as((zx_abi).value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_91, {}, null, });
    }).@"0";

    const value_2: []const u32 = block_89: {
        break :block_89 (try (allocator).dupe(u32, (&[_]u32{})));
    };

    const value_14: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = block_88: {
        const operand_62 = block_61: {
            const operand_55 = in;

            const operand_56 = block_57: {
                break :block_57 value_1;
            };
            const operand_58 = block_59: {
                break :block_59 value_2;
            };

            const operand_60 = @as(u64, 0);

            break :block_61 @as((zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a, (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a{ .fields = operand_55, .names = operand_56, .sorted = operand_58, .index = operand_60, });
        };

        var state_capacity_64: (std).ArrayList(u32) = .empty;
        var state_capacity_started_65 = false;

        defer (state_capacity_64).deinit(allocator);

        var state_54: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = operand_62;
        var state_changed_63 = false;

        while (((state_54).index < @as(u64, ((state_54).names).len))) {
            state_54 = block_85: {
                const value_5: u32 = block_84: {
                    const operand_81 = block_80: {
                        const operand_75 = (state_54).fields;
                        const operand_76 = block_79: {
                            const operand_77 = (state_54).names;
                            const operand_78 = (state_54).index;

                            if ((operand_78 >= (operand_77).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_79 (operand_77)[@intCast(operand_78)];
                        };

                        break :block_80 @as((zx_abi).value_zx_type_30_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac, (zx_abi).value_zx_type_30_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac{ .fields = operand_75, .name = operand_76, });
                    };

                    var state_borrow_82: (zx_abi).zx_type_18 = undefined;

                    state_borrow_82 = (zx_abi).zx_type_18{ .names = ((operand_81).fields).names, .types = ((operand_81).fields).types, };

                    var state_borrow_83: (zx_abi).zx_type_30 = undefined;
                    state_borrow_83 = (zx_abi).zx_type_30{ .fields = (((operand_81).fields).zx_origin orelse (&state_borrow_82)), .name = (operand_81).name, };

                    break :block_84 (try function_8(allocator, ((operand_81).zx_origin orelse (&state_borrow_83))));
                };

                const value_6: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = state_54;

                _ = (value_6).sorted;

                const value_8: []const u32 = (block_74: {
                    const operand_71 = (state_54).sorted;

                    const operand_73 = block_72: {
                        break :block_72 value_5;
                    };

                    _ = (try ((std).math).add(usize, (operand_71).len, 1));

                    if ((!state_capacity_started_65)) {
                        (try (state_capacity_64).appendSlice(allocator, operand_71));

                        state_capacity_started_65 = true;
                    } else {
                        ((state_capacity_64).items).len = (operand_71).len;
                    }

                    (try (state_capacity_64).append(allocator, operand_73));

                    break :block_74 @as((zx_abi).value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_64).items, {}, null, });
                }).@"0";

                const value_9: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a, (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a{ .fields = (value_6).fields, .index = (value_6).index, .names = (value_6).names, .sorted = block_69: {
                        break :block_69 value_8;
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = value_9;
                const value_11: u64 = (value_10).index;
                const value_12: u64 = @as(u64, 1);

                const value_13: (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = block_68: {
                    break :block_68 @as((zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a, (zx_abi).value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a{ .fields = (value_10).fields, .index = (block_66: {
                        break :block_66 value_11;
                    } + block_67: {
                        break :block_67 value_12;
                    }), .names = (value_10).names, .sorted = (value_10).sorted, });
                };

                break :block_85 value_13;
            };

            state_changed_63 = true;
        }

        var state_owned_86: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_86);

        if (state_capacity_started_65) {
            ((state_capacity_64).items).len = ((state_54).sorted).len;
            state_owned_86 = (try (state_capacity_64).toOwnedSlice(allocator));
        }

        if (state_capacity_started_65) {
            (state_54).sorted = state_owned_86;
        }

        if (state_capacity_started_65) {
            (state_54).zx_origin = null;
        }

        break :block_88 (if (state_changed_63) state_54 else operand_62);
    };

    return block_53: {
        const operand_50 = block_51: {
            break :block_51 value_1;
        };

        const operand_52 = (value_14).sorted;

        break :block_53 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = operand_50, .types = operand_52, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_22) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_21 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_18 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .Object))) (try function_9(allocator, ((in).candidate).fields)) else ((in).candidate).fields);

    const value_2: []const []const u8 = (if ((((in).candidate).kind == @as((zx_abi).zx_type_11, .ErrorSet))) (block_24: {
        const operand_22 = ((in).candidate).names;
        const operand_23 = (try (allocator).alloc([]const u8, (operand_22).len));

        @memcpy(operand_23, operand_22);

        ((std).mem).sortUnstable([]const u8, operand_23, {}, zx_compare_10);

        break :block_24 @as((zx_abi).zx_type_25, .{ operand_23, {}, });
    }).@"0" else ((in).candidate).names);

    const value_3: *const (zx_abi).zx_type_19 = block_21: {
        const operand_16 = (in).candidate;
        const operand_17 = value_1;
        const operand_18 = value_2;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_19).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .children = (operand_16).children, .fields = operand_17, .first = (operand_16).first, .kind = (operand_16).kind, .label = (operand_16).label, .names = operand_18, .second = (operand_16).second, });

            break :block_20 @as(*const (zx_abi).zx_type_19, operand_19);
        };
    };

    const value_4: *const (zx_abi).zx_type_20 = (try function_7(allocator, block_15: {
        const operand_11 = (in).tables;
        const operand_12 = value_3;

        break :block_15 block_14: {
            const operand_13 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_13).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .tables = operand_11, .candidate = operand_12, });

            break :block_14 @as(*const (zx_abi).zx_type_22, operand_13);
        };
    }));

    if ((value_4).found) {
        return block_10: {
            const operand_6 = ((in).tables).delta;
            const operand_7 = (value_4).id;

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_21));

                (operand_8).* = @as((zx_abi).zx_type_21, (zx_abi).zx_type_21{ .delta = operand_6, .id = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_21, operand_8);
            };
        };
    }

    return (try function_3(allocator, block_5: {
        const operand_1 = (in).tables;
        const operand_2 = value_3;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_22));

            (operand_3).* = @as((zx_abi).zx_type_22, (zx_abi).zx_type_22{ .tables = operand_1, .candidate = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_22, operand_3);
        };
    }));
}

fn zx_compare_10(context: void, left: []const u8, right: []const u8) bool {
    _ = context;

    return ((std).mem).lessThan(u8, left, right);
}
