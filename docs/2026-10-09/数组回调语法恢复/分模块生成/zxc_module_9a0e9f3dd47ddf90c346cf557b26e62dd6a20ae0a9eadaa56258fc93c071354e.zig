const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_121: {
        const value_2: []const u8 = (in).kinds;

        break :block_121 block_120: {
            const operand_104 = block_103: {
                const operand_99 = value_2;
                const operand_100 = @as(u64, 0);

                const operand_101 = block_102: {
                    break :block_102 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_103 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_100, .result = operand_101, .source = operand_99, };
            };

            var state_capacity_105: (std).ArrayList(u64) = .empty;
            var state_capacity_started_106 = false;

            defer (state_capacity_105).deinit(allocator);

            var state_98: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_104).index, .result = (operand_104).result, .source = (operand_104).source, .zx_origin = (&operand_104), };

            while (((state_98).index < @as(u64, ((state_98).source).len))) {
                state_98 = block_118: {
                    _ = block_117: {
                        const operand_115 = (state_98).source;
                        const operand_116 = (state_98).index;

                        if ((operand_116 >= (operand_115).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_117 (operand_115)[@intCast(operand_116)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_118 block_114: {
                        const operand_107 = (state_98).source;
                        const operand_108 = ((state_98).index + @as(u64, 1));

                        const operand_109 = (block_113: {
                            const operand_110 = (state_98).result;

                            const operand_112 = block_111: {
                                break :block_111 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_110).len, 1));

                            if ((!state_capacity_started_106)) {
                                (try (state_capacity_105).ensureTotalCapacityPrecise(allocator, ((operand_104).source).len));
                                (try (state_capacity_105).appendSlice(allocator, operand_110));

                                state_capacity_started_106 = true;
                            } else {
                                ((state_capacity_105).items).len = (operand_110).len;
                            }

                            (try (state_capacity_105).append(allocator, operand_112));

                            break :block_113 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_105).items, {}, null, });
                        }).@"0";

                        break :block_114 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_108, .result = operand_109, .source = operand_107, });
                    };
                };
            }

            var state_owned_119: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_119);

            if (state_capacity_started_106) {
                ((state_capacity_105).items).len = ((state_98).result).len;
                state_owned_119 = (try (state_capacity_105).toOwnedSlice(allocator));
            }

            if (state_capacity_started_106) {
                state_98 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_98).index, .result = state_owned_119, .source = (state_98).source, };
            }

            break :block_120 (state_98).result;
        };
    };

    const value_16: []const u32 = block_97: {
        const value_10: []const u8 = (in).kinds;

        break :block_97 block_96: {
            const operand_78 = block_77: {
                const operand_73 = value_10;
                const operand_74 = @as(u64, 0);

                const operand_75 = block_76: {
                    break :block_76 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_77 (zx_abi).zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f{ .index = operand_74, .result = operand_75, .source = operand_73, };
            };

            var state_capacity_79: (std).ArrayList(u32) = .empty;
            var state_capacity_started_80 = false;

            defer (state_capacity_79).deinit(allocator);

            var state_72: (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_78).index, .result = (operand_78).result, .source = (operand_78).source, .zx_origin = (&operand_78), };

            while (((state_72).index < @as(u64, ((state_72).source).len))) {
                state_72 = block_94: {
                    _ = block_93: {
                        const operand_91 = (state_72).source;
                        const operand_92 = (state_72).index;

                        if ((operand_92 >= (operand_91).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_93 (operand_91)[@intCast(operand_92)];
                    };
                    const value_14: u32 = block_90: {
                        const operand_89 = @as(u64, 0);

                        break :block_90 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_89));
                    };

                    break :block_94 block_88: {
                        const operand_81 = (state_72).source;
                        const operand_82 = ((state_72).index + @as(u64, 1));

                        const operand_83 = (block_87: {
                            const operand_84 = (state_72).result;

                            const operand_86 = block_85: {
                                break :block_85 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_84).len, 1));

                            if ((!state_capacity_started_80)) {
                                (try (state_capacity_79).ensureTotalCapacityPrecise(allocator, ((operand_78).source).len));
                                (try (state_capacity_79).appendSlice(allocator, operand_84));
                                state_capacity_started_80 = true;
                            } else {
                                ((state_capacity_79).items).len = (operand_84).len;
                            }

                            (try (state_capacity_79).append(allocator, operand_86));

                            break :block_87 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_79).items, {}, null, });
                        }).@"0";

                        break :block_88 @as((zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_82, .result = operand_83, .source = operand_81, });
                    };
                };
            }

            var state_owned_95: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_95);

            if (state_capacity_started_80) {
                ((state_capacity_79).items).len = ((state_72).result).len;
                state_owned_95 = (try (state_capacity_79).toOwnedSlice(allocator));
            }

            if (state_capacity_started_80) {
                state_72 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_72).index, .result = state_owned_95, .source = (state_72).source, };
            }

            break :block_96 (state_72).result;
        };
    };

    const value_24: []const u64 = block_71: {
        const value_18: []const u8 = (in).kinds;

        break :block_71 block_70: {
            const operand_54 = block_53: {
                const operand_49 = value_18;
                const operand_50 = @as(u64, 0);

                const operand_51 = block_52: {
                    break :block_52 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_53 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_50, .result = operand_51, .source = operand_49, };
            };

            var state_capacity_55: (std).ArrayList(u64) = .empty;
            var state_capacity_started_56 = false;

            defer (state_capacity_55).deinit(allocator);

            var state_48: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_54).index, .result = (operand_54).result, .source = (operand_54).source, .zx_origin = (&operand_54), };

            while (((state_48).index < @as(u64, ((state_48).source).len))) {
                state_48 = block_68: {
                    _ = block_67: {
                        const operand_65 = (state_48).source;
                        const operand_66 = (state_48).index;

                        if ((operand_66 >= (operand_65).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_67 (operand_65)[@intCast(operand_66)];
                    };

                    const value_22: u64 = @as(u64, 0);

                    break :block_68 block_64: {
                        const operand_57 = (state_48).source;
                        const operand_58 = ((state_48).index + @as(u64, 1));

                        const operand_59 = (block_63: {
                            const operand_60 = (state_48).result;

                            const operand_62 = block_61: {
                                break :block_61 value_22;
                            };

                            _ = (try ((std).math).add(usize, (operand_60).len, 1));

                            if ((!state_capacity_started_56)) {
                                (try (state_capacity_55).ensureTotalCapacityPrecise(allocator, ((operand_54).source).len));
                                (try (state_capacity_55).appendSlice(allocator, operand_60));
                                state_capacity_started_56 = true;
                            } else {
                                ((state_capacity_55).items).len = (operand_60).len;
                            }

                            (try (state_capacity_55).append(allocator, operand_62));

                            break :block_63 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_55).items, {}, null, });
                        }).@"0";

                        break :block_64 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_58, .result = operand_59, .source = operand_57, });
                    };
                };
            }

            var state_owned_69: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_69);

            if (state_capacity_started_56) {
                ((state_capacity_55).items).len = ((state_48).result).len;
                state_owned_69 = (try (state_capacity_55).toOwnedSlice(allocator));
            }

            if (state_capacity_started_56) {
                state_48 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_48).index, .result = state_owned_69, .source = (state_48).source, };
            }

            break :block_70 (state_48).result;
        };
    };

    const value_38: *const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_47: {
        const operand_17 = block_16: {
            const operand_10 = value_8;
            const operand_11 = value_16;
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
        var state_9: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_17).index, .mapping = (operand_17).mapping, .order = (operand_17).order, .scalar_count = (operand_17).scalar_count, .zx_origin = operand_17, };
        var state_changed_18 = false;

        while (((state_9).index < (state_9).scalar_count)) {
            state_9 = block_43: {
                const value_27: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_9;
                const value_28: []const u64 = (value_27).mapping;
                const value_29: u64 = (state_9).index;

                const value_30: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_42: {
                    break :block_42 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_27).index, .mapping = block_41: {
                        const operand_36 = block_35: {
                            break :block_35 value_28;
                        };
                        const operand_38 = block_37: {
                            break :block_37 value_29;
                        };

                        if ((operand_38 >= (operand_36).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_39 = ((state_9).index + @as(u64, 1));

                        break :block_41 block_40: {
                            if ((!state_items_started_20)) {
                                state_items_19 = (try (allocator).dupe(u64, operand_36));
                                state_items_started_20 = true;
                            }

                            (state_items_19)[@intCast(operand_38)] = operand_39;

                            break :block_40 state_items_19;
                        };
                    }, .order = (value_27).order, .scalar_count = (value_27).scalar_count, });
                };

                const value_31: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_30;
                const value_32: []const u32 = (value_31).order;
                const value_33: u64 = (value_30).index;

                const value_34: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_34: {
                    break :block_34 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_31).index, .mapping = (value_31).mapping, .order = block_33: {
                        const operand_26 = block_25: {
                            break :block_25 value_32;
                        };
                        const operand_28 = block_27: {
                            break :block_27 value_33;
                        };

                        if ((operand_28 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_31 = block_30: {
                            const operand_29 = (value_30).index;

                            break :block_30 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_29));
                        };

                        break :block_33 block_32: {
                            if ((!state_items_started_22)) {
                                state_items_21 = (try (allocator).dupe(u32, operand_26));
                                state_items_started_22 = true;
                            }

                            (state_items_21)[@intCast(operand_28)] = operand_31;

                            break :block_32 state_items_21;
                        };
                    }, .scalar_count = (value_31).scalar_count, });
                };

                const value_35: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_24: {
                    break :block_24 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_23: {
                        break :block_23 value_36;
                    } + @as(u64, 1)), .mapping = (value_35).mapping, .order = (value_35).order, .scalar_count = (value_35).scalar_count, });
                };

                break :block_43 value_37;
            };

            state_changed_18 = true;
        }

        break :block_47 (if (state_changed_18) block_46: {
            break :block_46 (if (((state_9).zx_origin != null)) (state_9).zx_origin.? else block_45: {
                const operand_44 = (try (allocator).create((zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c));

                (operand_44).* = (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (state_9).index, .mapping = (state_9).mapping, .order = (state_9).order, .scalar_count = (state_9).scalar_count, };

                break :block_45 @as(*const (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c, operand_44);
            });
        } else operand_17);
    };

    return block_8: {
        const operand_1 = (value_38).mapping;
        const operand_2 = (value_38).order;
        const operand_3 = value_24;
        const operand_4 = (in).scalar_count;
        const operand_5 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_6).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_1, .order = operand_2, .origins = operand_3, .count = operand_4, .status = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_6);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_236: {
        const value_2: []const u8 = (in).kinds;

        break :block_236 block_235: {
            const operand_219 = block_218: {
                const operand_214 = value_2;
                const operand_215 = @as(u64, 0);

                const operand_216 = block_217: {
                    break :block_217 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_218 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_215, .result = operand_216, .source = operand_214, };
            };

            var state_capacity_220: (std).ArrayList(u64) = .empty;
            var state_capacity_started_221 = false;

            defer (state_capacity_220).deinit(allocator);

            var state_213: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_219).index, .result = (operand_219).result, .source = (operand_219).source, .zx_origin = (&operand_219), };

            while (((state_213).index < @as(u64, ((state_213).source).len))) {
                state_213 = block_233: {
                    _ = block_232: {
                        const operand_230 = (state_213).source;
                        const operand_231 = (state_213).index;

                        if ((operand_231 >= (operand_230).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_232 (operand_230)[@intCast(operand_231)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_233 block_229: {
                        const operand_222 = (state_213).source;
                        const operand_223 = ((state_213).index + @as(u64, 1));

                        const operand_224 = (block_228: {
                            const operand_225 = (state_213).result;

                            const operand_227 = block_226: {
                                break :block_226 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_225).len, 1));

                            if ((!state_capacity_started_221)) {
                                (try (state_capacity_220).ensureTotalCapacityPrecise(allocator, ((operand_219).source).len));
                                (try (state_capacity_220).appendSlice(allocator, operand_225));

                                state_capacity_started_221 = true;
                            } else {
                                ((state_capacity_220).items).len = (operand_225).len;
                            }

                            (try (state_capacity_220).append(allocator, operand_227));

                            break :block_228 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_220).items, {}, null, });
                        }).@"0";

                        break :block_229 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_223, .result = operand_224, .source = operand_222, });
                    };
                };
            }

            var state_owned_234: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_234);

            if (state_capacity_started_221) {
                ((state_capacity_220).items).len = ((state_213).result).len;
                state_owned_234 = (try (state_capacity_220).toOwnedSlice(allocator));
            }

            if (state_capacity_started_221) {
                state_213 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_213).index, .result = state_owned_234, .source = (state_213).source, };
            }

            break :block_235 (state_213).result;
        };
    };

    const value_16: []const u32 = block_212: {
        const value_10: []const u8 = (in).kinds;

        break :block_212 block_211: {
            const operand_193 = block_192: {
                const operand_188 = value_10;
                const operand_189 = @as(u64, 0);

                const operand_190 = block_191: {
                    break :block_191 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_192 (zx_abi).zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f{ .index = operand_189, .result = operand_190, .source = operand_188, };
            };

            var state_capacity_194: (std).ArrayList(u32) = .empty;
            var state_capacity_started_195 = false;

            defer (state_capacity_194).deinit(allocator);

            var state_187: (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_193).index, .result = (operand_193).result, .source = (operand_193).source, .zx_origin = (&operand_193), };

            while (((state_187).index < @as(u64, ((state_187).source).len))) {
                state_187 = block_209: {
                    _ = block_208: {
                        const operand_206 = (state_187).source;
                        const operand_207 = (state_187).index;

                        if ((operand_207 >= (operand_206).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_208 (operand_206)[@intCast(operand_207)];
                    };
                    const value_14: u32 = block_205: {
                        const operand_204 = @as(u64, 0);

                        break :block_205 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_204));
                    };

                    break :block_209 block_203: {
                        const operand_196 = (state_187).source;
                        const operand_197 = ((state_187).index + @as(u64, 1));

                        const operand_198 = (block_202: {
                            const operand_199 = (state_187).result;

                            const operand_201 = block_200: {
                                break :block_200 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_199).len, 1));

                            if ((!state_capacity_started_195)) {
                                (try (state_capacity_194).ensureTotalCapacityPrecise(allocator, ((operand_193).source).len));
                                (try (state_capacity_194).appendSlice(allocator, operand_199));

                                state_capacity_started_195 = true;
                            } else {
                                ((state_capacity_194).items).len = (operand_199).len;
                            }

                            (try (state_capacity_194).append(allocator, operand_201));

                            break :block_202 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_194).items, {}, null, });
                        }).@"0";

                        break :block_203 @as((zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_197, .result = operand_198, .source = operand_196, });
                    };
                };
            }

            var state_owned_210: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_210);

            if (state_capacity_started_195) {
                ((state_capacity_194).items).len = ((state_187).result).len;
                state_owned_210 = (try (state_capacity_194).toOwnedSlice(allocator));
            }

            if (state_capacity_started_195) {
                state_187 = (zx_abi).value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_187).index, .result = state_owned_210, .source = (state_187).source, };
            }

            break :block_211 (state_187).result;
        };
    };

    const value_24: []const u64 = block_186: {
        const value_18: []const u8 = (in).kinds;

        break :block_186 block_185: {
            const operand_169 = block_168: {
                const operand_164 = value_18;
                const operand_165 = @as(u64, 0);

                const operand_166 = block_167: {
                    break :block_167 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_168 (zx_abi).zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a{ .index = operand_165, .result = operand_166, .source = operand_164, };
            };

            var state_capacity_170: (std).ArrayList(u64) = .empty;
            var state_capacity_started_171 = false;

            defer (state_capacity_170).deinit(allocator);

            var state_163: (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_169).index, .result = (operand_169).result, .source = (operand_169).source, .zx_origin = (&operand_169), };

            while (((state_163).index < @as(u64, ((state_163).source).len))) {
                state_163 = block_183: {
                    _ = block_182: {
                        const operand_180 = (state_163).source;
                        const operand_181 = (state_163).index;

                        if ((operand_181 >= (operand_180).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_182 (operand_180)[@intCast(operand_181)];
                    };

                    const value_22: u64 = @as(u64, 0);

                    break :block_183 block_179: {
                        const operand_172 = (state_163).source;
                        const operand_173 = ((state_163).index + @as(u64, 1));

                        const operand_174 = (block_178: {
                            const operand_175 = (state_163).result;

                            const operand_177 = block_176: {
                                break :block_176 value_22;
                            };

                            _ = (try ((std).math).add(usize, (operand_175).len, 1));

                            if ((!state_capacity_started_171)) {
                                (try (state_capacity_170).ensureTotalCapacityPrecise(allocator, ((operand_169).source).len));
                                (try (state_capacity_170).appendSlice(allocator, operand_175));
                                state_capacity_started_171 = true;
                            } else {
                                ((state_capacity_170).items).len = (operand_175).len;
                            }

                            (try (state_capacity_170).append(allocator, operand_177));

                            break :block_178 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_170).items, {}, null, });
                        }).@"0";

                        break :block_179 @as((zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_173, .result = operand_174, .source = operand_172, });
                    };
                };
            }

            var state_owned_184: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_184);

            if (state_capacity_started_171) {
                ((state_capacity_170).items).len = ((state_163).result).len;
                state_owned_184 = (try (state_capacity_170).toOwnedSlice(allocator));
            }

            if (state_capacity_started_171) {
                state_163 = (zx_abi).value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_163).index, .result = state_owned_184, .source = (state_163).source, };
            }

            break :block_185 (state_163).result;
        };
    };

    const value_38: (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = block_162: {
        const operand_134 = block_133: {
            const operand_129 = value_8;
            const operand_130 = value_16;
            const operand_131 = @as(u64, 0);
            const operand_132 = (in).scalar_count;

            break :block_133 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .mapping = operand_129, .order = operand_130, .index = operand_131, .scalar_count = operand_132, };
        };

        var state_items_135: []u64 = undefined;
        var state_items_started_136 = false;
        var state_items_137: []u32 = undefined;
        var state_items_started_138 = false;
        var state_128: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (operand_134).index, .mapping = (operand_134).mapping, .order = (operand_134).order, .scalar_count = (operand_134).scalar_count, .zx_origin = (&operand_134), };

        while (((state_128).index < (state_128).scalar_count)) {
            state_128 = block_159: {
                const value_27: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = state_128;
                const value_28: []const u64 = (value_27).mapping;
                const value_29: u64 = (state_128).index;

                const value_30: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_158: {
                    break :block_158 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_27).index, .mapping = block_157: {
                        const operand_152 = block_151: {
                            break :block_151 value_28;
                        };
                        const operand_154 = block_153: {
                            break :block_153 value_29;
                        };

                        if ((operand_154 >= (operand_152).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_155 = ((state_128).index + @as(u64, 1));

                        break :block_157 block_156: {
                            if ((!state_items_started_136)) {
                                state_items_135 = (try (allocator).dupe(u64, operand_152));
                                state_items_started_136 = true;
                            }

                            (state_items_135)[@intCast(operand_154)] = operand_155;

                            break :block_156 state_items_135;
                        };
                    }, .order = (value_27).order, .scalar_count = (value_27).scalar_count, });
                };

                const value_31: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_30;
                const value_32: []const u32 = (value_31).order;
                const value_33: u64 = (value_30).index;

                const value_34: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_150: {
                    break :block_150 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (value_31).index, .mapping = (value_31).mapping, .order = block_149: {
                        const operand_142 = block_141: {
                            break :block_141 value_32;
                        };
                        const operand_144 = block_143: {
                            break :block_143 value_33;
                        };

                        if ((operand_144 >= (operand_142).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_147 = block_146: {
                            const operand_145 = (value_30).index;

                            break :block_146 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_145));
                        };

                        break :block_149 block_148: {
                            if ((!state_items_started_138)) {
                                state_items_137 = (try (allocator).dupe(u32, operand_142));
                                state_items_started_138 = true;
                            }

                            (state_items_137)[@intCast(operand_144)] = operand_147;

                            break :block_148 state_items_137;
                        };
                    }, .scalar_count = (value_31).scalar_count, });
                };

                const value_35: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_140: {
                    break :block_140 @as((zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .index = (block_139: {
                        break :block_139 value_36;
                    } + @as(u64, 1)), .mapping = (value_35).mapping, .order = (value_35).order, .scalar_count = (value_35).scalar_count, });
                };

                break :block_159 value_37;
            };
        }

        break :block_162 block_161: {
            break :block_161 (if (((state_128).zx_origin != null)) ((state_128).zx_origin.?).* else block_160: {
                break :block_160 (zx_abi).zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c{ .index = (state_128).index, .mapping = (state_128).mapping, .order = (state_128).order, .scalar_count = (state_128).scalar_count, };
            });
        };
    };

    return block_127: {
        const operand_122 = ((&value_38)).mapping;
        const operand_123 = ((&value_38)).order;
        const operand_124 = value_24;
        const operand_125 = (in).scalar_count;
        const operand_126 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready);

        break :block_127 (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .mapping = operand_122, .order = operand_123, .origins = operand_124, .count = operand_125, .status = operand_126, };
    };
}

