const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e {
    @setRuntimeSafety(true);

    const value_31: *const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad = block_96: {
        const operand_17 = block_16: {
            const operand_7 = (in).request;
            const operand_8 = (in).state;
            const operand_9 = (in).modules;
            const operand_10 = (in).selected;
            const operand_11 = @as(u64, 0);
            const operand_12 = @as(u64, 0);
            const operand_13 = false;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad));

                (operand_14).* = @as((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad{ .request = operand_7, .plan = operand_8, .modules = operand_9, .selected = operand_10, .index = operand_11, .member = operand_12, .including = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, operand_14);
            };
        };

        var state_capacity_19: (std).ArrayList(u64) = .empty;
        var state_capacity_started_20 = false;

        defer (state_capacity_19).deinit(allocator);

        var state_capacity_21: (std).ArrayList(u32) = .empty;
        var state_capacity_started_22 = false;

        defer (state_capacity_21).deinit(allocator);

        var state_capacity_23: (std).ArrayList(u64) = .empty;
        var state_capacity_started_24 = false;

        defer (state_capacity_23).deinit(allocator);

        var state_items_25: []bool = undefined;
        var state_items_started_26 = false;

        const state_type_27 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };

        const state_type_28 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_29 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_30 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_31 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_29,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_30,
        };
        const state_type_32 = struct {
            including: bool,
            index: u64,
            member: u64,
            modules: state_type_27,
            plan: state_type_28,
            request: state_type_31,
            selected: []const bool,
        };
        const state_type_38 = struct {
            index: u64,
            request: state_type_31,
            state: state_type_28,
        };

        var state_6: state_type_32 = state_type_32{ .including = (operand_17).including, .index = (operand_17).index, .member = (operand_17).member, .modules = state_type_27{ .identities = ((operand_17).modules).identities, .import_names = ((operand_17).modules).import_names, .specifiers = ((operand_17).modules).specifiers, .type_ids = ((operand_17).modules).type_ids, .type_names = ((operand_17).modules).type_names, .type_namespaces = ((operand_17).modules).type_namespaces, }, .plan = state_type_28{ .count = ((operand_17).plan).count, .mapping = ((operand_17).plan).mapping, .order = ((operand_17).plan).order, .origins = ((operand_17).plan).origins, .status = ((operand_17).plan).status, }, .request = state_type_31{ .maximum_count = ((operand_17).request).maximum_count, .names = ((operand_17).request).names, .origins = state_type_29{ .ids = (((operand_17).request).origins).ids, .kinds = (((operand_17).request).origins).kinds, .members = (((operand_17).request).origins).members, .owners = (((operand_17).request).origins).owners, }, .roots = ((operand_17).request).roots, .scalar_count = ((operand_17).request).scalar_count, .table = state_type_30{ .children = (((operand_17).request).table).children, .field_names = (((operand_17).request).table).field_names, .field_types = (((operand_17).request).table).field_types, .first = (((operand_17).request).table).first, .kinds = (((operand_17).request).table).kinds, .labels = (((operand_17).request).table).labels, .names = (((operand_17).request).table).names, .second = (((operand_17).request).table).second, }, }, .selected = (operand_17).selected, };
        var state_changed_18 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).index < @as(u64, (((state_6).modules).specifiers).len)))) {
            state_6 = block_79: {
                const value_3: []const u32 = block_78: {
                    const operand_76 = ((state_6).modules).type_ids;
                    const operand_77 = (state_6).index;

                    if ((operand_77 >= (operand_76).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_78 (operand_76)[@intCast(operand_77)];
                };

                const value_30: state_type_32 = (if (((state_6).member >= @as(u64, (value_3).len))) block_36: {
                    const value_4: state_type_32 = state_6;
                    const value_5: u64 = (value_4).index;

                    const value_6: state_type_32 = block_35: {
                        break :block_35 state_type_32{ .including = (value_4).including, .index = (value_5 + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .plan = (value_4).plan, .request = (value_4).request, .selected = (value_4).selected, };
                    };
                    const value_7: state_type_32 = value_6;

                    const value_8: state_type_32 = block_34: {
                        break :block_34 state_type_32{ .including = (value_7).including, .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .plan = (value_7).plan, .request = (value_7).request, .selected = (value_7).selected, };
                    };
                    const value_9: state_type_32 = value_8;

                    const value_10: state_type_32 = block_33: {
                        break :block_33 state_type_32{ .including = false, .index = (value_9).index, .member = (value_9).member, .modules = (value_9).modules, .plan = (value_9).plan, .request = (value_9).request, .selected = (value_9).selected, };
                    };

                    break :block_36 value_10;
                } else block_75: {
                    const value_11: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_74: {
                        const operand_72 = value_3;
                        const operand_73 = (state_6).member;

                        if ((operand_73 >= (operand_72).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_74 (operand_72)[@intCast(operand_73)];
                    }));

                    const value_29: state_type_32 = (if ((state_6).including) block_53: {
                        const value_12: state_type_32 = state_6;
                        const value_13: state_type_32 = block_52: {
                            break :block_52 state_type_32{ .including = (value_12).including, .index = (value_12).index, .member = (value_12).member, .modules = (value_12).modules, .plan = block_51: {
                                const operand_43 = block_42: {
                                    const operand_39 = (state_6).request;
                                    const operand_40 = (state_6).plan;
                                    const operand_41 = value_11;

                                    break :block_42 state_type_38{ .request = operand_39, .state = operand_40, .index = operand_41, };
                                };

                                const operand_44 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_43).request).origins).ids, .kinds = (((operand_43).request).origins).kinds, .members = (((operand_43).request).origins).members, .owners = (((operand_43).request).origins).owners, };
                                const operand_45 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_43).request).table).children, .field_names = (((operand_43).request).table).field_names, .field_types = (((operand_43).request).table).field_types, .first = (((operand_43).request).table).first, .kinds = (((operand_43).request).table).kinds, .labels = (((operand_43).request).table).labels, .names = (((operand_43).request).table).names, .second = (((operand_43).request).table).second, };
                                const operand_46 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_43).request).maximum_count, .names = ((operand_43).request).names, .origins = (&operand_44), .roots = ((operand_43).request).roots, .scalar_count = ((operand_43).request).scalar_count, .table = (&operand_45), };
                                const operand_47 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_43).state).count, .mapping = ((operand_43).state).mapping, .order = ((operand_43).state).order, .origins = ((operand_43).state).origins, .status = ((operand_43).state).status, };
                                const operand_48 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_43).index, .request = (&operand_46), .state = (&operand_47), };

                                const operand_50 = block_49: {
                                    break :block_49 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_48), .{ .lane_0 = .{ .buffer = (&state_capacity_19), .started = (&state_capacity_started_20), }, .lane_1 = .{ .buffer = (&state_capacity_21), .started = (&state_capacity_started_22), }, .lane_2 = .{ .buffer = (&state_capacity_23), .started = (&state_capacity_started_24), }, }));
                                };

                                break :block_51 state_type_28{ .count = (operand_50).count, .mapping = (operand_50).mapping, .order = (operand_50).order, .origins = (operand_50).origins, .status = (operand_50).status, };
                            }, .request = (value_12).request, .selected = (value_12).selected, };
                        };
                        const value_14: state_type_32 = value_13;
                        const value_15: u64 = (value_14).member;

                        const value_16: state_type_32 = block_37: {
                            break :block_37 state_type_32{ .including = (value_14).including, .index = (value_14).index, .member = (value_15 + @as(u64, 1)), .modules = (value_14).modules, .plan = (value_14).plan, .request = (value_14).request, .selected = (value_14).selected, };
                        };

                        break :block_53 value_16;
                    } else block_71: {
                        const value_28: state_type_32 = (if ((((try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_56: {
                            const operand_54 = (((state_6).request).table).kinds;
                            const operand_55 = value_11;

                            if ((operand_55 >= (operand_54).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_56 (operand_54)[@intCast(operand_55)];
                        })) == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_59: {
                            const operand_57 = ((state_6).plan).mapping;
                            const operand_58 = value_11;

                            if ((operand_58 >= (operand_57).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_59 (operand_57)[@intCast(operand_58)];
                        } != @as(u64, 0)))) block_68: {
                            const value_17: state_type_32 = state_6;
                            const value_18: []const bool = (value_17).selected;
                            const value_19: u64 = (state_6).index;
                            const value_20: state_type_32 = block_67: {
                                break :block_67 state_type_32{ .including = (value_17).including, .index = (value_17).index, .member = (value_17).member, .modules = (value_17).modules, .plan = (value_17).plan, .request = (value_17).request, .selected = block_66: {
                                    const operand_62 = value_18;
                                    const operand_63 = value_19;

                                    if ((operand_63 >= (operand_62).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_64 = true;

                                    break :block_66 block_65: {
                                        if ((!state_items_started_26)) {
                                            state_items_25 = (try (allocator).dupe(bool, operand_62));
                                            state_items_started_26 = true;
                                        }

                                        (state_items_25)[@intCast(operand_63)] = operand_64;

                                        break :block_65 state_items_25;
                                    };
                                }, };
                            };
                            const value_21: state_type_32 = value_20;

                            const value_22: state_type_32 = block_61: {
                                break :block_61 state_type_32{ .including = true, .index = (value_21).index, .member = (value_21).member, .modules = (value_21).modules, .plan = (value_21).plan, .request = (value_21).request, .selected = (value_21).selected, };
                            };
                            const value_23: state_type_32 = value_22;

                            const value_24: state_type_32 = block_60: {
                                break :block_60 state_type_32{ .including = (value_23).including, .index = (value_23).index, .member = @as(u64, 0), .modules = (value_23).modules, .plan = (value_23).plan, .request = (value_23).request, .selected = (value_23).selected, };
                            };

                            break :block_68 value_24;
                        } else block_70: {
                            const value_25: state_type_32 = state_6;
                            const value_26: u64 = (value_25).member;

                            const value_27: state_type_32 = block_69: {
                                break :block_69 state_type_32{ .including = (value_25).including, .index = (value_25).index, .member = (value_26 + @as(u64, 1)), .modules = (value_25).modules, .plan = (value_25).plan, .request = (value_25).request, .selected = (value_25).selected, };
                            };

                            break :block_70 value_27;
                        });

                        break :block_71 value_28;
                    });

                    break :block_75 value_29;
                });

                break :block_79 value_30;
            };

            state_changed_18 = true;
        }

        var state_owned_80: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_80);

        if (state_capacity_started_20) {
            ((state_capacity_19).items).len = (((state_6).plan).mapping).len;
            state_owned_80 = (try (state_capacity_19).toOwnedSlice(allocator));
        }

        if (state_capacity_started_20) {
            ((state_6).plan).mapping = state_owned_80;
        }

        var state_owned_81: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_81);

        if (state_capacity_started_22) {
            ((state_capacity_21).items).len = (((state_6).plan).order).len;
            state_owned_81 = (try (state_capacity_21).toOwnedSlice(allocator));
        }

        if (state_capacity_started_22) {
            ((state_6).plan).order = state_owned_81;
        }

        var state_owned_82: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_82);

        if (state_capacity_started_24) {
            ((state_capacity_23).items).len = (((state_6).plan).origins).len;
            state_owned_82 = (try (state_capacity_23).toOwnedSlice(allocator));
        }

        if (state_capacity_started_24) {
            ((state_6).plan).origins = state_owned_82;
        }

        break :block_96 (if (state_changed_18) block_95: {
            const operand_94 = (try (allocator).create((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad));

            (operand_94).* = @as((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad{ .including = (state_6).including, .index = (state_6).index, .member = (state_6).member, .modules = block_85: {
                const operand_84 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_84).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_6).modules).identities, .import_names = ((state_6).modules).import_names, .specifiers = ((state_6).modules).specifiers, .type_ids = ((state_6).modules).type_ids, .type_names = ((state_6).modules).type_names, .type_namespaces = ((state_6).modules).type_namespaces, });

                break :block_85 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_84);
            }, .plan = block_87: {
                const operand_86 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_86).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_87 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_86);
            }, .request = block_93: {
                const operand_92 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_92).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = block_89: {
                    const operand_88 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_88).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_6).request).origins).ids, .kinds = (((state_6).request).origins).kinds, .members = (((state_6).request).origins).members, .owners = (((state_6).request).origins).owners, });

                    break :block_89 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_88);
                }, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = block_91: {
                    const operand_90 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_90).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_6).request).table).children, .field_names = (((state_6).request).table).field_names, .field_types = (((state_6).request).table).field_types, .first = (((state_6).request).table).first, .kinds = (((state_6).request).table).kinds, .labels = (((state_6).request).table).labels, .names = (((state_6).request).table).names, .second = (((state_6).request).table).second, });

                    break :block_91 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_90);
                }, });

                break :block_93 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_92);
            }, .selected = (state_6).selected, });

            break :block_95 @as(*const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, operand_94);
        } else operand_17);
    };

    return block_5: {
        const operand_1 = (value_31).plan;
        const operand_2 = (value_31).selected;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

            (operand_3).* = @as((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .state = operand_1, .selected = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_3);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_31: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_186: {
        const operand_109 = block_108: {
            const operand_101 = (in).request;
            const operand_102 = (in).state;
            const operand_103 = (in).modules;
            const operand_104 = (in).selected;
            const operand_105 = @as(u64, 0);
            const operand_106 = @as(u64, 0);
            const operand_107 = false;

            break :block_108 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .request = operand_101, .plan = operand_102, .modules = operand_103, .selected = operand_104, .index = operand_105, .member = operand_106, .including = operand_107, });
        };

        var state_capacity_111: (std).ArrayList(u64) = .empty;
        var state_capacity_started_112 = false;

        defer (state_capacity_111).deinit(allocator);

        var state_capacity_113: (std).ArrayList(u32) = .empty;
        var state_capacity_started_114 = false;

        defer (state_capacity_113).deinit(allocator);

        var state_capacity_115: (std).ArrayList(u64) = .empty;
        var state_capacity_started_116 = false;

        defer (state_capacity_115).deinit(allocator);

        var state_items_117: []bool = undefined;
        var state_items_started_118 = false;
        var state_100: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = operand_109;
        var state_changed_110 = false;

        while (((((state_100).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_100).index < @as(u64, (((state_100).modules).specifiers).len)))) {
            state_100 = block_175: {
                const value_3: []const u32 = block_174: {
                    const operand_172 = ((state_100).modules).type_ids;
                    const operand_173 = (state_100).index;

                    if ((operand_173 >= (operand_172).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_174 (operand_172)[@intCast(operand_173)];
                };

                const value_30: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if (((state_100).member >= @as(u64, (block_119: {
                    break :block_119 value_3;
                }).len))) block_124: {
                    const value_4: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_100;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_123: {
                        break :block_123 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_4).including, .index = (block_122: {
                            break :block_122 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .plan = (value_4).plan, .request = (value_4).request, .selected = (value_4).selected, });
                    };

                    const value_7: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_6;

                    const value_8: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_121: {
                        break :block_121 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_7).including, .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .plan = (value_7).plan, .request = (value_7).request, .selected = (value_7).selected, });
                    };
                    const value_9: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_8;

                    const value_10: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_120: {
                        break :block_120 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = false, .index = (value_9).index, .member = (value_9).member, .modules = (value_9).modules, .plan = (value_9).plan, .request = (value_9).request, .selected = (value_9).selected, });
                    };

                    break :block_124 value_10;
                } else block_171: {
                    const value_11: u64 = block_170: {
                        const operand_169 = block_168: {
                            const operand_166 = block_165: {
                                break :block_165 value_3;
                            };

                            const operand_167 = (state_100).member;

                            if ((operand_167 >= (operand_166).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_168 (operand_166)[@intCast(operand_167)];
                        };

                        break :block_170 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_169));
                    };
                    const value_29: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if ((state_100).including) block_139: {
                        const value_12: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_100;

                        const value_13: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_138: {
                            break :block_138 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_12).including, .index = (value_12).index, .member = (value_12).member, .modules = (value_12).modules, .plan = block_137: {
                                const operand_136 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                (operand_136).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_135: {
                                    const operand_132 = block_131: {
                                        const operand_127 = (state_100).request;
                                        const operand_128 = (state_100).plan;
                                        const operand_129 = block_130: {
                                            break :block_130 value_11;
                                        };

                                        break :block_131 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_127, .state = operand_128, .index = operand_129, });
                                    };
                                    var state_borrow_133: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                    state_borrow_133 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_132).request).maximum_count, .names = ((operand_132).request).names, .origins = ((operand_132).request).origins, .roots = ((operand_132).request).roots, .scalar_count = ((operand_132).request).scalar_count, .table = ((operand_132).request).table, };

                                    var state_borrow_134: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                    state_borrow_134 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_132).index, .request = (((operand_132).request).zx_origin orelse (&state_borrow_133)), .state = (operand_132).state, };

                                    break :block_135 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_132).zx_origin orelse (&state_borrow_134)), .{ .lane_0 = .{ .buffer = (&state_capacity_111), .started = (&state_capacity_started_112), }, .lane_1 = .{ .buffer = (&state_capacity_113), .started = (&state_capacity_started_114), }, .lane_2 = .{ .buffer = (&state_capacity_115), .started = (&state_capacity_started_116), }, }));
                                });

                                break :block_137 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_136);
                            }, .request = (value_12).request, .selected = (value_12).selected, });
                        };

                        const value_14: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_13;
                        const value_15: u64 = (value_14).member;

                        const value_16: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_126: {
                            break :block_126 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_14).including, .index = (value_14).index, .member = (block_125: {
                                break :block_125 value_15;
                            } + @as(u64, 1)), .modules = (value_14).modules, .plan = (value_14).plan, .request = (value_14).request, .selected = (value_14).selected, });
                        };

                        break :block_139 value_16;
                    } else block_164: {
                        const value_28: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if (((block_145: {
                            const operand_144 = block_143: {
                                const operand_141 = (((state_100).request).table).kinds;

                                const operand_142 = block_140: {
                                    break :block_140 value_11;
                                };

                                if ((operand_142 >= (operand_141).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_143 (operand_141)[@intCast(operand_142)];
                            };

                            break :block_145 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_144));
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_149: {
                            const operand_147 = ((state_100).plan).mapping;

                            const operand_148 = block_146: {
                                break :block_146 value_11;
                            };

                            if ((operand_148 >= (operand_147).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_149 (operand_147)[@intCast(operand_148)];
                        } != @as(u64, 0)))) block_160: {
                            const value_17: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_100;
                            const value_18: []const bool = (value_17).selected;
                            const value_19: u64 = (state_100).index;

                            const value_20: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_159: {
                                break :block_159 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_17).including, .index = (value_17).index, .member = (value_17).member, .modules = (value_17).modules, .plan = (value_17).plan, .request = (value_17).request, .selected = block_158: {
                                    const operand_153 = block_152: {
                                        break :block_152 value_18;
                                    };
                                    const operand_155 = block_154: {
                                        break :block_154 value_19;
                                    };

                                    if ((operand_155 >= (operand_153).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_156 = true;

                                    break :block_158 block_157: {
                                        if ((!state_items_started_118)) {
                                            state_items_117 = (try (allocator).dupe(bool, operand_153));
                                            state_items_started_118 = true;
                                        }

                                        (state_items_117)[@intCast(operand_155)] = operand_156;

                                        break :block_157 state_items_117;
                                    };
                                }, });
                            };
                            const value_21: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_20;

                            const value_22: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_151: {
                                break :block_151 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = true, .index = (value_21).index, .member = (value_21).member, .modules = (value_21).modules, .plan = (value_21).plan, .request = (value_21).request, .selected = (value_21).selected, });
                            };
                            const value_23: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_22;

                            const value_24: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_150: {
                                break :block_150 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_23).including, .index = (value_23).index, .member = @as(u64, 0), .modules = (value_23).modules, .plan = (value_23).plan, .request = (value_23).request, .selected = (value_23).selected, });
                            };

                            break :block_160 value_24;
                        } else block_163: {
                            const value_25: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_100;
                            const value_26: u64 = (value_25).member;

                            const value_27: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_162: {
                                break :block_162 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_25).including, .index = (value_25).index, .member = (block_161: {
                                    break :block_161 value_26;
                                } + @as(u64, 1)), .modules = (value_25).modules, .plan = (value_25).plan, .request = (value_25).request, .selected = (value_25).selected, });
                            };

                            break :block_163 value_27;
                        });

                        break :block_164 value_28;
                    });

                    break :block_171 value_29;
                });

                break :block_175 value_30;
            };

            state_changed_110 = true;
        }

        var state_owned_176: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_176);

        if (state_capacity_started_112) {
            ((state_capacity_111).items).len = (((state_100).plan).mapping).len;
            state_owned_176 = (try (state_capacity_111).toOwnedSlice(allocator));
        }

        if (state_capacity_started_112) {
            state_100 = (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (state_100).including, .index = (state_100).index, .member = (state_100).member, .modules = (state_100).modules, .plan = block_178: {
                const operand_177 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_177).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_100).plan).count, .mapping = state_owned_176, .order = ((state_100).plan).order, .origins = ((state_100).plan).origins, .status = ((state_100).plan).status, });

                break :block_178 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_177);
            }, .request = (state_100).request, .selected = (state_100).selected, };
        }

        var state_owned_179: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_179);

        if (state_capacity_started_114) {
            ((state_capacity_113).items).len = (((state_100).plan).order).len;
            state_owned_179 = (try (state_capacity_113).toOwnedSlice(allocator));
        }

        if (state_capacity_started_114) {
            state_100 = (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (state_100).including, .index = (state_100).index, .member = (state_100).member, .modules = (state_100).modules, .plan = block_181: {
                const operand_180 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_180).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_100).plan).count, .mapping = ((state_100).plan).mapping, .order = state_owned_179, .origins = ((state_100).plan).origins, .status = ((state_100).plan).status, });

                break :block_181 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_180);
            }, .request = (state_100).request, .selected = (state_100).selected, };
        }

        var state_owned_182: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_182);

        if (state_capacity_started_116) {
            ((state_capacity_115).items).len = (((state_100).plan).origins).len;
            state_owned_182 = (try (state_capacity_115).toOwnedSlice(allocator));
        }

        if (state_capacity_started_116) {
            state_100 = (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (state_100).including, .index = (state_100).index, .member = (state_100).member, .modules = (state_100).modules, .plan = block_184: {
                const operand_183 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_183).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_100).plan).count, .mapping = ((state_100).plan).mapping, .order = ((state_100).plan).order, .origins = state_owned_182, .status = ((state_100).plan).status, });

                break :block_184 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_183);
            }, .request = (state_100).request, .selected = (state_100).selected, };
        }

        break :block_186 (if (state_changed_110) state_100 else operand_109);
    };

    return block_99: {
        const operand_97 = (value_31).plan;
        const operand_98 = (value_31).selected;

        break :block_99 @as((zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .state = operand_97, .selected = operand_98, });
    };
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_31: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_263: {
        const operand_199 = block_198: {
            const operand_191 = (in).request;
            const operand_192 = (in).state;
            const operand_193 = (in).modules;
            const operand_194 = (in).selected;
            const operand_195 = @as(u64, 0);
            const operand_196 = @as(u64, 0);
            const operand_197 = false;

            break :block_198 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .request = operand_191, .plan = operand_192, .modules = operand_193, .selected = operand_194, .index = operand_195, .member = operand_196, .including = operand_197, });
        };

        var state_capacity_201: (std).ArrayList(bool) = .empty;
        var state_capacity_started_202 = false;

        defer (state_capacity_201).deinit(allocator);

        var state_190: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = operand_199;
        var state_changed_200 = false;

        while (((((state_190).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_190).index < @as(u64, (((state_190).modules).specifiers).len)))) {
            state_190 = block_260: {
                const value_3: []const u32 = block_259: {
                    const operand_257 = ((state_190).modules).type_ids;
                    const operand_258 = (state_190).index;

                    if ((operand_258 >= (operand_257).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_259 (operand_257)[@intCast(operand_258)];
                };

                const value_30: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if (((state_190).member >= @as(u64, (block_203: {
                    break :block_203 value_3;
                }).len))) block_208: {
                    const value_4: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_190;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_207: {
                        break :block_207 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_4).including, .index = (block_206: {
                            break :block_206 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .plan = (value_4).plan, .request = (value_4).request, .selected = (value_4).selected, });
                    };

                    const value_7: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_6;

                    const value_8: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_205: {
                        break :block_205 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_7).including, .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .plan = (value_7).plan, .request = (value_7).request, .selected = (value_7).selected, });
                    };
                    const value_9: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_8;

                    const value_10: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_204: {
                        break :block_204 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = false, .index = (value_9).index, .member = (value_9).member, .modules = (value_9).modules, .plan = (value_9).plan, .request = (value_9).request, .selected = (value_9).selected, });
                    };

                    break :block_208 value_10;
                } else block_256: {
                    const value_11: u64 = block_255: {
                        const operand_254 = block_253: {
                            const operand_251 = block_250: {
                                break :block_250 value_3;
                            };

                            const operand_252 = (state_190).member;

                            if ((operand_252 >= (operand_251).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_253 (operand_251)[@intCast(operand_252)];
                        };

                        break :block_255 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_254));
                    };
                    const value_29: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if ((state_190).including) block_223: {
                        const value_12: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_190;

                        const value_13: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_222: {
                            break :block_222 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_12).including, .index = (value_12).index, .member = (value_12).member, .modules = (value_12).modules, .plan = block_221: {
                                const operand_220 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                (operand_220).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_219: {
                                    const operand_216 = block_215: {
                                        const operand_211 = (state_190).request;
                                        const operand_212 = (state_190).plan;
                                        const operand_213 = block_214: {
                                            break :block_214 value_11;
                                        };

                                        break :block_215 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_211, .state = operand_212, .index = operand_213, });
                                    };
                                    var state_borrow_217: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                    state_borrow_217 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_216).request).maximum_count, .names = ((operand_216).request).names, .origins = ((operand_216).request).origins, .roots = ((operand_216).request).roots, .scalar_count = ((operand_216).request).scalar_count, .table = ((operand_216).request).table, };

                                    var state_borrow_218: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                    state_borrow_218 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_216).index, .request = (((operand_216).request).zx_origin orelse (&state_borrow_217)), .state = (operand_216).state, };

                                    break :block_219 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_216).zx_origin orelse (&state_borrow_218)), .{ .lane_0 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_1 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_2 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), }));
                                });

                                break :block_221 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_220);
                            }, .request = (value_12).request, .selected = (value_12).selected, });
                        };

                        const value_14: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_13;
                        const value_15: u64 = (value_14).member;

                        const value_16: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_210: {
                            break :block_210 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_14).including, .index = (value_14).index, .member = (block_209: {
                                break :block_209 value_15;
                            } + @as(u64, 1)), .modules = (value_14).modules, .plan = (value_14).plan, .request = (value_14).request, .selected = (value_14).selected, });
                        };

                        break :block_223 value_16;
                    } else block_249: {
                        const value_28: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = (if (((block_229: {
                            const operand_228 = block_227: {
                                const operand_225 = (((state_190).request).table).kinds;

                                const operand_226 = block_224: {
                                    break :block_224 value_11;
                                };

                                if ((operand_226 >= (operand_225).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_227 (operand_225)[@intCast(operand_226)];
                            };

                            break :block_229 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_228));
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_233: {
                            const operand_231 = ((state_190).plan).mapping;

                            const operand_232 = block_230: {
                                break :block_230 value_11;
                            };

                            if ((operand_232 >= (operand_231).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_233 (operand_231)[@intCast(operand_232)];
                        } != @as(u64, 0)))) block_245: {
                            const value_17: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_190;
                            const value_18: []const bool = (value_17).selected;
                            const value_19: u64 = (state_190).index;
                            const value_20: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_244: {
                                break :block_244 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_17).including, .index = (value_17).index, .member = (value_17).member, .modules = (value_17).modules, .plan = (value_17).plan, .request = (value_17).request, .selected = block_243: {
                                    const operand_237 = block_236: {
                                        break :block_236 value_18;
                                    };
                                    const operand_239 = block_238: {
                                        break :block_238 value_19;
                                    };

                                    if ((operand_239 >= (operand_237).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_240 = true;

                                    break :block_243 @as([]const bool, (if (((buffers).lane_0 != null)) block_241: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_237));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_237).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_239)] = operand_240;

                                        break :block_241 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_242: {
                                        if ((!state_capacity_started_202)) {
                                            (try (state_capacity_201).appendSlice(allocator, operand_237));
                                            state_capacity_started_202 = true;
                                        } else {
                                            ((state_capacity_201).items).len = (operand_237).len;
                                        }

                                        ((state_capacity_201).items)[@intCast(operand_239)] = operand_240;

                                        break :block_242 (state_capacity_201).items;
                                    }));
                                }, });
                            };
                            const value_21: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_20;

                            const value_22: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_235: {
                                break :block_235 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = true, .index = (value_21).index, .member = (value_21).member, .modules = (value_21).modules, .plan = (value_21).plan, .request = (value_21).request, .selected = (value_21).selected, });
                            };
                            const value_23: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = value_22;

                            const value_24: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_234: {
                                break :block_234 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_23).including, .index = (value_23).index, .member = @as(u64, 0), .modules = (value_23).modules, .plan = (value_23).plan, .request = (value_23).request, .selected = (value_23).selected, });
                            };

                            break :block_245 value_24;
                        } else block_248: {
                            const value_25: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = state_190;
                            const value_26: u64 = (value_25).member;

                            const value_27: (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = block_247: {
                                break :block_247 @as((zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd, (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (value_25).including, .index = (value_25).index, .member = (block_246: {
                                    break :block_246 value_26;
                                } + @as(u64, 1)), .modules = (value_25).modules, .plan = (value_25).plan, .request = (value_25).request, .selected = (value_25).selected, });
                            };

                            break :block_248 value_27;
                        });

                        break :block_249 value_28;
                    });

                    break :block_256 value_29;
                });

                break :block_260 value_30;
            };

            state_changed_200 = true;
        }

        var state_owned_261: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_261);

        if (state_capacity_started_202) {
            ((state_capacity_201).items).len = ((state_190).selected).len;
            state_owned_261 = (try (state_capacity_201).toOwnedSlice(allocator));
        }

        if (state_capacity_started_202) {
            state_190 = (zx_abi).value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd{ .including = (state_190).including, .index = (state_190).index, .member = (state_190).member, .modules = (state_190).modules, .plan = (state_190).plan, .request = (state_190).request, .selected = state_owned_261, };
        }

        break :block_263 (if (state_changed_200) state_190 else operand_199);
    };

    return block_189: {
        const operand_187 = (value_31).plan;
        const operand_188 = (value_31).selected;

        break :block_189 @as((zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .state = operand_187, .selected = operand_188, });
    };
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e {
    @setRuntimeSafety(true);

    const value_31: *const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad = block_352: {
        const operand_280 = block_279: {
            const operand_270 = (in).request;
            const operand_271 = (in).state;
            const operand_272 = (in).modules;
            const operand_273 = (in).selected;
            const operand_274 = @as(u64, 0);
            const operand_275 = @as(u64, 0);
            const operand_276 = false;

            break :block_279 block_278: {
                const operand_277 = (try (allocator).create((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad));

                (operand_277).* = @as((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad{ .request = operand_270, .plan = operand_271, .modules = operand_272, .selected = operand_273, .index = operand_274, .member = operand_275, .including = operand_276, });

                break :block_278 @as(*const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, operand_277);
            };
        };

        var state_capacity_282: (std).ArrayList(bool) = .empty;
        var state_capacity_started_283 = false;

        defer (state_capacity_282).deinit(allocator);

        const state_type_284 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };
        const state_type_285 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_286 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_287 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_288 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_286,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_287,
        };
        const state_type_289 = struct {
            including: bool,
            index: u64,
            member: u64,
            modules: state_type_284,
            plan: state_type_285,
            request: state_type_288,
            selected: []const bool,
        };
        const state_type_295 = struct {
            index: u64,
            request: state_type_288,
            state: state_type_285,
        };

        var state_269: state_type_289 = state_type_289{ .including = (operand_280).including, .index = (operand_280).index, .member = (operand_280).member, .modules = state_type_284{ .identities = ((operand_280).modules).identities, .import_names = ((operand_280).modules).import_names, .specifiers = ((operand_280).modules).specifiers, .type_ids = ((operand_280).modules).type_ids, .type_names = ((operand_280).modules).type_names, .type_namespaces = ((operand_280).modules).type_namespaces, }, .plan = state_type_285{ .count = ((operand_280).plan).count, .mapping = ((operand_280).plan).mapping, .order = ((operand_280).plan).order, .origins = ((operand_280).plan).origins, .status = ((operand_280).plan).status, }, .request = state_type_288{ .maximum_count = ((operand_280).request).maximum_count, .names = ((operand_280).request).names, .origins = state_type_286{ .ids = (((operand_280).request).origins).ids, .kinds = (((operand_280).request).origins).kinds, .members = (((operand_280).request).origins).members, .owners = (((operand_280).request).origins).owners, }, .roots = ((operand_280).request).roots, .scalar_count = ((operand_280).request).scalar_count, .table = state_type_287{ .children = (((operand_280).request).table).children, .field_names = (((operand_280).request).table).field_names, .field_types = (((operand_280).request).table).field_types, .first = (((operand_280).request).table).first, .kinds = (((operand_280).request).table).kinds, .labels = (((operand_280).request).table).labels, .names = (((operand_280).request).table).names, .second = (((operand_280).request).table).second, }, }, .selected = (operand_280).selected, };
        var state_changed_281 = false;

        while (((((state_269).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_269).index < @as(u64, (((state_269).modules).specifiers).len)))) {
            state_269 = block_337: {
                const value_3: []const u32 = block_336: {
                    const operand_334 = ((state_269).modules).type_ids;
                    const operand_335 = (state_269).index;

                    if ((operand_335 >= (operand_334).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_336 (operand_334)[@intCast(operand_335)];
                };

                const value_30: state_type_289 = (if (((state_269).member >= @as(u64, (value_3).len))) block_293: {
                    const value_4: state_type_289 = state_269;
                    const value_5: u64 = (value_4).index;

                    const value_6: state_type_289 = block_292: {
                        break :block_292 state_type_289{ .including = (value_4).including, .index = (value_5 + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .plan = (value_4).plan, .request = (value_4).request, .selected = (value_4).selected, };
                    };
                    const value_7: state_type_289 = value_6;

                    const value_8: state_type_289 = block_291: {
                        break :block_291 state_type_289{ .including = (value_7).including, .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .plan = (value_7).plan, .request = (value_7).request, .selected = (value_7).selected, };
                    };
                    const value_9: state_type_289 = value_8;

                    const value_10: state_type_289 = block_290: {
                        break :block_290 state_type_289{ .including = false, .index = (value_9).index, .member = (value_9).member, .modules = (value_9).modules, .plan = (value_9).plan, .request = (value_9).request, .selected = (value_9).selected, };
                    };

                    break :block_293 value_10;
                } else block_333: {
                    const value_11: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_332: {
                        const operand_330 = value_3;
                        const operand_331 = (state_269).member;

                        if ((operand_331 >= (operand_330).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_332 (operand_330)[@intCast(operand_331)];
                    }));

                    const value_29: state_type_289 = (if ((state_269).including) block_310: {
                        const value_12: state_type_289 = state_269;
                        const value_13: state_type_289 = block_309: {
                            break :block_309 state_type_289{ .including = (value_12).including, .index = (value_12).index, .member = (value_12).member, .modules = (value_12).modules, .plan = block_308: {
                                const operand_300 = block_299: {
                                    const operand_296 = (state_269).request;
                                    const operand_297 = (state_269).plan;
                                    const operand_298 = value_11;

                                    break :block_299 state_type_295{ .request = operand_296, .state = operand_297, .index = operand_298, };
                                };

                                const operand_301 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_300).request).origins).ids, .kinds = (((operand_300).request).origins).kinds, .members = (((operand_300).request).origins).members, .owners = (((operand_300).request).origins).owners, };
                                const operand_302 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_300).request).table).children, .field_names = (((operand_300).request).table).field_names, .field_types = (((operand_300).request).table).field_types, .first = (((operand_300).request).table).first, .kinds = (((operand_300).request).table).kinds, .labels = (((operand_300).request).table).labels, .names = (((operand_300).request).table).names, .second = (((operand_300).request).table).second, };
                                const operand_303 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_300).request).maximum_count, .names = ((operand_300).request).names, .origins = (&operand_301), .roots = ((operand_300).request).roots, .scalar_count = ((operand_300).request).scalar_count, .table = (&operand_302), };
                                const operand_304 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_300).state).count, .mapping = ((operand_300).state).mapping, .order = ((operand_300).state).order, .origins = ((operand_300).state).origins, .status = ((operand_300).state).status, };
                                const operand_305 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_300).index, .request = (&operand_303), .state = (&operand_304), };

                                const operand_307 = block_306: {
                                    break :block_306 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_305), .{ .lane_0 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_1 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_2 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), }));
                                };

                                break :block_308 state_type_285{ .count = (operand_307).count, .mapping = (operand_307).mapping, .order = (operand_307).order, .origins = (operand_307).origins, .status = (operand_307).status, };
                            }, .request = (value_12).request, .selected = (value_12).selected, };
                        };
                        const value_14: state_type_289 = value_13;
                        const value_15: u64 = (value_14).member;

                        const value_16: state_type_289 = block_294: {
                            break :block_294 state_type_289{ .including = (value_14).including, .index = (value_14).index, .member = (value_15 + @as(u64, 1)), .modules = (value_14).modules, .plan = (value_14).plan, .request = (value_14).request, .selected = (value_14).selected, };
                        };

                        break :block_310 value_16;
                    } else block_329: {
                        const value_28: state_type_289 = (if ((((try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_313: {
                            const operand_311 = (((state_269).request).table).kinds;
                            const operand_312 = value_11;

                            if ((operand_312 >= (operand_311).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_313 (operand_311)[@intCast(operand_312)];
                        })) == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_316: {
                            const operand_314 = ((state_269).plan).mapping;
                            const operand_315 = value_11;

                            if ((operand_315 >= (operand_314).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_316 (operand_314)[@intCast(operand_315)];
                        } != @as(u64, 0)))) block_326: {
                            const value_17: state_type_289 = state_269;
                            const value_18: []const bool = (value_17).selected;
                            const value_19: u64 = (state_269).index;
                            const value_20: state_type_289 = block_325: {
                                break :block_325 state_type_289{ .including = (value_17).including, .index = (value_17).index, .member = (value_17).member, .modules = (value_17).modules, .plan = (value_17).plan, .request = (value_17).request, .selected = block_324: {
                                    const operand_319 = value_18;
                                    const operand_320 = value_19;

                                    if ((operand_320 >= (operand_319).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_321 = true;

                                    break :block_324 @as([]const bool, (if (((buffers).lane_0 != null)) block_322: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_319));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_319).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_320)] = operand_321;

                                        break :block_322 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_323: {
                                        if ((!state_capacity_started_283)) {
                                            (try (state_capacity_282).appendSlice(allocator, operand_319));
                                            state_capacity_started_283 = true;
                                        } else {
                                            ((state_capacity_282).items).len = (operand_319).len;
                                        }

                                        ((state_capacity_282).items)[@intCast(operand_320)] = operand_321;

                                        break :block_323 (state_capacity_282).items;
                                    }));
                                }, };
                            };
                            const value_21: state_type_289 = value_20;

                            const value_22: state_type_289 = block_318: {
                                break :block_318 state_type_289{ .including = true, .index = (value_21).index, .member = (value_21).member, .modules = (value_21).modules, .plan = (value_21).plan, .request = (value_21).request, .selected = (value_21).selected, };
                            };
                            const value_23: state_type_289 = value_22;

                            const value_24: state_type_289 = block_317: {
                                break :block_317 state_type_289{ .including = (value_23).including, .index = (value_23).index, .member = @as(u64, 0), .modules = (value_23).modules, .plan = (value_23).plan, .request = (value_23).request, .selected = (value_23).selected, };
                            };

                            break :block_326 value_24;
                        } else block_328: {
                            const value_25: state_type_289 = state_269;
                            const value_26: u64 = (value_25).member;

                            const value_27: state_type_289 = block_327: {
                                break :block_327 state_type_289{ .including = (value_25).including, .index = (value_25).index, .member = (value_26 + @as(u64, 1)), .modules = (value_25).modules, .plan = (value_25).plan, .request = (value_25).request, .selected = (value_25).selected, };
                            };

                            break :block_328 value_27;
                        });

                        break :block_329 value_28;
                    });

                    break :block_333 value_29;
                });

                break :block_337 value_30;
            };

            state_changed_281 = true;
        }

        var state_owned_338: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_338);

        if (state_capacity_started_283) {
            ((state_capacity_282).items).len = ((state_269).selected).len;
            state_owned_338 = (try (state_capacity_282).toOwnedSlice(allocator));
        }

        if (state_capacity_started_283) {
            (state_269).selected = state_owned_338;
        }

        break :block_352 (if (state_changed_281) block_351: {
            const operand_350 = (try (allocator).create((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad));

            (operand_350).* = @as((zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad{ .including = (state_269).including, .index = (state_269).index, .member = (state_269).member, .modules = block_341: {
                const operand_340 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_340).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_269).modules).identities, .import_names = ((state_269).modules).import_names, .specifiers = ((state_269).modules).specifiers, .type_ids = ((state_269).modules).type_ids, .type_names = ((state_269).modules).type_names, .type_namespaces = ((state_269).modules).type_namespaces, });

                break :block_341 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_340);
            }, .plan = block_343: {
                const operand_342 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_342).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_269).plan).count, .mapping = ((state_269).plan).mapping, .order = ((state_269).plan).order, .origins = ((state_269).plan).origins, .status = ((state_269).plan).status, });

                break :block_343 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_342);
            }, .request = block_349: {
                const operand_348 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_348).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_269).request).maximum_count, .names = ((state_269).request).names, .origins = block_345: {
                    const operand_344 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_344).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_269).request).origins).ids, .kinds = (((state_269).request).origins).kinds, .members = (((state_269).request).origins).members, .owners = (((state_269).request).origins).owners, });

                    break :block_345 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_344);
                }, .roots = ((state_269).request).roots, .scalar_count = ((state_269).request).scalar_count, .table = block_347: {
                    const operand_346 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_346).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_269).request).table).children, .field_names = (((state_269).request).table).field_names, .field_types = (((state_269).request).table).field_types, .first = (((state_269).request).table).first, .kinds = (((state_269).request).table).kinds, .labels = (((state_269).request).table).labels, .names = (((state_269).request).table).names, .second = (((state_269).request).table).second, });

                    break :block_347 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_346);
                }, });

                break :block_349 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_348);
            }, .selected = (state_269).selected, });

            break :block_351 @as(*const (zx_abi).zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad, operand_350);
        } else operand_280);
    };

    return block_268: {
        const operand_264 = (value_31).plan;
        const operand_265 = (value_31).selected;

        break :block_268 block_267: {
            const operand_266 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

            (operand_266).* = @as((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .state = operand_264, .selected = operand_265, });

            break :block_267 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_266);
        };
    };
}

