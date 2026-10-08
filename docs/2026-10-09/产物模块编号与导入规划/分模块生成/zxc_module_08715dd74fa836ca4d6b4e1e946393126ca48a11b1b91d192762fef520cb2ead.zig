const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    if ((block_153: {
        const operand_151 = ((in).state).mapping;
        const operand_152 = (in).index;

        if ((operand_152 >= (operand_151).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_153 (operand_151)[@intCast(operand_152)];
    } != @as(u64, 0))) {
        return (in).state;
    }

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

    if ((block_341: {
        const operand_339 = ((in).state).mapping;
        const operand_340 = (in).index;

        if ((operand_340 >= (operand_339).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_341 (operand_339)[@intCast(operand_340)];
    } != @as(u64, 0))) {
        return ((in).state).*;
    }

    const value_1: []const u64 = block_338: {
        const operand_337 = (in).index;

        break :block_338 (try (allocator).dupe(u64, (&[_]u64{operand_337, })));
    };

    const value_2: []const bool = block_336: {
        const operand_335 = false;

        break :block_336 (try (allocator).dupe(bool, (&[_]bool{operand_335, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_334: {
        const operand_164 = block_163: {
            const operand_155 = (in).request;
            const operand_156 = (in).state;

            const operand_157 = block_162: {
                const operand_158 = value_1;
                const operand_159 = value_2;

                break :block_162 block_161: {
                    const operand_160 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_160).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_158, .ready = operand_159, });

                    break :block_161 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_160);
                };
            };

            break :block_163 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_155, .plan = operand_156, .pending = operand_157, };
        };

        var state_capacity_165: (std).ArrayList(u64) = .empty;
        var state_capacity_started_166 = false;

        defer (state_capacity_165).deinit(allocator);

        var state_capacity_167: (std).ArrayList(bool) = .empty;
        var state_capacity_started_168 = false;

        defer (state_capacity_167).deinit(allocator);

        var state_items_169: []u64 = undefined;
        var state_items_started_170 = false;
        var state_items_171: []u32 = undefined;
        var state_items_started_172 = false;
        var state_items_173: []u64 = undefined;
        var state_items_started_174 = false;
        var state_154: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_164).pending).ids, .ready = ((operand_164).pending).ready, .zx_origin = (operand_164).pending, }, .plan = (operand_164).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_164).request).maximum_count, .names = ((operand_164).request).names, .origins = ((operand_164).request).origins, .roots = ((operand_164).request).roots, .scalar_count = ((operand_164).request).scalar_count, .table = ((operand_164).request).table, .zx_origin = (operand_164).request, }, .zx_origin = (&operand_164), };

        while (((((state_154).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_154).pending).ids).len) > @as(u64, 0)))) {
            state_154 = block_325: {
                const value_5: u64 = (@as(u64, (((state_154).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_324: {
                    const operand_322 = ((state_154).pending).ids;

                    const operand_323 = block_321: {
                        break :block_321 value_5;
                    };

                    if ((operand_323 >= (operand_322).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_324 (operand_322)[@intCast(operand_323)];
                };
                const value_7: bool = block_320: {
                    const operand_318 = ((state_154).pending).ready;

                    const operand_319 = block_317: {
                        break :block_317 value_5;
                    };

                    if ((operand_319 >= (operand_318).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_320 (operand_318)[@intCast(operand_319)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_154;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_316: {
                    break :block_316 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_315: {
                        break :block_315 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_314: {
                            const operand_313 = ((state_154).pending).ids;

                            break :block_314 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_313).len == 0)) .{ operand_313, null, null, } else .{ (operand_313)[0..((operand_313).len - 1)], (operand_313)[((operand_313).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_312: {
                    break :block_312 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_311: {
                        break :block_311 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_310: {
                            const operand_309 = ((value_10).pending).ready;

                            break :block_310 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_309).len == 0)) .{ operand_309, null, null, } else .{ (operand_309)[0..((operand_309).len - 1)], (operand_309)[((operand_309).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_178: {
                    const operand_176 = ((value_13).plan).mapping;

                    const operand_177 = block_175: {
                        break :block_175 value_6;
                    };

                    if ((operand_177 >= (operand_176).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_178 (operand_176)[@intCast(operand_177)];
                } == @as(u64, 0))) block_308: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_179: {
                        break :block_179 value_7;
                    })) block_198: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_197: {
                            break :block_197 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_196: {
                                break :block_196 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_195: {
                                    const operand_192 = ((value_13).pending).ids;

                                    const operand_194 = block_193: {
                                        break :block_193 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_192).len, 1));

                                    if ((!state_capacity_started_166)) {
                                        (try (state_capacity_165).appendSlice(allocator, operand_192));

                                        state_capacity_started_166 = true;
                                    } else {
                                        ((state_capacity_165).items).len = (operand_192).len;
                                    }

                                    (try (state_capacity_165).append(allocator, operand_194));

                                    break :block_195 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_165).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_191: {
                            break :block_191 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_190: {
                                break :block_190 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_189: {
                                    const operand_187 = ((value_16).pending).ready;
                                    const operand_188 = true;

                                    _ = (try ((std).math).add(usize, (operand_187).len, 1));

                                    if ((!state_capacity_started_168)) {
                                        (try (state_capacity_167).appendSlice(allocator, operand_187));
                                        state_capacity_started_168 = true;
                                    } else {
                                        ((state_capacity_167).items).len = (operand_187).len;
                                    }

                                    (try (state_capacity_167).append(allocator, operand_188));

                                    break :block_189 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_167).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_186: {
                            break :block_186 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_185: {
                                break :block_185 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_184: {
                                    const operand_180 = ((value_19).request).table;

                                    const operand_181 = block_182: {
                                        break :block_182 value_6;
                                    };

                                    const operand_183 = (value_19).pending;

                                    break :block_184 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_180, .index = operand_181, .pending = operand_183, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_165), .started = (&state_capacity_started_166), }, .lane_1 = .{ .buffer = (&state_capacity_167), .started = (&state_capacity_started_168), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_198 value_21;
                    } else block_307: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_306: {
                            break :block_306 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_305: {
                            break :block_305 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_304: {
                            break :block_304 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_303: {
                                break :block_303 block_302: {
                                    const operand_301 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_301).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_289: {
                                        break :block_289 (&value_24);
                                    }).count, .mapping = block_297: {
                                        const operand_291 = block_290: {
                                            break :block_290 value_25;
                                        };
                                        const operand_293 = block_292: {
                                            break :block_292 value_26;
                                        };

                                        if ((operand_293 >= (operand_291).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_295 = (block_294: {
                                            break :block_294 value_22;
                                        } + @as(u64, 1));

                                        break :block_297 block_296: {
                                            if ((!state_items_started_170)) {
                                                state_items_169 = (try (allocator).dupe(u64, operand_291));
                                                state_items_started_170 = true;
                                            }

                                            (state_items_169)[@intCast(operand_293)] = operand_295;

                                            break :block_296 state_items_169;
                                        };
                                    }, .order = (block_298: {
                                        break :block_298 (&value_24);
                                    }).order, .origins = (block_299: {
                                        break :block_299 (&value_24);
                                    }).origins, .status = (block_300: {
                                        break :block_300 (&value_24);
                                    }).status, });

                                    break :block_302 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_301);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_288: {
                            break :block_288 (&value_29);
                        }).order;
                        const value_31: u64 = block_287: {
                            break :block_287 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_286: {
                            break :block_286 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_285: {
                                break :block_285 block_284: {
                                    const operand_283 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_283).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_269: {
                                        break :block_269 (&value_29);
                                    }).count, .mapping = (block_270: {
                                        break :block_270 (&value_29);
                                    }).mapping, .order = block_280: {
                                        const operand_272 = block_271: {
                                            break :block_271 value_30;
                                        };
                                        const operand_274 = block_273: {
                                            break :block_273 value_31;
                                        };

                                        if ((operand_274 >= (operand_272).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_278 = block_277: {
                                            const operand_276 = block_275: {
                                                break :block_275 value_6;
                                            };

                                            break :block_277 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_276));
                                        };

                                        break :block_280 block_279: {
                                            if ((!state_items_started_172)) {
                                                state_items_171 = (try (allocator).dupe(u32, operand_272));
                                                state_items_started_172 = true;
                                            }

                                            (state_items_171)[@intCast(operand_274)] = operand_278;

                                            break :block_279 state_items_171;
                                        };
                                    }, .origins = (block_281: {
                                        break :block_281 (&value_29);
                                    }).origins, .status = (block_282: {
                                        break :block_282 (&value_29);
                                    }).status, });

                                    break :block_284 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_283);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_268: {
                            break :block_268 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_267: {
                            break :block_267 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_266: {
                                break :block_266 block_265: {
                                    const operand_264 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_264).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_259: {
                                        break :block_259 value_35;
                                    } + @as(u64, 1)), .mapping = (block_260: {
                                        break :block_260 (&value_34);
                                    }).mapping, .order = (block_261: {
                                        break :block_261 (&value_34);
                                    }).order, .origins = (block_262: {
                                        break :block_262 (&value_34);
                                    }).origins, .status = (block_263: {
                                        break :block_263 (&value_34);
                                    }).status, });

                                    break :block_265 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_264);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_258: {
                            const operand_257 = block_256: {
                                const operand_254 = (((value_36).request).table).kinds;

                                const operand_255 = block_253: {
                                    break :block_253 value_6;
                                };

                                if ((operand_255 >= (operand_254).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_256 (operand_254)[@intCast(operand_255)];
                            };

                            break :block_258 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_257));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_199: {
                            break :block_199 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_200: {
                            break :block_200 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_252: {
                            const value_38: u64 = block_251: {
                                const operand_241 = ((value_36).request).origins;
                                const operand_242 = ((value_36).request).names;
                                const operand_244 = block_243: {
                                    break :block_243 value_6;
                                };
                                const operand_249 = block_248: {
                                    const operand_246 = (((value_36).request).table).labels;

                                    const operand_247 = block_245: {
                                        break :block_245 value_6;
                                    };

                                    if ((operand_247 >= (operand_246).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_248 (operand_246)[@intCast(operand_247)];
                                };
                                const operand_250 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_241, .names = operand_242, .index = operand_244, .name = operand_249, };

                                break :block_251 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_250)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_201: {
                                break :block_201 value_38;
                            } == @as(u64, 0))) block_210: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_209: {
                                    break :block_209 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_208: {
                                        break :block_208 block_207: {
                                            const operand_206 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_206).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_202: {
                                                break :block_202 (&value_40);
                                            }).count, .mapping = (block_203: {
                                                break :block_203 (&value_40);
                                            }).mapping, .order = (block_204: {
                                                break :block_204 (&value_40);
                                            }).order, .origins = (block_205: {
                                                break :block_205 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_207 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_206);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_210 value_41;
                            } else block_240: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_211: {
                                    break :block_211 value_38;
                                } == @as(u64, 1))) block_220: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_219: {
                                        break :block_219 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_218: {
                                            break :block_218 block_217: {
                                                const operand_216 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_216).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_212: {
                                                    break :block_212 (&value_43);
                                                }).count, .mapping = (block_213: {
                                                    break :block_213 (&value_43);
                                                }).mapping, .order = (block_214: {
                                                    break :block_214 (&value_43);
                                                }).order, .origins = (block_215: {
                                                    break :block_215 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_217 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_216);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_220 value_44;
                                } else block_239: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_238: {
                                        break :block_238 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_237: {
                                        break :block_237 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_236: {
                                        break :block_236 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_235: {
                                            break :block_235 block_234: {
                                                const operand_233 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_233).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_221: {
                                                    break :block_221 (&value_46);
                                                }).count, .mapping = (block_222: {
                                                    break :block_222 (&value_46);
                                                }).mapping, .order = (block_223: {
                                                    break :block_223 (&value_46);
                                                }).order, .origins = block_231: {
                                                    const operand_225 = block_224: {
                                                        break :block_224 value_47;
                                                    };
                                                    const operand_227 = block_226: {
                                                        break :block_226 value_48;
                                                    };

                                                    if ((operand_227 >= (operand_225).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_229 = (block_228: {
                                                        break :block_228 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_231 block_230: {
                                                        if ((!state_items_started_174)) {
                                                            state_items_173 = (try (allocator).dupe(u64, operand_225));
                                                            state_items_started_174 = true;
                                                        }

                                                        (state_items_173)[@intCast(operand_227)] = operand_229;

                                                        break :block_230 state_items_173;
                                                    };
                                                }, .status = (block_232: {
                                                    break :block_232 (&value_46);
                                                }).status, });

                                                break :block_234 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_233);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_239 value_49;
                                });

                                break :block_240 value_50;
                            });

                            break :block_252 value_51;
                        } else value_36);

                        break :block_307 value_52;
                    });

                    break :block_308 value_53;
                } else value_13);

                break :block_325 value_54;
            };
        }

        var state_owned_326: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_326);

        if (state_capacity_started_166) {
            ((state_capacity_165).items).len = (((state_154).pending).ids).len;
            state_owned_326 = (try (state_capacity_165).toOwnedSlice(allocator));
        }

        if (state_capacity_started_166) {
            state_154 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_326, .ready = ((state_154).pending).ready, }), .plan = (state_154).plan, .request = (state_154).request, };
        }

        var state_owned_327: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_327);

        if (state_capacity_started_168) {
            ((state_capacity_167).items).len = (((state_154).pending).ready).len;
            state_owned_327 = (try (state_capacity_167).toOwnedSlice(allocator));
        }

        if (state_capacity_started_168) {
            state_154 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_154).pending).ids, .ready = state_owned_327, }), .plan = (state_154).plan, .request = (state_154).request, };
        }

        break :block_334 block_333: {
            break :block_333 (if (((state_154).zx_origin != null)) ((state_154).zx_origin.?).* else block_332: {
                break :block_332 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_154).pending).zx_origin != null)) ((state_154).pending).zx_origin.? else block_329: {
                    const operand_328 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_328).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_154).pending).ids, .ready = ((state_154).pending).ready, };

                    break :block_329 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_328);
                }), .plan = (state_154).plan, .request = (if ((((state_154).request).zx_origin != null)) ((state_154).request).zx_origin.? else block_331: {
                    const operand_330 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_330).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_154).request).maximum_count, .names = ((state_154).request).names, .origins = ((state_154).request).origins, .roots = ((state_154).request).roots, .scalar_count = ((state_154).request).scalar_count, .table = ((state_154).request).table, };

                    break :block_331 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_330);
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

    if ((block_541: {
        const operand_539 = ((in).state).mapping;
        const operand_540 = (in).index;

        if ((operand_540 >= (operand_539).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_541 (operand_539)[@intCast(operand_540)];
    } != @as(u64, 0))) {
        return ((in).state).*;
    }

    const value_1: []const u64 = block_538: {
        const operand_537 = (in).index;

        break :block_538 (try (allocator).dupe(u64, (&[_]u64{operand_537, })));
    };

    const value_2: []const bool = block_536: {
        const operand_535 = false;

        break :block_536 (try (allocator).dupe(bool, (&[_]bool{operand_535, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_534: {
        const operand_352 = block_351: {
            const operand_343 = (in).request;
            const operand_344 = (in).state;

            const operand_345 = block_350: {
                const operand_346 = value_1;
                const operand_347 = value_2;

                break :block_350 block_349: {
                    const operand_348 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_348).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_346, .ready = operand_347, });

                    break :block_349 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_348);
                };
            };

            break :block_351 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_343, .plan = operand_344, .pending = operand_345, };
        };

        var state_capacity_353: (std).ArrayList(u64) = .empty;
        var state_capacity_started_354 = false;

        defer (state_capacity_353).deinit(allocator);

        var state_capacity_355: (std).ArrayList(bool) = .empty;
        var state_capacity_started_356 = false;

        defer (state_capacity_355).deinit(allocator);

        var state_capacity_357: (std).ArrayList(u64) = .empty;
        var state_capacity_started_358 = false;

        defer (state_capacity_357).deinit(allocator);

        var state_capacity_359: (std).ArrayList(u32) = .empty;
        var state_capacity_started_360 = false;

        defer (state_capacity_359).deinit(allocator);

        var state_capacity_361: (std).ArrayList(u64) = .empty;
        var state_capacity_started_362 = false;

        defer (state_capacity_361).deinit(allocator);

        var state_342: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_352).pending).ids, .ready = ((operand_352).pending).ready, .zx_origin = (operand_352).pending, }, .plan = (operand_352).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_352).request).maximum_count, .names = ((operand_352).request).names, .origins = ((operand_352).request).origins, .roots = ((operand_352).request).roots, .scalar_count = ((operand_352).request).scalar_count, .table = ((operand_352).request).table, .zx_origin = (operand_352).request, }, .zx_origin = (&operand_352), };

        while (((((state_342).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_342).pending).ids).len) > @as(u64, 0)))) {
            state_342 = block_516: {
                const value_5: u64 = (@as(u64, (((state_342).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_515: {
                    const operand_513 = ((state_342).pending).ids;

                    const operand_514 = block_512: {
                        break :block_512 value_5;
                    };

                    if ((operand_514 >= (operand_513).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_515 (operand_513)[@intCast(operand_514)];
                };
                const value_7: bool = block_511: {
                    const operand_509 = ((state_342).pending).ready;

                    const operand_510 = block_508: {
                        break :block_508 value_5;
                    };

                    if ((operand_510 >= (operand_509).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_511 (operand_509)[@intCast(operand_510)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_342;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_507: {
                    break :block_507 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_506: {
                        break :block_506 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_505: {
                            const operand_504 = ((state_342).pending).ids;

                            break :block_505 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_504).len == 0)) .{ operand_504, null, null, } else .{ (operand_504)[0..((operand_504).len - 1)], (operand_504)[((operand_504).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_503: {
                    break :block_503 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_502: {
                        break :block_502 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_501: {
                            const operand_500 = ((value_10).pending).ready;

                            break :block_501 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_500).len == 0)) .{ operand_500, null, null, } else .{ (operand_500)[0..((operand_500).len - 1)], (operand_500)[((operand_500).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_366: {
                    const operand_364 = ((value_13).plan).mapping;

                    const operand_365 = block_363: {
                        break :block_363 value_6;
                    };

                    if ((operand_365 >= (operand_364).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_366 (operand_364)[@intCast(operand_365)];
                } == @as(u64, 0))) block_499: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_367: {
                        break :block_367 value_7;
                    })) block_386: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_385: {
                            break :block_385 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_384: {
                                break :block_384 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_383: {
                                    const operand_380 = ((value_13).pending).ids;

                                    const operand_382 = block_381: {
                                        break :block_381 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_380).len, 1));

                                    if ((!state_capacity_started_354)) {
                                        (try (state_capacity_353).appendSlice(allocator, operand_380));

                                        state_capacity_started_354 = true;
                                    } else {
                                        ((state_capacity_353).items).len = (operand_380).len;
                                    }

                                    (try (state_capacity_353).append(allocator, operand_382));

                                    break :block_383 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_353).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_379: {
                            break :block_379 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_378: {
                                break :block_378 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_377: {
                                    const operand_375 = ((value_16).pending).ready;
                                    const operand_376 = true;

                                    _ = (try ((std).math).add(usize, (operand_375).len, 1));

                                    if ((!state_capacity_started_356)) {
                                        (try (state_capacity_355).appendSlice(allocator, operand_375));
                                        state_capacity_started_356 = true;
                                    } else {
                                        ((state_capacity_355).items).len = (operand_375).len;
                                    }

                                    (try (state_capacity_355).append(allocator, operand_376));

                                    break :block_377 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_355).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_374: {
                            break :block_374 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_373: {
                                break :block_373 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_372: {
                                    const operand_368 = ((value_19).request).table;

                                    const operand_369 = block_370: {
                                        break :block_370 value_6;
                                    };

                                    const operand_371 = (value_19).pending;

                                    break :block_372 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_368, .index = operand_369, .pending = operand_371, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_353), .started = (&state_capacity_started_354), }, .lane_1 = .{ .buffer = (&state_capacity_355), .started = (&state_capacity_started_356), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_386 value_21;
                    } else block_498: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_497: {
                            break :block_497 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_496: {
                            break :block_496 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_495: {
                            break :block_495 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_494: {
                                break :block_494 block_493: {
                                    const operand_492 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_492).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_479: {
                                        break :block_479 (&value_24);
                                    }).count, .mapping = block_488: {
                                        const operand_481 = block_480: {
                                            break :block_480 value_25;
                                        };
                                        const operand_483 = block_482: {
                                            break :block_482 value_26;
                                        };

                                        if ((operand_483 >= (operand_481).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_485 = (block_484: {
                                            break :block_484 value_22;
                                        } + @as(u64, 1));

                                        break :block_488 @as([]const u64, (if (((buffers).lane_0 != null)) block_486: {
                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_481));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_481).len;
                                            }

                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_483)] = operand_485;

                                            break :block_486 ((((buffers).lane_0.?).buffer).*).items;
                                        } else block_487: {
                                            if ((!state_capacity_started_358)) {
                                                (try (state_capacity_357).appendSlice(allocator, operand_481));
                                                state_capacity_started_358 = true;
                                            } else {
                                                ((state_capacity_357).items).len = (operand_481).len;
                                            }

                                            ((state_capacity_357).items)[@intCast(operand_483)] = operand_485;

                                            break :block_487 (state_capacity_357).items;
                                        }));
                                    }, .order = (block_489: {
                                        break :block_489 (&value_24);
                                    }).order, .origins = (block_490: {
                                        break :block_490 (&value_24);
                                    }).origins, .status = (block_491: {
                                        break :block_491 (&value_24);
                                    }).status, });

                                    break :block_493 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_492);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_478: {
                            break :block_478 (&value_29);
                        }).order;
                        const value_31: u64 = block_477: {
                            break :block_477 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_476: {
                            break :block_476 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_475: {
                                break :block_475 block_474: {
                                    const operand_473 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_473).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_458: {
                                        break :block_458 (&value_29);
                                    }).count, .mapping = (block_459: {
                                        break :block_459 (&value_29);
                                    }).mapping, .order = block_470: {
                                        const operand_461 = block_460: {
                                            break :block_460 value_30;
                                        };
                                        const operand_463 = block_462: {
                                            break :block_462 value_31;
                                        };

                                        if ((operand_463 >= (operand_461).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_467 = block_466: {
                                            const operand_465 = block_464: {
                                                break :block_464 value_6;
                                            };

                                            break :block_466 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_465));
                                        };

                                        break :block_470 @as([]const u32, (if (((buffers).lane_1 != null)) block_468: {
                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_461));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_461).len;
                                            }

                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_463)] = operand_467;

                                            break :block_468 ((((buffers).lane_1.?).buffer).*).items;
                                        } else block_469: {
                                            if ((!state_capacity_started_360)) {
                                                (try (state_capacity_359).appendSlice(allocator, operand_461));

                                                state_capacity_started_360 = true;
                                            } else {
                                                ((state_capacity_359).items).len = (operand_461).len;
                                            }

                                            ((state_capacity_359).items)[@intCast(operand_463)] = operand_467;

                                            break :block_469 (state_capacity_359).items;
                                        }));
                                    }, .origins = (block_471: {
                                        break :block_471 (&value_29);
                                    }).origins, .status = (block_472: {
                                        break :block_472 (&value_29);
                                    }).status, });

                                    break :block_474 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_473);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_457: {
                            break :block_457 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_456: {
                            break :block_456 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_455: {
                                break :block_455 block_454: {
                                    const operand_453 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_453).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_448: {
                                        break :block_448 value_35;
                                    } + @as(u64, 1)), .mapping = (block_449: {
                                        break :block_449 (&value_34);
                                    }).mapping, .order = (block_450: {
                                        break :block_450 (&value_34);
                                    }).order, .origins = (block_451: {
                                        break :block_451 (&value_34);
                                    }).origins, .status = (block_452: {
                                        break :block_452 (&value_34);
                                    }).status, });

                                    break :block_454 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_453);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_447: {
                            const operand_446 = block_445: {
                                const operand_443 = (((value_36).request).table).kinds;

                                const operand_444 = block_442: {
                                    break :block_442 value_6;
                                };

                                if ((operand_444 >= (operand_443).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_445 (operand_443)[@intCast(operand_444)];
                            };

                            break :block_447 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_446));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_387: {
                            break :block_387 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_388: {
                            break :block_388 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_441: {
                            const value_38: u64 = block_440: {
                                const operand_430 = ((value_36).request).origins;
                                const operand_431 = ((value_36).request).names;
                                const operand_433 = block_432: {
                                    break :block_432 value_6;
                                };
                                const operand_438 = block_437: {
                                    const operand_435 = (((value_36).request).table).labels;

                                    const operand_436 = block_434: {
                                        break :block_434 value_6;
                                    };

                                    if ((operand_436 >= (operand_435).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_437 (operand_435)[@intCast(operand_436)];
                                };

                                const operand_439 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_430, .names = operand_431, .index = operand_433, .name = operand_438, };

                                break :block_440 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_439)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_389: {
                                break :block_389 value_38;
                            } == @as(u64, 0))) block_398: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_397: {
                                    break :block_397 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_396: {
                                        break :block_396 block_395: {
                                            const operand_394 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_394).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_390: {
                                                break :block_390 (&value_40);
                                            }).count, .mapping = (block_391: {
                                                break :block_391 (&value_40);
                                            }).mapping, .order = (block_392: {
                                                break :block_392 (&value_40);
                                            }).order, .origins = (block_393: {
                                                break :block_393 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_395 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_394);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_398 value_41;
                            } else block_429: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_399: {
                                    break :block_399 value_38;
                                } == @as(u64, 1))) block_408: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_407: {
                                        break :block_407 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_406: {
                                            break :block_406 block_405: {
                                                const operand_404 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_404).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_400: {
                                                    break :block_400 (&value_43);
                                                }).count, .mapping = (block_401: {
                                                    break :block_401 (&value_43);
                                                }).mapping, .order = (block_402: {
                                                    break :block_402 (&value_43);
                                                }).order, .origins = (block_403: {
                                                    break :block_403 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_405 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_404);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_408 value_44;
                                } else block_428: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_427: {
                                        break :block_427 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_426: {
                                        break :block_426 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_425: {
                                        break :block_425 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_424: {
                                            break :block_424 block_423: {
                                                const operand_422 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_422).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_409: {
                                                    break :block_409 (&value_46);
                                                }).count, .mapping = (block_410: {
                                                    break :block_410 (&value_46);
                                                }).mapping, .order = (block_411: {
                                                    break :block_411 (&value_46);
                                                }).order, .origins = block_420: {
                                                    const operand_413 = block_412: {
                                                        break :block_412 value_47;
                                                    };
                                                    const operand_415 = block_414: {
                                                        break :block_414 value_48;
                                                    };

                                                    if ((operand_415 >= (operand_413).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_417 = (block_416: {
                                                        break :block_416 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_420 @as([]const u64, (if (((buffers).lane_2 != null)) block_418: {
                                                        if ((!(((buffers).lane_2.?).started).*)) {
                                                            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_413));
                                                            (((buffers).lane_2.?).started).* = true;
                                                        } else {
                                                            (((((buffers).lane_2.?).buffer).*).items).len = (operand_413).len;
                                                        }

                                                        (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_415)] = operand_417;

                                                        break :block_418 ((((buffers).lane_2.?).buffer).*).items;
                                                    } else block_419: {
                                                        if ((!state_capacity_started_362)) {
                                                            (try (state_capacity_361).appendSlice(allocator, operand_413));

                                                            state_capacity_started_362 = true;
                                                        } else {
                                                            ((state_capacity_361).items).len = (operand_413).len;
                                                        }

                                                        ((state_capacity_361).items)[@intCast(operand_415)] = operand_417;
                                                        break :block_419 (state_capacity_361).items;
                                                    }));
                                                }, .status = (block_421: {
                                                    break :block_421 (&value_46);
                                                }).status, });

                                                break :block_423 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_422);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_428 value_49;
                                });

                                break :block_429 value_50;
                            });

                            break :block_441 value_51;
                        } else value_36);

                        break :block_498 value_52;
                    });

                    break :block_499 value_53;
                } else value_13);

                break :block_516 value_54;
            };
        }

        var state_owned_517: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_517);

        if (state_capacity_started_354) {
            ((state_capacity_353).items).len = (((state_342).pending).ids).len;
            state_owned_517 = (try (state_capacity_353).toOwnedSlice(allocator));
        }

        if (state_capacity_started_354) {
            state_342 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_517, .ready = ((state_342).pending).ready, }), .plan = (state_342).plan, .request = (state_342).request, };
        }

        var state_owned_518: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_518);

        if (state_capacity_started_356) {
            ((state_capacity_355).items).len = (((state_342).pending).ready).len;
            state_owned_518 = (try (state_capacity_355).toOwnedSlice(allocator));
        }

        if (state_capacity_started_356) {
            state_342 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_342).pending).ids, .ready = state_owned_518, }), .plan = (state_342).plan, .request = (state_342).request, };
        }

        var state_owned_519: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_519);

        if (state_capacity_started_358) {
            ((state_capacity_357).items).len = (((state_342).plan).mapping).len;
            state_owned_519 = (try (state_capacity_357).toOwnedSlice(allocator));
        }

        if (state_capacity_started_358) {
            state_342 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_342).pending, .plan = block_521: {
                const operand_520 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_520).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_342).plan).count, .mapping = state_owned_519, .order = ((state_342).plan).order, .origins = ((state_342).plan).origins, .status = ((state_342).plan).status, });

                break :block_521 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_520);
            }, .request = (state_342).request, };
        }

        var state_owned_522: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_522);

        if (state_capacity_started_360) {
            ((state_capacity_359).items).len = (((state_342).plan).order).len;
            state_owned_522 = (try (state_capacity_359).toOwnedSlice(allocator));
        }

        if (state_capacity_started_360) {
            state_342 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_342).pending, .plan = block_524: {
                const operand_523 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_523).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_342).plan).count, .mapping = ((state_342).plan).mapping, .order = state_owned_522, .origins = ((state_342).plan).origins, .status = ((state_342).plan).status, });

                break :block_524 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_523);
            }, .request = (state_342).request, };
        }

        var state_owned_525: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_525);

        if (state_capacity_started_362) {
            ((state_capacity_361).items).len = (((state_342).plan).origins).len;
            state_owned_525 = (try (state_capacity_361).toOwnedSlice(allocator));
        }

        if (state_capacity_started_362) {
            state_342 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_342).pending, .plan = block_527: {
                const operand_526 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_526).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_342).plan).count, .mapping = ((state_342).plan).mapping, .order = ((state_342).plan).order, .origins = state_owned_525, .status = ((state_342).plan).status, });

                break :block_527 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_526);
            }, .request = (state_342).request, };
        }

        break :block_534 block_533: {
            break :block_533 (if (((state_342).zx_origin != null)) ((state_342).zx_origin.?).* else block_532: {
                break :block_532 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_342).pending).zx_origin != null)) ((state_342).pending).zx_origin.? else block_529: {
                    const operand_528 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_528).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_342).pending).ids, .ready = ((state_342).pending).ready, };

                    break :block_529 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_528);
                }), .plan = (state_342).plan, .request = (if ((((state_342).request).zx_origin != null)) ((state_342).request).zx_origin.? else block_531: {
                    const operand_530 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_530).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_342).request).maximum_count, .names = ((state_342).request).names, .origins = ((state_342).request).origins, .roots = ((state_342).request).roots, .scalar_count = ((state_342).request).scalar_count, .table = ((state_342).request).table, };

                    break :block_531 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_530);
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

    if ((block_700: {
        const operand_698 = ((in).state).mapping;
        const operand_699 = (in).index;

        if ((operand_699 >= (operand_698).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_700 (operand_698)[@intCast(operand_699)];
    } != @as(u64, 0))) {
        return (in).state;
    }

    const value_1: []const u64 = block_697: {
        const operand_696 = (in).index;

        break :block_697 (try (allocator).dupe(u64, (&[_]u64{operand_696, })));
    };

    const value_2: []const bool = block_695: {
        const operand_694 = false;

        break :block_695 (try (allocator).dupe(bool, (&[_]bool{operand_694, })));
    };

    const value_55: *const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_693: {
        const operand_554 = block_553: {
            const operand_543 = (in).request;
            const operand_544 = (in).state;

            const operand_545 = block_550: {
                const operand_546 = value_1;
                const operand_547 = value_2;

                break :block_550 block_549: {
                    const operand_548 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_548).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_546, .ready = operand_547, });

                    break :block_549 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_548);
                };
            };

            break :block_553 block_552: {
                const operand_551 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_551).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_543, .plan = operand_544, .pending = operand_545, });

                break :block_552 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_551);
            };
        };

        var state_capacity_556: (std).ArrayList(u64) = .empty;
        var state_capacity_started_557 = false;

        defer (state_capacity_556).deinit(allocator);

        var state_capacity_558: (std).ArrayList(bool) = .empty;
        var state_capacity_started_559 = false;

        defer (state_capacity_558).deinit(allocator);

        var state_capacity_560: (std).ArrayList(u64) = .empty;
        var state_capacity_started_561 = false;

        defer (state_capacity_560).deinit(allocator);

        var state_capacity_562: (std).ArrayList(u32) = .empty;
        var state_capacity_started_563 = false;

        defer (state_capacity_562).deinit(allocator);

        var state_capacity_564: (std).ArrayList(u64) = .empty;
        var state_capacity_started_565 = false;

        defer (state_capacity_564).deinit(allocator);

        const state_type_569 = struct {
            ids: []const u64,
            ready: []const bool,
        };
        const state_type_570 = struct {
            count: u64,
            mapping: []const u64,
            order: []const u32,
            origins: []const u64,
            status: (zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
        };
        const state_type_571 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };
        const state_type_572 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_573 = struct {
            maximum_count: u64,
            names: []const []const u8,
            origins: state_type_571,
            roots: []const bool,
            scalar_count: u64,
            table: state_type_572,
        };
        const state_type_574 = struct {
            pending: state_type_569,
            plan: state_type_570,
            request: state_type_573,
        };
        const state_type_575 = struct {
            index: u64,
            pending: state_type_569,
            table: state_type_572,
        };
        const state_type_591 = struct { []const bool, void, };
        const state_type_597 = struct { []const u64, void, };

        const state_type_620 = struct {
            index: u64,
            name: []const u8,
            names: []const []const u8,
            origins: state_type_571,
        };
        const state_type_658 = struct { []const bool, ?bool, };
        const state_type_663 = struct { []const u64, ?u64, };
        var state_542: state_type_574 = state_type_574{ .pending = state_type_569{ .ids = ((operand_554).pending).ids, .ready = ((operand_554).pending).ready, }, .plan = state_type_570{ .count = ((operand_554).plan).count, .mapping = ((operand_554).plan).mapping, .order = ((operand_554).plan).order, .origins = ((operand_554).plan).origins, .status = ((operand_554).plan).status, }, .request = state_type_573{ .maximum_count = ((operand_554).request).maximum_count, .names = ((operand_554).request).names, .origins = state_type_571{ .ids = (((operand_554).request).origins).ids, .kinds = (((operand_554).request).origins).kinds, .members = (((operand_554).request).origins).members, .owners = (((operand_554).request).origins).owners, }, .roots = ((operand_554).request).roots, .scalar_count = ((operand_554).request).scalar_count, .table = state_type_572{ .children = (((operand_554).request).table).children, .field_names = (((operand_554).request).table).field_names, .field_types = (((operand_554).request).table).field_types, .first = (((operand_554).request).table).first, .kinds = (((operand_554).request).table).kinds, .labels = (((operand_554).request).table).labels, .names = (((operand_554).request).table).names, .second = (((operand_554).request).table).second, }, }, };
        var state_changed_555 = false;

        while (((((state_542).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_542).pending).ids).len) > @as(u64, 0)))) {
            state_542 = block_674: {
                const value_5: u64 = (@as(u64, (((state_542).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_673: {
                    const operand_671 = ((state_542).pending).ids;
                    const operand_672 = value_5;

                    if ((operand_672 >= (operand_671).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_673 (operand_671)[@intCast(operand_672)];
                };
                const value_7: bool = block_670: {
                    const operand_668 = ((state_542).pending).ready;
                    const operand_669 = value_5;

                    if ((operand_669 >= (operand_668).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_670 (operand_668)[@intCast(operand_669)];
                };
                const value_8: state_type_574 = state_542;
                const value_9: state_type_569 = (value_8).pending;

                const value_10: state_type_574 = block_667: {
                    break :block_667 state_type_574{ .pending = block_666: {
                        break :block_666 state_type_569{ .ids = (block_665: {
                            const operand_664 = ((state_542).pending).ids;

                            break :block_665 @as(state_type_663, (if (((operand_664).len == 0)) .{ operand_664, null, } else .{ (operand_664)[0..((operand_664).len - 1)], (operand_664)[((operand_664).len - 1)], }));
                        }).@"0", .ready = (value_9).ready, };
                    }, .plan = (value_8).plan, .request = (value_8).request, };
                };

                const value_11: state_type_574 = value_10;
                const value_12: state_type_569 = (value_11).pending;

                const value_13: state_type_574 = block_662: {
                    break :block_662 state_type_574{ .pending = block_661: {
                        break :block_661 state_type_569{ .ids = (value_12).ids, .ready = (block_660: {
                            const operand_659 = ((value_10).pending).ready;

                            break :block_660 @as(state_type_658, (if (((operand_659).len == 0)) .{ operand_659, null, } else .{ (operand_659)[0..((operand_659).len - 1)], (operand_659)[((operand_659).len - 1)], }));
                        }).@"0", };
                    }, .plan = (value_11).plan, .request = (value_11).request, };
                };
                const value_54: state_type_574 = (if ((block_568: {
                    const operand_566 = ((value_13).plan).mapping;
                    const operand_567 = value_6;

                    if ((operand_567 >= (operand_566).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_568 (operand_566)[@intCast(operand_567)];
                } == @as(u64, 0))) block_657: {
                    const value_53: state_type_574 = (if ((!value_7)) block_603: {
                        const value_14: state_type_574 = value_13;
                        const value_15: state_type_569 = (value_14).pending;
                        const value_16: state_type_574 = block_602: {
                            break :block_602 state_type_574{ .pending = block_601: {
                                break :block_601 state_type_569{ .ids = (block_600: {
                                    const operand_598 = ((value_13).pending).ids;
                                    const operand_599 = value_6;

                                    _ = (try ((std).math).add(usize, (operand_598).len, 1));

                                    if ((!state_capacity_started_557)) {
                                        (try (state_capacity_556).appendSlice(allocator, operand_598));
                                        state_capacity_started_557 = true;
                                    } else {
                                        ((state_capacity_556).items).len = (operand_598).len;
                                    }

                                    (try (state_capacity_556).append(allocator, operand_599));

                                    break :block_600 @as(state_type_597, .{ (state_capacity_556).items, {}, });
                                }).@"0", .ready = (value_15).ready, };
                            }, .plan = (value_14).plan, .request = (value_14).request, };
                        };
                        const value_17: state_type_574 = value_16;
                        const value_18: state_type_569 = (value_17).pending;

                        const value_19: state_type_574 = block_596: {
                            break :block_596 state_type_574{ .pending = block_595: {
                                break :block_595 state_type_569{ .ids = (value_18).ids, .ready = (block_594: {
                                    const operand_592 = ((value_16).pending).ready;
                                    const operand_593 = true;

                                    _ = (try ((std).math).add(usize, (operand_592).len, 1));

                                    if ((!state_capacity_started_559)) {
                                        (try (state_capacity_558).appendSlice(allocator, operand_592));

                                        state_capacity_started_559 = true;
                                    } else {
                                        ((state_capacity_558).items).len = (operand_592).len;
                                    }

                                    (try (state_capacity_558).append(allocator, operand_593));

                                    break :block_594 @as(state_type_591, .{ (state_capacity_558).items, {}, });
                                }).@"0", };
                            }, .plan = (value_17).plan, .request = (value_17).request, };
                        };
                        const value_20: state_type_574 = value_19;

                        const value_21: state_type_574 = block_590: {
                            break :block_590 state_type_574{ .pending = block_589: {
                                const operand_580 = block_579: {
                                    const operand_576 = ((value_19).request).table;
                                    const operand_577 = value_6;
                                    const operand_578 = (value_19).pending;

                                    break :block_579 state_type_575{ .table = operand_576, .index = operand_577, .pending = operand_578, };
                                };

                                const operand_581 = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((operand_580).pending).ids, .ready = ((operand_580).pending).ready, };
                                const operand_582 = (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = ((operand_580).table).children, .field_names = ((operand_580).table).field_names, .field_types = ((operand_580).table).field_types, .first = ((operand_580).table).first, .kinds = ((operand_580).table).kinds, .labels = ((operand_580).table).labels, .names = ((operand_580).table).names, .second = ((operand_580).table).second, };
                                const operand_583 = (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a{ .index = (operand_580).index, .pending = (&operand_581), .table = (&operand_582), };
                                const operand_588 = block_587: {
                                    const operand_584 = (&operand_583);
                                    const operand_585 = (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .index = (operand_584).index, .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_584).pending).ids, .ready = ((operand_584).pending).ready, .zx_origin = (operand_584).pending, }, .table = (operand_584).table, .zx_origin = operand_584, }, .{ .lane_0 = .{ .buffer = (&state_capacity_556), .started = (&state_capacity_started_557), }, .lane_1 = .{ .buffer = (&state_capacity_558), .started = (&state_capacity_started_559), }, }));

                                    break :block_587 (if (((operand_585).zx_origin != null)) ((operand_585).zx_origin.?).* else block_586: {
                                        break :block_586 (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = (operand_585).ids, .ready = (operand_585).ready, };
                                    });
                                };

                                break :block_589 state_type_569{ .ids = (operand_588).ids, .ready = (operand_588).ready, };
                            }, .plan = (value_20).plan, .request = (value_20).request, };
                        };

                        break :block_603 value_21;
                    } else block_656: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: state_type_574 = value_13;
                        const value_24: state_type_570 = (value_23).plan;
                        const value_25: []const u64 = (value_24).mapping;
                        const value_26: u64 = value_6;
                        const value_27: state_type_574 = block_655: {
                            break :block_655 state_type_574{ .pending = (value_23).pending, .plan = block_654: {
                                break :block_654 state_type_570{ .count = (value_24).count, .mapping = block_653: {
                                    const operand_648 = value_25;
                                    const operand_649 = value_26;

                                    if ((operand_649 >= (operand_648).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_650 = (value_22 + @as(u64, 1));

                                    break :block_653 @as([]const u64, (if (((buffers).lane_0 != null)) block_651: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_648));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_648).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_649)] = operand_650;

                                        break :block_651 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_652: {
                                        if ((!state_capacity_started_561)) {
                                            (try (state_capacity_560).appendSlice(allocator, operand_648));

                                            state_capacity_started_561 = true;
                                        } else {
                                            ((state_capacity_560).items).len = (operand_648).len;
                                        }

                                        ((state_capacity_560).items)[@intCast(operand_649)] = operand_650;

                                        break :block_652 (state_capacity_560).items;
                                    }));
                                }, .order = (value_24).order, .origins = (value_24).origins, .status = (value_24).status, };
                            }, .request = (value_23).request, };
                        };
                        const value_28: state_type_574 = value_27;
                        const value_29: state_type_570 = (value_28).plan;
                        const value_30: []const u32 = (value_29).order;
                        const value_31: u64 = value_22;
                        const value_32: state_type_574 = block_647: {
                            break :block_647 state_type_574{ .pending = (value_28).pending, .plan = block_646: {
                                break :block_646 state_type_570{ .count = (value_29).count, .mapping = (value_29).mapping, .order = block_645: {
                                    const operand_640 = value_30;
                                    const operand_641 = value_31;

                                    if ((operand_641 >= (operand_640).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_642 = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, value_6));

                                    break :block_645 @as([]const u32, (if (((buffers).lane_1 != null)) block_643: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_640));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_640).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_641)] = operand_642;

                                        break :block_643 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_644: {
                                        if ((!state_capacity_started_563)) {
                                            (try (state_capacity_562).appendSlice(allocator, operand_640));

                                            state_capacity_started_563 = true;
                                        } else {
                                            ((state_capacity_562).items).len = (operand_640).len;
                                        }

                                        ((state_capacity_562).items)[@intCast(operand_641)] = operand_642;

                                        break :block_644 (state_capacity_562).items;
                                    }));
                                }, .origins = (value_29).origins, .status = (value_29).status, };
                            }, .request = (value_28).request, };
                        };
                        const value_33: state_type_574 = value_32;
                        const value_34: state_type_570 = (value_33).plan;
                        const value_35: u64 = (value_34).count;

                        const value_36: state_type_574 = block_639: {
                            break :block_639 state_type_574{ .pending = (value_33).pending, .plan = block_638: {
                                break :block_638 state_type_570{ .count = (value_35 + @as(u64, 1)), .mapping = (value_34).mapping, .order = (value_34).order, .origins = (value_34).origins, .status = (value_34).status, };
                            }, .request = (value_33).request, };
                        };

                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_637: {
                            const operand_635 = (((value_36).request).table).kinds;
                            const operand_636 = value_6;

                            if ((operand_636 >= (operand_635).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_637 (operand_635)[@intCast(operand_636)];
                        }));

                        const value_52: state_type_574 = (if (((value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (value_37 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_634: {
                            const value_38: u64 = block_633: {
                                const operand_629 = block_628: {
                                    const operand_621 = ((value_36).request).origins;
                                    const operand_622 = ((value_36).request).names;
                                    const operand_623 = value_6;
                                    const operand_627 = block_626: {
                                        const operand_624 = (((value_36).request).table).labels;
                                        const operand_625 = value_6;

                                        if ((operand_625 >= (operand_624).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_626 (operand_624)[@intCast(operand_625)];
                                    };

                                    break :block_628 state_type_620{ .origins = operand_621, .names = operand_622, .index = operand_623, .name = operand_627, };
                                };

                                const operand_630 = (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = ((operand_629).origins).ids, .kinds = ((operand_629).origins).kinds, .members = ((operand_629).origins).members, .owners = ((operand_629).origins).owners, };
                                const operand_631 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .index = (operand_629).index, .name = (operand_629).name, .names = (operand_629).names, .origins = (&operand_630), };
                                const operand_632 = (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_631)));

                                break :block_633 operand_632;
                            };
                            const value_51: state_type_574 = (if ((value_38 == @as(u64, 0))) block_606: {
                                const value_39: state_type_574 = value_36;
                                const value_40: state_type_570 = (value_39).plan;

                                const value_41: state_type_574 = block_605: {
                                    break :block_605 state_type_574{ .pending = (value_39).pending, .plan = block_604: {
                                        break :block_604 state_type_570{ .count = (value_40).count, .mapping = (value_40).mapping, .order = (value_40).order, .origins = (value_40).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), };
                                    }, .request = (value_39).request, };
                                };

                                break :block_606 value_41;
                            } else block_619: {
                                const value_50: state_type_574 = (if ((value_38 == @as(u64, 1))) block_609: {
                                    const value_42: state_type_574 = value_36;
                                    const value_43: state_type_570 = (value_42).plan;

                                    const value_44: state_type_574 = block_608: {
                                        break :block_608 state_type_574{ .pending = (value_42).pending, .plan = block_607: {
                                            break :block_607 state_type_570{ .count = (value_43).count, .mapping = (value_43).mapping, .order = (value_43).order, .origins = (value_43).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), };
                                        }, .request = (value_42).request, };
                                    };

                                    break :block_609 value_44;
                                } else block_618: {
                                    const value_45: state_type_574 = value_36;
                                    const value_46: state_type_570 = (value_45).plan;
                                    const value_47: []const u64 = (value_46).origins;
                                    const value_48: u64 = value_22;
                                    const value_49: state_type_574 = block_617: {
                                        break :block_617 state_type_574{ .pending = (value_45).pending, .plan = block_616: {
                                            break :block_616 state_type_570{ .count = (value_46).count, .mapping = (value_46).mapping, .order = (value_46).order, .origins = block_615: {
                                                const operand_610 = value_47;
                                                const operand_611 = value_48;

                                                if ((operand_611 >= (operand_610).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_612 = (value_38 - @as(u64, 1));

                                                break :block_615 @as([]const u64, (if (((buffers).lane_2 != null)) block_613: {
                                                    if ((!(((buffers).lane_2.?).started).*)) {
                                                        (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_610));
                                                        (((buffers).lane_2.?).started).* = true;
                                                    } else {
                                                        (((((buffers).lane_2.?).buffer).*).items).len = (operand_610).len;
                                                    }

                                                    (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_611)] = operand_612;

                                                    break :block_613 ((((buffers).lane_2.?).buffer).*).items;
                                                } else block_614: {
                                                    if ((!state_capacity_started_565)) {
                                                        (try (state_capacity_564).appendSlice(allocator, operand_610));

                                                        state_capacity_started_565 = true;
                                                    } else {
                                                        ((state_capacity_564).items).len = (operand_610).len;
                                                    }

                                                    ((state_capacity_564).items)[@intCast(operand_611)] = operand_612;
                                                    break :block_614 (state_capacity_564).items;
                                                }));
                                            }, .status = (value_46).status, };
                                        }, .request = (value_45).request, };
                                    };

                                    break :block_618 value_49;
                                });

                                break :block_619 value_50;
                            });

                            break :block_634 value_51;
                        } else value_36);

                        break :block_656 value_52;
                    });

                    break :block_657 value_53;
                } else value_13);

                break :block_674 value_54;
            };

            state_changed_555 = true;
        }

        var state_owned_675: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_675);

        if (state_capacity_started_557) {
            ((state_capacity_556).items).len = (((state_542).pending).ids).len;
            state_owned_675 = (try (state_capacity_556).toOwnedSlice(allocator));
        }

        if (state_capacity_started_557) {
            ((state_542).pending).ids = state_owned_675;
        }

        var state_owned_676: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_676);

        if (state_capacity_started_559) {
            ((state_capacity_558).items).len = (((state_542).pending).ready).len;
            state_owned_676 = (try (state_capacity_558).toOwnedSlice(allocator));
        }

        if (state_capacity_started_559) {
            ((state_542).pending).ready = state_owned_676;
        }

        var state_owned_677: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_677);

        if (state_capacity_started_561) {
            ((state_capacity_560).items).len = (((state_542).plan).mapping).len;
            state_owned_677 = (try (state_capacity_560).toOwnedSlice(allocator));
        }

        if (state_capacity_started_561) {
            ((state_542).plan).mapping = state_owned_677;
        }

        var state_owned_678: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_678);

        if (state_capacity_started_563) {
            ((state_capacity_562).items).len = (((state_542).plan).order).len;
            state_owned_678 = (try (state_capacity_562).toOwnedSlice(allocator));
        }

        if (state_capacity_started_563) {
            ((state_542).plan).order = state_owned_678;
        }

        var state_owned_679: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_679);

        if (state_capacity_started_565) {
            ((state_capacity_564).items).len = (((state_542).plan).origins).len;
            state_owned_679 = (try (state_capacity_564).toOwnedSlice(allocator));
        }

        if (state_capacity_started_565) {
            ((state_542).plan).origins = state_owned_679;
        }

        break :block_693 (if (state_changed_555) block_692: {
            const operand_691 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

            (operand_691).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = block_682: {
                const operand_681 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_681).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_542).pending).ids, .ready = ((state_542).pending).ready, });

                break :block_682 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_681);
            }, .plan = block_684: {
                const operand_683 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_683).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_542).plan).count, .mapping = ((state_542).plan).mapping, .order = ((state_542).plan).order, .origins = ((state_542).plan).origins, .status = ((state_542).plan).status, });

                break :block_684 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_683);
            }, .request = block_690: {
                const operand_689 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                (operand_689).* = @as((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_542).request).maximum_count, .names = ((state_542).request).names, .origins = block_686: {
                    const operand_685 = (try (allocator).create((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a));

                    (operand_685).* = @as((zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a{ .ids = (((state_542).request).origins).ids, .kinds = (((state_542).request).origins).kinds, .members = (((state_542).request).origins).members, .owners = (((state_542).request).origins).owners, });

                    break :block_686 @as(*const (zx_abi).zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a, operand_685);
                }, .roots = ((state_542).request).roots, .scalar_count = ((state_542).request).scalar_count, .table = block_688: {
                    const operand_687 = (try (allocator).create((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f));

                    (operand_687).* = @as((zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f{ .children = (((state_542).request).table).children, .field_names = (((state_542).request).table).field_names, .field_types = (((state_542).request).table).field_types, .first = (((state_542).request).table).first, .kinds = (((state_542).request).table).kinds, .labels = (((state_542).request).table).labels, .names = (((state_542).request).table).names, .second = (((state_542).request).table).second, });

                    break :block_688 @as(*const (zx_abi).zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f, operand_687);
                }, });

                break :block_690 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_689);
            }, });

            break :block_692 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_691);
        } else operand_554);
    };

    return (value_55).plan;
}

