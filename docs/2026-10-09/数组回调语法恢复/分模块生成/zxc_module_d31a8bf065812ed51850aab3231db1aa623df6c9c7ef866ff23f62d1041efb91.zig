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

    const value_25: (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_200: {
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
            state_107 = block_178: {
                const value_3: []const u32 = block_177: {
                    const operand_175 = ((state_107).modules).type_ids;
                    const operand_176 = (state_107).index;

                    if ((operand_176 >= (operand_175).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_177 (operand_175)[@intCast(operand_176)];
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
                } else block_174: {
                    const value_9: u64 = block_173: {
                        const operand_172 = block_171: {
                            const operand_169 = block_168: {
                                break :block_168 value_3;
                            };

                            const operand_170 = (state_107).member;

                            if ((operand_170 >= (operand_169).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_171 (operand_169)[@intCast(operand_170)];
                        };

                        break :block_173 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_172));
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
                    } != @as(u64, 0)))) block_164: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_163: {
                            const operand_162 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_162).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_161: {
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
                            });

                            break :block_163 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_162);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_107;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_150: {
                            break :block_150 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_149: {
                                break :block_149 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_148: {
                            break :block_148 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_147: {
                                break :block_147 value_10;
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

                        break :block_164 value_19;
                    } else block_167: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_107;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_166: {
                            break :block_166 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_165: {
                                break :block_165 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_167 value_22;
                    });

                    break :block_174 value_23;
                });

                break :block_178 value_24;
            };
        }

        var state_owned_179: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_179);

        if (state_capacity_started_117) {
            ((state_capacity_116).items).len = (((state_107).natives).mapping).len;
            state_owned_179 = (try (state_capacity_116).toOwnedSlice(allocator));
        }

        if (state_capacity_started_117) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = block_181: {
                const operand_180 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_180).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_107).natives).count, .mapping = state_owned_179, .order = ((state_107).natives).order, });

                break :block_181 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_180);
            }, .plan = (state_107).plan, .request = (state_107).request, };
        }

        var state_owned_182: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_182);

        if (state_capacity_started_119) {
            ((state_capacity_118).items).len = (((state_107).natives).order).len;
            state_owned_182 = (try (state_capacity_118).toOwnedSlice(allocator));
        }

        if (state_capacity_started_119) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = block_184: {
                const operand_183 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_183).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_107).natives).count, .mapping = ((state_107).natives).mapping, .order = state_owned_182, });

                break :block_184 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_183);
            }, .plan = (state_107).plan, .request = (state_107).request, };
        }

        var state_owned_185: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_185);

        if (state_capacity_started_121) {
            ((state_capacity_120).items).len = (((state_107).plan).mapping).len;
            state_owned_185 = (try (state_capacity_120).toOwnedSlice(allocator));
        }

        if (state_capacity_started_121) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_187: {
                const operand_186 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_186).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = state_owned_185, .order = ((state_107).plan).order, .origins = ((state_107).plan).origins, .status = ((state_107).plan).status, });

                break :block_187 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_186);
            }, .request = (state_107).request, };
        }

        var state_owned_188: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_188);

        if (state_capacity_started_123) {
            ((state_capacity_122).items).len = (((state_107).plan).order).len;
            state_owned_188 = (try (state_capacity_122).toOwnedSlice(allocator));
        }

        if (state_capacity_started_123) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_190: {
                const operand_189 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_189).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = ((state_107).plan).mapping, .order = state_owned_188, .origins = ((state_107).plan).origins, .status = ((state_107).plan).status, });

                break :block_190 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_189);
            }, .request = (state_107).request, };
        }

        var state_owned_191: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_191);

        if (state_capacity_started_125) {
            ((state_capacity_124).items).len = (((state_107).plan).origins).len;
            state_owned_191 = (try (state_capacity_124).toOwnedSlice(allocator));
        }

        if (state_capacity_started_125) {
            state_107 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (state_107).index, .member = (state_107).member, .modules = (state_107).modules, .natives = (state_107).natives, .plan = block_193: {
                const operand_192 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_192).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_107).plan).count, .mapping = ((state_107).plan).mapping, .order = ((state_107).plan).order, .origins = state_owned_191, .status = ((state_107).plan).status, });

                break :block_193 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_192);
            }, .request = (state_107).request, };
        }

        break :block_200 block_199: {
            break :block_199 (if (((state_107).zx_origin != null)) ((state_107).zx_origin.?).* else block_198: {
                break :block_198 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_107).index, .member = (state_107).member, .modules = (if ((((state_107).modules).zx_origin != null)) ((state_107).modules).zx_origin.? else block_195: {
                    const operand_194 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_194).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_107).modules).identities, .import_names = ((state_107).modules).import_names, .specifiers = ((state_107).modules).specifiers, .type_ids = ((state_107).modules).type_ids, .type_names = ((state_107).modules).type_names, .type_namespaces = ((state_107).modules).type_namespaces, };

                    break :block_195 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_194);
                }), .natives = (state_107).natives, .plan = (state_107).plan, .request = (if ((((state_107).request).zx_origin != null)) ((state_107).request).zx_origin.? else block_197: {
                    const operand_196 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_196).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_107).request).maximum_count, .names = ((state_107).request).names, .origins = ((state_107).request).origins, .roots = ((state_107).request).roots, .scalar_count = ((state_107).request).scalar_count, .table = ((state_107).request).table, };

                    break :block_197 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_196);
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

    const value_25: (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_272: {
        const operand_212 = block_211: {
            const operand_205 = (in).request;
            const operand_206 = (in).state;
            const operand_207 = (in).modules;
            const operand_208 = (in).natives;
            const operand_209 = @as(u64, 0);
            const operand_210 = @as(u64, 0);

            break :block_211 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_205, .plan = operand_206, .modules = operand_207, .natives = operand_208, .index = operand_209, .member = operand_210, };
        };

        var state_204: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_212).index, .member = (operand_212).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_212).modules).identities, .import_names = ((operand_212).modules).import_names, .specifiers = ((operand_212).modules).specifiers, .type_ids = ((operand_212).modules).type_ids, .type_names = ((operand_212).modules).type_names, .type_namespaces = ((operand_212).modules).type_namespaces, .zx_origin = (operand_212).modules, }, .natives = (operand_212).natives, .plan = (operand_212).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_212).request).maximum_count, .names = ((operand_212).request).names, .origins = ((operand_212).request).origins, .roots = ((operand_212).request).roots, .scalar_count = ((operand_212).request).scalar_count, .table = ((operand_212).request).table, .zx_origin = (operand_212).request, }, .zx_origin = (&operand_212), };

        while (((((state_204).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_204).index < @as(u64, (((state_204).modules).specifiers).len)))) {
            state_204 = block_265: {
                const value_3: []const u32 = block_264: {
                    const operand_262 = ((state_204).modules).type_ids;
                    const operand_263 = (state_204).index;

                    if ((operand_263 >= (operand_262).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_264 (operand_262)[@intCast(operand_263)];
                };
                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_215: {
                    const operand_213 = ((state_204).natives).mapping;
                    const operand_214 = (state_204).index;

                    if ((operand_214 >= (operand_213).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_215 (operand_213)[@intCast(operand_214)];
                } != @as(u64, 0)) or ((state_204).member >= @as(u64, (block_216: {
                    break :block_216 value_3;
                }).len)))) block_220: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_204;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_219: {
                        break :block_219 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_218: {
                            break :block_218 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_217: {
                        break :block_217 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_220 value_8;
                } else block_261: {
                    const value_9: u64 = block_260: {
                        const operand_259 = block_258: {
                            const operand_256 = block_255: {
                                break :block_255 value_3;
                            };

                            const operand_257 = (state_204).member;

                            if ((operand_257 >= (operand_256).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_258 (operand_256)[@intCast(operand_257)];
                        };

                        break :block_260 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_259));
                    };
                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_226: {
                        const operand_225 = block_224: {
                            const operand_222 = (((state_204).request).table).kinds;

                            const operand_223 = block_221: {
                                break :block_221 value_9;
                            };

                            if ((operand_223 >= (operand_222).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_224 (operand_222)[@intCast(operand_223)];
                        };

                        break :block_226 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_225));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_230: {
                        const operand_228 = ((state_204).plan).mapping;

                        const operand_229 = block_227: {
                            break :block_227 value_9;
                        };

                        if ((operand_229 >= (operand_228).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_230 (operand_228)[@intCast(operand_229)];
                    } != @as(u64, 0)))) block_251: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_250: {
                            const operand_249 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_249).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_248: {
                                const operand_244 = block_243: {
                                    const operand_238 = (state_204).request;
                                    const operand_239 = (state_204).plan;
                                    const operand_240 = (state_204).modules;
                                    const operand_241 = (state_204).natives;
                                    const operand_242 = (state_204).index;

                                    break :block_243 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_238, .state = operand_239, .modules = operand_240, .natives = operand_241, .index = operand_242, });
                                };
                                var state_borrow_245: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_245 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_244).modules).identities, .import_names = ((operand_244).modules).import_names, .specifiers = ((operand_244).modules).specifiers, .type_ids = ((operand_244).modules).type_ids, .type_names = ((operand_244).modules).type_names, .type_namespaces = ((operand_244).modules).type_namespaces, };

                                var state_borrow_246: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_246 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_244).request).maximum_count, .names = ((operand_244).request).names, .origins = ((operand_244).request).origins, .roots = ((operand_244).request).roots, .scalar_count = ((operand_244).request).scalar_count, .table = ((operand_244).request).table, };

                                var state_borrow_247: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_247 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_244).index, .modules = (((operand_244).modules).zx_origin orelse (&state_borrow_245)), .natives = (operand_244).natives, .request = (((operand_244).request).zx_origin orelse (&state_borrow_246)), .state = (operand_244).state, };

                                break :block_248 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_244).zx_origin orelse (&state_borrow_247)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_250 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_249);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_204;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_237: {
                            break :block_237 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_236: {
                                break :block_236 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_235: {
                            break :block_235 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_234: {
                                break :block_234 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_233: {
                            break :block_233 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_232: {
                                break :block_232 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_231: {
                            break :block_231 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_251 value_19;
                    } else block_254: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_204;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_253: {
                            break :block_253 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_252: {
                                break :block_252 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_254 value_22;
                    });

                    break :block_261 value_23;
                });

                break :block_265 value_24;
            };
        }

        break :block_272 block_271: {
            break :block_271 (if (((state_204).zx_origin != null)) ((state_204).zx_origin.?).* else block_270: {
                break :block_270 (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_204).index, .member = (state_204).member, .modules = (if ((((state_204).modules).zx_origin != null)) ((state_204).modules).zx_origin.? else block_267: {
                    const operand_266 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_266).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_204).modules).identities, .import_names = ((state_204).modules).import_names, .specifiers = ((state_204).modules).specifiers, .type_ids = ((state_204).modules).type_ids, .type_names = ((state_204).modules).type_names, .type_namespaces = ((state_204).modules).type_namespaces, };

                    break :block_267 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_266);
                }), .natives = (state_204).natives, .plan = (state_204).plan, .request = (if ((((state_204).request).zx_origin != null)) ((state_204).request).zx_origin.? else block_269: {
                    const operand_268 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_268).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_204).request).maximum_count, .names = ((state_204).request).names, .origins = ((state_204).request).origins, .roots = ((state_204).request).roots, .scalar_count = ((state_204).request).scalar_count, .table = ((state_204).request).table, };

                    break :block_269 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_268);
                }), };
            });
        };
    };

    return block_203: {
        const operand_201 = ((&value_25)).plan;
        const operand_202 = ((&value_25)).natives;

        break :block_203 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_201, .natives = operand_202, };
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

    const value_25: *const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = block_350: {
        const operand_288 = block_287: {
            const operand_279 = (in).request;
            const operand_280 = (in).state;
            const operand_281 = (in).modules;
            const operand_282 = (in).natives;
            const operand_283 = @as(u64, 0);
            const operand_284 = @as(u64, 0);

            break :block_287 block_286: {
                const operand_285 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_285).* = @as((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .request = operand_279, .plan = operand_280, .modules = operand_281, .natives = operand_282, .index = operand_283, .member = operand_284, });

                break :block_286 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_285);
            };
        };

        var state_278: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (operand_288).index, .member = (operand_288).member, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_288).modules).identities, .import_names = ((operand_288).modules).import_names, .specifiers = ((operand_288).modules).specifiers, .type_ids = ((operand_288).modules).type_ids, .type_names = ((operand_288).modules).type_names, .type_namespaces = ((operand_288).modules).type_namespaces, .zx_origin = (operand_288).modules, }, .natives = (operand_288).natives, .plan = (operand_288).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_288).request).maximum_count, .names = ((operand_288).request).names, .origins = ((operand_288).request).origins, .roots = ((operand_288).request).roots, .scalar_count = ((operand_288).request).scalar_count, .table = ((operand_288).request).table, .zx_origin = (operand_288).request, }, .zx_origin = operand_288, };
        var state_changed_289 = false;

        while (((((state_278).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_278).index < @as(u64, (((state_278).modules).specifiers).len)))) {
            state_278 = block_342: {
                const value_3: []const u32 = block_341: {
                    const operand_339 = ((state_278).modules).type_ids;
                    const operand_340 = (state_278).index;

                    if ((operand_340 >= (operand_339).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_341 (operand_339)[@intCast(operand_340)];
                };
                const value_24: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_292: {
                    const operand_290 = ((state_278).natives).mapping;
                    const operand_291 = (state_278).index;

                    if ((operand_291 >= (operand_290).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_292 (operand_290)[@intCast(operand_291)];
                } != @as(u64, 0)) or ((state_278).member >= @as(u64, (block_293: {
                    break :block_293 value_3;
                }).len)))) block_297: {
                    const value_4: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_278;
                    const value_5: u64 = (value_4).index;

                    const value_6: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_296: {
                        break :block_296 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_295: {
                            break :block_295 value_5;
                        } + @as(u64, 1)), .member = (value_4).member, .modules = (value_4).modules, .natives = (value_4).natives, .plan = (value_4).plan, .request = (value_4).request, });
                    };

                    const value_7: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_6;

                    const value_8: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_294: {
                        break :block_294 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_7).index, .member = @as(u64, 0), .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    break :block_297 value_8;
                } else block_338: {
                    const value_9: u64 = block_337: {
                        const operand_336 = block_335: {
                            const operand_333 = block_332: {
                                break :block_332 value_3;
                            };

                            const operand_334 = (state_278).member;

                            if ((operand_334 >= (operand_333).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_335 (operand_333)[@intCast(operand_334)];
                        };

                        break :block_337 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_336));
                    };

                    const value_23: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = (if (((block_303: {
                        const operand_302 = block_301: {
                            const operand_299 = (((state_278).request).table).kinds;

                            const operand_300 = block_298: {
                                break :block_298 value_9;
                            };

                            if ((operand_300 >= (operand_299).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_301 (operand_299)[@intCast(operand_300)];
                        };

                        break :block_303 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_302));
                    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)) and (block_307: {
                        const operand_305 = ((state_278).plan).mapping;

                        const operand_306 = block_304: {
                            break :block_304 value_9;
                        };

                        if ((operand_306 >= (operand_305).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_307 (operand_305)[@intCast(operand_306)];
                    } != @as(u64, 0)))) block_328: {
                        const value_10: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_327: {
                            const operand_326 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_326).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_325: {
                                const operand_321 = block_320: {
                                    const operand_315 = (state_278).request;
                                    const operand_316 = (state_278).plan;
                                    const operand_317 = (state_278).modules;
                                    const operand_318 = (state_278).natives;
                                    const operand_319 = (state_278).index;

                                    break :block_320 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_315, .state = operand_316, .modules = operand_317, .natives = operand_318, .index = operand_319, });
                                };
                                var state_borrow_322: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_322 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_321).modules).identities, .import_names = ((operand_321).modules).import_names, .specifiers = ((operand_321).modules).specifiers, .type_ids = ((operand_321).modules).type_ids, .type_names = ((operand_321).modules).type_names, .type_namespaces = ((operand_321).modules).type_namespaces, };

                                var state_borrow_323: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_323 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_321).request).maximum_count, .names = ((operand_321).request).names, .origins = ((operand_321).request).origins, .roots = ((operand_321).request).roots, .scalar_count = ((operand_321).request).scalar_count, .table = ((operand_321).request).table, };

                                var state_borrow_324: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_324 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_321).index, .modules = (((operand_321).modules).zx_origin orelse (&state_borrow_322)), .natives = (operand_321).natives, .request = (((operand_321).request).zx_origin orelse (&state_borrow_323)), .state = (operand_321).state, };

                                break :block_325 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_321).zx_origin orelse (&state_borrow_324)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_327 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_326);
                        };

                        const value_11: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_278;

                        const value_12: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_314: {
                            break :block_314 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_11).index, .member = (value_11).member, .modules = (value_11).modules, .natives = (value_11).natives, .plan = (block_313: {
                                break :block_313 value_10;
                            }).state, .request = (value_11).request, });
                        };
                        const value_13: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_12;

                        const value_14: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_312: {
                            break :block_312 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_13).index, .member = (value_13).member, .modules = (value_13).modules, .natives = (block_311: {
                                break :block_311 value_10;
                            }).natives, .plan = (value_13).plan, .request = (value_13).request, });
                        };

                        const value_15: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_14;
                        const value_16: u64 = (value_15).index;

                        const value_17: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_310: {
                            break :block_310 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (block_309: {
                                break :block_309 value_16;
                            } + @as(u64, 1)), .member = (value_15).member, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_15).plan, .request = (value_15).request, });
                        };

                        const value_18: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = value_17;

                        const value_19: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_308: {
                            break :block_308 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_18).index, .member = @as(u64, 0), .modules = (value_18).modules, .natives = (value_18).natives, .plan = (value_18).plan, .request = (value_18).request, });
                        };

                        break :block_328 value_19;
                    } else block_331: {
                        const value_20: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = state_278;
                        const value_21: u64 = (value_20).member;

                        const value_22: (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = block_330: {
                            break :block_330 @as((zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3, (zx_abi).value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3{ .index = (value_20).index, .member = (block_329: {
                                break :block_329 value_21;
                            } + @as(u64, 1)), .modules = (value_20).modules, .natives = (value_20).natives, .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_331 value_22;
                    });

                    break :block_338 value_23;
                });

                break :block_342 value_24;
            };

            state_changed_289 = true;
        }

        break :block_350 (if (state_changed_289) block_349: {
            break :block_349 (if (((state_278).zx_origin != null)) (state_278).zx_origin.? else block_348: {
                const operand_347 = (try (allocator).create((zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a));

                (operand_347).* = (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a{ .index = (state_278).index, .member = (state_278).member, .modules = (if ((((state_278).modules).zx_origin != null)) ((state_278).modules).zx_origin.? else block_344: {
                    const operand_343 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_343).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_278).modules).identities, .import_names = ((state_278).modules).import_names, .specifiers = ((state_278).modules).specifiers, .type_ids = ((state_278).modules).type_ids, .type_names = ((state_278).modules).type_names, .type_namespaces = ((state_278).modules).type_namespaces, };

                    break :block_344 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_343);
                }), .natives = (state_278).natives, .plan = (state_278).plan, .request = (if ((((state_278).request).zx_origin != null)) ((state_278).request).zx_origin.? else block_346: {
                    const operand_345 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_345).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_278).request).maximum_count, .names = ((state_278).request).names, .origins = ((state_278).request).origins, .roots = ((state_278).request).roots, .scalar_count = ((state_278).request).scalar_count, .table = ((state_278).request).table, };

                    break :block_346 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_345);
                }), };

                break :block_348 @as(*const (zx_abi).zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a, operand_347);
            });
        } else operand_288);
    };

    return block_277: {
        const operand_273 = (value_25).plan;
        const operand_274 = (value_25).natives;

        break :block_277 block_276: {
            const operand_275 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_275).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_273, .natives = operand_274, });

            break :block_276 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_275);
        };
    };
}

