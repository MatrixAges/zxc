const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_25: *const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_101: {
        const operand_16 = block_15: {
            const operand_7 = (in).request;
            const operand_8 = (in).state;
            const operand_9 = (in).modules;
            const operand_10 = (in).natives;
            const operand_11 = @as(u64, 0);
            const operand_12 = @as(u64, 0);

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_13).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_7, .plan = operand_8, .modules = operand_9, .natives = operand_10, .index = operand_11, .member = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_13);
            };
        };

        var state_capacity_18: (std).ArrayList(u64) = .empty;
        var state_capacity_started_19 = false;

        defer (state_capacity_18).deinit(allocator);

        var state_capacity_20: (std).ArrayList(u32) = .empty;
        var state_capacity_started_21 = false;

        defer (state_capacity_20).deinit(allocator);

        var state_capacity_22: (std).ArrayList(u64) = .empty;
        var state_capacity_started_23 = false;

        defer (state_capacity_22).deinit(allocator);

        var state_capacity_24: (std).ArrayList(u32) = .empty;
        var state_capacity_started_25 = false;

        defer (state_capacity_24).deinit(allocator);

        var state_capacity_26: (std).ArrayList(u64) = .empty;
        var state_capacity_started_27 = false;

        defer (state_capacity_26).deinit(allocator);

        const state_type_31 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };
        const state_type_32 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_33 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_34 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };

        const state_type_35 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_36 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_34,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_35,
        };
        const state_type_37 = struct {
            index: u64,
            member: u64,
            modules: state_type_31,
            natives: state_type_32,
            plan: state_type_33,
            request: state_type_36,
        };
        const state_type_51 = struct {
            index: u64,
            modules: state_type_31,
            natives: state_type_32,
            request: state_type_36,
            state: state_type_33,
        };
        const state_type_68 = struct {
            natives: state_type_32,
            state: state_type_33,
        };

        var state_6: state_type_37 = state_type_37{ .index = (operand_16).index, .member = (operand_16).member, .modules = state_type_31{ .identities = ((operand_16).modules).identities, .import_names = ((operand_16).modules).import_names, .specifiers = ((operand_16).modules).specifiers, .type_ids = ((operand_16).modules).type_ids, .type_names = ((operand_16).modules).type_names, .type_namespaces = ((operand_16).modules).type_namespaces, }, .natives = state_type_32{ .count = ((operand_16).natives).count, .mapping = ((operand_16).natives).mapping, .order = ((operand_16).natives).order, }, .plan = state_type_33{ .count = ((operand_16).plan).count, .mapping = ((operand_16).plan).mapping, .order = ((operand_16).plan).order, .origins = ((operand_16).plan).origins, .status = ((operand_16).plan).status, }, .request = state_type_36{ .maximum_count = ((operand_16).request).maximum_count, .names = ((operand_16).request).names, .origins = state_type_34{ .ids = (((operand_16).request).origins).ids, .kinds = (((operand_16).request).origins).kinds, .members = (((operand_16).request).origins).members, .owners = (((operand_16).request).origins).owners, }, .roots = ((operand_16).request).roots, .scalar_count = ((operand_16).request).scalar_count, .table = state_type_35{ .children = (((operand_16).request).table).children, .field_names = (((operand_16).request).table).field_names, .field_types = (((operand_16).request).table).field_types, .first = (((operand_16).request).table).first, .kinds = (((operand_16).request).table).kinds, .labels = (((operand_16).request).table).labels, .names = (((operand_16).request).table).names, .second = (((operand_16).request).table).second, }, }, };
        var state_changed_17 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).index < @as(u64, (((state_6).modules).specifiers).len)))) {
            state_6 = block_80: {
                const value_3: []const u32 = block_79: {
                    const operand_77 = ((state_6).modules).type_ids;
                    const operand_78 = (state_6).index;

                    if ((operand_78 >= (operand_77).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_79 (operand_77)[@intCast(operand_78)];
                };
                const value_24: state_type_37 = (if (((block_30: {
                    const operand_28 = ((state_6).natives).mapping;
                    const operand_29 = (state_6).index;

                    if ((operand_29 >= (operand_28).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_30 (operand_28)[@intCast(operand_29)];
                } != @as(u64, 0)) or ((state_6).member >= @as(u64, (value_3).len)))) block_40: {
                    const value_4: state_type_37 = state_6;
                    const value_5: u64 = (value_4).index;

                    const value_6: state_type_37 = block_39: {
                        break :block_39 state_type_37{ .index = (value_5 + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, };
                    };
                    const value_7: state_type_37 = value_6;

                    const value_8: state_type_37 = block_38: {
                        break :block_38 state_type_37{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, };
                    };

                    break :block_40 value_8;
                } else block_76: {
                    const value_9: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_75: {
                        const operand_73 = value_3;
                        const operand_74 = (state_6).member;

                        if ((operand_74 >= (operand_73).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_75 (operand_73)[@intCast(operand_74)];
                    }));

                    const value_23: state_type_37 = (if ((((try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_43: {
                        const operand_41 = (((state_6).request).table).kinds;
                        const operand_42 = value_9;

                        if ((operand_42 >= (operand_41).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_43 (operand_41)[@intCast(operand_42)];
                    })) == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_46: {
                        const operand_44 = ((state_6).plan).mapping;
                        const operand_45 = value_9;

                        if ((operand_45 >= (operand_44).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_46 (operand_44)[@intCast(operand_45)];
                    } != @as(u64, 0)))) block_70: {
                        const value_10: state_type_68 = block_69: {
                            const operand_58 = block_57: {
                                const operand_52 = (state_6).request;
                                const operand_53 = (state_6).plan;
                                const operand_54 = (state_6).modules;
                                const operand_55 = (state_6).natives;
                                const operand_56 = (state_6).index;

                                break :block_57 state_type_51{ .request = operand_52, .state = operand_53, .modules = operand_54, .natives = operand_55, .index = operand_56, };
                            };

                            const operand_59 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_58).modules).identities, .import_names = ((operand_58).modules).import_names, .specifiers = ((operand_58).modules).specifiers, .type_ids = ((operand_58).modules).type_ids, .type_names = ((operand_58).modules).type_names, .type_namespaces = ((operand_58).modules).type_namespaces, };
                            const operand_60 = (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((operand_58).natives).count, .mapping = ((operand_58).natives).mapping, .order = ((operand_58).natives).order, };
                            const operand_61 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_58).request).origins).ids, .kinds = (((operand_58).request).origins).kinds, .members = (((operand_58).request).origins).members, .owners = (((operand_58).request).origins).owners, };
                            const operand_62 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_58).request).table).children, .field_names = (((operand_58).request).table).field_names, .field_types = (((operand_58).request).table).field_types, .first = (((operand_58).request).table).first, .kinds = (((operand_58).request).table).kinds, .labels = (((operand_58).request).table).labels, .names = (((operand_58).request).table).names, .second = (((operand_58).request).table).second, };
                            const operand_63 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_58).request).maximum_count, .names = ((operand_58).request).names, .origins = (&operand_61), .roots = ((operand_58).request).roots, .scalar_count = ((operand_58).request).scalar_count, .table = (&operand_62), };
                            const operand_64 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_58).state).count, .mapping = ((operand_58).state).mapping, .order = ((operand_58).state).order, .origins = ((operand_58).state).origins, .status = ((operand_58).state).status, };
                            const operand_65 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_58).index, .modules = (&operand_59), .natives = (&operand_60), .request = (&operand_63), .state = (&operand_64), };

                            const operand_67 = block_66: {
                                break :block_66 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, (&operand_65), .{ .lane_0 = .{ .buffer = (&state_capacity_18), .started = (&state_capacity_started_19), }, .lane_1 = .{ .buffer = (&state_capacity_20), .started = (&state_capacity_started_21), }, .lane_2 = .{ .buffer = (&state_capacity_22), .started = (&state_capacity_started_23), }, .lane_3 = .{ .buffer = (&state_capacity_24), .started = (&state_capacity_started_25), }, .lane_4 = .{ .buffer = (&state_capacity_26), .started = (&state_capacity_started_27), }, }));
                            };

                            break :block_69 state_type_68{ .natives = state_type_32{ .count = ((operand_67).natives).count, .mapping = ((operand_67).natives).mapping, .order = ((operand_67).natives).order, }, .state = state_type_33{ .count = ((operand_67).state).count, .mapping = ((operand_67).state).mapping, .order = ((operand_67).state).order, .origins = ((operand_67).state).origins, .status = ((operand_67).state).status, }, };
                        };
                        const value_11: state_type_37 = state_6;

                        const value_12: state_type_37 = block_50: {
                            break :block_50 state_type_37{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (value_10).state, .request = (value_11).request, };
                        };
                        const value_13: state_type_37 = value_12;

                        const value_14: state_type_37 = block_49: {
                            break :block_49 state_type_37{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (value_10).natives, .plan = (value_13).plan, .request = (value_13).request, };
                        };
                        const value_15: state_type_37 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: state_type_37 = block_48: {
                            break :block_48 state_type_37{ .index = (value_16 + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, };
                        };
                        const value_18: state_type_37 = value_17;

                        const value_19: state_type_37 = block_47: {
                            break :block_47 state_type_37{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, };
                        };

                        break :block_70 value_19;
                    } else block_72: {
                        const value_20: state_type_37 = state_6;
                        const value_21: u64 = (value_20).member;

                        const value_22: state_type_37 = block_71: {
                            break :block_71 state_type_37{ .index = (value_20).index, .member = (value_21 + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_72 value_22;
                    });

                    break :block_76 value_23;
                });

                break :block_80 value_24;
            };

            state_changed_17 = true;
        }

        var state_owned_81: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_81);

        if (state_capacity_started_19) {
            ((state_capacity_18).items).len = (((state_6).natives).mapping).len;
            state_owned_81 = (try (state_capacity_18).toOwnedSlice(allocator));
        }

        if (state_capacity_started_19) {
            ((state_6).natives).mapping = state_owned_81;
        }

        var state_owned_82: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_82);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = (((state_6).natives).order).len;
            state_owned_82 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            ((state_6).natives).order = state_owned_82;
        }

        var state_owned_83: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_83);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = (((state_6).plan).mapping).len;
            state_owned_83 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            ((state_6).plan).mapping = state_owned_83;
        }

        var state_owned_84: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_84);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = (((state_6).plan).order).len;
            state_owned_84 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            ((state_6).plan).order = state_owned_84;
        }

        var state_owned_85: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_85);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = (((state_6).plan).origins).len;
            state_owned_85 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            ((state_6).plan).origins = state_owned_85;
        }

        break :block_101 (if (state_changed_17) block_100: {
            const operand_99 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

            (operand_99).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_6).index, .member = (state_6).member, .modules = block_88: {
                const operand_87 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_87).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_6).modules).identities, .import_names = ((state_6).modules).import_names, .specifiers = ((state_6).modules).specifiers, .type_ids = ((state_6).modules).type_ids, .type_names = ((state_6).modules).type_names, .type_namespaces = ((state_6).modules).type_namespaces, });

                break :block_88 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_87);
            }, .natives = block_90: {
                const operand_89 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_89).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = ((state_6).natives).mapping, .order = ((state_6).natives).order, });

                break :block_90 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_89);
            }, .plan = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_91).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_92 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_91);
            }, .request = block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_97).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = block_94: {
                    const operand_93 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_93).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_6).request).origins).ids, .kinds = (((state_6).request).origins).kinds, .members = (((state_6).request).origins).members, .owners = (((state_6).request).origins).owners, });

                    break :block_94 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_93);
                }, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = block_96: {
                    const operand_95 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_95).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_6).request).table).children, .field_names = (((state_6).request).table).field_names, .field_types = (((state_6).request).table).field_types, .first = (((state_6).request).table).first, .kinds = (((state_6).request).table).kinds, .labels = (((state_6).request).table).labels, .names = (((state_6).request).table).names, .second = (((state_6).request).table).second, });

                    break :block_96 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_95);
                }, });

                break :block_98 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_97);
            }, });

            break :block_100 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_99);
        } else operand_16);
    };

    return block_5: {
        const operand_1 = (value_25).plan;
        const operand_2 = (value_25).natives;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_3).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_1, .natives = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_3);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_25: (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_198: {
        const operand_113 = block_112: {
            const operand_106 = (in).request;
            const operand_107 = (in).state;
            const operand_108 = (in).modules;
            const operand_109 = (in).natives;
            const operand_110 = @as(u64, 0);
            const operand_111 = @as(u64, 0);

            break :block_112 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_106, .plan = operand_107, .modules = operand_108, .natives = operand_109, .index = operand_110, .member = operand_111, };
        };

        var state_capacity_114: (std).ArrayList(u64) = .empty;
        var state_capacity_started_115 = false;

        defer (state_capacity_114).deinit(allocator);

        var state_capacity_116: (std).ArrayList(u32) = .empty;
        var state_capacity_started_117 = false;

        defer (state_capacity_116).deinit(allocator);

        var state_capacity_118: (std).ArrayList(u64) = .empty;
        var state_capacity_started_119 = false;

        defer (state_capacity_118).deinit(allocator);

        var state_capacity_120: (std).ArrayList(u32) = .empty;
        var state_capacity_started_121 = false;

        defer (state_capacity_120).deinit(allocator);

        var state_capacity_122: (std).ArrayList(u64) = .empty;
        var state_capacity_started_123 = false;

        defer (state_capacity_122).deinit(allocator);

        var state_105: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_113).index, .member = (operand_113).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_113).modules).identities, .import_names = ((operand_113).modules).import_names, .specifiers = ((operand_113).modules).specifiers, .type_ids = ((operand_113).modules).type_ids, .type_names = ((operand_113).modules).type_names, .type_namespaces = ((operand_113).modules).type_namespaces, .zx_origin = (operand_113).modules, }, .natives = (operand_113).natives, .plan = (operand_113).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_113).request).maximum_count, .names = ((operand_113).request).names, .origins = ((operand_113).request).origins, .roots = ((operand_113).request).roots, .scalar_count = ((operand_113).request).scalar_count, .table = ((operand_113).request).table, .zx_origin = (operand_113).request, }, .zx_origin = (&operand_113), };

        while (((((state_105).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_105).index < @as(u64, (((state_105).modules).specifiers).len)))) {
            state_105 = block_176: {
                const value_3: []const u32 = block_175: {
                    const operand_173 = ((state_105).modules).type_ids;
                    const operand_174 = (state_105).index;

                    if ((operand_174 >= (operand_173).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_175 (operand_173)[@intCast(operand_174)];
                };

                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_126: {
                    const operand_124 = ((state_105).natives).mapping;
                    const operand_125 = (state_105).index;

                    if ((operand_125 >= (operand_124).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_126 (operand_124)[@intCast(operand_125)];
                } != @as(u64, 0)) or ((state_105).member >= @as(u64, (block_127: {
                    break :block_127 value_3;
                }).len)))) block_131: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_105;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_130: {
                        break :block_130 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_129: {
                            break :block_129 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_128: {
                        break :block_128 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_131 value_8;
                } else block_172: {
                    const value_9: u64 = block_171: {
                        const operand_170 = block_169: {
                            const operand_167 = block_166: {
                                break :block_166 value_3;
                            };

                            const operand_168 = (state_105).member;

                            if ((operand_168 >= (operand_167).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_169 (operand_167)[@intCast(operand_168)];
                        };

                        break :block_171 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_170));
                    };
                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_137: {
                        const operand_136 = block_135: {
                            const operand_133 = (((state_105).request).table).kinds;

                            const operand_134 = block_132: {
                                break :block_132 value_9;
                            };

                            if ((operand_134 >= (operand_133).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_135 (operand_133)[@intCast(operand_134)];
                        };

                        break :block_137 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_136));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_141: {
                        const operand_139 = ((state_105).plan).mapping;

                        const operand_140 = block_138: {
                            break :block_138 value_9;
                        };

                        if ((operand_140 >= (operand_139).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_141 (operand_139)[@intCast(operand_140)];
                    } != @as(u64, 0)))) block_162: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_161: {
                            const operand_160 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_160).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_159: {
                                const operand_155 = block_154: {
                                    const operand_149 = (state_105).request;
                                    const operand_150 = (state_105).plan;
                                    const operand_151 = (state_105).modules;
                                    const operand_152 = (state_105).natives;
                                    const operand_153 = (state_105).index;

                                    break :block_154 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_149, .state = operand_150, .modules = operand_151, .natives = operand_152, .index = operand_153, });
                                };
                                var state_borrow_156: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_156 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_155).modules).identities, .import_names = ((operand_155).modules).import_names, .specifiers = ((operand_155).modules).specifiers, .type_ids = ((operand_155).modules).type_ids, .type_names = ((operand_155).modules).type_names, .type_namespaces = ((operand_155).modules).type_namespaces, };

                                var state_borrow_157: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_157 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_155).request).maximum_count, .names = ((operand_155).request).names, .origins = ((operand_155).request).origins, .roots = ((operand_155).request).roots, .scalar_count = ((operand_155).request).scalar_count, .table = ((operand_155).request).table, };

                                var state_borrow_158: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_158 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_155).index, .modules = (((operand_155).modules).zx_origin orelse (&state_borrow_156)), .natives = (operand_155).natives, .request = (((operand_155).request).zx_origin orelse (&state_borrow_157)), .state = (operand_155).state, };

                                break :block_159 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_155).zx_origin orelse (&state_borrow_158)), .{ .lane_0 = .{ .buffer = (&state_capacity_114), .started = (&state_capacity_started_115), }, .lane_1 = .{ .buffer = (&state_capacity_116), .started = (&state_capacity_started_117), }, .lane_2 = .{ .buffer = (&state_capacity_118), .started = (&state_capacity_started_119), }, .lane_3 = .{ .buffer = (&state_capacity_120), .started = (&state_capacity_started_121), }, .lane_4 = .{ .buffer = (&state_capacity_122), .started = (&state_capacity_started_123), }, }));
                            });

                            break :block_161 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_160);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_105;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_148: {
                            break :block_148 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_147: {
                                break :block_147 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_146: {
                            break :block_146 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_145: {
                                break :block_145 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_144: {
                            break :block_144 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_143: {
                                break :block_143 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_142: {
                            break :block_142 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_162 value_19;
                    } else block_165: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_105;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_164: {
                            break :block_164 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_163: {
                                break :block_163 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_165 value_22;
                    });

                    break :block_172 value_23;
                });

                break :block_176 value_24;
            };
        }

        var state_owned_177: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_177);

        if (state_capacity_started_115) {
            ((state_capacity_114).items).len = (((state_105).natives).mapping).len;
            state_owned_177 = (try (state_capacity_114).toOwnedSlice(allocator));
        }

        if (state_capacity_started_115) {
            state_105 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_105).index, .member = (state_105).member, .modules = (state_105).modules, .natives = block_179: {
                const operand_178 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_178).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_105).natives).count, .mapping = state_owned_177, .order = ((state_105).natives).order, });

                break :block_179 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_178);
            }, .plan = (state_105).plan, .request = (state_105).request, };
        }

        var state_owned_180: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_180);

        if (state_capacity_started_117) {
            ((state_capacity_116).items).len = (((state_105).natives).order).len;
            state_owned_180 = (try (state_capacity_116).toOwnedSlice(allocator));
        }

        if (state_capacity_started_117) {
            state_105 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_105).index, .member = (state_105).member, .modules = (state_105).modules, .natives = block_182: {
                const operand_181 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_181).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_105).natives).count, .mapping = ((state_105).natives).mapping, .order = state_owned_180, });

                break :block_182 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_181);
            }, .plan = (state_105).plan, .request = (state_105).request, };
        }

        var state_owned_183: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_183);

        if (state_capacity_started_119) {
            ((state_capacity_118).items).len = (((state_105).plan).mapping).len;
            state_owned_183 = (try (state_capacity_118).toOwnedSlice(allocator));
        }

        if (state_capacity_started_119) {
            state_105 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_105).index, .member = (state_105).member, .modules = (state_105).modules, .natives = (state_105).natives, .plan = block_185: {
                const operand_184 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_184).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_105).plan).count, .mapping = state_owned_183, .order = ((state_105).plan).order, .origins = ((state_105).plan).origins, .status = ((state_105).plan).status, });

                break :block_185 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_184);
            }, .request = (state_105).request, };
        }

        var state_owned_186: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_186);

        if (state_capacity_started_121) {
            ((state_capacity_120).items).len = (((state_105).plan).order).len;
            state_owned_186 = (try (state_capacity_120).toOwnedSlice(allocator));
        }

        if (state_capacity_started_121) {
            state_105 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_105).index, .member = (state_105).member, .modules = (state_105).modules, .natives = (state_105).natives, .plan = block_188: {
                const operand_187 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_187).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_105).plan).count, .mapping = ((state_105).plan).mapping, .order = state_owned_186, .origins = ((state_105).plan).origins, .status = ((state_105).plan).status, });

                break :block_188 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_187);
            }, .request = (state_105).request, };
        }

        var state_owned_189: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_189);

        if (state_capacity_started_123) {
            ((state_capacity_122).items).len = (((state_105).plan).origins).len;
            state_owned_189 = (try (state_capacity_122).toOwnedSlice(allocator));
        }

        if (state_capacity_started_123) {
            state_105 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_105).index, .member = (state_105).member, .modules = (state_105).modules, .natives = (state_105).natives, .plan = block_191: {
                const operand_190 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_190).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_105).plan).count, .mapping = ((state_105).plan).mapping, .order = ((state_105).plan).order, .origins = state_owned_189, .status = ((state_105).plan).status, });

                break :block_191 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_190);
            }, .request = (state_105).request, };
        }

        break :block_198 block_197: {
            break :block_197 (if (((state_105).zx_origin != null)) ((state_105).zx_origin.?).* else block_196: {
                break :block_196 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_105).index, .member = (state_105).member, .modules = (if ((((state_105).modules).zx_origin != null)) ((state_105).modules).zx_origin.? else block_193: {
                    const operand_192 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_192).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_105).modules).identities, .import_names = ((state_105).modules).import_names, .specifiers = ((state_105).modules).specifiers, .type_ids = ((state_105).modules).type_ids, .type_names = ((state_105).modules).type_names, .type_namespaces = ((state_105).modules).type_namespaces, };

                    break :block_193 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_192);
                }), .natives = (state_105).natives, .plan = (state_105).plan, .request = (if ((((state_105).request).zx_origin != null)) ((state_105).request).zx_origin.? else block_195: {
                    const operand_194 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_194).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_105).request).maximum_count, .names = ((state_105).request).names, .origins = ((state_105).request).origins, .roots = ((state_105).request).roots, .scalar_count = ((state_105).request).scalar_count, .table = ((state_105).request).table, };

                    break :block_195 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_194);
                }), };
            });
        };
    };

    return block_104: {
        const operand_102 = ((&value_25)).plan;
        const operand_103 = ((&value_25)).natives;

        break :block_104 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_102, .natives = operand_103, };
    };
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, buffers: struct {
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

    const value_25: (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_270: {
        const operand_210 = block_209: {
            const operand_203 = (in).request;
            const operand_204 = (in).state;
            const operand_205 = (in).modules;
            const operand_206 = (in).natives;
            const operand_207 = @as(u64, 0);
            const operand_208 = @as(u64, 0);

            break :block_209 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_203, .plan = operand_204, .modules = operand_205, .natives = operand_206, .index = operand_207, .member = operand_208, };
        };

        var state_202: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_210).index, .member = (operand_210).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_210).modules).identities, .import_names = ((operand_210).modules).import_names, .specifiers = ((operand_210).modules).specifiers, .type_ids = ((operand_210).modules).type_ids, .type_names = ((operand_210).modules).type_names, .type_namespaces = ((operand_210).modules).type_namespaces, .zx_origin = (operand_210).modules, }, .natives = (operand_210).natives, .plan = (operand_210).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_210).request).maximum_count, .names = ((operand_210).request).names, .origins = ((operand_210).request).origins, .roots = ((operand_210).request).roots, .scalar_count = ((operand_210).request).scalar_count, .table = ((operand_210).request).table, .zx_origin = (operand_210).request, }, .zx_origin = (&operand_210), };

        while (((((state_202).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_202).index < @as(u64, (((state_202).modules).specifiers).len)))) {
            state_202 = block_263: {
                const value_3: []const u32 = block_262: {
                    const operand_260 = ((state_202).modules).type_ids;
                    const operand_261 = (state_202).index;

                    if ((operand_261 >= (operand_260).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_262 (operand_260)[@intCast(operand_261)];
                };
                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_213: {
                    const operand_211 = ((state_202).natives).mapping;
                    const operand_212 = (state_202).index;

                    if ((operand_212 >= (operand_211).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_213 (operand_211)[@intCast(operand_212)];
                } != @as(u64, 0)) or ((state_202).member >= @as(u64, (block_214: {
                    break :block_214 value_3;
                }).len)))) block_218: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_202;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_217: {
                        break :block_217 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_216: {
                            break :block_216 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_215: {
                        break :block_215 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_218 value_8;
                } else block_259: {
                    const value_9: u64 = block_258: {
                        const operand_257 = block_256: {
                            const operand_254 = block_253: {
                                break :block_253 value_3;
                            };

                            const operand_255 = (state_202).member;

                            if ((operand_255 >= (operand_254).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_256 (operand_254)[@intCast(operand_255)];
                        };

                        break :block_258 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_257));
                    };
                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_224: {
                        const operand_223 = block_222: {
                            const operand_220 = (((state_202).request).table).kinds;

                            const operand_221 = block_219: {
                                break :block_219 value_9;
                            };

                            if ((operand_221 >= (operand_220).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_222 (operand_220)[@intCast(operand_221)];
                        };

                        break :block_224 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_223));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_228: {
                        const operand_226 = ((state_202).plan).mapping;

                        const operand_227 = block_225: {
                            break :block_225 value_9;
                        };

                        if ((operand_227 >= (operand_226).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_228 (operand_226)[@intCast(operand_227)];
                    } != @as(u64, 0)))) block_249: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_248: {
                            const operand_247 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_247).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_246: {
                                const operand_242 = block_241: {
                                    const operand_236 = (state_202).request;
                                    const operand_237 = (state_202).plan;
                                    const operand_238 = (state_202).modules;
                                    const operand_239 = (state_202).natives;
                                    const operand_240 = (state_202).index;

                                    break :block_241 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_236, .state = operand_237, .modules = operand_238, .natives = operand_239, .index = operand_240, });
                                };
                                var state_borrow_243: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;

                                state_borrow_243 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_242).modules).identities, .import_names = ((operand_242).modules).import_names, .specifiers = ((operand_242).modules).specifiers, .type_ids = ((operand_242).modules).type_ids, .type_names = ((operand_242).modules).type_names, .type_namespaces = ((operand_242).modules).type_namespaces, };

                                var state_borrow_244: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_244 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_242).request).maximum_count, .names = ((operand_242).request).names, .origins = ((operand_242).request).origins, .roots = ((operand_242).request).roots, .scalar_count = ((operand_242).request).scalar_count, .table = ((operand_242).request).table, };

                                var state_borrow_245: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_245 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_242).index, .modules = (((operand_242).modules).zx_origin orelse (&state_borrow_243)), .natives = (operand_242).natives, .request = (((operand_242).request).zx_origin orelse (&state_borrow_244)), .state = (operand_242).state, };

                                break :block_246 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_242).zx_origin orelse (&state_borrow_245)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_248 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_247);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_202;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_235: {
                            break :block_235 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_234: {
                                break :block_234 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_233: {
                            break :block_233 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_232: {
                                break :block_232 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_231: {
                            break :block_231 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_230: {
                                break :block_230 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_229: {
                            break :block_229 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_249 value_19;
                    } else block_252: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_202;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_251: {
                            break :block_251 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_250: {
                                break :block_250 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_252 value_22;
                    });

                    break :block_259 value_23;
                });

                break :block_263 value_24;
            };
        }

        break :block_270 block_269: {
            break :block_269 (if (((state_202).zx_origin != null)) ((state_202).zx_origin.?).* else block_268: {
                break :block_268 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_202).index, .member = (state_202).member, .modules = (if ((((state_202).modules).zx_origin != null)) ((state_202).modules).zx_origin.? else block_265: {
                    const operand_264 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_264).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_202).modules).identities, .import_names = ((state_202).modules).import_names, .specifiers = ((state_202).modules).specifiers, .type_ids = ((state_202).modules).type_ids, .type_names = ((state_202).modules).type_names, .type_namespaces = ((state_202).modules).type_namespaces, };

                    break :block_265 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_264);
                }), .natives = (state_202).natives, .plan = (state_202).plan, .request = (if ((((state_202).request).zx_origin != null)) ((state_202).request).zx_origin.? else block_267: {
                    const operand_266 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_266).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_202).request).maximum_count, .names = ((state_202).request).names, .origins = ((state_202).request).origins, .roots = ((state_202).request).roots, .scalar_count = ((state_202).request).scalar_count, .table = ((state_202).request).table, };

                    break :block_267 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_266);
                }), };
            });
        };
    };

    return block_201: {
        const operand_199 = ((&value_25)).plan;
        const operand_200 = ((&value_25)).natives;

        break :block_201 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_199, .natives = operand_200, };
    };
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, buffers: struct {
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

    const value_25: *const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_356: {
        const operand_286 = block_285: {
            const operand_277 = (in).request;
            const operand_278 = (in).state;
            const operand_279 = (in).modules;
            const operand_280 = (in).natives;
            const operand_281 = @as(u64, 0);
            const operand_282 = @as(u64, 0);

            break :block_285 block_284: {
                const operand_283 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_283).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_277, .plan = operand_278, .modules = operand_279, .natives = operand_280, .index = operand_281, .member = operand_282, });

                break :block_284 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_283);
            };
        };
        const state_type_291 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };
        const state_type_292 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_293 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_294 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_295 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_296 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_294,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_295,
        };
        const state_type_297 = struct {
            index: u64,
            member: u64,
            modules: state_type_291,
            natives: state_type_292,
            plan: state_type_293,
            request: state_type_296,
        };
        const state_type_311 = struct {
            index: u64,
            modules: state_type_291,
            natives: state_type_292,
            request: state_type_296,
            state: state_type_293,
        };
        const state_type_328 = struct {
            natives: state_type_292,
            state: state_type_293,
        };

        var state_276: state_type_297 = state_type_297{ .index = (operand_286).index, .member = (operand_286).member, .modules = state_type_291{ .identities = ((operand_286).modules).identities, .import_names = ((operand_286).modules).import_names, .specifiers = ((operand_286).modules).specifiers, .type_ids = ((operand_286).modules).type_ids, .type_names = ((operand_286).modules).type_names, .type_namespaces = ((operand_286).modules).type_namespaces, }, .natives = state_type_292{ .count = ((operand_286).natives).count, .mapping = ((operand_286).natives).mapping, .order = ((operand_286).natives).order, }, .plan = state_type_293{ .count = ((operand_286).plan).count, .mapping = ((operand_286).plan).mapping, .order = ((operand_286).plan).order, .origins = ((operand_286).plan).origins, .status = ((operand_286).plan).status, }, .request = state_type_296{ .maximum_count = ((operand_286).request).maximum_count, .names = ((operand_286).request).names, .origins = state_type_294{ .ids = (((operand_286).request).origins).ids, .kinds = (((operand_286).request).origins).kinds, .members = (((operand_286).request).origins).members, .owners = (((operand_286).request).origins).owners, }, .roots = ((operand_286).request).roots, .scalar_count = ((operand_286).request).scalar_count, .table = state_type_295{ .children = (((operand_286).request).table).children, .field_names = (((operand_286).request).table).field_names, .field_types = (((operand_286).request).table).field_types, .first = (((operand_286).request).table).first, .kinds = (((operand_286).request).table).kinds, .labels = (((operand_286).request).table).labels, .names = (((operand_286).request).table).names, .second = (((operand_286).request).table).second, }, }, };
        var state_changed_287 = false;

        while (((((state_276).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_276).index < @as(u64, (((state_276).modules).specifiers).len)))) {
            state_276 = block_340: {
                const value_3: []const u32 = block_339: {
                    const operand_337 = ((state_276).modules).type_ids;
                    const operand_338 = (state_276).index;

                    if ((operand_338 >= (operand_337).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_339 (operand_337)[@intCast(operand_338)];
                };
                const value_24: state_type_297 = (if (((block_290: {
                    const operand_288 = ((state_276).natives).mapping;
                    const operand_289 = (state_276).index;

                    if ((operand_289 >= (operand_288).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_290 (operand_288)[@intCast(operand_289)];
                } != @as(u64, 0)) or ((state_276).member >= @as(u64, (value_3).len)))) block_300: {
                    const value_4: state_type_297 = state_276;
                    const value_5: u64 = (value_4).index;

                    const value_6: state_type_297 = block_299: {
                        break :block_299 state_type_297{ .index = (value_5 + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, };
                    };
                    const value_7: state_type_297 = value_6;

                    const value_8: state_type_297 = block_298: {
                        break :block_298 state_type_297{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, };
                    };

                    break :block_300 value_8;
                } else block_336: {
                    const value_9: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_335: {
                        const operand_333 = value_3;
                        const operand_334 = (state_276).member;

                        if ((operand_334 >= (operand_333).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_335 (operand_333)[@intCast(operand_334)];
                    }));

                    const value_23: state_type_297 = (if ((((try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_303: {
                        const operand_301 = (((state_276).request).table).kinds;
                        const operand_302 = value_9;

                        if ((operand_302 >= (operand_301).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_303 (operand_301)[@intCast(operand_302)];
                    })) == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_306: {
                        const operand_304 = ((state_276).plan).mapping;
                        const operand_305 = value_9;

                        if ((operand_305 >= (operand_304).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_306 (operand_304)[@intCast(operand_305)];
                    } != @as(u64, 0)))) block_330: {
                        const value_10: state_type_328 = block_329: {
                            const operand_318 = block_317: {
                                const operand_312 = (state_276).request;
                                const operand_313 = (state_276).plan;
                                const operand_314 = (state_276).modules;
                                const operand_315 = (state_276).natives;
                                const operand_316 = (state_276).index;

                                break :block_317 state_type_311{ .request = operand_312, .state = operand_313, .modules = operand_314, .natives = operand_315, .index = operand_316, };
                            };

                            const operand_319 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_318).modules).identities, .import_names = ((operand_318).modules).import_names, .specifiers = ((operand_318).modules).specifiers, .type_ids = ((operand_318).modules).type_ids, .type_names = ((operand_318).modules).type_names, .type_namespaces = ((operand_318).modules).type_namespaces, };
                            const operand_320 = (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((operand_318).natives).count, .mapping = ((operand_318).natives).mapping, .order = ((operand_318).natives).order, };
                            const operand_321 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_318).request).origins).ids, .kinds = (((operand_318).request).origins).kinds, .members = (((operand_318).request).origins).members, .owners = (((operand_318).request).origins).owners, };
                            const operand_322 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_318).request).table).children, .field_names = (((operand_318).request).table).field_names, .field_types = (((operand_318).request).table).field_types, .first = (((operand_318).request).table).first, .kinds = (((operand_318).request).table).kinds, .labels = (((operand_318).request).table).labels, .names = (((operand_318).request).table).names, .second = (((operand_318).request).table).second, };
                            const operand_323 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_318).request).maximum_count, .names = ((operand_318).request).names, .origins = (&operand_321), .roots = ((operand_318).request).roots, .scalar_count = ((operand_318).request).scalar_count, .table = (&operand_322), };
                            const operand_324 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_318).state).count, .mapping = ((operand_318).state).mapping, .order = ((operand_318).state).order, .origins = ((operand_318).state).origins, .status = ((operand_318).state).status, };
                            const operand_325 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_318).index, .modules = (&operand_319), .natives = (&operand_320), .request = (&operand_323), .state = (&operand_324), };

                            const operand_327 = block_326: {
                                break :block_326 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, (&operand_325), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            };

                            break :block_329 state_type_328{ .natives = state_type_292{ .count = ((operand_327).natives).count, .mapping = ((operand_327).natives).mapping, .order = ((operand_327).natives).order, }, .state = state_type_293{ .count = ((operand_327).state).count, .mapping = ((operand_327).state).mapping, .order = ((operand_327).state).order, .origins = ((operand_327).state).origins, .status = ((operand_327).state).status, }, };
                        };
                        const value_11: state_type_297 = state_276;

                        const value_12: state_type_297 = block_310: {
                            break :block_310 state_type_297{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (value_10).state, .request = (value_11).request, };
                        };
                        const value_13: state_type_297 = value_12;

                        const value_14: state_type_297 = block_309: {
                            break :block_309 state_type_297{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (value_10).natives, .plan = (value_13).plan, .request = (value_13).request, };
                        };
                        const value_15: state_type_297 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: state_type_297 = block_308: {
                            break :block_308 state_type_297{ .index = (value_16 + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, };
                        };
                        const value_18: state_type_297 = value_17;

                        const value_19: state_type_297 = block_307: {
                            break :block_307 state_type_297{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, };
                        };

                        break :block_330 value_19;
                    } else block_332: {
                        const value_20: state_type_297 = state_276;
                        const value_21: u64 = (value_20).member;

                        const value_22: state_type_297 = block_331: {
                            break :block_331 state_type_297{ .index = (value_20).index, .member = (value_21 + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_332 value_22;
                    });

                    break :block_336 value_23;
                });

                break :block_340 value_24;
            };

            state_changed_287 = true;
        }

        break :block_356 (if (state_changed_287) block_355: {
            const operand_354 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

            (operand_354).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_276).index, .member = (state_276).member, .modules = block_343: {
                const operand_342 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_342).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_276).modules).identities, .import_names = ((state_276).modules).import_names, .specifiers = ((state_276).modules).specifiers, .type_ids = ((state_276).modules).type_ids, .type_names = ((state_276).modules).type_names, .type_namespaces = ((state_276).modules).type_namespaces, });

                break :block_343 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_342);
            }, .natives = block_345: {
                const operand_344 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_344).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_276).natives).count, .mapping = ((state_276).natives).mapping, .order = ((state_276).natives).order, });

                break :block_345 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_344);
            }, .plan = block_347: {
                const operand_346 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_346).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_276).plan).count, .mapping = ((state_276).plan).mapping, .order = ((state_276).plan).order, .origins = ((state_276).plan).origins, .status = ((state_276).plan).status, });

                break :block_347 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_346);
            }, .request = block_353: {
                const operand_352 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_352).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_276).request).maximum_count, .names = ((state_276).request).names, .origins = block_349: {
                    const operand_348 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_348).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_276).request).origins).ids, .kinds = (((state_276).request).origins).kinds, .members = (((state_276).request).origins).members, .owners = (((state_276).request).origins).owners, });

                    break :block_349 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_348);
                }, .roots = ((state_276).request).roots, .scalar_count = ((state_276).request).scalar_count, .table = block_351: {
                    const operand_350 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_350).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_276).request).table).children, .field_names = (((state_276).request).table).field_names, .field_types = (((state_276).request).table).field_types, .first = (((state_276).request).table).first, .kinds = (((state_276).request).table).kinds, .labels = (((state_276).request).table).labels, .names = (((state_276).request).table).names, .second = (((state_276).request).table).second, });

                    break :block_351 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_350);
                }, });

                break :block_353 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_352);
            }, });

            break :block_355 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_354);
        } else operand_286);
    };

    return block_275: {
        const operand_271 = (value_25).plan;
        const operand_272 = (value_25).natives;

        break :block_275 block_274: {
            const operand_273 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_273).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_271, .natives = operand_272, });

            break :block_274 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_273);
        };
    };
}

