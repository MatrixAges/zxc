const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_150: {
        const operand_149 = (in).index;

        break :block_150 (try (allocator).dupe(u64, (&[_]u64{operand_149, })));
    };

    const value_2: []const bool = block_148: {
        const operand_147 = false;

        break :block_148 (try (allocator).dupe(bool, (&[_]bool{operand_147, })));
    };

    const value_55: *const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_146: {
        const operand_13 = block_12: {
            const operand_2 = (in).request;
            const operand_3 = (in).state;

            const operand_4 = block_9: {
                const operand_5 = value_1;
                const operand_6 = value_2;

                break :block_9 block_8: {
                    const operand_7 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_7).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_5, .ready = operand_6, });

                    break :block_8 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_7);
                };
            };

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_10).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_2, .plan = operand_3, .pending = operand_4, });

                break :block_11 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_10);
            };
        };

        var state_capacity_15: (std).ArrayList(u64) = .empty;
        var state_capacity_started_16 = false;

        defer (state_capacity_15).deinit(allocator);

        var state_capacity_17: (std).ArrayList(bool) = .empty;
        var state_capacity_started_18 = false;

        defer (state_capacity_17).deinit(allocator);

        var state_items_19: []u64 = undefined;
        var state_items_started_20 = false;
        var state_items_21: []u32 = undefined;
        var state_items_started_22 = false;
        var state_items_23: []u64 = undefined;
        var state_items_started_24 = false;

        const state_type_28 = struct {
            ids: []const u64,
            ready: []const bool,
        };
        const state_type_29 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_30 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_31 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_32 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_30,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_31,
        };
        const state_type_33 = struct {
            pending: state_type_28,
            plan: state_type_29,
            request: state_type_32,
        };
        const state_type_34 = struct {
            index: u64,
            pending: state_type_28,
            table: state_type_31,
        };

        const state_type_50 = struct { []const bool, void, };
        const state_type_56 = struct { []const u64, void, };

        const state_type_78 = struct {
            index: u64,
            name: []const u8,
            names: []const []const u8,
            origins: state_type_30,
        };
        const state_type_114 = struct { []const bool, ?bool, };
        const state_type_119 = struct { []const u64, ?u64, };
        var state_1: state_type_33 = state_type_33{ .pending = state_type_28{ .ids = ((operand_13).pending).ids, .ready = ((operand_13).pending).ready, }, .plan = state_type_29{ .count = ((operand_13).plan).count, .mapping = ((operand_13).plan).mapping, .order = ((operand_13).plan).order, .origins = ((operand_13).plan).origins, .status = ((operand_13).plan).status, }, .request = state_type_32{ .maximum_count = ((operand_13).request).maximum_count, .names = ((operand_13).request).names, .origins = state_type_30{ .ids = (((operand_13).request).origins).ids, .kinds = (((operand_13).request).origins).kinds, .members = (((operand_13).request).origins).members, .owners = (((operand_13).request).origins).owners, }, .roots = ((operand_13).request).roots, .scalar_count = ((operand_13).request).scalar_count, .table = state_type_31{ .children = (((operand_13).request).table).children, .field_names = (((operand_13).request).table).field_names, .field_types = (((operand_13).request).table).field_types, .first = (((operand_13).request).table).first, .kinds = (((operand_13).request).table).kinds, .labels = (((operand_13).request).table).labels, .names = (((operand_13).request).table).names, .second = (((operand_13).request).table).second, }, }, };
        var state_changed_14 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_1).pending).ids).len) > @as(u64, 0)))) {
            state_1 = block_130: {
                const value_5: u64 = (@as(u64, (((state_1).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_129: {
                    const operand_127 = ((state_1).pending).ids;
                    const operand_128 = value_5;

                    if ((operand_128 >= (operand_127).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_129 (operand_127)[@intCast(operand_128)];
                };
                const value_7: bool = block_126: {
                    const operand_124 = ((state_1).pending).ready;
                    const operand_125 = value_5;

                    if ((operand_125 >= (operand_124).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_126 (operand_124)[@intCast(operand_125)];
                };
                const value_8: state_type_33 = state_1;
                const value_9: state_type_28 = (value_8).pending;

                const value_10: state_type_33 = block_123: {
                    break :block_123 state_type_33{ .pending = block_122: {
                        break :block_122 state_type_28{ .ids = (block_121: {
                            const operand_120 = ((state_1).pending).ids;

                            break :block_121 @as(state_type_119, (if (((operand_120).len == 0)) .{ operand_120, null, } else .{ (operand_120)[0..((operand_120).len - 1)], (operand_120)[((operand_120).len - 1)], }));
                        }).@"0", .ready = (value_9).ready, };
                    }, .plan = (value_8).plan, .request = (value_8).request, };
                };
                const value_11: state_type_33 = value_10;
                const value_12: state_type_28 = (value_11).pending;

                const value_13: state_type_33 = block_118: {
                    break :block_118 state_type_33{ .pending = block_117: {
                        break :block_117 state_type_28{ .ids = (value_12).ids, .ready = (block_116: {
                            const operand_115 = ((value_10).pending).ready;

                            break :block_116 @as(state_type_114, (if (((operand_115).len == 0)) .{ operand_115, null, } else .{ (operand_115)[0..((operand_115).len - 1)], (operand_115)[((operand_115).len - 1)], }));
                        }).@"0", };
                    }, .plan = (value_11).plan, .request = (value_11).request, };
                };
                const value_54: state_type_33 = (if ((block_27: {
                    const operand_25 = ((value_13).plan).mapping;
                    const operand_26 = value_6;

                    if ((operand_26 >= (operand_25).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_27 (operand_25)[@intCast(operand_26)];
                } == @as(u64, 0))) block_113: {
                    const value_53: state_type_33 = (if ((!value_7)) block_62: {
                        const value_14: state_type_33 = value_13;
                        const value_15: state_type_28 = (value_14).pending;
                        const value_16: state_type_33 = block_61: {
                            break :block_61 state_type_33{ .pending = block_60: {
                                break :block_60 state_type_28{ .ids = (block_59: {
                                    const operand_57 = ((value_13).pending).ids;
                                    const operand_58 = value_6;

                                    _ = (try ((std).math).add(usize, (operand_57).len, 1));

                                    if ((!state_capacity_started_16)) {
                                        (try (state_capacity_15).appendSlice(allocator, operand_57));
                                        state_capacity_started_16 = true;
                                    } else {
                                        ((state_capacity_15).items).len = (operand_57).len;
                                    }

                                    (try (state_capacity_15).append(allocator, operand_58));

                                    break :block_59 @as(state_type_56, .{ (state_capacity_15).items, {}, });
                                }).@"0", .ready = (value_15).ready, };
                            }, .plan = (value_14).plan, .request = (value_14).request, };
                        };
                        const value_17: state_type_33 = value_16;
                        const value_18: state_type_28 = (value_17).pending;
                        const value_19: state_type_33 = block_55: {
                            break :block_55 state_type_33{ .pending = block_54: {
                                break :block_54 state_type_28{ .ids = (value_18).ids, .ready = (block_53: {
                                    const operand_51 = ((value_16).pending).ready;
                                    const operand_52 = true;

                                    _ = (try ((std).math).add(usize, (operand_51).len, 1));

                                    if ((!state_capacity_started_18)) {
                                        (try (state_capacity_17).appendSlice(allocator, operand_51));

                                        state_capacity_started_18 = true;
                                    } else {
                                        ((state_capacity_17).items).len = (operand_51).len;
                                    }

                                    (try (state_capacity_17).append(allocator, operand_52));

                                    break :block_53 @as(state_type_50, .{ (state_capacity_17).items, {}, });
                                }).@"0", };
                            }, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_20: state_type_33 = value_19;
                        const value_21: state_type_33 = block_49: {
                            break :block_49 state_type_33{ .pending = block_48: {
                                const operand_39 = block_38: {
                                    const operand_35 = ((value_19).request).table;
                                    const operand_36 = value_6;
                                    const operand_37 = (value_19).pending;

                                    break :block_38 state_type_34{ .table = operand_35, .index = operand_36, .pending = operand_37, };
                                };

                                const operand_40 = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((operand_39).pending).ids, .ready = ((operand_39).pending).ready, };
                                const operand_41 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = ((operand_39).table).children, .field_names = ((operand_39).table).field_names, .field_types = ((operand_39).table).field_types, .first = ((operand_39).table).first, .kinds = ((operand_39).table).kinds, .labels = ((operand_39).table).labels, .names = ((operand_39).table).names, .second = ((operand_39).table).second, };
                                const operand_42 = (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a{ .index = (operand_39).index, .pending = (&operand_40), .table = (&operand_41), };

                                const operand_47 = block_46: {
                                    const operand_43 = (&operand_42);
                                    const operand_44 = (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_43).index, .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_43).pending).ids, .ready = ((operand_43).pending).ready, .zx_origin = (operand_43).pending, }, .table = (operand_43).table, .zx_origin = operand_43, }, .{ .lane_0 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, .lane_1 = .{ .buffer = (&state_capacity_17), .started = (&state_capacity_started_18), }, }));

                                    break :block_46 (if (((operand_44).zx_origin != null)) ((operand_44).zx_origin.?).* else block_45: {
                                        break :block_45 (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = (operand_44).ids, .ready = (operand_44).ready, };
                                    });
                                };

                                break :block_48 state_type_28{ .ids = (operand_47).ids, .ready = (operand_47).ready, };
                            }, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_62 value_21;
                    } else block_112: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: state_type_33 = value_13;
                        const value_24: state_type_29 = (value_23).plan;
                        const value_25: []const u64 = (value_24).mapping;
                        const value_26: u64 = value_6;
                        const value_27: state_type_33 = block_111: {
                            break :block_111 state_type_33{ .pending = (value_23).pending, .plan = block_110: {
                                break :block_110 state_type_29{ .count = (value_24).count, .mapping = block_109: {
                                    const operand_105 = value_25;
                                    const operand_106 = value_26;

                                    if ((operand_106 >= (operand_105).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_107 = (value_22 + @as(u64, 1));

                                    break :block_109 block_108: {
                                        if ((!state_items_started_20)) {
                                            state_items_19 = (try (allocator).dupe(u64, operand_105));
                                            state_items_started_20 = true;
                                        }

                                        (state_items_19)[@intCast(operand_106)] = operand_107;

                                        break :block_108 state_items_19;
                                    };
                                }, .order = (value_24).order, .origins = (value_24).origins, .status = (value_24).status, };
                            }, .request = (value_23).request, };
                        };
                        const value_28: state_type_33 = value_27;
                        const value_29: state_type_29 = (value_28).plan;
                        const value_30: []const u32 = (value_29).order;
                        const value_31: u64 = value_22;
                        const value_32: state_type_33 = block_104: {
                            break :block_104 state_type_33{ .pending = (value_28).pending, .plan = block_103: {
                                break :block_103 state_type_29{ .count = (value_29).count, .mapping = (value_29).mapping, .order = block_102: {
                                    const operand_98 = value_30;
                                    const operand_99 = value_31;

                                    if ((operand_99 >= (operand_98).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_100 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, value_6));

                                    break :block_102 block_101: {
                                        if ((!state_items_started_22)) {
                                            state_items_21 = (try (allocator).dupe(u32, operand_98));
                                            state_items_started_22 = true;
                                        }

                                        (state_items_21)[@intCast(operand_99)] = operand_100;

                                        break :block_101 state_items_21;
                                    };
                                }, .origins = (value_29).origins, .status = (value_29).status, };
                            }, .request = (value_28).request, };
                        };
                        const value_33: state_type_33 = value_32;
                        const value_34: state_type_29 = (value_33).plan;
                        const value_35: u64 = (value_34).count;

                        const value_36: state_type_33 = block_97: {
                            break :block_97 state_type_33{ .pending = (value_33).pending, .plan = block_96: {
                                break :block_96 state_type_29{ .count = (value_35 + @as(u64, 1)), .mapping = (value_34).mapping, .order = (value_34).order, .origins = (value_34).origins, .status = (value_34).status, };
                            }, .request = (value_33).request, };
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_95: {
                            const operand_93 = (((value_36).request).table).kinds;
                            const operand_94 = value_6;

                            if ((operand_94 >= (operand_93).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_95 (operand_93)[@intCast(operand_94)];
                        }));

                        const value_52: state_type_33 = (if (((value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_92: {
                            const value_38: u64 = block_91: {
                                const operand_87 = block_86: {
                                    const operand_79 = ((value_36).request).origins;
                                    const operand_80 = ((value_36).request).names;
                                    const operand_81 = value_6;
                                    const operand_85 = block_84: {
                                        const operand_82 = (((value_36).request).table).labels;
                                        const operand_83 = value_6;

                                        if ((operand_83 >= (operand_82).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_84 (operand_82)[@intCast(operand_83)];
                                    };

                                    break :block_86 state_type_78{ .origins = operand_79, .names = operand_80, .index = operand_81, .name = operand_85, };
                                };

                                const operand_88 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = ((operand_87).origins).ids, .kinds = ((operand_87).origins).kinds, .members = ((operand_87).origins).members, .owners = ((operand_87).origins).owners, };
                                const operand_89 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .index = (operand_87).index, .name = (operand_87).name, .names = (operand_87).names, .origins = (&operand_88), };
                                const operand_90 = (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_89)));

                                break :block_91 operand_90;
                            };
                            const value_51: state_type_33 = (if ((value_38 == @as(u64, 0))) block_65: {
                                const value_39: state_type_33 = value_36;
                                const value_40: state_type_29 = (value_39).plan;

                                const value_41: state_type_33 = block_64: {
                                    break :block_64 state_type_33{ .pending = (value_39).pending, .plan = block_63: {
                                        break :block_63 state_type_29{ .count = (value_40).count, .mapping = (value_40).mapping, .order = (value_40).order, .origins = (value_40).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), };
                                    }, .request = (value_39).request, };
                                };

                                break :block_65 value_41;
                            } else block_77: {
                                const value_50: state_type_33 = (if ((value_38 == @as(u64, 1))) block_68: {
                                    const value_42: state_type_33 = value_36;
                                    const value_43: state_type_29 = (value_42).plan;
                                    const value_44: state_type_33 = block_67: {
                                        break :block_67 state_type_33{ .pending = (value_42).pending, .plan = block_66: {
                                            break :block_66 state_type_29{ .count = (value_43).count, .mapping = (value_43).mapping, .order = (value_43).order, .origins = (value_43).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), };
                                        }, .request = (value_42).request, };
                                    };

                                    break :block_68 value_44;
                                } else block_76: {
                                    const value_45: state_type_33 = value_36;
                                    const value_46: state_type_29 = (value_45).plan;
                                    const value_47: []const u64 = (value_46).origins;
                                    const value_48: u64 = value_22;
                                    const value_49: state_type_33 = block_75: {
                                        break :block_75 state_type_33{ .pending = (value_45).pending, .plan = block_74: {
                                            break :block_74 state_type_29{ .count = (value_46).count, .mapping = (value_46).mapping, .order = (value_46).order, .origins = block_73: {
                                                const operand_69 = value_47;
                                                const operand_70 = value_48;

                                                if ((operand_70 >= (operand_69).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_71 = (value_38 - @as(u64, 1));

                                                break :block_73 block_72: {
                                                    if ((!state_items_started_24)) {
                                                        state_items_23 = (try (allocator).dupe(u64, operand_69));
                                                        state_items_started_24 = true;
                                                    }

                                                    (state_items_23)[@intCast(operand_70)] = operand_71;

                                                    break :block_72 state_items_23;
                                                };
                                            }, .status = (value_46).status, };
                                        }, .request = (value_45).request, };
                                    };

                                    break :block_76 value_49;
                                });

                                break :block_77 value_50;
                            });

                            break :block_92 value_51;
                        } else value_36);

                        break :block_112 value_52;
                    });

                    break :block_113 value_53;
                } else value_13);

                break :block_130 value_54;
            };

            state_changed_14 = true;
        }

        var state_owned_131: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_131);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).pending).ids).len;
            state_owned_131 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            ((state_1).pending).ids = state_owned_131;
        }

        var state_owned_132: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_132);

        if (state_capacity_started_18) {
            ((state_capacity_17).items).len = (((state_1).pending).ready).len;
            state_owned_132 = (try (state_capacity_17).toOwnedSlice(allocator));
        }

        if (state_capacity_started_18) {
            ((state_1).pending).ready = state_owned_132;
        }

        break :block_146 (if (state_changed_14) block_145: {
            const operand_144 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

            (operand_144).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = block_135: {
                const operand_134 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_134).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_1).pending).ids, .ready = ((state_1).pending).ready, });

                break :block_135 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_134);
            }, .plan = block_137: {
                const operand_136 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_136).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_1).plan).count, .mapping = ((state_1).plan).mapping, .order = ((state_1).plan).order, .origins = ((state_1).plan).origins, .status = ((state_1).plan).status, });

                break :block_137 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_136);
            }, .request = block_143: {
                const operand_142 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_142).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = block_139: {
                    const operand_138 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_138).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_1).request).origins).ids, .kinds = (((state_1).request).origins).kinds, .members = (((state_1).request).origins).members, .owners = (((state_1).request).origins).owners, });

                    break :block_139 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_138);
                }, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = block_141: {
                    const operand_140 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_140).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_1).request).table).children, .field_names = (((state_1).request).table).field_names, .field_types = (((state_1).request).table).field_types, .first = (((state_1).request).table).first, .kinds = (((state_1).request).table).kinds, .labels = (((state_1).request).table).labels, .names = (((state_1).request).table).names, .second = (((state_1).request).table).second, });

                    break :block_141 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_140);
                }, });

                break :block_143 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_142);
            }, });

            break :block_145 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_144);
        } else operand_13);
    };

    return (value_55).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_335: {
        const operand_334 = (in).index;

        break :block_335 (try (allocator).dupe(u64, (&[_]u64{operand_334, })));
    };

    const value_2: []const bool = block_333: {
        const operand_332 = false;

        break :block_333 (try (allocator).dupe(bool, (&[_]bool{operand_332, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_331: {
        const operand_161 = block_160: {
            const operand_152 = (in).request;
            const operand_153 = (in).state;

            const operand_154 = block_159: {
                const operand_155 = value_1;
                const operand_156 = value_2;

                break :block_159 block_158: {
                    const operand_157 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_157).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_155, .ready = operand_156, });

                    break :block_158 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_157);
                };
            };

            break :block_160 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_152, .plan = operand_153, .pending = operand_154, };
        };

        var state_capacity_162: (std).ArrayList(u64) = .empty;
        var state_capacity_started_163 = false;

        defer (state_capacity_162).deinit(allocator);

        var state_capacity_164: (std).ArrayList(bool) = .empty;
        var state_capacity_started_165 = false;

        defer (state_capacity_164).deinit(allocator);

        var state_items_166: []u64 = undefined;
        var state_items_started_167 = false;
        var state_items_168: []u32 = undefined;
        var state_items_started_169 = false;
        var state_items_170: []u64 = undefined;
        var state_items_started_171 = false;
        var state_151: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_161).pending).ids, .ready = ((operand_161).pending).ready, .zx_origin = (operand_161).pending, }, .plan = (operand_161).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_161).request).maximum_count, .names = ((operand_161).request).names, .origins = ((operand_161).request).origins, .roots = ((operand_161).request).roots, .scalar_count = ((operand_161).request).scalar_count, .table = ((operand_161).request).table, .zx_origin = (operand_161).request, }, .zx_origin = (&operand_161), };

        while (((((state_151).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_151).pending).ids).len) > @as(u64, 0)))) {
            state_151 = block_322: {
                const value_5: u64 = (@as(u64, (((state_151).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_321: {
                    const operand_319 = ((state_151).pending).ids;

                    const operand_320 = block_318: {
                        break :block_318 value_5;
                    };

                    if ((operand_320 >= (operand_319).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_321 (operand_319)[@intCast(operand_320)];
                };
                const value_7: bool = block_317: {
                    const operand_315 = ((state_151).pending).ready;

                    const operand_316 = block_314: {
                        break :block_314 value_5;
                    };

                    if ((operand_316 >= (operand_315).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_317 (operand_315)[@intCast(operand_316)];
                };
                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_151;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_313: {
                    break :block_313 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_312: {
                        break :block_312 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_311: {
                            const operand_310 = ((state_151).pending).ids;

                            break :block_311 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_310).len == 0)) .{ operand_310, null, null, } else .{ (operand_310)[0..((operand_310).len - 1)], (operand_310)[((operand_310).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_309: {
                    break :block_309 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_308: {
                        break :block_308 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_307: {
                            const operand_306 = ((value_10).pending).ready;

                            break :block_307 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_306).len == 0)) .{ operand_306, null, null, } else .{ (operand_306)[0..((operand_306).len - 1)], (operand_306)[((operand_306).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_175: {
                    const operand_173 = ((value_13).plan).mapping;

                    const operand_174 = block_172: {
                        break :block_172 value_6;
                    };

                    if ((operand_174 >= (operand_173).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_175 (operand_173)[@intCast(operand_174)];
                } == @as(u64, 0))) block_305: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_176: {
                        break :block_176 value_7;
                    })) block_195: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_194: {
                            break :block_194 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_193: {
                                break :block_193 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_192: {
                                    const operand_189 = ((value_13).pending).ids;

                                    const operand_191 = block_190: {
                                        break :block_190 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_189).len, 1));

                                    if ((!state_capacity_started_163)) {
                                        (try (state_capacity_162).appendSlice(allocator, operand_189));

                                        state_capacity_started_163 = true;
                                    } else {
                                        ((state_capacity_162).items).len = (operand_189).len;
                                    }

                                    (try (state_capacity_162).append(allocator, operand_191));

                                    break :block_192 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_162).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_188: {
                            break :block_188 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_187: {
                                break :block_187 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_186: {
                                    const operand_184 = ((value_16).pending).ready;
                                    const operand_185 = true;

                                    _ = (try ((std).math).add(usize, (operand_184).len, 1));

                                    if ((!state_capacity_started_165)) {
                                        (try (state_capacity_164).appendSlice(allocator, operand_184));

                                        state_capacity_started_165 = true;
                                    } else {
                                        ((state_capacity_164).items).len = (operand_184).len;
                                    }

                                    (try (state_capacity_164).append(allocator, operand_185));

                                    break :block_186 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_164).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_183: {
                            break :block_183 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_182: {
                                break :block_182 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_181: {
                                    const operand_177 = ((value_19).request).table;

                                    const operand_178 = block_179: {
                                        break :block_179 value_6;
                                    };

                                    const operand_180 = (value_19).pending;

                                    break :block_181 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_177, .index = operand_178, .pending = operand_180, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_162), .started = (&state_capacity_started_163), }, .lane_1 = .{ .buffer = (&state_capacity_164), .started = (&state_capacity_started_165), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_195 value_21;
                    } else block_304: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_303: {
                            break :block_303 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_302: {
                            break :block_302 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_301: {
                            break :block_301 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_300: {
                                break :block_300 block_299: {
                                    const operand_298 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_298).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_286: {
                                        break :block_286 (&value_24);
                                    }).count, .mapping = block_294: {
                                        const operand_288 = block_287: {
                                            break :block_287 value_25;
                                        };
                                        const operand_290 = block_289: {
                                            break :block_289 value_26;
                                        };

                                        if ((operand_290 >= (operand_288).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_292 = (block_291: {
                                            break :block_291 value_22;
                                        } + @as(u64, 1));

                                        break :block_294 block_293: {
                                            if ((!state_items_started_167)) {
                                                state_items_166 = (try (allocator).dupe(u64, operand_288));
                                                state_items_started_167 = true;
                                            }

                                            (state_items_166)[@intCast(operand_290)] = operand_292;

                                            break :block_293 state_items_166;
                                        };
                                    }, .order = (block_295: {
                                        break :block_295 (&value_24);
                                    }).order, .origins = (block_296: {
                                        break :block_296 (&value_24);
                                    }).origins, .status = (block_297: {
                                        break :block_297 (&value_24);
                                    }).status, });

                                    break :block_299 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_298);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_285: {
                            break :block_285 (&value_29);
                        }).order;
                        const value_31: u64 = block_284: {
                            break :block_284 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_283: {
                            break :block_283 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_282: {
                                break :block_282 block_281: {
                                    const operand_280 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_280).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_266: {
                                        break :block_266 (&value_29);
                                    }).count, .mapping = (block_267: {
                                        break :block_267 (&value_29);
                                    }).mapping, .order = block_277: {
                                        const operand_269 = block_268: {
                                            break :block_268 value_30;
                                        };
                                        const operand_271 = block_270: {
                                            break :block_270 value_31;
                                        };

                                        if ((operand_271 >= (operand_269).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_275 = block_274: {
                                            const operand_273 = block_272: {
                                                break :block_272 value_6;
                                            };

                                            break :block_274 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_273));
                                        };

                                        break :block_277 block_276: {
                                            if ((!state_items_started_169)) {
                                                state_items_168 = (try (allocator).dupe(u32, operand_269));
                                                state_items_started_169 = true;
                                            }

                                            (state_items_168)[@intCast(operand_271)] = operand_275;

                                            break :block_276 state_items_168;
                                        };
                                    }, .origins = (block_278: {
                                        break :block_278 (&value_29);
                                    }).origins, .status = (block_279: {
                                        break :block_279 (&value_29);
                                    }).status, });

                                    break :block_281 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_280);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_265: {
                            break :block_265 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_264: {
                            break :block_264 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_263: {
                                break :block_263 block_262: {
                                    const operand_261 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_261).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_256: {
                                        break :block_256 value_35;
                                    } + @as(u64, 1)), .mapping = (block_257: {
                                        break :block_257 (&value_34);
                                    }).mapping, .order = (block_258: {
                                        break :block_258 (&value_34);
                                    }).order, .origins = (block_259: {
                                        break :block_259 (&value_34);
                                    }).origins, .status = (block_260: {
                                        break :block_260 (&value_34);
                                    }).status, });

                                    break :block_262 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_261);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_255: {
                            const operand_254 = block_253: {
                                const operand_251 = (((value_36).request).table).kinds;

                                const operand_252 = block_250: {
                                    break :block_250 value_6;
                                };

                                if ((operand_252 >= (operand_251).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_253 (operand_251)[@intCast(operand_252)];
                            };

                            break :block_255 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_254));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_196: {
                            break :block_196 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_197: {
                            break :block_197 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_249: {
                            const value_38: u64 = block_248: {
                                const operand_238 = ((value_36).request).origins;
                                const operand_239 = ((value_36).request).names;

                                const operand_241 = block_240: {
                                    break :block_240 value_6;
                                };
                                const operand_246 = block_245: {
                                    const operand_243 = (((value_36).request).table).labels;

                                    const operand_244 = block_242: {
                                        break :block_242 value_6;
                                    };

                                    if ((operand_244 >= (operand_243).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_245 (operand_243)[@intCast(operand_244)];
                                };

                                const operand_247 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_238, .names = operand_239, .index = operand_241, .name = operand_246, };

                                break :block_248 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_247)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_198: {
                                break :block_198 value_38;
                            } == @as(u64, 0))) block_207: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_206: {
                                    break :block_206 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_205: {
                                        break :block_205 block_204: {
                                            const operand_203 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_203).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_199: {
                                                break :block_199 (&value_40);
                                            }).count, .mapping = (block_200: {
                                                break :block_200 (&value_40);
                                            }).mapping, .order = (block_201: {
                                                break :block_201 (&value_40);
                                            }).order, .origins = (block_202: {
                                                break :block_202 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_204 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_203);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_207 value_41;
                            } else block_237: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_208: {
                                    break :block_208 value_38;
                                } == @as(u64, 1))) block_217: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_216: {
                                        break :block_216 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_215: {
                                            break :block_215 block_214: {
                                                const operand_213 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_213).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_209: {
                                                    break :block_209 (&value_43);
                                                }).count, .mapping = (block_210: {
                                                    break :block_210 (&value_43);
                                                }).mapping, .order = (block_211: {
                                                    break :block_211 (&value_43);
                                                }).order, .origins = (block_212: {
                                                    break :block_212 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_214 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_213);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_217 value_44;
                                } else block_236: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_235: {
                                        break :block_235 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_234: {
                                        break :block_234 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_233: {
                                        break :block_233 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_232: {
                                            break :block_232 block_231: {
                                                const operand_230 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_230).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_218: {
                                                    break :block_218 (&value_46);
                                                }).count, .mapping = (block_219: {
                                                    break :block_219 (&value_46);
                                                }).mapping, .order = (block_220: {
                                                    break :block_220 (&value_46);
                                                }).order, .origins = block_228: {
                                                    const operand_222 = block_221: {
                                                        break :block_221 value_47;
                                                    };
                                                    const operand_224 = block_223: {
                                                        break :block_223 value_48;
                                                    };

                                                    if ((operand_224 >= (operand_222).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_226 = (block_225: {
                                                        break :block_225 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_228 block_227: {
                                                        if ((!state_items_started_171)) {
                                                            state_items_170 = (try (allocator).dupe(u64, operand_222));
                                                            state_items_started_171 = true;
                                                        }

                                                        (state_items_170)[@intCast(operand_224)] = operand_226;

                                                        break :block_227 state_items_170;
                                                    };
                                                }, .status = (block_229: {
                                                    break :block_229 (&value_46);
                                                }).status, });

                                                break :block_231 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_230);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_236 value_49;
                                });

                                break :block_237 value_50;
                            });

                            break :block_249 value_51;
                        } else value_36);

                        break :block_304 value_52;
                    });

                    break :block_305 value_53;
                } else value_13);

                break :block_322 value_54;
            };
        }

        var state_owned_323: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_323);

        if (state_capacity_started_163) {
            ((state_capacity_162).items).len = (((state_151).pending).ids).len;
            state_owned_323 = (try (state_capacity_162).toOwnedSlice(allocator));
        }

        if (state_capacity_started_163) {
            state_151 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_323, .ready = ((state_151).pending).ready, }), .plan = (state_151).plan, .request = (state_151).request, };
        }

        var state_owned_324: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_324);

        if (state_capacity_started_165) {
            ((state_capacity_164).items).len = (((state_151).pending).ready).len;
            state_owned_324 = (try (state_capacity_164).toOwnedSlice(allocator));
        }

        if (state_capacity_started_165) {
            state_151 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_151).pending).ids, .ready = state_owned_324, }), .plan = (state_151).plan, .request = (state_151).request, };
        }

        break :block_331 block_330: {
            break :block_330 (if (((state_151).zx_origin != null)) ((state_151).zx_origin.?).* else block_329: {
                break :block_329 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_151).pending).zx_origin != null)) ((state_151).pending).zx_origin.? else block_326: {
                    const operand_325 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_325).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_151).pending).ids, .ready = ((state_151).pending).ready, };

                    break :block_326 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_325);
                }), .plan = (state_151).plan, .request = (if ((((state_151).request).zx_origin != null)) ((state_151).request).zx_origin.? else block_328: {
                    const operand_327 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_327).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_151).request).maximum_count, .names = ((state_151).request).names, .origins = ((state_151).request).origins, .roots = ((state_151).request).roots, .scalar_count = ((state_151).request).scalar_count, .table = ((state_151).request).table, };

                    break :block_328 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_327);
                }), };
            });
        };
    };

    return (((&value_55)).plan).*;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, buffers: struct {
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

    const value_1: []const u64 = block_532: {
        const operand_531 = (in).index;

        break :block_532 (try (allocator).dupe(u64, (&[_]u64{operand_531, })));
    };

    const value_2: []const bool = block_530: {
        const operand_529 = false;

        break :block_530 (try (allocator).dupe(bool, (&[_]bool{operand_529, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_528: {
        const operand_346 = block_345: {
            const operand_337 = (in).request;
            const operand_338 = (in).state;

            const operand_339 = block_344: {
                const operand_340 = value_1;
                const operand_341 = value_2;

                break :block_344 block_343: {
                    const operand_342 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_342).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_340, .ready = operand_341, });

                    break :block_343 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_342);
                };
            };

            break :block_345 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_337, .plan = operand_338, .pending = operand_339, };
        };

        var state_capacity_347: (std).ArrayList(u64) = .empty;
        var state_capacity_started_348 = false;

        defer (state_capacity_347).deinit(allocator);

        var state_capacity_349: (std).ArrayList(bool) = .empty;
        var state_capacity_started_350 = false;

        defer (state_capacity_349).deinit(allocator);

        var state_capacity_351: (std).ArrayList(u64) = .empty;
        var state_capacity_started_352 = false;

        defer (state_capacity_351).deinit(allocator);

        var state_capacity_353: (std).ArrayList(u32) = .empty;
        var state_capacity_started_354 = false;

        defer (state_capacity_353).deinit(allocator);

        var state_capacity_355: (std).ArrayList(u64) = .empty;
        var state_capacity_started_356 = false;

        defer (state_capacity_355).deinit(allocator);

        var state_336: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_346).pending).ids, .ready = ((operand_346).pending).ready, .zx_origin = (operand_346).pending, }, .plan = (operand_346).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_346).request).maximum_count, .names = ((operand_346).request).names, .origins = ((operand_346).request).origins, .roots = ((operand_346).request).roots, .scalar_count = ((operand_346).request).scalar_count, .table = ((operand_346).request).table, .zx_origin = (operand_346).request, }, .zx_origin = (&operand_346), };

        while (((((state_336).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_336).pending).ids).len) > @as(u64, 0)))) {
            state_336 = block_510: {
                const value_5: u64 = (@as(u64, (((state_336).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_509: {
                    const operand_507 = ((state_336).pending).ids;

                    const operand_508 = block_506: {
                        break :block_506 value_5;
                    };

                    if ((operand_508 >= (operand_507).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_509 (operand_507)[@intCast(operand_508)];
                };
                const value_7: bool = block_505: {
                    const operand_503 = ((state_336).pending).ready;

                    const operand_504 = block_502: {
                        break :block_502 value_5;
                    };

                    if ((operand_504 >= (operand_503).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_505 (operand_503)[@intCast(operand_504)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_336;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_501: {
                    break :block_501 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_500: {
                        break :block_500 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_499: {
                            const operand_498 = ((state_336).pending).ids;

                            break :block_499 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_498).len == 0)) .{ operand_498, null, null, } else .{ (operand_498)[0..((operand_498).len - 1)], (operand_498)[((operand_498).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_497: {
                    break :block_497 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_496: {
                        break :block_496 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_495: {
                            const operand_494 = ((value_10).pending).ready;

                            break :block_495 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_494).len == 0)) .{ operand_494, null, null, } else .{ (operand_494)[0..((operand_494).len - 1)], (operand_494)[((operand_494).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_360: {
                    const operand_358 = ((value_13).plan).mapping;

                    const operand_359 = block_357: {
                        break :block_357 value_6;
                    };

                    if ((operand_359 >= (operand_358).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_360 (operand_358)[@intCast(operand_359)];
                } == @as(u64, 0))) block_493: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_361: {
                        break :block_361 value_7;
                    })) block_380: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_379: {
                            break :block_379 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_378: {
                                break :block_378 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_377: {
                                    const operand_374 = ((value_13).pending).ids;

                                    const operand_376 = block_375: {
                                        break :block_375 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_374).len, 1));

                                    if ((!state_capacity_started_348)) {
                                        (try (state_capacity_347).appendSlice(allocator, operand_374));

                                        state_capacity_started_348 = true;
                                    } else {
                                        ((state_capacity_347).items).len = (operand_374).len;
                                    }

                                    (try (state_capacity_347).append(allocator, operand_376));

                                    break :block_377 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_347).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_373: {
                            break :block_373 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_372: {
                                break :block_372 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_371: {
                                    const operand_369 = ((value_16).pending).ready;
                                    const operand_370 = true;

                                    _ = (try ((std).math).add(usize, (operand_369).len, 1));

                                    if ((!state_capacity_started_350)) {
                                        (try (state_capacity_349).appendSlice(allocator, operand_369));

                                        state_capacity_started_350 = true;
                                    } else {
                                        ((state_capacity_349).items).len = (operand_369).len;
                                    }

                                    (try (state_capacity_349).append(allocator, operand_370));

                                    break :block_371 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_349).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_368: {
                            break :block_368 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_367: {
                                break :block_367 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_366: {
                                    const operand_362 = ((value_19).request).table;

                                    const operand_363 = block_364: {
                                        break :block_364 value_6;
                                    };

                                    const operand_365 = (value_19).pending;

                                    break :block_366 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_362, .index = operand_363, .pending = operand_365, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_347), .started = (&state_capacity_started_348), }, .lane_1 = .{ .buffer = (&state_capacity_349), .started = (&state_capacity_started_350), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_380 value_21;
                    } else block_492: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_491: {
                            break :block_491 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_490: {
                            break :block_490 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_489: {
                            break :block_489 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_488: {
                                break :block_488 block_487: {
                                    const operand_486 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_486).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_473: {
                                        break :block_473 (&value_24);
                                    }).count, .mapping = block_482: {
                                        const operand_475 = block_474: {
                                            break :block_474 value_25;
                                        };
                                        const operand_477 = block_476: {
                                            break :block_476 value_26;
                                        };

                                        if ((operand_477 >= (operand_475).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_479 = (block_478: {
                                            break :block_478 value_22;
                                        } + @as(u64, 1));

                                        break :block_482 @as([]const u64, (if (((buffers).lane_0 != null)) block_480: {
                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_475));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_475).len;
                                            }

                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_477)] = operand_479;

                                            break :block_480 ((((buffers).lane_0.?).buffer).*).items;
                                        } else block_481: {
                                            if ((!state_capacity_started_352)) {
                                                (try (state_capacity_351).appendSlice(allocator, operand_475));

                                                state_capacity_started_352 = true;
                                            } else {
                                                ((state_capacity_351).items).len = (operand_475).len;
                                            }

                                            ((state_capacity_351).items)[@intCast(operand_477)] = operand_479;

                                            break :block_481 (state_capacity_351).items;
                                        }));
                                    }, .order = (block_483: {
                                        break :block_483 (&value_24);
                                    }).order, .origins = (block_484: {
                                        break :block_484 (&value_24);
                                    }).origins, .status = (block_485: {
                                        break :block_485 (&value_24);
                                    }).status, });

                                    break :block_487 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_486);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_472: {
                            break :block_472 (&value_29);
                        }).order;
                        const value_31: u64 = block_471: {
                            break :block_471 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_470: {
                            break :block_470 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_469: {
                                break :block_469 block_468: {
                                    const operand_467 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_467).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_452: {
                                        break :block_452 (&value_29);
                                    }).count, .mapping = (block_453: {
                                        break :block_453 (&value_29);
                                    }).mapping, .order = block_464: {
                                        const operand_455 = block_454: {
                                            break :block_454 value_30;
                                        };
                                        const operand_457 = block_456: {
                                            break :block_456 value_31;
                                        };

                                        if ((operand_457 >= (operand_455).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_461 = block_460: {
                                            const operand_459 = block_458: {
                                                break :block_458 value_6;
                                            };

                                            break :block_460 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_459));
                                        };

                                        break :block_464 @as([]const u32, (if (((buffers).lane_1 != null)) block_462: {
                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_455));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_455).len;
                                            }

                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_457)] = operand_461;

                                            break :block_462 ((((buffers).lane_1.?).buffer).*).items;
                                        } else block_463: {
                                            if ((!state_capacity_started_354)) {
                                                (try (state_capacity_353).appendSlice(allocator, operand_455));

                                                state_capacity_started_354 = true;
                                            } else {
                                                ((state_capacity_353).items).len = (operand_455).len;
                                            }

                                            ((state_capacity_353).items)[@intCast(operand_457)] = operand_461;

                                            break :block_463 (state_capacity_353).items;
                                        }));
                                    }, .origins = (block_465: {
                                        break :block_465 (&value_29);
                                    }).origins, .status = (block_466: {
                                        break :block_466 (&value_29);
                                    }).status, });

                                    break :block_468 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_467);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_451: {
                            break :block_451 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_450: {
                            break :block_450 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_449: {
                                break :block_449 block_448: {
                                    const operand_447 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_447).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_442: {
                                        break :block_442 value_35;
                                    } + @as(u64, 1)), .mapping = (block_443: {
                                        break :block_443 (&value_34);
                                    }).mapping, .order = (block_444: {
                                        break :block_444 (&value_34);
                                    }).order, .origins = (block_445: {
                                        break :block_445 (&value_34);
                                    }).origins, .status = (block_446: {
                                        break :block_446 (&value_34);
                                    }).status, });

                                    break :block_448 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_447);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_441: {
                            const operand_440 = block_439: {
                                const operand_437 = (((value_36).request).table).kinds;

                                const operand_438 = block_436: {
                                    break :block_436 value_6;
                                };

                                if ((operand_438 >= (operand_437).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_439 (operand_437)[@intCast(operand_438)];
                            };

                            break :block_441 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_440));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_381: {
                            break :block_381 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_382: {
                            break :block_382 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_435: {
                            const value_38: u64 = block_434: {
                                const operand_424 = ((value_36).request).origins;
                                const operand_425 = ((value_36).request).names;

                                const operand_427 = block_426: {
                                    break :block_426 value_6;
                                };
                                const operand_432 = block_431: {
                                    const operand_429 = (((value_36).request).table).labels;

                                    const operand_430 = block_428: {
                                        break :block_428 value_6;
                                    };

                                    if ((operand_430 >= (operand_429).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_431 (operand_429)[@intCast(operand_430)];
                                };

                                const operand_433 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_424, .names = operand_425, .index = operand_427, .name = operand_432, };

                                break :block_434 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_433)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_383: {
                                break :block_383 value_38;
                            } == @as(u64, 0))) block_392: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_391: {
                                    break :block_391 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_390: {
                                        break :block_390 block_389: {
                                            const operand_388 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_388).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_384: {
                                                break :block_384 (&value_40);
                                            }).count, .mapping = (block_385: {
                                                break :block_385 (&value_40);
                                            }).mapping, .order = (block_386: {
                                                break :block_386 (&value_40);
                                            }).order, .origins = (block_387: {
                                                break :block_387 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_389 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_388);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_392 value_41;
                            } else block_423: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_393: {
                                    break :block_393 value_38;
                                } == @as(u64, 1))) block_402: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_401: {
                                        break :block_401 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_400: {
                                            break :block_400 block_399: {
                                                const operand_398 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_398).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_394: {
                                                    break :block_394 (&value_43);
                                                }).count, .mapping = (block_395: {
                                                    break :block_395 (&value_43);
                                                }).mapping, .order = (block_396: {
                                                    break :block_396 (&value_43);
                                                }).order, .origins = (block_397: {
                                                    break :block_397 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_399 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_398);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_402 value_44;
                                } else block_422: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_421: {
                                        break :block_421 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_420: {
                                        break :block_420 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_419: {
                                        break :block_419 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_418: {
                                            break :block_418 block_417: {
                                                const operand_416 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_416).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_403: {
                                                    break :block_403 (&value_46);
                                                }).count, .mapping = (block_404: {
                                                    break :block_404 (&value_46);
                                                }).mapping, .order = (block_405: {
                                                    break :block_405 (&value_46);
                                                }).order, .origins = block_414: {
                                                    const operand_407 = block_406: {
                                                        break :block_406 value_47;
                                                    };
                                                    const operand_409 = block_408: {
                                                        break :block_408 value_48;
                                                    };

                                                    if ((operand_409 >= (operand_407).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_411 = (block_410: {
                                                        break :block_410 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_414 @as([]const u64, (if (((buffers).lane_2 != null)) block_412: {
                                                        if ((!(((buffers).lane_2.?).started).*)) {
                                                            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_407));
                                                            (((buffers).lane_2.?).started).* = true;
                                                        } else {
                                                            (((((buffers).lane_2.?).buffer).*).items).len = (operand_407).len;
                                                        }

                                                        (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_409)] = operand_411;

                                                        break :block_412 ((((buffers).lane_2.?).buffer).*).items;
                                                    } else block_413: {
                                                        if ((!state_capacity_started_356)) {
                                                            (try (state_capacity_355).appendSlice(allocator, operand_407));

                                                            state_capacity_started_356 = true;
                                                        } else {
                                                            ((state_capacity_355).items).len = (operand_407).len;
                                                        }

                                                        ((state_capacity_355).items)[@intCast(operand_409)] = operand_411;
                                                        break :block_413 (state_capacity_355).items;
                                                    }));
                                                }, .status = (block_415: {
                                                    break :block_415 (&value_46);
                                                }).status, });

                                                break :block_417 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_416);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_422 value_49;
                                });

                                break :block_423 value_50;
                            });

                            break :block_435 value_51;
                        } else value_36);

                        break :block_492 value_52;
                    });

                    break :block_493 value_53;
                } else value_13);

                break :block_510 value_54;
            };
        }

        var state_owned_511: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_511);

        if (state_capacity_started_348) {
            ((state_capacity_347).items).len = (((state_336).pending).ids).len;
            state_owned_511 = (try (state_capacity_347).toOwnedSlice(allocator));
        }

        if (state_capacity_started_348) {
            state_336 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_511, .ready = ((state_336).pending).ready, }), .plan = (state_336).plan, .request = (state_336).request, };
        }

        var state_owned_512: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_512);

        if (state_capacity_started_350) {
            ((state_capacity_349).items).len = (((state_336).pending).ready).len;
            state_owned_512 = (try (state_capacity_349).toOwnedSlice(allocator));
        }

        if (state_capacity_started_350) {
            state_336 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_336).pending).ids, .ready = state_owned_512, }), .plan = (state_336).plan, .request = (state_336).request, };
        }

        var state_owned_513: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_513);

        if (state_capacity_started_352) {
            ((state_capacity_351).items).len = (((state_336).plan).mapping).len;
            state_owned_513 = (try (state_capacity_351).toOwnedSlice(allocator));
        }

        if (state_capacity_started_352) {
            state_336 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_515: {
                const operand_514 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_514).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_336).plan).count, .mapping = state_owned_513, .order = ((state_336).plan).order, .origins = ((state_336).plan).origins, .status = ((state_336).plan).status, });

                break :block_515 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_514);
            }, .request = (state_336).request, };
        }

        var state_owned_516: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_516);

        if (state_capacity_started_354) {
            ((state_capacity_353).items).len = (((state_336).plan).order).len;
            state_owned_516 = (try (state_capacity_353).toOwnedSlice(allocator));
        }

        if (state_capacity_started_354) {
            state_336 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_518: {
                const operand_517 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_517).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_336).plan).count, .mapping = ((state_336).plan).mapping, .order = state_owned_516, .origins = ((state_336).plan).origins, .status = ((state_336).plan).status, });

                break :block_518 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_517);
            }, .request = (state_336).request, };
        }

        var state_owned_519: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_519);

        if (state_capacity_started_356) {
            ((state_capacity_355).items).len = (((state_336).plan).origins).len;
            state_owned_519 = (try (state_capacity_355).toOwnedSlice(allocator));
        }

        if (state_capacity_started_356) {
            state_336 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_336).pending, .plan = block_521: {
                const operand_520 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_520).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_336).plan).count, .mapping = ((state_336).plan).mapping, .order = ((state_336).plan).order, .origins = state_owned_519, .status = ((state_336).plan).status, });

                break :block_521 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_520);
            }, .request = (state_336).request, };
        }

        break :block_528 block_527: {
            break :block_527 (if (((state_336).zx_origin != null)) ((state_336).zx_origin.?).* else block_526: {
                break :block_526 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_336).pending).zx_origin != null)) ((state_336).pending).zx_origin.? else block_523: {
                    const operand_522 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_522).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_336).pending).ids, .ready = ((state_336).pending).ready, };

                    break :block_523 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_522);
                }), .plan = (state_336).plan, .request = (if ((((state_336).request).zx_origin != null)) ((state_336).request).zx_origin.? else block_525: {
                    const operand_524 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_524).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_336).request).maximum_count, .names = ((state_336).request).names, .origins = ((state_336).request).origins, .roots = ((state_336).request).roots, .scalar_count = ((state_336).request).scalar_count, .table = ((state_336).request).table, };

                    break :block_525 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_524);
                }), };
            });
        };
    };

    return (((&value_55)).plan).*;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, buffers: struct {
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

    const value_1: []const u64 = block_688: {
        const operand_687 = (in).index;

        break :block_688 (try (allocator).dupe(u64, (&[_]u64{operand_687, })));
    };

    const value_2: []const bool = block_686: {
        const operand_685 = false;

        break :block_686 (try (allocator).dupe(bool, (&[_]bool{operand_685, })));
    };

    const value_55: *const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_684: {
        const operand_545 = block_544: {
            const operand_534 = (in).request;
            const operand_535 = (in).state;

            const operand_536 = block_541: {
                const operand_537 = value_1;
                const operand_538 = value_2;

                break :block_541 block_540: {
                    const operand_539 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_539).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_537, .ready = operand_538, });

                    break :block_540 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_539);
                };
            };

            break :block_544 block_543: {
                const operand_542 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_542).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_534, .plan = operand_535, .pending = operand_536, });

                break :block_543 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_542);
            };
        };

        var state_capacity_547: (std).ArrayList(u64) = .empty;
        var state_capacity_started_548 = false;

        defer (state_capacity_547).deinit(allocator);

        var state_capacity_549: (std).ArrayList(bool) = .empty;
        var state_capacity_started_550 = false;

        defer (state_capacity_549).deinit(allocator);

        var state_capacity_551: (std).ArrayList(u64) = .empty;
        var state_capacity_started_552 = false;

        defer (state_capacity_551).deinit(allocator);

        var state_capacity_553: (std).ArrayList(u32) = .empty;
        var state_capacity_started_554 = false;

        defer (state_capacity_553).deinit(allocator);

        var state_capacity_555: (std).ArrayList(u64) = .empty;
        var state_capacity_started_556 = false;

        defer (state_capacity_555).deinit(allocator);

        const state_type_560 = struct {
            ids: []const u64,
            ready: []const bool,
        };
        const state_type_561 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_562 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_563 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };

        const state_type_564 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_562,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_563,
        };
        const state_type_565 = struct {
            pending: state_type_560,
            plan: state_type_561,
            request: state_type_564,
        };
        const state_type_566 = struct {
            index: u64,
            pending: state_type_560,
            table: state_type_563,
        };
        const state_type_582 = struct { []const bool, void, };
        const state_type_588 = struct { []const u64, void, };

        const state_type_611 = struct {
            index: u64,
            name: []const u8,
            names: []const []const u8,
            origins: state_type_562,
        };
        const state_type_649 = struct { []const bool, ?bool, };
        const state_type_654 = struct { []const u64, ?u64, };
        var state_533: state_type_565 = state_type_565{ .pending = state_type_560{ .ids = ((operand_545).pending).ids, .ready = ((operand_545).pending).ready, }, .plan = state_type_561{ .count = ((operand_545).plan).count, .mapping = ((operand_545).plan).mapping, .order = ((operand_545).plan).order, .origins = ((operand_545).plan).origins, .status = ((operand_545).plan).status, }, .request = state_type_564{ .maximum_count = ((operand_545).request).maximum_count, .names = ((operand_545).request).names, .origins = state_type_562{ .ids = (((operand_545).request).origins).ids, .kinds = (((operand_545).request).origins).kinds, .members = (((operand_545).request).origins).members, .owners = (((operand_545).request).origins).owners, }, .roots = ((operand_545).request).roots, .scalar_count = ((operand_545).request).scalar_count, .table = state_type_563{ .children = (((operand_545).request).table).children, .field_names = (((operand_545).request).table).field_names, .field_types = (((operand_545).request).table).field_types, .first = (((operand_545).request).table).first, .kinds = (((operand_545).request).table).kinds, .labels = (((operand_545).request).table).labels, .names = (((operand_545).request).table).names, .second = (((operand_545).request).table).second, }, }, };
        var state_changed_546 = false;

        while (((((state_533).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_533).pending).ids).len) > @as(u64, 0)))) {
            state_533 = block_665: {
                const value_5: u64 = (@as(u64, (((state_533).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_664: {
                    const operand_662 = ((state_533).pending).ids;
                    const operand_663 = value_5;

                    if ((operand_663 >= (operand_662).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_664 (operand_662)[@intCast(operand_663)];
                };
                const value_7: bool = block_661: {
                    const operand_659 = ((state_533).pending).ready;
                    const operand_660 = value_5;

                    if ((operand_660 >= (operand_659).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_661 (operand_659)[@intCast(operand_660)];
                };
                const value_8: state_type_565 = state_533;
                const value_9: state_type_560 = (value_8).pending;

                const value_10: state_type_565 = block_658: {
                    break :block_658 state_type_565{ .pending = block_657: {
                        break :block_657 state_type_560{ .ids = (block_656: {
                            const operand_655 = ((state_533).pending).ids;

                            break :block_656 @as(state_type_654, (if (((operand_655).len == 0)) .{ operand_655, null, } else .{ (operand_655)[0..((operand_655).len - 1)], (operand_655)[((operand_655).len - 1)], }));
                        }).@"0", .ready = (value_9).ready, };
                    }, .plan = (value_8).plan, .request = (value_8).request, };
                };
                const value_11: state_type_565 = value_10;
                const value_12: state_type_560 = (value_11).pending;

                const value_13: state_type_565 = block_653: {
                    break :block_653 state_type_565{ .pending = block_652: {
                        break :block_652 state_type_560{ .ids = (value_12).ids, .ready = (block_651: {
                            const operand_650 = ((value_10).pending).ready;

                            break :block_651 @as(state_type_649, (if (((operand_650).len == 0)) .{ operand_650, null, } else .{ (operand_650)[0..((operand_650).len - 1)], (operand_650)[((operand_650).len - 1)], }));
                        }).@"0", };
                    }, .plan = (value_11).plan, .request = (value_11).request, };
                };
                const value_54: state_type_565 = (if ((block_559: {
                    const operand_557 = ((value_13).plan).mapping;
                    const operand_558 = value_6;

                    if ((operand_558 >= (operand_557).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_559 (operand_557)[@intCast(operand_558)];
                } == @as(u64, 0))) block_648: {
                    const value_53: state_type_565 = (if ((!value_7)) block_594: {
                        const value_14: state_type_565 = value_13;
                        const value_15: state_type_560 = (value_14).pending;
                        const value_16: state_type_565 = block_593: {
                            break :block_593 state_type_565{ .pending = block_592: {
                                break :block_592 state_type_560{ .ids = (block_591: {
                                    const operand_589 = ((value_13).pending).ids;
                                    const operand_590 = value_6;

                                    _ = (try ((std).math).add(usize, (operand_589).len, 1));

                                    if ((!state_capacity_started_548)) {
                                        (try (state_capacity_547).appendSlice(allocator, operand_589));
                                        state_capacity_started_548 = true;
                                    } else {
                                        ((state_capacity_547).items).len = (operand_589).len;
                                    }

                                    (try (state_capacity_547).append(allocator, operand_590));

                                    break :block_591 @as(state_type_588, .{ (state_capacity_547).items, {}, });
                                }).@"0", .ready = (value_15).ready, };
                            }, .plan = (value_14).plan, .request = (value_14).request, };
                        };
                        const value_17: state_type_565 = value_16;
                        const value_18: state_type_560 = (value_17).pending;
                        const value_19: state_type_565 = block_587: {
                            break :block_587 state_type_565{ .pending = block_586: {
                                break :block_586 state_type_560{ .ids = (value_18).ids, .ready = (block_585: {
                                    const operand_583 = ((value_16).pending).ready;
                                    const operand_584 = true;

                                    _ = (try ((std).math).add(usize, (operand_583).len, 1));

                                    if ((!state_capacity_started_550)) {
                                        (try (state_capacity_549).appendSlice(allocator, operand_583));
                                        state_capacity_started_550 = true;
                                    } else {
                                        ((state_capacity_549).items).len = (operand_583).len;
                                    }

                                    (try (state_capacity_549).append(allocator, operand_584));

                                    break :block_585 @as(state_type_582, .{ (state_capacity_549).items, {}, });
                                }).@"0", };
                            }, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_20: state_type_565 = value_19;
                        const value_21: state_type_565 = block_581: {
                            break :block_581 state_type_565{ .pending = block_580: {
                                const operand_571 = block_570: {
                                    const operand_567 = ((value_19).request).table;
                                    const operand_568 = value_6;
                                    const operand_569 = (value_19).pending;

                                    break :block_570 state_type_566{ .table = operand_567, .index = operand_568, .pending = operand_569, };
                                };

                                const operand_572 = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((operand_571).pending).ids, .ready = ((operand_571).pending).ready, };
                                const operand_573 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = ((operand_571).table).children, .field_names = ((operand_571).table).field_names, .field_types = ((operand_571).table).field_types, .first = ((operand_571).table).first, .kinds = ((operand_571).table).kinds, .labels = ((operand_571).table).labels, .names = ((operand_571).table).names, .second = ((operand_571).table).second, };
                                const operand_574 = (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a{ .index = (operand_571).index, .pending = (&operand_572), .table = (&operand_573), };

                                const operand_579 = block_578: {
                                    const operand_575 = (&operand_574);
                                    const operand_576 = (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_575).index, .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_575).pending).ids, .ready = ((operand_575).pending).ready, .zx_origin = (operand_575).pending, }, .table = (operand_575).table, .zx_origin = operand_575, }, .{ .lane_0 = .{ .buffer = (&state_capacity_547), .started = (&state_capacity_started_548), }, .lane_1 = .{ .buffer = (&state_capacity_549), .started = (&state_capacity_started_550), }, }));

                                    break :block_578 (if (((operand_576).zx_origin != null)) ((operand_576).zx_origin.?).* else block_577: {
                                        break :block_577 (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = (operand_576).ids, .ready = (operand_576).ready, };
                                    });
                                };

                                break :block_580 state_type_560{ .ids = (operand_579).ids, .ready = (operand_579).ready, };
                            }, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_594 value_21;
                    } else block_647: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: state_type_565 = value_13;
                        const value_24: state_type_561 = (value_23).plan;
                        const value_25: []const u64 = (value_24).mapping;
                        const value_26: u64 = value_6;
                        const value_27: state_type_565 = block_646: {
                            break :block_646 state_type_565{ .pending = (value_23).pending, .plan = block_645: {
                                break :block_645 state_type_561{ .count = (value_24).count, .mapping = block_644: {
                                    const operand_639 = value_25;
                                    const operand_640 = value_26;

                                    if ((operand_640 >= (operand_639).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_641 = (value_22 + @as(u64, 1));

                                    break :block_644 @as([]const u64, (if (((buffers).lane_0 != null)) block_642: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_639));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_639).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_640)] = operand_641;

                                        break :block_642 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_643: {
                                        if ((!state_capacity_started_552)) {
                                            (try (state_capacity_551).appendSlice(allocator, operand_639));

                                            state_capacity_started_552 = true;
                                        } else {
                                            ((state_capacity_551).items).len = (operand_639).len;
                                        }

                                        ((state_capacity_551).items)[@intCast(operand_640)] = operand_641;

                                        break :block_643 (state_capacity_551).items;
                                    }));
                                }, .order = (value_24).order, .origins = (value_24).origins, .status = (value_24).status, };
                            }, .request = (value_23).request, };
                        };
                        const value_28: state_type_565 = value_27;
                        const value_29: state_type_561 = (value_28).plan;
                        const value_30: []const u32 = (value_29).order;
                        const value_31: u64 = value_22;
                        const value_32: state_type_565 = block_638: {
                            break :block_638 state_type_565{ .pending = (value_28).pending, .plan = block_637: {
                                break :block_637 state_type_561{ .count = (value_29).count, .mapping = (value_29).mapping, .order = block_636: {
                                    const operand_631 = value_30;
                                    const operand_632 = value_31;

                                    if ((operand_632 >= (operand_631).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_633 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, value_6));

                                    break :block_636 @as([]const u32, (if (((buffers).lane_1 != null)) block_634: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_631));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_631).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_632)] = operand_633;

                                        break :block_634 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_635: {
                                        if ((!state_capacity_started_554)) {
                                            (try (state_capacity_553).appendSlice(allocator, operand_631));

                                            state_capacity_started_554 = true;
                                        } else {
                                            ((state_capacity_553).items).len = (operand_631).len;
                                        }

                                        ((state_capacity_553).items)[@intCast(operand_632)] = operand_633;

                                        break :block_635 (state_capacity_553).items;
                                    }));
                                }, .origins = (value_29).origins, .status = (value_29).status, };
                            }, .request = (value_28).request, };
                        };
                        const value_33: state_type_565 = value_32;
                        const value_34: state_type_561 = (value_33).plan;
                        const value_35: u64 = (value_34).count;

                        const value_36: state_type_565 = block_630: {
                            break :block_630 state_type_565{ .pending = (value_33).pending, .plan = block_629: {
                                break :block_629 state_type_561{ .count = (value_35 + @as(u64, 1)), .mapping = (value_34).mapping, .order = (value_34).order, .origins = (value_34).origins, .status = (value_34).status, };
                            }, .request = (value_33).request, };
                        };

                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_628: {
                            const operand_626 = (((value_36).request).table).kinds;
                            const operand_627 = value_6;

                            if ((operand_627 >= (operand_626).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_628 (operand_626)[@intCast(operand_627)];
                        }));

                        const value_52: state_type_565 = (if (((value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_625: {
                            const value_38: u64 = block_624: {
                                const operand_620 = block_619: {
                                    const operand_612 = ((value_36).request).origins;
                                    const operand_613 = ((value_36).request).names;
                                    const operand_614 = value_6;
                                    const operand_618 = block_617: {
                                        const operand_615 = (((value_36).request).table).labels;
                                        const operand_616 = value_6;

                                        if ((operand_616 >= (operand_615).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_617 (operand_615)[@intCast(operand_616)];
                                    };

                                    break :block_619 state_type_611{ .origins = operand_612, .names = operand_613, .index = operand_614, .name = operand_618, };
                                };

                                const operand_621 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = ((operand_620).origins).ids, .kinds = ((operand_620).origins).kinds, .members = ((operand_620).origins).members, .owners = ((operand_620).origins).owners, };
                                const operand_622 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .index = (operand_620).index, .name = (operand_620).name, .names = (operand_620).names, .origins = (&operand_621), };
                                const operand_623 = (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_622)));

                                break :block_624 operand_623;
                            };
                            const value_51: state_type_565 = (if ((value_38 == @as(u64, 0))) block_597: {
                                const value_39: state_type_565 = value_36;
                                const value_40: state_type_561 = (value_39).plan;
                                const value_41: state_type_565 = block_596: {
                                    break :block_596 state_type_565{ .pending = (value_39).pending, .plan = block_595: {
                                        break :block_595 state_type_561{ .count = (value_40).count, .mapping = (value_40).mapping, .order = (value_40).order, .origins = (value_40).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), };
                                    }, .request = (value_39).request, };
                                };

                                break :block_597 value_41;
                            } else block_610: {
                                const value_50: state_type_565 = (if ((value_38 == @as(u64, 1))) block_600: {
                                    const value_42: state_type_565 = value_36;
                                    const value_43: state_type_561 = (value_42).plan;
                                    const value_44: state_type_565 = block_599: {
                                        break :block_599 state_type_565{ .pending = (value_42).pending, .plan = block_598: {
                                            break :block_598 state_type_561{ .count = (value_43).count, .mapping = (value_43).mapping, .order = (value_43).order, .origins = (value_43).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), };
                                        }, .request = (value_42).request, };
                                    };

                                    break :block_600 value_44;
                                } else block_609: {
                                    const value_45: state_type_565 = value_36;
                                    const value_46: state_type_561 = (value_45).plan;
                                    const value_47: []const u64 = (value_46).origins;
                                    const value_48: u64 = value_22;
                                    const value_49: state_type_565 = block_608: {
                                        break :block_608 state_type_565{ .pending = (value_45).pending, .plan = block_607: {
                                            break :block_607 state_type_561{ .count = (value_46).count, .mapping = (value_46).mapping, .order = (value_46).order, .origins = block_606: {
                                                const operand_601 = value_47;
                                                const operand_602 = value_48;

                                                if ((operand_602 >= (operand_601).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_603 = (value_38 - @as(u64, 1));

                                                break :block_606 @as([]const u64, (if (((buffers).lane_2 != null)) block_604: {
                                                    if ((!(((buffers).lane_2.?).started).*)) {
                                                        (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_601));
                                                        (((buffers).lane_2.?).started).* = true;
                                                    } else {
                                                        (((((buffers).lane_2.?).buffer).*).items).len = (operand_601).len;
                                                    }

                                                    (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_602)] = operand_603;

                                                    break :block_604 ((((buffers).lane_2.?).buffer).*).items;
                                                } else block_605: {
                                                    if ((!state_capacity_started_556)) {
                                                        (try (state_capacity_555).appendSlice(allocator, operand_601));

                                                        state_capacity_started_556 = true;
                                                    } else {
                                                        ((state_capacity_555).items).len = (operand_601).len;
                                                    }

                                                    ((state_capacity_555).items)[@intCast(operand_602)] = operand_603;
                                                    break :block_605 (state_capacity_555).items;
                                                }));
                                            }, .status = (value_46).status, };
                                        }, .request = (value_45).request, };
                                    };

                                    break :block_609 value_49;
                                });

                                break :block_610 value_50;
                            });

                            break :block_625 value_51;
                        } else value_36);

                        break :block_647 value_52;
                    });

                    break :block_648 value_53;
                } else value_13);

                break :block_665 value_54;
            };

            state_changed_546 = true;
        }

        var state_owned_666: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_666);

        if (state_capacity_started_548) {
            ((state_capacity_547).items).len = (((state_533).pending).ids).len;
            state_owned_666 = (try (state_capacity_547).toOwnedSlice(allocator));
        }

        if (state_capacity_started_548) {
            ((state_533).pending).ids = state_owned_666;
        }

        var state_owned_667: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_667);

        if (state_capacity_started_550) {
            ((state_capacity_549).items).len = (((state_533).pending).ready).len;
            state_owned_667 = (try (state_capacity_549).toOwnedSlice(allocator));
        }

        if (state_capacity_started_550) {
            ((state_533).pending).ready = state_owned_667;
        }

        var state_owned_668: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_668);

        if (state_capacity_started_552) {
            ((state_capacity_551).items).len = (((state_533).plan).mapping).len;
            state_owned_668 = (try (state_capacity_551).toOwnedSlice(allocator));
        }

        if (state_capacity_started_552) {
            ((state_533).plan).mapping = state_owned_668;
        }

        var state_owned_669: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_669);

        if (state_capacity_started_554) {
            ((state_capacity_553).items).len = (((state_533).plan).order).len;
            state_owned_669 = (try (state_capacity_553).toOwnedSlice(allocator));
        }

        if (state_capacity_started_554) {
            ((state_533).plan).order = state_owned_669;
        }

        var state_owned_670: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_670);

        if (state_capacity_started_556) {
            ((state_capacity_555).items).len = (((state_533).plan).origins).len;
            state_owned_670 = (try (state_capacity_555).toOwnedSlice(allocator));
        }

        if (state_capacity_started_556) {
            ((state_533).plan).origins = state_owned_670;
        }

        break :block_684 (if (state_changed_546) block_683: {
            const operand_682 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

            (operand_682).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = block_673: {
                const operand_672 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_672).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_533).pending).ids, .ready = ((state_533).pending).ready, });

                break :block_673 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_672);
            }, .plan = block_675: {
                const operand_674 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_674).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_533).plan).count, .mapping = ((state_533).plan).mapping, .order = ((state_533).plan).order, .origins = ((state_533).plan).origins, .status = ((state_533).plan).status, });

                break :block_675 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_674);
            }, .request = block_681: {
                const operand_680 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_680).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_533).request).maximum_count, .names = ((state_533).request).names, .origins = block_677: {
                    const operand_676 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_676).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_533).request).origins).ids, .kinds = (((state_533).request).origins).kinds, .members = (((state_533).request).origins).members, .owners = (((state_533).request).origins).owners, });

                    break :block_677 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_676);
                }, .roots = ((state_533).request).roots, .scalar_count = ((state_533).request).scalar_count, .table = block_679: {
                    const operand_678 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_678).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_533).request).table).children, .field_names = (((state_533).request).table).field_names, .field_types = (((state_533).request).table).field_types, .first = (((state_533).request).table).first, .kinds = (((state_533).request).table).kinds, .labels = (((state_533).request).table).labels, .names = (((state_533).request).table).names, .second = (((state_533).request).table).second, });

                    break :block_679 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_678);
                }, });

                break :block_681 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_680);
            }, });

            break :block_683 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_682);
        } else operand_545);
    };

    return (value_55).plan;
}

