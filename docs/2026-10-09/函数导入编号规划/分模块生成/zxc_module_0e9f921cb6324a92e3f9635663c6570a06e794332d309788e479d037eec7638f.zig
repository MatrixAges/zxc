const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_38: *const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = block_208: {
        const operand_11 = block_10: {
            const operand_2 = (in).request;
            const operand_3 = (in).modules;
            const operand_4 = (in).signatures;
            const operand_5 = (in).imports;
            const operand_6 = (in).plan;
            const operand_7 = @as(u64, 0);

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba));

                (operand_8).* = @as((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .request = operand_2, .modules = operand_3, .signatures = operand_4, .imports = operand_5, .plan = operand_6, .index = operand_7, });

                break :block_9 @as(*const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, operand_8);
            };
        };

        var state_capacity_13: (std).ArrayList(u64) = .empty;
        var state_capacity_started_14 = false;

        defer (state_capacity_13).deinit(allocator);

        var state_capacity_15: (std).ArrayList(u32) = .empty;
        var state_capacity_started_16 = false;

        defer (state_capacity_15).deinit(allocator);

        var state_capacity_17: (std).ArrayList(u64) = .empty;
        var state_capacity_started_18 = false;

        defer (state_capacity_17).deinit(allocator);

        var state_capacity_19: (std).ArrayList(u32) = .empty;
        var state_capacity_started_20 = false;

        defer (state_capacity_19).deinit(allocator);

        var state_capacity_21: (std).ArrayList(u64) = .empty;
        var state_capacity_started_22 = false;

        defer (state_capacity_21).deinit(allocator);

        var state_capacity_23: (std).ArrayList(u32) = .empty;
        var state_capacity_started_24 = false;

        defer (state_capacity_23).deinit(allocator);

        var state_capacity_25: (std).ArrayList(u64) = .empty;
        var state_capacity_started_26 = false;

        defer (state_capacity_25).deinit(allocator);

        var state_1: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (zx_abi).value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .ids = ((operand_11).imports).ids, .inputs = ((operand_11).imports).inputs, .outputs = ((operand_11).imports).outputs, .zx_origin = (operand_11).imports, }, .index = (operand_11).index, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_11).modules).identities, .import_names = ((operand_11).modules).import_names, .specifiers = ((operand_11).modules).specifiers, .type_ids = ((operand_11).modules).type_ids, .type_names = ((operand_11).modules).type_names, .type_namespaces = ((operand_11).modules).type_namespaces, .zx_origin = (operand_11).modules, }, .plan = (operand_11).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_11).request).maximum_count, .names = ((operand_11).request).names, .origins = ((operand_11).request).origins, .roots = ((operand_11).request).roots, .scalar_count = ((operand_11).request).scalar_count, .table = ((operand_11).request).table, .zx_origin = (operand_11).request, }, .signatures = (zx_abi).value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .inputs = ((operand_11).signatures).inputs, .native_modules = ((operand_11).signatures).native_modules, .outputs = ((operand_11).signatures).outputs, .zx_origin = (operand_11).signatures, }, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while ((((((state_1).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_1).index < @as(u64, (((state_1).imports).ids).len)))) {
            state_1 = block_161: {
                const value_3: u64 = block_160: {
                    const operand_159 = block_158: {
                        const operand_156 = ((state_1).imports).ids;
                        const operand_157 = (state_1).index;

                        if ((operand_157 >= (operand_156).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_158 (operand_156)[@intCast(operand_157)];
                    };

                    break :block_160 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_159));
                };

                const value_34: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_29: {
                    break :block_29 value_3;
                } >= @as(u64, (((state_1).signatures).inputs).len))) block_44: {
                    const value_4: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_1;
                    const value_5: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_4).plan;

                    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (block_43: {
                        break :block_43 value_5;
                    }).state;

                    const value_7: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_42: {
                        break :block_42 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_4).imports, .index = (value_4).index, .modules = (value_4).modules, .plan = block_41: {
                            break :block_41 block_40: {
                                const operand_39 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                (operand_39).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_30: {
                                    break :block_30 value_5;
                                }).functions, .natives = (block_31: {
                                    break :block_31 value_5;
                                }).natives, .state = block_38: {
                                    break :block_38 block_37: {
                                        const operand_36 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                        (operand_36).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_32: {
                                            break :block_32 value_6;
                                        }).count, .mapping = (block_33: {
                                            break :block_33 value_6;
                                        }).mapping, .order = (block_34: {
                                            break :block_34 value_6;
                                        }).order, .origins = (block_35: {
                                            break :block_35 value_6;
                                        }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                        break :block_37 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_36);
                                    };
                                }, });

                                break :block_40 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_39);
                            };
                        }, .request = (value_4).request, .signatures = (value_4).signatures, });
                    };

                    break :block_44 value_7;
                } else block_155: {
                    const value_33: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((block_47: {
                        const operand_45 = ((state_1).imports).inputs;
                        const operand_46 = (state_1).index;

                        if ((operand_46 >= (operand_45).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_47 (operand_45)[@intCast(operand_46)];
                    } != block_51: {
                        const operand_49 = ((state_1).signatures).inputs;

                        const operand_50 = block_48: {
                            break :block_48 value_3;
                        };

                        if ((operand_50 >= (operand_49).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_51 (operand_49)[@intCast(operand_50)];
                    }) or (block_54: {
                        const operand_52 = ((state_1).imports).outputs;
                        const operand_53 = (state_1).index;

                        if ((operand_53 >= (operand_52).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_54 (operand_52)[@intCast(operand_53)];
                    } != block_58: {
                        const operand_56 = ((state_1).signatures).outputs;

                        const operand_57 = block_55: {
                            break :block_55 value_3;
                        };

                        if ((operand_57 >= (operand_56).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_58 (operand_56)[@intCast(operand_57)];
                    }))) block_73: {
                        const value_8: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_1;
                        const value_9: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_8).plan;

                        const value_10: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (block_72: {
                            break :block_72 value_9;
                        }).state;

                        const value_11: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_71: {
                            break :block_71 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_8).imports, .index = (value_8).index, .modules = (value_8).modules, .plan = block_70: {
                                break :block_70 block_69: {
                                    const operand_68 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_68).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_59: {
                                        break :block_59 value_9;
                                    }).functions, .natives = (block_60: {
                                        break :block_60 value_9;
                                    }).natives, .state = block_67: {
                                        break :block_67 block_66: {
                                            const operand_65 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_65).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_61: {
                                                break :block_61 value_10;
                                            }).count, .mapping = (block_62: {
                                                break :block_62 value_10;
                                            }).mapping, .order = (block_63: {
                                                break :block_63 value_10;
                                            }).order, .origins = (block_64: {
                                                break :block_64 value_10;
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                            break :block_66 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_65);
                                        };
                                    }, });

                                    break :block_69 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_68);
                                };
                            }, .request = (value_8).request, .signatures = (value_8).signatures, });
                        };

                        break :block_73 value_11;
                    } else block_154: {
                        const value_32: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_77: {
                            const operand_75 = (((state_1).plan).functions).mapping;

                            const operand_76 = block_74: {
                                break :block_74 value_3;
                            };

                            if ((operand_76 >= (operand_75).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_77 (operand_75)[@intCast(operand_76)];
                        } == @as(u64, 0))) block_153: {
                            const value_12: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_1;

                            const value_13: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_152: {
                                break :block_152 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_12).imports, .index = (value_12).index, .modules = (value_12).modules, .plan = block_151: {
                                    const operand_150 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_150).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, block_149: {
                                        const operand_144 = block_143: {
                                            const operand_137 = (state_1).request;
                                            const operand_138 = (state_1).modules;
                                            const operand_139 = (state_1).signatures;
                                            const operand_140 = (state_1).plan;
                                            const operand_141 = block_142: {
                                                break :block_142 value_3;
                                            };

                                            break :block_143 @as((zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7, (zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7{ .request = operand_137, .modules = operand_138, .signatures = operand_139, .plan = operand_140, .index = operand_141, });
                                        };

                                        var state_borrow_145: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                        state_borrow_145 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_144).modules).identities, .import_names = ((operand_144).modules).import_names, .specifiers = ((operand_144).modules).specifiers, .type_ids = ((operand_144).modules).type_ids, .type_names = ((operand_144).modules).type_names, .type_namespaces = ((operand_144).modules).type_namespaces, };

                                        var state_borrow_146: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                        state_borrow_146 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_144).request).maximum_count, .names = ((operand_144).request).names, .origins = ((operand_144).request).origins, .roots = ((operand_144).request).roots, .scalar_count = ((operand_144).request).scalar_count, .table = ((operand_144).request).table, };

                                        var state_borrow_147: (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = undefined;
                                        state_borrow_147 = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((operand_144).signatures).inputs, .native_modules = ((operand_144).signatures).native_modules, .outputs = ((operand_144).signatures).outputs, };

                                        var state_borrow_148: (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = undefined;
                                        state_borrow_148 = (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517{ .index = (operand_144).index, .modules = (((operand_144).modules).zx_origin orelse (&state_borrow_145)), .plan = (operand_144).plan, .request = (((operand_144).request).zx_origin orelse (&state_borrow_146)), .signatures = (((operand_144).signatures).zx_origin orelse (&state_borrow_147)), };

                                        break :block_149 (try (@import("zxc_module_124d04c56d807c136dc19893a96e3b11ff5a660d20886242da64af429cd4c503")).callBuffered(allocator, ((operand_144).zx_origin orelse (&state_borrow_148)), .{ .lane_0 = .{ .buffer = (&state_capacity_13), .started = (&state_capacity_started_14), }, .lane_1 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, .lane_2 = .{ .buffer = (&state_capacity_17), .started = (&state_capacity_started_18), }, .lane_3 = .{ .buffer = (&state_capacity_19), .started = (&state_capacity_started_20), }, .lane_4 = .{ .buffer = (&state_capacity_21), .started = (&state_capacity_started_22), }, .lane_5 = .{ .buffer = (&state_capacity_23), .started = (&state_capacity_started_24), }, .lane_6 = .{ .buffer = (&state_capacity_25), .started = (&state_capacity_started_26), }, }));
                                    });

                                    break :block_151 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_150);
                                }, .request = (value_12).request, .signatures = (value_12).signatures, });
                            };

                            const value_31: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((((value_13).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) block_136: {
                                const value_14: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_13;
                                const value_15: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_14).plan;

                                const value_16: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_135: {
                                    break :block_135 value_15;
                                }).functions;
                                const value_17: []const u64 = (block_134: {
                                    break :block_134 value_16;
                                }).mapping;
                                const value_18: u64 = block_133: {
                                    break :block_133 value_3;
                                };
                                const value_19: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_132: {
                                    break :block_132 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_14).imports, .index = (value_14).index, .modules = (value_14).modules, .plan = block_131: {
                                        break :block_131 block_130: {
                                            const operand_129 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_129).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_126: {
                                                break :block_126 block_125: {
                                                    const operand_124 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_124).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_115: {
                                                        break :block_115 value_16;
                                                    }).count, .mapping = block_122: {
                                                        const operand_117 = block_116: {
                                                            break :block_116 value_17;
                                                        };
                                                        const operand_119 = block_118: {
                                                            break :block_118 value_18;
                                                        };

                                                        if ((operand_119 >= (operand_117).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        const operand_120 = ((((value_13).plan).functions).count + @as(u64, 1));

                                                        break :block_122 block_121: {
                                                            if ((!state_capacity_started_14)) {
                                                                (try (state_capacity_13).appendSlice(allocator, operand_117));

                                                                state_capacity_started_14 = true;
                                                            } else {
                                                                ((state_capacity_13).items).len = (operand_117).len;
                                                            }

                                                            ((state_capacity_13).items)[@intCast(operand_119)] = operand_120;
                                                            break :block_121 (state_capacity_13).items;
                                                        };
                                                    }, .order = (block_123: {
                                                        break :block_123 value_16;
                                                    }).order, });

                                                    break :block_125 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_124);
                                                };
                                            }, .natives = (block_127: {
                                                break :block_127 value_15;
                                            }).natives, .state = (block_128: {
                                                break :block_128 value_15;
                                            }).state, });

                                            break :block_130 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_129);
                                        };
                                    }, .request = (value_14).request, .signatures = (value_14).signatures, });
                                };
                                const value_20: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_19;
                                const value_21: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_20).plan;

                                const value_22: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_114: {
                                    break :block_114 value_21;
                                }).functions;
                                const value_23: []const u32 = (block_113: {
                                    break :block_113 value_22;
                                }).order;

                                const value_24: u64 = (((value_19).plan).functions).count;

                                const value_25: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_112: {
                                    break :block_112 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_20).imports, .index = (value_20).index, .modules = (value_20).modules, .plan = block_111: {
                                        break :block_111 block_110: {
                                            const operand_109 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_109).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_106: {
                                                break :block_106 block_105: {
                                                    const operand_104 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_104).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_92: {
                                                        break :block_92 value_22;
                                                    }).count, .mapping = (block_93: {
                                                        break :block_93 value_22;
                                                    }).mapping, .order = block_103: {
                                                        const operand_95 = block_94: {
                                                            break :block_94 value_23;
                                                        };
                                                        const operand_97 = block_96: {
                                                            break :block_96 value_24;
                                                        };

                                                        if ((operand_97 >= (operand_95).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }
                                                        const operand_101 = block_100: {
                                                            const operand_99 = block_98: {
                                                                break :block_98 value_3;
                                                            };

                                                            break :block_100 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_99));
                                                        };
                                                        break :block_103 block_102: {
                                                            if ((!state_capacity_started_16)) {
                                                                (try (state_capacity_15).appendSlice(allocator, operand_95));
                                                                state_capacity_started_16 = true;
                                                            } else {
                                                                ((state_capacity_15).items).len = (operand_95).len;
                                                            }

                                                            ((state_capacity_15).items)[@intCast(operand_97)] = operand_101;
                                                            break :block_102 (state_capacity_15).items;
                                                        };
                                                    }, });

                                                    break :block_105 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_104);
                                                };
                                            }, .natives = (block_107: {
                                                break :block_107 value_21;
                                            }).natives, .state = (block_108: {
                                                break :block_108 value_21;
                                            }).state, });

                                            break :block_110 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_109);
                                        };
                                    }, .request = (value_20).request, .signatures = (value_20).signatures, });
                                };
                                const value_26: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_25;
                                const value_27: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_26).plan;

                                const value_28: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_91: {
                                    break :block_91 value_27;
                                }).functions;
                                const value_29: u64 = (block_90: {
                                    break :block_90 value_28;
                                }).count;
                                const value_30: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_89: {
                                    break :block_89 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_26).imports, .index = (value_26).index, .modules = (value_26).modules, .plan = block_88: {
                                        break :block_88 block_87: {
                                            const operand_86 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_86).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_83: {
                                                break :block_83 block_82: {
                                                    const operand_81 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_81).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_78: {
                                                        break :block_78 value_29;
                                                    } + @as(u64, 1)), .mapping = (block_79: {
                                                        break :block_79 value_28;
                                                    }).mapping, .order = (block_80: {
                                                        break :block_80 value_28;
                                                    }).order, });

                                                    break :block_82 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_81);
                                                };
                                            }, .natives = (block_84: {
                                                break :block_84 value_27;
                                            }).natives, .state = (block_85: {
                                                break :block_85 value_27;
                                            }).state, });

                                            break :block_87 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_86);
                                        };
                                    }, .request = (value_26).request, .signatures = (value_26).signatures, });
                                };

                                break :block_136 value_30;
                            } else value_13);

                            break :block_153 value_31;
                        } else state_1);

                        break :block_154 value_32;
                    });

                    break :block_155 value_33;
                });

                const value_35: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_28: {
                    break :block_28 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_35).imports, .index = (block_27: {
                        break :block_27 value_36;
                    } + @as(u64, 1)), .modules = (value_35).modules, .plan = (value_35).plan, .request = (value_35).request, .signatures = (value_35).signatures, });
                };

                break :block_161 value_37;
            };

            state_changed_12 = true;
        }

        var state_owned_162: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_162);

        if (state_capacity_started_14) {
            ((state_capacity_13).items).len = ((((state_1).plan).functions).mapping).len;
            state_owned_162 = (try (state_capacity_13).toOwnedSlice(allocator));
        }

        if (state_capacity_started_14) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_166: {
                const operand_165 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_165).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_164: {
                    const operand_163 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_163).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_1).plan).functions).count, .mapping = state_owned_162, .order = (((state_1).plan).functions).order, });

                    break :block_164 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_163);
                }, .natives = ((state_1).plan).natives, .state = ((state_1).plan).state, });

                break :block_166 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_165);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_167: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_167);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = ((((state_1).plan).functions).order).len;
            state_owned_167 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_171: {
                const operand_170 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_170).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_169: {
                    const operand_168 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_168).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_1).plan).functions).count, .mapping = (((state_1).plan).functions).mapping, .order = state_owned_167, });

                    break :block_169 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_168);
                }, .natives = ((state_1).plan).natives, .state = ((state_1).plan).state, });

                break :block_171 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_170);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_172: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_172);

        if (state_capacity_started_18) {
            ((state_capacity_17).items).len = ((((state_1).plan).natives).mapping).len;
            state_owned_172 = (try (state_capacity_17).toOwnedSlice(allocator));
        }

        if (state_capacity_started_18) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_176: {
                const operand_175 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_175).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_1).plan).functions, .natives = block_174: {
                    const operand_173 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_173).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_1).plan).natives).count, .mapping = state_owned_172, .order = (((state_1).plan).natives).order, });

                    break :block_174 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_173);
                }, .state = ((state_1).plan).state, });

                break :block_176 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_175);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_177: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_177);

        if (state_capacity_started_20) {
            ((state_capacity_19).items).len = ((((state_1).plan).natives).order).len;
            state_owned_177 = (try (state_capacity_19).toOwnedSlice(allocator));
        }

        if (state_capacity_started_20) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_181: {
                const operand_180 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_180).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_1).plan).functions, .natives = block_179: {
                    const operand_178 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_178).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_1).plan).natives).count, .mapping = (((state_1).plan).natives).mapping, .order = state_owned_177, });

                    break :block_179 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_178);
                }, .state = ((state_1).plan).state, });

                break :block_181 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_180);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_182: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_182);

        if (state_capacity_started_22) {
            ((state_capacity_21).items).len = ((((state_1).plan).state).mapping).len;
            state_owned_182 = (try (state_capacity_21).toOwnedSlice(allocator));
        }

        if (state_capacity_started_22) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_186: {
                const operand_185 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_185).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_1).plan).functions, .natives = ((state_1).plan).natives, .state = block_184: {
                    const operand_183 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_183).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_1).plan).state).count, .mapping = state_owned_182, .order = (((state_1).plan).state).order, .origins = (((state_1).plan).state).origins, .status = (((state_1).plan).state).status, });

                    break :block_184 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_183);
                }, });

                break :block_186 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_185);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_187: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_187);

        if (state_capacity_started_24) {
            ((state_capacity_23).items).len = ((((state_1).plan).state).order).len;
            state_owned_187 = (try (state_capacity_23).toOwnedSlice(allocator));
        }

        if (state_capacity_started_24) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_191: {
                const operand_190 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_190).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_1).plan).functions, .natives = ((state_1).plan).natives, .state = block_189: {
                    const operand_188 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_188).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_1).plan).state).count, .mapping = (((state_1).plan).state).mapping, .order = state_owned_187, .origins = (((state_1).plan).state).origins, .status = (((state_1).plan).state).status, });

                    break :block_189 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_188);
                }, });

                break :block_191 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_190);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        var state_owned_192: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_192);

        if (state_capacity_started_26) {
            ((state_capacity_25).items).len = ((((state_1).plan).state).origins).len;
            state_owned_192 = (try (state_capacity_25).toOwnedSlice(allocator));
        }

        if (state_capacity_started_26) {
            state_1 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_1).imports, .index = (state_1).index, .modules = (state_1).modules, .plan = block_196: {
                const operand_195 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_195).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_1).plan).functions, .natives = ((state_1).plan).natives, .state = block_194: {
                    const operand_193 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_193).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_1).plan).state).count, .mapping = (((state_1).plan).state).mapping, .order = (((state_1).plan).state).order, .origins = state_owned_192, .status = (((state_1).plan).state).status, });

                    break :block_194 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_193);
                }, });

                break :block_196 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_195);
            }, .request = (state_1).request, .signatures = (state_1).signatures, };
        }

        break :block_208 (if (state_changed_12) block_207: {
            break :block_207 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_206: {
                const operand_205 = (try (allocator).create((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba));

                (operand_205).* = (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .imports = (if ((((state_1).imports).zx_origin != null)) ((state_1).imports).zx_origin.? else block_198: {
                    const operand_197 = (try (allocator).create((zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c));

                    (operand_197).* = (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c{ .ids = ((state_1).imports).ids, .inputs = ((state_1).imports).inputs, .outputs = ((state_1).imports).outputs, };

                    break :block_198 @as(*const (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c, operand_197);
                }), .index = (state_1).index, .modules = (if ((((state_1).modules).zx_origin != null)) ((state_1).modules).zx_origin.? else block_200: {
                    const operand_199 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_199).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_1).modules).identities, .import_names = ((state_1).modules).import_names, .specifiers = ((state_1).modules).specifiers, .type_ids = ((state_1).modules).type_ids, .type_names = ((state_1).modules).type_names, .type_namespaces = ((state_1).modules).type_namespaces, };

                    break :block_200 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_199);
                }), .plan = (state_1).plan, .request = (if ((((state_1).request).zx_origin != null)) ((state_1).request).zx_origin.? else block_202: {
                    const operand_201 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_201).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = ((state_1).request).origins, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = ((state_1).request).table, };

                    break :block_202 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_201);
                }), .signatures = (if ((((state_1).signatures).zx_origin != null)) ((state_1).signatures).zx_origin.? else block_204: {
                    const operand_203 = (try (allocator).create((zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c));

                    (operand_203).* = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((state_1).signatures).inputs, .native_modules = ((state_1).signatures).native_modules, .outputs = ((state_1).signatures).outputs, };

                    break :block_204 @as(*const (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c, operand_203);
                }), };

                break :block_206 @as(*const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, operand_205);
            });
        } else operand_11);
    };

    return (value_38).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_38: (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = block_412: {
        const operand_217 = block_216: {
            const operand_210 = (in).request;
            const operand_211 = (in).modules;
            const operand_212 = (in).signatures;
            const operand_213 = (in).imports;
            const operand_214 = (in).plan;
            const operand_215 = @as(u64, 0);

            break :block_216 (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .request = operand_210, .modules = operand_211, .signatures = operand_212, .imports = operand_213, .plan = operand_214, .index = operand_215, };
        };

        var state_capacity_218: (std).ArrayList(u64) = .empty;
        var state_capacity_started_219 = false;

        defer (state_capacity_218).deinit(allocator);

        var state_capacity_220: (std).ArrayList(u32) = .empty;
        var state_capacity_started_221 = false;

        defer (state_capacity_220).deinit(allocator);

        var state_capacity_222: (std).ArrayList(u64) = .empty;
        var state_capacity_started_223 = false;

        defer (state_capacity_222).deinit(allocator);

        var state_capacity_224: (std).ArrayList(u32) = .empty;
        var state_capacity_started_225 = false;

        defer (state_capacity_224).deinit(allocator);

        var state_capacity_226: (std).ArrayList(u64) = .empty;
        var state_capacity_started_227 = false;

        defer (state_capacity_226).deinit(allocator);

        var state_capacity_228: (std).ArrayList(u32) = .empty;
        var state_capacity_started_229 = false;

        defer (state_capacity_228).deinit(allocator);

        var state_capacity_230: (std).ArrayList(u64) = .empty;
        var state_capacity_started_231 = false;

        defer (state_capacity_230).deinit(allocator);

        var state_209: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (zx_abi).value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .ids = ((operand_217).imports).ids, .inputs = ((operand_217).imports).inputs, .outputs = ((operand_217).imports).outputs, .zx_origin = (operand_217).imports, }, .index = (operand_217).index, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_217).modules).identities, .import_names = ((operand_217).modules).import_names, .specifiers = ((operand_217).modules).specifiers, .type_ids = ((operand_217).modules).type_ids, .type_names = ((operand_217).modules).type_names, .type_namespaces = ((operand_217).modules).type_namespaces, .zx_origin = (operand_217).modules, }, .plan = (operand_217).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_217).request).maximum_count, .names = ((operand_217).request).names, .origins = ((operand_217).request).origins, .roots = ((operand_217).request).roots, .scalar_count = ((operand_217).request).scalar_count, .table = ((operand_217).request).table, .zx_origin = (operand_217).request, }, .signatures = (zx_abi).value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .inputs = ((operand_217).signatures).inputs, .native_modules = ((operand_217).signatures).native_modules, .outputs = ((operand_217).signatures).outputs, .zx_origin = (operand_217).signatures, }, .zx_origin = (&operand_217), };

        while ((((((state_209).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_209).index < @as(u64, (((state_209).imports).ids).len)))) {
            state_209 = block_366: {
                const value_3: u64 = block_365: {
                    const operand_364 = block_363: {
                        const operand_361 = ((state_209).imports).ids;
                        const operand_362 = (state_209).index;

                        if ((operand_362 >= (operand_361).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_363 (operand_361)[@intCast(operand_362)];
                    };

                    break :block_365 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_364));
                };

                const value_34: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_234: {
                    break :block_234 value_3;
                } >= @as(u64, (((state_209).signatures).inputs).len))) block_249: {
                    const value_4: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_209;
                    const value_5: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_4).plan).*;

                    const value_6: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((block_248: {
                        break :block_248 (&value_5);
                    }).state).*;

                    const value_7: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_247: {
                        break :block_247 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_4).imports, .index = (value_4).index, .modules = (value_4).modules, .plan = block_246: {
                            break :block_246 block_245: {
                                const operand_244 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                (operand_244).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_235: {
                                    break :block_235 (&value_5);
                                }).functions, .natives = (block_236: {
                                    break :block_236 (&value_5);
                                }).natives, .state = block_243: {
                                    break :block_243 block_242: {
                                        const operand_241 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                        (operand_241).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_237: {
                                            break :block_237 (&value_6);
                                        }).count, .mapping = (block_238: {
                                            break :block_238 (&value_6);
                                        }).mapping, .order = (block_239: {
                                            break :block_239 (&value_6);
                                        }).order, .origins = (block_240: {
                                            break :block_240 (&value_6);
                                        }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                        break :block_242 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_241);
                                    };
                                }, });

                                break :block_245 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_244);
                            };
                        }, .request = (value_4).request, .signatures = (value_4).signatures, });
                    };

                    break :block_249 value_7;
                } else block_360: {
                    const value_33: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((block_252: {
                        const operand_250 = ((state_209).imports).inputs;
                        const operand_251 = (state_209).index;

                        if ((operand_251 >= (operand_250).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_252 (operand_250)[@intCast(operand_251)];
                    } != block_256: {
                        const operand_254 = ((state_209).signatures).inputs;

                        const operand_255 = block_253: {
                            break :block_253 value_3;
                        };

                        if ((operand_255 >= (operand_254).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_256 (operand_254)[@intCast(operand_255)];
                    }) or (block_259: {
                        const operand_257 = ((state_209).imports).outputs;
                        const operand_258 = (state_209).index;

                        if ((operand_258 >= (operand_257).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_259 (operand_257)[@intCast(operand_258)];
                    } != block_263: {
                        const operand_261 = ((state_209).signatures).outputs;

                        const operand_262 = block_260: {
                            break :block_260 value_3;
                        };

                        if ((operand_262 >= (operand_261).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_263 (operand_261)[@intCast(operand_262)];
                    }))) block_278: {
                        const value_8: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_209;
                        const value_9: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_8).plan).*;

                        const value_10: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((block_277: {
                            break :block_277 (&value_9);
                        }).state).*;

                        const value_11: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_276: {
                            break :block_276 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_8).imports, .index = (value_8).index, .modules = (value_8).modules, .plan = block_275: {
                                break :block_275 block_274: {
                                    const operand_273 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_273).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_264: {
                                        break :block_264 (&value_9);
                                    }).functions, .natives = (block_265: {
                                        break :block_265 (&value_9);
                                    }).natives, .state = block_272: {
                                        break :block_272 block_271: {
                                            const operand_270 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_270).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_266: {
                                                break :block_266 (&value_10);
                                            }).count, .mapping = (block_267: {
                                                break :block_267 (&value_10);
                                            }).mapping, .order = (block_268: {
                                                break :block_268 (&value_10);
                                            }).order, .origins = (block_269: {
                                                break :block_269 (&value_10);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                            break :block_271 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_270);
                                        };
                                    }, });

                                    break :block_274 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_273);
                                };
                            }, .request = (value_8).request, .signatures = (value_8).signatures, });
                        };

                        break :block_278 value_11;
                    } else block_359: {
                        const value_32: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_282: {
                            const operand_280 = (((state_209).plan).functions).mapping;

                            const operand_281 = block_279: {
                                break :block_279 value_3;
                            };

                            if ((operand_281 >= (operand_280).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_282 (operand_280)[@intCast(operand_281)];
                        } == @as(u64, 0))) block_358: {
                            const value_12: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_209;

                            const value_13: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_357: {
                                break :block_357 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_12).imports, .index = (value_12).index, .modules = (value_12).modules, .plan = block_356: {
                                    const operand_355 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_355).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, block_354: {
                                        const operand_349 = block_348: {
                                            const operand_342 = (state_209).request;
                                            const operand_343 = (state_209).modules;
                                            const operand_344 = (state_209).signatures;
                                            const operand_345 = (state_209).plan;
                                            const operand_346 = block_347: {
                                                break :block_347 value_3;
                                            };

                                            break :block_348 @as((zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7, (zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7{ .request = operand_342, .modules = operand_343, .signatures = operand_344, .plan = operand_345, .index = operand_346, });
                                        };
                                        var state_borrow_350: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                        state_borrow_350 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_349).modules).identities, .import_names = ((operand_349).modules).import_names, .specifiers = ((operand_349).modules).specifiers, .type_ids = ((operand_349).modules).type_ids, .type_names = ((operand_349).modules).type_names, .type_namespaces = ((operand_349).modules).type_namespaces, };

                                        var state_borrow_351: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                        state_borrow_351 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_349).request).maximum_count, .names = ((operand_349).request).names, .origins = ((operand_349).request).origins, .roots = ((operand_349).request).roots, .scalar_count = ((operand_349).request).scalar_count, .table = ((operand_349).request).table, };

                                        var state_borrow_352: (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = undefined;
                                        state_borrow_352 = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((operand_349).signatures).inputs, .native_modules = ((operand_349).signatures).native_modules, .outputs = ((operand_349).signatures).outputs, };

                                        var state_borrow_353: (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = undefined;
                                        state_borrow_353 = (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517{ .index = (operand_349).index, .modules = (((operand_349).modules).zx_origin orelse (&state_borrow_350)), .plan = (operand_349).plan, .request = (((operand_349).request).zx_origin orelse (&state_borrow_351)), .signatures = (((operand_349).signatures).zx_origin orelse (&state_borrow_352)), };

                                        break :block_354 (try (@import("zxc_module_124d04c56d807c136dc19893a96e3b11ff5a660d20886242da64af429cd4c503")).callBuffered(allocator, ((operand_349).zx_origin orelse (&state_borrow_353)), .{ .lane_0 = .{ .buffer = (&state_capacity_218), .started = (&state_capacity_started_219), }, .lane_1 = .{ .buffer = (&state_capacity_220), .started = (&state_capacity_started_221), }, .lane_2 = .{ .buffer = (&state_capacity_222), .started = (&state_capacity_started_223), }, .lane_3 = .{ .buffer = (&state_capacity_224), .started = (&state_capacity_started_225), }, .lane_4 = .{ .buffer = (&state_capacity_226), .started = (&state_capacity_started_227), }, .lane_5 = .{ .buffer = (&state_capacity_228), .started = (&state_capacity_started_229), }, .lane_6 = .{ .buffer = (&state_capacity_230), .started = (&state_capacity_started_231), }, }));
                                    });

                                    break :block_356 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_355);
                                }, .request = (value_12).request, .signatures = (value_12).signatures, });
                            };

                            const value_31: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((((value_13).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) block_341: {
                                const value_14: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_13;
                                const value_15: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_14).plan).*;

                                const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_340: {
                                    break :block_340 (&value_15);
                                }).functions).*;
                                const value_17: []const u64 = (block_339: {
                                    break :block_339 (&value_16);
                                }).mapping;
                                const value_18: u64 = block_338: {
                                    break :block_338 value_3;
                                };
                                const value_19: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_337: {
                                    break :block_337 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_14).imports, .index = (value_14).index, .modules = (value_14).modules, .plan = block_336: {
                                        break :block_336 block_335: {
                                            const operand_334 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_334).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_331: {
                                                break :block_331 block_330: {
                                                    const operand_329 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_329).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_320: {
                                                        break :block_320 (&value_16);
                                                    }).count, .mapping = block_327: {
                                                        const operand_322 = block_321: {
                                                            break :block_321 value_17;
                                                        };
                                                        const operand_324 = block_323: {
                                                            break :block_323 value_18;
                                                        };

                                                        if ((operand_324 >= (operand_322).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        const operand_325 = ((((value_13).plan).functions).count + @as(u64, 1));

                                                        break :block_327 block_326: {
                                                            if ((!state_capacity_started_219)) {
                                                                (try (state_capacity_218).appendSlice(allocator, operand_322));

                                                                state_capacity_started_219 = true;
                                                            } else {
                                                                ((state_capacity_218).items).len = (operand_322).len;
                                                            }

                                                            ((state_capacity_218).items)[@intCast(operand_324)] = operand_325;

                                                            break :block_326 (state_capacity_218).items;
                                                        };
                                                    }, .order = (block_328: {
                                                        break :block_328 (&value_16);
                                                    }).order, });

                                                    break :block_330 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_329);
                                                };
                                            }, .natives = (block_332: {
                                                break :block_332 (&value_15);
                                            }).natives, .state = (block_333: {
                                                break :block_333 (&value_15);
                                            }).state, });

                                            break :block_335 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_334);
                                        };
                                    }, .request = (value_14).request, .signatures = (value_14).signatures, });
                                };
                                const value_20: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_19;
                                const value_21: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_20).plan).*;

                                const value_22: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_319: {
                                    break :block_319 (&value_21);
                                }).functions).*;
                                const value_23: []const u32 = (block_318: {
                                    break :block_318 (&value_22);
                                }).order;

                                const value_24: u64 = (((value_19).plan).functions).count;

                                const value_25: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_317: {
                                    break :block_317 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_20).imports, .index = (value_20).index, .modules = (value_20).modules, .plan = block_316: {
                                        break :block_316 block_315: {
                                            const operand_314 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_314).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_311: {
                                                break :block_311 block_310: {
                                                    const operand_309 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_309).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_297: {
                                                        break :block_297 (&value_22);
                                                    }).count, .mapping = (block_298: {
                                                        break :block_298 (&value_22);
                                                    }).mapping, .order = block_308: {
                                                        const operand_300 = block_299: {
                                                            break :block_299 value_23;
                                                        };
                                                        const operand_302 = block_301: {
                                                            break :block_301 value_24;
                                                        };

                                                        if ((operand_302 >= (operand_300).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }
                                                        const operand_306 = block_305: {
                                                            const operand_304 = block_303: {
                                                                break :block_303 value_3;
                                                            };

                                                            break :block_305 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_304));
                                                        };
                                                        break :block_308 block_307: {
                                                            if ((!state_capacity_started_221)) {
                                                                (try (state_capacity_220).appendSlice(allocator, operand_300));

                                                                state_capacity_started_221 = true;
                                                            } else {
                                                                ((state_capacity_220).items).len = (operand_300).len;
                                                            }

                                                            ((state_capacity_220).items)[@intCast(operand_302)] = operand_306;
                                                            break :block_307 (state_capacity_220).items;
                                                        };
                                                    }, });

                                                    break :block_310 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_309);
                                                };
                                            }, .natives = (block_312: {
                                                break :block_312 (&value_21);
                                            }).natives, .state = (block_313: {
                                                break :block_313 (&value_21);
                                            }).state, });

                                            break :block_315 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_314);
                                        };
                                    }, .request = (value_20).request, .signatures = (value_20).signatures, });
                                };
                                const value_26: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_25;
                                const value_27: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_26).plan).*;

                                const value_28: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_296: {
                                    break :block_296 (&value_27);
                                }).functions).*;
                                const value_29: u64 = (block_295: {
                                    break :block_295 (&value_28);
                                }).count;
                                const value_30: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_294: {
                                    break :block_294 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_26).imports, .index = (value_26).index, .modules = (value_26).modules, .plan = block_293: {
                                        break :block_293 block_292: {
                                            const operand_291 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_291).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_288: {
                                                break :block_288 block_287: {
                                                    const operand_286 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_286).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_283: {
                                                        break :block_283 value_29;
                                                    } + @as(u64, 1)), .mapping = (block_284: {
                                                        break :block_284 (&value_28);
                                                    }).mapping, .order = (block_285: {
                                                        break :block_285 (&value_28);
                                                    }).order, });

                                                    break :block_287 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_286);
                                                };
                                            }, .natives = (block_289: {
                                                break :block_289 (&value_27);
                                            }).natives, .state = (block_290: {
                                                break :block_290 (&value_27);
                                            }).state, });

                                            break :block_292 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_291);
                                        };
                                    }, .request = (value_26).request, .signatures = (value_26).signatures, });
                                };

                                break :block_341 value_30;
                            } else value_13);

                            break :block_358 value_31;
                        } else state_209);

                        break :block_359 value_32;
                    });

                    break :block_360 value_33;
                });

                const value_35: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_233: {
                    break :block_233 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_35).imports, .index = (block_232: {
                        break :block_232 value_36;
                    } + @as(u64, 1)), .modules = (value_35).modules, .plan = (value_35).plan, .request = (value_35).request, .signatures = (value_35).signatures, });
                };

                break :block_366 value_37;
            };
        }

        var state_owned_367: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_367);

        if (state_capacity_started_219) {
            ((state_capacity_218).items).len = ((((state_209).plan).functions).mapping).len;
            state_owned_367 = (try (state_capacity_218).toOwnedSlice(allocator));
        }

        if (state_capacity_started_219) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_371: {
                const operand_370 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_370).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_369: {
                    const operand_368 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_368).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_209).plan).functions).count, .mapping = state_owned_367, .order = (((state_209).plan).functions).order, });

                    break :block_369 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_368);
                }, .natives = ((state_209).plan).natives, .state = ((state_209).plan).state, });

                break :block_371 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_370);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_372: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_372);

        if (state_capacity_started_221) {
            ((state_capacity_220).items).len = ((((state_209).plan).functions).order).len;
            state_owned_372 = (try (state_capacity_220).toOwnedSlice(allocator));
        }

        if (state_capacity_started_221) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_376: {
                const operand_375 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_375).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_374: {
                    const operand_373 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_373).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_209).plan).functions).count, .mapping = (((state_209).plan).functions).mapping, .order = state_owned_372, });

                    break :block_374 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_373);
                }, .natives = ((state_209).plan).natives, .state = ((state_209).plan).state, });

                break :block_376 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_375);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_377: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_377);

        if (state_capacity_started_223) {
            ((state_capacity_222).items).len = ((((state_209).plan).natives).mapping).len;
            state_owned_377 = (try (state_capacity_222).toOwnedSlice(allocator));
        }

        if (state_capacity_started_223) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_381: {
                const operand_380 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_380).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_209).plan).functions, .natives = block_379: {
                    const operand_378 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_378).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_209).plan).natives).count, .mapping = state_owned_377, .order = (((state_209).plan).natives).order, });

                    break :block_379 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_378);
                }, .state = ((state_209).plan).state, });

                break :block_381 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_380);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_382: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_382);

        if (state_capacity_started_225) {
            ((state_capacity_224).items).len = ((((state_209).plan).natives).order).len;
            state_owned_382 = (try (state_capacity_224).toOwnedSlice(allocator));
        }

        if (state_capacity_started_225) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_386: {
                const operand_385 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_385).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_209).plan).functions, .natives = block_384: {
                    const operand_383 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                    (operand_383).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (((state_209).plan).natives).count, .mapping = (((state_209).plan).natives).mapping, .order = state_owned_382, });

                    break :block_384 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_383);
                }, .state = ((state_209).plan).state, });

                break :block_386 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_385);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_387: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_387);

        if (state_capacity_started_227) {
            ((state_capacity_226).items).len = ((((state_209).plan).state).mapping).len;
            state_owned_387 = (try (state_capacity_226).toOwnedSlice(allocator));
        }

        if (state_capacity_started_227) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_391: {
                const operand_390 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_390).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_209).plan).functions, .natives = ((state_209).plan).natives, .state = block_389: {
                    const operand_388 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_388).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_209).plan).state).count, .mapping = state_owned_387, .order = (((state_209).plan).state).order, .origins = (((state_209).plan).state).origins, .status = (((state_209).plan).state).status, });

                    break :block_389 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_388);
                }, });

                break :block_391 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_390);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_392: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_392);

        if (state_capacity_started_229) {
            ((state_capacity_228).items).len = ((((state_209).plan).state).order).len;
            state_owned_392 = (try (state_capacity_228).toOwnedSlice(allocator));
        }

        if (state_capacity_started_229) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_396: {
                const operand_395 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_395).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_209).plan).functions, .natives = ((state_209).plan).natives, .state = block_394: {
                    const operand_393 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_393).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_209).plan).state).count, .mapping = (((state_209).plan).state).mapping, .order = state_owned_392, .origins = (((state_209).plan).state).origins, .status = (((state_209).plan).state).status, });

                    break :block_394 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_393);
                }, });

                break :block_396 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_395);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        var state_owned_397: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_397);

        if (state_capacity_started_231) {
            ((state_capacity_230).items).len = ((((state_209).plan).state).origins).len;
            state_owned_397 = (try (state_capacity_230).toOwnedSlice(allocator));
        }

        if (state_capacity_started_231) {
            state_209 = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (state_209).imports, .index = (state_209).index, .modules = (state_209).modules, .plan = block_401: {
                const operand_400 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_400).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = ((state_209).plan).functions, .natives = ((state_209).plan).natives, .state = block_399: {
                    const operand_398 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_398).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (((state_209).plan).state).count, .mapping = (((state_209).plan).state).mapping, .order = (((state_209).plan).state).order, .origins = state_owned_397, .status = (((state_209).plan).state).status, });

                    break :block_399 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_398);
                }, });

                break :block_401 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_400);
            }, .request = (state_209).request, .signatures = (state_209).signatures, };
        }

        break :block_412 block_411: {
            break :block_411 (if (((state_209).zx_origin != null)) ((state_209).zx_origin.?).* else block_410: {
                break :block_410 (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .imports = (if ((((state_209).imports).zx_origin != null)) ((state_209).imports).zx_origin.? else block_403: {
                    const operand_402 = (try (allocator).create((zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c));

                    (operand_402).* = (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c{ .ids = ((state_209).imports).ids, .inputs = ((state_209).imports).inputs, .outputs = ((state_209).imports).outputs, };

                    break :block_403 @as(*const (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c, operand_402);
                }), .index = (state_209).index, .modules = (if ((((state_209).modules).zx_origin != null)) ((state_209).modules).zx_origin.? else block_405: {
                    const operand_404 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_404).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_209).modules).identities, .import_names = ((state_209).modules).import_names, .specifiers = ((state_209).modules).specifiers, .type_ids = ((state_209).modules).type_ids, .type_names = ((state_209).modules).type_names, .type_namespaces = ((state_209).modules).type_namespaces, };

                    break :block_405 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_404);
                }), .plan = (state_209).plan, .request = (if ((((state_209).request).zx_origin != null)) ((state_209).request).zx_origin.? else block_407: {
                    const operand_406 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_406).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_209).request).maximum_count, .names = ((state_209).request).names, .origins = ((state_209).request).origins, .roots = ((state_209).request).roots, .scalar_count = ((state_209).request).scalar_count, .table = ((state_209).request).table, };

                    break :block_407 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_406);
                }), .signatures = (if ((((state_209).signatures).zx_origin != null)) ((state_209).signatures).zx_origin.? else block_409: {
                    const operand_408 = (try (allocator).create((zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c));

                    (operand_408).* = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((state_209).signatures).inputs, .native_modules = ((state_209).signatures).native_modules, .outputs = ((state_209).signatures).outputs, };

                    break :block_409 @as(*const (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c, operand_408);
                }), };
            });
        };
    };

    return (((&value_38)).plan).*;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, buffers: struct {
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
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_38: (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = block_571: {
        const operand_421 = block_420: {
            const operand_414 = (in).request;
            const operand_415 = (in).modules;
            const operand_416 = (in).signatures;
            const operand_417 = (in).imports;
            const operand_418 = (in).plan;
            const operand_419 = @as(u64, 0);

            break :block_420 (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .request = operand_414, .modules = operand_415, .signatures = operand_416, .imports = operand_417, .plan = operand_418, .index = operand_419, };
        };

        var state_413: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (zx_abi).value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .ids = ((operand_421).imports).ids, .inputs = ((operand_421).imports).inputs, .outputs = ((operand_421).imports).outputs, .zx_origin = (operand_421).imports, }, .index = (operand_421).index, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_421).modules).identities, .import_names = ((operand_421).modules).import_names, .specifiers = ((operand_421).modules).specifiers, .type_ids = ((operand_421).modules).type_ids, .type_names = ((operand_421).modules).type_names, .type_namespaces = ((operand_421).modules).type_namespaces, .zx_origin = (operand_421).modules, }, .plan = (operand_421).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_421).request).maximum_count, .names = ((operand_421).request).names, .origins = ((operand_421).request).origins, .roots = ((operand_421).request).roots, .scalar_count = ((operand_421).request).scalar_count, .table = ((operand_421).request).table, .zx_origin = (operand_421).request, }, .signatures = (zx_abi).value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .inputs = ((operand_421).signatures).inputs, .native_modules = ((operand_421).signatures).native_modules, .outputs = ((operand_421).signatures).outputs, .zx_origin = (operand_421).signatures, }, .zx_origin = (&operand_421), };

        while ((((((state_413).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_413).index < @as(u64, (((state_413).imports).ids).len)))) {
            state_413 = block_560: {
                const value_3: u64 = block_559: {
                    const operand_558 = block_557: {
                        const operand_555 = ((state_413).imports).ids;
                        const operand_556 = (state_413).index;

                        if ((operand_556 >= (operand_555).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_557 (operand_555)[@intCast(operand_556)];
                    };

                    break :block_559 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_558));
                };

                const value_34: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_424: {
                    break :block_424 value_3;
                } >= @as(u64, (((state_413).signatures).inputs).len))) block_439: {
                    const value_4: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_413;
                    const value_5: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_4).plan).*;

                    const value_6: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((block_438: {
                        break :block_438 (&value_5);
                    }).state).*;

                    const value_7: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_437: {
                        break :block_437 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_4).imports, .index = (value_4).index, .modules = (value_4).modules, .plan = block_436: {
                            break :block_436 block_435: {
                                const operand_434 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                (operand_434).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_425: {
                                    break :block_425 (&value_5);
                                }).functions, .natives = (block_426: {
                                    break :block_426 (&value_5);
                                }).natives, .state = block_433: {
                                    break :block_433 block_432: {
                                        const operand_431 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                        (operand_431).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_427: {
                                            break :block_427 (&value_6);
                                        }).count, .mapping = (block_428: {
                                            break :block_428 (&value_6);
                                        }).mapping, .order = (block_429: {
                                            break :block_429 (&value_6);
                                        }).order, .origins = (block_430: {
                                            break :block_430 (&value_6);
                                        }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                        break :block_432 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_431);
                                    };
                                }, });

                                break :block_435 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_434);
                            };
                        }, .request = (value_4).request, .signatures = (value_4).signatures, });
                    };

                    break :block_439 value_7;
                } else block_554: {
                    const value_33: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((block_442: {
                        const operand_440 = ((state_413).imports).inputs;
                        const operand_441 = (state_413).index;

                        if ((operand_441 >= (operand_440).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_442 (operand_440)[@intCast(operand_441)];
                    } != block_446: {
                        const operand_444 = ((state_413).signatures).inputs;

                        const operand_445 = block_443: {
                            break :block_443 value_3;
                        };

                        if ((operand_445 >= (operand_444).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_446 (operand_444)[@intCast(operand_445)];
                    }) or (block_449: {
                        const operand_447 = ((state_413).imports).outputs;
                        const operand_448 = (state_413).index;

                        if ((operand_448 >= (operand_447).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_449 (operand_447)[@intCast(operand_448)];
                    } != block_453: {
                        const operand_451 = ((state_413).signatures).outputs;

                        const operand_452 = block_450: {
                            break :block_450 value_3;
                        };

                        if ((operand_452 >= (operand_451).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_453 (operand_451)[@intCast(operand_452)];
                    }))) block_468: {
                        const value_8: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_413;
                        const value_9: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_8).plan).*;

                        const value_10: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((block_467: {
                            break :block_467 (&value_9);
                        }).state).*;

                        const value_11: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_466: {
                            break :block_466 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_8).imports, .index = (value_8).index, .modules = (value_8).modules, .plan = block_465: {
                                break :block_465 block_464: {
                                    const operand_463 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_463).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_454: {
                                        break :block_454 (&value_9);
                                    }).functions, .natives = (block_455: {
                                        break :block_455 (&value_9);
                                    }).natives, .state = block_462: {
                                        break :block_462 block_461: {
                                            const operand_460 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_460).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_456: {
                                                break :block_456 (&value_10);
                                            }).count, .mapping = (block_457: {
                                                break :block_457 (&value_10);
                                            }).mapping, .order = (block_458: {
                                                break :block_458 (&value_10);
                                            }).order, .origins = (block_459: {
                                                break :block_459 (&value_10);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                            break :block_461 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_460);
                                        };
                                    }, });

                                    break :block_464 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_463);
                                };
                            }, .request = (value_8).request, .signatures = (value_8).signatures, });
                        };

                        break :block_468 value_11;
                    } else block_553: {
                        const value_32: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_472: {
                            const operand_470 = (((state_413).plan).functions).mapping;

                            const operand_471 = block_469: {
                                break :block_469 value_3;
                            };

                            if ((operand_471 >= (operand_470).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_472 (operand_470)[@intCast(operand_471)];
                        } == @as(u64, 0))) block_552: {
                            const value_12: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_413;

                            const value_13: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_551: {
                                break :block_551 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_12).imports, .index = (value_12).index, .modules = (value_12).modules, .plan = block_550: {
                                    const operand_549 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_549).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, block_548: {
                                        const operand_543 = block_542: {
                                            const operand_536 = (state_413).request;
                                            const operand_537 = (state_413).modules;
                                            const operand_538 = (state_413).signatures;
                                            const operand_539 = (state_413).plan;

                                            const operand_540 = block_541: {
                                                break :block_541 value_3;
                                            };

                                            break :block_542 @as((zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7, (zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7{ .request = operand_536, .modules = operand_537, .signatures = operand_538, .plan = operand_539, .index = operand_540, });
                                        };

                                        var state_borrow_544: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                        state_borrow_544 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_543).modules).identities, .import_names = ((operand_543).modules).import_names, .specifiers = ((operand_543).modules).specifiers, .type_ids = ((operand_543).modules).type_ids, .type_names = ((operand_543).modules).type_names, .type_namespaces = ((operand_543).modules).type_namespaces, };

                                        var state_borrow_545: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                        state_borrow_545 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_543).request).maximum_count, .names = ((operand_543).request).names, .origins = ((operand_543).request).origins, .roots = ((operand_543).request).roots, .scalar_count = ((operand_543).request).scalar_count, .table = ((operand_543).request).table, };

                                        var state_borrow_546: (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = undefined;
                                        state_borrow_546 = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((operand_543).signatures).inputs, .native_modules = ((operand_543).signatures).native_modules, .outputs = ((operand_543).signatures).outputs, };

                                        var state_borrow_547: (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = undefined;
                                        state_borrow_547 = (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517{ .index = (operand_543).index, .modules = (((operand_543).modules).zx_origin orelse (&state_borrow_544)), .plan = (operand_543).plan, .request = (((operand_543).request).zx_origin orelse (&state_borrow_545)), .signatures = (((operand_543).signatures).zx_origin orelse (&state_borrow_546)), };

                                        break :block_548 (try (@import("zxc_module_124d04c56d807c136dc19893a96e3b11ff5a660d20886242da64af429cd4c503")).callBuffered(allocator, ((operand_543).zx_origin orelse (&state_borrow_547)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
                                    });

                                    break :block_550 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_549);
                                }, .request = (value_12).request, .signatures = (value_12).signatures, });
                            };

                            const value_31: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((((value_13).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) block_535: {
                                const value_14: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_13;
                                const value_15: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_14).plan).*;

                                const value_16: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_534: {
                                    break :block_534 (&value_15);
                                }).functions).*;
                                const value_17: []const u64 = (block_533: {
                                    break :block_533 (&value_16);
                                }).mapping;
                                const value_18: u64 = block_532: {
                                    break :block_532 value_3;
                                };
                                const value_19: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_531: {
                                    break :block_531 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_14).imports, .index = (value_14).index, .modules = (value_14).modules, .plan = block_530: {
                                        break :block_530 block_529: {
                                            const operand_528 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_528).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_525: {
                                                break :block_525 block_524: {
                                                    const operand_523 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_523).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_512: {
                                                        break :block_512 (&value_16);
                                                    }).count, .mapping = block_521: {
                                                        const operand_514 = block_513: {
                                                            break :block_513 value_17;
                                                        };
                                                        const operand_516 = block_515: {
                                                            break :block_515 value_18;
                                                        };

                                                        if ((operand_516 >= (operand_514).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        const operand_517 = ((((value_13).plan).functions).count + @as(u64, 1));

                                                        break :block_521 @as([]const u64, (if (((buffers).lane_0 != null)) block_518: {
                                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_514));
                                                                (((buffers).lane_0.?).started).* = true;
                                                            } else {
                                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_514).len;
                                                            }

                                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_516)] = operand_517;

                                                            break :block_518 ((((buffers).lane_0.?).buffer).*).items;
                                                        } else block_520: {
                                                            const operand_519 = (try (allocator).dupe(u64, operand_514));

                                                            (operand_519)[@intCast(operand_516)] = operand_517;
                                                            break :block_520 operand_519;
                                                        }));
                                                    }, .order = (block_522: {
                                                        break :block_522 (&value_16);
                                                    }).order, });

                                                    break :block_524 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_523);
                                                };
                                            }, .natives = (block_526: {
                                                break :block_526 (&value_15);
                                            }).natives, .state = (block_527: {
                                                break :block_527 (&value_15);
                                            }).state, });

                                            break :block_529 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_528);
                                        };
                                    }, .request = (value_14).request, .signatures = (value_14).signatures, });
                                };
                                const value_20: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_19;
                                const value_21: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_20).plan).*;

                                const value_22: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_511: {
                                    break :block_511 (&value_21);
                                }).functions).*;
                                const value_23: []const u32 = (block_510: {
                                    break :block_510 (&value_22);
                                }).order;

                                const value_24: u64 = (((value_19).plan).functions).count;

                                const value_25: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_509: {
                                    break :block_509 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_20).imports, .index = (value_20).index, .modules = (value_20).modules, .plan = block_508: {
                                        break :block_508 block_507: {
                                            const operand_506 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_506).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_503: {
                                                break :block_503 block_502: {
                                                    const operand_501 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_501).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_487: {
                                                        break :block_487 (&value_22);
                                                    }).count, .mapping = (block_488: {
                                                        break :block_488 (&value_22);
                                                    }).mapping, .order = block_500: {
                                                        const operand_490 = block_489: {
                                                            break :block_489 value_23;
                                                        };
                                                        const operand_492 = block_491: {
                                                            break :block_491 value_24;
                                                        };

                                                        if ((operand_492 >= (operand_490).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }
                                                        const operand_496 = block_495: {
                                                            const operand_494 = block_493: {
                                                                break :block_493 value_3;
                                                            };

                                                            break :block_495 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_494));
                                                        };

                                                        break :block_500 @as([]const u32, (if (((buffers).lane_1 != null)) block_497: {
                                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_490));
                                                                (((buffers).lane_1.?).started).* = true;
                                                            } else {
                                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_490).len;
                                                            }

                                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_492)] = operand_496;

                                                            break :block_497 ((((buffers).lane_1.?).buffer).*).items;
                                                        } else block_499: {
                                                            const operand_498 = (try (allocator).dupe(u32, operand_490));
                                                            (operand_498)[@intCast(operand_492)] = operand_496;
                                                            break :block_499 operand_498;
                                                        }));
                                                    }, });

                                                    break :block_502 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_501);
                                                };
                                            }, .natives = (block_504: {
                                                break :block_504 (&value_21);
                                            }).natives, .state = (block_505: {
                                                break :block_505 (&value_21);
                                            }).state, });

                                            break :block_507 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_506);
                                        };
                                    }, .request = (value_20).request, .signatures = (value_20).signatures, });
                                };
                                const value_26: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_25;
                                const value_27: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = ((value_26).plan).*;

                                const value_28: (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = ((block_486: {
                                    break :block_486 (&value_27);
                                }).functions).*;
                                const value_29: u64 = (block_485: {
                                    break :block_485 (&value_28);
                                }).count;

                                const value_30: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_484: {
                                    break :block_484 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_26).imports, .index = (value_26).index, .modules = (value_26).modules, .plan = block_483: {
                                        break :block_483 block_482: {
                                            const operand_481 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_481).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_478: {
                                                break :block_478 block_477: {
                                                    const operand_476 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_476).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_473: {
                                                        break :block_473 value_29;
                                                    } + @as(u64, 1)), .mapping = (block_474: {
                                                        break :block_474 (&value_28);
                                                    }).mapping, .order = (block_475: {
                                                        break :block_475 (&value_28);
                                                    }).order, });

                                                    break :block_477 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_476);
                                                };
                                            }, .natives = (block_479: {
                                                break :block_479 (&value_27);
                                            }).natives, .state = (block_480: {
                                                break :block_480 (&value_27);
                                            }).state, });

                                            break :block_482 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_481);
                                        };
                                    }, .request = (value_26).request, .signatures = (value_26).signatures, });
                                };

                                break :block_535 value_30;
                            } else value_13);

                            break :block_552 value_31;
                        } else state_413);

                        break :block_553 value_32;
                    });

                    break :block_554 value_33;
                });

                const value_35: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_423: {
                    break :block_423 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_35).imports, .index = (block_422: {
                        break :block_422 value_36;
                    } + @as(u64, 1)), .modules = (value_35).modules, .plan = (value_35).plan, .request = (value_35).request, .signatures = (value_35).signatures, });
                };

                break :block_560 value_37;
            };
        }

        break :block_571 block_570: {
            break :block_570 (if (((state_413).zx_origin != null)) ((state_413).zx_origin.?).* else block_569: {
                break :block_569 (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .imports = (if ((((state_413).imports).zx_origin != null)) ((state_413).imports).zx_origin.? else block_562: {
                    const operand_561 = (try (allocator).create((zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c));

                    (operand_561).* = (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c{ .ids = ((state_413).imports).ids, .inputs = ((state_413).imports).inputs, .outputs = ((state_413).imports).outputs, };

                    break :block_562 @as(*const (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c, operand_561);
                }), .index = (state_413).index, .modules = (if ((((state_413).modules).zx_origin != null)) ((state_413).modules).zx_origin.? else block_564: {
                    const operand_563 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_563).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_413).modules).identities, .import_names = ((state_413).modules).import_names, .specifiers = ((state_413).modules).specifiers, .type_ids = ((state_413).modules).type_ids, .type_names = ((state_413).modules).type_names, .type_namespaces = ((state_413).modules).type_namespaces, };

                    break :block_564 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_563);
                }), .plan = (state_413).plan, .request = (if ((((state_413).request).zx_origin != null)) ((state_413).request).zx_origin.? else block_566: {
                    const operand_565 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_565).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_413).request).maximum_count, .names = ((state_413).request).names, .origins = ((state_413).request).origins, .roots = ((state_413).request).roots, .scalar_count = ((state_413).request).scalar_count, .table = ((state_413).request).table, };

                    break :block_566 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_565);
                }), .signatures = (if ((((state_413).signatures).zx_origin != null)) ((state_413).signatures).zx_origin.? else block_568: {
                    const operand_567 = (try (allocator).create((zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c));

                    (operand_567).* = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((state_413).signatures).inputs, .native_modules = ((state_413).signatures).native_modules, .outputs = ((state_413).signatures).outputs, };

                    break :block_568 @as(*const (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c, operand_567);
                }), };
            });
        };
    };

    return (((&value_38)).plan).*;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, buffers: struct {
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
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_38: *const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = block_734: {
        const operand_582 = block_581: {
            const operand_573 = (in).request;
            const operand_574 = (in).modules;
            const operand_575 = (in).signatures;
            const operand_576 = (in).imports;
            const operand_577 = (in).plan;
            const operand_578 = @as(u64, 0);

            break :block_581 block_580: {
                const operand_579 = (try (allocator).create((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba));

                (operand_579).* = @as((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .request = operand_573, .modules = operand_574, .signatures = operand_575, .imports = operand_576, .plan = operand_577, .index = operand_578, });

                break :block_580 @as(*const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, operand_579);
            };
        };

        var state_572: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (zx_abi).value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .ids = ((operand_582).imports).ids, .inputs = ((operand_582).imports).inputs, .outputs = ((operand_582).imports).outputs, .zx_origin = (operand_582).imports, }, .index = (operand_582).index, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_582).modules).identities, .import_names = ((operand_582).modules).import_names, .specifiers = ((operand_582).modules).specifiers, .type_ids = ((operand_582).modules).type_ids, .type_names = ((operand_582).modules).type_names, .type_namespaces = ((operand_582).modules).type_namespaces, .zx_origin = (operand_582).modules, }, .plan = (operand_582).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_582).request).maximum_count, .names = ((operand_582).request).names, .origins = ((operand_582).request).origins, .roots = ((operand_582).request).roots, .scalar_count = ((operand_582).request).scalar_count, .table = ((operand_582).request).table, .zx_origin = (operand_582).request, }, .signatures = (zx_abi).value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .inputs = ((operand_582).signatures).inputs, .native_modules = ((operand_582).signatures).native_modules, .outputs = ((operand_582).signatures).outputs, .zx_origin = (operand_582).signatures, }, .zx_origin = operand_582, };
        var state_changed_583 = false;

        while ((((((state_572).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_572).index < @as(u64, (((state_572).imports).ids).len)))) {
            state_572 = block_722: {
                const value_3: u64 = block_721: {
                    const operand_720 = block_719: {
                        const operand_717 = ((state_572).imports).ids;
                        const operand_718 = (state_572).index;

                        if ((operand_718 >= (operand_717).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_719 (operand_717)[@intCast(operand_718)];
                    };

                    break :block_721 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_720));
                };

                const value_34: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_586: {
                    break :block_586 value_3;
                } >= @as(u64, (((state_572).signatures).inputs).len))) block_601: {
                    const value_4: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_572;
                    const value_5: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_4).plan;

                    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (block_600: {
                        break :block_600 value_5;
                    }).state;

                    const value_7: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_599: {
                        break :block_599 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_4).imports, .index = (value_4).index, .modules = (value_4).modules, .plan = block_598: {
                            break :block_598 block_597: {
                                const operand_596 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                (operand_596).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_587: {
                                    break :block_587 value_5;
                                }).functions, .natives = (block_588: {
                                    break :block_588 value_5;
                                }).natives, .state = block_595: {
                                    break :block_595 block_594: {
                                        const operand_593 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                        (operand_593).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_589: {
                                            break :block_589 value_6;
                                        }).count, .mapping = (block_590: {
                                            break :block_590 value_6;
                                        }).mapping, .order = (block_591: {
                                            break :block_591 value_6;
                                        }).order, .origins = (block_592: {
                                            break :block_592 value_6;
                                        }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                        break :block_594 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_593);
                                    };
                                }, });

                                break :block_597 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_596);
                            };
                        }, .request = (value_4).request, .signatures = (value_4).signatures, });
                    };

                    break :block_601 value_7;
                } else block_716: {
                    const value_33: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((block_604: {
                        const operand_602 = ((state_572).imports).inputs;
                        const operand_603 = (state_572).index;

                        if ((operand_603 >= (operand_602).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_604 (operand_602)[@intCast(operand_603)];
                    } != block_608: {
                        const operand_606 = ((state_572).signatures).inputs;

                        const operand_607 = block_605: {
                            break :block_605 value_3;
                        };

                        if ((operand_607 >= (operand_606).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_608 (operand_606)[@intCast(operand_607)];
                    }) or (block_611: {
                        const operand_609 = ((state_572).imports).outputs;
                        const operand_610 = (state_572).index;

                        if ((operand_610 >= (operand_609).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_611 (operand_609)[@intCast(operand_610)];
                    } != block_615: {
                        const operand_613 = ((state_572).signatures).outputs;

                        const operand_614 = block_612: {
                            break :block_612 value_3;
                        };

                        if ((operand_614 >= (operand_613).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_615 (operand_613)[@intCast(operand_614)];
                    }))) block_630: {
                        const value_8: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_572;
                        const value_9: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_8).plan;

                        const value_10: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (block_629: {
                            break :block_629 value_9;
                        }).state;

                        const value_11: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_628: {
                            break :block_628 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_8).imports, .index = (value_8).index, .modules = (value_8).modules, .plan = block_627: {
                                break :block_627 block_626: {
                                    const operand_625 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_625).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (block_616: {
                                        break :block_616 value_9;
                                    }).functions, .natives = (block_617: {
                                        break :block_617 value_9;
                                    }).natives, .state = block_624: {
                                        break :block_624 block_623: {
                                            const operand_622 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_622).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_618: {
                                                break :block_618 value_10;
                                            }).count, .mapping = (block_619: {
                                                break :block_619 value_10;
                                            }).mapping, .order = (block_620: {
                                                break :block_620 value_10;
                                            }).order, .origins = (block_621: {
                                                break :block_621 value_10;
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                            break :block_623 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_622);
                                        };
                                    }, });

                                    break :block_626 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_625);
                                };
                            }, .request = (value_8).request, .signatures = (value_8).signatures, });
                        };

                        break :block_630 value_11;
                    } else block_715: {
                        const value_32: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if ((block_634: {
                            const operand_632 = (((state_572).plan).functions).mapping;

                            const operand_633 = block_631: {
                                break :block_631 value_3;
                            };

                            if ((operand_633 >= (operand_632).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_634 (operand_632)[@intCast(operand_633)];
                        } == @as(u64, 0))) block_714: {
                            const value_12: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = state_572;

                            const value_13: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_713: {
                                break :block_713 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_12).imports, .index = (value_12).index, .modules = (value_12).modules, .plan = block_712: {
                                    const operand_711 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                    (operand_711).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, block_710: {
                                        const operand_705 = block_704: {
                                            const operand_698 = (state_572).request;
                                            const operand_699 = (state_572).modules;
                                            const operand_700 = (state_572).signatures;
                                            const operand_701 = (state_572).plan;
                                            const operand_702 = block_703: {
                                                break :block_703 value_3;
                                            };

                                            break :block_704 @as((zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7, (zx_abi).value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7{ .request = operand_698, .modules = operand_699, .signatures = operand_700, .plan = operand_701, .index = operand_702, });
                                        };
                                        var state_borrow_706: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                        state_borrow_706 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_705).modules).identities, .import_names = ((operand_705).modules).import_names, .specifiers = ((operand_705).modules).specifiers, .type_ids = ((operand_705).modules).type_ids, .type_names = ((operand_705).modules).type_names, .type_namespaces = ((operand_705).modules).type_namespaces, };

                                        var state_borrow_707: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                        state_borrow_707 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_705).request).maximum_count, .names = ((operand_705).request).names, .origins = ((operand_705).request).origins, .roots = ((operand_705).request).roots, .scalar_count = ((operand_705).request).scalar_count, .table = ((operand_705).request).table, };

                                        var state_borrow_708: (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = undefined;
                                        state_borrow_708 = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((operand_705).signatures).inputs, .native_modules = ((operand_705).signatures).native_modules, .outputs = ((operand_705).signatures).outputs, };
                                        var state_borrow_709: (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = undefined;
                                        state_borrow_709 = (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517{ .index = (operand_705).index, .modules = (((operand_705).modules).zx_origin orelse (&state_borrow_706)), .plan = (operand_705).plan, .request = (((operand_705).request).zx_origin orelse (&state_borrow_707)), .signatures = (((operand_705).signatures).zx_origin orelse (&state_borrow_708)), };

                                        break :block_710 (try (@import("zxc_module_124d04c56d807c136dc19893a96e3b11ff5a660d20886242da64af429cd4c503")).callBuffered(allocator, ((operand_705).zx_origin orelse (&state_borrow_709)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
                                    });

                                    break :block_712 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_711);
                                }, .request = (value_12).request, .signatures = (value_12).signatures, });
                            };

                            const value_31: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = (if (((((value_13).plan).state).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) block_697: {
                                const value_14: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_13;
                                const value_15: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_14).plan;

                                const value_16: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_696: {
                                    break :block_696 value_15;
                                }).functions;
                                const value_17: []const u64 = (block_695: {
                                    break :block_695 value_16;
                                }).mapping;
                                const value_18: u64 = block_694: {
                                    break :block_694 value_3;
                                };
                                const value_19: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_693: {
                                    break :block_693 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_14).imports, .index = (value_14).index, .modules = (value_14).modules, .plan = block_692: {
                                        break :block_692 block_691: {
                                            const operand_690 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_690).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_687: {
                                                break :block_687 block_686: {
                                                    const operand_685 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_685).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_674: {
                                                        break :block_674 value_16;
                                                    }).count, .mapping = block_683: {
                                                        const operand_676 = block_675: {
                                                            break :block_675 value_17;
                                                        };
                                                        const operand_678 = block_677: {
                                                            break :block_677 value_18;
                                                        };

                                                        if ((operand_678 >= (operand_676).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        const operand_679 = ((((value_13).plan).functions).count + @as(u64, 1));

                                                        break :block_683 @as([]const u64, (if (((buffers).lane_0 != null)) block_680: {
                                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_676));
                                                                (((buffers).lane_0.?).started).* = true;
                                                            } else {
                                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_676).len;
                                                            }

                                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_678)] = operand_679;

                                                            break :block_680 ((((buffers).lane_0.?).buffer).*).items;
                                                        } else block_682: {
                                                            const operand_681 = (try (allocator).dupe(u64, operand_676));

                                                            (operand_681)[@intCast(operand_678)] = operand_679;
                                                            break :block_682 operand_681;
                                                        }));
                                                    }, .order = (block_684: {
                                                        break :block_684 value_16;
                                                    }).order, });

                                                    break :block_686 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_685);
                                                };
                                            }, .natives = (block_688: {
                                                break :block_688 value_15;
                                            }).natives, .state = (block_689: {
                                                break :block_689 value_15;
                                            }).state, });

                                            break :block_691 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_690);
                                        };
                                    }, .request = (value_14).request, .signatures = (value_14).signatures, });
                                };
                                const value_20: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_19;
                                const value_21: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_20).plan;

                                const value_22: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_673: {
                                    break :block_673 value_21;
                                }).functions;
                                const value_23: []const u32 = (block_672: {
                                    break :block_672 value_22;
                                }).order;

                                const value_24: u64 = (((value_19).plan).functions).count;

                                const value_25: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_671: {
                                    break :block_671 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_20).imports, .index = (value_20).index, .modules = (value_20).modules, .plan = block_670: {
                                        break :block_670 block_669: {
                                            const operand_668 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_668).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_665: {
                                                break :block_665 block_664: {
                                                    const operand_663 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_663).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_649: {
                                                        break :block_649 value_22;
                                                    }).count, .mapping = (block_650: {
                                                        break :block_650 value_22;
                                                    }).mapping, .order = block_662: {
                                                        const operand_652 = block_651: {
                                                            break :block_651 value_23;
                                                        };
                                                        const operand_654 = block_653: {
                                                            break :block_653 value_24;
                                                        };

                                                        if ((operand_654 >= (operand_652).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }
                                                        const operand_658 = block_657: {
                                                            const operand_656 = block_655: {
                                                                break :block_655 value_3;
                                                            };

                                                            break :block_657 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_656));
                                                        };

                                                        break :block_662 @as([]const u32, (if (((buffers).lane_1 != null)) block_659: {
                                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_652));
                                                                (((buffers).lane_1.?).started).* = true;
                                                            } else {
                                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_652).len;
                                                            }

                                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_654)] = operand_658;

                                                            break :block_659 ((((buffers).lane_1.?).buffer).*).items;
                                                        } else block_661: {
                                                            const operand_660 = (try (allocator).dupe(u32, operand_652));

                                                            (operand_660)[@intCast(operand_654)] = operand_658;

                                                            break :block_661 operand_660;
                                                        }));
                                                    }, });

                                                    break :block_664 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_663);
                                                };
                                            }, .natives = (block_666: {
                                                break :block_666 value_21;
                                            }).natives, .state = (block_667: {
                                                break :block_667 value_21;
                                            }).state, });

                                            break :block_669 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_668);
                                        };
                                    }, .request = (value_20).request, .signatures = (value_20).signatures, });
                                };
                                const value_26: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_25;
                                const value_27: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (value_26).plan;

                                const value_28: *const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = (block_648: {
                                    break :block_648 value_27;
                                }).functions;
                                const value_29: u64 = (block_647: {
                                    break :block_647 value_28;
                                }).count;
                                const value_30: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_646: {
                                    break :block_646 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_26).imports, .index = (value_26).index, .modules = (value_26).modules, .plan = block_645: {
                                        break :block_645 block_644: {
                                            const operand_643 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                                            (operand_643).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = block_640: {
                                                break :block_640 block_639: {
                                                    const operand_638 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                                                    (operand_638).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = (block_635: {
                                                        break :block_635 value_29;
                                                    } + @as(u64, 1)), .mapping = (block_636: {
                                                        break :block_636 value_28;
                                                    }).mapping, .order = (block_637: {
                                                        break :block_637 value_28;
                                                    }).order, });

                                                    break :block_639 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_638);
                                                };
                                            }, .natives = (block_641: {
                                                break :block_641 value_27;
                                            }).natives, .state = (block_642: {
                                                break :block_642 value_27;
                                            }).state, });

                                            break :block_644 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_643);
                                        };
                                    }, .request = (value_26).request, .signatures = (value_26).signatures, });
                                };

                                break :block_697 value_30;
                            } else value_13);

                            break :block_714 value_31;
                        } else state_572);

                        break :block_715 value_32;
                    });

                    break :block_716 value_33;
                });

                const value_35: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = value_34;
                const value_36: u64 = (value_35).index;

                const value_37: (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = block_585: {
                    break :block_585 @as((zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c, (zx_abi).value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c{ .imports = (value_35).imports, .index = (block_584: {
                        break :block_584 value_36;
                    } + @as(u64, 1)), .modules = (value_35).modules, .plan = (value_35).plan, .request = (value_35).request, .signatures = (value_35).signatures, });
                };

                break :block_722 value_37;
            };

            state_changed_583 = true;
        }

        break :block_734 (if (state_changed_583) block_733: {
            break :block_733 (if (((state_572).zx_origin != null)) (state_572).zx_origin.? else block_732: {
                const operand_731 = (try (allocator).create((zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba));

                (operand_731).* = (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba{ .imports = (if ((((state_572).imports).zx_origin != null)) ((state_572).imports).zx_origin.? else block_724: {
                    const operand_723 = (try (allocator).create((zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c));

                    (operand_723).* = (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c{ .ids = ((state_572).imports).ids, .inputs = ((state_572).imports).inputs, .outputs = ((state_572).imports).outputs, };

                    break :block_724 @as(*const (zx_abi).zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c, operand_723);
                }), .index = (state_572).index, .modules = (if ((((state_572).modules).zx_origin != null)) ((state_572).modules).zx_origin.? else block_726: {
                    const operand_725 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_725).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_572).modules).identities, .import_names = ((state_572).modules).import_names, .specifiers = ((state_572).modules).specifiers, .type_ids = ((state_572).modules).type_ids, .type_names = ((state_572).modules).type_names, .type_namespaces = ((state_572).modules).type_namespaces, };

                    break :block_726 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_725);
                }), .plan = (state_572).plan, .request = (if ((((state_572).request).zx_origin != null)) ((state_572).request).zx_origin.? else block_728: {
                    const operand_727 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_727).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_572).request).maximum_count, .names = ((state_572).request).names, .origins = ((state_572).request).origins, .roots = ((state_572).request).roots, .scalar_count = ((state_572).request).scalar_count, .table = ((state_572).request).table, };

                    break :block_728 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_727);
                }), .signatures = (if ((((state_572).signatures).zx_origin != null)) ((state_572).signatures).zx_origin.? else block_730: {
                    const operand_729 = (try (allocator).create((zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c));

                    (operand_729).* = (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c{ .inputs = ((state_572).signatures).inputs, .native_modules = ((state_572).signatures).native_modules, .outputs = ((state_572).signatures).outputs, };

                    break :block_730 @as(*const (zx_abi).zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c, operand_729);
                }), };

                break :block_732 @as(*const (zx_abi).zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba, operand_731);
            });
        } else operand_582);
    };

    return (value_38).plan;
}

