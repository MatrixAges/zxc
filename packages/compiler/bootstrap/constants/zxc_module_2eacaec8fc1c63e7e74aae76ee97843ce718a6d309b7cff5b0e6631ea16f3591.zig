const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c = (((in).input).expressions).*;

    const value_2: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_94: {
        const operand_92 = (block_91: {
            break :block_91 (&value_1);
        }).payloads;

        const operand_93 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, ((in).frame).id));

        if ((operand_93 >= (operand_92).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_94 (operand_92)[@intCast(operand_93)];
    }));

    const value_3: ?u32 = block_90: {
        const operand_88 = (block_86: {
            break :block_86 (&value_1);
        }).match_subjects;

        const operand_89 = block_87: {
            break :block_87 value_2;
        };

        if ((operand_89 >= (operand_88).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_90 (operand_88)[@intCast(operand_89)];
    };

    const value_4: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (if ((block_81: {
        break :block_81 value_3;
    } != null)) block_85: {
        const operand_83 = ((in).cursor).values;

        const operand_84 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_82: {
            break :block_82 value_3;
        }.?));

        if ((operand_84 >= (operand_83).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_85 (operand_83)[@intCast(operand_84)];
    } else @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null));

    if (((block_73: {
        break :block_73 value_3;
    } != null) and (block_74: {
        break :block_74 value_4;
    } == null))) {
        return block_80: {
            const operand_75 = (in).frame;

            const operand_76 = @as(?u32, block_77: {
                break :block_77 value_3;
            }.?);

            const operand_78 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_79 = @as([]const u8, "");

            break :block_80 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_75, .child = operand_76, .value = operand_78, .message = operand_79, });
        };
    }

    const value_5: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_72: {
        const operand_70 = (block_68: {
            break :block_68 (&value_1);
        }).match_count;

        const operand_71 = block_69: {
            break :block_69 value_2;
        };

        if ((operand_71 >= (operand_70).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_72 (operand_70)[@intCast(operand_71)];
    }));

    const value_6: u64 = ((try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_67: {
        const operand_65 = (block_63: {
            break :block_63 (&value_1);
        }).match_first;

        const operand_66 = block_64: {
            break :block_64 value_2;
        };

        if ((operand_66 >= (operand_65).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_67 (operand_65)[@intCast(operand_66)];
    })) + ((in).frame).arm);

    if ((((in).frame).arm < block_24: {
        break :block_24 value_5;
    })) {
        const value_7: u32 = block_62: {
            const operand_60 = (block_58: {
                break :block_58 (&value_1);
            }).match_conditions;

            const operand_61 = block_59: {
                break :block_59 value_6;
            };

            if ((operand_61 >= (operand_60).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_62 (operand_60)[@intCast(operand_61)];
        };

        const value_8: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_57: {
            const operand_55 = ((in).cursor).values;

            const operand_56 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_54: {
                break :block_54 value_7;
            }));

            if ((operand_56 >= (operand_55).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_57 (operand_55)[@intCast(operand_56)];
        };

        if ((block_47: {
            break :block_47 value_8;
        } == null)) {
            return block_53: {
                const operand_48 = (in).frame;

                const operand_49 = @as(?u32, block_50: {
                    break :block_50 value_7;
                });

                const operand_51 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_52 = @as([]const u8, "");

                break :block_53 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_48, .child = operand_49, .value = operand_51, .message = operand_52, });
            };
        }

        const value_9: bool = (if ((block_36: {
            break :block_36 value_4;
        } != null)) block_45: {
            const operand_38 = block_37: {
                break :block_37 value_4;
            }.?;

            const operand_40 = block_39: {
                break :block_39 value_8;
            }.?;

            const operand_41 = @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal);

            const operand_43 = (block_42: {
                break :block_42 value_8;
            }.?).type_id;

            const operand_44 = (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2{ .left = operand_38, .right = operand_40, .operator = operand_41, .type_id = operand_43, };

            break :block_45 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).call(allocator, (&operand_44)));
        } else (block_46: {
            break :block_46 value_8;
        }.?).boolean);

        if ((!block_25: {
            break :block_25 value_9;
        })) {
            return block_35: {
                const operand_26 = block_31: {
                    const operand_27 = (in).frame;
                    const operand_28 = (((in).frame).arm + @as(u64, 1));

                    break :block_31 block_30: {
                        const operand_29 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                        (operand_29).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .arm = operand_28, .id = (operand_27).id, });

                        break :block_30 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_29);
                    };
                };

                const operand_32 = @as(?u32, null);
                const operand_33 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_34 = @as([]const u8, "");

                break :block_35 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_26, .child = operand_32, .value = operand_33, .message = operand_34, });
            };
        }
    }

    const value_10: u32 = (if ((((in).frame).arm < block_13: {
        break :block_13 value_5;
    })) block_18: {
        const operand_16 = (block_14: {
            break :block_14 (&value_1);
        }).match_results;

        const operand_17 = block_15: {
            break :block_15 value_6;
        };

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    } else block_23: {
        const operand_21 = (block_19: {
            break :block_19 (&value_1);
        }).match_fallbacks;

        const operand_22 = block_20: {
            break :block_20 value_2;
        };

        if ((operand_22 >= (operand_21).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_23 (operand_21)[@intCast(operand_22)];
    });

    const value_11: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_12: {
        const operand_10 = ((in).cursor).values;

        const operand_11 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_9: {
            break :block_9 value_10;
        }));

        if ((operand_11 >= (operand_10).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_12 (operand_10)[@intCast(operand_11)];
    };

    return block_8: {
        const operand_1 = (in).frame;

        const operand_2 = (if ((block_3: {
            break :block_3 value_11;
        } == null)) @as(?u32, block_4: {
            break :block_4 value_10;
        }) else @as(?u32, null));

        const operand_5 = block_6: {
            break :block_6 value_11;
        };

        const operand_7 = @as([]const u8, "");

        break :block_8 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_1, .child = operand_2, .value = operand_5, .message = operand_7, });
    };
}

