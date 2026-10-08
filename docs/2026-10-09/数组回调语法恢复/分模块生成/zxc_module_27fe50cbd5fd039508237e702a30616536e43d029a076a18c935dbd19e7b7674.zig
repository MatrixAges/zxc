const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).modules).specifiers).len))) {
        return block_122: {
            const operand_113 = block_118: {
                const operand_114 = (in).state;
                const operand_115 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_118 block_117: {
                    const operand_116 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_116).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_114).count, .mapping = (operand_114).mapping, .order = (operand_114).order, .origins = (operand_114).origins, .status = operand_115, });

                    break :block_117 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_116);
                };
            };

            const operand_119 = (in).natives;

            break :block_122 block_121: {
                const operand_120 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_120).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_113, .natives = operand_119, });

                break :block_121 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_120);
            };
        };
    }

    if ((block_107: {
        const operand_105 = ((in).natives).mapping;
        const operand_106 = (in).index;

        if ((operand_106 >= (operand_105).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_107 (operand_105)[@intCast(operand_106)];
    } != @as(u64, 0))) {
        return block_112: {
            const operand_108 = (in).state;
            const operand_109 = (in).natives;

            break :block_112 block_111: {
                const operand_110 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_110).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_108, .natives = operand_109, });

                break :block_111 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_110);
            };
        };
    }

    const value_23: *const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_104: {
        const operand_19 = block_18: {
            const operand_7 = (in).request;
            const operand_8 = (in).state;
            const operand_9 = (in).natives;
            const operand_10 = (in).index;

            const operand_11 = block_14: {
                const operand_12 = ((in).modules).type_ids;
                const operand_13 = (in).index;

                if ((operand_13 >= (operand_12).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_14 (operand_12)[@intCast(operand_13)];
            };

            const operand_15 = @as(u64, 0);

            break :block_18 block_17: {
                const operand_16 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

                (operand_16).* = @as((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_7, .plan = operand_8, .natives = operand_9, .index = operand_10, .values = operand_11, .member = operand_15, });

                break :block_17 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_16);
            };
        };

        var state_items_21: []u64 = undefined;
        var state_items_started_22 = false;
        var state_items_23: []u32 = undefined;
        var state_items_started_24 = false;
        var state_capacity_25: (std).ArrayList(u64) = .empty;
        var state_capacity_started_26 = false;

        defer (state_capacity_25).deinit(allocator);

        var state_capacity_27: (std).ArrayList(u32) = .empty;
        var state_capacity_started_28 = false;

        defer (state_capacity_27).deinit(allocator);

        var state_capacity_29: (std).ArrayList(u64) = .empty;
        var state_capacity_started_30 = false;

        defer (state_capacity_29).deinit(allocator);

        var state_6: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_19).index, .member = (operand_19).member, .natives = (operand_19).natives, .plan = (operand_19).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_19).request).maximum_count, .names = ((operand_19).request).names, .origins = ((operand_19).request).origins, .roots = ((operand_19).request).roots, .scalar_count = ((operand_19).request).scalar_count, .table = ((operand_19).request).table, .zx_origin = (operand_19).request, }, .values = (operand_19).values, .zx_origin = operand_19, };
        var state_changed_20 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).member <= @as(u64, ((state_6).values).len)))) {
            state_6 = block_89: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_6).member < @as(u64, ((state_6).values).len))) block_49: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_6;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_48: {
                        break :block_48 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_47: {
                            const operand_46 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_46).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_45: {
                                const operand_42 = block_41: {
                                    const operand_33 = (state_6).request;
                                    const operand_34 = (state_6).plan;
                                    const operand_35 = block_40: {
                                        const operand_39 = block_38: {
                                            const operand_36 = (state_6).values;
                                            const operand_37 = (state_6).member;

                                            if ((operand_37 >= (operand_36).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_38 (operand_36)[@intCast(operand_37)];
                                        };

                                        break :block_40 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_39));
                                    };

                                    break :block_41 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_33, .state = operand_34, .index = operand_35, });
                                };

                                var state_borrow_43: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_43 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_42).request).maximum_count, .names = ((operand_42).request).names, .origins = ((operand_42).request).origins, .roots = ((operand_42).request).roots, .scalar_count = ((operand_42).request).scalar_count, .table = ((operand_42).request).table, };

                                var state_borrow_44: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_44 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_42).index, .request = (((operand_42).request).zx_origin orelse (&state_borrow_43)), .state = (operand_42).state, };

                                break :block_45 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_42).zx_origin orelse (&state_borrow_44)), .{ .lane_0 = .{ .buffer = (&state_capacity_25), .started = (&state_capacity_started_26), }, .lane_1 = .{ .buffer = (&state_capacity_27), .started = (&state_capacity_started_28), }, .lane_2 = .{ .buffer = (&state_capacity_29), .started = (&state_capacity_started_30), }, }));
                            });

                            break :block_47 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_46);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_49 value_4;
                } else block_88: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_6;
                    const value_6: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_5).natives;

                    const value_7: []const u64 = (block_87: {
                        break :block_87 value_6;
                    }).mapping;

                    const value_8: u64 = (state_6).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_86: {
                        break :block_86 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_85: {
                            break :block_85 block_84: {
                                const operand_83 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_83).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_74: {
                                    break :block_74 value_6;
                                }).count, .mapping = block_81: {
                                    const operand_76 = block_75: {
                                        break :block_75 value_7;
                                    };
                                    const operand_78 = block_77: {
                                        break :block_77 value_8;
                                    };

                                    if ((operand_78 >= (operand_76).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_79 = (((state_6).natives).count + @as(u64, 1));

                                    break :block_81 block_80: {
                                        if ((!state_items_started_22)) {
                                            state_items_21 = (try (allocator).dupe(u64, operand_76));
                                            state_items_started_22 = true;
                                        }

                                        (state_items_21)[@intCast(operand_78)] = operand_79;

                                        break :block_80 state_items_21;
                                    };
                                }, .order = (block_82: {
                                    break :block_82 value_6;
                                }).order, });

                                break :block_84 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_83);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_10).natives;

                    const value_12: []const u32 = (block_73: {
                        break :block_73 value_11;
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_72: {
                        break :block_72 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_71: {
                            break :block_71 block_70: {
                                const operand_69 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_69).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_58: {
                                    break :block_58 value_11;
                                }).count, .mapping = (block_59: {
                                    break :block_59 value_11;
                                }).mapping, .order = block_68: {
                                    const operand_61 = block_60: {
                                        break :block_60 value_12;
                                    };
                                    const operand_63 = block_62: {
                                        break :block_62 value_13;
                                    };

                                    if ((operand_63 >= (operand_61).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_66 = block_65: {
                                        const operand_64 = (value_9).index;

                                        break :block_65 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_64));
                                    };

                                    break :block_68 block_67: {
                                        if ((!state_items_started_24)) {
                                            state_items_23 = (try (allocator).dupe(u32, operand_61));
                                            state_items_started_24 = true;
                                        }

                                        (state_items_23)[@intCast(operand_63)] = operand_66;

                                        break :block_67 state_items_23;
                                    };
                                }, });

                                break :block_70 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_69);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_15).natives;

                    const value_17: u64 = (block_57: {
                        break :block_57 value_16;
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_56: {
                        break :block_56 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_55: {
                            break :block_55 block_54: {
                                const operand_53 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_53).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_50: {
                                    break :block_50 value_17;
                                } + @as(u64, 1)), .mapping = (block_51: {
                                    break :block_51 value_16;
                                }).mapping, .order = (block_52: {
                                    break :block_52 value_16;
                                }).order, });

                                break :block_54 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_53);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_88 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_32: {
                    break :block_32 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_31: {
                        break :block_31 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_89 value_22;
            };

            state_changed_20 = true;
        }

        var state_owned_90: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_90);

        if (state_capacity_started_26) {
            ((state_capacity_25).items).len = (((state_6).plan).mapping).len;
            state_owned_90 = (try (state_capacity_25).toOwnedSlice(allocator));
        }

        if (state_capacity_started_26) {
            state_6 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_6).index, .member = (state_6).member, .natives = (state_6).natives, .plan = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_91).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = state_owned_90, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_92 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_91);
            }, .request = (state_6).request, .values = (state_6).values, };
        }

        var state_owned_93: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_28) {
            ((state_capacity_27).items).len = (((state_6).plan).order).len;
            state_owned_93 = (try (state_capacity_27).toOwnedSlice(allocator));
        }

        if (state_capacity_started_28) {
            state_6 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_6).index, .member = (state_6).member, .natives = (state_6).natives, .plan = block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_94).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = state_owned_93, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_95 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_94);
            }, .request = (state_6).request, .values = (state_6).values, };
        }

        var state_owned_96: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_96);

        if (state_capacity_started_30) {
            ((state_capacity_29).items).len = (((state_6).plan).origins).len;
            state_owned_96 = (try (state_capacity_29).toOwnedSlice(allocator));
        }

        if (state_capacity_started_30) {
            state_6 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_6).index, .member = (state_6).member, .natives = (state_6).natives, .plan = block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_97).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = state_owned_96, .status = ((state_6).plan).status, });

                break :block_98 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_97);
            }, .request = (state_6).request, .values = (state_6).values, };
        }

        break :block_104 (if (state_changed_20) block_103: {
            break :block_103 (if (((state_6).zx_origin != null)) (state_6).zx_origin.? else block_102: {
                const operand_101 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

                (operand_101).* = (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_6).index, .member = (state_6).member, .natives = (state_6).natives, .plan = (state_6).plan, .request = (if ((((state_6).request).zx_origin != null)) ((state_6).request).zx_origin.? else block_100: {
                    const operand_99 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_99).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = ((state_6).request).origins, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = ((state_6).request).table, };

                    break :block_100 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_99);
                }), .values = (state_6).values, };

                break :block_102 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_101);
            });
        } else operand_19);
    };

    return block_5: {
        const operand_1 = (value_23).plan;
        const operand_2 = (value_23).natives;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_3).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_1, .natives = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_3);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).modules).specifiers).len))) {
        return block_234: {
            const operand_227 = block_232: {
                const operand_228 = (in).state;
                const operand_229 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_232 block_231: {
                    const operand_230 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_230).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_228).count, .mapping = (operand_228).mapping, .order = (operand_228).order, .origins = (operand_228).origins, .status = operand_229, });

                    break :block_231 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_230);
                };
            };

            const operand_233 = (in).natives;

            break :block_234 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_227, .natives = operand_233, };
        };
    }

    if ((block_223: {
        const operand_221 = ((in).natives).mapping;
        const operand_222 = (in).index;

        if ((operand_222 >= (operand_221).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_223 (operand_221)[@intCast(operand_222)];
    } != @as(u64, 0))) {
        return block_226: {
            const operand_224 = (in).state;
            const operand_225 = (in).natives;

            break :block_226 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_224, .natives = operand_225, };
        };
    }

    const value_23: (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_220: {
        const operand_137 = block_136: {
            const operand_127 = (in).request;
            const operand_128 = (in).state;
            const operand_129 = (in).natives;
            const operand_130 = (in).index;

            const operand_131 = block_134: {
                const operand_132 = ((in).modules).type_ids;
                const operand_133 = (in).index;

                if ((operand_133 >= (operand_132).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_134 (operand_132)[@intCast(operand_133)];
            };

            const operand_135 = @as(u64, 0);

            break :block_136 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_127, .plan = operand_128, .natives = operand_129, .index = operand_130, .values = operand_131, .member = operand_135, };
        };

        var state_items_138: []u64 = undefined;
        var state_items_started_139 = false;
        var state_items_140: []u32 = undefined;
        var state_items_started_141 = false;
        var state_capacity_142: (std).ArrayList(u64) = .empty;
        var state_capacity_started_143 = false;

        defer (state_capacity_142).deinit(allocator);

        var state_capacity_144: (std).ArrayList(u32) = .empty;
        var state_capacity_started_145 = false;

        defer (state_capacity_144).deinit(allocator);

        var state_capacity_146: (std).ArrayList(u64) = .empty;
        var state_capacity_started_147 = false;

        defer (state_capacity_146).deinit(allocator);

        var state_126: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_137).index, .member = (operand_137).member, .natives = (operand_137).natives, .plan = (operand_137).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_137).request).maximum_count, .names = ((operand_137).request).names, .origins = ((operand_137).request).origins, .roots = ((operand_137).request).roots, .scalar_count = ((operand_137).request).scalar_count, .table = ((operand_137).request).table, .zx_origin = (operand_137).request, }, .values = (operand_137).values, .zx_origin = (&operand_137), };

        while (((((state_126).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_126).member <= @as(u64, ((state_126).values).len)))) {
            state_126 = block_206: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_126).member < @as(u64, ((state_126).values).len))) block_166: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_126;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_165: {
                        break :block_165 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_164: {
                            const operand_163 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_163).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_162: {
                                const operand_159 = block_158: {
                                    const operand_150 = (state_126).request;
                                    const operand_151 = (state_126).plan;
                                    const operand_152 = block_157: {
                                        const operand_156 = block_155: {
                                            const operand_153 = (state_126).values;
                                            const operand_154 = (state_126).member;

                                            if ((operand_154 >= (operand_153).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_155 (operand_153)[@intCast(operand_154)];
                                        };

                                        break :block_157 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_156));
                                    };

                                    break :block_158 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_150, .state = operand_151, .index = operand_152, });
                                };
                                var state_borrow_160: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_160 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_159).request).maximum_count, .names = ((operand_159).request).names, .origins = ((operand_159).request).origins, .roots = ((operand_159).request).roots, .scalar_count = ((operand_159).request).scalar_count, .table = ((operand_159).request).table, };

                                var state_borrow_161: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_161 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_159).index, .request = (((operand_159).request).zx_origin orelse (&state_borrow_160)), .state = (operand_159).state, };

                                break :block_162 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_159).zx_origin orelse (&state_borrow_161)), .{ .lane_0 = .{ .buffer = (&state_capacity_142), .started = (&state_capacity_started_143), }, .lane_1 = .{ .buffer = (&state_capacity_144), .started = (&state_capacity_started_145), }, .lane_2 = .{ .buffer = (&state_capacity_146), .started = (&state_capacity_started_147), }, }));
                            });

                            break :block_164 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_163);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_166 value_4;
                } else block_205: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_126;
                    const value_6: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_5).natives).*;

                    const value_7: []const u64 = (block_204: {
                        break :block_204 (&value_6);
                    }).mapping;

                    const value_8: u64 = (state_126).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_203: {
                        break :block_203 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_202: {
                            break :block_202 block_201: {
                                const operand_200 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_200).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_191: {
                                    break :block_191 (&value_6);
                                }).count, .mapping = block_198: {
                                    const operand_193 = block_192: {
                                        break :block_192 value_7;
                                    };
                                    const operand_195 = block_194: {
                                        break :block_194 value_8;
                                    };

                                    if ((operand_195 >= (operand_193).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_196 = (((state_126).natives).count + @as(u64, 1));

                                    break :block_198 block_197: {
                                        if ((!state_items_started_139)) {
                                            state_items_138 = (try (allocator).dupe(u64, operand_193));
                                            state_items_started_139 = true;
                                        }

                                        (state_items_138)[@intCast(operand_195)] = operand_196;

                                        break :block_197 state_items_138;
                                    };
                                }, .order = (block_199: {
                                    break :block_199 (&value_6);
                                }).order, });

                                break :block_201 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_200);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_10).natives).*;

                    const value_12: []const u32 = (block_190: {
                        break :block_190 (&value_11);
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_189: {
                        break :block_189 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_188: {
                            break :block_188 block_187: {
                                const operand_186 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_186).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_175: {
                                    break :block_175 (&value_11);
                                }).count, .mapping = (block_176: {
                                    break :block_176 (&value_11);
                                }).mapping, .order = block_185: {
                                    const operand_178 = block_177: {
                                        break :block_177 value_12;
                                    };
                                    const operand_180 = block_179: {
                                        break :block_179 value_13;
                                    };

                                    if ((operand_180 >= (operand_178).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_183 = block_182: {
                                        const operand_181 = (value_9).index;

                                        break :block_182 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_181));
                                    };
                                    break :block_185 block_184: {
                                        if ((!state_items_started_141)) {
                                            state_items_140 = (try (allocator).dupe(u32, operand_178));
                                            state_items_started_141 = true;
                                        }

                                        (state_items_140)[@intCast(operand_180)] = operand_183;

                                        break :block_184 state_items_140;
                                    };
                                }, });

                                break :block_187 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_186);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_15).natives).*;

                    const value_17: u64 = (block_174: {
                        break :block_174 (&value_16);
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_173: {
                        break :block_173 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_172: {
                            break :block_172 block_171: {
                                const operand_170 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_170).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_167: {
                                    break :block_167 value_17;
                                } + @as(u64, 1)), .mapping = (block_168: {
                                    break :block_168 (&value_16);
                                }).mapping, .order = (block_169: {
                                    break :block_169 (&value_16);
                                }).order, });

                                break :block_171 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_170);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_205 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_149: {
                    break :block_149 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_148: {
                        break :block_148 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_206 value_22;
            };
        }

        var state_owned_207: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_207);

        if (state_capacity_started_143) {
            ((state_capacity_142).items).len = (((state_126).plan).mapping).len;
            state_owned_207 = (try (state_capacity_142).toOwnedSlice(allocator));
        }

        if (state_capacity_started_143) {
            state_126 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_126).index, .member = (state_126).member, .natives = (state_126).natives, .plan = block_209: {
                const operand_208 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_208).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_126).plan).count, .mapping = state_owned_207, .order = ((state_126).plan).order, .origins = ((state_126).plan).origins, .status = ((state_126).plan).status, });

                break :block_209 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_208);
            }, .request = (state_126).request, .values = (state_126).values, };
        }

        var state_owned_210: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_210);

        if (state_capacity_started_145) {
            ((state_capacity_144).items).len = (((state_126).plan).order).len;
            state_owned_210 = (try (state_capacity_144).toOwnedSlice(allocator));
        }

        if (state_capacity_started_145) {
            state_126 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_126).index, .member = (state_126).member, .natives = (state_126).natives, .plan = block_212: {
                const operand_211 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_211).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_126).plan).count, .mapping = ((state_126).plan).mapping, .order = state_owned_210, .origins = ((state_126).plan).origins, .status = ((state_126).plan).status, });

                break :block_212 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_211);
            }, .request = (state_126).request, .values = (state_126).values, };
        }

        var state_owned_213: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_213);

        if (state_capacity_started_147) {
            ((state_capacity_146).items).len = (((state_126).plan).origins).len;
            state_owned_213 = (try (state_capacity_146).toOwnedSlice(allocator));
        }

        if (state_capacity_started_147) {
            state_126 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_126).index, .member = (state_126).member, .natives = (state_126).natives, .plan = block_215: {
                const operand_214 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_214).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_126).plan).count, .mapping = ((state_126).plan).mapping, .order = ((state_126).plan).order, .origins = state_owned_213, .status = ((state_126).plan).status, });

                break :block_215 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_214);
            }, .request = (state_126).request, .values = (state_126).values, };
        }

        break :block_220 block_219: {
            break :block_219 (if (((state_126).zx_origin != null)) ((state_126).zx_origin.?).* else block_218: {
                break :block_218 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_126).index, .member = (state_126).member, .natives = (state_126).natives, .plan = (state_126).plan, .request = (if ((((state_126).request).zx_origin != null)) ((state_126).request).zx_origin.? else block_217: {
                    const operand_216 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_216).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_126).request).maximum_count, .names = ((state_126).request).names, .origins = ((state_126).request).origins, .roots = ((state_126).request).roots, .scalar_count = ((state_126).request).scalar_count, .table = ((state_126).request).table, };

                    break :block_217 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_216);
                }), .values = (state_126).values, };
            });
        };
    };

    return block_125: {
        const operand_123 = ((&value_23)).plan;
        const operand_124 = ((&value_23)).natives;

        break :block_125 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_123, .natives = operand_124, };
    };
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).modules).specifiers).len))) {
        return block_339: {
            const operand_332 = block_337: {
                const operand_333 = (in).state;
                const operand_334 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_337 block_336: {
                    const operand_335 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_335).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_333).count, .mapping = (operand_333).mapping, .order = (operand_333).order, .origins = (operand_333).origins, .status = operand_334, });

                    break :block_336 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_335);
                };
            };

            const operand_338 = (in).natives;

            break :block_339 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_332, .natives = operand_338, };
        };
    }

    if ((block_328: {
        const operand_326 = ((in).natives).mapping;
        const operand_327 = (in).index;

        if ((operand_327 >= (operand_326).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_328 (operand_326)[@intCast(operand_327)];
    } != @as(u64, 0))) {
        return block_331: {
            const operand_329 = (in).state;
            const operand_330 = (in).natives;

            break :block_331 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_329, .natives = operand_330, };
        };
    }

    const value_23: (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_325: {
        const operand_249 = block_248: {
            const operand_239 = (in).request;
            const operand_240 = (in).state;
            const operand_241 = (in).natives;
            const operand_242 = (in).index;

            const operand_243 = block_246: {
                const operand_244 = ((in).modules).type_ids;
                const operand_245 = (in).index;

                if ((operand_245 >= (operand_244).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_246 (operand_244)[@intCast(operand_245)];
            };

            const operand_247 = @as(u64, 0);

            break :block_248 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_239, .plan = operand_240, .natives = operand_241, .index = operand_242, .values = operand_243, .member = operand_247, };
        };

        var state_capacity_250: (std).ArrayList(u64) = .empty;
        var state_capacity_started_251 = false;

        defer (state_capacity_250).deinit(allocator);

        var state_capacity_252: (std).ArrayList(u32) = .empty;
        var state_capacity_started_253 = false;

        defer (state_capacity_252).deinit(allocator);

        var state_238: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_249).index, .member = (operand_249).member, .natives = (operand_249).natives, .plan = (operand_249).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_249).request).maximum_count, .names = ((operand_249).request).names, .origins = ((operand_249).request).origins, .roots = ((operand_249).request).roots, .scalar_count = ((operand_249).request).scalar_count, .table = ((operand_249).request).table, .zx_origin = (operand_249).request, }, .values = (operand_249).values, .zx_origin = (&operand_249), };

        while (((((state_238).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_238).member <= @as(u64, ((state_238).values).len)))) {
            state_238 = block_314: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_238).member < @as(u64, ((state_238).values).len))) block_272: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_238;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_271: {
                        break :block_271 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_270: {
                            const operand_269 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_269).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_268: {
                                const operand_265 = block_264: {
                                    const operand_256 = (state_238).request;
                                    const operand_257 = (state_238).plan;
                                    const operand_258 = block_263: {
                                        const operand_262 = block_261: {
                                            const operand_259 = (state_238).values;
                                            const operand_260 = (state_238).member;

                                            if ((operand_260 >= (operand_259).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_261 (operand_259)[@intCast(operand_260)];
                                        };

                                        break :block_263 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_262));
                                    };

                                    break :block_264 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_256, .state = operand_257, .index = operand_258, });
                                };

                                var state_borrow_266: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_266 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_265).request).maximum_count, .names = ((operand_265).request).names, .origins = ((operand_265).request).origins, .roots = ((operand_265).request).roots, .scalar_count = ((operand_265).request).scalar_count, .table = ((operand_265).request).table, };

                                var state_borrow_267: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_267 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_265).index, .request = (((operand_265).request).zx_origin orelse (&state_borrow_266)), .state = (operand_265).state, };

                                break :block_268 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_265).zx_origin orelse (&state_borrow_267)), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_270 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_269);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_272 value_4;
                } else block_313: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_238;
                    const value_6: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_5).natives).*;

                    const value_7: []const u64 = (block_312: {
                        break :block_312 (&value_6);
                    }).mapping;

                    const value_8: u64 = (state_238).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_311: {
                        break :block_311 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_310: {
                            break :block_310 block_309: {
                                const operand_308 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_308).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_298: {
                                    break :block_298 (&value_6);
                                }).count, .mapping = block_306: {
                                    const operand_300 = block_299: {
                                        break :block_299 value_7;
                                    };
                                    const operand_302 = block_301: {
                                        break :block_301 value_8;
                                    };

                                    if ((operand_302 >= (operand_300).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_303 = (((state_238).natives).count + @as(u64, 1));

                                    break :block_306 @as([]const u64, (if (((buffers).lane_0 != null)) block_304: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_300));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_300).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_302)] = operand_303;

                                        break :block_304 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_305: {
                                        if ((!state_capacity_started_251)) {
                                            (try (state_capacity_250).appendSlice(allocator, operand_300));

                                            state_capacity_started_251 = true;
                                        } else {
                                            ((state_capacity_250).items).len = (operand_300).len;
                                        }

                                        ((state_capacity_250).items)[@intCast(operand_302)] = operand_303;

                                        break :block_305 (state_capacity_250).items;
                                    }));
                                }, .order = (block_307: {
                                    break :block_307 (&value_6);
                                }).order, });

                                break :block_309 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_308);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_10).natives).*;

                    const value_12: []const u32 = (block_297: {
                        break :block_297 (&value_11);
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_296: {
                        break :block_296 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_295: {
                            break :block_295 block_294: {
                                const operand_293 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_293).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_281: {
                                    break :block_281 (&value_11);
                                }).count, .mapping = (block_282: {
                                    break :block_282 (&value_11);
                                }).mapping, .order = block_292: {
                                    const operand_284 = block_283: {
                                        break :block_283 value_12;
                                    };
                                    const operand_286 = block_285: {
                                        break :block_285 value_13;
                                    };

                                    if ((operand_286 >= (operand_284).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_289 = block_288: {
                                        const operand_287 = (value_9).index;

                                        break :block_288 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_287));
                                    };

                                    break :block_292 @as([]const u32, (if (((buffers).lane_1 != null)) block_290: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_284));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_284).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_286)] = operand_289;

                                        break :block_290 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_291: {
                                        if ((!state_capacity_started_253)) {
                                            (try (state_capacity_252).appendSlice(allocator, operand_284));

                                            state_capacity_started_253 = true;
                                        } else {
                                            ((state_capacity_252).items).len = (operand_284).len;
                                        }

                                        ((state_capacity_252).items)[@intCast(operand_286)] = operand_289;

                                        break :block_291 (state_capacity_252).items;
                                    }));
                                }, });

                                break :block_294 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_293);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_15).natives).*;

                    const value_17: u64 = (block_280: {
                        break :block_280 (&value_16);
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_279: {
                        break :block_279 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_278: {
                            break :block_278 block_277: {
                                const operand_276 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_276).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_273: {
                                    break :block_273 value_17;
                                } + @as(u64, 1)), .mapping = (block_274: {
                                    break :block_274 (&value_16);
                                }).mapping, .order = (block_275: {
                                    break :block_275 (&value_16);
                                }).order, });

                                break :block_277 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_276);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_313 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_255: {
                    break :block_255 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_254: {
                        break :block_254 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_314 value_22;
            };
        }

        var state_owned_315: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_315);

        if (state_capacity_started_251) {
            ((state_capacity_250).items).len = (((state_238).natives).mapping).len;
            state_owned_315 = (try (state_capacity_250).toOwnedSlice(allocator));
        }

        if (state_capacity_started_251) {
            state_238 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_238).index, .member = (state_238).member, .natives = block_317: {
                const operand_316 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_316).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_238).natives).count, .mapping = state_owned_315, .order = ((state_238).natives).order, });

                break :block_317 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_316);
            }, .plan = (state_238).plan, .request = (state_238).request, .values = (state_238).values, };
        }

        var state_owned_318: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_318);

        if (state_capacity_started_253) {
            ((state_capacity_252).items).len = (((state_238).natives).order).len;
            state_owned_318 = (try (state_capacity_252).toOwnedSlice(allocator));
        }

        if (state_capacity_started_253) {
            state_238 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_238).index, .member = (state_238).member, .natives = block_320: {
                const operand_319 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_319).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_238).natives).count, .mapping = ((state_238).natives).mapping, .order = state_owned_318, });

                break :block_320 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_319);
            }, .plan = (state_238).plan, .request = (state_238).request, .values = (state_238).values, };
        }

        break :block_325 block_324: {
            break :block_324 (if (((state_238).zx_origin != null)) ((state_238).zx_origin.?).* else block_323: {
                break :block_323 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_238).index, .member = (state_238).member, .natives = (state_238).natives, .plan = (state_238).plan, .request = (if ((((state_238).request).zx_origin != null)) ((state_238).request).zx_origin.? else block_322: {
                    const operand_321 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_321).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_238).request).maximum_count, .names = ((state_238).request).names, .origins = ((state_238).request).origins, .roots = ((state_238).request).roots, .scalar_count = ((state_238).request).scalar_count, .table = ((state_238).request).table, };

                    break :block_322 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_321);
                }), .values = (state_238).values, };
            });
        };
    };

    return block_237: {
        const operand_235 = ((&value_23)).plan;
        const operand_236 = ((&value_23)).natives;

        break :block_237 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_235, .natives = operand_236, };
    };
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).modules).specifiers).len))) {
        return block_454: {
            const operand_445 = block_450: {
                const operand_446 = (in).state;
                const operand_447 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_450 block_449: {
                    const operand_448 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_448).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_446).count, .mapping = (operand_446).mapping, .order = (operand_446).order, .origins = (operand_446).origins, .status = operand_447, });

                    break :block_449 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_448);
                };
            };

            const operand_451 = (in).natives;

            break :block_454 block_453: {
                const operand_452 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_452).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_445, .natives = operand_451, });

                break :block_453 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_452);
            };
        };
    }

    if ((block_439: {
        const operand_437 = ((in).natives).mapping;
        const operand_438 = (in).index;

        if ((operand_438 >= (operand_437).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_439 (operand_437)[@intCast(operand_438)];
    } != @as(u64, 0))) {
        return block_444: {
            const operand_440 = (in).state;
            const operand_441 = (in).natives;

            break :block_444 block_443: {
                const operand_442 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_442).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_440, .natives = operand_441, });

                break :block_443 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_442);
            };
        };
    }

    const value_23: *const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_436: {
        const operand_358 = block_357: {
            const operand_346 = (in).request;
            const operand_347 = (in).state;
            const operand_348 = (in).natives;
            const operand_349 = (in).index;

            const operand_350 = block_353: {
                const operand_351 = ((in).modules).type_ids;
                const operand_352 = (in).index;

                if ((operand_352 >= (operand_351).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_353 (operand_351)[@intCast(operand_352)];
            };

            const operand_354 = @as(u64, 0);

            break :block_357 block_356: {
                const operand_355 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

                (operand_355).* = @as((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_346, .plan = operand_347, .natives = operand_348, .index = operand_349, .values = operand_350, .member = operand_354, });

                break :block_356 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_355);
            };
        };

        var state_capacity_360: (std).ArrayList(u64) = .empty;
        var state_capacity_started_361 = false;

        defer (state_capacity_360).deinit(allocator);

        var state_capacity_362: (std).ArrayList(u32) = .empty;
        var state_capacity_started_363 = false;

        defer (state_capacity_362).deinit(allocator);

        var state_345: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_358).index, .member = (operand_358).member, .natives = (operand_358).natives, .plan = (operand_358).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_358).request).maximum_count, .names = ((operand_358).request).names, .origins = ((operand_358).request).origins, .roots = ((operand_358).request).roots, .scalar_count = ((operand_358).request).scalar_count, .table = ((operand_358).request).table, .zx_origin = (operand_358).request, }, .values = (operand_358).values, .zx_origin = operand_358, };
        var state_changed_359 = false;

        while (((((state_345).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_345).member <= @as(u64, ((state_345).values).len)))) {
            state_345 = block_424: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_345).member < @as(u64, ((state_345).values).len))) block_382: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_345;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_381: {
                        break :block_381 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_380: {
                            const operand_379 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_379).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_378: {
                                const operand_375 = block_374: {
                                    const operand_366 = (state_345).request;
                                    const operand_367 = (state_345).plan;
                                    const operand_368 = block_373: {
                                        const operand_372 = block_371: {
                                            const operand_369 = (state_345).values;
                                            const operand_370 = (state_345).member;

                                            if ((operand_370 >= (operand_369).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_371 (operand_369)[@intCast(operand_370)];
                                        };

                                        break :block_373 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_372));
                                    };

                                    break :block_374 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_366, .state = operand_367, .index = operand_368, });
                                };

                                var state_borrow_376: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_376 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_375).request).maximum_count, .names = ((operand_375).request).names, .origins = ((operand_375).request).origins, .roots = ((operand_375).request).roots, .scalar_count = ((operand_375).request).scalar_count, .table = ((operand_375).request).table, };

                                var state_borrow_377: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_377 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_375).index, .request = (((operand_375).request).zx_origin orelse (&state_borrow_376)), .state = (operand_375).state, };

                                break :block_378 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_375).zx_origin orelse (&state_borrow_377)), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_380 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_379);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_382 value_4;
                } else block_423: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_345;
                    const value_6: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_5).natives;

                    const value_7: []const u64 = (block_422: {
                        break :block_422 value_6;
                    }).mapping;

                    const value_8: u64 = (state_345).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_421: {
                        break :block_421 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_420: {
                            break :block_420 block_419: {
                                const operand_418 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_418).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_408: {
                                    break :block_408 value_6;
                                }).count, .mapping = block_416: {
                                    const operand_410 = block_409: {
                                        break :block_409 value_7;
                                    };
                                    const operand_412 = block_411: {
                                        break :block_411 value_8;
                                    };

                                    if ((operand_412 >= (operand_410).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_413 = (((state_345).natives).count + @as(u64, 1));

                                    break :block_416 @as([]const u64, (if (((buffers).lane_0 != null)) block_414: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_410));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_410).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_412)] = operand_413;

                                        break :block_414 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_415: {
                                        if ((!state_capacity_started_361)) {
                                            (try (state_capacity_360).appendSlice(allocator, operand_410));

                                            state_capacity_started_361 = true;
                                        } else {
                                            ((state_capacity_360).items).len = (operand_410).len;
                                        }

                                        ((state_capacity_360).items)[@intCast(operand_412)] = operand_413;
                                        break :block_415 (state_capacity_360).items;
                                    }));
                                }, .order = (block_417: {
                                    break :block_417 value_6;
                                }).order, });

                                break :block_419 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_418);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_10).natives;

                    const value_12: []const u32 = (block_407: {
                        break :block_407 value_11;
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_406: {
                        break :block_406 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_405: {
                            break :block_405 block_404: {
                                const operand_403 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_403).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_391: {
                                    break :block_391 value_11;
                                }).count, .mapping = (block_392: {
                                    break :block_392 value_11;
                                }).mapping, .order = block_402: {
                                    const operand_394 = block_393: {
                                        break :block_393 value_12;
                                    };
                                    const operand_396 = block_395: {
                                        break :block_395 value_13;
                                    };

                                    if ((operand_396 >= (operand_394).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_399 = block_398: {
                                        const operand_397 = (value_9).index;

                                        break :block_398 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_397));
                                    };

                                    break :block_402 @as([]const u32, (if (((buffers).lane_1 != null)) block_400: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_394));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_394).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_396)] = operand_399;

                                        break :block_400 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_401: {
                                        if ((!state_capacity_started_363)) {
                                            (try (state_capacity_362).appendSlice(allocator, operand_394));

                                            state_capacity_started_363 = true;
                                        } else {
                                            ((state_capacity_362).items).len = (operand_394).len;
                                        }

                                        ((state_capacity_362).items)[@intCast(operand_396)] = operand_399;
                                        break :block_401 (state_capacity_362).items;
                                    }));
                                }, });

                                break :block_404 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_403);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (value_15).natives;

                    const value_17: u64 = (block_390: {
                        break :block_390 value_16;
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_389: {
                        break :block_389 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_388: {
                            break :block_388 block_387: {
                                const operand_386 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_386).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_383: {
                                    break :block_383 value_17;
                                } + @as(u64, 1)), .mapping = (block_384: {
                                    break :block_384 value_16;
                                }).mapping, .order = (block_385: {
                                    break :block_385 value_16;
                                }).order, });

                                break :block_387 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_386);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_423 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_365: {
                    break :block_365 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_364: {
                        break :block_364 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_424 value_22;
            };

            state_changed_359 = true;
        }

        var state_owned_425: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_425);

        if (state_capacity_started_361) {
            ((state_capacity_360).items).len = (((state_345).natives).mapping).len;
            state_owned_425 = (try (state_capacity_360).toOwnedSlice(allocator));
        }

        if (state_capacity_started_361) {
            state_345 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_345).index, .member = (state_345).member, .natives = block_427: {
                const operand_426 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_426).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_345).natives).count, .mapping = state_owned_425, .order = ((state_345).natives).order, });

                break :block_427 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_426);
            }, .plan = (state_345).plan, .request = (state_345).request, .values = (state_345).values, };
        }

        var state_owned_428: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_428);

        if (state_capacity_started_363) {
            ((state_capacity_362).items).len = (((state_345).natives).order).len;
            state_owned_428 = (try (state_capacity_362).toOwnedSlice(allocator));
        }

        if (state_capacity_started_363) {
            state_345 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_345).index, .member = (state_345).member, .natives = block_430: {
                const operand_429 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_429).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_345).natives).count, .mapping = ((state_345).natives).mapping, .order = state_owned_428, });

                break :block_430 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_429);
            }, .plan = (state_345).plan, .request = (state_345).request, .values = (state_345).values, };
        }

        break :block_436 (if (state_changed_359) block_435: {
            break :block_435 (if (((state_345).zx_origin != null)) (state_345).zx_origin.? else block_434: {
                const operand_433 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

                (operand_433).* = (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_345).index, .member = (state_345).member, .natives = (state_345).natives, .plan = (state_345).plan, .request = (if ((((state_345).request).zx_origin != null)) ((state_345).request).zx_origin.? else block_432: {
                    const operand_431 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_431).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_345).request).maximum_count, .names = ((state_345).request).names, .origins = ((state_345).request).origins, .roots = ((state_345).request).roots, .scalar_count = ((state_345).request).scalar_count, .table = ((state_345).request).table, };

                    break :block_432 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_431);
                }), .values = (state_345).values, };

                break :block_434 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_433);
            });
        } else operand_358);
    };

    return block_344: {
        const operand_340 = (value_23).plan;
        const operand_341 = (value_23).natives;

        break :block_344 block_343: {
            const operand_342 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_342).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_340, .natives = operand_341, });

            break :block_343 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_342);
        };
    };
}

