const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_56: {
        const value_2: []const []const u8 = (in).specifiers;

        break :block_56 block_55: {
            const operand_39 = block_38: {
                const operand_34 = value_2;
                const operand_35 = @as(u64, 0);

                const operand_36 = block_37: {
                    break :block_37 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_38 (zx_abi).zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e{ .index = operand_35, .result = operand_36, .source = operand_34, };
            };

            var state_capacity_40: (std).ArrayList(u64) = .empty;
            var state_capacity_started_41 = false;

            defer (state_capacity_40).deinit(allocator);

            var state_33: (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_39).index, .result = (operand_39).result, .source = (operand_39).source, .zx_origin = (&operand_39), };

            while (((state_33).index < @as(u64, ((state_33).source).len))) {
                state_33 = block_53: {
                    _ = block_52: {
                        const operand_50 = (state_33).source;
                        const operand_51 = (state_33).index;

                        if ((operand_51 >= (operand_50).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_52 (operand_50)[@intCast(operand_51)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_53 block_49: {
                        const operand_42 = (state_33).source;
                        const operand_43 = ((state_33).index + @as(u64, 1));

                        const operand_44 = (block_48: {
                            const operand_45 = (state_33).result;

                            const operand_47 = block_46: {
                                break :block_46 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_45).len, 1));

                            if ((!state_capacity_started_41)) {
                                (try (state_capacity_40).ensureTotalCapacityPrecise(allocator, ((operand_39).source).len));
                                (try (state_capacity_40).appendSlice(allocator, operand_45));
                                state_capacity_started_41 = true;
                            } else {
                                ((state_capacity_40).items).len = (operand_45).len;
                            }

                            (try (state_capacity_40).append(allocator, operand_47));

                            break :block_48 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_40).items, {}, null, });
                        }).@"0";

                        break :block_49 @as((zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_43, .result = operand_44, .source = operand_42, });
                    };
                };
            }

            var state_owned_54: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_54);

            if (state_capacity_started_41) {
                ((state_capacity_40).items).len = ((state_33).result).len;
                state_owned_54 = (try (state_capacity_40).toOwnedSlice(allocator));
            }

            if (state_capacity_started_41) {
                state_33 = (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_33).index, .result = state_owned_54, .source = (state_33).source, };
            }

            break :block_55 (state_33).result;
        };
    };

    const value_16: []const u32 = block_32: {
        const value_10: []const []const u8 = (in).specifiers;

        break :block_32 block_31: {
            const operand_13 = block_12: {
                const operand_8 = value_10;
                const operand_9 = @as(u64, 0);

                const operand_10 = block_11: {
                    break :block_11 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_12 (zx_abi).zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e{ .index = operand_9, .result = operand_10, .source = operand_8, };
            };

            var state_capacity_14: (std).ArrayList(u32) = .empty;
            var state_capacity_started_15 = false;

            defer (state_capacity_14).deinit(allocator);

            var state_7: (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_13).index, .result = (operand_13).result, .source = (operand_13).source, .zx_origin = (&operand_13), };

            while (((state_7).index < @as(u64, ((state_7).source).len))) {
                state_7 = block_29: {
                    _ = block_28: {
                        const operand_26 = (state_7).source;
                        const operand_27 = (state_7).index;

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_28 (operand_26)[@intCast(operand_27)];
                    };
                    const value_14: u32 = block_25: {
                        const operand_24 = @as(u64, 0);

                        break :block_25 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_24));
                    };

                    break :block_29 block_23: {
                        const operand_16 = (state_7).source;
                        const operand_17 = ((state_7).index + @as(u64, 1));

                        const operand_18 = (block_22: {
                            const operand_19 = (state_7).result;

                            const operand_21 = block_20: {
                                break :block_20 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_19).len, 1));

                            if ((!state_capacity_started_15)) {
                                (try (state_capacity_14).ensureTotalCapacityPrecise(allocator, ((operand_13).source).len));
                                (try (state_capacity_14).appendSlice(allocator, operand_19));
                                state_capacity_started_15 = true;
                            } else {
                                ((state_capacity_14).items).len = (operand_19).len;
                            }

                            (try (state_capacity_14).append(allocator, operand_21));

                            break :block_22 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_14).items, {}, null, });
                        }).@"0";

                        break :block_23 @as((zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_17, .result = operand_18, .source = operand_16, });
                    };
                };
            }

            var state_owned_30: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_30);

            if (state_capacity_started_15) {
                ((state_capacity_14).items).len = ((state_7).result).len;
                state_owned_30 = (try (state_capacity_14).toOwnedSlice(allocator));
            }

            if (state_capacity_started_15) {
                state_7 = (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_7).index, .result = state_owned_30, .source = (state_7).source, };
            }

            break :block_31 (state_7).result;
        };
    };

    return block_6: {
        const operand_1 = value_8;
        const operand_2 = value_16;
        const operand_3 = @as(u64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

            (operand_4).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .mapping = operand_1, .order = operand_2, .count = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_4);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add {
    @setRuntimeSafety(true);

    const value_8: []const u64 = block_110: {
        const value_2: []const []const u8 = (in).specifiers;

        break :block_110 block_109: {
            const operand_93 = block_92: {
                const operand_88 = value_2;
                const operand_89 = @as(u64, 0);

                const operand_90 = block_91: {
                    break :block_91 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_92 (zx_abi).zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e{ .index = operand_89, .result = operand_90, .source = operand_88, };
            };

            var state_capacity_94: (std).ArrayList(u64) = .empty;
            var state_capacity_started_95 = false;

            defer (state_capacity_94).deinit(allocator);

            var state_87: (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_93).index, .result = (operand_93).result, .source = (operand_93).source, .zx_origin = (&operand_93), };

            while (((state_87).index < @as(u64, ((state_87).source).len))) {
                state_87 = block_107: {
                    _ = block_106: {
                        const operand_104 = (state_87).source;
                        const operand_105 = (state_87).index;

                        if ((operand_105 >= (operand_104).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_106 (operand_104)[@intCast(operand_105)];
                    };

                    const value_6: u64 = @as(u64, 0);

                    break :block_107 block_103: {
                        const operand_96 = (state_87).source;
                        const operand_97 = ((state_87).index + @as(u64, 1));

                        const operand_98 = (block_102: {
                            const operand_99 = (state_87).result;

                            const operand_101 = block_100: {
                                break :block_100 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_99).len, 1));

                            if ((!state_capacity_started_95)) {
                                (try (state_capacity_94).ensureTotalCapacityPrecise(allocator, ((operand_93).source).len));
                                (try (state_capacity_94).appendSlice(allocator, operand_99));
                                state_capacity_started_95 = true;
                            } else {
                                ((state_capacity_94).items).len = (operand_99).len;
                            }

                            (try (state_capacity_94).append(allocator, operand_101));

                            break :block_102 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_94).items, {}, null, });
                        }).@"0";

                        break :block_103 @as((zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_97, .result = operand_98, .source = operand_96, });
                    };
                };
            }

            var state_owned_108: []const u64 = (&[_]u64{});

            errdefer (allocator).free(state_owned_108);

            if (state_capacity_started_95) {
                ((state_capacity_94).items).len = ((state_87).result).len;
                state_owned_108 = (try (state_capacity_94).toOwnedSlice(allocator));
            }

            if (state_capacity_started_95) {
                state_87 = (zx_abi).value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_87).index, .result = state_owned_108, .source = (state_87).source, };
            }

            break :block_109 (state_87).result;
        };
    };

    const value_16: []const u32 = block_86: {
        const value_10: []const []const u8 = (in).specifiers;

        break :block_86 block_85: {
            const operand_67 = block_66: {
                const operand_62 = value_10;
                const operand_63 = @as(u64, 0);

                const operand_64 = block_65: {
                    break :block_65 (try (allocator).dupe(u32, (&[_]u32{})));
                };

                break :block_66 (zx_abi).zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e{ .index = operand_63, .result = operand_64, .source = operand_62, };
            };

            var state_capacity_68: (std).ArrayList(u32) = .empty;
            var state_capacity_started_69 = false;

            defer (state_capacity_68).deinit(allocator);

            var state_61: (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_67).index, .result = (operand_67).result, .source = (operand_67).source, .zx_origin = (&operand_67), };

            while (((state_61).index < @as(u64, ((state_61).source).len))) {
                state_61 = block_83: {
                    _ = block_82: {
                        const operand_80 = (state_61).source;
                        const operand_81 = (state_61).index;

                        if ((operand_81 >= (operand_80).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_82 (operand_80)[@intCast(operand_81)];
                    };
                    const value_14: u32 = block_79: {
                        const operand_78 = @as(u64, 0);

                        break :block_79 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_78));
                    };

                    break :block_83 block_77: {
                        const operand_70 = (state_61).source;
                        const operand_71 = ((state_61).index + @as(u64, 1));

                        const operand_72 = (block_76: {
                            const operand_73 = (state_61).result;

                            const operand_75 = block_74: {
                                break :block_74 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_73).len, 1));

                            if ((!state_capacity_started_69)) {
                                (try (state_capacity_68).ensureTotalCapacityPrecise(allocator, ((operand_67).source).len));
                                (try (state_capacity_68).appendSlice(allocator, operand_73));

                                state_capacity_started_69 = true;
                            } else {
                                ((state_capacity_68).items).len = (operand_73).len;
                            }

                            (try (state_capacity_68).append(allocator, operand_75));

                            break :block_76 @as((zx_abi).value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_68).items, {}, null, });
                        }).@"0";

                        break :block_77 @as((zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_71, .result = operand_72, .source = operand_70, });
                    };
                };
            }

            var state_owned_84: []const u32 = (&[_]u32{});

            errdefer (allocator).free(state_owned_84);

            if (state_capacity_started_69) {
                ((state_capacity_68).items).len = ((state_61).result).len;
                state_owned_84 = (try (state_capacity_68).toOwnedSlice(allocator));
            }

            if (state_capacity_started_69) {
                state_61 = (zx_abi).value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_61).index, .result = state_owned_84, .source = (state_61).source, };
            }

            break :block_85 (state_61).result;
        };
    };

    return block_60: {
        const operand_57 = value_8;
        const operand_58 = value_16;
        const operand_59 = @as(u64, 0);

        break :block_60 (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .mapping = operand_57, .order = operand_58, .count = operand_59, };
    };
}

