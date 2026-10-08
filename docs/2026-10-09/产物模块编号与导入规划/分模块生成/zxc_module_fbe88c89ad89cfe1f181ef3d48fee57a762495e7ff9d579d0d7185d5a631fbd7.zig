const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: *const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_56: {
        const operand_9 = block_8: {
            const operand_2 = (in).request;
            const operand_3 = (in).state;
            const operand_4 = (in).ids;
            const operand_5 = @as(u64, 0);

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

                (operand_6).* = @as((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_2, .plan = operand_3, .ids = operand_4, .index = operand_5, });

                break :block_7 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_6);
            };
        };

        var state_capacity_11: (std).ArrayList(u64) = .empty;
        var state_capacity_started_12 = false;

        defer (state_capacity_11).deinit(allocator);

        var state_capacity_13: (std).ArrayList(u32) = .empty;
        var state_capacity_started_14 = false;

        defer (state_capacity_13).deinit(allocator);

        var state_capacity_15: (std).ArrayList(u64) = .empty;
        var state_capacity_started_16 = false;

        defer (state_capacity_15).deinit(allocator);

        const state_type_17 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_18 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_19 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_20 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_18,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_19,
        };
        const state_type_21 = struct {
            ids: []const u32,
            index: u64,
            plan: state_type_17,
            request: state_type_20,
        };
        const state_type_23 = struct {
            index: u64,
            request: state_type_20,
            state: state_type_17,
        };

        var state_1: state_type_21 = state_type_21{ .ids = (operand_9).ids, .index = (operand_9).index, .plan = state_type_17{ .count = ((operand_9).plan).count, .mapping = ((operand_9).plan).mapping, .order = ((operand_9).plan).order, .origins = ((operand_9).plan).origins, .status = ((operand_9).plan).status, }, .request = state_type_20{ .maximum_count = ((operand_9).request).maximum_count, .names = ((operand_9).request).names, .origins = state_type_18{ .ids = (((operand_9).request).origins).ids, .kinds = (((operand_9).request).origins).kinds, .members = (((operand_9).request).origins).members, .owners = (((operand_9).request).origins).owners, }, .roots = ((operand_9).request).roots, .scalar_count = ((operand_9).request).scalar_count, .table = state_type_19{ .children = (((operand_9).request).table).children, .field_names = (((operand_9).request).table).field_names, .field_types = (((operand_9).request).table).field_types, .first = (((operand_9).request).table).first, .kinds = (((operand_9).request).table).kinds, .labels = (((operand_9).request).table).labels, .names = (((operand_9).request).table).names, .second = (((operand_9).request).table).second, }, }, };
        var state_changed_10 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_1).index < @as(u64, ((state_1).ids).len)))) {
            state_1 = block_41: {
                const value_3: state_type_21 = state_1;
                const value_4: state_type_21 = block_40: {
                    break :block_40 state_type_21{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_39: {
                        const operand_31 = block_30: {
                            const operand_24 = (state_1).request;
                            const operand_25 = (state_1).plan;

                            const operand_29 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_28: {
                                const operand_26 = (state_1).ids;
                                const operand_27 = (state_1).index;

                                if ((operand_27 >= (operand_26).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_28 (operand_26)[@intCast(operand_27)];
                            }));

                            break :block_30 state_type_23{ .request = operand_24, .state = operand_25, .index = operand_29, };
                        };

                        const operand_32 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_31).request).origins).ids, .kinds = (((operand_31).request).origins).kinds, .members = (((operand_31).request).origins).members, .owners = (((operand_31).request).origins).owners, };
                        const operand_33 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_31).request).table).children, .field_names = (((operand_31).request).table).field_names, .field_types = (((operand_31).request).table).field_types, .first = (((operand_31).request).table).first, .kinds = (((operand_31).request).table).kinds, .labels = (((operand_31).request).table).labels, .names = (((operand_31).request).table).names, .second = (((operand_31).request).table).second, };
                        const operand_34 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_31).request).maximum_count, .names = ((operand_31).request).names, .origins = (&operand_32), .roots = ((operand_31).request).roots, .scalar_count = ((operand_31).request).scalar_count, .table = (&operand_33), };
                        const operand_35 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_31).state).count, .mapping = ((operand_31).state).mapping, .order = ((operand_31).state).order, .origins = ((operand_31).state).origins, .status = ((operand_31).state).status, };
                        const operand_36 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_31).index, .request = (&operand_34), .state = (&operand_35), };

                        const operand_38 = block_37: {
                            break :block_37 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_36), .{ .lane_0 = .{ .buffer = (&state_capacity_11), .started = (&state_capacity_started_12), }, .lane_1 = .{ .buffer = (&state_capacity_13), .started = (&state_capacity_started_14), }, .lane_2 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, }));
                        };

                        break :block_39 state_type_17{ .count = (operand_38).count, .mapping = (operand_38).mapping, .order = (operand_38).order, .origins = (operand_38).origins, .status = (operand_38).status, };
                    }, .request = (value_3).request, };
                };

                const value_5: state_type_21 = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: state_type_21 = block_22: {
                    break :block_22 state_type_21{ .ids = (value_5).ids, .index = (value_6 + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, };
                };

                break :block_41 value_7;
            };

            state_changed_10 = true;
        }

        var state_owned_42: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_42);

        if (state_capacity_started_12) {
            ((state_capacity_11).items).len = (((state_1).plan).mapping).len;
            state_owned_42 = (try (state_capacity_11).toOwnedSlice(allocator));
        }

        if (state_capacity_started_12) {
            ((state_1).plan).mapping = state_owned_42;
        }

        var state_owned_43: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_43);

        if (state_capacity_started_14) {
            ((state_capacity_13).items).len = (((state_1).plan).order).len;
            state_owned_43 = (try (state_capacity_13).toOwnedSlice(allocator));
        }

        if (state_capacity_started_14) {
            ((state_1).plan).order = state_owned_43;
        }

        var state_owned_44: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_44);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).plan).origins).len;
            state_owned_44 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            ((state_1).plan).origins = state_owned_44;
        }

        break :block_56 (if (state_changed_10) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

            (operand_54).* = @as((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_1).ids, .index = (state_1).index, .plan = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_46).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_47 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_46);
            }, .request = block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_52).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = block_49: {
                    const operand_48 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_48).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_1).request).origins).ids, .kinds = (((state_1).request).origins).kinds, .members = (((state_1).request).origins).members, .owners = (((state_1).request).origins).owners, });

                    break :block_49 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_48);
                }, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_50).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_1).request).table).children, .field_names = (((state_1).request).table).field_names, .field_types = (((state_1).request).table).field_types, .first = (((state_1).request).table).first, .kinds = (((state_1).request).table).kinds, .labels = (((state_1).request).table).labels, .names = (((state_1).request).table).names, .second = (((state_1).request).table).second, });

                    break :block_51 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_50);
                }, });

                break :block_53 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_52);
            }, });

            break :block_55 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_54);
        } else operand_9);
    };

    return (value_8).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_102: {
        const operand_63 = block_62: {
            const operand_58 = (in).request;
            const operand_59 = (in).state;
            const operand_60 = (in).ids;
            const operand_61 = @as(u64, 0);

            break :block_62 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_58, .plan = operand_59, .ids = operand_60, .index = operand_61, };
        };

        var state_capacity_64: (std).ArrayList(u64) = .empty;
        var state_capacity_started_65 = false;

        defer (state_capacity_64).deinit(allocator);

        var state_capacity_66: (std).ArrayList(u32) = .empty;
        var state_capacity_started_67 = false;

        defer (state_capacity_66).deinit(allocator);

        var state_capacity_68: (std).ArrayList(u64) = .empty;
        var state_capacity_started_69 = false;

        defer (state_capacity_68).deinit(allocator);

        var state_57: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_63).ids, .index = (operand_63).index, .plan = (operand_63).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_63).request).maximum_count, .names = ((operand_63).request).names, .origins = ((operand_63).request).origins, .roots = ((operand_63).request).roots, .scalar_count = ((operand_63).request).scalar_count, .table = ((operand_63).request).table, .zx_origin = (operand_63).request, }, .zx_origin = (&operand_63), };

        while (((((state_57).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_57).index < @as(u64, ((state_57).ids).len)))) {
            state_57 = block_88: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_57;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_87: {
                    break :block_87 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_86: {
                        const operand_85 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_85).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_84: {
                            const operand_81 = block_80: {
                                const operand_72 = (state_57).request;
                                const operand_73 = (state_57).plan;
                                const operand_74 = block_79: {
                                    const operand_78 = block_77: {
                                        const operand_75 = (state_57).ids;
                                        const operand_76 = (state_57).index;

                                        if ((operand_76 >= (operand_75).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_77 (operand_75)[@intCast(operand_76)];
                                    };

                                    break :block_79 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_78));
                                };

                                break :block_80 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_72, .state = operand_73, .index = operand_74, });
                            };

                            var state_borrow_82: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_82 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_81).request).maximum_count, .names = ((operand_81).request).names, .origins = ((operand_81).request).origins, .roots = ((operand_81).request).roots, .scalar_count = ((operand_81).request).scalar_count, .table = ((operand_81).request).table, };

                            var state_borrow_83: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                            state_borrow_83 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_81).index, .request = (((operand_81).request).zx_origin orelse (&state_borrow_82)), .state = (operand_81).state, };

                            break :block_84 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_81).zx_origin orelse (&state_borrow_83)), .{ .lane_0 = .{ .buffer = (&state_capacity_64), .started = (&state_capacity_started_65), }, .lane_1 = .{ .buffer = (&state_capacity_66), .started = (&state_capacity_started_67), }, .lane_2 = .{ .buffer = (&state_capacity_68), .started = (&state_capacity_started_69), }, }));
                        });

                        break :block_86 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_85);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_71: {
                    break :block_71 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_70: {
                        break :block_70 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_88 value_7;
            };
        }

        var state_owned_89: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_89);

        if (state_capacity_started_65) {
            ((state_capacity_64).items).len = (((state_57).plan).mapping).len;
            state_owned_89 = (try (state_capacity_64).toOwnedSlice(allocator));
        }

        if (state_capacity_started_65) {
            state_57 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_57).ids, .index = (state_57).index, .plan = block_91: {
                const operand_90 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_90).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = state_owned_89, .order = ((state_57).plan).order, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_91 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_90);
            }, .request = (state_57).request, };
        }

        var state_owned_92: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_92);

        if (state_capacity_started_67) {
            ((state_capacity_66).items).len = (((state_57).plan).order).len;
            state_owned_92 = (try (state_capacity_66).toOwnedSlice(allocator));
        }

        if (state_capacity_started_67) {
            state_57 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_57).ids, .index = (state_57).index, .plan = block_94: {
                const operand_93 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_93).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = state_owned_92, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_94 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_93);
            }, .request = (state_57).request, };
        }

        var state_owned_95: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_95);

        if (state_capacity_started_69) {
            ((state_capacity_68).items).len = (((state_57).plan).origins).len;
            state_owned_95 = (try (state_capacity_68).toOwnedSlice(allocator));
        }

        if (state_capacity_started_69) {
            state_57 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_57).ids, .index = (state_57).index, .plan = block_97: {
                const operand_96 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_96).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = ((state_57).plan).order, .origins = state_owned_95, .status = ((state_57).plan).status, });

                break :block_97 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_96);
            }, .request = (state_57).request, };
        }

        break :block_102 block_101: {
            break :block_101 (if (((state_57).zx_origin != null)) ((state_57).zx_origin.?).* else block_100: {
                break :block_100 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_57).ids, .index = (state_57).index, .plan = (state_57).plan, .request = (if ((((state_57).request).zx_origin != null)) ((state_57).request).zx_origin.? else block_99: {
                    const operand_98 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_98).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_57).request).maximum_count, .names = ((state_57).request).names, .origins = ((state_57).request).origins, .roots = ((state_57).request).roots, .scalar_count = ((state_57).request).scalar_count, .table = ((state_57).request).table, };

                    break :block_99 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_98);
                }), };
            });
        };
    };

    return (((&value_8)).plan).*;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_133: {
        const operand_109 = block_108: {
            const operand_104 = (in).request;
            const operand_105 = (in).state;
            const operand_106 = (in).ids;
            const operand_107 = @as(u64, 0);

            break :block_108 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_104, .plan = operand_105, .ids = operand_106, .index = operand_107, };
        };

        var state_103: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_109).ids, .index = (operand_109).index, .plan = (operand_109).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_109).request).maximum_count, .names = ((operand_109).request).names, .origins = ((operand_109).request).origins, .roots = ((operand_109).request).roots, .scalar_count = ((operand_109).request).scalar_count, .table = ((operand_109).request).table, .zx_origin = (operand_109).request, }, .zx_origin = (&operand_109), };

        while (((((state_103).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_103).index < @as(u64, ((state_103).ids).len)))) {
            state_103 = block_128: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_103;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_127: {
                    break :block_127 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_126: {
                        const operand_125 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_125).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_124: {
                            const operand_121 = block_120: {
                                const operand_112 = (state_103).request;
                                const operand_113 = (state_103).plan;
                                const operand_114 = block_119: {
                                    const operand_118 = block_117: {
                                        const operand_115 = (state_103).ids;
                                        const operand_116 = (state_103).index;

                                        if ((operand_116 >= (operand_115).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_117 (operand_115)[@intCast(operand_116)];
                                    };

                                    break :block_119 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_118));
                                };

                                break :block_120 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_112, .state = operand_113, .index = operand_114, });
                            };
                            var state_borrow_122: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_122 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_121).request).maximum_count, .names = ((operand_121).request).names, .origins = ((operand_121).request).origins, .roots = ((operand_121).request).roots, .scalar_count = ((operand_121).request).scalar_count, .table = ((operand_121).request).table, };

                            var state_borrow_123: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                            state_borrow_123 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_121).index, .request = (((operand_121).request).zx_origin orelse (&state_borrow_122)), .state = (operand_121).state, };

                            break :block_124 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_121).zx_origin orelse (&state_borrow_123)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                        });

                        break :block_126 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_125);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_111: {
                    break :block_111 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_110: {
                        break :block_110 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_128 value_7;
            };
        }

        break :block_133 block_132: {
            break :block_132 (if (((state_103).zx_origin != null)) ((state_103).zx_origin.?).* else block_131: {
                break :block_131 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_103).ids, .index = (state_103).index, .plan = (state_103).plan, .request = (if ((((state_103).request).zx_origin != null)) ((state_103).request).zx_origin.? else block_130: {
                    const operand_129 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_129).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_103).request).maximum_count, .names = ((state_103).request).names, .origins = ((state_103).request).origins, .roots = ((state_103).request).roots, .scalar_count = ((state_103).request).scalar_count, .table = ((state_103).request).table, };

                    break :block_130 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_129);
                }), };
            });
        };
    };

    return (((&value_8)).plan).*;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: *const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_180: {
        const operand_142 = block_141: {
            const operand_135 = (in).request;
            const operand_136 = (in).state;
            const operand_137 = (in).ids;
            const operand_138 = @as(u64, 0);

            break :block_141 block_140: {
                const operand_139 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

                (operand_139).* = @as((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_135, .plan = operand_136, .ids = operand_137, .index = operand_138, });

                break :block_140 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_139);
            };
        };
        const state_type_144 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_145 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };

        const state_type_146 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_147 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_145,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_146,
        };
        const state_type_148 = struct {
            ids: []const u32,
            index: u64,
            plan: state_type_144,
            request: state_type_147,
        };
        const state_type_150 = struct {
            index: u64,
            request: state_type_147,
            state: state_type_144,
        };

        var state_134: state_type_148 = state_type_148{ .ids = (operand_142).ids, .index = (operand_142).index, .plan = state_type_144{ .count = ((operand_142).plan).count, .mapping = ((operand_142).plan).mapping, .order = ((operand_142).plan).order, .origins = ((operand_142).plan).origins, .status = ((operand_142).plan).status, }, .request = state_type_147{ .maximum_count = ((operand_142).request).maximum_count, .names = ((operand_142).request).names, .origins = state_type_145{ .ids = (((operand_142).request).origins).ids, .kinds = (((operand_142).request).origins).kinds, .members = (((operand_142).request).origins).members, .owners = (((operand_142).request).origins).owners, }, .roots = ((operand_142).request).roots, .scalar_count = ((operand_142).request).scalar_count, .table = state_type_146{ .children = (((operand_142).request).table).children, .field_names = (((operand_142).request).table).field_names, .field_types = (((operand_142).request).table).field_types, .first = (((operand_142).request).table).first, .kinds = (((operand_142).request).table).kinds, .labels = (((operand_142).request).table).labels, .names = (((operand_142).request).table).names, .second = (((operand_142).request).table).second, }, }, };
        var state_changed_143 = false;

        while (((((state_134).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_134).index < @as(u64, ((state_134).ids).len)))) {
            state_134 = block_168: {
                const value_3: state_type_148 = state_134;

                const value_4: state_type_148 = block_167: {
                    break :block_167 state_type_148{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_166: {
                        const operand_158 = block_157: {
                            const operand_151 = (state_134).request;
                            const operand_152 = (state_134).plan;

                            const operand_156 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_155: {
                                const operand_153 = (state_134).ids;
                                const operand_154 = (state_134).index;

                                if ((operand_154 >= (operand_153).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_155 (operand_153)[@intCast(operand_154)];
                            }));

                            break :block_157 state_type_150{ .request = operand_151, .state = operand_152, .index = operand_156, };
                        };

                        const operand_159 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_158).request).origins).ids, .kinds = (((operand_158).request).origins).kinds, .members = (((operand_158).request).origins).members, .owners = (((operand_158).request).origins).owners, };
                        const operand_160 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_158).request).table).children, .field_names = (((operand_158).request).table).field_names, .field_types = (((operand_158).request).table).field_types, .first = (((operand_158).request).table).first, .kinds = (((operand_158).request).table).kinds, .labels = (((operand_158).request).table).labels, .names = (((operand_158).request).table).names, .second = (((operand_158).request).table).second, };
                        const operand_161 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_158).request).maximum_count, .names = ((operand_158).request).names, .origins = (&operand_159), .roots = ((operand_158).request).roots, .scalar_count = ((operand_158).request).scalar_count, .table = (&operand_160), };
                        const operand_162 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_158).state).count, .mapping = ((operand_158).state).mapping, .order = ((operand_158).state).order, .origins = ((operand_158).state).origins, .status = ((operand_158).state).status, };
                        const operand_163 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_158).index, .request = (&operand_161), .state = (&operand_162), };

                        const operand_165 = block_164: {
                            break :block_164 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_163), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                        };

                        break :block_166 state_type_144{ .count = (operand_165).count, .mapping = (operand_165).mapping, .order = (operand_165).order, .origins = (operand_165).origins, .status = (operand_165).status, };
                    }, .request = (value_3).request, };
                };

                const value_5: state_type_148 = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: state_type_148 = block_149: {
                    break :block_149 state_type_148{ .ids = (value_5).ids, .index = (value_6 + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, };
                };

                break :block_168 value_7;
            };

            state_changed_143 = true;
        }

        break :block_180 (if (state_changed_143) block_179: {
            const operand_178 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

            (operand_178).* = @as((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_134).ids, .index = (state_134).index, .plan = block_171: {
                const operand_170 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_170).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_134).plan).count, .mapping = ((state_134).plan).mapping, .order = ((state_134).plan).order, .origins = ((state_134).plan).origins, .status = ((state_134).plan).status, });

                break :block_171 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_170);
            }, .request = block_177: {
                const operand_176 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_176).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_134).request).maximum_count, .names = ((state_134).request).names, .origins = block_173: {
                    const operand_172 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_172).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_134).request).origins).ids, .kinds = (((state_134).request).origins).kinds, .members = (((state_134).request).origins).members, .owners = (((state_134).request).origins).owners, });

                    break :block_173 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_172);
                }, .roots = ((state_134).request).roots, .scalar_count = ((state_134).request).scalar_count, .table = block_175: {
                    const operand_174 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_174).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_134).request).table).children, .field_names = (((state_134).request).table).field_names, .field_types = (((state_134).request).table).field_types, .first = (((state_134).request).table).first, .kinds = (((state_134).request).table).kinds, .labels = (((state_134).request).table).labels, .names = (((state_134).request).table).names, .second = (((state_134).request).table).second, });

                    break :block_175 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_174);
                }, });

                break :block_177 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_176);
            }, });

            break :block_179 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_178);
        } else operand_142);
    };

    return (value_8).plan;
}

