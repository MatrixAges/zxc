const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_9: *const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_56: {
        const operand_8 = block_7: {
            const operand_2 = (in).request;
            const operand_3 = (in).state;
            const operand_4 = @as(u64, 0);

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

                (operand_5).* = @as((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_2, .plan = operand_3, .index = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_5);
            };
        };

        var state_capacity_10: (std).ArrayList(u64) = .empty;
        var state_capacity_started_11 = false;

        defer (state_capacity_10).deinit(allocator);

        var state_capacity_12: (std).ArrayList(u32) = .empty;
        var state_capacity_started_13 = false;

        defer (state_capacity_12).deinit(allocator);

        var state_capacity_14: (std).ArrayList(u64) = .empty;
        var state_capacity_started_15 = false;

        defer (state_capacity_14).deinit(allocator);

        const state_type_16 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_17 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_18 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_19 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_17,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_18,
        };
        const state_type_20 = struct {
            index: u64,
            plan: state_type_16,
            request: state_type_19,
        };
        const state_type_25 = struct {
            index: u64,
            request: state_type_19,
            state: state_type_16,
        };

        var state_1: state_type_20 = state_type_20{ .index = (operand_8).index, .plan = state_type_16{ .count = ((operand_8).plan).count, .mapping = ((operand_8).plan).mapping, .order = ((operand_8).plan).order, .origins = ((operand_8).plan).origins, .status = ((operand_8).plan).status, }, .request = state_type_19{ .maximum_count = ((operand_8).request).maximum_count, .names = ((operand_8).request).names, .origins = state_type_17{ .ids = (((operand_8).request).origins).ids, .kinds = (((operand_8).request).origins).kinds, .members = (((operand_8).request).origins).members, .owners = (((operand_8).request).origins).owners, }, .roots = ((operand_8).request).roots, .scalar_count = ((operand_8).request).scalar_count, .table = state_type_18{ .children = (((operand_8).request).table).children, .field_names = (((operand_8).request).table).field_names, .field_types = (((operand_8).request).table).field_types, .first = (((operand_8).request).table).first, .kinds = (((operand_8).request).table).kinds, .labels = (((operand_8).request).table).labels, .names = (((operand_8).request).table).names, .second = (((operand_8).request).table).second, }, }, };
        var state_changed_9 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_1).index < @as(u64, (((state_1).request).roots).len)))) {
            state_1 = block_41: {
                const value_5: state_type_20 = (if (block_24: {
                    const operand_22 = ((state_1).request).roots;
                    const operand_23 = (state_1).index;

                    if ((operand_23 >= (operand_22).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_24 (operand_22)[@intCast(operand_23)];
                }) block_40: {
                    const value_3: state_type_20 = state_1;

                    const value_4: state_type_20 = block_39: {
                        break :block_39 state_type_20{ .index = (value_3).index, .plan = block_38: {
                            const operand_30 = block_29: {
                                const operand_26 = (state_1).request;
                                const operand_27 = (state_1).plan;
                                const operand_28 = (state_1).index;

                                break :block_29 state_type_25{ .request = operand_26, .state = operand_27, .index = operand_28, };
                            };

                            const operand_31 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_30).request).origins).ids, .kinds = (((operand_30).request).origins).kinds, .members = (((operand_30).request).origins).members, .owners = (((operand_30).request).origins).owners, };
                            const operand_32 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_30).request).table).children, .field_names = (((operand_30).request).table).field_names, .field_types = (((operand_30).request).table).field_types, .first = (((operand_30).request).table).first, .kinds = (((operand_30).request).table).kinds, .labels = (((operand_30).request).table).labels, .names = (((operand_30).request).table).names, .second = (((operand_30).request).table).second, };
                            const operand_33 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_30).request).maximum_count, .names = ((operand_30).request).names, .origins = (&operand_31), .roots = ((operand_30).request).roots, .scalar_count = ((operand_30).request).scalar_count, .table = (&operand_32), };
                            const operand_34 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_30).state).count, .mapping = ((operand_30).state).mapping, .order = ((operand_30).state).order, .origins = ((operand_30).state).origins, .status = ((operand_30).state).status, };
                            const operand_35 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_30).index, .request = (&operand_33), .state = (&operand_34), };

                            const operand_37 = block_36: {
                                break :block_36 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_35), .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, .lane_1 = .{ .buffer = (&state_capacity_12), .started = (&state_capacity_started_13), }, .lane_2 = .{ .buffer = (&state_capacity_14), .started = (&state_capacity_started_15), }, }));
                            };

                            break :block_38 state_type_16{ .count = (operand_37).count, .mapping = (operand_37).mapping, .order = (operand_37).order, .origins = (operand_37).origins, .status = (operand_37).status, };
                        }, .request = (value_3).request, };
                    };

                    break :block_40 value_4;
                } else state_1);

                const value_6: state_type_20 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: state_type_20 = block_21: {
                    break :block_21 state_type_20{ .index = (value_7 + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, };
                };

                break :block_41 value_8;
            };

            state_changed_9 = true;
        }

        var state_owned_42: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_42);

        if (state_capacity_started_11) {
            ((state_capacity_10).items).len = (((state_1).plan).mapping).len;
            state_owned_42 = (try (state_capacity_10).toOwnedSlice(allocator));
        }

        if (state_capacity_started_11) {
            ((state_1).plan).mapping = state_owned_42;
        }

        var state_owned_43: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_43);

        if (state_capacity_started_13) {
            ((state_capacity_12).items).len = (((state_1).plan).order).len;
            state_owned_43 = (try (state_capacity_12).toOwnedSlice(allocator));
        }

        if (state_capacity_started_13) {
            ((state_1).plan).order = state_owned_43;
        }

        var state_owned_44: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_44);

        if (state_capacity_started_15) {
            ((state_capacity_14).items).len = (((state_1).plan).origins).len;
            state_owned_44 = (try (state_capacity_14).toOwnedSlice(allocator));
        }

        if (state_capacity_started_15) {
            ((state_1).plan).origins = state_owned_44;
        }

        break :block_56 (if (state_changed_9) block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

            (operand_54).* = @as((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_1).index, .plan = block_47: {
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

            break :block_55 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_54);
        } else operand_8);
    };

    return (value_9).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_9: (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_100: {
        const operand_62 = block_61: {
            const operand_58 = (in).request;
            const operand_59 = (in).state;
            const operand_60 = @as(u64, 0);

            break :block_61 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_58, .plan = operand_59, .index = operand_60, };
        };

        var state_capacity_63: (std).ArrayList(u64) = .empty;
        var state_capacity_started_64 = false;

        defer (state_capacity_63).deinit(allocator);

        var state_capacity_65: (std).ArrayList(u32) = .empty;
        var state_capacity_started_66 = false;

        defer (state_capacity_65).deinit(allocator);

        var state_capacity_67: (std).ArrayList(u64) = .empty;
        var state_capacity_started_68 = false;

        defer (state_capacity_67).deinit(allocator);

        var state_57: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_62).index, .plan = (operand_62).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_62).request).maximum_count, .names = ((operand_62).request).names, .origins = ((operand_62).request).origins, .roots = ((operand_62).request).roots, .scalar_count = ((operand_62).request).scalar_count, .table = ((operand_62).request).table, .zx_origin = (operand_62).request, }, .zx_origin = (&operand_62), };

        while (((((state_57).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_57).index < @as(u64, (((state_57).request).roots).len)))) {
            state_57 = block_86: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_73: {
                    const operand_71 = ((state_57).request).roots;
                    const operand_72 = (state_57).index;

                    if ((operand_72 >= (operand_71).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_73 (operand_71)[@intCast(operand_72)];
                }) block_85: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_57;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_84: {
                        break :block_84 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_83: {
                            const operand_82 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_82).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_81: {
                                const operand_78 = block_77: {
                                    const operand_74 = (state_57).request;
                                    const operand_75 = (state_57).plan;
                                    const operand_76 = (state_57).index;

                                    break :block_77 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_74, .state = operand_75, .index = operand_76, });
                                };
                                var state_borrow_79: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_79 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_78).request).maximum_count, .names = ((operand_78).request).names, .origins = ((operand_78).request).origins, .roots = ((operand_78).request).roots, .scalar_count = ((operand_78).request).scalar_count, .table = ((operand_78).request).table, };

                                var state_borrow_80: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_80 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_78).index, .request = (((operand_78).request).zx_origin orelse (&state_borrow_79)), .state = (operand_78).state, };

                                break :block_81 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_78).zx_origin orelse (&state_borrow_80)), .{ .lane_0 = .{ .buffer = (&state_capacity_63), .started = (&state_capacity_started_64), }, .lane_1 = .{ .buffer = (&state_capacity_65), .started = (&state_capacity_started_66), }, .lane_2 = .{ .buffer = (&state_capacity_67), .started = (&state_capacity_started_68), }, }));
                            });

                            break :block_83 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_82);
                        }, .request = (value_3).request, });
                    };

                    break :block_85 value_4;
                } else state_57);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_69: {
                        break :block_69 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_86 value_8;
            };
        }

        var state_owned_87: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_87);

        if (state_capacity_started_64) {
            ((state_capacity_63).items).len = (((state_57).plan).mapping).len;
            state_owned_87 = (try (state_capacity_63).toOwnedSlice(allocator));
        }

        if (state_capacity_started_64) {
            state_57 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_88).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = state_owned_87, .order = ((state_57).plan).order, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_89 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_88);
            }, .request = (state_57).request, };
        }

        var state_owned_90: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_90);

        if (state_capacity_started_66) {
            ((state_capacity_65).items).len = (((state_57).plan).order).len;
            state_owned_90 = (try (state_capacity_65).toOwnedSlice(allocator));
        }

        if (state_capacity_started_66) {
            state_57 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_91).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = state_owned_90, .origins = ((state_57).plan).origins, .status = ((state_57).plan).status, });

                break :block_92 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_91);
            }, .request = (state_57).request, };
        }

        var state_owned_93: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_68) {
            ((state_capacity_67).items).len = (((state_57).plan).origins).len;
            state_owned_93 = (try (state_capacity_67).toOwnedSlice(allocator));
        }

        if (state_capacity_started_68) {
            state_57 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_57).index, .plan = block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_94).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_57).plan).count, .mapping = ((state_57).plan).mapping, .order = ((state_57).plan).order, .origins = state_owned_93, .status = ((state_57).plan).status, });

                break :block_95 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_94);
            }, .request = (state_57).request, };
        }

        break :block_100 block_99: {
            break :block_99 (if (((state_57).zx_origin != null)) ((state_57).zx_origin.?).* else block_98: {
                break :block_98 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_57).index, .plan = (state_57).plan, .request = (if ((((state_57).request).zx_origin != null)) ((state_57).request).zx_origin.? else block_97: {
                    const operand_96 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_96).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_57).request).maximum_count, .names = ((state_57).request).names, .origins = ((state_57).request).origins, .roots = ((state_57).request).roots, .scalar_count = ((state_57).request).scalar_count, .table = ((state_57).request).table, };

                    break :block_97 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_96);
                }), };
            });
        };
    };

    return (((&value_9)).plan).*;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, buffers: struct {
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

    const value_9: (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_129: {
        const operand_106 = block_105: {
            const operand_102 = (in).request;
            const operand_103 = (in).state;
            const operand_104 = @as(u64, 0);

            break :block_105 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_102, .plan = operand_103, .index = operand_104, };
        };

        var state_101: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_106).index, .plan = (operand_106).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_106).request).maximum_count, .names = ((operand_106).request).names, .origins = ((operand_106).request).origins, .roots = ((operand_106).request).roots, .scalar_count = ((operand_106).request).scalar_count, .table = ((operand_106).request).table, .zx_origin = (operand_106).request, }, .zx_origin = (&operand_106), };

        while (((((state_101).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_101).index < @as(u64, (((state_101).request).roots).len)))) {
            state_101 = block_124: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_111: {
                    const operand_109 = ((state_101).request).roots;
                    const operand_110 = (state_101).index;

                    if ((operand_110 >= (operand_109).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_111 (operand_109)[@intCast(operand_110)];
                }) block_123: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_101;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_122: {
                        break :block_122 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_121: {
                            const operand_120 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_120).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_119: {
                                const operand_116 = block_115: {
                                    const operand_112 = (state_101).request;
                                    const operand_113 = (state_101).plan;
                                    const operand_114 = (state_101).index;

                                    break :block_115 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_112, .state = operand_113, .index = operand_114, });
                                };
                                var state_borrow_117: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_117 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_116).request).maximum_count, .names = ((operand_116).request).names, .origins = ((operand_116).request).origins, .roots = ((operand_116).request).roots, .scalar_count = ((operand_116).request).scalar_count, .table = ((operand_116).request).table, };

                                var state_borrow_118: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_118 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_116).index, .request = (((operand_116).request).zx_origin orelse (&state_borrow_117)), .state = (operand_116).state, };

                                break :block_119 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_116).zx_origin orelse (&state_borrow_118)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            });

                            break :block_121 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_120);
                        }, .request = (value_3).request, });
                    };

                    break :block_123 value_4;
                } else state_101);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_108: {
                    break :block_108 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_107: {
                        break :block_107 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_124 value_8;
            };
        }

        break :block_129 block_128: {
            break :block_128 (if (((state_101).zx_origin != null)) ((state_101).zx_origin.?).* else block_127: {
                break :block_127 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_101).index, .plan = (state_101).plan, .request = (if ((((state_101).request).zx_origin != null)) ((state_101).request).zx_origin.? else block_126: {
                    const operand_125 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_125).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_101).request).maximum_count, .names = ((state_101).request).names, .origins = ((state_101).request).origins, .roots = ((state_101).request).roots, .scalar_count = ((state_101).request).scalar_count, .table = ((state_101).request).table, };

                    break :block_126 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_125);
                }), };
            });
        };
    };

    return (((&value_9)).plan).*;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748, buffers: struct {
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

    const value_9: *const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_176: {
        const operand_137 = block_136: {
            const operand_131 = (in).request;
            const operand_132 = (in).state;
            const operand_133 = @as(u64, 0);

            break :block_136 block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

                (operand_134).* = @as((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_131, .plan = operand_132, .index = operand_133, });

                break :block_135 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_134);
            };
        };
        const state_type_139 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_140 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_141 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_142 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_140,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_141,
        };
        const state_type_143 = struct {
            index: u64,
            plan: state_type_139,
            request: state_type_142,
        };
        const state_type_148 = struct {
            index: u64,
            request: state_type_142,
            state: state_type_139,
        };

        var state_130: state_type_143 = state_type_143{ .index = (operand_137).index, .plan = state_type_139{ .count = ((operand_137).plan).count, .mapping = ((operand_137).plan).mapping, .order = ((operand_137).plan).order, .origins = ((operand_137).plan).origins, .status = ((operand_137).plan).status, }, .request = state_type_142{ .maximum_count = ((operand_137).request).maximum_count, .names = ((operand_137).request).names, .origins = state_type_140{ .ids = (((operand_137).request).origins).ids, .kinds = (((operand_137).request).origins).kinds, .members = (((operand_137).request).origins).members, .owners = (((operand_137).request).origins).owners, }, .roots = ((operand_137).request).roots, .scalar_count = ((operand_137).request).scalar_count, .table = state_type_141{ .children = (((operand_137).request).table).children, .field_names = (((operand_137).request).table).field_names, .field_types = (((operand_137).request).table).field_types, .first = (((operand_137).request).table).first, .kinds = (((operand_137).request).table).kinds, .labels = (((operand_137).request).table).labels, .names = (((operand_137).request).table).names, .second = (((operand_137).request).table).second, }, }, };
        var state_changed_138 = false;

        while (((((state_130).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_130).index < @as(u64, (((state_130).request).roots).len)))) {
            state_130 = block_164: {
                const value_5: state_type_143 = (if (block_147: {
                    const operand_145 = ((state_130).request).roots;
                    const operand_146 = (state_130).index;

                    if ((operand_146 >= (operand_145).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_147 (operand_145)[@intCast(operand_146)];
                }) block_163: {
                    const value_3: state_type_143 = state_130;
                    const value_4: state_type_143 = block_162: {
                        break :block_162 state_type_143{ .index = (value_3).index, .plan = block_161: {
                            const operand_153 = block_152: {
                                const operand_149 = (state_130).request;
                                const operand_150 = (state_130).plan;
                                const operand_151 = (state_130).index;

                                break :block_152 state_type_148{ .request = operand_149, .state = operand_150, .index = operand_151, };
                            };

                            const operand_154 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_153).request).origins).ids, .kinds = (((operand_153).request).origins).kinds, .members = (((operand_153).request).origins).members, .owners = (((operand_153).request).origins).owners, };
                            const operand_155 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_153).request).table).children, .field_names = (((operand_153).request).table).field_names, .field_types = (((operand_153).request).table).field_types, .first = (((operand_153).request).table).first, .kinds = (((operand_153).request).table).kinds, .labels = (((operand_153).request).table).labels, .names = (((operand_153).request).table).names, .second = (((operand_153).request).table).second, };
                            const operand_156 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_153).request).maximum_count, .names = ((operand_153).request).names, .origins = (&operand_154), .roots = ((operand_153).request).roots, .scalar_count = ((operand_153).request).scalar_count, .table = (&operand_155), };
                            const operand_157 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_153).state).count, .mapping = ((operand_153).state).mapping, .order = ((operand_153).state).order, .origins = ((operand_153).state).origins, .status = ((operand_153).state).status, };
                            const operand_158 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_153).index, .request = (&operand_156), .state = (&operand_157), };

                            const operand_160 = block_159: {
                                break :block_159 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_158), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            };

                            break :block_161 state_type_139{ .count = (operand_160).count, .mapping = (operand_160).mapping, .order = (operand_160).order, .origins = (operand_160).origins, .status = (operand_160).status, };
                        }, .request = (value_3).request, };
                    };

                    break :block_163 value_4;
                } else state_130);

                const value_6: state_type_143 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: state_type_143 = block_144: {
                    break :block_144 state_type_143{ .index = (value_7 + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, };
                };

                break :block_164 value_8;
            };

            state_changed_138 = true;
        }

        break :block_176 (if (state_changed_138) block_175: {
            const operand_174 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

            (operand_174).* = @as((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_130).index, .plan = block_167: {
                const operand_166 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_166).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_130).plan).count, .mapping = ((state_130).plan).mapping, .order = ((state_130).plan).order, .origins = ((state_130).plan).origins, .status = ((state_130).plan).status, });

                break :block_167 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_166);
            }, .request = block_173: {
                const operand_172 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_172).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_130).request).maximum_count, .names = ((state_130).request).names, .origins = block_169: {
                    const operand_168 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_168).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_130).request).origins).ids, .kinds = (((state_130).request).origins).kinds, .members = (((state_130).request).origins).members, .owners = (((state_130).request).origins).owners, });

                    break :block_169 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_168);
                }, .roots = ((state_130).request).roots, .scalar_count = ((state_130).request).scalar_count, .table = block_171: {
                    const operand_170 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_170).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_130).request).table).children, .field_names = (((state_130).request).table).field_names, .field_types = (((state_130).request).table).field_types, .first = (((state_130).request).table).first, .kinds = (((state_130).request).table).kinds, .labels = (((state_130).request).table).labels, .names = (((state_130).request).table).names, .second = (((state_130).request).table).second, });

                    break :block_171 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_170);
                }, });

                break :block_173 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_172);
            }, });

            break :block_175 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_174);
        } else operand_137);
    };

    return (value_9).plan;
}

