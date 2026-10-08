const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_9: *const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_48: {
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

        var state_1: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_8).index, .plan = (operand_8).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_8).request).maximum_count, .names = ((operand_8).request).names, .origins = ((operand_8).request).origins, .roots = ((operand_8).request).roots, .scalar_count = ((operand_8).request).scalar_count, .table = ((operand_8).request).table, .zx_origin = (operand_8).request, }, .zx_origin = operand_8, };
        var state_changed_9 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_1).index < @as(u64, (((state_1).request).roots).len)))) {
            state_1 = block_33: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_20: {
                    const operand_18 = ((state_1).request).roots;
                    const operand_19 = (state_1).index;

                    if ((operand_19 >= (operand_18).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_20 (operand_18)[@intCast(operand_19)];
                }) block_32: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_1;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_31: {
                        break :block_31 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_30: {
                            const operand_29 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_29).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_28: {
                                const operand_25 = block_24: {
                                    const operand_21 = (state_1).request;
                                    const operand_22 = (state_1).plan;
                                    const operand_23 = (state_1).index;

                                    break :block_24 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_21, .state = operand_22, .index = operand_23, });
                                };
                                var state_borrow_26: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_26 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_25).request).maximum_count, .names = ((operand_25).request).names, .origins = ((operand_25).request).origins, .roots = ((operand_25).request).roots, .scalar_count = ((operand_25).request).scalar_count, .table = ((operand_25).request).table, };

                                var state_borrow_27: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_27 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_25).index, .request = (((operand_25).request).zx_origin orelse (&state_borrow_26)), .state = (operand_25).state, };

                                break :block_28 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_25).zx_origin orelse (&state_borrow_27)), .{ .lane_0 = .{ .buffer = (&state_capacity_10), .started = (&state_capacity_started_11), }, .lane_1 = .{ .buffer = (&state_capacity_12), .started = (&state_capacity_started_13), }, .lane_2 = .{ .buffer = (&state_capacity_14), .started = (&state_capacity_started_15), }, }));
                            });

                            break :block_30 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_29);
                        }, .request = (value_3).request, });
                    };

                    break :block_32 value_4;
                } else state_1);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_17: {
                    break :block_17 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_16: {
                        break :block_16 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_33 value_8;
            };

            state_changed_9 = true;
        }

        var state_owned_34: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_34);

        if (state_capacity_started_11) {
            ((state_capacity_10).items).len = (((state_1).plan).mapping).len;
            state_owned_34 = (try (state_capacity_10).toOwnedSlice(allocator));
        }

        if (state_capacity_started_11) {
            state_1 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_1).index, .plan = block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_35).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = state_owned_34, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_36 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_35);
            }, .request = (state_1).request, };
        }

        var state_owned_37: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_37);

        if (state_capacity_started_13) {
            ((state_capacity_12).items).len = (((state_1).plan).order).len;
            state_owned_37 = (try (state_capacity_12).toOwnedSlice(allocator));
        }

        if (state_capacity_started_13) {
            state_1 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_1).index, .plan = block_39: {
                const operand_38 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_38).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = state_owned_37, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_39 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_38);
            }, .request = (state_1).request, };
        }

        var state_owned_40: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_40);

        if (state_capacity_started_15) {
            ((state_capacity_14).items).len = (((state_1).plan).origins).len;
            state_owned_40 = (try (state_capacity_14).toOwnedSlice(allocator));
        }

        if (state_capacity_started_15) {
            state_1 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_1).index, .plan = block_42: {
                const operand_41 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_41).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = state_owned_40, .status = ((state_1).plan).status, });

                break :block_42 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_41);
            }, .request = (state_1).request, };
        }

        break :block_48 (if (state_changed_9) block_47: {
            break :block_47 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_46: {
                const operand_45 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

                (operand_45).* = (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_1).index, .plan = (state_1).plan, .request = (if ((((state_1).request).zx_origin != null)) ((state_1).request).zx_origin.? else block_44: {
                    const operand_43 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_43).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = ((state_1).request).origins, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = ((state_1).request).table, };

                    break :block_44 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_43);
                }), };

                break :block_46 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_45);
            });
        } else operand_8);
    };

    return (value_9).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_9: (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_92: {
        const operand_54 = block_53: {
            const operand_50 = (in).request;
            const operand_51 = (in).state;
            const operand_52 = @as(u64, 0);

            break :block_53 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_50, .plan = operand_51, .index = operand_52, };
        };

        var state_capacity_55: (std).ArrayList(u64) = .empty;
        var state_capacity_started_56 = false;

        defer (state_capacity_55).deinit(allocator);

        var state_capacity_57: (std).ArrayList(u32) = .empty;
        var state_capacity_started_58 = false;

        defer (state_capacity_57).deinit(allocator);

        var state_capacity_59: (std).ArrayList(u64) = .empty;
        var state_capacity_started_60 = false;

        defer (state_capacity_59).deinit(allocator);

        var state_49: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_54).index, .plan = (operand_54).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_54).request).maximum_count, .names = ((operand_54).request).names, .origins = ((operand_54).request).origins, .roots = ((operand_54).request).roots, .scalar_count = ((operand_54).request).scalar_count, .table = ((operand_54).request).table, .zx_origin = (operand_54).request, }, .zx_origin = (&operand_54), };

        while (((((state_49).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_49).index < @as(u64, (((state_49).request).roots).len)))) {
            state_49 = block_78: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_65: {
                    const operand_63 = ((state_49).request).roots;
                    const operand_64 = (state_49).index;

                    if ((operand_64 >= (operand_63).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_65 (operand_63)[@intCast(operand_64)];
                }) block_77: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_49;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_76: {
                        break :block_76 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_75: {
                            const operand_74 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_74).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_73: {
                                const operand_70 = block_69: {
                                    const operand_66 = (state_49).request;
                                    const operand_67 = (state_49).plan;
                                    const operand_68 = (state_49).index;

                                    break :block_69 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_66, .state = operand_67, .index = operand_68, });
                                };
                                var state_borrow_71: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_71 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_70).request).maximum_count, .names = ((operand_70).request).names, .origins = ((operand_70).request).origins, .roots = ((operand_70).request).roots, .scalar_count = ((operand_70).request).scalar_count, .table = ((operand_70).request).table, };

                                var state_borrow_72: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_72 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_70).index, .request = (((operand_70).request).zx_origin orelse (&state_borrow_71)), .state = (operand_70).state, };

                                break :block_73 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_70).zx_origin orelse (&state_borrow_72)), .{ .lane_0 = .{ .buffer = (&state_capacity_55), .started = (&state_capacity_started_56), }, .lane_1 = .{ .buffer = (&state_capacity_57), .started = (&state_capacity_started_58), }, .lane_2 = .{ .buffer = (&state_capacity_59), .started = (&state_capacity_started_60), }, }));
                            });

                            break :block_75 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_74);
                        }, .request = (value_3).request, });
                    };

                    break :block_77 value_4;
                } else state_49);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_62: {
                    break :block_62 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_61: {
                        break :block_61 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_78 value_8;
            };
        }

        var state_owned_79: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_79);

        if (state_capacity_started_56) {
            ((state_capacity_55).items).len = (((state_49).plan).mapping).len;
            state_owned_79 = (try (state_capacity_55).toOwnedSlice(allocator));
        }

        if (state_capacity_started_56) {
            state_49 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_49).index, .plan = block_81: {
                const operand_80 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_80).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_49).plan).count, .mapping = state_owned_79, .order = ((state_49).plan).order, .origins = ((state_49).plan).origins, .status = ((state_49).plan).status, });

                break :block_81 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_80);
            }, .request = (state_49).request, };
        }

        var state_owned_82: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_82);

        if (state_capacity_started_58) {
            ((state_capacity_57).items).len = (((state_49).plan).order).len;
            state_owned_82 = (try (state_capacity_57).toOwnedSlice(allocator));
        }

        if (state_capacity_started_58) {
            state_49 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_49).index, .plan = block_84: {
                const operand_83 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_83).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_49).plan).count, .mapping = ((state_49).plan).mapping, .order = state_owned_82, .origins = ((state_49).plan).origins, .status = ((state_49).plan).status, });

                break :block_84 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_83);
            }, .request = (state_49).request, };
        }

        var state_owned_85: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_85);

        if (state_capacity_started_60) {
            ((state_capacity_59).items).len = (((state_49).plan).origins).len;
            state_owned_85 = (try (state_capacity_59).toOwnedSlice(allocator));
        }

        if (state_capacity_started_60) {
            state_49 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (state_49).index, .plan = block_87: {
                const operand_86 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_86).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_49).plan).count, .mapping = ((state_49).plan).mapping, .order = ((state_49).plan).order, .origins = state_owned_85, .status = ((state_49).plan).status, });

                break :block_87 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_86);
            }, .request = (state_49).request, };
        }

        break :block_92 block_91: {
            break :block_91 (if (((state_49).zx_origin != null)) ((state_49).zx_origin.?).* else block_90: {
                break :block_90 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_49).index, .plan = (state_49).plan, .request = (if ((((state_49).request).zx_origin != null)) ((state_49).request).zx_origin.? else block_89: {
                    const operand_88 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_88).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_49).request).maximum_count, .names = ((state_49).request).names, .origins = ((state_49).request).origins, .roots = ((state_49).request).roots, .scalar_count = ((state_49).request).scalar_count, .table = ((state_49).request).table, };

                    break :block_89 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_88);
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

    const value_9: (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_121: {
        const operand_98 = block_97: {
            const operand_94 = (in).request;
            const operand_95 = (in).state;
            const operand_96 = @as(u64, 0);

            break :block_97 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_94, .plan = operand_95, .index = operand_96, };
        };

        var state_93: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_98).index, .plan = (operand_98).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_98).request).maximum_count, .names = ((operand_98).request).names, .origins = ((operand_98).request).origins, .roots = ((operand_98).request).roots, .scalar_count = ((operand_98).request).scalar_count, .table = ((operand_98).request).table, .zx_origin = (operand_98).request, }, .zx_origin = (&operand_98), };

        while (((((state_93).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_93).index < @as(u64, (((state_93).request).roots).len)))) {
            state_93 = block_116: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_103: {
                    const operand_101 = ((state_93).request).roots;
                    const operand_102 = (state_93).index;

                    if ((operand_102 >= (operand_101).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_103 (operand_101)[@intCast(operand_102)];
                }) block_115: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_93;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_114: {
                        break :block_114 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_113: {
                            const operand_112 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_112).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_111: {
                                const operand_108 = block_107: {
                                    const operand_104 = (state_93).request;
                                    const operand_105 = (state_93).plan;
                                    const operand_106 = (state_93).index;

                                    break :block_107 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_104, .state = operand_105, .index = operand_106, });
                                };
                                var state_borrow_109: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_109 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_108).request).maximum_count, .names = ((operand_108).request).names, .origins = ((operand_108).request).origins, .roots = ((operand_108).request).roots, .scalar_count = ((operand_108).request).scalar_count, .table = ((operand_108).request).table, };

                                var state_borrow_110: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                                state_borrow_110 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_108).index, .request = (((operand_108).request).zx_origin orelse (&state_borrow_109)), .state = (operand_108).state, };

                                break :block_111 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_108).zx_origin orelse (&state_borrow_110)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            });

                            break :block_113 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_112);
                        }, .request = (value_3).request, });
                    };

                    break :block_115 value_4;
                } else state_93);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_100: {
                    break :block_100 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_99: {
                        break :block_99 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_116 value_8;
            };
        }

        break :block_121 block_120: {
            break :block_120 (if (((state_93).zx_origin != null)) ((state_93).zx_origin.?).* else block_119: {
                break :block_119 (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_93).index, .plan = (state_93).plan, .request = (if ((((state_93).request).zx_origin != null)) ((state_93).request).zx_origin.? else block_118: {
                    const operand_117 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_117).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_93).request).maximum_count, .names = ((state_93).request).names, .origins = ((state_93).request).origins, .roots = ((state_93).request).roots, .scalar_count = ((state_93).request).scalar_count, .table = ((state_93).request).table, };

                    break :block_118 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_117);
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

    const value_9: *const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = block_154: {
        const operand_129 = block_128: {
            const operand_123 = (in).request;
            const operand_124 = (in).state;
            const operand_125 = @as(u64, 0);

            break :block_128 block_127: {
                const operand_126 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

                (operand_126).* = @as((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .request = operand_123, .plan = operand_124, .index = operand_125, });

                break :block_127 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_126);
            };
        };

        var state_122: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (operand_129).index, .plan = (operand_129).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_129).request).maximum_count, .names = ((operand_129).request).names, .origins = ((operand_129).request).origins, .roots = ((operand_129).request).roots, .scalar_count = ((operand_129).request).scalar_count, .table = ((operand_129).request).table, .zx_origin = (operand_129).request, }, .zx_origin = operand_129, };
        var state_changed_130 = false;

        while (((((state_122).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_122).index < @as(u64, (((state_122).request).roots).len)))) {
            state_122 = block_148: {
                const value_5: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = (if (block_135: {
                    const operand_133 = ((state_122).request).roots;
                    const operand_134 = (state_122).index;

                    if ((operand_134 >= (operand_133).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_135 (operand_133)[@intCast(operand_134)];
                }) block_147: {
                    const value_3: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = state_122;

                    const value_4: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_146: {
                        break :block_146 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (value_3).index, .plan = block_145: {
                            const operand_144 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                            (operand_144).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_143: {
                                const operand_140 = block_139: {
                                    const operand_136 = (state_122).request;
                                    const operand_137 = (state_122).plan;
                                    const operand_138 = (state_122).index;

                                    break :block_139 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_136, .state = operand_137, .index = operand_138, });
                                };
                                var state_borrow_141: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_141 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_140).request).maximum_count, .names = ((operand_140).request).names, .origins = ((operand_140).request).origins, .roots = ((operand_140).request).roots, .scalar_count = ((operand_140).request).scalar_count, .table = ((operand_140).request).table, };

                                var state_borrow_142: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                                state_borrow_142 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_140).index, .request = (((operand_140).request).zx_origin orelse (&state_borrow_141)), .state = (operand_140).state, };

                                break :block_143 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_140).zx_origin orelse (&state_borrow_142)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                            });

                            break :block_145 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_144);
                        }, .request = (value_3).request, });
                    };

                    break :block_147 value_4;
                } else state_122);

                const value_6: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = value_5;
                const value_7: u64 = (value_6).index;

                const value_8: (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = block_132: {
                    break :block_132 @as((zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31, (zx_abi).value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31{ .index = (block_131: {
                        break :block_131 value_7;
                    } + @as(u64, 1)), .plan = (value_6).plan, .request = (value_6).request, });
                };

                break :block_148 value_8;
            };

            state_changed_130 = true;
        }

        break :block_154 (if (state_changed_130) block_153: {
            break :block_153 (if (((state_122).zx_origin != null)) (state_122).zx_origin.? else block_152: {
                const operand_151 = (try (allocator).create((zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28));

                (operand_151).* = (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28{ .index = (state_122).index, .plan = (state_122).plan, .request = (if ((((state_122).request).zx_origin != null)) ((state_122).request).zx_origin.? else block_150: {
                    const operand_149 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_149).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_122).request).maximum_count, .names = ((state_122).request).names, .origins = ((state_122).request).origins, .roots = ((state_122).request).roots, .scalar_count = ((state_122).request).scalar_count, .table = ((state_122).request).table, };

                    break :block_150 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_149);
                }), };

                break :block_152 @as(*const (zx_abi).zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28, operand_151);
            });
        } else operand_129);
    };

    return (value_9).plan;
}

