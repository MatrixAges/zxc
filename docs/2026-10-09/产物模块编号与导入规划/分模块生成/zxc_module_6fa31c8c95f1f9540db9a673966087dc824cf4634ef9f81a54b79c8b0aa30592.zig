const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_26: *const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_114: {
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

        const state_type_33 = struct {
            is_native: []const bool,
            keys: []const []const u8,
        };
        const state_type_34 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };

        const state_type_35 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_36 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_37 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_38 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_39 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_37,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_38,
        };
        const state_type_40 = struct {
            dependencies: state_type_33,
            found: bool,
            index: u64,
            module: u64,
            modules: state_type_34,
            natives: state_type_35,
            plan: state_type_36,
            request: state_type_39,
        };
        const state_type_52 = struct {
            index: u64,
            modules: state_type_34,
        };
        const state_type_70 = struct {
            index: u64,
            modules: state_type_34,
            natives: state_type_35,
            request: state_type_39,
            state: state_type_36,
        };
        const state_type_87 = struct {
            natives: state_type_35,
            state: state_type_36,
        };

        var state_6: state_type_40 = state_type_40{ .dependencies = state_type_33{ .is_native = ((operand_18).dependencies).is_native, .keys = ((operand_18).dependencies).keys, }, .found = (operand_18).found, .index = (operand_18).index, .module = (operand_18).module, .modules = state_type_34{ .identities = ((operand_18).modules).identities, .import_names = ((operand_18).modules).import_names, .specifiers = ((operand_18).modules).specifiers, .type_ids = ((operand_18).modules).type_ids, .type_names = ((operand_18).modules).type_names, .type_namespaces = ((operand_18).modules).type_namespaces, }, .natives = state_type_35{ .count = ((operand_18).natives).count, .mapping = ((operand_18).natives).mapping, .order = ((operand_18).natives).order, }, .plan = state_type_36{ .count = ((operand_18).plan).count, .mapping = ((operand_18).plan).mapping, .order = ((operand_18).plan).order, .origins = ((operand_18).plan).origins, .status = ((operand_18).plan).status, }, .request = state_type_39{ .maximum_count = ((operand_18).request).maximum_count, .names = ((operand_18).request).names, .origins = state_type_37{ .ids = (((operand_18).request).origins).ids, .kinds = (((operand_18).request).origins).kinds, .members = (((operand_18).request).origins).members, .owners = (((operand_18).request).origins).owners, }, .roots = ((operand_18).request).roots, .scalar_count = ((operand_18).request).scalar_count, .table = state_type_38{ .children = (((operand_18).request).table).children, .field_names = (((operand_18).request).table).field_names, .field_types = (((operand_18).request).table).field_types, .first = (((operand_18).request).table).first, .kinds = (((operand_18).request).table).kinds, .labels = (((operand_18).request).table).labels, .names = (((operand_18).request).table).names, .second = (((operand_18).request).table).second, }, }, };
        var state_changed_19 = false;

        while (((((state_6).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_6).index < @as(u64, (((state_6).dependencies).is_native).len)))) {
            state_6 = block_91: {
                const value_25: state_type_40 = (if (((!block_32: {
                    const operand_30 = ((state_6).dependencies).is_native;
                    const operand_31 = (state_6).index;

                    if ((operand_31 >= (operand_30).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_32 (operand_30)[@intCast(operand_31)];
                }) or ((state_6).module >= @as(u64, (((state_6).modules).specifiers).len)))) block_50: {
                    const value_6: state_type_40 = (if ((block_46: {
                        const operand_44 = ((state_6).dependencies).is_native;
                        const operand_45 = (state_6).index;

                        if ((operand_45 >= (operand_44).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_46 (operand_44)[@intCast(operand_45)];
                    } and (!(state_6).found))) block_49: {
                        const value_3: state_type_40 = state_6;
                        const value_4: state_type_36 = (value_3).plan;

                        const value_5: state_type_40 = block_48: {
                            break :block_48 state_type_40{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_47: {
                                break :block_47 state_type_36{ .count = (value_4).count, .mapping = (value_4).mapping, .order = (value_4).order, .origins = (value_4).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), };
                            }, .request = (value_3).request, };
                        };

                        break :block_49 value_5;
                    } else state_6);

                    const value_7: state_type_40 = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: state_type_40 = block_43: {
                        break :block_43 state_type_40{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (value_8 + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, };
                    };

                    const value_10: state_type_40 = value_9;

                    const value_11: state_type_40 = block_42: {
                        break :block_42 state_type_40{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, };
                    };
                    const value_12: state_type_40 = value_11;

                    const value_13: state_type_40 = block_41: {
                        break :block_41 state_type_40{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, };
                    };

                    break :block_50 value_13;
                } else block_90: {
                    const value_21: state_type_40 = (if (block_66: {
                        const operand_64 = block_60: {
                            const operand_56 = block_55: {
                                const operand_53 = (state_6).modules;
                                const operand_54 = (state_6).module;

                                break :block_55 state_type_52{ .modules = operand_53, .index = operand_54, };
                            };

                            const operand_57 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_56).modules).identities, .import_names = ((operand_56).modules).import_names, .specifiers = ((operand_56).modules).specifiers, .type_ids = ((operand_56).modules).type_ids, .type_names = ((operand_56).modules).type_names, .type_namespaces = ((operand_56).modules).type_namespaces, };
                            const operand_58 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .index = (operand_56).index, .modules = (&operand_57), };
                            const operand_59 = (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_58)));

                            break :block_60 operand_59;
                        };
                        const operand_65 = block_63: {
                            const operand_61 = ((state_6).dependencies).keys;
                            const operand_62 = (state_6).index;

                            if ((operand_62 >= (operand_61).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_63 (operand_61)[@intCast(operand_62)];
                        };

                        break :block_66 ((std).mem).eql(u8, operand_64, operand_65);
                    }) block_89: {
                        const value_14: state_type_87 = block_88: {
                            const operand_77 = block_76: {
                                const operand_71 = (state_6).request;
                                const operand_72 = (state_6).plan;
                                const operand_73 = (state_6).modules;
                                const operand_74 = (state_6).natives;
                                const operand_75 = (state_6).module;

                                break :block_76 state_type_70{ .request = operand_71, .state = operand_72, .modules = operand_73, .natives = operand_74, .index = operand_75, };
                            };

                            const operand_78 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_77).modules).identities, .import_names = ((operand_77).modules).import_names, .specifiers = ((operand_77).modules).specifiers, .type_ids = ((operand_77).modules).type_ids, .type_names = ((operand_77).modules).type_names, .type_namespaces = ((operand_77).modules).type_namespaces, };
                            const operand_79 = (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((operand_77).natives).count, .mapping = ((operand_77).natives).mapping, .order = ((operand_77).natives).order, };
                            const operand_80 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_77).request).origins).ids, .kinds = (((operand_77).request).origins).kinds, .members = (((operand_77).request).origins).members, .owners = (((operand_77).request).origins).owners, };
                            const operand_81 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_77).request).table).children, .field_names = (((operand_77).request).table).field_names, .field_types = (((operand_77).request).table).field_types, .first = (((operand_77).request).table).first, .kinds = (((operand_77).request).table).kinds, .labels = (((operand_77).request).table).labels, .names = (((operand_77).request).table).names, .second = (((operand_77).request).table).second, };
                            const operand_82 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_77).request).maximum_count, .names = ((operand_77).request).names, .origins = (&operand_80), .roots = ((operand_77).request).roots, .scalar_count = ((operand_77).request).scalar_count, .table = (&operand_81), };
                            const operand_83 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_77).state).count, .mapping = ((operand_77).state).mapping, .order = ((operand_77).state).order, .origins = ((operand_77).state).origins, .status = ((operand_77).state).status, };
                            const operand_84 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_77).index, .modules = (&operand_78), .natives = (&operand_79), .request = (&operand_82), .state = (&operand_83), };

                            const operand_86 = block_85: {
                                break :block_85 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, (&operand_84), .{ .lane_0 = .{ .buffer = (&state_capacity_20), .started = (&state_capacity_started_21), }, .lane_1 = .{ .buffer = (&state_capacity_22), .started = (&state_capacity_started_23), }, .lane_2 = .{ .buffer = (&state_capacity_24), .started = (&state_capacity_started_25), }, .lane_3 = .{ .buffer = (&state_capacity_26), .started = (&state_capacity_started_27), }, .lane_4 = .{ .buffer = (&state_capacity_28), .started = (&state_capacity_started_29), }, }));
                            };

                            break :block_88 state_type_87{ .natives = state_type_35{ .count = ((operand_86).natives).count, .mapping = ((operand_86).natives).mapping, .order = ((operand_86).natives).order, }, .state = state_type_36{ .count = ((operand_86).state).count, .mapping = ((operand_86).state).mapping, .order = ((operand_86).state).order, .origins = ((operand_86).state).origins, .status = ((operand_86).state).status, }, };
                        };
                        const value_15: state_type_40 = state_6;

                        const value_16: state_type_40 = block_69: {
                            break :block_69 state_type_40{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_14).state, .request = (value_15).request, };
                        };
                        const value_17: state_type_40 = value_16;

                        const value_18: state_type_40 = block_68: {
                            break :block_68 state_type_40{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (value_14).natives, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_19: state_type_40 = value_18;

                        const value_20: state_type_40 = block_67: {
                            break :block_67 state_type_40{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, };
                        };

                        break :block_89 value_20;
                    } else state_6);

                    const value_22: state_type_40 = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: state_type_40 = block_51: {
                        break :block_51 state_type_40{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (value_23 + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, };
                    };

                    break :block_90 value_24;
                });

                break :block_91 value_25;
            };

            state_changed_19 = true;
        }

        var state_owned_92: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_92);

        if (state_capacity_started_21) {
            ((state_capacity_20).items).len = (((state_6).natives).mapping).len;
            state_owned_92 = (try (state_capacity_20).toOwnedSlice(allocator));
        }

        if (state_capacity_started_21) {
            ((state_6).natives).mapping = state_owned_92;
        }

        var state_owned_93: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_93);

        if (state_capacity_started_23) {
            ((state_capacity_22).items).len = (((state_6).natives).order).len;
            state_owned_93 = (try (state_capacity_22).toOwnedSlice(allocator));
        }

        if (state_capacity_started_23) {
            ((state_6).natives).order = state_owned_93;
        }

        var state_owned_94: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_94);

        if (state_capacity_started_25) {
            ((state_capacity_24).items).len = (((state_6).plan).mapping).len;
            state_owned_94 = (try (state_capacity_24).toOwnedSlice(allocator));
        }

        if (state_capacity_started_25) {
            ((state_6).plan).mapping = state_owned_94;
        }

        var state_owned_95: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_95);

        if (state_capacity_started_27) {
            ((state_capacity_26).items).len = (((state_6).plan).order).len;
            state_owned_95 = (try (state_capacity_26).toOwnedSlice(allocator));
        }

        if (state_capacity_started_27) {
            ((state_6).plan).order = state_owned_95;
        }

        var state_owned_96: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_96);

        if (state_capacity_started_29) {
            ((state_capacity_28).items).len = (((state_6).plan).origins).len;
            state_owned_96 = (try (state_capacity_28).toOwnedSlice(allocator));
        }

        if (state_capacity_started_29) {
            ((state_6).plan).origins = state_owned_96;
        }

        break :block_114 (if (state_changed_19) block_113: {
            const operand_112 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

            (operand_112).* = @as((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = block_99: {
                const operand_98 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                (operand_98).* = @as((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_6).dependencies).is_native, .keys = ((state_6).dependencies).keys, });

                break :block_99 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_98);
            }, .found = (state_6).found, .index = (state_6).index, .module = (state_6).module, .modules = block_101: {
                const operand_100 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_100).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_6).modules).identities, .import_names = ((state_6).modules).import_names, .specifiers = ((state_6).modules).specifiers, .type_ids = ((state_6).modules).type_ids, .type_names = ((state_6).modules).type_names, .type_namespaces = ((state_6).modules).type_namespaces, });

                break :block_101 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_100);
            }, .natives = block_103: {
                const operand_102 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_102).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_6).natives).count, .mapping = ((state_6).natives).mapping, .order = ((state_6).natives).order, });

                break :block_103 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_102);
            }, .plan = block_105: {
                const operand_104 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_104).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_6).plan).count, .mapping = ((state_6).plan).mapping, .order = ((state_6).plan).order, .origins = ((state_6).plan).origins, .status = ((state_6).plan).status, });

                break :block_105 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_104);
            }, .request = block_111: {
                const operand_110 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_110).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_6).request).maximum_count, .names = ((state_6).request).names, .origins = block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_106).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_6).request).origins).ids, .kinds = (((state_6).request).origins).kinds, .members = (((state_6).request).origins).members, .owners = (((state_6).request).origins).owners, });

                    break :block_107 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_106);
                }, .roots = ((state_6).request).roots, .scalar_count = ((state_6).request).scalar_count, .table = block_109: {
                    const operand_108 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_108).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_6).request).table).children, .field_names = (((state_6).request).table).field_names, .field_types = (((state_6).request).table).field_types, .first = (((state_6).request).table).first, .kinds = (((state_6).request).table).kinds, .labels = (((state_6).request).table).labels, .names = (((state_6).request).table).names, .second = (((state_6).request).table).second, });

                    break :block_109 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_108);
                }, });

                break :block_111 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_110);
            }, });

            break :block_113 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_112);
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

    const value_26: (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_219: {
        const operand_128 = block_127: {
            const operand_119 = (in).request;
            const operand_120 = (in).state;
            const operand_121 = (in).modules;
            const operand_122 = (in).natives;
            const operand_123 = (in).dependencies;
            const operand_124 = @as(u64, 0);
            const operand_125 = @as(u64, 0);
            const operand_126 = false;

            break :block_127 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_119, .plan = operand_120, .modules = operand_121, .natives = operand_122, .dependencies = operand_123, .index = operand_124, .module = operand_125, .found = operand_126, };
        };

        var state_capacity_129: (std).ArrayList(u64) = .empty;
        var state_capacity_started_130 = false;

        defer (state_capacity_129).deinit(allocator);

        var state_capacity_131: (std).ArrayList(u32) = .empty;
        var state_capacity_started_132 = false;

        defer (state_capacity_131).deinit(allocator);

        var state_capacity_133: (std).ArrayList(u64) = .empty;
        var state_capacity_started_134 = false;

        defer (state_capacity_133).deinit(allocator);

        var state_capacity_135: (std).ArrayList(u32) = .empty;
        var state_capacity_started_136 = false;

        defer (state_capacity_135).deinit(allocator);

        var state_capacity_137: (std).ArrayList(u64) = .empty;
        var state_capacity_started_138 = false;

        defer (state_capacity_137).deinit(allocator);

        var state_118: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_128).dependencies).is_native, .keys = ((operand_128).dependencies).keys, .zx_origin = (operand_128).dependencies, }, .found = (operand_128).found, .index = (operand_128).index, .module = (operand_128).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_128).modules).identities, .import_names = ((operand_128).modules).import_names, .specifiers = ((operand_128).modules).specifiers, .type_ids = ((operand_128).modules).type_ids, .type_names = ((operand_128).modules).type_names, .type_namespaces = ((operand_128).modules).type_namespaces, .zx_origin = (operand_128).modules, }, .natives = (operand_128).natives, .plan = (operand_128).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_128).request).maximum_count, .names = ((operand_128).request).names, .origins = ((operand_128).request).origins, .roots = ((operand_128).request).roots, .scalar_count = ((operand_128).request).scalar_count, .table = ((operand_128).request).table, .zx_origin = (operand_128).request, }, .zx_origin = (&operand_128), };

        while (((((state_118).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_118).index < @as(u64, (((state_118).dependencies).is_native).len)))) {
            state_118 = block_195: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_141: {
                    const operand_139 = ((state_118).dependencies).is_native;
                    const operand_140 = (state_118).index;

                    if ((operand_140 >= (operand_139).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_141 (operand_139)[@intCast(operand_140)];
                }) or ((state_118).module >= @as(u64, (((state_118).modules).specifiers).len)))) block_158: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_148: {
                        const operand_146 = ((state_118).dependencies).is_native;
                        const operand_147 = (state_118).index;

                        if ((operand_147 >= (operand_146).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_148 (operand_146)[@intCast(operand_147)];
                    } and (!(state_118).found))) block_157: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_118;
                        const value_4: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_3).plan).*;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_156: {
                            break :block_156 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_155: {
                                break :block_155 block_154: {
                                    const operand_153 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_153).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_149: {
                                        break :block_149 (&value_4);
                                    }).count, .mapping = (block_150: {
                                        break :block_150 (&value_4);
                                    }).mapping, .order = (block_151: {
                                        break :block_151 (&value_4);
                                    }).order, .origins = (block_152: {
                                        break :block_152 (&value_4);
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_154 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_153);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_157 value_5;
                    } else state_118);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_145: {
                        break :block_145 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_144: {
                            break :block_144 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_143: {
                        break :block_143 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_142: {
                        break :block_142 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_158 value_13;
                } else block_194: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_174: {
                        const operand_172 = block_168: {
                            const operand_161 = (state_118).modules;
                            var state_borrow_162: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_162 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_161).identities, .import_names = (operand_161).import_names, .specifiers = (operand_161).specifiers, .type_ids = (operand_161).type_ids, .type_names = (operand_161).type_names, .type_namespaces = (operand_161).type_namespaces, };
                            const operand_163 = ((operand_161).zx_origin orelse (&state_borrow_162));
                            const operand_164 = (state_118).module;
                            const operand_165 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_163).identities, .import_names = (operand_163).import_names, .specifiers = (operand_163).specifiers, .type_ids = (operand_163).type_ids, .type_names = (operand_163).type_names, .type_namespaces = (operand_163).type_namespaces, .zx_origin = operand_163, };
                            var state_borrow_166: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_166 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_165).identities, .import_names = (operand_165).import_names, .specifiers = (operand_165).specifiers, .type_ids = (operand_165).type_ids, .type_names = (operand_165).type_names, .type_namespaces = (operand_165).type_namespaces, };

                            const operand_167 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_165).zx_origin orelse (&state_borrow_166)), .index = operand_164, };

                            break :block_168 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_167)));
                        };
                        const operand_173 = block_171: {
                            const operand_169 = ((state_118).dependencies).keys;
                            const operand_170 = (state_118).index;

                            if ((operand_170 >= (operand_169).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_171 (operand_169)[@intCast(operand_170)];
                        };

                        break :block_174 ((std).mem).eql(u8, operand_172, operand_173);
                    }) block_193: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_192: {
                            const operand_191 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_191).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_190: {
                                const operand_186 = block_185: {
                                    const operand_180 = (state_118).request;
                                    const operand_181 = (state_118).plan;
                                    const operand_182 = (state_118).modules;
                                    const operand_183 = (state_118).natives;
                                    const operand_184 = (state_118).module;

                                    break :block_185 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_180, .state = operand_181, .modules = operand_182, .natives = operand_183, .index = operand_184, });
                                };
                                var state_borrow_187: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_187 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_186).modules).identities, .import_names = ((operand_186).modules).import_names, .specifiers = ((operand_186).modules).specifiers, .type_ids = ((operand_186).modules).type_ids, .type_names = ((operand_186).modules).type_names, .type_namespaces = ((operand_186).modules).type_namespaces, };

                                var state_borrow_188: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;
                                state_borrow_188 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_186).request).maximum_count, .names = ((operand_186).request).names, .origins = ((operand_186).request).origins, .roots = ((operand_186).request).roots, .scalar_count = ((operand_186).request).scalar_count, .table = ((operand_186).request).table, };

                                var state_borrow_189: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;
                                state_borrow_189 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_186).index, .modules = (((operand_186).modules).zx_origin orelse (&state_borrow_187)), .natives = (operand_186).natives, .request = (((operand_186).request).zx_origin orelse (&state_borrow_188)), .state = (operand_186).state, };

                                break :block_190 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_186).zx_origin orelse (&state_borrow_189)), .{ .lane_0 = .{ .buffer = (&state_capacity_129), .started = (&state_capacity_started_130), }, .lane_1 = .{ .buffer = (&state_capacity_131), .started = (&state_capacity_started_132), }, .lane_2 = .{ .buffer = (&state_capacity_133), .started = (&state_capacity_started_134), }, .lane_3 = .{ .buffer = (&state_capacity_135), .started = (&state_capacity_started_136), }, .lane_4 = .{ .buffer = (&state_capacity_137), .started = (&state_capacity_started_138), }, }));
                            });

                            break :block_192 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_191);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_118;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_179: {
                            break :block_179 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_178: {
                                break :block_178 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_177: {
                            break :block_177 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_176: {
                                break :block_176 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_175: {
                            break :block_175 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_193 value_20;
                    } else state_118);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_160: {
                        break :block_160 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_159: {
                            break :block_159 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_194 value_24;
                });

                break :block_195 value_25;
            };
        }

        var state_owned_196: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_196);

        if (state_capacity_started_130) {
            ((state_capacity_129).items).len = (((state_118).natives).mapping).len;
            state_owned_196 = (try (state_capacity_129).toOwnedSlice(allocator));
        }

        if (state_capacity_started_130) {
            state_118 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_118).dependencies, .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (state_118).modules, .natives = block_198: {
                const operand_197 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_197).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_118).natives).count, .mapping = state_owned_196, .order = ((state_118).natives).order, });

                break :block_198 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_197);
            }, .plan = (state_118).plan, .request = (state_118).request, };
        }

        var state_owned_199: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_199);

        if (state_capacity_started_132) {
            ((state_capacity_131).items).len = (((state_118).natives).order).len;
            state_owned_199 = (try (state_capacity_131).toOwnedSlice(allocator));
        }

        if (state_capacity_started_132) {
            state_118 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_118).dependencies, .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (state_118).modules, .natives = block_201: {
                const operand_200 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_200).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_118).natives).count, .mapping = ((state_118).natives).mapping, .order = state_owned_199, });

                break :block_201 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_200);
            }, .plan = (state_118).plan, .request = (state_118).request, };
        }

        var state_owned_202: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_202);

        if (state_capacity_started_134) {
            ((state_capacity_133).items).len = (((state_118).plan).mapping).len;
            state_owned_202 = (try (state_capacity_133).toOwnedSlice(allocator));
        }

        if (state_capacity_started_134) {
            state_118 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_118).dependencies, .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (state_118).modules, .natives = (state_118).natives, .plan = block_204: {
                const operand_203 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_203).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_118).plan).count, .mapping = state_owned_202, .order = ((state_118).plan).order, .origins = ((state_118).plan).origins, .status = ((state_118).plan).status, });

                break :block_204 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_203);
            }, .request = (state_118).request, };
        }

        var state_owned_205: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_205);

        if (state_capacity_started_136) {
            ((state_capacity_135).items).len = (((state_118).plan).order).len;
            state_owned_205 = (try (state_capacity_135).toOwnedSlice(allocator));
        }

        if (state_capacity_started_136) {
            state_118 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_118).dependencies, .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (state_118).modules, .natives = (state_118).natives, .plan = block_207: {
                const operand_206 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_206).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_118).plan).count, .mapping = ((state_118).plan).mapping, .order = state_owned_205, .origins = ((state_118).plan).origins, .status = ((state_118).plan).status, });

                break :block_207 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_206);
            }, .request = (state_118).request, };
        }

        var state_owned_208: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_208);

        if (state_capacity_started_138) {
            ((state_capacity_137).items).len = (((state_118).plan).origins).len;
            state_owned_208 = (try (state_capacity_137).toOwnedSlice(allocator));
        }

        if (state_capacity_started_138) {
            state_118 = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (state_118).dependencies, .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (state_118).modules, .natives = (state_118).natives, .plan = block_210: {
                const operand_209 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_209).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_118).plan).count, .mapping = ((state_118).plan).mapping, .order = ((state_118).plan).order, .origins = state_owned_208, .status = ((state_118).plan).status, });

                break :block_210 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_209);
            }, .request = (state_118).request, };
        }

        break :block_219 block_218: {
            break :block_218 (if (((state_118).zx_origin != null)) ((state_118).zx_origin.?).* else block_217: {
                break :block_217 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_118).dependencies).zx_origin != null)) ((state_118).dependencies).zx_origin.? else block_212: {
                    const operand_211 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_211).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_118).dependencies).is_native, .keys = ((state_118).dependencies).keys, };

                    break :block_212 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_211);
                }), .found = (state_118).found, .index = (state_118).index, .module = (state_118).module, .modules = (if ((((state_118).modules).zx_origin != null)) ((state_118).modules).zx_origin.? else block_214: {
                    const operand_213 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_213).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_118).modules).identities, .import_names = ((state_118).modules).import_names, .specifiers = ((state_118).modules).specifiers, .type_ids = ((state_118).modules).type_ids, .type_names = ((state_118).modules).type_names, .type_namespaces = ((state_118).modules).type_namespaces, };

                    break :block_214 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_213);
                }), .natives = (state_118).natives, .plan = (state_118).plan, .request = (if ((((state_118).request).zx_origin != null)) ((state_118).request).zx_origin.? else block_216: {
                    const operand_215 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_215).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_118).request).maximum_count, .names = ((state_118).request).names, .origins = ((state_118).request).origins, .roots = ((state_118).request).roots, .scalar_count = ((state_118).request).scalar_count, .table = ((state_118).request).table, };

                    break :block_216 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_215);
                }), };
            });
        };
    };

    return block_117: {
        const operand_115 = ((&value_26)).plan;
        const operand_116 = ((&value_26)).natives;

        break :block_117 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_115, .natives = operand_116, };
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

    const value_26: (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_299: {
        const operand_233 = block_232: {
            const operand_224 = (in).request;
            const operand_225 = (in).state;
            const operand_226 = (in).modules;
            const operand_227 = (in).natives;
            const operand_228 = (in).dependencies;
            const operand_229 = @as(u64, 0);
            const operand_230 = @as(u64, 0);
            const operand_231 = false;

            break :block_232 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_224, .plan = operand_225, .modules = operand_226, .natives = operand_227, .dependencies = operand_228, .index = operand_229, .module = operand_230, .found = operand_231, };
        };

        var state_223: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (zx_abi).value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .is_native = ((operand_233).dependencies).is_native, .keys = ((operand_233).dependencies).keys, .zx_origin = (operand_233).dependencies, }, .found = (operand_233).found, .index = (operand_233).index, .module = (operand_233).module, .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_233).modules).identities, .import_names = ((operand_233).modules).import_names, .specifiers = ((operand_233).modules).specifiers, .type_ids = ((operand_233).modules).type_ids, .type_names = ((operand_233).modules).type_names, .type_namespaces = ((operand_233).modules).type_namespaces, .zx_origin = (operand_233).modules, }, .natives = (operand_233).natives, .plan = (operand_233).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_233).request).maximum_count, .names = ((operand_233).request).names, .origins = ((operand_233).request).origins, .roots = ((operand_233).request).roots, .scalar_count = ((operand_233).request).scalar_count, .table = ((operand_233).request).table, .zx_origin = (operand_233).request, }, .zx_origin = (&operand_233), };

        while (((((state_223).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_223).index < @as(u64, (((state_223).dependencies).is_native).len)))) {
            state_223 = block_290: {
                const value_25: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (((!block_236: {
                    const operand_234 = ((state_223).dependencies).is_native;
                    const operand_235 = (state_223).index;

                    if ((operand_235 >= (operand_234).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_236 (operand_234)[@intCast(operand_235)];
                }) or ((state_223).module >= @as(u64, (((state_223).modules).specifiers).len)))) block_253: {
                    const value_6: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if ((block_243: {
                        const operand_241 = ((state_223).dependencies).is_native;
                        const operand_242 = (state_223).index;

                        if ((operand_242 >= (operand_241).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_243 (operand_241)[@intCast(operand_242)];
                    } and (!(state_223).found))) block_252: {
                        const value_3: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_223;
                        const value_4: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_3).plan).*;

                        const value_5: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_251: {
                            break :block_251 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_250: {
                                break :block_250 block_249: {
                                    const operand_248 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_248).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_244: {
                                        break :block_244 (&value_4);
                                    }).count, .mapping = (block_245: {
                                        break :block_245 (&value_4);
                                    }).mapping, .order = (block_246: {
                                        break :block_246 (&value_4);
                                    }).order, .origins = (block_247: {
                                        break :block_247 (&value_4);
                                    }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                    break :block_249 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_248);
                                };
                            }, .request = (value_3).request, });
                        };

                        break :block_252 value_5;
                    } else state_223);

                    const value_7: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_240: {
                        break :block_240 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (block_239: {
                            break :block_239 value_8;
                        } + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, });
                    };

                    const value_10: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_9;

                    const value_11: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_238: {
                        break :block_238 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, });
                    };

                    const value_12: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_11;

                    const value_13: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_237: {
                        break :block_237 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, });
                    };

                    break :block_253 value_13;
                } else block_289: {
                    const value_21: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = (if (block_269: {
                        const operand_267 = block_263: {
                            const operand_256 = (state_223).modules;
                            var state_borrow_257: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_257 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_256).identities, .import_names = (operand_256).import_names, .specifiers = (operand_256).specifiers, .type_ids = (operand_256).type_ids, .type_names = (operand_256).type_names, .type_namespaces = (operand_256).type_namespaces, };
                            const operand_258 = ((operand_256).zx_origin orelse (&state_borrow_257));
                            const operand_259 = (state_223).module;
                            const operand_260 = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = (operand_258).identities, .import_names = (operand_258).import_names, .specifiers = (operand_258).specifiers, .type_ids = (operand_258).type_ids, .type_names = (operand_258).type_names, .type_namespaces = (operand_258).type_namespaces, .zx_origin = operand_258, };
                            var state_borrow_261: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                            state_borrow_261 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = (operand_260).identities, .import_names = (operand_260).import_names, .specifiers = (operand_260).specifiers, .type_ids = (operand_260).type_ids, .type_names = (operand_260).type_names, .type_namespaces = (operand_260).type_namespaces, };

                            const operand_262 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .modules = ((operand_260).zx_origin orelse (&state_borrow_261)), .index = operand_259, };

                            break :block_263 (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_262)));
                        };
                        const operand_268 = block_266: {
                            const operand_264 = ((state_223).dependencies).keys;
                            const operand_265 = (state_223).index;

                            if ((operand_265 >= (operand_264).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_266 (operand_264)[@intCast(operand_265)];
                        };

                        break :block_269 ((std).mem).eql(u8, operand_267, operand_268);
                    }) block_288: {
                        const value_14: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_287: {
                            const operand_286 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                            (operand_286).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, block_285: {
                                const operand_281 = block_280: {
                                    const operand_275 = (state_223).request;
                                    const operand_276 = (state_223).plan;
                                    const operand_277 = (state_223).modules;
                                    const operand_278 = (state_223).natives;
                                    const operand_279 = (state_223).module;

                                    break :block_280 @as((zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06, (zx_abi).value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06{ .request = operand_275, .state = operand_276, .modules = operand_277, .natives = operand_278, .index = operand_279, });
                                };

                                var state_borrow_282: (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = undefined;
                                state_borrow_282 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_281).modules).identities, .import_names = ((operand_281).modules).import_names, .specifiers = ((operand_281).modules).specifiers, .type_ids = ((operand_281).modules).type_ids, .type_names = ((operand_281).modules).type_names, .type_namespaces = ((operand_281).modules).type_namespaces, };

                                var state_borrow_283: (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = undefined;

                                state_borrow_283 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_281).request).maximum_count, .names = ((operand_281).request).names, .origins = ((operand_281).request).origins, .roots = ((operand_281).request).roots, .scalar_count = ((operand_281).request).scalar_count, .table = ((operand_281).request).table, };

                                var state_borrow_284: (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = undefined;

                                state_borrow_284 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_281).index, .modules = (((operand_281).modules).zx_origin orelse (&state_borrow_282)), .natives = (operand_281).natives, .request = (((operand_281).request).zx_origin orelse (&state_borrow_283)), .state = (operand_281).state, };

                                break :block_285 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, ((operand_281).zx_origin orelse (&state_borrow_284)), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            });

                            break :block_287 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_286);
                        };

                        const value_15: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = state_223;

                        const value_16: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_274: {
                            break :block_274 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (block_273: {
                                break :block_273 value_14;
                            }).state, .request = (value_15).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_16;

                        const value_18: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_272: {
                            break :block_272 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (block_271: {
                                break :block_271 value_14;
                            }).natives, .plan = (value_17).plan, .request = (value_17).request, });
                        };

                        const value_19: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_18;

                        const value_20: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_270: {
                            break :block_270 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, });
                        };

                        break :block_288 value_20;
                    } else state_223);

                    const value_22: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = block_255: {
                        break :block_255 @as((zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e, (zx_abi).value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (block_254: {
                            break :block_254 value_23;
                        } + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, });
                    };

                    break :block_289 value_24;
                });

                break :block_290 value_25;
            };
        }

        break :block_299 block_298: {
            break :block_298 (if (((state_223).zx_origin != null)) ((state_223).zx_origin.?).* else block_297: {
                break :block_297 (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = (if ((((state_223).dependencies).zx_origin != null)) ((state_223).dependencies).zx_origin.? else block_292: {
                    const operand_291 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                    (operand_291).* = (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_223).dependencies).is_native, .keys = ((state_223).dependencies).keys, };

                    break :block_292 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_291);
                }), .found = (state_223).found, .index = (state_223).index, .module = (state_223).module, .modules = (if ((((state_223).modules).zx_origin != null)) ((state_223).modules).zx_origin.? else block_294: {
                    const operand_293 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                    (operand_293).* = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_223).modules).identities, .import_names = ((state_223).modules).import_names, .specifiers = ((state_223).modules).specifiers, .type_ids = ((state_223).modules).type_ids, .type_names = ((state_223).modules).type_names, .type_namespaces = ((state_223).modules).type_namespaces, };

                    break :block_294 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_293);
                }), .natives = (state_223).natives, .plan = (state_223).plan, .request = (if ((((state_223).request).zx_origin != null)) ((state_223).request).zx_origin.? else block_296: {
                    const operand_295 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_295).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_223).request).maximum_count, .names = ((state_223).request).names, .origins = ((state_223).request).origins, .roots = ((state_223).request).roots, .scalar_count = ((state_223).request).scalar_count, .table = ((state_223).request).table, };

                    break :block_296 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_295);
                }), };
            });
        };
    };

    return block_222: {
        const operand_220 = ((&value_26)).plan;
        const operand_221 = ((&value_26)).natives;

        break :block_222 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_220, .natives = operand_221, };
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

    const value_26: *const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = block_398: {
        const operand_317 = block_316: {
            const operand_306 = (in).request;
            const operand_307 = (in).state;
            const operand_308 = (in).modules;
            const operand_309 = (in).natives;
            const operand_310 = (in).dependencies;
            const operand_311 = @as(u64, 0);
            const operand_312 = @as(u64, 0);
            const operand_313 = false;

            break :block_316 block_315: {
                const operand_314 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

                (operand_314).* = @as((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .request = operand_306, .plan = operand_307, .modules = operand_308, .natives = operand_309, .dependencies = operand_310, .index = operand_311, .module = operand_312, .found = operand_313, });

                break :block_315 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_314);
            };
        };

        const state_type_322 = struct {
            is_native: []const bool,
            keys: []const []const u8,
        };
        const state_type_323 = struct {
            identities: []const ?[]const u8,
            import_names: []const []const u8,
            specifiers: []const []const u8,
            type_ids: []const []const u32,
            type_names: []const []const []const u8,
            type_namespaces: []const []const []const u8,
        };

        const state_type_324 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
        };
        const state_type_325 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_326 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_327 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_328 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_326,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_327,
        };
        const state_type_329 = struct {
            dependencies: state_type_322,
            found: bool,
            index: u64,
            module: u64,
            modules: state_type_323,
            natives: state_type_324,
            plan: state_type_325,
            request: state_type_328,
        };

        const state_type_341 = struct {
            index: u64,
            modules: state_type_323,
        };
        const state_type_359 = struct {
            index: u64,
            modules: state_type_323,
            natives: state_type_324,
            request: state_type_328,
            state: state_type_325,
        };
        const state_type_376 = struct {
            natives: state_type_324,
            state: state_type_325,
        };

        var state_305: state_type_329 = state_type_329{ .dependencies = state_type_322{ .is_native = ((operand_317).dependencies).is_native, .keys = ((operand_317).dependencies).keys, }, .found = (operand_317).found, .index = (operand_317).index, .module = (operand_317).module, .modules = state_type_323{ .identities = ((operand_317).modules).identities, .import_names = ((operand_317).modules).import_names, .specifiers = ((operand_317).modules).specifiers, .type_ids = ((operand_317).modules).type_ids, .type_names = ((operand_317).modules).type_names, .type_namespaces = ((operand_317).modules).type_namespaces, }, .natives = state_type_324{ .count = ((operand_317).natives).count, .mapping = ((operand_317).natives).mapping, .order = ((operand_317).natives).order, }, .plan = state_type_325{ .count = ((operand_317).plan).count, .mapping = ((operand_317).plan).mapping, .order = ((operand_317).plan).order, .origins = ((operand_317).plan).origins, .status = ((operand_317).plan).status, }, .request = state_type_328{ .maximum_count = ((operand_317).request).maximum_count, .names = ((operand_317).request).names, .origins = state_type_326{ .ids = (((operand_317).request).origins).ids, .kinds = (((operand_317).request).origins).kinds, .members = (((operand_317).request).origins).members, .owners = (((operand_317).request).origins).owners, }, .roots = ((operand_317).request).roots, .scalar_count = ((operand_317).request).scalar_count, .table = state_type_327{ .children = (((operand_317).request).table).children, .field_names = (((operand_317).request).table).field_names, .field_types = (((operand_317).request).table).field_types, .first = (((operand_317).request).table).first, .kinds = (((operand_317).request).table).kinds, .labels = (((operand_317).request).table).labels, .names = (((operand_317).request).table).names, .second = (((operand_317).request).table).second, }, }, };
        var state_changed_318 = false;

        while (((((state_305).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and ((state_305).index < @as(u64, (((state_305).dependencies).is_native).len)))) {
            state_305 = block_380: {
                const value_25: state_type_329 = (if (((!block_321: {
                    const operand_319 = ((state_305).dependencies).is_native;
                    const operand_320 = (state_305).index;

                    if ((operand_320 >= (operand_319).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_321 (operand_319)[@intCast(operand_320)];
                }) or ((state_305).module >= @as(u64, (((state_305).modules).specifiers).len)))) block_339: {
                    const value_6: state_type_329 = (if ((block_335: {
                        const operand_333 = ((state_305).dependencies).is_native;
                        const operand_334 = (state_305).index;

                        if ((operand_334 >= (operand_333).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_335 (operand_333)[@intCast(operand_334)];
                    } and (!(state_305).found))) block_338: {
                        const value_3: state_type_329 = state_305;
                        const value_4: state_type_325 = (value_3).plan;

                        const value_5: state_type_329 = block_337: {
                            break :block_337 state_type_329{ .dependencies = (value_3).dependencies, .found = (value_3).found, .index = (value_3).index, .module = (value_3).module, .modules = (value_3).modules, .natives = (value_3).natives, .plan = block_336: {
                                break :block_336 state_type_325{ .count = (value_4).count, .mapping = (value_4).mapping, .order = (value_4).order, .origins = (value_4).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), };
                            }, .request = (value_3).request, };
                        };

                        break :block_338 value_5;
                    } else state_305);

                    const value_7: state_type_329 = value_6;
                    const value_8: u64 = (value_7).index;

                    const value_9: state_type_329 = block_332: {
                        break :block_332 state_type_329{ .dependencies = (value_7).dependencies, .found = (value_7).found, .index = (value_8 + @as(u64, 1)), .module = (value_7).module, .modules = (value_7).modules, .natives = (value_7).natives, .plan = (value_7).plan, .request = (value_7).request, };
                    };
                    const value_10: state_type_329 = value_9;

                    const value_11: state_type_329 = block_331: {
                        break :block_331 state_type_329{ .dependencies = (value_10).dependencies, .found = (value_10).found, .index = (value_10).index, .module = @as(u64, 0), .modules = (value_10).modules, .natives = (value_10).natives, .plan = (value_10).plan, .request = (value_10).request, };
                    };
                    const value_12: state_type_329 = value_11;

                    const value_13: state_type_329 = block_330: {
                        break :block_330 state_type_329{ .dependencies = (value_12).dependencies, .found = false, .index = (value_12).index, .module = (value_12).module, .modules = (value_12).modules, .natives = (value_12).natives, .plan = (value_12).plan, .request = (value_12).request, };
                    };

                    break :block_339 value_13;
                } else block_379: {
                    const value_21: state_type_329 = (if (block_355: {
                        const operand_353 = block_349: {
                            const operand_345 = block_344: {
                                const operand_342 = (state_305).modules;
                                const operand_343 = (state_305).module;

                                break :block_344 state_type_341{ .modules = operand_342, .index = operand_343, };
                            };

                            const operand_346 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_345).modules).identities, .import_names = ((operand_345).modules).import_names, .specifiers = ((operand_345).modules).specifiers, .type_ids = ((operand_345).modules).type_ids, .type_names = ((operand_345).modules).type_names, .type_namespaces = ((operand_345).modules).type_namespaces, };
                            const operand_347 = (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c{ .index = (operand_345).index, .modules = (&operand_346), };
                            const operand_348 = (try (@import("zxc_module_570681fd2bde59220ceee9e44b576e3307692b3d1adb4ef22077e0de04ab73fe")).call(allocator, (&operand_347)));

                            break :block_349 operand_348;
                        };
                        const operand_354 = block_352: {
                            const operand_350 = ((state_305).dependencies).keys;
                            const operand_351 = (state_305).index;

                            if ((operand_351 >= (operand_350).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_352 (operand_350)[@intCast(operand_351)];
                        };

                        break :block_355 ((std).mem).eql(u8, operand_353, operand_354);
                    }) block_378: {
                        const value_14: state_type_376 = block_377: {
                            const operand_366 = block_365: {
                                const operand_360 = (state_305).request;
                                const operand_361 = (state_305).plan;
                                const operand_362 = (state_305).modules;
                                const operand_363 = (state_305).natives;
                                const operand_364 = (state_305).module;

                                break :block_365 state_type_359{ .request = operand_360, .state = operand_361, .modules = operand_362, .natives = operand_363, .index = operand_364, };
                            };

                            const operand_367 = (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((operand_366).modules).identities, .import_names = ((operand_366).modules).import_names, .specifiers = ((operand_366).modules).specifiers, .type_ids = ((operand_366).modules).type_ids, .type_names = ((operand_366).modules).type_names, .type_namespaces = ((operand_366).modules).type_namespaces, };
                            const operand_368 = (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((operand_366).natives).count, .mapping = ((operand_366).natives).mapping, .order = ((operand_366).natives).order, };
                            const operand_369 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((operand_366).request).origins).ids, .kinds = (((operand_366).request).origins).kinds, .members = (((operand_366).request).origins).members, .owners = (((operand_366).request).origins).owners, };
                            const operand_370 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((operand_366).request).table).children, .field_names = (((operand_366).request).table).field_names, .field_types = (((operand_366).request).table).field_types, .first = (((operand_366).request).table).first, .kinds = (((operand_366).request).table).kinds, .labels = (((operand_366).request).table).labels, .names = (((operand_366).request).table).names, .second = (((operand_366).request).table).second, };
                            const operand_371 = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((operand_366).request).maximum_count, .names = ((operand_366).request).names, .origins = (&operand_369), .roots = ((operand_366).request).roots, .scalar_count = ((operand_366).request).scalar_count, .table = (&operand_370), };
                            const operand_372 = (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((operand_366).state).count, .mapping = ((operand_366).state).mapping, .order = ((operand_366).state).order, .origins = ((operand_366).state).origins, .status = ((operand_366).state).status, };
                            const operand_373 = (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .index = (operand_366).index, .modules = (&operand_367), .natives = (&operand_368), .request = (&operand_371), .state = (&operand_372), };

                            const operand_375 = block_374: {
                                break :block_374 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, (&operand_373), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
                            };

                            break :block_377 state_type_376{ .natives = state_type_324{ .count = ((operand_375).natives).count, .mapping = ((operand_375).natives).mapping, .order = ((operand_375).natives).order, }, .state = state_type_325{ .count = ((operand_375).state).count, .mapping = ((operand_375).state).mapping, .order = ((operand_375).state).order, .origins = ((operand_375).state).origins, .status = ((operand_375).state).status, }, };
                        };
                        const value_15: state_type_329 = state_305;

                        const value_16: state_type_329 = block_358: {
                            break :block_358 state_type_329{ .dependencies = (value_15).dependencies, .found = (value_15).found, .index = (value_15).index, .module = (value_15).module, .modules = (value_15).modules, .natives = (value_15).natives, .plan = (value_14).state, .request = (value_15).request, };
                        };
                        const value_17: state_type_329 = value_16;

                        const value_18: state_type_329 = block_357: {
                            break :block_357 state_type_329{ .dependencies = (value_17).dependencies, .found = (value_17).found, .index = (value_17).index, .module = (value_17).module, .modules = (value_17).modules, .natives = (value_14).natives, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_19: state_type_329 = value_18;
                        const value_20: state_type_329 = block_356: {
                            break :block_356 state_type_329{ .dependencies = (value_19).dependencies, .found = true, .index = (value_19).index, .module = (value_19).module, .modules = (value_19).modules, .natives = (value_19).natives, .plan = (value_19).plan, .request = (value_19).request, };
                        };

                        break :block_378 value_20;
                    } else state_305);

                    const value_22: state_type_329 = value_21;
                    const value_23: u64 = (value_22).module;

                    const value_24: state_type_329 = block_340: {
                        break :block_340 state_type_329{ .dependencies = (value_22).dependencies, .found = (value_22).found, .index = (value_22).index, .module = (value_23 + @as(u64, 1)), .modules = (value_22).modules, .natives = (value_22).natives, .plan = (value_22).plan, .request = (value_22).request, };
                    };

                    break :block_379 value_24;
                });

                break :block_380 value_25;
            };

            state_changed_318 = true;
        }

        break :block_398 (if (state_changed_318) block_397: {
            const operand_396 = (try (allocator).create((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356));

            (operand_396).* = @as((zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356{ .dependencies = block_383: {
                const operand_382 = (try (allocator).create((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2));

                (operand_382).* = @as((zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2{ .is_native = ((state_305).dependencies).is_native, .keys = ((state_305).dependencies).keys, });

                break :block_383 @as(*const (zx_abi).zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2, operand_382);
            }, .found = (state_305).found, .index = (state_305).index, .module = (state_305).module, .modules = block_385: {
                const operand_384 = (try (allocator).create((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960));

                (operand_384).* = @as((zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960{ .identities = ((state_305).modules).identities, .import_names = ((state_305).modules).import_names, .specifiers = ((state_305).modules).specifiers, .type_ids = ((state_305).modules).type_ids, .type_names = ((state_305).modules).type_names, .type_namespaces = ((state_305).modules).type_namespaces, });

                break :block_385 @as(*const (zx_abi).zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960, operand_384);
            }, .natives = block_387: {
                const operand_386 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

                (operand_386).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .count = ((state_305).natives).count, .mapping = ((state_305).natives).mapping, .order = ((state_305).natives).order, });

                break :block_387 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_386);
            }, .plan = block_389: {
                const operand_388 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_388).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_305).plan).count, .mapping = ((state_305).plan).mapping, .order = ((state_305).plan).order, .origins = ((state_305).plan).origins, .status = ((state_305).plan).status, });

                break :block_389 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_388);
            }, .request = block_395: {
                const operand_394 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_394).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_305).request).maximum_count, .names = ((state_305).request).names, .origins = block_391: {
                    const operand_390 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_390).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_305).request).origins).ids, .kinds = (((state_305).request).origins).kinds, .members = (((state_305).request).origins).members, .owners = (((state_305).request).origins).owners, });

                    break :block_391 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_390);
                }, .roots = ((state_305).request).roots, .scalar_count = ((state_305).request).scalar_count, .table = block_393: {
                    const operand_392 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_392).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_305).request).table).children, .field_names = (((state_305).request).table).field_names, .field_types = (((state_305).request).table).field_types, .first = (((state_305).request).table).first, .kinds = (((state_305).request).table).kinds, .labels = (((state_305).request).table).labels, .names = (((state_305).request).table).names, .second = (((state_305).request).table).second, });

                    break :block_393 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_392);
                }, });

                break :block_395 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_394);
            }, });

            break :block_397 @as(*const (zx_abi).zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356, operand_396);
        } else operand_317);
    };

    return block_304: {
        const operand_300 = (value_26).plan;
        const operand_301 = (value_26).natives;

        break :block_304 block_303: {
            const operand_302 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_302).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_300, .natives = operand_301, });

            break :block_303 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_302);
        };
    };
}

