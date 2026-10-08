const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_26: *const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_111: {
        const operand_18 = block_17: {
            const operand_7 = (in).request;
            const operand_8 = (in).state;
            const operand_9 = (in).modules;
            const operand_10 = (in).natives;
            const operand_11 = (in).dependencies;
            const operand_12 = @as(u64, 0);
            const operand_13 = @as(u64, 0);
            const operand_14 = false;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

                (operand_15).* = @as((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_7, .plan = operand_8, .modules = operand_9, .natives = operand_10, .dependencies = operand_11, .index = operand_12, .module = operand_13, .found = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_15);
            };
        };

        var state_capacity_20: (std).ArrayList(u64) = .empty;
        var state_capacity_started_21 = false;

        defer (state_capacity_20).deinit(allocator);

        var state_capacity_22: (std).ArrayList(u32) = .empty;
        var state_capacity_started_23 = false;

        defer (state_capacity_22).deinit(allocator);

        var state_capacity_24: (std).ArrayList(u64) = .empty;
        var state_capacity_started_25 = false;

        defer (state_capacity_24).deinit(allocator);

        var state_capacity_26: (std).ArrayList(u32) = .empty;
        var state_capacity_started_27 = false;

        defer (state_capacity_26).deinit(allocator);

        var state_capacity_28: (std).ArrayList(u64) = .empty;
        var state_capacity_started_29 = false;

        defer (state_capacity_28).deinit(allocator);

        var state_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_18).dependencies).is_native, .keys = ((operand_18).dependencies).keys, .zx_origin = (operand_18).dependencies, }, .found = (operand_18).found, .index = (operand_18).index, .module = (operand_18).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_18).modules).identities, .import_names = ((operand_18).modules).import_names, .specifiers = ((operand_18).modules).specifiers, .type_ids = ((operand_18).modules).type_ids, .type_names = ((operand_18).modules).type_names, .type_namespaces = ((operand_18).modules).type_namespaces, .zx_origin = (operand_18).modules, }, .natives = (operand_18).natives, .plan = (operand_18).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_18).request).maximum_count, .names = ((operand_18).request).names, .origins = ((operand_18).request).origins, .roots = ((operand_18).request).roots, .scalar_count = ((operand_18).request).scalar_count, .table = ((operand_18).request).table, .zx_origin = (operand_18).request, }, .zx_origin = operand_18, };
        var state_changed_19 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).index < @as(u64, (((state_6).dependencies).is_native).len)))) {
            state_6 = block_86: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_32: {
                    const operand_30 = ((state_6).dependencies).is_native;
                    const operand_31 = (state_6).index;

                    if ((operand_31 >= (operand_30).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_32 (operand_30)[@intCast(operand_31)];
                }) or ((state_6).module >= @as(u64, (((state_6).modules).specifiers).len)))) block_49: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_39: {
                        const operand_37 = ((state_6).dependencies).is_native;
                        const operand_38 = (state_6).index;

                        if ((operand_38 >= (operand_37).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_39 (operand_37)[@intCast(operand_38)];
                    } and (!(state_6).found))) block_48: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_6;
                        const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_3).plan;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_47: {
                            break :block_47 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_46: {
                                break :block_46 block_45: {
                                    const operand_44 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_44).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_40: {
                                        break :block_40 value_4;
                                    }).count, .mapping = (block_41: {
                                        break :block_41 value_4;
                                    }).mapping, .order = (block_42: {
                                        break :block_42 value_4;
                                    }).order, .origins = (block_43: {
                                        break :block_43 value_4;
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_45 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_44);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_48 value_5;
                    } else state_6);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_36: {
                        break :block_36 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_35: {
                            break :block_35 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_34: {
                        break :block_34 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_33: {
                        break :block_33 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_49 value_13;
                } else block_85: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_65: {
                        const operand_63 = block_59: {
                            const operand_52 = (state_6).modules;
                            var state_borrow_53: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_53 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_52).identities, .import_names = (operand_52).import_names, .specifiers = (operand_52).specifiers, .type_ids = (operand_52).type_ids, .type_names = (operand_52).type_names, .type_namespaces = (operand_52).type_namespaces, };

                            const operand_54 = ((operand_52).zx_origin orelse (&state_borrow_53));
                            const operand_55 = (state_6).module;
                            const operand_56 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_54).identities, .import_names = (operand_54).import_names, .specifiers = (operand_54).specifiers, .type_ids = (operand_54).type_ids, .type_names = (operand_54).type_names, .type_namespaces = (operand_54).type_namespaces, .zx_origin = operand_54, };
                            var state_borrow_57: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;

                            state_borrow_57 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_56).identities, .import_names = (operand_56).import_names, .specifiers = (operand_56).specifiers, .type_ids = (operand_56).type_ids, .type_names = (operand_56).type_names, .type_namespaces = (operand_56).type_namespaces, };

                            const operand_58 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_56).zx_origin orelse (&state_borrow_57)), .index = operand_55, };

                            break :block_59 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_58)));
                        };
                        const operand_64 = block_62: {
                            const operand_60 = ((state_6).dependencies).keys;
                            const operand_61 = (state_6).index;

                            if ((operand_61 >= (operand_60).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_62 (operand_60)[@intCast(operand_61)];
                        };

                        break :block_65 ((std).mem).eql(u8, operand_63, operand_64);
                    }) block_84: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_83: {
                            const operand_82 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_82).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_81: {
                                const operand_77 = block_76: {
                                    const operand_71 = (state_6).request;
                                    const operand_72 = (state_6).plan;
                                    const operand_73 = (state_6).modules;
                                    const operand_74 = (state_6).natives;
                                    const operand_75 = (state_6).module;

                                    break :block_76 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_71, .state = operand_72, .modules = operand_73, .natives = operand_74, .index = operand_75, });
                                };
                                var state_borrow_78: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_78 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_77).modules).identities, .import_names = ((operand_77).modules).import_names, .specifiers = ((operand_77).modules).specifiers, .type_ids = ((operand_77).modules).type_ids, .type_names = ((operand_77).modules).type_names, .type_namespaces = ((operand_77).modules).type_namespaces, };

                                var state_borrow_79: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_79 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_77).request).maximum_count, .names = ((operand_77).request).names, .origins = ((operand_77).request).origins, .roots = ((operand_77).request).roots, .scalar_count = ((operand_77).request).scalar_count, .table = ((operand_77).request).table, };

                                var state_borrow_80: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_80 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_77).index, .modules = (((operand_77).modules).zx_origin orelse (&state_borrow_78)), .natives = (operand_77).natives, .request = (((operand_77).request).zx_origin orelse (&state_borrow_79)), .state = (operand_77).state, };

                                break :block_81 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_77).zx_origin orelse (&state_borrow_80)), .{ .lane_0 = .{ .buffer = (&state_capacity_20), .started = (&state_capacity_started_21), }, .lane_1 = .{ .buffer = (&state_capacity_22), .started = (&state_capacity_started_23), }, .lane_2 = .{ .buffer = (&state_capacity_24), .started = (&state_capacity_started_25), }, .lane_3 = .{ .buffer = (&state_capacity_26), .started = (&state_capacity_started_27), }, .lane_4 = .{ .buffer = (&state_capacity_28), .started = (&state_capacity_started_29), }, }));
                            });

                            break :block_83 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_82);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_6;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_70: {
                            break :block_70 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_69: {
                                break :block_69 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_68: {
                            break :block_68 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_67: {
                                break :block_67 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_66: {
                            break :block_66 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_84 value_20;
                    } else state_6);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_51: {
                        break :block_51 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_50: {
                            break :block_50 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_85 value_24;
                });

                break :block_86 value_25;
            };

            state_changed_19 = true;
        }

        var state_owned_87: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_87);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = (((state_6).natives).mapping).len;
            state_owned_87 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            state_6 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_6).dependencies, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (state_6).modules, .natives = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_88).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = state_owned_87, .order = ((state_6).natives).order, });

                break :block_89 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_88);
            }, .plan = (state_6).plan, .request = (state_6).request, };
        }

        var state_owned_90: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_90);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = (((state_6).natives).order).len;
            state_owned_90 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            state_6 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_6).dependencies, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (state_6).modules, .natives = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_91).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = ((state_6).natives).mapping, .order = state_owned_90, });

                break :block_92 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_91);
            }, .plan = (state_6).plan, .request = (state_6).request, };
        }

        var state_owned_93: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = (((state_6).plan).mapping).len;
            state_owned_93 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            state_6 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_6).dependencies, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_94).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = state_owned_93, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_95 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_94);
            }, .request = (state_6).request, };
        }

        var state_owned_96: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_96);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = (((state_6).plan).order).len;
            state_owned_96 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            state_6 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_6).dependencies, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_98: {
                const operand_97 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_97).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = state_owned_96, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_98 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_97);
            }, .request = (state_6).request, };
        }

        var state_owned_99: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_99);

        if (state_capacity_started_29) {
            ((state_capacity_28).items).len = (((state_6).plan).origins).len;
            state_owned_99 = (try (state_capacity_28).toOwnedSlice(allocator));
        }

        if (state_capacity_started_29) {
            state_6 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_6).dependencies, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (state_6).modules, .natives = (state_6).natives, .plan = block_101: {
                const operand_100 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_100).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = state_owned_99, .status = ((state_6).plan).status, });

                break :block_101 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_100);
            }, .request = (state_6).request, };
        }

        break :block_111 (if (state_changed_19) block_110: {
            break :block_110 (if (((state_6).zx_origin != null)) (state_6).zx_origin.? else block_109: {
                const operand_108 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

                (operand_108).* = (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_6).dependencies).zx_origin != null)) ((state_6).dependencies).zx_origin.? else block_103: {
                    const operand_102 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_102).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_6).dependencies).is_native, .keys = ((state_6).dependencies).keys, };

                    break :block_103 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_102);
                }), .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = (if ((((state_6).modules).zx_origin != null)) ((state_6).modules).zx_origin.? else block_105: {
                    const operand_104 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_104).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_6).modules).identities, .import_names = ((state_6).modules).import_names, .specifiers = ((state_6).modules).specifiers, .type_ids = ((state_6).modules).type_ids, .type_names = ((state_6).modules).type_names, .type_namespaces = ((state_6).modules).type_namespaces, };

                    break :block_105 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_104);
                }), .natives = (state_6).natives, .plan = (state_6).plan, .request = (if ((((state_6).request).zx_origin != null)) ((state_6).request).zx_origin.? else block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_106).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = ((state_6).request).origins, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = ((state_6).request).table, };

                    break :block_107 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_106);
                }), };

                break :block_109 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_108);
            });
        } else operand_18);
    };

    return block_5: {
        const operand_1 = (value_26).plan;
        const operand_2 = (value_26).natives;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_3).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_1, .natives = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_3);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_26: (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_216: {
        const operand_125 = block_124: {
            const operand_116 = (in).request;
            const operand_117 = (in).state;
            const operand_118 = (in).modules;
            const operand_119 = (in).natives;
            const operand_120 = (in).dependencies;
            const operand_121 = @as(u64, 0);
            const operand_122 = @as(u64, 0);
            const operand_123 = false;

            break :block_124 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_116, .plan = operand_117, .modules = operand_118, .natives = operand_119, .dependencies = operand_120, .index = operand_121, .module = operand_122, .found = operand_123, };
        };

        var state_capacity_126: (std).ArrayList(u64) = .empty;
        var state_capacity_started_127 = false;

        defer (state_capacity_126).deinit(allocator);

        var state_capacity_128: (std).ArrayList(u32) = .empty;
        var state_capacity_started_129 = false;

        defer (state_capacity_128).deinit(allocator);

        var state_capacity_130: (std).ArrayList(u64) = .empty;
        var state_capacity_started_131 = false;

        defer (state_capacity_130).deinit(allocator);

        var state_capacity_132: (std).ArrayList(u32) = .empty;
        var state_capacity_started_133 = false;

        defer (state_capacity_132).deinit(allocator);

        var state_capacity_134: (std).ArrayList(u64) = .empty;
        var state_capacity_started_135 = false;

        defer (state_capacity_134).deinit(allocator);

        var state_115: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_125).dependencies).is_native, .keys = ((operand_125).dependencies).keys, .zx_origin = (operand_125).dependencies, }, .found = (operand_125).found, .index = (operand_125).index, .module = (operand_125).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_125).modules).identities, .import_names = ((operand_125).modules).import_names, .specifiers = ((operand_125).modules).specifiers, .type_ids = ((operand_125).modules).type_ids, .type_names = ((operand_125).modules).type_names, .type_namespaces = ((operand_125).modules).type_namespaces, .zx_origin = (operand_125).modules, }, .natives = (operand_125).natives, .plan = (operand_125).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_125).request).maximum_count, .names = ((operand_125).request).names, .origins = ((operand_125).request).origins, .roots = ((operand_125).request).roots, .scalar_count = ((operand_125).request).scalar_count, .table = ((operand_125).request).table, .zx_origin = (operand_125).request, }, .zx_origin = (&operand_125), };

        while (((((state_115).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_115).index < @as(u64, (((state_115).dependencies).is_native).len)))) {
            state_115 = block_192: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_138: {
                    const operand_136 = ((state_115).dependencies).is_native;
                    const operand_137 = (state_115).index;

                    if ((operand_137 >= (operand_136).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_138 (operand_136)[@intCast(operand_137)];
                }) or ((state_115).module >= @as(u64, (((state_115).modules).specifiers).len)))) block_155: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_145: {
                        const operand_143 = ((state_115).dependencies).is_native;
                        const operand_144 = (state_115).index;

                        if ((operand_144 >= (operand_143).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_145 (operand_143)[@intCast(operand_144)];
                    } and (!(state_115).found))) block_154: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_115;
                        const value_4: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_3).plan).*;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_153: {
                            break :block_153 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_152: {
                                break :block_152 block_151: {
                                    const operand_150 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_150).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_146: {
                                        break :block_146 (&value_4);
                                    }).count, .mapping = (block_147: {
                                        break :block_147 (&value_4);
                                    }).mapping, .order = (block_148: {
                                        break :block_148 (&value_4);
                                    }).order, .origins = (block_149: {
                                        break :block_149 (&value_4);
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_151 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_150);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_154 value_5;
                    } else state_115);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_142: {
                        break :block_142 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_141: {
                            break :block_141 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_140: {
                        break :block_140 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_139: {
                        break :block_139 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_155 value_13;
                } else block_191: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_171: {
                        const operand_169 = block_165: {
                            const operand_158 = (state_115).modules;
                            var state_borrow_159: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_159 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_158).identities, .import_names = (operand_158).import_names, .specifiers = (operand_158).specifiers, .type_ids = (operand_158).type_ids, .type_names = (operand_158).type_names, .type_namespaces = (operand_158).type_namespaces, };

                            const operand_160 = ((operand_158).zx_origin orelse (&state_borrow_159));
                            const operand_161 = (state_115).module;
                            const operand_162 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_160).identities, .import_names = (operand_160).import_names, .specifiers = (operand_160).specifiers, .type_ids = (operand_160).type_ids, .type_names = (operand_160).type_names, .type_namespaces = (operand_160).type_namespaces, .zx_origin = operand_160, };
                            var state_borrow_163: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_163 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_162).identities, .import_names = (operand_162).import_names, .specifiers = (operand_162).specifiers, .type_ids = (operand_162).type_ids, .type_names = (operand_162).type_names, .type_namespaces = (operand_162).type_namespaces, };

                            const operand_164 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_162).zx_origin orelse (&state_borrow_163)), .index = operand_161, };

                            break :block_165 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_164)));
                        };
                        const operand_170 = block_168: {
                            const operand_166 = ((state_115).dependencies).keys;
                            const operand_167 = (state_115).index;

                            if ((operand_167 >= (operand_166).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_168 (operand_166)[@intCast(operand_167)];
                        };

                        break :block_171 ((std).mem).eql(u8, operand_169, operand_170);
                    }) block_190: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_189: {
                            const operand_188 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_188).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_187: {
                                const operand_183 = block_182: {
                                    const operand_177 = (state_115).request;
                                    const operand_178 = (state_115).plan;
                                    const operand_179 = (state_115).modules;
                                    const operand_180 = (state_115).natives;
                                    const operand_181 = (state_115).module;

                                    break :block_182 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_177, .state = operand_178, .modules = operand_179, .natives = operand_180, .index = operand_181, });
                                };
                                var state_borrow_184: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_184 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_183).modules).identities, .import_names = ((operand_183).modules).import_names, .specifiers = ((operand_183).modules).specifiers, .type_ids = ((operand_183).modules).type_ids, .type_names = ((operand_183).modules).type_names, .type_namespaces = ((operand_183).modules).type_namespaces, };

                                var state_borrow_185: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_185 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_183).request).maximum_count, .names = ((operand_183).request).names, .origins = ((operand_183).request).origins, .roots = ((operand_183).request).roots, .scalar_count = ((operand_183).request).scalar_count, .table = ((operand_183).request).table, };

                                var state_borrow_186: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_186 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_183).index, .modules = (((operand_183).modules).zx_origin orelse (&state_borrow_184)), .natives = (operand_183).natives, .request = (((operand_183).request).zx_origin orelse (&state_borrow_185)), .state = (operand_183).state, };

                                break :block_187 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_183).zx_origin orelse (&state_borrow_186)), .{ .lane_0 = .{ .buffer = (&state_capacity_126), .started = (&state_capacity_started_127), }, .lane_1 = .{ .buffer = (&state_capacity_128), .started = (&state_capacity_started_129), }, .lane_2 = .{ .buffer = (&state_capacity_130), .started = (&state_capacity_started_131), }, .lane_3 = .{ .buffer = (&state_capacity_132), .started = (&state_capacity_started_133), }, .lane_4 = .{ .buffer = (&state_capacity_134), .started = (&state_capacity_started_135), }, }));
                            });

                            break :block_189 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_188);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_115;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_176: {
                            break :block_176 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_175: {
                                break :block_175 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_174: {
                            break :block_174 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_173: {
                                break :block_173 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_172: {
                            break :block_172 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_190 value_20;
                    } else state_115);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_157: {
                        break :block_157 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_156: {
                            break :block_156 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_191 value_24;
                });

                break :block_192 value_25;
            };
        }

        var state_owned_193: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_193);

        if (state_capacity_started_127) {
            ((state_capacity_126).items).len = (((state_115).natives).mapping).len;
            state_owned_193 = (try (state_capacity_126).toOwnedSlice(allocator));
        }

        if (state_capacity_started_127) {
            state_115 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_115).dependencies, .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (state_115).modules, .natives = block_195: {
                const operand_194 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_194).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_115).natives).count, .mapping = state_owned_193, .order = ((state_115).natives).order, });

                break :block_195 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_194);
            }, .plan = (state_115).plan, .request = (state_115).request, };
        }

        var state_owned_196: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_196);

        if (state_capacity_started_129) {
            ((state_capacity_128).items).len = (((state_115).natives).order).len;
            state_owned_196 = (try (state_capacity_128).toOwnedSlice(allocator));
        }

        if (state_capacity_started_129) {
            state_115 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_115).dependencies, .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (state_115).modules, .natives = block_198: {
                const operand_197 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_197).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_115).natives).count, .mapping = ((state_115).natives).mapping, .order = state_owned_196, });

                break :block_198 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_197);
            }, .plan = (state_115).plan, .request = (state_115).request, };
        }

        var state_owned_199: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_199);

        if (state_capacity_started_131) {
            ((state_capacity_130).items).len = (((state_115).plan).mapping).len;
            state_owned_199 = (try (state_capacity_130).toOwnedSlice(allocator));
        }

        if (state_capacity_started_131) {
            state_115 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_115).dependencies, .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (state_115).modules, .natives = (state_115).natives, .plan = block_201: {
                const operand_200 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_200).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_115).plan).count, .mapping = state_owned_199, .order = ((state_115).plan).order, .origins = ((state_115).plan).origins, .status = ((state_115).plan).status, });

                break :block_201 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_200);
            }, .request = (state_115).request, };
        }

        var state_owned_202: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_202);

        if (state_capacity_started_133) {
            ((state_capacity_132).items).len = (((state_115).plan).order).len;
            state_owned_202 = (try (state_capacity_132).toOwnedSlice(allocator));
        }

        if (state_capacity_started_133) {
            state_115 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_115).dependencies, .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (state_115).modules, .natives = (state_115).natives, .plan = block_204: {
                const operand_203 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_203).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_115).plan).count, .mapping = ((state_115).plan).mapping, .order = state_owned_202, .origins = ((state_115).plan).origins, .status = ((state_115).plan).status, });

                break :block_204 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_203);
            }, .request = (state_115).request, };
        }

        var state_owned_205: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_205);

        if (state_capacity_started_135) {
            ((state_capacity_134).items).len = (((state_115).plan).origins).len;
            state_owned_205 = (try (state_capacity_134).toOwnedSlice(allocator));
        }

        if (state_capacity_started_135) {
            state_115 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_115).dependencies, .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (state_115).modules, .natives = (state_115).natives, .plan = block_207: {
                const operand_206 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_206).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_115).plan).count, .mapping = ((state_115).plan).mapping, .order = ((state_115).plan).order, .origins = state_owned_205, .status = ((state_115).plan).status, });

                break :block_207 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_206);
            }, .request = (state_115).request, };
        }

        break :block_216 block_215: {
            break :block_215 (if (((state_115).zx_origin != null)) ((state_115).zx_origin.?).* else block_214: {
                break :block_214 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_115).dependencies).zx_origin != null)) ((state_115).dependencies).zx_origin.? else block_209: {
                    const operand_208 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_208).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_115).dependencies).is_native, .keys = ((state_115).dependencies).keys, };

                    break :block_209 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_208);
                }), .found = (state_115).found, .index = (state_115).index, .module = (state_115).module, .modules = (if ((((state_115).modules).zx_origin != null)) ((state_115).modules).zx_origin.? else block_211: {
                    const operand_210 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_210).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_115).modules).identities, .import_names = ((state_115).modules).import_names, .specifiers = ((state_115).modules).specifiers, .type_ids = ((state_115).modules).type_ids, .type_names = ((state_115).modules).type_names, .type_namespaces = ((state_115).modules).type_namespaces, };

                    break :block_211 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_210);
                }), .natives = (state_115).natives, .plan = (state_115).plan, .request = (if ((((state_115).request).zx_origin != null)) ((state_115).request).zx_origin.? else block_213: {
                    const operand_212 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_212).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_115).request).maximum_count, .names = ((state_115).request).names, .origins = ((state_115).request).origins, .roots = ((state_115).request).roots, .scalar_count = ((state_115).request).scalar_count, .table = ((state_115).request).table, };

                    break :block_213 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_212);
                }), };
            });
        };
    };

    return block_114: {
        const operand_112 = ((&value_26)).plan;
        const operand_113 = ((&value_26)).natives;

        break :block_114 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_112, .natives = operand_113, };
    };
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, buffers: struct {
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

    const value_26: (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_296: {
        const operand_230 = block_229: {
            const operand_221 = (in).request;
            const operand_222 = (in).state;
            const operand_223 = (in).modules;
            const operand_224 = (in).natives;
            const operand_225 = (in).dependencies;
            const operand_226 = @as(u64, 0);
            const operand_227 = @as(u64, 0);
            const operand_228 = false;

            break :block_229 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_221, .plan = operand_222, .modules = operand_223, .natives = operand_224, .dependencies = operand_225, .index = operand_226, .module = operand_227, .found = operand_228, };
        };

        var state_220: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_230).dependencies).is_native, .keys = ((operand_230).dependencies).keys, .zx_origin = (operand_230).dependencies, }, .found = (operand_230).found, .index = (operand_230).index, .module = (operand_230).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_230).modules).identities, .import_names = ((operand_230).modules).import_names, .specifiers = ((operand_230).modules).specifiers, .type_ids = ((operand_230).modules).type_ids, .type_names = ((operand_230).modules).type_names, .type_namespaces = ((operand_230).modules).type_namespaces, .zx_origin = (operand_230).modules, }, .natives = (operand_230).natives, .plan = (operand_230).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_230).request).maximum_count, .names = ((operand_230).request).names, .origins = ((operand_230).request).origins, .roots = ((operand_230).request).roots, .scalar_count = ((operand_230).request).scalar_count, .table = ((operand_230).request).table, .zx_origin = (operand_230).request, }, .zx_origin = (&operand_230), };

        while (((((state_220).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_220).index < @as(u64, (((state_220).dependencies).is_native).len)))) {
            state_220 = block_287: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_233: {
                    const operand_231 = ((state_220).dependencies).is_native;
                    const operand_232 = (state_220).index;

                    if ((operand_232 >= (operand_231).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_233 (operand_231)[@intCast(operand_232)];
                }) or ((state_220).module >= @as(u64, (((state_220).modules).specifiers).len)))) block_250: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_240: {
                        const operand_238 = ((state_220).dependencies).is_native;
                        const operand_239 = (state_220).index;

                        if ((operand_239 >= (operand_238).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_240 (operand_238)[@intCast(operand_239)];
                    } and (!(state_220).found))) block_249: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_220;
                        const value_4: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_3).plan).*;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_248: {
                            break :block_248 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_247: {
                                break :block_247 block_246: {
                                    const operand_245 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_245).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_241: {
                                        break :block_241 (&value_4);
                                    }).count, .mapping = (block_242: {
                                        break :block_242 (&value_4);
                                    }).mapping, .order = (block_243: {
                                        break :block_243 (&value_4);
                                    }).order, .origins = (block_244: {
                                        break :block_244 (&value_4);
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_246 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_245);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_249 value_5;
                    } else state_220);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_237: {
                        break :block_237 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_236: {
                            break :block_236 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_235: {
                        break :block_235 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_234: {
                        break :block_234 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_250 value_13;
                } else block_286: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_266: {
                        const operand_264 = block_260: {
                            const operand_253 = (state_220).modules;
                            var state_borrow_254: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_254 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_253).identities, .import_names = (operand_253).import_names, .specifiers = (operand_253).specifiers, .type_ids = (operand_253).type_ids, .type_names = (operand_253).type_names, .type_namespaces = (operand_253).type_namespaces, };
                            const operand_255 = ((operand_253).zx_origin orelse (&state_borrow_254));
                            const operand_256 = (state_220).module;
                            const operand_257 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_255).identities, .import_names = (operand_255).import_names, .specifiers = (operand_255).specifiers, .type_ids = (operand_255).type_ids, .type_names = (operand_255).type_names, .type_namespaces = (operand_255).type_namespaces, .zx_origin = operand_255, };
                            var state_borrow_258: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_258 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_257).identities, .import_names = (operand_257).import_names, .specifiers = (operand_257).specifiers, .type_ids = (operand_257).type_ids, .type_names = (operand_257).type_names, .type_namespaces = (operand_257).type_namespaces, };

                            const operand_259 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_257).zx_origin orelse (&state_borrow_258)), .index = operand_256, };

                            break :block_260 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_259)));
                        };
                        const operand_265 = block_263: {
                            const operand_261 = ((state_220).dependencies).keys;
                            const operand_262 = (state_220).index;

                            if ((operand_262 >= (operand_261).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_263 (operand_261)[@intCast(operand_262)];
                        };

                        break :block_266 ((std).mem).eql(u8, operand_264, operand_265);
                    }) block_285: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_284: {
                            const operand_283 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_283).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_282: {
                                const operand_278 = block_277: {
                                    const operand_272 = (state_220).request;
                                    const operand_273 = (state_220).plan;
                                    const operand_274 = (state_220).modules;
                                    const operand_275 = (state_220).natives;
                                    const operand_276 = (state_220).module;

                                    break :block_277 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_272, .state = operand_273, .modules = operand_274, .natives = operand_275, .index = operand_276, });
                                };
                                var state_borrow_279: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_279 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_278).modules).identities, .import_names = ((operand_278).modules).import_names, .specifiers = ((operand_278).modules).specifiers, .type_ids = ((operand_278).modules).type_ids, .type_names = ((operand_278).modules).type_names, .type_namespaces = ((operand_278).modules).type_namespaces, };

                                var state_borrow_280: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_280 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_278).request).maximum_count, .names = ((operand_278).request).names, .origins = ((operand_278).request).origins, .roots = ((operand_278).request).roots, .scalar_count = ((operand_278).request).scalar_count, .table = ((operand_278).request).table, };

                                var state_borrow_281: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;
                                state_borrow_281 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_278).index, .modules = (((operand_278).modules).zx_origin orelse (&state_borrow_279)), .natives = (operand_278).natives, .request = (((operand_278).request).zx_origin orelse (&state_borrow_280)), .state = (operand_278).state, };

                                break :block_282 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_278).zx_origin orelse (&state_borrow_281)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_284 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_283);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_220;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_271: {
                            break :block_271 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_270: {
                                break :block_270 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_269: {
                            break :block_269 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_268: {
                                break :block_268 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_267: {
                            break :block_267 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_285 value_20;
                    } else state_220);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_252: {
                        break :block_252 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_251: {
                            break :block_251 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_286 value_24;
                });

                break :block_287 value_25;
            };
        }

        break :block_296 block_295: {
            break :block_295 (if (((state_220).zx_origin != null)) ((state_220).zx_origin.?).* else block_294: {
                break :block_294 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_220).dependencies).zx_origin != null)) ((state_220).dependencies).zx_origin.? else block_289: {
                    const operand_288 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_288).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_220).dependencies).is_native, .keys = ((state_220).dependencies).keys, };

                    break :block_289 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_288);
                }), .found = (state_220).found, .index = (state_220).index, .module = (state_220).module, .modules = (if ((((state_220).modules).zx_origin != null)) ((state_220).modules).zx_origin.? else block_291: {
                    const operand_290 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_290).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_220).modules).identities, .import_names = ((state_220).modules).import_names, .specifiers = ((state_220).modules).specifiers, .type_ids = ((state_220).modules).type_ids, .type_names = ((state_220).modules).type_names, .type_namespaces = ((state_220).modules).type_namespaces, };

                    break :block_291 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_290);
                }), .natives = (state_220).natives, .plan = (state_220).plan, .request = (if ((((state_220).request).zx_origin != null)) ((state_220).request).zx_origin.? else block_293: {
                    const operand_292 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_292).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_220).request).maximum_count, .names = ((state_220).request).names, .origins = ((state_220).request).origins, .roots = ((state_220).request).roots, .scalar_count = ((state_220).request).scalar_count, .table = ((state_220).request).table, };

                    break :block_293 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_292);
                }), };
            });
        };
    };

    return block_219: {
        const operand_217 = ((&value_26)).plan;
        const operand_218 = ((&value_26)).natives;

        break :block_219 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_217, .natives = operand_218, };
    };
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, buffers: struct {
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

    const value_26: *const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_382: {
        const operand_314 = block_313: {
            const operand_303 = (in).request;
            const operand_304 = (in).state;
            const operand_305 = (in).modules;
            const operand_306 = (in).natives;
            const operand_307 = (in).dependencies;
            const operand_308 = @as(u64, 0);
            const operand_309 = @as(u64, 0);
            const operand_310 = false;

            break :block_313 block_312: {
                const operand_311 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

                (operand_311).* = @as((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_303, .plan = operand_304, .modules = operand_305, .natives = operand_306, .dependencies = operand_307, .index = operand_308, .module = operand_309, .found = operand_310, });

                break :block_312 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_311);
            };
        };

        var state_302: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_314).dependencies).is_native, .keys = ((operand_314).dependencies).keys, .zx_origin = (operand_314).dependencies, }, .found = (operand_314).found, .index = (operand_314).index, .module = (operand_314).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_314).modules).identities, .import_names = ((operand_314).modules).import_names, .specifiers = ((operand_314).modules).specifiers, .type_ids = ((operand_314).modules).type_ids, .type_names = ((operand_314).modules).type_names, .type_namespaces = ((operand_314).modules).type_namespaces, .zx_origin = (operand_314).modules, }, .natives = (operand_314).natives, .plan = (operand_314).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_314).request).maximum_count, .names = ((operand_314).request).names, .origins = ((operand_314).request).origins, .roots = ((operand_314).request).roots, .scalar_count = ((operand_314).request).scalar_count, .table = ((operand_314).request).table, .zx_origin = (operand_314).request, }, .zx_origin = operand_314, };
        var state_changed_315 = false;

        while (((((state_302).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_302).index < @as(u64, (((state_302).dependencies).is_native).len)))) {
            state_302 = block_372: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_318: {
                    const operand_316 = ((state_302).dependencies).is_native;
                    const operand_317 = (state_302).index;

                    if ((operand_317 >= (operand_316).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_318 (operand_316)[@intCast(operand_317)];
                }) or ((state_302).module >= @as(u64, (((state_302).modules).specifiers).len)))) block_335: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_325: {
                        const operand_323 = ((state_302).dependencies).is_native;
                        const operand_324 = (state_302).index;

                        if ((operand_324 >= (operand_323).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_325 (operand_323)[@intCast(operand_324)];
                    } and (!(state_302).found))) block_334: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_302;
                        const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_3).plan;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_333: {
                            break :block_333 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_332: {
                                break :block_332 block_331: {
                                    const operand_330 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_330).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_326: {
                                        break :block_326 value_4;
                                    }).count, .mapping = (block_327: {
                                        break :block_327 value_4;
                                    }).mapping, .order = (block_328: {
                                        break :block_328 value_4;
                                    }).order, .origins = (block_329: {
                                        break :block_329 value_4;
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_331 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_330);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_334 value_5;
                    } else state_302);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_322: {
                        break :block_322 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_321: {
                            break :block_321 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_320: {
                        break :block_320 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_319: {
                        break :block_319 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_335 value_13;
                } else block_371: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_351: {
                        const operand_349 = block_345: {
                            const operand_338 = (state_302).modules;
                            var state_borrow_339: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_339 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_338).identities, .import_names = (operand_338).import_names, .specifiers = (operand_338).specifiers, .type_ids = (operand_338).type_ids, .type_names = (operand_338).type_names, .type_namespaces = (operand_338).type_namespaces, };
                            const operand_340 = ((operand_338).zx_origin orelse (&state_borrow_339));
                            const operand_341 = (state_302).module;
                            const operand_342 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_340).identities, .import_names = (operand_340).import_names, .specifiers = (operand_340).specifiers, .type_ids = (operand_340).type_ids, .type_names = (operand_340).type_names, .type_namespaces = (operand_340).type_namespaces, .zx_origin = operand_340, };
                            var state_borrow_343: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_343 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_342).identities, .import_names = (operand_342).import_names, .specifiers = (operand_342).specifiers, .type_ids = (operand_342).type_ids, .type_names = (operand_342).type_names, .type_namespaces = (operand_342).type_namespaces, };

                            const operand_344 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_342).zx_origin orelse (&state_borrow_343)), .index = operand_341, };

                            break :block_345 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_344)));
                        };
                        const operand_350 = block_348: {
                            const operand_346 = ((state_302).dependencies).keys;
                            const operand_347 = (state_302).index;

                            if ((operand_347 >= (operand_346).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_348 (operand_346)[@intCast(operand_347)];
                        };

                        break :block_351 ((std).mem).eql(u8, operand_349, operand_350);
                    }) block_370: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_369: {
                            const operand_368 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_368).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_367: {
                                const operand_363 = block_362: {
                                    const operand_357 = (state_302).request;
                                    const operand_358 = (state_302).plan;
                                    const operand_359 = (state_302).modules;
                                    const operand_360 = (state_302).natives;
                                    const operand_361 = (state_302).module;

                                    break :block_362 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_357, .state = operand_358, .modules = operand_359, .natives = operand_360, .index = operand_361, });
                                };

                                var state_borrow_364: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_364 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_363).modules).identities, .import_names = ((operand_363).modules).import_names, .specifiers = ((operand_363).modules).specifiers, .type_ids = ((operand_363).modules).type_ids, .type_names = ((operand_363).modules).type_names, .type_namespaces = ((operand_363).modules).type_namespaces, };

                                var state_borrow_365: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_365 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_363).request).maximum_count, .names = ((operand_363).request).names, .origins = ((operand_363).request).origins, .roots = ((operand_363).request).roots, .scalar_count = ((operand_363).request).scalar_count, .table = ((operand_363).request).table, };

                                var state_borrow_366: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;
                                state_borrow_366 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_363).index, .modules = (((operand_363).modules).zx_origin orelse (&state_borrow_364)), .natives = (operand_363).natives, .request = (((operand_363).request).zx_origin orelse (&state_borrow_365)), .state = (operand_363).state, };

                                break :block_367 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_363).zx_origin orelse (&state_borrow_366)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_369 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_368);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_302;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_356: {
                            break :block_356 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_355: {
                                break :block_355 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_354: {
                            break :block_354 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_353: {
                                break :block_353 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_352: {
                            break :block_352 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_370 value_20;
                    } else state_302);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_337: {
                        break :block_337 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_336: {
                            break :block_336 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_371 value_24;
                });

                break :block_372 value_25;
            };

            state_changed_315 = true;
        }

        break :block_382 (if (state_changed_315) block_381: {
            break :block_381 (if (((state_302).zx_origin != null)) (state_302).zx_origin.? else block_380: {
                const operand_379 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

                (operand_379).* = (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_302).dependencies).zx_origin != null)) ((state_302).dependencies).zx_origin.? else block_374: {
                    const operand_373 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_373).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_302).dependencies).is_native, .keys = ((state_302).dependencies).keys, };

                    break :block_374 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_373);
                }), .found = (state_302).found, .index = (state_302).index, .module = (state_302).module, .modules = (if ((((state_302).modules).zx_origin != null)) ((state_302).modules).zx_origin.? else block_376: {
                    const operand_375 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_375).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_302).modules).identities, .import_names = ((state_302).modules).import_names, .specifiers = ((state_302).modules).specifiers, .type_ids = ((state_302).modules).type_ids, .type_names = ((state_302).modules).type_names, .type_namespaces = ((state_302).modules).type_namespaces, };

                    break :block_376 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_375);
                }), .natives = (state_302).natives, .plan = (state_302).plan, .request = (if ((((state_302).request).zx_origin != null)) ((state_302).request).zx_origin.? else block_378: {
                    const operand_377 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_377).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_302).request).maximum_count, .names = ((state_302).request).names, .origins = ((state_302).request).origins, .roots = ((state_302).request).roots, .scalar_count = ((state_302).request).scalar_count, .table = ((state_302).request).table, };

                    break :block_378 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_377);
                }), };

                break :block_380 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_379);
            });
        } else operand_314);
    };

    return block_301: {
        const operand_297 = (value_26).plan;
        const operand_298 = (value_26).natives;

        break :block_301 block_300: {
            const operand_299 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_299).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_297, .natives = operand_298, });

            break :block_300 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_299);
        };
    };
}

