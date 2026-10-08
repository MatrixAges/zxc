const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_25: *const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_103: {
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

        var state_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_16).index, .member = (operand_16).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_16).modules).identities, .import_names = ((operand_16).modules).import_names, .specifiers = ((operand_16).modules).specifiers, .type_ids = ((operand_16).modules).type_ids, .type_names = ((operand_16).modules).type_names, .type_namespaces = ((operand_16).modules).type_namespaces, .zx_origin = (operand_16).modules, }, .natives = (operand_16).natives, .plan = (operand_16).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_16).request).maximum_count, .names = ((operand_16).request).names, .origins = ((operand_16).request).origins, .roots = ((operand_16).request).roots, .scalar_count = ((operand_16).request).scalar_count, .table = ((operand_16).request).table, .zx_origin = (operand_16).request, }, .zx_origin = operand_16, };
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

                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_30: {
                    const operand_28 = ((state_6).natives).mapping;
                    const operand_29 = (state_6).index;

                    if ((operand_29 >= (operand_28).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_30 (operand_28)[@intCast(operand_29)];
                } != @as(u64, 0)) or ((state_6).member >= @as(u64, (block_31: {
                    break :block_31 value_3;
                }).len)))) block_35: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_6;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_34: {
                        break :block_34 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_33: {
                            break :block_33 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_32: {
                        break :block_32 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_35 value_8;
                } else block_76: {
                    const value_9: u64 = block_75: {
                        const operand_74 = block_73: {
                            const operand_71 = block_70: {
                                break :block_70 value_3;
                            };

                            const operand_72 = (state_6).member;

                            if ((operand_72 >= (operand_71).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_73 (operand_71)[@intCast(operand_72)];
                        };

                        break :block_75 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_74));
                    };
                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_41: {
                        const operand_40 = block_39: {
                            const operand_37 = (((state_6).request).table).kinds;

                            const operand_38 = block_36: {
                                break :block_36 value_9;
                            };

                            if ((operand_38 >= (operand_37).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_39 (operand_37)[@intCast(operand_38)];
                        };

                        break :block_41 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_40));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_45: {
                        const operand_43 = ((state_6).plan).mapping;

                        const operand_44 = block_42: {
                            break :block_42 value_9;
                        };

                        if ((operand_44 >= (operand_43).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_45 (operand_43)[@intCast(operand_44)];
                    } != @as(u64, 0)))) block_66: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_65: {
                            const operand_64 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_64).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_63: {
                                const operand_59 = block_58: {
                                    const operand_53 = (state_6).request;
                                    const operand_54 = (state_6).plan;
                                    const operand_55 = (state_6).modules;
                                    const operand_56 = (state_6).natives;
                                    const operand_57 = (state_6).index;

                                    break :block_58 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_53, .state = operand_54, .modules = operand_55, .natives = operand_56, .index = operand_57, });
                                };
                                var state_borrow_60: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_60 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_59).modules).identities, .import_names = ((operand_59).modules).import_names, .specifiers = ((operand_59).modules).specifiers, .type_ids = ((operand_59).modules).type_ids, .type_names = ((operand_59).modules).type_names, .type_namespaces = ((operand_59).modules).type_namespaces, };
                                var state_borrow_61: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_61 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_59).request).maximum_count, .names = ((operand_59).request).names, .origins = ((operand_59).request).origins, .roots = ((operand_59).request).roots, .scalar_count = ((operand_59).request).scalar_count, .table = ((operand_59).request).table, };

                                var state_borrow_62: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;
                                state_borrow_62 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_59).index, .modules = (((operand_59).modules).zx_origin orelse (&state_borrow_60)), .natives = (operand_59).natives, .request = (((operand_59).request).zx_origin orelse (&state_borrow_61)), .state = (operand_59).state, };

                                break :block_63 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_59).zx_origin orelse (&state_borrow_62)), .{ .lane_0 = .{ .buffer = (&state_capacity_18), .started = (&state_capacity_started_19), }, .lane_1 = .{ .buffer = (&state_capacity_20), .started = (&state_capacity_started_21), }, .lane_2 = .{ .buffer = (&state_capacity_22), .started = (&state_capacity_started_23), }, .lane_3 = .{ .buffer = (&state_capacity_24), .started = (&state_capacity_started_25), }, .lane_4 = .{ .buffer = (&state_capacity_26), .started = (&state_capacity_started_27), }, }));
                            });

                            break :block_65 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_64);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_6;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_52: {
                            break :block_52 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_51: {
                                break :block_51 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_50: {
                            break :block_50 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_49: {
                                break :block_49 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_48: {
                            break :block_48 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_47: {
                                break :block_47 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_46: {
                            break :block_46 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_66 value_19;
                    } else block_69: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_6;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_68: {
                            break :block_68 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_67: {
                                break :block_67 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_69 value_22;
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
            state_6 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_6).index, .member = (state_6).member, .modules = (state_6).modules, .natives = block_83: {
                const operand_82 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_82).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = state_owned_81, .order = ((state_6).natives).order, });

                break :block_83 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_82);
            }, .plan = (state_6).plan, .request = (state_6).request, };
        }

        var state_owned_84: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_84);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = (((state_6).natives).order).len;
            state_owned_84 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            state_6 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_6).index, .member = (state_6).member, .modules = (state_6).modules, .natives = block_86: {
                const operand_85 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_85).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = ((state_6).natives).mapping, .order = state_owned_84, });

                break :block_86 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_85);
            }, .plan = (state_6).plan, .request = (state_6).request, };
        }

        var state_owned_87: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_87);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = (((state_6).plan).mapping).len;
            state_owned_87 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            state_6 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_6).index, .member = (state_6).member, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_88).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = state_owned_87, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_89 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_88);
            }, .request = (state_6).request, };
        }

        var state_owned_90: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_90);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = (((state_6).plan).order).len;
            state_owned_90 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            state_6 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_6).index, .member = (state_6).member, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_91).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = state_owned_90, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_92 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_91);
            }, .request = (state_6).request, };
        }

        var state_owned_93: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = (((state_6).plan).origins).len;
            state_owned_93 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            state_6 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_6).index, .member = (state_6).member, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_94).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = state_owned_93, .status = ((state_6).plan).status, });

                break :block_95 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_94);
            }, .request = (state_6).request, };
        }

        break :block_103 (if (state_changed_17) block_102: {
            break :block_102 (if (((state_6).zx_origin != null)) (state_6).zx_origin.? else block_101: {
                const operand_100 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_100).* = (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_6).index, .member = (state_6).member, .modules = (if ((((state_6).modules).zx_origin != null)) ((state_6).modules).zx_origin.? else block_97: {
                    const operand_96 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_96).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_6).modules).identities, .import_names = ((state_6).modules).import_names, .specifiers = ((state_6).modules).specifiers, .type_ids = ((state_6).modules).type_ids, .type_names = ((state_6).modules).type_names, .type_namespaces = ((state_6).modules).type_namespaces, };

                    break :block_97 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_96);
                }), .natives = (state_6).natives, .plan = (state_6).plan, .request = (if ((((state_6).request).zx_origin != null)) ((state_6).request).zx_origin.? else block_99: {
                    const operand_98 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_98).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = ((state_6).request).origins, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = ((state_6).request).table, };

                    break :block_99 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_98);
                }), };

                break :block_101 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_100);
            });
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
        const operand_115 = block_114: {
            const operand_108 = (in).request;
            const operand_109 = (in).state;
            const operand_110 = (in).modules;
            const operand_111 = (in).natives;
            const operand_112 = @as(u64, 0);
            const operand_113 = @as(u64, 0);

            break :block_114 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_108, .plan = operand_109, .modules = operand_110, .natives = operand_111, .index = operand_112, .member = operand_113, };
        };

        var state_capacity_116: (std).ArrayList(u64) = .empty;
        var state_capacity_started_117 = false;

        defer (state_capacity_116).deinit(allocator);

        var state_capacity_118: (std).ArrayList(u32) = .empty;
        var state_capacity_started_119 = false;

        defer (state_capacity_118).deinit(allocator);

        var state_capacity_120: (std).ArrayList(u64) = .empty;
        var state_capacity_started_121 = false;

        defer (state_capacity_120).deinit(allocator);

        var state_capacity_122: (std).ArrayList(u32) = .empty;
        var state_capacity_started_123 = false;

        defer (state_capacity_122).deinit(allocator);

        var state_capacity_124: (std).ArrayList(u64) = .empty;
        var state_capacity_started_125 = false;

        defer (state_capacity_124).deinit(allocator);

        var state_107: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_115).index, .member = (operand_115).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_115).modules).identities, .import_names = ((operand_115).modules).import_names, .specifiers = ((operand_115).modules).specifiers, .type_ids = ((operand_115).modules).type_ids, .type_names = ((operand_115).modules).type_names, .type_namespaces = ((operand_115).modules).type_namespaces, .zx_origin = (operand_115).modules, }, .natives = (operand_115).natives, .plan = (operand_115).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_115).request).maximum_count, .names = ((operand_115).request).names, .origins = ((operand_115).request).origins, .roots = ((operand_115).request).roots, .scalar_count = ((operand_115).request).scalar_count, .table = ((operand_115).request).table, .zx_origin = (operand_115).request, }, .zx_origin = (&operand_115), };

        while (((((state_107).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_107).index < @as(u64, (((state_107).modules).specifiers).len)))) {
            state_107 = block_176: {
                const value_3: []const u32 = block_175: {
                    const operand_173 = ((state_107).modules).type_ids;
                    const operand_174 = (state_107).index;

                    if ((operand_174 >= (operand_173).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_175 (operand_173)[@intCast(operand_174)];
                };

                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_128: {
                    const operand_126 = ((state_107).natives).mapping;
                    const operand_127 = (state_107).index;

                    if ((operand_127 >= (operand_126).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_128 (operand_126)[@intCast(operand_127)];
                } != @as(u64, 0)) or ((state_107).member >= @as(u64, (block_129: {
                    break :block_129 value_3;
                }).len)))) block_133: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_107;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_132: {
                        break :block_132 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_131: {
                            break :block_131 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_130: {
                        break :block_130 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_133 value_8;
                } else block_172: {
                    const value_9: u64 = block_171: {
                        const operand_170 = block_169: {
                            const operand_167 = block_166: {
                                break :block_166 value_3;
                            };

                            const operand_168 = (state_107).member;

                            if ((operand_168 >= (operand_167).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_169 (operand_167)[@intCast(operand_168)];
                        };

                        break :block_171 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_170));
                    };
                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_139: {
                        const operand_138 = block_137: {
                            const operand_135 = (((state_107).request).table).kinds;

                            const operand_136 = block_134: {
                                break :block_134 value_9;
                            };

                            if ((operand_136 >= (operand_135).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_137 (operand_135)[@intCast(operand_136)];
                        };

                        break :block_139 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_138));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_143: {
                        const operand_141 = ((state_107).plan).mapping;

                        const operand_142 = block_140: {
                            break :block_140 value_9;
                        };

                        if ((operand_142 >= (operand_141).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_143 (operand_141)[@intCast(operand_142)];
                    } != @as(u64, 0)))) block_162: {
                        const value_10: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_161: {
                            const operand_157 = block_156: {
                                const operand_151 = (state_107).request;
                                const operand_152 = (state_107).plan;
                                const operand_153 = (state_107).modules;
                                const operand_154 = (state_107).natives;
                                const operand_155 = (state_107).index;

                                break :block_156 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_151, .state = operand_152, .modules = operand_153, .natives = operand_154, .index = operand_155, });
                            };
                            var state_borrow_158: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_158 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_157).modules).identities, .import_names = ((operand_157).modules).import_names, .specifiers = ((operand_157).modules).specifiers, .type_ids = ((operand_157).modules).type_ids, .type_names = ((operand_157).modules).type_names, .type_namespaces = ((operand_157).modules).type_namespaces, };

                            var state_borrow_159: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                            state_borrow_159 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_157).request).maximum_count, .names = ((operand_157).request).names, .origins = ((operand_157).request).origins, .roots = ((operand_157).request).roots, .scalar_count = ((operand_157).request).scalar_count, .table = ((operand_157).request).table, };

                            var state_borrow_160: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                            state_borrow_160 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_157).index, .modules = (((operand_157).modules).zx_origin orelse (&state_borrow_158)), .natives = (operand_157).natives, .request = (((operand_157).request).zx_origin orelse (&state_borrow_159)), .state = (operand_157).state, };

                            break :block_161 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_157).zx_origin orelse (&state_borrow_160)), .{ .lane_0 = .{ .buffer = (&state_capacity_116), .started = (&state_capacity_started_117), }, .lane_1 = .{ .buffer = (&state_capacity_118), .started = (&state_capacity_started_119), }, .lane_2 = .{ .buffer = (&state_capacity_120), .started = (&state_capacity_started_121), }, .lane_3 = .{ .buffer = (&state_capacity_122), .started = (&state_capacity_started_123), }, .lane_4 = .{ .buffer = (&state_capacity_124), .started = (&state_capacity_started_125), }, }));
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_107;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_150: {
                            break :block_150 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_149: {
                                break :block_149 (&value_10);
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_148: {
                            break :block_148 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_147: {
                                break :block_147 (&value_10);
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_146: {
                            break :block_146 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_145: {
                                break :block_145 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_144: {
                            break :block_144 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_162 value_19;
                    } else block_165: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_107;
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

        if (state_capacity_started_117) {
            ((state_capacity_116).items).len = (((state_107).natives).mapping).len;
            state_owned_177 = (try (state_capacity_116).toOwnedSlice(allocator));
        }

        if (state_capacity_started_117) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = block_179: {
                const operand_178 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_178).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_107).natives).count, .mapping = state_owned_177, .order = ((state_107).natives).order, });

                break :block_179 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_178);
            }, .plan = (state_107).plan, .request = (state_107).request, };
        }

        var state_owned_180: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_180);

        if (state_capacity_started_119) {
            ((state_capacity_118).items).len = (((state_107).natives).order).len;
            state_owned_180 = (try (state_capacity_118).toOwnedSlice(allocator));
        }

        if (state_capacity_started_119) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = block_182: {
                const operand_181 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_181).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_107).natives).count, .mapping = ((state_107).natives).mapping, .order = state_owned_180, });

                break :block_182 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_181);
            }, .plan = (state_107).plan, .request = (state_107).request, };
        }

        var state_owned_183: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_183);

        if (state_capacity_started_121) {
            ((state_capacity_120).items).len = (((state_107).plan).mapping).len;
            state_owned_183 = (try (state_capacity_120).toOwnedSlice(allocator));
        }

        if (state_capacity_started_121) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_185: {
                const operand_184 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_184).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = state_owned_183, .order = ((state_107).plan).order, .origins = ((state_107).plan).origins, .status = ((state_107).plan).status, });

                break :block_185 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_184);
            }, .request = (state_107).request, };
        }

        var state_owned_186: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_186);

        if (state_capacity_started_123) {
            ((state_capacity_122).items).len = (((state_107).plan).order).len;
            state_owned_186 = (try (state_capacity_122).toOwnedSlice(allocator));
        }

        if (state_capacity_started_123) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_188: {
                const operand_187 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_187).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = ((state_107).plan).mapping, .order = state_owned_186, .origins = ((state_107).plan).origins, .status = ((state_107).plan).status, });

                break :block_188 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_187);
            }, .request = (state_107).request, };
        }

        var state_owned_189: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_189);

        if (state_capacity_started_125) {
            ((state_capacity_124).items).len = (((state_107).plan).origins).len;
            state_owned_189 = (try (state_capacity_124).toOwnedSlice(allocator));
        }

        if (state_capacity_started_125) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_191: {
                const operand_190 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_190).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = ((state_107).plan).mapping, .order = ((state_107).plan).order, .origins = state_owned_189, .status = ((state_107).plan).status, });

                break :block_191 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_190);
            }, .request = (state_107).request, };
        }

        break :block_198 block_197: {
            break :block_197 (if (((state_107).zx_origin != null)) ((state_107).zx_origin.?).* else block_196: {
                break :block_196 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_107).index, .member = (state_107).member, .modules = (if ((((state_107).modules).zx_origin != null)) ((state_107).modules).zx_origin.? else block_193: {
                    const operand_192 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_192).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_107).modules).identities, .import_names = ((state_107).modules).import_names, .specifiers = ((state_107).modules).specifiers, .type_ids = ((state_107).modules).type_ids, .type_names = ((state_107).modules).type_names, .type_namespaces = ((state_107).modules).type_namespaces, };

                    break :block_193 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_192);
                }), .natives = (state_107).natives, .plan = (state_107).plan, .request = (if ((((state_107).request).zx_origin != null)) ((state_107).request).zx_origin.? else block_195: {
                    const operand_194 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_194).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_107).request).maximum_count, .names = ((state_107).request).names, .origins = ((state_107).request).origins, .roots = ((state_107).request).roots, .scalar_count = ((state_107).request).scalar_count, .table = ((state_107).request).table, };

                    break :block_195 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_194);
                }), };
            });
        };
    };

    return block_106: {
        const operand_104 = ((&value_25)).plan;
        const operand_105 = ((&value_25)).natives;

        break :block_106 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_104, .natives = operand_105, };
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

    const value_25: (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_268: {
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
            state_202 = block_261: {
                const value_3: []const u32 = block_260: {
                    const operand_258 = ((state_202).modules).type_ids;
                    const operand_259 = (state_202).index;

                    if ((operand_259 >= (operand_258).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_260 (operand_258)[@intCast(operand_259)];
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
                } else block_257: {
                    const value_9: u64 = block_256: {
                        const operand_255 = block_254: {
                            const operand_252 = block_251: {
                                break :block_251 value_3;
                            };

                            const operand_253 = (state_202).member;

                            if ((operand_253 >= (operand_252).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_254 (operand_252)[@intCast(operand_253)];
                        };

                        break :block_256 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_255));
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
                    } != @as(u64, 0)))) block_247: {
                        const value_10: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_246: {
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
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_202;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_235: {
                            break :block_235 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_234: {
                                break :block_234 (&value_10);
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_233: {
                            break :block_233 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_232: {
                                break :block_232 (&value_10);
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

                        break :block_247 value_19;
                    } else block_250: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_202;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_249: {
                            break :block_249 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_248: {
                                break :block_248 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_250 value_22;
                    });

                    break :block_257 value_23;
                });

                break :block_261 value_24;
            };
        }

        break :block_268 block_267: {
            break :block_267 (if (((state_202).zx_origin != null)) ((state_202).zx_origin.?).* else block_266: {
                break :block_266 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_202).index, .member = (state_202).member, .modules = (if ((((state_202).modules).zx_origin != null)) ((state_202).modules).zx_origin.? else block_263: {
                    const operand_262 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_262).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_202).modules).identities, .import_names = ((state_202).modules).import_names, .specifiers = ((state_202).modules).specifiers, .type_ids = ((state_202).modules).type_ids, .type_names = ((state_202).modules).type_names, .type_namespaces = ((state_202).modules).type_namespaces, };

                    break :block_263 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_262);
                }), .natives = (state_202).natives, .plan = (state_202).plan, .request = (if ((((state_202).request).zx_origin != null)) ((state_202).request).zx_origin.? else block_265: {
                    const operand_264 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_264).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_202).request).maximum_count, .names = ((state_202).request).names, .origins = ((state_202).request).origins, .roots = ((state_202).request).roots, .scalar_count = ((state_202).request).scalar_count, .table = ((state_202).request).table, };

                    break :block_265 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_264);
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

    const value_25: *const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_346: {
        const operand_284 = block_283: {
            const operand_275 = (in).request;
            const operand_276 = (in).state;
            const operand_277 = (in).modules;
            const operand_278 = (in).natives;
            const operand_279 = @as(u64, 0);
            const operand_280 = @as(u64, 0);

            break :block_283 block_282: {
                const operand_281 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_281).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_275, .plan = operand_276, .modules = operand_277, .natives = operand_278, .index = operand_279, .member = operand_280, });

                break :block_282 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_281);
            };
        };

        var state_274: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_284).index, .member = (operand_284).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_284).modules).identities, .import_names = ((operand_284).modules).import_names, .specifiers = ((operand_284).modules).specifiers, .type_ids = ((operand_284).modules).type_ids, .type_names = ((operand_284).modules).type_names, .type_namespaces = ((operand_284).modules).type_namespaces, .zx_origin = (operand_284).modules, }, .natives = (operand_284).natives, .plan = (operand_284).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_284).request).maximum_count, .names = ((operand_284).request).names, .origins = ((operand_284).request).origins, .roots = ((operand_284).request).roots, .scalar_count = ((operand_284).request).scalar_count, .table = ((operand_284).request).table, .zx_origin = (operand_284).request, }, .zx_origin = operand_284, };
        var state_changed_285 = false;

        while (((((state_274).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_274).index < @as(u64, (((state_274).modules).specifiers).len)))) {
            state_274 = block_338: {
                const value_3: []const u32 = block_337: {
                    const operand_335 = ((state_274).modules).type_ids;
                    const operand_336 = (state_274).index;

                    if ((operand_336 >= (operand_335).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_337 (operand_335)[@intCast(operand_336)];
                };

                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_288: {
                    const operand_286 = ((state_274).natives).mapping;
                    const operand_287 = (state_274).index;

                    if ((operand_287 >= (operand_286).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_288 (operand_286)[@intCast(operand_287)];
                } != @as(u64, 0)) or ((state_274).member >= @as(u64, (block_289: {
                    break :block_289 value_3;
                }).len)))) block_293: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_274;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_292: {
                        break :block_292 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_291: {
                            break :block_291 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_290: {
                        break :block_290 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_293 value_8;
                } else block_334: {
                    const value_9: u64 = block_333: {
                        const operand_332 = block_331: {
                            const operand_329 = block_328: {
                                break :block_328 value_3;
                            };

                            const operand_330 = (state_274).member;

                            if ((operand_330 >= (operand_329).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_331 (operand_329)[@intCast(operand_330)];
                        };

                        break :block_333 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_332));
                    };

                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_299: {
                        const operand_298 = block_297: {
                            const operand_295 = (((state_274).request).table).kinds;

                            const operand_296 = block_294: {
                                break :block_294 value_9;
                            };

                            if ((operand_296 >= (operand_295).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_297 (operand_295)[@intCast(operand_296)];
                        };

                        break :block_299 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_298));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_303: {
                        const operand_301 = ((state_274).plan).mapping;

                        const operand_302 = block_300: {
                            break :block_300 value_9;
                        };

                        if ((operand_302 >= (operand_301).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_303 (operand_301)[@intCast(operand_302)];
                    } != @as(u64, 0)))) block_324: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_323: {
                            const operand_322 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_322).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_321: {
                                const operand_317 = block_316: {
                                    const operand_311 = (state_274).request;
                                    const operand_312 = (state_274).plan;
                                    const operand_313 = (state_274).modules;
                                    const operand_314 = (state_274).natives;
                                    const operand_315 = (state_274).index;

                                    break :block_316 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_311, .state = operand_312, .modules = operand_313, .natives = operand_314, .index = operand_315, });
                                };
                                var state_borrow_318: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_318 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_317).modules).identities, .import_names = ((operand_317).modules).import_names, .specifiers = ((operand_317).modules).specifiers, .type_ids = ((operand_317).modules).type_ids, .type_names = ((operand_317).modules).type_names, .type_namespaces = ((operand_317).modules).type_namespaces, };

                                var state_borrow_319: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_319 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_317).request).maximum_count, .names = ((operand_317).request).names, .origins = ((operand_317).request).origins, .roots = ((operand_317).request).roots, .scalar_count = ((operand_317).request).scalar_count, .table = ((operand_317).request).table, };

                                var state_borrow_320: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;
                                state_borrow_320 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_317).index, .modules = (((operand_317).modules).zx_origin orelse (&state_borrow_318)), .natives = (operand_317).natives, .request = (((operand_317).request).zx_origin orelse (&state_borrow_319)), .state = (operand_317).state, };

                                break :block_321 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_317).zx_origin orelse (&state_borrow_320)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_323 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_322);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_274;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_310: {
                            break :block_310 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_309: {
                                break :block_309 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_308: {
                            break :block_308 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_307: {
                                break :block_307 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_306: {
                            break :block_306 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_305: {
                                break :block_305 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_304: {
                            break :block_304 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_324 value_19;
                    } else block_327: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_274;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_326: {
                            break :block_326 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_325: {
                                break :block_325 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_327 value_22;
                    });

                    break :block_334 value_23;
                });

                break :block_338 value_24;
            };

            state_changed_285 = true;
        }

        break :block_346 (if (state_changed_285) block_345: {
            break :block_345 (if (((state_274).zx_origin != null)) (state_274).zx_origin.? else block_344: {
                const operand_343 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_343).* = (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_274).index, .member = (state_274).member, .modules = (if ((((state_274).modules).zx_origin != null)) ((state_274).modules).zx_origin.? else block_340: {
                    const operand_339 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_339).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_274).modules).identities, .import_names = ((state_274).modules).import_names, .specifiers = ((state_274).modules).specifiers, .type_ids = ((state_274).modules).type_ids, .type_names = ((state_274).modules).type_names, .type_namespaces = ((state_274).modules).type_namespaces, };

                    break :block_340 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_339);
                }), .natives = (state_274).natives, .plan = (state_274).plan, .request = (if ((((state_274).request).zx_origin != null)) ((state_274).request).zx_origin.? else block_342: {
                    const operand_341 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_341).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_274).request).maximum_count, .names = ((state_274).request).names, .origins = ((state_274).request).origins, .roots = ((state_274).request).roots, .scalar_count = ((state_274).request).scalar_count, .table = ((state_274).request).table, };

                    break :block_342 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_341);
                }), };

                break :block_344 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_343);
            });
        } else operand_284);
    };

    return block_273: {
        const operand_269 = (value_25).plan;
        const operand_270 = (value_25).natives;

        break :block_273 block_272: {
            const operand_271 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_271).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_269, .natives = operand_270, });

            break :block_272 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_271);
        };
    };
}

