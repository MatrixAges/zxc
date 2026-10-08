const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: *const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_50: {
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

        var state_1: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_9).ids, .index = (operand_9).index, .plan = (operand_9).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_9).request).maximum_count, .names = ((operand_9).request).names, .origins = ((operand_9).request).origins, .roots = ((operand_9).request).roots, .scalar_count = ((operand_9).request).scalar_count, .table = ((operand_9).request).table, .zx_origin = (operand_9).request, }, .zx_origin = operand_9, };
        var state_changed_10 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_1).index < @as(u64, ((state_1).ids).len)))) {
            state_1 = block_35: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_1;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_34: {
                    break :block_34 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_32).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_31: {
                            const operand_28 = block_27: {
                                const operand_19 = (state_1).request;
                                const operand_20 = (state_1).plan;
                                const operand_21 = block_26: {
                                    const operand_25 = block_24: {
                                        const operand_22 = (state_1).ids;
                                        const operand_23 = (state_1).index;

                                        if ((operand_23 >= (operand_22).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_24 (operand_22)[@intCast(operand_23)];
                                    };

                                    break :block_26 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_25));
                                };

                                break :block_27 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_19, .state = operand_20, .index = operand_21, });
                            };

                            var state_borrow_29: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_29 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_28).request).maximum_count, .names = ((operand_28).request).names, .origins = ((operand_28).request).origins, .roots = ((operand_28).request).roots, .scalar_count = ((operand_28).request).scalar_count, .table = ((operand_28).request).table, };

                            var state_borrow_30: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                            state_borrow_30 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_28).index, .request = (((operand_28).request).zx_origin orelse (&state_borrow_29)), .state = (operand_28).state, };

                            break :block_31 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_28).zx_origin orelse (&state_borrow_30)), .{ .lane_0 = .{ .buffer = (&state_capacity_11), .started = (&state_capacity_started_12), }, .lane_1 = .{ .buffer = (&state_capacity_13), .started = (&state_capacity_started_14), }, .lane_2 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, }));
                        });

                        break :block_33 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_32);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_17: {
                        break :block_17 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_35 value_7;
            };

            state_changed_10 = true;
        }

        var state_owned_36: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_36);

        if (state_capacity_started_12) {
            ((state_capacity_11).items).len = (((state_1).plan).mapping).len;
            state_owned_36 = (try (state_capacity_11).toOwnedSlice(allocator));
        }

        if (state_capacity_started_12) {
            state_1 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_1).ids, .index = (state_1).index, .plan = block_38: {
                const operand_37 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_37).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = state_owned_36, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_38 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_37);
            }, .request = (state_1).request, };
        }

        var state_owned_39: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_39);

        if (state_capacity_started_14) {
            ((state_capacity_13).items).len = (((state_1).plan).order).len;
            state_owned_39 = (try (state_capacity_13).toOwnedSlice(allocator));
        }

        if (state_capacity_started_14) {
            state_1 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_1).ids, .index = (state_1).index, .plan = block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_40).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = state_owned_39, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_41 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_40);
            }, .request = (state_1).request, };
        }

        var state_owned_42: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_42);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).plan).origins).len;
            state_owned_42 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            state_1 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_1).ids, .index = (state_1).index, .plan = block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_43).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = state_owned_42, .status = ((state_1).plan).status, });

                break :block_44 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_43);
            }, .request = (state_1).request, };
        }

        break :block_50 (if (state_changed_10) block_49: {
            break :block_49 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_48: {
                const operand_47 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

                (operand_47).* = (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_1).ids, .index = (state_1).index, .plan = (state_1).plan, .request = (if ((((state_1).request).zx_origin != null)) ((state_1).request).zx_origin.? else block_46: {
                    const operand_45 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_45).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = ((state_1).request).origins, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = ((state_1).request).table, };

                    break :block_46 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_45);
                }), };

                break :block_48 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_47);
            });
        } else operand_9);
    };

    return (value_8).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_96: {
        const operand_57 = block_56: {
            const operand_52 = (in).request;
            const operand_53 = (in).state;
            const operand_54 = (in).ids;
            const operand_55 = @as(u64, 0);

            break :block_56 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_52, .plan = operand_53, .ids = operand_54, .index = operand_55, };
        };

        var state_capacity_58: (std).ArrayList(u64) = .empty;
        var state_capacity_started_59 = false;

        defer (state_capacity_58).deinit(allocator);

        var state_capacity_60: (std).ArrayList(u32) = .empty;
        var state_capacity_started_61 = false;

        defer (state_capacity_60).deinit(allocator);

        var state_capacity_62: (std).ArrayList(u64) = .empty;
        var state_capacity_started_63 = false;

        defer (state_capacity_62).deinit(allocator);

        var state_51: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_57).ids, .index = (operand_57).index, .plan = (operand_57).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_57).request).maximum_count, .names = ((operand_57).request).names, .origins = ((operand_57).request).origins, .roots = ((operand_57).request).roots, .scalar_count = ((operand_57).request).scalar_count, .table = ((operand_57).request).table, .zx_origin = (operand_57).request, }, .zx_origin = (&operand_57), };

        while (((((state_51).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_51).index < @as(u64, ((state_51).ids).len)))) {
            state_51 = block_82: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_51;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_81: {
                    break :block_81 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_80: {
                        const operand_79 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_79).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_78: {
                            const operand_75 = block_74: {
                                const operand_66 = (state_51).request;
                                const operand_67 = (state_51).plan;
                                const operand_68 = block_73: {
                                    const operand_72 = block_71: {
                                        const operand_69 = (state_51).ids;
                                        const operand_70 = (state_51).index;

                                        if ((operand_70 >= (operand_69).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_71 (operand_69)[@intCast(operand_70)];
                                    };

                                    break :block_73 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_72));
                                };

                                break :block_74 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_66, .state = operand_67, .index = operand_68, });
                            };

                            var state_borrow_76: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_76 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_75).request).maximum_count, .names = ((operand_75).request).names, .origins = ((operand_75).request).origins, .roots = ((operand_75).request).roots, .scalar_count = ((operand_75).request).scalar_count, .table = ((operand_75).request).table, };

                            var state_borrow_77: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;
                            state_borrow_77 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_75).index, .request = (((operand_75).request).zx_origin orelse (&state_borrow_76)), .state = (operand_75).state, };

                            break :block_78 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_75).zx_origin orelse (&state_borrow_77)), .{ .lane_0 = .{ .buffer = (&state_capacity_58), .started = (&state_capacity_started_59), }, .lane_1 = .{ .buffer = (&state_capacity_60), .started = (&state_capacity_started_61), }, .lane_2 = .{ .buffer = (&state_capacity_62), .started = (&state_capacity_started_63), }, }));
                        });

                        break :block_80 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_79);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_65: {
                    break :block_65 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_64: {
                        break :block_64 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_82 value_7;
            };
        }

        var state_owned_83: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_83);

        if (state_capacity_started_59) {
            ((state_capacity_58).items).len = (((state_51).plan).mapping).len;
            state_owned_83 = (try (state_capacity_58).toOwnedSlice(allocator));
        }

        if (state_capacity_started_59) {
            state_51 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_51).ids, .index = (state_51).index, .plan = block_85: {
                const operand_84 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_84).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_51).plan).count, .mapping = state_owned_83, .order = ((state_51).plan).order, .origins = ((state_51).plan).origins, .status = ((state_51).plan).status, });

                break :block_85 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_84);
            }, .request = (state_51).request, };
        }

        var state_owned_86: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_86);

        if (state_capacity_started_61) {
            ((state_capacity_60).items).len = (((state_51).plan).order).len;
            state_owned_86 = (try (state_capacity_60).toOwnedSlice(allocator));
        }

        if (state_capacity_started_61) {
            state_51 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_51).ids, .index = (state_51).index, .plan = block_88: {
                const operand_87 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_87).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_51).plan).count, .mapping = ((state_51).plan).mapping, .order = state_owned_86, .origins = ((state_51).plan).origins, .status = ((state_51).plan).status, });

                break :block_88 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_87);
            }, .request = (state_51).request, };
        }

        var state_owned_89: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_89);

        if (state_capacity_started_63) {
            ((state_capacity_62).items).len = (((state_51).plan).origins).len;
            state_owned_89 = (try (state_capacity_62).toOwnedSlice(allocator));
        }

        if (state_capacity_started_63) {
            state_51 = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (state_51).ids, .index = (state_51).index, .plan = block_91: {
                const operand_90 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_90).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_51).plan).count, .mapping = ((state_51).plan).mapping, .order = ((state_51).plan).order, .origins = state_owned_89, .status = ((state_51).plan).status, });

                break :block_91 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_90);
            }, .request = (state_51).request, };
        }

        break :block_96 block_95: {
            break :block_95 (if (((state_51).zx_origin != null)) ((state_51).zx_origin.?).* else block_94: {
                break :block_94 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_51).ids, .index = (state_51).index, .plan = (state_51).plan, .request = (if ((((state_51).request).zx_origin != null)) ((state_51).request).zx_origin.? else block_93: {
                    const operand_92 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_92).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_51).request).maximum_count, .names = ((state_51).request).names, .origins = ((state_51).request).origins, .roots = ((state_51).request).roots, .scalar_count = ((state_51).request).scalar_count, .table = ((state_51).request).table, };

                    break :block_93 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_92);
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

    const value_8: (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_127: {
        const operand_103 = block_102: {
            const operand_98 = (in).request;
            const operand_99 = (in).state;
            const operand_100 = (in).ids;
            const operand_101 = @as(u64, 0);

            break :block_102 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_98, .plan = operand_99, .ids = operand_100, .index = operand_101, };
        };

        var state_97: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_103).ids, .index = (operand_103).index, .plan = (operand_103).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_103).request).maximum_count, .names = ((operand_103).request).names, .origins = ((operand_103).request).origins, .roots = ((operand_103).request).roots, .scalar_count = ((operand_103).request).scalar_count, .table = ((operand_103).request).table, .zx_origin = (operand_103).request, }, .zx_origin = (&operand_103), };

        while (((((state_97).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_97).index < @as(u64, ((state_97).ids).len)))) {
            state_97 = block_122: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_97;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_121: {
                    break :block_121 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_120: {
                        const operand_119 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_119).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_118: {
                            const operand_115 = block_114: {
                                const operand_106 = (state_97).request;
                                const operand_107 = (state_97).plan;
                                const operand_108 = block_113: {
                                    const operand_112 = block_111: {
                                        const operand_109 = (state_97).ids;
                                        const operand_110 = (state_97).index;

                                        if ((operand_110 >= (operand_109).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_111 (operand_109)[@intCast(operand_110)];
                                    };

                                    break :block_113 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_112));
                                };

                                break :block_114 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_106, .state = operand_107, .index = operand_108, });
                            };

                            var state_borrow_116: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_116 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_115).request).maximum_count, .names = ((operand_115).request).names, .origins = ((operand_115).request).origins, .roots = ((operand_115).request).roots, .scalar_count = ((operand_115).request).scalar_count, .table = ((operand_115).request).table, };

                            var state_borrow_117: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                            state_borrow_117 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_115).index, .request = (((operand_115).request).zx_origin orelse (&state_borrow_116)), .state = (operand_115).state, };

                            break :block_118 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_115).zx_origin orelse (&state_borrow_117)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                        });

                        break :block_120 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_119);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_105: {
                    break :block_105 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_104: {
                        break :block_104 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_122 value_7;
            };
        }

        break :block_127 block_126: {
            break :block_126 (if (((state_97).zx_origin != null)) ((state_97).zx_origin.?).* else block_125: {
                break :block_125 (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_97).ids, .index = (state_97).index, .plan = (state_97).plan, .request = (if ((((state_97).request).zx_origin != null)) ((state_97).request).zx_origin.? else block_124: {
                    const operand_123 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_123).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_97).request).maximum_count, .names = ((state_97).request).names, .origins = ((state_97).request).origins, .roots = ((state_97).request).roots, .scalar_count = ((state_97).request).scalar_count, .table = ((state_97).request).table, };

                    break :block_124 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_123);
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

    const value_8: *const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = block_162: {
        const operand_136 = block_135: {
            const operand_129 = (in).request;
            const operand_130 = (in).state;
            const operand_131 = (in).ids;
            const operand_132 = @as(u64, 0);

            break :block_135 block_134: {
                const operand_133 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

                (operand_133).* = @as((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .request = operand_129, .plan = operand_130, .ids = operand_131, .index = operand_132, });

                break :block_134 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_133);
            };
        };

        var state_128: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (operand_136).ids, .index = (operand_136).index, .plan = (operand_136).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_136).request).maximum_count, .names = ((operand_136).request).names, .origins = ((operand_136).request).origins, .roots = ((operand_136).request).roots, .scalar_count = ((operand_136).request).scalar_count, .table = ((operand_136).request).table, .zx_origin = (operand_136).request, }, .zx_origin = operand_136, };
        var state_changed_137 = false;

        while (((((state_128).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_128).index < @as(u64, ((state_128).ids).len)))) {
            state_128 = block_156: {
                const value_3: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = state_128;

                const value_4: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_155: {
                    break :block_155 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_3).ids, .index = (value_3).index, .plan = block_154: {
                        const operand_153 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                        (operand_153).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_152: {
                            const operand_149 = block_148: {
                                const operand_140 = (state_128).request;
                                const operand_141 = (state_128).plan;
                                const operand_142 = block_147: {
                                    const operand_146 = block_145: {
                                        const operand_143 = (state_128).ids;
                                        const operand_144 = (state_128).index;

                                        if ((operand_144 >= (operand_143).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_145 (operand_143)[@intCast(operand_144)];
                                    };

                                    break :block_147 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_146));
                                };

                                break :block_148 @as((zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0, (zx_abi).value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0{ .request = operand_140, .state = operand_141, .index = operand_142, });
                            };

                            var state_borrow_150: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                            state_borrow_150 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_149).request).maximum_count, .names = ((operand_149).request).names, .origins = ((operand_149).request).origins, .roots = ((operand_149).request).roots, .scalar_count = ((operand_149).request).scalar_count, .table = ((operand_149).request).table, };

                            var state_borrow_151: (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = undefined;

                            state_borrow_151 = (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .index = (operand_149).index, .request = (((operand_149).request).zx_origin orelse (&state_borrow_150)), .state = (operand_149).state, };

                            break :block_152 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, ((operand_149).zx_origin orelse (&state_borrow_151)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), }));
                        });

                        break :block_154 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_153);
                    }, .request = (value_3).request, });
                };

                const value_5: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = value_4;
                const value_6: u64 = (value_5).index;

                const value_7: (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = block_139: {
                    break :block_139 @as((zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef, (zx_abi).value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef{ .ids = (value_5).ids, .index = (block_138: {
                        break :block_138 value_6;
                    } + @as(u64, 1)), .plan = (value_5).plan, .request = (value_5).request, });
                };

                break :block_156 value_7;
            };

            state_changed_137 = true;
        }

        break :block_162 (if (state_changed_137) block_161: {
            break :block_161 (if (((state_128).zx_origin != null)) (state_128).zx_origin.? else block_160: {
                const operand_159 = (try (allocator).create((zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535));

                (operand_159).* = (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535{ .ids = (state_128).ids, .index = (state_128).index, .plan = (state_128).plan, .request = (if ((((state_128).request).zx_origin != null)) ((state_128).request).zx_origin.? else block_158: {
                    const operand_157 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_157).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_128).request).maximum_count, .names = ((state_128).request).names, .origins = ((state_128).request).origins, .roots = ((state_128).request).roots, .scalar_count = ((state_128).request).scalar_count, .table = ((state_128).request).table, };

                    break :block_158 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_157);
                }), };

                break :block_160 @as(*const (zx_abi).zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535, operand_159);
            });
        } else operand_136);
    };

    return (value_8).plan;
}

