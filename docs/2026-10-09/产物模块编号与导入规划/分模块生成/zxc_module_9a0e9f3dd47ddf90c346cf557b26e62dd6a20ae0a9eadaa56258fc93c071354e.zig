const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_52: {
        const operand_49 = (in).kinds;
        const operand_50 = (try (allocator).alloc(u64, (operand_49).len));

        for (operand_49, 0..) |_, index_51| {
            (operand_50)[index_51] = @as(u64, 0);
        }

        break :block_52 operand_50;
    };

    const value_4: []const u32 = block_48: {
        const operand_45 = (in).kinds;
        const operand_46 = (try (allocator).alloc(u32, (operand_45).len));

        for (operand_45, 0..) |_, index_47| {
            (operand_46)[index_47] = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, @as(u64, 0)));
        }

        break :block_48 operand_46;
    };

    const value_6: []const u64 = block_44: {
        const operand_41 = (in).kinds;
        const operand_42 = (try (allocator).alloc(u64, (operand_41).len));

        for (operand_41, 0..) |_, index_43| {
            (operand_42)[index_43] = @as(u64, 0);
        }

        break :block_44 operand_42;
    };

    const value_20: *const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_40: {
        const operand_17 = block_16: {
            const operand_10 = value_2;
            const operand_11 = value_4;
            const operand_12 = @as(u64, 0);
            const operand_13 = (in).scalar_count;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c));

                (operand_14).* = @as((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .mapping = operand_10, .order = operand_11, .index = operand_12, .scalar_count = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, operand_14);
            };
        };

        var state_items_19: []u64 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_9: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = (operand_17).*;
        var state_changed_18 = false;

        while ((((&state_9)).index < ((&state_9)).scalar_count)) {
            state_9 = block_36: {
                const value_9: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = ((&state_9)).*;
                const value_10: []const u64 = ((&value_9)).mapping;
                const value_11: u64 = ((&state_9)).index;

                const value_12: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_35: {
                    break :block_35 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = ((&value_9)).index, .mapping = block_34: {
                        const operand_30 = value_10;
                        const operand_31 = value_11;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_32 = (((&state_9)).index + @as(u64, 1));

                        break :block_34 block_33: {
                            if ((!state_items_started_20)) {
                                state_items_19 = @constCast(operand_30);
                                state_items_started_20 = true;
                            }

                            (state_items_19)[@intCast(operand_31)] = operand_32;

                            break :block_33 state_items_19;
                        };
                    }, .order = ((&value_9)).order, .scalar_count = ((&value_9)).scalar_count, };
                };

                const value_13: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = ((&value_12)).*;
                const value_14: []const u32 = ((&value_13)).order;
                const value_15: u64 = ((&value_12)).index;

                const value_16: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_29: {
                    break :block_29 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = ((&value_13)).index, .mapping = ((&value_13)).mapping, .order = block_28: {
                        const operand_24 = value_14;
                        const operand_25 = value_15;

                        if ((operand_25 >= (operand_24).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_26 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, ((&value_12)).index));

                        break :block_28 block_27: {
                            if ((!state_items_started_22)) {
                                state_items_21 = @constCast(operand_24);
                                state_items_started_22 = true;
                            }

                            (state_items_21)[@intCast(operand_25)] = operand_26;

                            break :block_27 state_items_21;
                        };
                    }, .scalar_count = ((&value_13)).scalar_count, };
                };

                const value_17: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = ((&value_16)).*;
                const value_18: u64 = ((&value_17)).index;

                const value_19: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_23: {
                    break :block_23 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (value_18 + @as(u64, 1)), .mapping = ((&value_17)).mapping, .order = ((&value_17)).order, .scalar_count = ((&value_17)).scalar_count, };
                };

                break :block_36 ((&value_19)).*;
            };

            state_changed_18 = true;
        }

        break :block_40 (if (state_changed_18) block_39: {
            const operand_38 = (try (allocator).create((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c));

            (operand_38).* = @as((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, state_9);

            break :block_39 @as(*const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, operand_38);
        } else operand_17);
    };

    return block_8: {
        const operand_1 = (value_20).mapping;
        const operand_2 = (value_20).order;
        const operand_3 = value_6;
        const operand_4 = (in).scalar_count;
        const operand_5 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_6).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_1, .order = operand_2, .origins = operand_3, .count = operand_4, .status = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_6);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_105: {
        const operand_102 = (in).kinds;
        const operand_103 = (try (allocator).alloc(u64, (operand_102).len));

        for (operand_102, 0..) |_, index_104| {
            (operand_103)[index_104] = @as(u64, 0);
        }

        break :block_105 operand_103;
    };

    const value_4: []const u32 = block_101: {
        const operand_98 = (in).kinds;
        const operand_99 = (try (allocator).alloc(u32, (operand_98).len));

        for (operand_98, 0..) |_, index_100| {
            (operand_99)[index_100] = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, @as(u64, 0)));
        }

        break :block_101 operand_99;
    };

    const value_6: []const u64 = block_97: {
        const operand_94 = (in).kinds;
        const operand_95 = (try (allocator).alloc(u64, (operand_94).len));

        for (operand_94, 0..) |_, index_96| {
            (operand_95)[index_96] = @as(u64, 0);
        }

        break :block_97 operand_95;
    };

    const value_20: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_93: {
        const operand_65 = block_64: {
            const operand_60 = value_2;
            const operand_61 = value_4;
            const operand_62 = @as(u64, 0);
            const operand_63 = (in).scalar_count;

            break :block_64 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .mapping = operand_60, .order = operand_61, .index = operand_62, .scalar_count = operand_63, };
        };

        var state_items_66: []u64 = undefined;
        var state_items_started_67 = false;
        var state_items_68: []u32 = undefined;
        var state_items_started_69 = false;
        var state_59: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_65).index, .mapping = (operand_65).mapping, .order = (operand_65).order, .scalar_count = (operand_65).scalar_count, .zx_origin = (&operand_65), };

        while (((state_59).index < (state_59).scalar_count)) {
            state_59 = block_90: {
                const value_9: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_59;
                const value_10: []const u64 = (value_9).mapping;
                const value_11: u64 = (state_59).index;

                const value_12: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_89: {
                    break :block_89 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_9).index, .mapping = block_88: {
                        const operand_83 = block_82: {
                            break :block_82 value_10;
                        };
                        const operand_85 = block_84: {
                            break :block_84 value_11;
                        };

                        if ((operand_85 >= (operand_83).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_86 = ((state_59).index + @as(u64, 1));

                        break :block_88 block_87: {
                            if ((!state_items_started_67)) {
                                state_items_66 = @constCast(operand_83);
                                state_items_started_67 = true;
                            }

                            (state_items_66)[@intCast(operand_85)] = operand_86;

                            break :block_87 state_items_66;
                        };
                    }, .order = (value_9).order, .scalar_count = (value_9).scalar_count, });
                };

                const value_13: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_12;
                const value_14: []const u32 = (value_13).order;
                const value_15: u64 = (value_12).index;

                const value_16: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_81: {
                    break :block_81 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_13).index, .mapping = (value_13).mapping, .order = block_80: {
                        const operand_73 = block_72: {
                            break :block_72 value_14;
                        };
                        const operand_75 = block_74: {
                            break :block_74 value_15;
                        };

                        if ((operand_75 >= (operand_73).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_78 = block_77: {
                            const operand_76 = (value_12).index;

                            break :block_77 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_76));
                        };

                        break :block_80 block_79: {
                            if ((!state_items_started_69)) {
                                state_items_68 = @constCast(operand_73);
                                state_items_started_69 = true;
                            }

                            (state_items_68)[@intCast(operand_75)] = operand_78;

                            break :block_79 state_items_68;
                        };
                    }, .scalar_count = (value_13).scalar_count, });
                };
                const value_17: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_16;
                const value_18: u64 = (value_17).index;

                const value_19: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_71: {
                    break :block_71 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_70: {
                        break :block_70 value_18;
                    } + @as(u64, 1)), .mapping = (value_17).mapping, .order = (value_17).order, .scalar_count = (value_17).scalar_count, });
                };

                break :block_90 value_19;
            };
        }

        break :block_93 block_92: {
            break :block_92 (if (((state_59).zx_origin != null)) ((state_59).zx_origin.?).* else block_91: {
                break :block_91 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (state_59).index, .mapping = (state_59).mapping, .order = (state_59).order, .scalar_count = (state_59).scalar_count, };
            });
        };
    };

    return block_58: {
        const operand_53 = ((&value_20)).mapping;
        const operand_54 = ((&value_20)).order;
        const operand_55 = value_6;
        const operand_56 = (in).scalar_count;
        const operand_57 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_58 (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_53, .order = operand_54, .origins = operand_55, .count = operand_56, .status = operand_57, };
    };
}

