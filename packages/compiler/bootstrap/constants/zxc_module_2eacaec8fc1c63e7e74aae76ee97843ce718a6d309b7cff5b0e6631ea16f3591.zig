const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_19ebf3d3daa1235aa9ca0e94693f070406096da386675c891f585ac3f6cab6cf) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb = ((in).input).expressions;

    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_96: {
        const operand_94 = (block_93: {
            break :block_93 value_1;
        }).payloads;

        const operand_95 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

        if ((operand_95 >= (operand_94).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_96 (operand_94)[@intCast(operand_95)];
    }));

    const value_3: ?u32 = block_92: {
        const operand_90 = (block_88: {
            break :block_88 value_1;
        }).match_subjects;

        const operand_91 = block_89: {
            break :block_89 value_2;
        };

        if ((operand_91 >= (operand_90).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_92 (operand_90)[@intCast(operand_91)];
    };

    const value_4: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (if ((block_83: {
        break :block_83 value_3;
    } != null)) block_87: {
        const operand_85 = (((in).cursor).values).items;

        const operand_86 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_84: {
            break :block_84 value_3;
        }.?));

        if ((operand_86 >= (operand_85).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_87 (operand_85)[@intCast(operand_86)];
    } else @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null));

    if (((block_75: {
        break :block_75 value_3;
    } != null) and (block_76: {
        break :block_76 value_4;
    } == null))) {
        return block_82: {
            const operand_77 = (in).frame;

            const operand_78 = @as(?u32, block_79: {
                break :block_79 value_3;
            }.?);

            const operand_80 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_81 = @as([]const u8, "");

            break :block_82 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_77, .child = operand_78, .value = operand_80, .message = operand_81, });
        };
    }

    const value_5: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_74: {
        const operand_72 = (block_70: {
            break :block_70 value_1;
        }).match_count;

        const operand_73 = block_71: {
            break :block_71 value_2;
        };

        if ((operand_73 >= (operand_72).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_74 (operand_72)[@intCast(operand_73)];
    }));

    const value_6: u64 = ((try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_69: {
        const operand_67 = (block_65: {
            break :block_65 value_1;
        }).match_first;

        const operand_68 = block_66: {
            break :block_66 value_2;
        };

        if ((operand_68 >= (operand_67).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_69 (operand_67)[@intCast(operand_68)];
    })) + ((in).frame).arm);

    if ((((in).frame).arm < block_24: {
        break :block_24 value_5;
    })) {
        const value_7: u32 = block_64: {
            const operand_62 = (block_60: {
                break :block_60 value_1;
            }).match_conditions;

            const operand_63 = block_61: {
                break :block_61 value_6;
            };

            if ((operand_63 >= (operand_62).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_64 (operand_62)[@intCast(operand_63)];
        };

        const value_8: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_59: {
            const operand_57 = (((in).cursor).values).items;

            const operand_58 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_56: {
                break :block_56 value_7;
            }));

            if ((operand_58 >= (operand_57).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_59 (operand_57)[@intCast(operand_58)];
        };

        if ((block_49: {
            break :block_49 value_8;
        } == null)) {
            return block_55: {
                const operand_50 = (in).frame;

                const operand_51 = @as(?u32, block_52: {
                    break :block_52 value_7;
                });

                const operand_53 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_54 = @as([]const u8, "");

                break :block_55 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_50, .child = operand_51, .value = operand_53, .message = operand_54, });
            };
        }

        const value_9: bool = (if ((block_38: {
            break :block_38 value_4;
        } != null)) block_47: {
            const operand_40 = block_39: {
                break :block_39 value_4;
            }.?;

            const operand_42 = block_41: {
                break :block_41 value_8;
            }.?;

            const operand_43 = @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal);

            const operand_45 = (block_44: {
                break :block_44 value_8;
            }.?).type_id;

            const operand_46 = (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2{ .left = operand_40, .right = operand_42, .operator = operand_43, .type_id = operand_45, };

            break :block_47 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).call(allocator, (&operand_46)));
        } else (block_48: {
            break :block_48 value_8;
        }.?).boolean);

        if ((!block_25: {
            break :block_25 value_9;
        })) {
            return block_37: {
                const operand_26 = block_33: {
                    const operand_27 = (in).frame;
                    const operand_28 = (((in).frame).arm + @as(u64, 1));
                    const operand_29 = operand_28;
                    const operand_30 = (operand_27).id;

                    break :block_33 block_32: {
                        const operand_31 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                        (operand_31).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .arm = operand_29, .id = operand_30, });

                        break :block_32 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_31);
                    };
                };

                const operand_34 = @as(?u32, null);
                const operand_35 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_36 = @as([]const u8, "");

                break :block_37 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_26, .child = operand_34, .value = operand_35, .message = operand_36, });
            };
        }
    }

    const value_10: u32 = (if ((((in).frame).arm < block_13: {
        break :block_13 value_5;
    })) block_18: {
        const operand_16 = (block_14: {
            break :block_14 value_1;
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
            break :block_19 value_1;
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
        const operand_10 = (((in).cursor).values).items;

        const operand_11 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_9: {
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

        break :block_8 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_1, .child = operand_2, .value = operand_5, .message = operand_7, });
    };
}

