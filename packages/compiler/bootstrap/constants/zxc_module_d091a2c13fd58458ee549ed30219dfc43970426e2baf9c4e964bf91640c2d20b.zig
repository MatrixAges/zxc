const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_d5a2abbc372f76159966b3930c9c4c5a4acd842be2767b076d686112aa34e82e) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78 = ((in).input).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

    const value_3: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_117: {
        const operand_115 = (block_113: {
            break :block_113 value_1;
        }).payloads;

        const operand_116 = block_114: {
            break :block_114 value_2;
        };

        if ((operand_116 >= (operand_115).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_117 (operand_115)[@intCast(operand_116)];
    }));

    const value_4: bool = (block_112: {
        const operand_110 = (block_108: {
            break :block_108 value_1;
        }).kinds;

        const operand_111 = block_109: {
            break :block_109 value_2;
        };

        if ((operand_111 >= (operand_110).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_112 (operand_110)[@intCast(operand_111)];
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary));

    const value_5: u32 = (if (block_97: {
        break :block_97 value_4;
    }) block_102: {
        const operand_100 = (block_98: {
            break :block_98 value_1;
        }).unary_operands;

        const operand_101 = block_99: {
            break :block_99 value_3;
        };

        if ((operand_101 >= (operand_100).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_102 (operand_100)[@intCast(operand_101)];
    } else block_107: {
        const operand_105 = (block_103: {
            break :block_103 value_1;
        }).binary_left;

        const operand_106 = block_104: {
            break :block_104 value_3;
        };

        if ((operand_106 >= (operand_105).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_107 (operand_105)[@intCast(operand_106)];
    });

    const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_96: {
        const operand_94 = (((in).cursor).values).items;

        const operand_95 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_93: {
            break :block_93 value_5;
        }));

        if ((operand_95 >= (operand_94).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_96 (operand_94)[@intCast(operand_95)];
    };

    if ((block_86: {
        break :block_86 value_6;
    } == null)) {
        return block_92: {
            const operand_87 = (in).frame;

            const operand_88 = @as(?u32, block_89: {
                break :block_89 value_5;
            });

            const operand_90 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_91 = @as([]const u8, "");

            break :block_92 @as((zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969, (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969{ .frame = operand_87, .child = operand_88, .value = operand_90, .message = operand_91, });
        };
    }

    if (block_70: {
        break :block_70 value_4;
    }) {
        const value_7: (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 = block_85: {
            break :block_85 (try (@import("zxc_module_0cf29a00048cd105c3cc3d15c53aed1645b8de7aa73ffb493cfed2efd6453ee5.zig")).callValue(allocator, block_84: {
                const operand_76 = block_77: {
                    break :block_77 value_6;
                }.?;

                const operand_78 = block_83: {
                    const operand_81 = (block_79: {
                        break :block_79 value_1;
                    }).unary_operators;
                    const operand_82 = block_80: {
                        break :block_80 value_3;
                    };

                    if ((operand_82 >= (operand_81).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_83 (operand_81)[@intCast(operand_82)];
                };

                break :block_84 @as((zx_abi).value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035, (zx_abi).value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035{ .value = operand_76, .operator = operand_78, });
            }));
        };

        return block_75: {
            const operand_71 = (in).frame;
            const operand_72 = @as(?u32, null);
            const operand_73 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_7).value);
            const operand_74 = (value_7).message;

            break :block_75 @as((zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969, (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969{ .frame = operand_71, .child = operand_72, .value = operand_73, .message = operand_74, });
        };
    }

    const value_8: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = block_69: {
        const operand_67 = (block_65: {
            break :block_65 value_1;
        }).binary_operators;

        const operand_68 = block_66: {
            break :block_66 value_3;
        };

        if ((operand_68 >= (operand_67).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_69 (operand_67)[@intCast(operand_68)];
    };

    const value_9: bool = (((!(!(block_61: {
        break :block_61 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd)))) and (!(block_62: {
        break :block_62 value_6;
    }.?).boolean)) or ((block_63: {
        break :block_63 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalOr)) and (block_64: {
        break :block_64 value_6;
    }.?).boolean));

    if (block_36: {
        break :block_36 value_9;
    }) {
        return block_60: {
            const operand_37 = (in).frame;
            const operand_38 = @as(?u32, null);

            const operand_39 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_58: {
                const operand_40 = block_41: {
                    break :block_41 value_6;
                }.?;

                const operand_42 = block_47: {
                    const operand_45 = (block_43: {
                        break :block_43 value_1;
                    }).types;
                    const operand_46 = block_44: {
                        break :block_44 value_2;
                    };

                    if ((operand_46 >= (operand_45).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_47 (operand_45)[@intCast(operand_46)];
                };

                const operand_48 = (operand_40).boolean;
                const operand_49 = (operand_40).enumeration;
                const operand_50 = (operand_40).floating;
                const operand_51 = (operand_40).integer;
                const operand_52 = (operand_40).kind;
                const operand_53 = (operand_40).negative;
                const operand_54 = (operand_40).text;
                const operand_55 = operand_42;

                break :block_58 block_57: {
                    const operand_56 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_56).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_48, .enumeration = operand_49, .floating = operand_50, .integer = operand_51, .kind = operand_52, .negative = operand_53, .text = operand_54, .type_id = operand_55, });

                    break :block_57 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_56);
                };
            });

            const operand_59 = @as([]const u8, "");

            break :block_60 @as((zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969, (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969{ .frame = operand_37, .child = operand_38, .value = operand_39, .message = operand_59, });
        };
    }

    const value_10: u32 = block_35: {
        const operand_33 = (block_31: {
            break :block_31 value_1;
        }).binary_right;

        const operand_34 = block_32: {
            break :block_32 value_3;
        };

        if ((operand_34 >= (operand_33).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_35 (operand_33)[@intCast(operand_34)];
    };

    const value_11: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_30: {
        const operand_28 = (((in).cursor).values).items;

        const operand_29 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_27: {
            break :block_27 value_10;
        }));

        if ((operand_29 >= (operand_28).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_30 (operand_28)[@intCast(operand_29)];
    };

    if ((block_20: {
        break :block_20 value_11;
    } == null)) {
        return block_26: {
            const operand_21 = (in).frame;

            const operand_22 = @as(?u32, block_23: {
                break :block_23 value_10;
            });

            const operand_24 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_25 = @as([]const u8, "");

            break :block_26 @as((zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969, (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969{ .frame = operand_21, .child = operand_22, .value = operand_24, .message = operand_25, });
        };
    }

    const value_12: (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 = block_19: {
        break :block_19 (try (@import("zxc_module_5ee4fab546fbe563089eb5d109b7f9697b3679024ed71b5132fd433fc1525f65.zig")).callValue(allocator, block_18: {
            const operand_6 = block_7: {
                break :block_7 value_6;
            }.?;

            const operand_8 = block_9: {
                break :block_9 value_11;
            }.?;

            const operand_10 = block_11: {
                break :block_11 value_8;
            };

            const operand_12 = block_17: {
                const operand_15 = (block_13: {
                    break :block_13 value_1;
                }).types;

                const operand_16 = block_14: {
                    break :block_14 value_2;
                };

                if ((operand_16 >= (operand_15).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_17 (operand_15)[@intCast(operand_16)];
            };

            break :block_18 @as((zx_abi).value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24, (zx_abi).value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24{ .left = operand_6, .right = operand_8, .operator = operand_10, .type_id = operand_12, });
        }));
    };

    return block_5: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);
        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_12).value);
        const operand_4 = (value_12).message;

        break :block_5 @as((zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969, (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_4, });
    };
}

