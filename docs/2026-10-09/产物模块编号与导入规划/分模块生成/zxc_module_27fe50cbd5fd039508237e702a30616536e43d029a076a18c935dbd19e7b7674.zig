const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).modules).specifiers).len))) {
        return block_109: {
            const operand_100 = block_105: {
                const operand_101 = (in).state;
                const operand_102 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_105 block_104: {
                    const operand_103 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_103).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_101).count, .mapping = (operand_101).mapping, .order = (operand_101).order, .origins = (operand_101).origins, .status = operand_102, });

                    break :block_104 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_103);
                };
            };

            const operand_106 = (in).natives;

            break :block_109 block_108: {
                const operand_107 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_107).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_100, .natives = operand_106, });

                break :block_108 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_107);
            };
        };
    }

    if ((block_94: {
        const operand_92 = ((in).natives).mapping;
        const operand_93 = (in).index;

        if ((operand_93 >= (operand_92).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_94 (operand_92)[@intCast(operand_93)];
    } != @as(u64, 0))) {
        return block_99: {
            const operand_95 = (in).state;
            const operand_96 = (in).natives;

            break :block_99 block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_97).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_95, .natives = operand_96, });

                break :block_98 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_97);
            };
        };
    }

    const value_23: *const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_91: {
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

        const state_type_31 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_32 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_33 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_34 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_35 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_33,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_34,
        };
        const state_type_36 = struct {
            index: u64,
            member: u64,
            natives: state_type_31,
            plan: state_type_32,
            request: state_type_35,
            values: []const u32,
        };
        const state_type_38 = struct {
            index: u64,
            request: state_type_35,
            state: state_type_32,
        };

        var state_6: state_type_36 = state_type_36{ .index = (operand_19).index, .member = (operand_19).member, .natives = state_type_31{ .count = ((operand_19).natives).count, .mapping = ((operand_19).natives).mapping, .order = ((operand_19).natives).order, }, .plan = state_type_32{ .count = ((operand_19).plan).count, .mapping = ((operand_19).plan).mapping, .order = ((operand_19).plan).order, .origins = ((operand_19).plan).origins, .status = ((operand_19).plan).status, }, .request = state_type_35{ .maximum_count = ((operand_19).request).maximum_count, .names = ((operand_19).request).names, .origins = state_type_33{ .ids = (((operand_19).request).origins).ids, .kinds = (((operand_19).request).origins).kinds, .members = (((operand_19).request).origins).members, .owners = (((operand_19).request).origins).owners, }, .roots = ((operand_19).request).roots, .scalar_count = ((operand_19).request).scalar_count, .table = state_type_34{ .children = (((operand_19).request).table).children, .field_names = (((operand_19).request).table).field_names, .field_types = (((operand_19).request).table).field_types, .first = (((operand_19).request).table).first, .kinds = (((operand_19).request).table).kinds, .labels = (((operand_19).request).table).labels, .names = (((operand_19).request).table).names, .second = (((operand_19).request).table).second, }, }, .values = (operand_19).values, };
        var state_changed_20 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).member <= @as(u64, ((state_6).values).len)))) {
            state_6 = block_74: {
                const value_19: state_type_36 = (if (((state_6).member < @as(u64, ((state_6).values).len))) block_56: {
                    const value_3: state_type_36 = state_6;
                    const value_4: state_type_36 = block_55: {
                        break :block_55 state_type_36{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_54: {
                            const operand_46 = block_45: {
                                const operand_39 = (state_6).request;
                                const operand_40 = (state_6).plan;

                                const operand_44 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_43: {
                                    const operand_41 = (state_6).values;
                                    const operand_42 = (state_6).member;

                                    if ((operand_42 >= (operand_41).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_43 (operand_41)[@intCast(operand_42)];
                                }));

                                break :block_45 state_type_38{ .request = operand_39, .state = operand_40, .index = operand_44, };
                            };

                            const operand_47 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_46).request).origins).ids, .kinds = (((operand_46).request).origins).kinds, .members = (((operand_46).request).origins).members, .owners = (((operand_46).request).origins).owners, };
                            const operand_48 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_46).request).table).children, .field_names = (((operand_46).request).table).field_names, .field_types = (((operand_46).request).table).field_types, .first = (((operand_46).request).table).first, .kinds = (((operand_46).request).table).kinds, .labels = (((operand_46).request).table).labels, .names = (((operand_46).request).table).names, .second = (((operand_46).request).table).second, };
                            const operand_49 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_46).request).maximum_count, .names = ((operand_46).request).names, .origins = (&operand_47), .roots = ((operand_46).request).roots, .scalar_count = ((operand_46).request).scalar_count, .table = (&operand_48), };
                            const operand_50 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_46).state).count, .mapping = ((operand_46).state).mapping, .order = ((operand_46).state).order, .origins = ((operand_46).state).origins, .status = ((operand_46).state).status, };
                            const operand_51 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_46).index, .request = (&operand_49), .state = (&operand_50), };

                            const operand_53 = block_52: {
                                break :block_52 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_51), .{ .lane_0 = .{ .buffer = (&state_capacity_25), .started = (&state_capacity_started_26), }, .lane_1 = .{ .buffer = (&state_capacity_27), .started = (&state_capacity_started_28), }, .lane_2 = .{ .buffer = (&state_capacity_29), .started = (&state_capacity_started_30), }, }));
                            };

                            break :block_54 state_type_32{ .count = (operand_53).count, .mapping = (operand_53).mapping, .order = (operand_53).order, .origins = (operand_53).origins, .status = (operand_53).status, };
                        }, .request = (value_3).request, .values = (value_3).values, };
                    };

                    break :block_56 value_4;
                } else block_73: {
                    const value_5: state_type_36 = state_6;
                    const value_6: state_type_31 = (value_5).natives;
                    const value_7: []const u64 = (value_6).mapping;
                    const value_8: u64 = (state_6).index;
                    const value_9: state_type_36 = block_72: {
                        break :block_72 state_type_36{ .index = (value_5).index, .member = (value_5).member, .natives = block_71: {
                            break :block_71 state_type_31{ .count = (value_6).count, .mapping = block_70: {
                                const operand_66 = value_7;
                                const operand_67 = value_8;

                                if ((operand_67 >= (operand_66).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_68 = (((state_6).natives).count + @as(u64, 1));

                                break :block_70 block_69: {
                                    if ((!state_items_started_22)) {
                                        state_items_21 = (try (allocator).dupe(u64, operand_66));
                                        state_items_started_22 = true;
                                    }

                                    (state_items_21)[@intCast(operand_67)] = operand_68;

                                    break :block_69 state_items_21;
                                };
                            }, .order = (value_6).order, };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, };
                    };
                    const value_10: state_type_36 = value_9;
                    const value_11: state_type_31 = (value_10).natives;
                    const value_12: []const u32 = (value_11).order;
                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: state_type_36 = block_65: {
                        break :block_65 state_type_36{ .index = (value_10).index, .member = (value_10).member, .natives = block_64: {
                            break :block_64 state_type_31{ .count = (value_11).count, .mapping = (value_11).mapping, .order = block_63: {
                                const operand_59 = value_12;
                                const operand_60 = value_13;

                                if ((operand_60 >= (operand_59).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_61 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, (value_9).index));

                                break :block_63 block_62: {
                                    if ((!state_items_started_24)) {
                                        state_items_23 = (try (allocator).dupe(u32, operand_59));
                                        state_items_started_24 = true;
                                    }

                                    (state_items_23)[@intCast(operand_60)] = operand_61;

                                    break :block_62 state_items_23;
                                };
                            }, };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, };
                    };
                    const value_15: state_type_36 = value_14;
                    const value_16: state_type_31 = (value_15).natives;
                    const value_17: u64 = (value_16).count;

                    const value_18: state_type_36 = block_58: {
                        break :block_58 state_type_36{ .index = (value_15).index, .member = (value_15).member, .natives = block_57: {
                            break :block_57 state_type_31{ .count = (value_17 + @as(u64, 1)), .mapping = (value_16).mapping, .order = (value_16).order, };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, };
                    };

                    break :block_73 value_18;
                });

                const value_20: state_type_36 = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: state_type_36 = block_37: {
                    break :block_37 state_type_36{ .index = (value_20).index, .member = (value_21 + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, };
                };

                break :block_74 value_22;
            };

            state_changed_20 = true;
        }

        var state_owned_75: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_75);

        if (state_capacity_started_26) {
            ((state_capacity_25).items).len = (((state_6).plan).mapping).len;
            state_owned_75 = (try (state_capacity_25).toOwnedSlice(allocator));
        }

        if (state_capacity_started_26) {
            ((state_6).plan).mapping = state_owned_75;
        }

        var state_owned_76: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_76);

        if (state_capacity_started_28) {
            ((state_capacity_27).items).len = (((state_6).plan).order).len;
            state_owned_76 = (try (state_capacity_27).toOwnedSlice(allocator));
        }

        if (state_capacity_started_28) {
            ((state_6).plan).order = state_owned_76;
        }

        var state_owned_77: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_77);

        if (state_capacity_started_30) {
            ((state_capacity_29).items).len = (((state_6).plan).origins).len;
            state_owned_77 = (try (state_capacity_29).toOwnedSlice(allocator));
        }

        if (state_capacity_started_30) {
            ((state_6).plan).origins = state_owned_77;
        }

        break :block_91 (if (state_changed_20) block_90: {
            const operand_89 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

            (operand_89).* = @as((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_6).index, .member = (state_6).member, .natives = block_80: {
                const operand_79 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_79).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = ((state_6).natives).mapping, .order = ((state_6).natives).order, });

                break :block_80 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_79);
            }, .plan = block_82: {
                const operand_81 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_81).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_82 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_81);
            }, .request = block_88: {
                const operand_87 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_87).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = block_84: {
                    const operand_83 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_83).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_6).request).origins).ids, .kinds = (((state_6).request).origins).kinds, .members = (((state_6).request).origins).members, .owners = (((state_6).request).origins).owners, });

                    break :block_84 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_83);
                }, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = block_86: {
                    const operand_85 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_85).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_6).request).table).children, .field_names = (((state_6).request).table).field_names, .field_types = (((state_6).request).table).field_types, .first = (((state_6).request).table).first, .kinds = (((state_6).request).table).kinds, .labels = (((state_6).request).table).labels, .names = (((state_6).request).table).names, .second = (((state_6).request).table).second, });

                    break :block_86 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_85);
                }, });

                break :block_88 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_87);
            }, .values = (state_6).values, });

            break :block_90 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_89);
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
        return block_221: {
            const operand_214 = block_219: {
                const operand_215 = (in).state;
                const operand_216 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_219 block_218: {
                    const operand_217 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_217).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_215).count, .mapping = (operand_215).mapping, .order = (operand_215).order, .origins = (operand_215).origins, .status = operand_216, });

                    break :block_218 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_217);
                };
            };

            const operand_220 = (in).natives;

            break :block_221 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_214, .natives = operand_220, };
        };
    }

    if ((block_210: {
        const operand_208 = ((in).natives).mapping;
        const operand_209 = (in).index;

        if ((operand_209 >= (operand_208).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_210 (operand_208)[@intCast(operand_209)];
    } != @as(u64, 0))) {
        return block_213: {
            const operand_211 = (in).state;
            const operand_212 = (in).natives;

            break :block_213 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_211, .natives = operand_212, };
        };
    }

    const value_23: (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_207: {
        const operand_124 = block_123: {
            const operand_114 = (in).request;
            const operand_115 = (in).state;
            const operand_116 = (in).natives;
            const operand_117 = (in).index;

            const operand_118 = block_121: {
                const operand_119 = ((in).modules).type_ids;
                const operand_120 = (in).index;

                if ((operand_120 >= (operand_119).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_121 (operand_119)[@intCast(operand_120)];
            };

            const operand_122 = @as(u64, 0);

            break :block_123 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_114, .plan = operand_115, .natives = operand_116, .index = operand_117, .values = operand_118, .member = operand_122, };
        };

        var state_items_125: []u64 = undefined;
        var state_items_started_126 = false;
        var state_items_127: []u32 = undefined;
        var state_items_started_128 = false;
        var state_capacity_129: (std).ArrayList(u64) = .empty;
        var state_capacity_started_130 = false;

        defer (state_capacity_129).deinit(allocator);

        var state_capacity_131: (std).ArrayList(u32) = .empty;
        var state_capacity_started_132 = false;

        defer (state_capacity_131).deinit(allocator);

        var state_capacity_133: (std).ArrayList(u64) = .empty;
        var state_capacity_started_134 = false;

        defer (state_capacity_133).deinit(allocator);

        var state_113: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_124).index, .member = (operand_124).member, .natives = (operand_124).natives, .plan = (operand_124).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_124).request).maximum_count, .names = ((operand_124).request).names, .origins = ((operand_124).request).origins, .roots = ((operand_124).request).roots, .scalar_count = ((operand_124).request).scalar_count, .table = ((operand_124).request).table, .zx_origin = (operand_124).request, }, .values = (operand_124).values, .zx_origin = (&operand_124), };

        while (((((state_113).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_113).member <= @as(u64, ((state_113).values).len)))) {
            state_113 = block_193: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_113).member < @as(u64, ((state_113).values).len))) block_153: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_113;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_152: {
                        break :block_152 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_151: {
                            const operand_150 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_150).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_149: {
                                const operand_146 = block_145: {
                                    const operand_137 = (state_113).request;
                                    const operand_138 = (state_113).plan;
                                    const operand_139 = block_144: {
                                        const operand_143 = block_142: {
                                            const operand_140 = (state_113).values;
                                            const operand_141 = (state_113).member;

                                            if ((operand_141 >= (operand_140).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_142 (operand_140)[@intCast(operand_141)];
                                        };

                                        break :block_144 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_143));
                                    };

                                    break :block_145 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_137, .state = operand_138, .index = operand_139, });
                                };
                                var state_borrow_147: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_147 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_146).request).maximum_count, .names = ((operand_146).request).names, .origins = ((operand_146).request).origins, .roots = ((operand_146).request).roots, .scalar_count = ((operand_146).request).scalar_count, .table = ((operand_146).request).table, };

                                var state_borrow_148: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_148 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_146).index, .request = (((operand_146).request).zx_origin orelse (&state_borrow_147)), .state = (operand_146).state, };

                                break :block_149 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_146).zx_origin orelse (&state_borrow_148)), .{ .lane_0 = .{ .buffer = (&state_capacity_129), .started = (&state_capacity_started_130), }, .lane_1 = .{ .buffer = (&state_capacity_131), .started = (&state_capacity_started_132), }, .lane_2 = .{ .buffer = (&state_capacity_133), .started = (&state_capacity_started_134), }, }));
                            });

                            break :block_151 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_150);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_153 value_4;
                } else block_192: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_113;
                    const value_6: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_5).natives).*;

                    const value_7: []const u64 = (block_191: {
                        break :block_191 (&value_6);
                    }).mapping;

                    const value_8: u64 = (state_113).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_190: {
                        break :block_190 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_189: {
                            break :block_189 block_188: {
                                const operand_187 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_187).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_178: {
                                    break :block_178 (&value_6);
                                }).count, .mapping = block_185: {
                                    const operand_180 = block_179: {
                                        break :block_179 value_7;
                                    };
                                    const operand_182 = block_181: {
                                        break :block_181 value_8;
                                    };

                                    if ((operand_182 >= (operand_180).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_183 = (((state_113).natives).count + @as(u64, 1));

                                    break :block_185 block_184: {
                                        if ((!state_items_started_126)) {
                                            state_items_125 = (try (allocator).dupe(u64, operand_180));
                                            state_items_started_126 = true;
                                        }

                                        (state_items_125)[@intCast(operand_182)] = operand_183;

                                        break :block_184 state_items_125;
                                    };
                                }, .order = (block_186: {
                                    break :block_186 (&value_6);
                                }).order, });

                                break :block_188 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_187);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_10).natives).*;

                    const value_12: []const u32 = (block_177: {
                        break :block_177 (&value_11);
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_176: {
                        break :block_176 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_175: {
                            break :block_175 block_174: {
                                const operand_173 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_173).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_162: {
                                    break :block_162 (&value_11);
                                }).count, .mapping = (block_163: {
                                    break :block_163 (&value_11);
                                }).mapping, .order = block_172: {
                                    const operand_165 = block_164: {
                                        break :block_164 value_12;
                                    };
                                    const operand_167 = block_166: {
                                        break :block_166 value_13;
                                    };

                                    if ((operand_167 >= (operand_165).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_170 = block_169: {
                                        const operand_168 = (value_9).index;

                                        break :block_169 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_168));
                                    };

                                    break :block_172 block_171: {
                                        if ((!state_items_started_128)) {
                                            state_items_127 = (try (allocator).dupe(u32, operand_165));
                                            state_items_started_128 = true;
                                        }

                                        (state_items_127)[@intCast(operand_167)] = operand_170;

                                        break :block_171 state_items_127;
                                    };
                                }, });

                                break :block_174 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_173);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_15).natives).*;

                    const value_17: u64 = (block_161: {
                        break :block_161 (&value_16);
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_160: {
                        break :block_160 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_159: {
                            break :block_159 block_158: {
                                const operand_157 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_157).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_154: {
                                    break :block_154 value_17;
                                } + @as(u64, 1)), .mapping = (block_155: {
                                    break :block_155 (&value_16);
                                }).mapping, .order = (block_156: {
                                    break :block_156 (&value_16);
                                }).order, });

                                break :block_158 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_157);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_192 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_136: {
                    break :block_136 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_135: {
                        break :block_135 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_193 value_22;
            };
        }

        var state_owned_194: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_194);

        if (state_capacity_started_130) {
            ((state_capacity_129).items).len = (((state_113).plan).mapping).len;
            state_owned_194 = (try (state_capacity_129).toOwnedSlice(allocator));
        }

        if (state_capacity_started_130) {
            state_113 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_113).index, .member = (state_113).member, .natives = (state_113).natives, .plan = block_196: {
                const operand_195 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_195).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_113).plan).count, .mapping = state_owned_194, .order = ((state_113).plan).order, .origins = ((state_113).plan).origins, .status = ((state_113).plan).status, });

                break :block_196 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_195);
            }, .request = (state_113).request, .values = (state_113).values, };
        }

        var state_owned_197: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_197);

        if (state_capacity_started_132) {
            ((state_capacity_131).items).len = (((state_113).plan).order).len;
            state_owned_197 = (try (state_capacity_131).toOwnedSlice(allocator));
        }

        if (state_capacity_started_132) {
            state_113 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_113).index, .member = (state_113).member, .natives = (state_113).natives, .plan = block_199: {
                const operand_198 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_198).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_113).plan).count, .mapping = ((state_113).plan).mapping, .order = state_owned_197, .origins = ((state_113).plan).origins, .status = ((state_113).plan).status, });

                break :block_199 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_198);
            }, .request = (state_113).request, .values = (state_113).values, };
        }

        var state_owned_200: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_200);

        if (state_capacity_started_134) {
            ((state_capacity_133).items).len = (((state_113).plan).origins).len;
            state_owned_200 = (try (state_capacity_133).toOwnedSlice(allocator));
        }

        if (state_capacity_started_134) {
            state_113 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_113).index, .member = (state_113).member, .natives = (state_113).natives, .plan = block_202: {
                const operand_201 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_201).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_113).plan).count, .mapping = ((state_113).plan).mapping, .order = ((state_113).plan).order, .origins = state_owned_200, .status = ((state_113).plan).status, });

                break :block_202 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_201);
            }, .request = (state_113).request, .values = (state_113).values, };
        }

        break :block_207 block_206: {
            break :block_206 (if (((state_113).zx_origin != null)) ((state_113).zx_origin.?).* else block_205: {
                break :block_205 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_113).index, .member = (state_113).member, .natives = (state_113).natives, .plan = (state_113).plan, .request = (if ((((state_113).request).zx_origin != null)) ((state_113).request).zx_origin.? else block_204: {
                    const operand_203 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_203).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_113).request).maximum_count, .names = ((state_113).request).names, .origins = ((state_113).request).origins, .roots = ((state_113).request).roots, .scalar_count = ((state_113).request).scalar_count, .table = ((state_113).request).table, };

                    break :block_204 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_203);
                }), .values = (state_113).values, };
            });
        };
    };

    return block_112: {
        const operand_110 = ((&value_23)).plan;
        const operand_111 = ((&value_23)).natives;

        break :block_112 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_110, .natives = operand_111, };
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
        return block_326: {
            const operand_319 = block_324: {
                const operand_320 = (in).state;
                const operand_321 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_324 block_323: {
                    const operand_322 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_322).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_320).count, .mapping = (operand_320).mapping, .order = (operand_320).order, .origins = (operand_320).origins, .status = operand_321, });

                    break :block_323 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_322);
                };
            };

            const operand_325 = (in).natives;

            break :block_326 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_319, .natives = operand_325, };
        };
    }

    if ((block_315: {
        const operand_313 = ((in).natives).mapping;
        const operand_314 = (in).index;

        if ((operand_314 >= (operand_313).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_315 (operand_313)[@intCast(operand_314)];
    } != @as(u64, 0))) {
        return block_318: {
            const operand_316 = (in).state;
            const operand_317 = (in).natives;

            break :block_318 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_316, .natives = operand_317, };
        };
    }

    const value_23: (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_312: {
        const operand_236 = block_235: {
            const operand_226 = (in).request;
            const operand_227 = (in).state;
            const operand_228 = (in).natives;
            const operand_229 = (in).index;

            const operand_230 = block_233: {
                const operand_231 = ((in).modules).type_ids;
                const operand_232 = (in).index;

                if ((operand_232 >= (operand_231).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_233 (operand_231)[@intCast(operand_232)];
            };

            const operand_234 = @as(u64, 0);

            break :block_235 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_226, .plan = operand_227, .natives = operand_228, .index = operand_229, .values = operand_230, .member = operand_234, };
        };

        var state_capacity_237: (std).ArrayList(u64) = .empty;
        var state_capacity_started_238 = false;

        defer (state_capacity_237).deinit(allocator);

        var state_capacity_239: (std).ArrayList(u32) = .empty;
        var state_capacity_started_240 = false;

        defer (state_capacity_239).deinit(allocator);

        var state_225: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (operand_236).index, .member = (operand_236).member, .natives = (operand_236).natives, .plan = (operand_236).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_236).request).maximum_count, .names = ((operand_236).request).names, .origins = ((operand_236).request).origins, .roots = ((operand_236).request).roots, .scalar_count = ((operand_236).request).scalar_count, .table = ((operand_236).request).table, .zx_origin = (operand_236).request, }, .values = (operand_236).values, .zx_origin = (&operand_236), };

        while (((((state_225).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_225).member <= @as(u64, ((state_225).values).len)))) {
            state_225 = block_301: {
                const value_19: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = (if (((state_225).member < @as(u64, ((state_225).values).len))) block_259: {
                    const value_3: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_225;

                    const value_4: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_258: {
                        break :block_258 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_257: {
                            const operand_256 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_256).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_255: {
                                const operand_252 = block_251: {
                                    const operand_243 = (state_225).request;
                                    const operand_244 = (state_225).plan;
                                    const operand_245 = block_250: {
                                        const operand_249 = block_248: {
                                            const operand_246 = (state_225).values;
                                            const operand_247 = (state_225).member;

                                            if ((operand_247 >= (operand_246).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_248 (operand_246)[@intCast(operand_247)];
                                        };

                                        break :block_250 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_249));
                                    };

                                    break :block_251 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_243, .state = operand_244, .index = operand_245, });
                                };
                                var state_borrow_253: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_253 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_252).request).maximum_count, .names = ((operand_252).request).names, .origins = ((operand_252).request).origins, .roots = ((operand_252).request).roots, .scalar_count = ((operand_252).request).scalar_count, .table = ((operand_252).request).table, };

                                var state_borrow_254: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_254 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_252).index, .request = (((operand_252).request).zx_origin orelse (&state_borrow_253)), .state = (operand_252).state, };

                                break :block_255 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_252).zx_origin orelse (&state_borrow_254)), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_257 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_256);
                        }, .request = (value_3).request, .values = (value_3).values, });
                    };

                    break :block_259 value_4;
                } else block_300: {
                    const value_5: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = state_225;
                    const value_6: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_5).natives).*;

                    const value_7: []const u64 = (block_299: {
                        break :block_299 (&value_6);
                    }).mapping;

                    const value_8: u64 = (state_225).index;

                    const value_9: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_298: {
                        break :block_298 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_5).index, .member = (value_5).member, .natives = block_297: {
                            break :block_297 block_296: {
                                const operand_295 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_295).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_285: {
                                    break :block_285 (&value_6);
                                }).count, .mapping = block_293: {
                                    const operand_287 = block_286: {
                                        break :block_286 value_7;
                                    };
                                    const operand_289 = block_288: {
                                        break :block_288 value_8;
                                    };

                                    if ((operand_289 >= (operand_287).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_290 = (((state_225).natives).count + @as(u64, 1));

                                    break :block_293 @as([]const u64, (if (((buffers).lane_0 != null)) block_291: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_287));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_287).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_289)] = operand_290;

                                        break :block_291 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_292: {
                                        if ((!state_capacity_started_238)) {
                                            (try (state_capacity_237).appendSlice(allocator, operand_287));

                                            state_capacity_started_238 = true;
                                        } else {
                                            ((state_capacity_237).items).len = (operand_287).len;
                                        }

                                        ((state_capacity_237).items)[@intCast(operand_289)] = operand_290;

                                        break :block_292 (state_capacity_237).items;
                                    }));
                                }, .order = (block_294: {
                                    break :block_294 (&value_6);
                                }).order, });

                                break :block_296 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_295);
                            };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, });
                    };

                    const value_10: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_9;
                    const value_11: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_10).natives).*;

                    const value_12: []const u32 = (block_284: {
                        break :block_284 (&value_11);
                    }).order;

                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_283: {
                        break :block_283 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_10).index, .member = (value_10).member, .natives = block_282: {
                            break :block_282 block_281: {
                                const operand_280 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_280).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_268: {
                                    break :block_268 (&value_11);
                                }).count, .mapping = (block_269: {
                                    break :block_269 (&value_11);
                                }).mapping, .order = block_279: {
                                    const operand_271 = block_270: {
                                        break :block_270 value_12;
                                    };
                                    const operand_273 = block_272: {
                                        break :block_272 value_13;
                                    };

                                    if ((operand_273 >= (operand_271).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_276 = block_275: {
                                        const operand_274 = (value_9).index;

                                        break :block_275 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_274));
                                    };

                                    break :block_279 @as([]const u32, (if (((buffers).lane_1 != null)) block_277: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_271));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_271).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_273)] = operand_276;

                                        break :block_277 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_278: {
                                        if ((!state_capacity_started_240)) {
                                            (try (state_capacity_239).appendSlice(allocator, operand_271));
                                            state_capacity_started_240 = true;
                                        } else {
                                            ((state_capacity_239).items).len = (operand_271).len;
                                        }

                                        ((state_capacity_239).items)[@intCast(operand_273)] = operand_276;
                                        break :block_278 (state_capacity_239).items;
                                    }));
                                }, });

                                break :block_281 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_280);
                            };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, });
                    };

                    const value_15: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_14;
                    const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((value_15).natives).*;

                    const value_17: u64 = (block_267: {
                        break :block_267 (&value_16);
                    }).count;

                    const value_18: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_266: {
                        break :block_266 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_15).index, .member = (value_15).member, .natives = block_265: {
                            break :block_265 block_264: {
                                const operand_263 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                (operand_263).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_260: {
                                    break :block_260 value_17;
                                } + @as(u64, 1)), .mapping = (block_261: {
                                    break :block_261 (&value_16);
                                }).mapping, .order = (block_262: {
                                    break :block_262 (&value_16);
                                }).order, });

                                break :block_264 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_263);
                            };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, });
                    };

                    break :block_300 value_18;
                });

                const value_20: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = block_242: {
                    break :block_242 @as((zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f, (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (value_20).index, .member = (block_241: {
                        break :block_241 value_21;
                    } + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, });
                };

                break :block_301 value_22;
            };
        }

        var state_owned_302: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_302);

        if (state_capacity_started_238) {
            ((state_capacity_237).items).len = (((state_225).natives).mapping).len;
            state_owned_302 = (try (state_capacity_237).toOwnedSlice(allocator));
        }

        if (state_capacity_started_238) {
            state_225 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_225).index, .member = (state_225).member, .natives = block_304: {
                const operand_303 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_303).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_225).natives).count, .mapping = state_owned_302, .order = ((state_225).natives).order, });

                break :block_304 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_303);
            }, .plan = (state_225).plan, .request = (state_225).request, .values = (state_225).values, };
        }

        var state_owned_305: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_305);

        if (state_capacity_started_240) {
            ((state_capacity_239).items).len = (((state_225).natives).order).len;
            state_owned_305 = (try (state_capacity_239).toOwnedSlice(allocator));
        }

        if (state_capacity_started_240) {
            state_225 = (zx_abi).value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f{ .index = (state_225).index, .member = (state_225).member, .natives = block_307: {
                const operand_306 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_306).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_225).natives).count, .mapping = ((state_225).natives).mapping, .order = state_owned_305, });

                break :block_307 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_306);
            }, .plan = (state_225).plan, .request = (state_225).request, .values = (state_225).values, };
        }

        break :block_312 block_311: {
            break :block_311 (if (((state_225).zx_origin != null)) ((state_225).zx_origin.?).* else block_310: {
                break :block_310 (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_225).index, .member = (state_225).member, .natives = (state_225).natives, .plan = (state_225).plan, .request = (if ((((state_225).request).zx_origin != null)) ((state_225).request).zx_origin.? else block_309: {
                    const operand_308 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_308).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_225).request).maximum_count, .names = ((state_225).request).names, .origins = ((state_225).request).origins, .roots = ((state_225).request).roots, .scalar_count = ((state_225).request).scalar_count, .table = ((state_225).request).table, };

                    break :block_309 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_308);
                }), .values = (state_225).values, };
            });
        };
    };

    return block_224: {
        const operand_222 = ((&value_23)).plan;
        const operand_223 = ((&value_23)).natives;

        break :block_224 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_222, .natives = operand_223, };
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
        return block_430: {
            const operand_421 = block_426: {
                const operand_422 = (in).state;
                const operand_423 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_426 block_425: {
                    const operand_424 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_424).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_422).count, .mapping = (operand_422).mapping, .order = (operand_422).order, .origins = (operand_422).origins, .status = operand_423, });

                    break :block_425 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_424);
                };
            };

            const operand_427 = (in).natives;

            break :block_430 block_429: {
                const operand_428 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_428).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_421, .natives = operand_427, });

                break :block_429 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_428);
            };
        };
    }

    if ((block_415: {
        const operand_413 = ((in).natives).mapping;
        const operand_414 = (in).index;

        if ((operand_414 >= (operand_413).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_415 (operand_413)[@intCast(operand_414)];
    } != @as(u64, 0))) {
        return block_420: {
            const operand_416 = (in).state;
            const operand_417 = (in).natives;

            break :block_420 block_419: {
                const operand_418 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_418).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_416, .natives = operand_417, });

                break :block_419 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_418);
            };
        };
    }

    const value_23: *const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = block_412: {
        const operand_345 = block_344: {
            const operand_333 = (in).request;
            const operand_334 = (in).state;
            const operand_335 = (in).natives;
            const operand_336 = (in).index;

            const operand_337 = block_340: {
                const operand_338 = ((in).modules).type_ids;
                const operand_339 = (in).index;

                if ((operand_339 >= (operand_338).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_340 (operand_338)[@intCast(operand_339)];
            };

            const operand_341 = @as(u64, 0);

            break :block_344 block_343: {
                const operand_342 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

                (operand_342).* = @as((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .request = operand_333, .plan = operand_334, .natives = operand_335, .index = operand_336, .values = operand_337, .member = operand_341, });

                break :block_343 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_342);
            };
        };

        var state_capacity_347: (std).ArrayList(u64) = .empty;
        var state_capacity_started_348 = false;

        defer (state_capacity_347).deinit(allocator);

        var state_capacity_349: (std).ArrayList(u32) = .empty;
        var state_capacity_started_350 = false;

        defer (state_capacity_349).deinit(allocator);

        const state_type_351 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_352 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_353 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_354 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_355 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_353,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_354,
        };
        const state_type_356 = struct {
            index: u64,
            member: u64,
            natives: state_type_351,
            plan: state_type_352,
            request: state_type_355,
            values: []const u32,
        };
        const state_type_358 = struct {
            index: u64,
            request: state_type_355,
            state: state_type_352,
        };

        var state_332: state_type_356 = state_type_356{ .index = (operand_345).index, .member = (operand_345).member, .natives = state_type_351{ .count = ((operand_345).natives).count, .mapping = ((operand_345).natives).mapping, .order = ((operand_345).natives).order, }, .plan = state_type_352{ .count = ((operand_345).plan).count, .mapping = ((operand_345).plan).mapping, .order = ((operand_345).plan).order, .origins = ((operand_345).plan).origins, .status = ((operand_345).plan).status, }, .request = state_type_355{ .maximum_count = ((operand_345).request).maximum_count, .names = ((operand_345).request).names, .origins = state_type_353{ .ids = (((operand_345).request).origins).ids, .kinds = (((operand_345).request).origins).kinds, .members = (((operand_345).request).origins).members, .owners = (((operand_345).request).origins).owners, }, .roots = ((operand_345).request).roots, .scalar_count = ((operand_345).request).scalar_count, .table = state_type_354{ .children = (((operand_345).request).table).children, .field_names = (((operand_345).request).table).field_names, .field_types = (((operand_345).request).table).field_types, .first = (((operand_345).request).table).first, .kinds = (((operand_345).request).table).kinds, .labels = (((operand_345).request).table).labels, .names = (((operand_345).request).table).names, .second = (((operand_345).request).table).second, }, }, .values = (operand_345).values, };
        var state_changed_346 = false;

        while (((((state_332).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_332).member <= @as(u64, ((state_332).values).len)))) {
            state_332 = block_396: {
                const value_19: state_type_356 = (if (((state_332).member < @as(u64, ((state_332).values).len))) block_376: {
                    const value_3: state_type_356 = state_332;
                    const value_4: state_type_356 = block_375: {
                        break :block_375 state_type_356{ .index = (value_3).index, .member = (value_3).member, .natives = (value_3).natives, .plan = block_374: {
                            const operand_366 = block_365: {
                                const operand_359 = (state_332).request;
                                const operand_360 = (state_332).plan;

                                const operand_364 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_363: {
                                    const operand_361 = (state_332).values;
                                    const operand_362 = (state_332).member;

                                    if ((operand_362 >= (operand_361).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_363 (operand_361)[@intCast(operand_362)];
                                }));

                                break :block_365 state_type_358{ .request = operand_359, .state = operand_360, .index = operand_364, };
                            };

                            const operand_367 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_366).request).origins).ids, .kinds = (((operand_366).request).origins).kinds, .members = (((operand_366).request).origins).members, .owners = (((operand_366).request).origins).owners, };
                            const operand_368 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_366).request).table).children, .field_names = (((operand_366).request).table).field_names, .field_types = (((operand_366).request).table).field_types, .first = (((operand_366).request).table).first, .kinds = (((operand_366).request).table).kinds, .labels = (((operand_366).request).table).labels, .names = (((operand_366).request).table).names, .second = (((operand_366).request).table).second, };
                            const operand_369 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_366).request).maximum_count, .names = ((operand_366).request).names, .origins = (&operand_367), .roots = ((operand_366).request).roots, .scalar_count = ((operand_366).request).scalar_count, .table = (&operand_368), };
                            const operand_370 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_366).state).count, .mapping = ((operand_366).state).mapping, .order = ((operand_366).state).order, .origins = ((operand_366).state).origins, .status = ((operand_366).state).status, };
                            const operand_371 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_366).index, .request = (&operand_369), .state = (&operand_370), };

                            const operand_373 = block_372: {
                                break :block_372 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_371), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            };

                            break :block_374 state_type_352{ .count = (operand_373).count, .mapping = (operand_373).mapping, .order = (operand_373).order, .origins = (operand_373).origins, .status = (operand_373).status, };
                        }, .request = (value_3).request, .values = (value_3).values, };
                    };

                    break :block_376 value_4;
                } else block_395: {
                    const value_5: state_type_356 = state_332;
                    const value_6: state_type_351 = (value_5).natives;
                    const value_7: []const u64 = (value_6).mapping;
                    const value_8: u64 = (state_332).index;

                    const value_9: state_type_356 = block_394: {
                        break :block_394 state_type_356{ .index = (value_5).index, .member = (value_5).member, .natives = block_393: {
                            break :block_393 state_type_351{ .count = (value_6).count, .mapping = block_392: {
                                const operand_387 = value_7;
                                const operand_388 = value_8;

                                if ((operand_388 >= (operand_387).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_389 = (((state_332).natives).count + @as(u64, 1));

                                break :block_392 @as([]const u64, (if (((buffers).lane_0 != null)) block_390: {
                                    if ((!(((buffers).lane_0.?).started).*)) {
                                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_387));
                                        (((buffers).lane_0.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_387).len;
                                    }

                                    (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_388)] = operand_389;

                                    break :block_390 ((((buffers).lane_0.?).buffer).*).items;
                                } else block_391: {
                                    if ((!state_capacity_started_348)) {
                                        (try (state_capacity_347).appendSlice(allocator, operand_387));

                                        state_capacity_started_348 = true;
                                    } else {
                                        ((state_capacity_347).items).len = (operand_387).len;
                                    }

                                    ((state_capacity_347).items)[@intCast(operand_388)] = operand_389;

                                    break :block_391 (state_capacity_347).items;
                                }));
                            }, .order = (value_6).order, };
                        }, .plan = (value_5).plan, .request = (value_5).request, .values = (value_5).values, };
                    };
                    const value_10: state_type_356 = value_9;
                    const value_11: state_type_351 = (value_10).natives;
                    const value_12: []const u32 = (value_11).order;
                    const value_13: u64 = ((value_9).natives).count;

                    const value_14: state_type_356 = block_386: {
                        break :block_386 state_type_356{ .index = (value_10).index, .member = (value_10).member, .natives = block_385: {
                            break :block_385 state_type_351{ .count = (value_11).count, .mapping = (value_11).mapping, .order = block_384: {
                                const operand_379 = value_12;
                                const operand_380 = value_13;

                                if ((operand_380 >= (operand_379).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_381 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, (value_9).index));

                                break :block_384 @as([]const u32, (if (((buffers).lane_1 != null)) block_382: {
                                    if ((!(((buffers).lane_1.?).started).*)) {
                                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_379));
                                        (((buffers).lane_1.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_379).len;
                                    }

                                    (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_380)] = operand_381;

                                    break :block_382 ((((buffers).lane_1.?).buffer).*).items;
                                } else block_383: {
                                    if ((!state_capacity_started_350)) {
                                        (try (state_capacity_349).appendSlice(allocator, operand_379));

                                        state_capacity_started_350 = true;
                                    } else {
                                        ((state_capacity_349).items).len = (operand_379).len;
                                    }

                                    ((state_capacity_349).items)[@intCast(operand_380)] = operand_381;

                                    break :block_383 (state_capacity_349).items;
                                }));
                            }, };
                        }, .plan = (value_10).plan, .request = (value_10).request, .values = (value_10).values, };
                    };
                    const value_15: state_type_356 = value_14;
                    const value_16: state_type_351 = (value_15).natives;
                    const value_17: u64 = (value_16).count;

                    const value_18: state_type_356 = block_378: {
                        break :block_378 state_type_356{ .index = (value_15).index, .member = (value_15).member, .natives = block_377: {
                            break :block_377 state_type_351{ .count = (value_17 + @as(u64, 1)), .mapping = (value_16).mapping, .order = (value_16).order, };
                        }, .plan = (value_15).plan, .request = (value_15).request, .values = (value_15).values, };
                    };

                    break :block_395 value_18;
                });

                const value_20: state_type_356 = value_19;
                const value_21: u64 = (value_20).member;

                const value_22: state_type_356 = block_357: {
                    break :block_357 state_type_356{ .index = (value_20).index, .member = (value_21 + @as(u64, 1)), .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, .values = (value_20).values, };
                };

                break :block_396 value_22;
            };

            state_changed_346 = true;
        }

        var state_owned_397: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_397);

        if (state_capacity_started_348) {
            ((state_capacity_347).items).len = (((state_332).natives).mapping).len;
            state_owned_397 = (try (state_capacity_347).toOwnedSlice(allocator));
        }

        if (state_capacity_started_348) {
            ((state_332).natives).mapping = state_owned_397;
        }

        var state_owned_398: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_398);

        if (state_capacity_started_350) {
            ((state_capacity_349).items).len = (((state_332).natives).order).len;
            state_owned_398 = (try (state_capacity_349).toOwnedSlice(allocator));
        }

        if (state_capacity_started_350) {
            ((state_332).natives).order = state_owned_398;
        }

        break :block_412 (if (state_changed_346) block_411: {
            const operand_410 = (try (allocator).create((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc));

            (operand_410).* = @as((zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc{ .index = (state_332).index, .member = (state_332).member, .natives = block_401: {
                const operand_400 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_400).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_332).natives).count, .mapping = ((state_332).natives).mapping, .order = ((state_332).natives).order, });

                break :block_401 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_400);
            }, .plan = block_403: {
                const operand_402 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_402).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_332).plan).count, .mapping = ((state_332).plan).mapping, .order = ((state_332).plan).order, .origins = ((state_332).plan).origins, .status = ((state_332).plan).status, });

                break :block_403 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_402);
            }, .request = block_409: {
                const operand_408 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_408).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_332).request).maximum_count, .names = ((state_332).request).names, .origins = block_405: {
                    const operand_404 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_404).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_332).request).origins).ids, .kinds = (((state_332).request).origins).kinds, .members = (((state_332).request).origins).members, .owners = (((state_332).request).origins).owners, });

                    break :block_405 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_404);
                }, .roots = ((state_332).request).roots, .scalar_count = ((state_332).request).scalar_count, .table = block_407: {
                    const operand_406 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_406).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_332).request).table).children, .field_names = (((state_332).request).table).field_names, .field_types = (((state_332).request).table).field_types, .first = (((state_332).request).table).first, .kinds = (((state_332).request).table).kinds, .labels = (((state_332).request).table).labels, .names = (((state_332).request).table).names, .second = (((state_332).request).table).second, });

                    break :block_407 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_406);
                }, });

                break :block_409 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_408);
            }, .values = (state_332).values, });

            break :block_411 @as(*const (zx_abi).zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc, operand_410);
        } else operand_345);
    };

    return block_331: {
        const operand_327 = (value_23).plan;
        const operand_328 = (value_23).natives;

        break :block_331 block_330: {
            const operand_329 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_329).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_327, .natives = operand_328, });

            break :block_330 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_329);
        };
    };
}

