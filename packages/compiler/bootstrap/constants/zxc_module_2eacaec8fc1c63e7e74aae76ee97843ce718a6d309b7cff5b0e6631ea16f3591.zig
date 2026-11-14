const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd = ((in).input).expressions;

    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_98: {
        const operand_96 = (block_95: {
            break :block_95 value_1;
        }).payloads;

        const operand_97 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

        if ((operand_97 >= (operand_96).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_98 (operand_96)[@intCast(operand_97)];
    }));

    const value_3: ?u32 = block_94: {
        const operand_92 = (block_90: {
            break :block_90 value_1;
        }).match_subjects;

        const operand_93 = block_91: {
            break :block_91 value_2;
        };

        if ((operand_93 >= (operand_92).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_94 (operand_92)[@intCast(operand_93)];
    };

    const value_4: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (if ((block_85: {
        break :block_85 value_3;
    } != null)) block_89: {
        const operand_87 = (((in).cursor).values).items;

        const operand_88 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_86: {
            break :block_86 value_3;
        }.?));

        if ((operand_88 >= (operand_87).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_89 (operand_87)[@intCast(operand_88)];
    } else @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null));

    if (((block_77: {
        break :block_77 value_3;
    } != null) and (block_78: {
        break :block_78 value_4;
    } == null))) {
        return block_84: {
            const operand_79 = (in).frame;

            const operand_80 = @as(?u32, block_81: {
                break :block_81 value_3;
            }.?);

            const operand_82 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_83 = @as([]const u8, "");

            break :block_84 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_79, .child = operand_80, .value = operand_82, .message = operand_83, });
        };
    }

    const value_5: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_76: {
        const operand_74 = (block_72: {
            break :block_72 value_1;
        }).match_count;

        const operand_75 = block_73: {
            break :block_73 value_2;
        };

        if ((operand_75 >= (operand_74).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_76 (operand_74)[@intCast(operand_75)];
    }));

    const value_6: u64 = ((try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_71: {
        const operand_69 = (block_67: {
            break :block_67 value_1;
        }).match_first;

        const operand_70 = block_68: {
            break :block_68 value_2;
        };

        if ((operand_70 >= (operand_69).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_71 (operand_69)[@intCast(operand_70)];
    })) + ((in).frame).arm);

    if ((((in).frame).arm < block_24: {
        break :block_24 value_5;
    })) {
        const value_7: u32 = block_66: {
            const operand_64 = (block_62: {
                break :block_62 value_1;
            }).match_conditions;
            const operand_65 = block_63: {
                break :block_63 value_6;
            };

            if ((operand_65 >= (operand_64).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_66 (operand_64)[@intCast(operand_65)];
        };

        const value_8: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_61: {
            const operand_59 = (((in).cursor).values).items;

            const operand_60 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_58: {
                break :block_58 value_7;
            }));

            if ((operand_60 >= (operand_59).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_61 (operand_59)[@intCast(operand_60)];
        };

        if ((block_51: {
            break :block_51 value_8;
        } == null)) {
            return block_57: {
                const operand_52 = (in).frame;

                const operand_53 = @as(?u32, block_54: {
                    break :block_54 value_7;
                });

                const operand_55 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_56 = @as([]const u8, "");

                break :block_57 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_52, .child = operand_53, .value = operand_55, .message = operand_56, });
            };
        }

        const value_9: bool = (if ((block_40: {
            break :block_40 value_4;
        } != null)) block_49: {
            break :block_49 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).callValue(allocator, block_48: {
                const operand_41 = block_42: {
                    break :block_42 value_4;
                }.?;

                const operand_43 = block_44: {
                    break :block_44 value_8;
                }.?;

                const operand_45 = @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal);

                const operand_46 = (block_47: {
                    break :block_47 value_8;
                }.?).type_id;

                break :block_48 @as((zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549, (zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549{ .left = operand_41, .right = operand_43, .operator = operand_45, .type_id = operand_46, });
            }));
        } else (block_50: {
            break :block_50 value_8;
        }.?).boolean);

        if ((!block_25: {
            break :block_25 value_9;
        })) {
            return block_39: {
                const operand_26 = block_35: {
                    const operand_27 = (in).frame;
                    const operand_28 = (((in).frame).arm + @as(u64, 1));
                    const operand_30 = operand_28;

                    break :block_35 block_34: {
                        const operand_33 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                        (operand_33).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, block_32: {
                            var updated_29: (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = (operand_27).*;
                            const operand_31 = operand_30;
                            (updated_29).arm = operand_31;

                            break :block_32 updated_29;
                        });

                        break :block_34 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_33);
                    };
                };

                const operand_36 = @as(?u32, null);
                const operand_37 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
                const operand_38 = @as([]const u8, "");

                break :block_39 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_26, .child = operand_36, .value = operand_37, .message = operand_38, });
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

        break :block_8 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_1, .child = operand_2, .value = operand_5, .message = operand_7, });
    };
}
