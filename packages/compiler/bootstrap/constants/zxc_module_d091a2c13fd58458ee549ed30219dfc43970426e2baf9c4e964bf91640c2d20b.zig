const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd = ((in).input).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

    const value_3: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_119: {
        const operand_117 = (block_115: {
            break :block_115 value_1;
        }).payloads;

        const operand_118 = block_116: {
            break :block_116 value_2;
        };

        if ((operand_118 >= (operand_117).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_119 (operand_117)[@intCast(operand_118)];
    }));

    const value_4: bool = (block_114: {
        const operand_112 = (block_110: {
            break :block_110 value_1;
        }).kinds;

        const operand_113 = block_111: {
            break :block_111 value_2;
        };

        if ((operand_113 >= (operand_112).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_114 (operand_112)[@intCast(operand_113)];
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary));

    const value_5: u32 = (if (block_99: {
        break :block_99 value_4;
    }) block_104: {
        const operand_102 = (block_100: {
            break :block_100 value_1;
        }).unary_operands;

        const operand_103 = block_101: {
            break :block_101 value_3;
        };

        if ((operand_103 >= (operand_102).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_104 (operand_102)[@intCast(operand_103)];
    } else block_109: {
        const operand_107 = (block_105: {
            break :block_105 value_1;
        }).binary_left;

        const operand_108 = block_106: {
            break :block_106 value_3;
        };

        if ((operand_108 >= (operand_107).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_109 (operand_107)[@intCast(operand_108)];
    });

    const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_98: {
        const operand_96 = (((in).cursor).values).items;

        const operand_97 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_95: {
            break :block_95 value_5;
        }));

        if ((operand_97 >= (operand_96).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_98 (operand_96)[@intCast(operand_97)];
    };

    if ((block_88: {
        break :block_88 value_6;
    } == null)) {
        return block_94: {
            const operand_89 = (in).frame;

            const operand_90 = @as(?u32, block_91: {
                break :block_91 value_5;
            });

            const operand_92 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_93 = @as([]const u8, "");

            break :block_94 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_89, .child = operand_90, .value = operand_92, .message = operand_93, });
        };
    }

    if (block_72: {
        break :block_72 value_4;
    }) {
        const value_7: (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 = block_87: {
            break :block_87 (try (@import("zxc_module_0cf29a00048cd105c3cc3d15c53aed1645b8de7aa73ffb493cfed2efd6453ee5.zig")).callValue(allocator, block_86: {
                const operand_78 = block_79: {
                    break :block_79 value_6;
                }.?;

                const operand_80 = block_85: {
                    const operand_83 = (block_81: {
                        break :block_81 value_1;
                    }).unary_operators;
                    const operand_84 = block_82: {
                        break :block_82 value_3;
                    };

                    if ((operand_84 >= (operand_83).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_85 (operand_83)[@intCast(operand_84)];
                };

                break :block_86 @as((zx_abi).value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c, (zx_abi).value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c{ .value = operand_78, .operator = operand_80, });
            }));
        };

        return block_77: {
            const operand_73 = (in).frame;
            const operand_74 = @as(?u32, null);
            const operand_75 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_7).value);
            const operand_76 = (value_7).message;

            break :block_77 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_73, .child = operand_74, .value = operand_75, .message = operand_76, });
        };
    }

    const value_8: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = block_71: {
        const operand_69 = (block_67: {
            break :block_67 value_1;
        }).binary_operators;

        const operand_70 = block_68: {
            break :block_68 value_3;
        };

        if ((operand_70 >= (operand_69).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_71 (operand_69)[@intCast(operand_70)];
    };

    const value_9: bool = (block_66: {
        break :block_66 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd));

    const value_10: bool = ((block_64: {
        break :block_64 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalOr)) and (block_65: {
        break :block_65 value_6;
    }.?).boolean);

    const value_11: bool = (((!(!block_61: {
        break :block_61 value_9;
    })) and (!(block_62: {
        break :block_62 value_6;
    }.?).boolean)) or block_63: {
        break :block_63 value_10;
    });

    if (block_36: {
        break :block_36 value_11;
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

            break :block_60 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_37, .child = operand_38, .value = operand_39, .message = operand_59, });
        };
    }

    const value_12: u32 = block_35: {
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

    const value_13: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_30: {
        const operand_28 = (((in).cursor).values).items;

        const operand_29 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_27: {
            break :block_27 value_12;
        }));

        if ((operand_29 >= (operand_28).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_30 (operand_28)[@intCast(operand_29)];
    };

    if ((block_20: {
        break :block_20 value_13;
    } == null)) {
        return block_26: {
            const operand_21 = (in).frame;

            const operand_22 = @as(?u32, block_23: {
                break :block_23 value_12;
            });

            const operand_24 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_25 = @as([]const u8, "");

            break :block_26 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_21, .child = operand_22, .value = operand_24, .message = operand_25, });
        };
    }

    const value_14: (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 = block_19: {
        break :block_19 (try (@import("zxc_module_5ee4fab546fbe563089eb5d109b7f9697b3679024ed71b5132fd433fc1525f65.zig")).callValue(allocator, block_18: {
            const operand_6 = block_7: {
                break :block_7 value_6;
            }.?;

            const operand_8 = block_9: {
                break :block_9 value_13;
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

            break :block_18 @as((zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549, (zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549{ .left = operand_6, .right = operand_8, .operator = operand_10, .type_id = operand_12, });
        }));
    };

    return block_5: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);
        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_14).value);
        const operand_4 = (value_14).message;

        break :block_5 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_4, });
    };
}
