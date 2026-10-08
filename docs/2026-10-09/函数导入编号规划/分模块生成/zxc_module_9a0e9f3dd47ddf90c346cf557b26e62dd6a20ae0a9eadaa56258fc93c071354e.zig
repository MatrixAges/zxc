const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_122: {
        const value_2: []const u8 = (in).kinds;

        break :block_122 block_121: {
            const operand_105 = block_104: {
                const operand_100 = value_2;
                const operand_101 = @as(u64, 0);

                const operand_102 = block_103: {
                    break :block_103 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_104 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_101, .result = operand_102, .source = operand_100, };
            };

            var state_capacity_106: (std).ArrayList(u64) = .empty;
            var state_capacity_started_107 = false;

            defer (state_capacity_106).deinit(allocator);

            var state_99: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_105).index, .result = (operand_105).result, .source = (operand_105).source, .zx_origin = (&operand_105), };

            while (((state_99).index < @as(u64, ((state_99).source).len))) {
                state_99 = block_119: {
                    _ = block_118: {
                        const operand_116 = (state_99).source;
                        const operand_117 = (state_99).index;

                        if ((operand_117 >= (operand_116).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_118 (operand_116)[@intCast(operand_117)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_119 block_115: {
                        const operand_108 = (state_99).source;
                        const operand_109 = ((state_99).index + @as(u64, 1));

                        const operand_110 = (block_114: {
                            const operand_111 = (state_99).result;

                            const operand_113 = block_112: {
                                break :block_112 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_111).len, 1));

                            if ((!state_capacity_started_107)) {
                                (try (state_capacity_106).ensureTotalCapacityPrecise(allocator, ((operand_105).source).len));
                                (try (state_capacity_106).appendSlice(allocator, operand_111));
                                state_capacity_started_107 = true;
                            } else {
                                ((state_capacity_106).items).len = (operand_111).len;
                            }

                            (try (state_capacity_106).append(allocator, operand_113));

                            break :block_114 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_106).items, {}, null, });
                        }).@"0";

                        break :block_115 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_109, .result = operand_110, .source = operand_108, });
                    };
                };
            }

            var state_owned_120: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_120);

            if (state_capacity_started_107) {
                ((state_capacity_106).items).len = ((state_99).result).len;
                state_owned_120 = (try (state_capacity_106).toOwnedSlice(allocator));
            }

            if (state_capacity_started_107) {
                state_99 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_99).index, .result = state_owned_120, .source = (state_99).source, };
            }

            break :block_121 (state_99).result;
        };
    };

    const value_16: []const u32 = block_98: {
        const value_10: []const u8 = (in).kinds;

        break :block_98 block_97: {
            const operand_79 = block_78: {
                const operand_74 = value_10;
                const operand_75 = @as(u64, 0);

                const operand_76 = block_77: {
                    break :block_77 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_78 (zx_abi).zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f{ .index = operand_75, .result = operand_76, .source = operand_74, };
            };

            var state_capacity_80: (std).ArrayList(u32) = .empty;
            var state_capacity_started_81 = false;

            defer (state_capacity_80).deinit(allocator);

            var state_73: (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_79).index, .result = (operand_79).result, .source = (operand_79).source, .zx_origin = (&operand_79), };

            while (((state_73).index < @as(u64, ((state_73).source).len))) {
                state_73 = block_95: {
                    _ = block_94: {
                        const operand_92 = (state_73).source;
                        const operand_93 = (state_73).index;

                        if ((operand_93 >= (operand_92).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_94 (operand_92)[@intCast(operand_93)];
                    };
                    const value_14: u32 = block_91: {
                        const operand_90 = @as(u64, 0);

                        break :block_91 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_90));
                    };

                    break :block_95 block_89: {
                        const operand_82 = (state_73).source;
                        const operand_83 = ((state_73).index + @as(u64, 1));

                        const operand_84 = (block_88: {
                            const operand_85 = (state_73).result;

                            const operand_87 = block_86: {
                                break :block_86 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_85).len, 1));

                            if ((!state_capacity_started_81)) {
                                (try (state_capacity_80).ensureTotalCapacityPrecise(allocator, ((operand_79).source).len));
                                (try (state_capacity_80).appendSlice(allocator, operand_85));

                                state_capacity_started_81 = true;
                            } else {
                                ((state_capacity_80).items).len = (operand_85).len;
                            }

                            (try (state_capacity_80).append(allocator, operand_87));

                            break :block_88 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_80).items, {}, null, });
                        }).@"0";

                        break :block_89 @as((zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_83, .result = operand_84, .source = operand_82, });
                    };
                };
            }

            var state_owned_96: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_96);

            if (state_capacity_started_81) {
                ((state_capacity_80).items).len = ((state_73).result).len;
                state_owned_96 = (try (state_capacity_80).toOwnedSlice(allocator));
            }

            if (state_capacity_started_81) {
                state_73 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_73).index, .result = state_owned_96, .source = (state_73).source, };
            }

            break :block_97 (state_73).result;
        };
    };

    const value_24: []const u64 = block_72: {
        const value_18: []const u8 = (in).kinds;

        break :block_72 block_71: {
            const operand_55 = block_54: {
                const operand_50 = value_18;
                const operand_51 = @as(u64, 0);

                const operand_52 = block_53: {
                    break :block_53 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_54 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_51, .result = operand_52, .source = operand_50, };
            };

            var state_capacity_56: (std).ArrayList(u64) = .empty;
            var state_capacity_started_57 = false;

            defer (state_capacity_56).deinit(allocator);

            var state_49: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_55).index, .result = (operand_55).result, .source = (operand_55).source, .zx_origin = (&operand_55), };

            while (((state_49).index < @as(u64, ((state_49).source).len))) {
                state_49 = block_69: {
                    _ = block_68: {
                        const operand_66 = (state_49).source;
                        const operand_67 = (state_49).index;

                        if ((operand_67 >= (operand_66).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_68 (operand_66)[@intCast(operand_67)];
                    };

                    const value_22: u64 = @as(u64, 0);

                    break :block_69 block_65: {
                        const operand_58 = (state_49).source;
                        const operand_59 = ((state_49).index + @as(u64, 1));

                        const operand_60 = (block_64: {
                            const operand_61 = (state_49).result;

                            const operand_63 = block_62: {
                                break :block_62 value_22;
                            };

                            _ = (try ((std).math).add(usize, (operand_61).len, 1));

                            if ((!state_capacity_started_57)) {
                                (try (state_capacity_56).ensureTotalCapacityPrecise(allocator, ((operand_55).source).len));
                                (try (state_capacity_56).appendSlice(allocator, operand_61));

                                state_capacity_started_57 = true;
                            } else {
                                ((state_capacity_56).items).len = (operand_61).len;
                            }

                            (try (state_capacity_56).append(allocator, operand_63));

                            break :block_64 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_56).items, {}, null, });
                        }).@"0";

                        break :block_65 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_59, .result = operand_60, .source = operand_58, });
                    };
                };
            }

            var state_owned_70: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_70);

            if (state_capacity_started_57) {
                ((state_capacity_56).items).len = ((state_49).result).len;
                state_owned_70 = (try (state_capacity_56).toOwnedSlice(allocator));
            }

            if (state_capacity_started_57) {
                state_49 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_49).index, .result = state_owned_70, .source = (state_49).source, };
            }

            break :block_71 (state_49).result;
        };
    };

    const value_38: *const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_48: {
        const operand_18 = block_17: {
            const operand_11 = value_8;
            const operand_12 = value_16;
            const operand_13 = @as(u64, 0);
            const operand_14 = (in).scalar_count;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c));

                (operand_15).* = @as((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .mapping = operand_11, .order = operand_12, .index = operand_13, .scalar_count = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, operand_15);
            };
        };

        var state_items_20: []u64 = undefined;
        var state_items_started_21 = false;
        var state_items_22: []u32 = undefined;
        var state_items_started_23 = false;
        var state_10: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_18).index, .mapping = (operand_18).mapping, .order = (operand_18).order, .scalar_count = (operand_18).scalar_count, .zx_origin = operand_18, };
        var state_changed_19 = false;

        while (((state_10).index < (state_10).scalar_count)) {
            state_10 = block_44: {
                const value_27: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_10;
                const value_28: []const u64 = (value_27).mapping;
                const value_29: u64 = (state_10).index;

                const value_30: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_43: {
                    break :block_43 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_27).index, .mapping = block_42: {
                        const operand_37 = block_36: {
                            break :block_36 value_28;
                        };
                        const operand_39 = block_38: {
                            break :block_38 value_29;
                        };

                        if ((operand_39 >= (operand_37).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_40 = ((state_10).index + @as(u64, 1));

                        break :block_42 block_41: {
                            if ((!state_items_started_21)) {
                                state_items_20 = (try (allocator).dupe(u64, operand_37));
                                state_items_started_21 = true;
                            }

                            (state_items_20)[@intCast(operand_39)] = operand_40;

                            break :block_41 state_items_20;
                        };
                    }, .order = (value_27).order, .scalar_count = (value_27).scalar_count, });
                };

                const value_31: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_30;
                const value_32: []const u32 = (value_31).order;
                const value_33: u64 = (value_30).index;

                const value_34: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_35: {
                    break :block_35 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_31).index, .mapping = (value_31).mapping, .order = block_34: {
                        const operand_27 = block_26: {
                            break :block_26 value_32;
                        };
                        const operand_29 = block_28: {
                            break :block_28 value_33;
                        };

                        if ((operand_29 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_32 = block_31: {
                            const operand_30 = (value_30).index;

                            break :block_31 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_30));
                        };

                        break :block_34 block_33: {
                            if ((!state_items_started_23)) {
                                state_items_22 = (try (allocator).dupe(u32, operand_27));
                                state_items_started_23 = true;
                            }

                            (state_items_22)[@intCast(operand_29)] = operand_32;

                            break :block_33 state_items_22;
                        };
                    }, .scalar_count = (value_31).scalar_count, });
                };

                const value_35: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_25: {
                    break :block_25 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_24: {
                        break :block_24 value_36;
                    } + @as(u64, 1)), .mapping = (value_35).mapping, .order = (value_35).order, .scalar_count = (value_35).scalar_count, });
                };

                break :block_44 value_37;
            };

            state_changed_19 = true;
        }

        break :block_48 (if (state_changed_19) block_47: {
            break :block_47 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_46: {
                const operand_45 = (try (allocator).create((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c));

                (operand_45).* = (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (state_10).index, .mapping = (state_10).mapping, .order = (state_10).order, .scalar_count = (state_10).scalar_count, };

                break :block_46 @as(*const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, operand_45);
            });
        } else operand_18);
    };

    return block_9: {
        const operand_2 = (value_38).mapping;
        const operand_3 = (value_38).order;
        const operand_4 = value_24;
        const operand_5 = (in).scalar_count;
        const operand_6 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_7).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_2, .order = operand_3, .origins = operand_4, .count = operand_5, .status = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_7);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_238: {
        const value_2: []const u8 = (in).kinds;

        break :block_238 block_237: {
            const operand_221 = block_220: {
                const operand_216 = value_2;
                const operand_217 = @as(u64, 0);

                const operand_218 = block_219: {
                    break :block_219 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_220 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_217, .result = operand_218, .source = operand_216, };
            };

            var state_capacity_222: (std).ArrayList(u64) = .empty;
            var state_capacity_started_223 = false;

            defer (state_capacity_222).deinit(allocator);

            var state_215: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_221).index, .result = (operand_221).result, .source = (operand_221).source, .zx_origin = (&operand_221), };

            while (((state_215).index < @as(u64, ((state_215).source).len))) {
                state_215 = block_235: {
                    _ = block_234: {
                        const operand_232 = (state_215).source;
                        const operand_233 = (state_215).index;

                        if ((operand_233 >= (operand_232).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_234 (operand_232)[@intCast(operand_233)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_235 block_231: {
                        const operand_224 = (state_215).source;
                        const operand_225 = ((state_215).index + @as(u64, 1));

                        const operand_226 = (block_230: {
                            const operand_227 = (state_215).result;

                            const operand_229 = block_228: {
                                break :block_228 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_227).len, 1));

                            if ((!state_capacity_started_223)) {
                                (try (state_capacity_222).ensureTotalCapacityPrecise(allocator, ((operand_221).source).len));
                                (try (state_capacity_222).appendSlice(allocator, operand_227));

                                state_capacity_started_223 = true;
                            } else {
                                ((state_capacity_222).items).len = (operand_227).len;
                            }

                            (try (state_capacity_222).append(allocator, operand_229));

                            break :block_230 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_222).items, {}, null, });
                        }).@"0";

                        break :block_231 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_225, .result = operand_226, .source = operand_224, });
                    };
                };
            }

            var state_owned_236: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_236);

            if (state_capacity_started_223) {
                ((state_capacity_222).items).len = ((state_215).result).len;
                state_owned_236 = (try (state_capacity_222).toOwnedSlice(allocator));
            }

            if (state_capacity_started_223) {
                state_215 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_215).index, .result = state_owned_236, .source = (state_215).source, };
            }

            break :block_237 (state_215).result;
        };
    };

    const value_16: []const u32 = block_214: {
        const value_10: []const u8 = (in).kinds;

        break :block_214 block_213: {
            const operand_195 = block_194: {
                const operand_190 = value_10;
                const operand_191 = @as(u64, 0);

                const operand_192 = block_193: {
                    break :block_193 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_194 (zx_abi).zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f{ .index = operand_191, .result = operand_192, .source = operand_190, };
            };

            var state_capacity_196: (std).ArrayList(u32) = .empty;
            var state_capacity_started_197 = false;

            defer (state_capacity_196).deinit(allocator);

            var state_189: (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_195).index, .result = (operand_195).result, .source = (operand_195).source, .zx_origin = (&operand_195), };

            while (((state_189).index < @as(u64, ((state_189).source).len))) {
                state_189 = block_211: {
                    _ = block_210: {
                        const operand_208 = (state_189).source;
                        const operand_209 = (state_189).index;

                        if ((operand_209 >= (operand_208).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_210 (operand_208)[@intCast(operand_209)];
                    };
                    const value_14: u32 = block_207: {
                        const operand_206 = @as(u64, 0);

                        break :block_207 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_206));
                    };

                    break :block_211 block_205: {
                        const operand_198 = (state_189).source;
                        const operand_199 = ((state_189).index + @as(u64, 1));

                        const operand_200 = (block_204: {
                            const operand_201 = (state_189).result;

                            const operand_203 = block_202: {
                                break :block_202 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_201).len, 1));

                            if ((!state_capacity_started_197)) {
                                (try (state_capacity_196).ensureTotalCapacityPrecise(allocator, ((operand_195).source).len));
                                (try (state_capacity_196).appendSlice(allocator, operand_201));

                                state_capacity_started_197 = true;
                            } else {
                                ((state_capacity_196).items).len = (operand_201).len;
                            }

                            (try (state_capacity_196).append(allocator, operand_203));

                            break :block_204 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_196).items, {}, null, });
                        }).@"0";

                        break :block_205 @as((zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_199, .result = operand_200, .source = operand_198, });
                    };
                };
            }

            var state_owned_212: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_212);

            if (state_capacity_started_197) {
                ((state_capacity_196).items).len = ((state_189).result).len;
                state_owned_212 = (try (state_capacity_196).toOwnedSlice(allocator));
            }

            if (state_capacity_started_197) {
                state_189 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_189).index, .result = state_owned_212, .source = (state_189).source, };
            }

            break :block_213 (state_189).result;
        };
    };

    const value_24: []const u64 = block_188: {
        const value_18: []const u8 = (in).kinds;

        break :block_188 block_187: {
            const operand_171 = block_170: {
                const operand_166 = value_18;
                const operand_167 = @as(u64, 0);

                const operand_168 = block_169: {
                    break :block_169 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_170 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_167, .result = operand_168, .source = operand_166, };
            };

            var state_capacity_172: (std).ArrayList(u64) = .empty;
            var state_capacity_started_173 = false;

            defer (state_capacity_172).deinit(allocator);

            var state_165: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_171).index, .result = (operand_171).result, .source = (operand_171).source, .zx_origin = (&operand_171), };

            while (((state_165).index < @as(u64, ((state_165).source).len))) {
                state_165 = block_185: {
                    _ = block_184: {
                        const operand_182 = (state_165).source;
                        const operand_183 = (state_165).index;

                        if ((operand_183 >= (operand_182).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_184 (operand_182)[@intCast(operand_183)];
                    };

                    const value_22: u64 = @as(u64, 0);

                    break :block_185 block_181: {
                        const operand_174 = (state_165).source;
                        const operand_175 = ((state_165).index + @as(u64, 1));

                        const operand_176 = (block_180: {
                            const operand_177 = (state_165).result;

                            const operand_179 = block_178: {
                                break :block_178 value_22;
                            };

                            _ = (try ((std).math).add(usize, (operand_177).len, 1));

                            if ((!state_capacity_started_173)) {
                                (try (state_capacity_172).ensureTotalCapacityPrecise(allocator, ((operand_171).source).len));
                                (try (state_capacity_172).appendSlice(allocator, operand_177));

                                state_capacity_started_173 = true;
                            } else {
                                ((state_capacity_172).items).len = (operand_177).len;
                            }

                            (try (state_capacity_172).append(allocator, operand_179));

                            break :block_180 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_172).items, {}, null, });
                        }).@"0";

                        break :block_181 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_175, .result = operand_176, .source = operand_174, });
                    };
                };
            }

            var state_owned_186: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_186);

            if (state_capacity_started_173) {
                ((state_capacity_172).items).len = ((state_165).result).len;
                state_owned_186 = (try (state_capacity_172).toOwnedSlice(allocator));
            }

            if (state_capacity_started_173) {
                state_165 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_165).index, .result = state_owned_186, .source = (state_165).source, };
            }

            break :block_187 (state_165).result;
        };
    };

    const value_38: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_164: {
        const operand_136 = block_135: {
            const operand_131 = value_8;
            const operand_132 = value_16;
            const operand_133 = @as(u64, 0);
            const operand_134 = (in).scalar_count;

            break :block_135 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .mapping = operand_131, .order = operand_132, .index = operand_133, .scalar_count = operand_134, };
        };

        var state_items_137: []u64 = undefined;
        var state_items_started_138 = false;
        var state_items_139: []u32 = undefined;
        var state_items_started_140 = false;
        var state_130: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_136).index, .mapping = (operand_136).mapping, .order = (operand_136).order, .scalar_count = (operand_136).scalar_count, .zx_origin = (&operand_136), };

        while (((state_130).index < (state_130).scalar_count)) {
            state_130 = block_161: {
                const value_27: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_130;
                const value_28: []const u64 = (value_27).mapping;
                const value_29: u64 = (state_130).index;

                const value_30: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_160: {
                    break :block_160 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_27).index, .mapping = block_159: {
                        const operand_154 = block_153: {
                            break :block_153 value_28;
                        };
                        const operand_156 = block_155: {
                            break :block_155 value_29;
                        };

                        if ((operand_156 >= (operand_154).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_157 = ((state_130).index + @as(u64, 1));

                        break :block_159 block_158: {
                            if ((!state_items_started_138)) {
                                state_items_137 = (try (allocator).dupe(u64, operand_154));
                                state_items_started_138 = true;
                            }

                            (state_items_137)[@intCast(operand_156)] = operand_157;

                            break :block_158 state_items_137;
                        };
                    }, .order = (value_27).order, .scalar_count = (value_27).scalar_count, });
                };

                const value_31: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_30;
                const value_32: []const u32 = (value_31).order;
                const value_33: u64 = (value_30).index;

                const value_34: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_152: {
                    break :block_152 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_31).index, .mapping = (value_31).mapping, .order = block_151: {
                        const operand_144 = block_143: {
                            break :block_143 value_32;
                        };

                        const operand_146 = block_145: {
                            break :block_145 value_33;
                        };

                        if ((operand_146 >= (operand_144).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_149 = block_148: {
                            const operand_147 = (value_30).index;

                            break :block_148 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_147));
                        };

                        break :block_151 block_150: {
                            if ((!state_items_started_140)) {
                                state_items_139 = (try (allocator).dupe(u32, operand_144));
                                state_items_started_140 = true;
                            }

                            (state_items_139)[@intCast(operand_146)] = operand_149;

                            break :block_150 state_items_139;
                        };
                    }, .scalar_count = (value_31).scalar_count, });
                };

                const value_35: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_142: {
                    break :block_142 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_141: {
                        break :block_141 value_36;
                    } + @as(u64, 1)), .mapping = (value_35).mapping, .order = (value_35).order, .scalar_count = (value_35).scalar_count, });
                };

                break :block_161 value_37;
            };
        }

        break :block_164 block_163: {
            break :block_163 (if (((state_130).zx_origin != null)) ((state_130).zx_origin.?).* else block_162: {
                break :block_162 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (state_130).index, .mapping = (state_130).mapping, .order = (state_130).order, .scalar_count = (state_130).scalar_count, };
            });
        };
    };

    return block_129: {
        const operand_124 = ((&value_38)).mapping;
        const operand_125 = ((&value_38)).order;
        const operand_126 = value_24;
        const operand_127 = (in).scalar_count;
        const operand_128 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_129 (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_124, .order = operand_125, .origins = operand_126, .count = operand_127, .status = operand_128, };
    };
}

