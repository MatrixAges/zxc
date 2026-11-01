const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c = (((in).input).expressions).*;
    const value_2: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, ((in).frame).id));

    const value_3: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_109: {
        const operand_107 = (block_105: {
            break :block_105 (&value_1);
        }).payloads;

        const operand_108 = block_106: {
            break :block_106 value_2;
        };

        if ((operand_108 >= (operand_107).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_109 (operand_107)[@intCast(operand_108)];
    }));

    const value_4: bool = (block_104: {
        const operand_102 = (block_100: {
            break :block_100 (&value_1);
        }).kinds;

        const operand_103 = block_101: {
            break :block_101 value_2;
        };

        if ((operand_103 >= (operand_102).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_104 (operand_102)[@intCast(operand_103)];
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary));

    const value_5: u32 = (if (block_89: {
        break :block_89 value_4;
    }) block_94: {
        const operand_92 = (block_90: {
            break :block_90 (&value_1);
        }).unary_operands;

        const operand_93 = block_91: {
            break :block_91 value_3;
        };

        if ((operand_93 >= (operand_92).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_94 (operand_92)[@intCast(operand_93)];
    } else block_99: {
        const operand_97 = (block_95: {
            break :block_95 (&value_1);
        }).binary_left;

        const operand_98 = block_96: {
            break :block_96 value_3;
        };

        if ((operand_98 >= (operand_97).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_99 (operand_97)[@intCast(operand_98)];
    });

    const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_88: {
        const operand_86 = ((in).cursor).values;

        const operand_87 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_85: {
            break :block_85 value_5;
        }));

        if ((operand_87 >= (operand_86).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_88 (operand_86)[@intCast(operand_87)];
    };

    if ((block_78: {
        break :block_78 value_6;
    } == null)) {
        return block_84: {
            const operand_79 = (in).frame;

            const operand_80 = @as(?u32, block_81: {
                break :block_81 value_5;
            });

            const operand_82 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_83 = @as([]const u8, "");

            break :block_84 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_79, .child = operand_80, .value = operand_82, .message = operand_83, });
        };
    }

    if (block_62: {
        break :block_62 value_4;
    }) {
        const value_7: (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730 = block_77: {
            break :block_77 (try (@import("zxc_module_0cf29a00048cd105c3cc3d15c53aed1645b8de7aa73ffb493cfed2efd6453ee5.zig")).callValue(allocator, block_76: {
                const operand_68 = block_69: {
                    break :block_69 value_6;
                }.?;

                const operand_70 = block_75: {
                    const operand_73 = (block_71: {
                        break :block_71 (&value_1);
                    }).unary_operators;

                    const operand_74 = block_72: {
                        break :block_72 value_3;
                    };

                    if ((operand_74 >= (operand_73).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_75 (operand_73)[@intCast(operand_74)];
                };

                break :block_76 @as((zx_abi).value_de7e557a1f4d614dfa1118c605778c70db10cfe21b8d0483d1af3768155ad272, (zx_abi).value_de7e557a1f4d614dfa1118c605778c70db10cfe21b8d0483d1af3768155ad272{ .value = operand_68, .operator = operand_70, });
            }));
        };

        return block_67: {
            const operand_63 = (in).frame;
            const operand_64 = @as(?u32, null);
            const operand_65 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_7).value);
            const operand_66 = (value_7).message;

            break :block_67 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_63, .child = operand_64, .value = operand_65, .message = operand_66, });
        };
    }

    const value_8: (zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = block_61: {
        const operand_59 = (block_57: {
            break :block_57 (&value_1);
        }).binary_operators;

        const operand_60 = block_58: {
            break :block_58 value_3;
        };

        if ((operand_60 >= (operand_59).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_61 (operand_59)[@intCast(operand_60)];
    };

    const value_9: bool = (((block_53: {
        break :block_53 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd)) and (!(block_54: {
        break :block_54 value_6;
    }.?).boolean)) or ((block_55: {
        break :block_55 value_8;
    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalOr)) and (block_56: {
        break :block_56 value_6;
    }.?).boolean));

    if (block_36: {
        break :block_36 value_9;
    }) {
        return block_52: {
            const operand_37 = (in).frame;
            const operand_38 = @as(?u32, null);

            const operand_39 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_50: {
                const operand_40 = block_41: {
                    break :block_41 value_6;
                }.?;

                const operand_42 = block_47: {
                    const operand_45 = (block_43: {
                        break :block_43 (&value_1);
                    }).types;
                    const operand_46 = block_44: {
                        break :block_44 value_2;
                    };

                    if ((operand_46 >= (operand_45).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_47 (operand_45)[@intCast(operand_46)];
                };

                break :block_50 block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_48).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = (operand_40).boolean, .enumeration = (operand_40).enumeration, .floating = (operand_40).floating, .integer = (operand_40).integer, .kind = (operand_40).kind, .negative = (operand_40).negative, .text = (operand_40).text, .type_id = operand_42, });

                    break :block_49 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_48);
                };
            });

            const operand_51 = @as([]const u8, "");

            break :block_52 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_37, .child = operand_38, .value = operand_39, .message = operand_51, });
        };
    }

    const value_10: u32 = block_35: {
        const operand_33 = (block_31: {
            break :block_31 (&value_1);
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
        const operand_28 = ((in).cursor).values;

        const operand_29 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_27: {
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

            break :block_26 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_21, .child = operand_22, .value = operand_24, .message = operand_25, });
        };
    }

    const value_12: (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730 = block_19: {
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
                    break :block_13 (&value_1);
                }).types;

                const operand_16 = block_14: {
                    break :block_14 value_2;
                };

                if ((operand_16 >= (operand_15).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_17 (operand_15)[@intCast(operand_16)];
            };

            break :block_18 @as((zx_abi).value_aa0d26cc0e88cd5936e5f12c41131a9936fbc2135966c84abd7ef1777ab7654c, (zx_abi).value_aa0d26cc0e88cd5936e5f12c41131a9936fbc2135966c84abd7ef1777ab7654c{ .left = operand_6, .right = operand_8, .operator = operand_10, .type_id = operand_12, });
        }));
    };

    return block_5: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);
        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_12).value);
        const operand_4 = (value_12).message;

        break :block_5 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_4, });
    };
}

