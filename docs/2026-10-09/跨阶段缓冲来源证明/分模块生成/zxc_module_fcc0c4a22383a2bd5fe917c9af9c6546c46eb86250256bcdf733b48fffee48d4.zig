const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac = (in).pending;

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_93: {
        const operand_91 = ((in).table).kinds;
        const operand_92 = (in).index;

        if ((operand_92 >= (operand_91).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_93 (operand_91)[@intCast(operand_92)];
    }));

    if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_27: {
            const operand_1 = (block_15: {
                const operand_9 = (block_8: {
                    const operand_2 = (value_1).ids;

                    const operand_6 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_5: {
                        const operand_3 = ((in).table).first;
                        const operand_4 = (in).index;

                        if ((operand_4 >= (operand_3).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_5 (operand_3)[@intCast(operand_4)];
                    }));

                    const operand_7 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_2).len, 1))));

                    @memcpy((operand_7)[0..(operand_2).len], operand_2);

                    (operand_7)[(operand_2).len] = operand_6;

                    break :block_8 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_7, {}, });
                }).@"0";

                const operand_13 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_12: {
                    const operand_10 = ((in).table).second;
                    const operand_11 = (in).index;

                    if ((operand_11 >= (operand_10).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_12 (operand_10)[@intCast(operand_11)];
                }));

                const operand_14 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_9).len, 1))));

                @memcpy((operand_14)[0..(operand_9).len], operand_9);

                (operand_14)[(operand_9).len] = operand_13;

                break :block_15 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_14, {}, });
            }).@"0";
            const operand_16 = (block_24: {
                const operand_21 = (block_20: {
                    const operand_17 = (value_1).ready;
                    const operand_18 = false;
                    const operand_19 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_17).len, 1))));

                    @memcpy((operand_19)[0..(operand_17).len], operand_17);

                    (operand_19)[(operand_17).len] = operand_18;

                    break :block_20 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_19, {}, });
                }).@"0";

                const operand_22 = false;
                const operand_23 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_21).len, 1))));

                @memcpy((operand_23)[0..(operand_21).len], operand_21);

                (operand_23)[(operand_21).len] = operand_22;

                break :block_24 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_23, {}, });
            }).@"0";

            break :block_27 block_26: {
                const operand_25 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_25).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_1, .ready = operand_16, });

                break :block_26 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_25);
            };
        };
    } else {
        if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_43: {
                const operand_28 = (block_35: {
                    const operand_29 = (value_1).ids;

                    const operand_33 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_32: {
                        const operand_30 = ((in).table).first;
                        const operand_31 = (in).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    }));

                    const operand_34 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_29).len, 1))));

                    @memcpy((operand_34)[0..(operand_29).len], operand_29);

                    (operand_34)[(operand_29).len] = operand_33;

                    break :block_35 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_34, {}, });
                }).@"0";
                const operand_36 = (block_40: {
                    const operand_37 = (value_1).ready;
                    const operand_38 = false;
                    const operand_39 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_37).len, 1))));

                    @memcpy((operand_39)[0..(operand_37).len], operand_37);

                    (operand_39)[(operand_37).len] = operand_38;

                    break :block_40 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_39, {}, });
                }).@"0";

                break :block_43 block_42: {
                    const operand_41 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_41).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_28, .ready = operand_36, });

                    break :block_42 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_41);
                };
            };
        } else {
            if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: *const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = block_90: {
                    const operand_58 = block_57: {
                        const operand_45 = value_3;

                        const operand_46 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_49: {
                            const operand_47 = ((in).table).first;
                            const operand_48 = (in).index;

                            if ((operand_48 >= (operand_47).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_49 (operand_47)[@intCast(operand_48)];
                        }));

                        const operand_50 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_53: {
                            const operand_51 = ((in).table).second;
                            const operand_52 = (in).index;

                            if ((operand_52 >= (operand_51).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_53 (operand_51)[@intCast(operand_52)];
                        }));

                        const operand_54 = value_1;

                        break :block_57 block_56: {
                            const operand_55 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                            (operand_55).* = @as((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .values = operand_45, .first = operand_46, .remaining = operand_50, .pending = operand_54, });

                            break :block_56 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_55);
                        };
                    };

                    var state_capacity_60: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_61 = false;

                    defer (state_capacity_60).deinit(allocator);

                    var state_capacity_62: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_63 = false;

                    defer (state_capacity_62).deinit(allocator);

                    const state_type_64 = struct {
                        ids: []const u64,
                        ready: []const bool,
                    };
                    const state_type_65 = struct {
                        first: u64,
                        pending: state_type_64,
                        remaining: u64,
                        values: []const u32,
                    };

                    const state_type_66 = struct { []const bool, void, };
                    const state_type_72 = struct { []const u64, void, };
                    var state_44: state_type_65 = state_type_65{ .first = (operand_58).first, .pending = state_type_64{ .ids = ((operand_58).pending).ids, .ready = ((operand_58).pending).ready, }, .remaining = (operand_58).remaining, .values = (operand_58).values, };
                    var state_changed_59 = false;

                    while (((state_44).remaining > @as(u64, 0))) {
                        state_44 = block_82: {
                            const value_6: state_type_65 = state_44;
                            const value_7: u64 = (value_6).remaining;
                            const value_8: state_type_65 = block_81: {
                                break :block_81 state_type_65{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (value_7 - @as(u64, 1)), .values = (value_6).values, };
                            };
                            const value_9: state_type_65 = value_8;
                            const value_10: state_type_64 = (value_9).pending;
                            const value_11: state_type_65 = block_80: {
                                break :block_80 state_type_65{ .first = (value_9).first, .pending = block_79: {
                                    break :block_79 state_type_64{ .ids = (block_78: {
                                        const operand_73 = ((value_8).pending).ids;

                                        const operand_77 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_76: {
                                            const operand_74 = (value_8).values;
                                            const operand_75 = ((value_8).first + (value_8).remaining);

                                            if ((operand_75 >= (operand_74).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_76 (operand_74)[@intCast(operand_75)];
                                        }));

                                        _ = (try ((std).math).add(usize, (operand_73).len, 1));

                                        if ((!state_capacity_started_61)) {
                                            (try (state_capacity_60).appendSlice(allocator, operand_73));

                                            state_capacity_started_61 = true;
                                        } else {
                                            ((state_capacity_60).items).len = (operand_73).len;
                                        }

                                        (try (state_capacity_60).append(allocator, operand_77));

                                        break :block_78 @as(state_type_72, .{ (state_capacity_60).items, {}, });
                                    }).@"0", .ready = (value_10).ready, };
                                }, .remaining = (value_9).remaining, .values = (value_9).values, };
                            };
                            const value_12: state_type_65 = value_11;
                            const value_13: state_type_64 = (value_12).pending;

                            const value_14: state_type_65 = block_71: {
                                break :block_71 state_type_65{ .first = (value_12).first, .pending = block_70: {
                                    break :block_70 state_type_64{ .ids = (value_13).ids, .ready = (block_69: {
                                        const operand_67 = ((value_11).pending).ready;
                                        const operand_68 = false;

                                        _ = (try ((std).math).add(usize, (operand_67).len, 1));

                                        if ((!state_capacity_started_63)) {
                                            (try (state_capacity_62).appendSlice(allocator, operand_67));
                                            state_capacity_started_63 = true;
                                        } else {
                                            ((state_capacity_62).items).len = (operand_67).len;
                                        }

                                        (try (state_capacity_62).append(allocator, operand_68));

                                        break :block_69 @as(state_type_66, .{ (state_capacity_62).items, {}, });
                                    }).@"0", };
                                }, .remaining = (value_12).remaining, .values = (value_12).values, };
                            };

                            break :block_82 value_14;
                        };

                        state_changed_59 = true;
                    }

                    var state_owned_83: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_83);

                    if (state_capacity_started_61) {
                        ((state_capacity_60).items).len = (((state_44).pending).ids).len;
                        state_owned_83 = (try (state_capacity_60).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_61) {
                        ((state_44).pending).ids = state_owned_83;
                    }

                    var state_owned_84: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_84);

                    if (state_capacity_started_63) {
                        ((state_capacity_62).items).len = (((state_44).pending).ready).len;
                        state_owned_84 = (try (state_capacity_62).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_63) {
                        ((state_44).pending).ready = state_owned_84;
                    }

                    break :block_90 (if (state_changed_59) block_89: {
                        const operand_88 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                        (operand_88).* = @as((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .first = (state_44).first, .pending = block_87: {
                            const operand_86 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                            (operand_86).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_44).pending).ids, .ready = ((state_44).pending).ready, });

                            break :block_87 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_86);
                        }, .remaining = (state_44).remaining, .values = (state_44).values, });

                        break :block_89 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_88);
                    } else operand_58);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (in).pending;

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_194: {
        const operand_193 = block_192: {
            const operand_190 = ((in).table).kinds;
            const operand_191 = (in).index;

            if ((operand_191 >= (operand_190).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_192 (operand_190)[@intCast(operand_191)];
        };

        break :block_194 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_193));
    };

    if ((block_94: {
        break :block_94 value_2;
    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_123: {
            const operand_95 = (block_113: {
                const operand_105 = (block_104: {
                    const operand_96 = (value_1).ids;

                    const operand_102 = block_101: {
                        const operand_100 = block_99: {
                            const operand_97 = ((in).table).first;
                            const operand_98 = (in).index;

                            if ((operand_98 >= (operand_97).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_99 (operand_97)[@intCast(operand_98)];
                        };

                        break :block_101 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_100));
                    };

                    const operand_103 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_96).len, 1))));

                    @memcpy((operand_103)[0..(operand_96).len], operand_96);

                    (operand_103)[(operand_96).len] = operand_102;

                    break :block_104 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_103, {}, null, });
                }).@"0";
                const operand_111 = block_110: {
                    const operand_109 = block_108: {
                        const operand_106 = ((in).table).second;
                        const operand_107 = (in).index;

                        if ((operand_107 >= (operand_106).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_108 (operand_106)[@intCast(operand_107)];
                    };

                    break :block_110 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_109));
                };

                const operand_112 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_105).len, 1))));

                @memcpy((operand_112)[0..(operand_105).len], operand_105);

                (operand_112)[(operand_105).len] = operand_111;

                break :block_113 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_112, {}, null, });
            }).@"0";

            const operand_114 = (block_122: {
                const operand_119 = (block_118: {
                    const operand_115 = (value_1).ready;
                    const operand_116 = false;
                    const operand_117 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_115).len, 1))));

                    @memcpy((operand_117)[0..(operand_115).len], operand_115);

                    (operand_117)[(operand_115).len] = operand_116;

                    break :block_118 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_117, {}, null, });
                }).@"0";
                const operand_120 = false;
                const operand_121 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_119).len, 1))));

                @memcpy((operand_121)[0..(operand_119).len], operand_119);

                (operand_121)[(operand_119).len] = operand_120;

                break :block_122 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_121, {}, null, });
            }).@"0";

            break :block_123 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_95, .ready = operand_114, });
        };
    } else {
        if (((block_124: {
            break :block_124 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (block_125: {
            break :block_125 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_141: {
                const operand_126 = (block_135: {
                    const operand_127 = (value_1).ids;

                    const operand_133 = block_132: {
                        const operand_131 = block_130: {
                            const operand_128 = ((in).table).first;
                            const operand_129 = (in).index;

                            if ((operand_129 >= (operand_128).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_130 (operand_128)[@intCast(operand_129)];
                        };

                        break :block_132 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_131));
                    };

                    const operand_134 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_127).len, 1))));

                    @memcpy((operand_134)[0..(operand_127).len], operand_127);

                    (operand_134)[(operand_127).len] = operand_133;

                    break :block_135 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_134, {}, null, });
                }).@"0";

                const operand_136 = (block_140: {
                    const operand_137 = (value_1).ready;
                    const operand_138 = false;
                    const operand_139 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_137).len, 1))));

                    @memcpy((operand_139)[0..(operand_137).len], operand_137);

                    (operand_139)[(operand_137).len] = operand_138;

                    break :block_140 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_139, {}, null, });
                }).@"0";

                break :block_141 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_126, .ready = operand_136, });
            };
        } else {
            if (((block_142: {
                break :block_142 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (block_143: {
                break :block_143 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((block_189: {
                    break :block_189 value_2;
                } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_188: {
                    const operand_161 = block_160: {
                        const operand_145 = block_146: {
                            break :block_146 value_3;
                        };
                        const operand_147 = block_152: {
                            const operand_151 = block_150: {
                                const operand_148 = ((in).table).first;
                                const operand_149 = (in).index;

                                if ((operand_149 >= (operand_148).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_150 (operand_148)[@intCast(operand_149)];
                            };

                            break :block_152 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_151));
                        };
                        const operand_153 = block_158: {
                            const operand_157 = block_156: {
                                const operand_154 = ((in).table).second;
                                const operand_155 = (in).index;

                                if ((operand_155 >= (operand_154).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_156 (operand_154)[@intCast(operand_155)];
                            };

                            break :block_158 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_157));
                        };

                        const operand_159 = value_1;

                        break :block_160 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_145, .first = operand_147, .remaining = operand_153, .pending = operand_159, });
                    };

                    var state_capacity_163: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_164 = false;

                    defer (state_capacity_163).deinit(allocator);

                    var state_capacity_165: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_166 = false;

                    defer (state_capacity_165).deinit(allocator);

                    var state_144: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_161;
                    var state_changed_162 = false;

                    while (((state_144).remaining > @as(u64, 0))) {
                        state_144 = block_184: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_144;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_183: {
                                break :block_183 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_182: {
                                    break :block_182 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_181: {
                                break :block_181 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_180: {
                                    break :block_180 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_179: {
                                        const operand_172 = ((value_8).pending).ids;

                                        const operand_178 = block_177: {
                                            const operand_176 = block_175: {
                                                const operand_173 = (value_8).values;
                                                const operand_174 = ((value_8).first + (value_8).remaining);

                                                if ((operand_174 >= (operand_173).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_175 (operand_173)[@intCast(operand_174)];
                                            };

                                            break :block_177 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_176));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_172).len, 1));

                                        if ((!state_capacity_started_164)) {
                                            (try (state_capacity_163).appendSlice(allocator, operand_172));

                                            state_capacity_started_164 = true;
                                        } else {
                                            ((state_capacity_163).items).len = (operand_172).len;
                                        }

                                        (try (state_capacity_163).append(allocator, operand_178));

                                        break :block_179 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_163).items, {}, null, });
                                    }).@"0", .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_171: {
                                break :block_171 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_170: {
                                    break :block_170 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = (block_169: {
                                        const operand_167 = ((value_11).pending).ready;
                                        const operand_168 = false;

                                        _ = (try ((std).math).add(usize, (operand_167).len, 1));

                                        if ((!state_capacity_started_166)) {
                                            (try (state_capacity_165).appendSlice(allocator, operand_167));

                                            state_capacity_started_166 = true;
                                        } else {
                                            ((state_capacity_165).items).len = (operand_167).len;
                                        }

                                        (try (state_capacity_165).append(allocator, operand_168));

                                        break :block_169 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_165).items, {}, null, });
                                    }).@"0", });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_184 value_14;
                        };

                        state_changed_162 = true;
                    }

                    var state_owned_185: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_185);

                    if (state_capacity_started_164) {
                        ((state_capacity_163).items).len = (((state_144).pending).ids).len;
                        state_owned_185 = (try (state_capacity_163).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_164) {
                        state_144 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_144).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_185, .ready = ((state_144).pending).ready, }), .remaining = (state_144).remaining, .values = (state_144).values, };
                    }

                    var state_owned_186: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_186);

                    if (state_capacity_started_166) {
                        ((state_capacity_165).items).len = (((state_144).pending).ready).len;
                        state_owned_186 = (try (state_capacity_165).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_166) {
                        state_144 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_144).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_144).pending).ids, .ready = state_owned_186, }), .remaining = (state_144).remaining, .values = (state_144).values, };
                    }

                    break :block_188 (if (state_changed_162) state_144 else operand_161);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (in).pending;

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_363: {
        const operand_362 = block_361: {
            const operand_359 = ((in).table).kinds;
            const operand_360 = (in).index;

            if ((operand_360 >= (operand_359).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_361 (operand_359)[@intCast(operand_360)];
        };

        break :block_363 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_362));
    };

    if ((block_195: {
        break :block_195 value_2;
    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_270: {
            const operand_196 = @as([]const u64, (if (((buffers).lane_0 != null)) block_221: {
                const operand_214 = @as([]const u64, (if (((buffers).lane_0 != null)) block_204: {
                    const operand_197 = (value_1).ids;

                    const operand_203 = block_202: {
                        const operand_201 = block_200: {
                            const operand_198 = ((in).table).first;
                            const operand_199 = (in).index;

                            if ((operand_199 >= (operand_198).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_200 (operand_198)[@intCast(operand_199)];
                        };

                        break :block_202 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_201));
                    };

                    _ = (try ((std).math).add(usize, (operand_197).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_197));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_197).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_203));

                    break :block_204 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_213: {
                    const operand_205 = (value_1).ids;
                    const operand_211 = block_210: {
                        const operand_209 = block_208: {
                            const operand_206 = ((in).table).first;
                            const operand_207 = (in).index;

                            if ((operand_207 >= (operand_206).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_208 (operand_206)[@intCast(operand_207)];
                        };

                        break :block_210 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_209));
                    };

                    const operand_212 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_205).len, 1))));

                    @memcpy((operand_212)[0..(operand_205).len], operand_205);

                    (operand_212)[(operand_205).len] = operand_211;

                    break :block_213 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_212, {}, null, });
                }).@"0"));

                const operand_220 = block_219: {
                    const operand_218 = block_217: {
                        const operand_215 = ((in).table).second;
                        const operand_216 = (in).index;

                        if ((operand_216 >= (operand_215).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_217 (operand_215)[@intCast(operand_216)];
                    };

                    break :block_219 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_218));
                };

                _ = (try ((std).math).add(usize, (operand_214).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_214));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_214).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_220));

                break :block_221 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_247: {
                const operand_239 = @as([]const u64, (if (((buffers).lane_0 != null)) block_229: {
                    const operand_222 = (value_1).ids;
                    const operand_228 = block_227: {
                        const operand_226 = block_225: {
                            const operand_223 = ((in).table).first;
                            const operand_224 = (in).index;

                            if ((operand_224 >= (operand_223).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_225 (operand_223)[@intCast(operand_224)];
                        };

                        break :block_227 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_226));
                    };

                    _ = (try ((std).math).add(usize, (operand_222).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_222));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_222).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_228));

                    break :block_229 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_238: {
                    const operand_230 = (value_1).ids;

                    const operand_236 = block_235: {
                        const operand_234 = block_233: {
                            const operand_231 = ((in).table).first;
                            const operand_232 = (in).index;

                            if ((operand_232 >= (operand_231).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_233 (operand_231)[@intCast(operand_232)];
                        };

                        break :block_235 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_234));
                    };

                    const operand_237 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_230).len, 1))));

                    @memcpy((operand_237)[0..(operand_230).len], operand_230);
                    (operand_237)[(operand_230).len] = operand_236;

                    break :block_238 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_237, {}, null, });
                }).@"0"));

                const operand_245 = block_244: {
                    const operand_243 = block_242: {
                        const operand_240 = ((in).table).second;
                        const operand_241 = (in).index;

                        if ((operand_241 >= (operand_240).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_242 (operand_240)[@intCast(operand_241)];
                    };

                    break :block_244 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_243));
                };

                const operand_246 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_239).len, 1))));

                @memcpy((operand_246)[0..(operand_239).len], operand_239);

                (operand_246)[(operand_239).len] = operand_245;

                break :block_247 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_246, {}, null, });
            }).@"0"));

            const operand_248 = @as([]const bool, (if (((buffers).lane_1 != null)) block_258: {
                const operand_256 = @as([]const bool, (if (((buffers).lane_1 != null)) block_251: {
                    const operand_249 = (value_1).ready;
                    const operand_250 = false;

                    _ = (try ((std).math).add(usize, (operand_249).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_249));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_249).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_250));

                    break :block_251 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_255: {
                    const operand_252 = (value_1).ready;
                    const operand_253 = false;
                    const operand_254 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_252).len, 1))));

                    @memcpy((operand_254)[0..(operand_252).len], operand_252);

                    (operand_254)[(operand_252).len] = operand_253;

                    break :block_255 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_254, {}, null, });
                }).@"0"));

                const operand_257 = false;

                _ = (try ((std).math).add(usize, (operand_256).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_256));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_256).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_257));

                break :block_258 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_269: {
                const operand_266 = @as([]const bool, (if (((buffers).lane_1 != null)) block_261: {
                    const operand_259 = (value_1).ready;
                    const operand_260 = false;

                    _ = (try ((std).math).add(usize, (operand_259).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_259));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_259).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_260));

                    break :block_261 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_265: {
                    const operand_262 = (value_1).ready;
                    const operand_263 = false;
                    const operand_264 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_262).len, 1))));

                    @memcpy((operand_264)[0..(operand_262).len], operand_262);

                    (operand_264)[(operand_262).len] = operand_263;

                    break :block_265 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_264, {}, null, });
                }).@"0"));

                const operand_267 = false;
                const operand_268 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_266).len, 1))));

                @memcpy((operand_268)[0..(operand_266).len], operand_266);

                (operand_268)[(operand_266).len] = operand_267;

                break :block_269 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_268, {}, null, });
            }).@"0"));

            break :block_270 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_196, .ready = operand_248, });
        };
    } else {
        if (((block_271: {
            break :block_271 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (block_272: {
            break :block_272 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_299: {
                const operand_273 = @as([]const u64, (if (((buffers).lane_0 != null)) block_281: {
                    const operand_274 = (value_1).ids;

                    const operand_280 = block_279: {
                        const operand_278 = block_277: {
                            const operand_275 = ((in).table).first;
                            const operand_276 = (in).index;

                            if ((operand_276 >= (operand_275).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_277 (operand_275)[@intCast(operand_276)];
                        };

                        break :block_279 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_278));
                    };

                    _ = (try ((std).math).add(usize, (operand_274).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_274));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_274).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_280));

                    break :block_281 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_290: {
                    const operand_282 = (value_1).ids;

                    const operand_288 = block_287: {
                        const operand_286 = block_285: {
                            const operand_283 = ((in).table).first;
                            const operand_284 = (in).index;

                            if ((operand_284 >= (operand_283).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_285 (operand_283)[@intCast(operand_284)];
                        };

                        break :block_287 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_286));
                    };

                    const operand_289 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_282).len, 1))));

                    @memcpy((operand_289)[0..(operand_282).len], operand_282);

                    (operand_289)[(operand_282).len] = operand_288;

                    break :block_290 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_289, {}, null, });
                }).@"0"));

                const operand_291 = @as([]const bool, (if (((buffers).lane_1 != null)) block_294: {
                    const operand_292 = (value_1).ready;
                    const operand_293 = false;

                    _ = (try ((std).math).add(usize, (operand_292).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_292));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_292).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_293));

                    break :block_294 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_298: {
                    const operand_295 = (value_1).ready;
                    const operand_296 = false;
                    const operand_297 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_295).len, 1))));

                    @memcpy((operand_297)[0..(operand_295).len], operand_295);

                    (operand_297)[(operand_295).len] = operand_296;

                    break :block_298 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_297, {}, null, });
                }).@"0"));

                break :block_299 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_273, .ready = operand_291, });
            };
        } else {
            if (((block_300: {
                break :block_300 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (block_301: {
                break :block_301 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((block_358: {
                    break :block_358 value_2;
                } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_357: {
                    const operand_319 = block_318: {
                        const operand_303 = block_304: {
                            break :block_304 value_3;
                        };
                        const operand_305 = block_310: {
                            const operand_309 = block_308: {
                                const operand_306 = ((in).table).first;
                                const operand_307 = (in).index;

                                if ((operand_307 >= (operand_306).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_308 (operand_306)[@intCast(operand_307)];
                            };

                            break :block_310 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_309));
                        };
                        const operand_311 = block_316: {
                            const operand_315 = block_314: {
                                const operand_312 = ((in).table).second;
                                const operand_313 = (in).index;

                                if ((operand_313 >= (operand_312).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_314 (operand_312)[@intCast(operand_313)];
                            };

                            break :block_316 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_315));
                        };

                        const operand_317 = value_1;

                        break :block_318 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_303, .first = operand_305, .remaining = operand_311, .pending = operand_317, });
                    };

                    var state_capacity_321: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_322 = false;

                    defer (state_capacity_321).deinit(allocator);

                    var state_capacity_323: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_324 = false;

                    defer (state_capacity_323).deinit(allocator);

                    var state_302: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_319;
                    var state_changed_320 = false;

                    while (((state_302).remaining > @as(u64, 0))) {
                        state_302 = block_353: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_302;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_352: {
                                break :block_352 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_351: {
                                    break :block_351 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_350: {
                                break :block_350 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_349: {
                                    break :block_349 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = @as([]const u64, (if (((buffers).lane_0 != null)) block_340: {
                                        const operand_333 = ((value_8).pending).ids;

                                        const operand_339 = block_338: {
                                            const operand_337 = block_336: {
                                                const operand_334 = (value_8).values;
                                                const operand_335 = ((value_8).first + (value_8).remaining);

                                                if ((operand_335 >= (operand_334).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_336 (operand_334)[@intCast(operand_335)];
                                            };

                                            break :block_338 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_337));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_333).len, 1));

                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_333));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_333).len;
                                        }

                                        (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_339));

                                        break :block_340 ((((buffers).lane_0.?).buffer).*).items;
                                    } else (block_348: {
                                        const operand_341 = ((value_8).pending).ids;
                                        const operand_347 = block_346: {
                                            const operand_345 = block_344: {
                                                const operand_342 = (value_8).values;
                                                const operand_343 = ((value_8).first + (value_8).remaining);

                                                if ((operand_343 >= (operand_342).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_344 (operand_342)[@intCast(operand_343)];
                                            };

                                            break :block_346 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_345));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_341).len, 1));

                                        if ((!state_capacity_started_322)) {
                                            (try (state_capacity_321).appendSlice(allocator, operand_341));
                                            state_capacity_started_322 = true;
                                        } else {
                                            ((state_capacity_321).items).len = (operand_341).len;
                                        }

                                        (try (state_capacity_321).append(allocator, operand_347));

                                        break :block_348 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_321).items, {}, null, });
                                    }).@"0")), .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_332: {
                                break :block_332 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_331: {
                                    break :block_331 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = @as([]const bool, (if (((buffers).lane_1 != null)) block_327: {
                                        const operand_325 = ((value_11).pending).ready;
                                        const operand_326 = false;

                                        _ = (try ((std).math).add(usize, (operand_325).len, 1));

                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_325));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_325).len;
                                        }

                                        (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_326));

                                        break :block_327 ((((buffers).lane_1.?).buffer).*).items;
                                    } else (block_330: {
                                        const operand_328 = ((value_11).pending).ready;
                                        const operand_329 = false;

                                        _ = (try ((std).math).add(usize, (operand_328).len, 1));

                                        if ((!state_capacity_started_324)) {
                                            (try (state_capacity_323).appendSlice(allocator, operand_328));
                                            state_capacity_started_324 = true;
                                        } else {
                                            ((state_capacity_323).items).len = (operand_328).len;
                                        }

                                        (try (state_capacity_323).append(allocator, operand_329));
                                        break :block_330 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_323).items, {}, null, });
                                    }).@"0")), });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_353 value_14;
                        };

                        state_changed_320 = true;
                    }

                    var state_owned_354: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_354);

                    if (state_capacity_started_322) {
                        ((state_capacity_321).items).len = (((state_302).pending).ids).len;
                        state_owned_354 = (try (state_capacity_321).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_322) {
                        state_302 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_302).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_354, .ready = ((state_302).pending).ready, }), .remaining = (state_302).remaining, .values = (state_302).values, };
                    }

                    var state_owned_355: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_355);

                    if (state_capacity_started_324) {
                        ((state_capacity_323).items).len = (((state_302).pending).ready).len;
                        state_owned_355 = (try (state_capacity_323).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_324) {
                        state_302 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_302).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_302).pending).ids, .ready = state_owned_355, }), .remaining = (state_302).remaining, .values = (state_302).values, };
                    }

                    break :block_357 (if (state_changed_320) state_302 else operand_319);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac = (in).pending;

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_516: {
        const operand_514 = ((in).table).kinds;
        const operand_515 = (in).index;

        if ((operand_515 >= (operand_514).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_516 (operand_514)[@intCast(operand_515)];
    }));

    if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_428: {
            const operand_364 = @as([]const u64, (if (((buffers).lane_0 != null)) block_383: {
                const operand_378 = @as([]const u64, (if (((buffers).lane_0 != null)) block_370: {
                    const operand_365 = (value_1).ids;

                    const operand_369 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_368: {
                        const operand_366 = ((in).table).first;
                        const operand_367 = (in).index;

                        if ((operand_367 >= (operand_366).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_368 (operand_366)[@intCast(operand_367)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_365).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_365));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_365).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_369));

                    break :block_370 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_377: {
                    const operand_371 = (value_1).ids;

                    const operand_375 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_374: {
                        const operand_372 = ((in).table).first;
                        const operand_373 = (in).index;

                        if ((operand_373 >= (operand_372).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_374 (operand_372)[@intCast(operand_373)];
                    }));

                    const operand_376 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_371).len, 1))));

                    @memcpy((operand_376)[0..(operand_371).len], operand_371);

                    (operand_376)[(operand_371).len] = operand_375;

                    break :block_377 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_376, {}, });
                }).@"0"));

                const operand_382 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_381: {
                    const operand_379 = ((in).table).second;
                    const operand_380 = (in).index;

                    if ((operand_380 >= (operand_379).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_381 (operand_379)[@intCast(operand_380)];
                }));

                _ = (try ((std).math).add(usize, (operand_378).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_378));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_378).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_382));

                break :block_383 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_403: {
                const operand_397 = @as([]const u64, (if (((buffers).lane_0 != null)) block_389: {
                    const operand_384 = (value_1).ids;

                    const operand_388 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_387: {
                        const operand_385 = ((in).table).first;
                        const operand_386 = (in).index;

                        if ((operand_386 >= (operand_385).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_387 (operand_385)[@intCast(operand_386)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_384).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_384));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_384).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_388));

                    break :block_389 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_396: {
                    const operand_390 = (value_1).ids;

                    const operand_394 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_393: {
                        const operand_391 = ((in).table).first;
                        const operand_392 = (in).index;

                        if ((operand_392 >= (operand_391).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_393 (operand_391)[@intCast(operand_392)];
                    }));

                    const operand_395 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_390).len, 1))));

                    @memcpy((operand_395)[0..(operand_390).len], operand_390);

                    (operand_395)[(operand_390).len] = operand_394;

                    break :block_396 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_395, {}, });
                }).@"0"));

                const operand_401 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_400: {
                    const operand_398 = ((in).table).second;
                    const operand_399 = (in).index;

                    if ((operand_399 >= (operand_398).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_400 (operand_398)[@intCast(operand_399)];
                }));

                const operand_402 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_397).len, 1))));

                @memcpy((operand_402)[0..(operand_397).len], operand_397);

                (operand_402)[(operand_397).len] = operand_401;

                break :block_403 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_402, {}, });
            }).@"0"));

            const operand_404 = @as([]const bool, (if (((buffers).lane_1 != null)) block_414: {
                const operand_412 = @as([]const bool, (if (((buffers).lane_1 != null)) block_407: {
                    const operand_405 = (value_1).ready;
                    const operand_406 = false;

                    _ = (try ((std).math).add(usize, (operand_405).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_405));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_405).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_406));

                    break :block_407 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_411: {
                    const operand_408 = (value_1).ready;
                    const operand_409 = false;
                    const operand_410 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_408).len, 1))));

                    @memcpy((operand_410)[0..(operand_408).len], operand_408);
                    (operand_410)[(operand_408).len] = operand_409;

                    break :block_411 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_410, {}, });
                }).@"0"));

                const operand_413 = false;

                _ = (try ((std).math).add(usize, (operand_412).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_412));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_412).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_413));

                break :block_414 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_425: {
                const operand_422 = @as([]const bool, (if (((buffers).lane_1 != null)) block_417: {
                    const operand_415 = (value_1).ready;
                    const operand_416 = false;

                    _ = (try ((std).math).add(usize, (operand_415).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_415));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_415).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_416));

                    break :block_417 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_421: {
                    const operand_418 = (value_1).ready;
                    const operand_419 = false;
                    const operand_420 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_418).len, 1))));

                    @memcpy((operand_420)[0..(operand_418).len], operand_418);

                    (operand_420)[(operand_418).len] = operand_419;

                    break :block_421 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_420, {}, });
                }).@"0"));

                const operand_423 = false;
                const operand_424 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_422).len, 1))));

                @memcpy((operand_424)[0..(operand_422).len], operand_422);

                (operand_424)[(operand_422).len] = operand_423;

                break :block_425 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_424, {}, });
            }).@"0"));

            break :block_428 block_427: {
                const operand_426 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_426).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_364, .ready = operand_404, });

                break :block_427 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_426);
            };
        };
    } else {
        if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_453: {
                const operand_429 = @as([]const u64, (if (((buffers).lane_0 != null)) block_435: {
                    const operand_430 = (value_1).ids;

                    const operand_434 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_433: {
                        const operand_431 = ((in).table).first;
                        const operand_432 = (in).index;

                        if ((operand_432 >= (operand_431).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_433 (operand_431)[@intCast(operand_432)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_430).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_430));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_430).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_434));

                    break :block_435 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_442: {
                    const operand_436 = (value_1).ids;

                    const operand_440 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_439: {
                        const operand_437 = ((in).table).first;
                        const operand_438 = (in).index;

                        if ((operand_438 >= (operand_437).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_439 (operand_437)[@intCast(operand_438)];
                    }));

                    const operand_441 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_436).len, 1))));

                    @memcpy((operand_441)[0..(operand_436).len], operand_436);

                    (operand_441)[(operand_436).len] = operand_440;

                    break :block_442 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_441, {}, });
                }).@"0"));

                const operand_443 = @as([]const bool, (if (((buffers).lane_1 != null)) block_446: {
                    const operand_444 = (value_1).ready;
                    const operand_445 = false;

                    _ = (try ((std).math).add(usize, (operand_444).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_444));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_444).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_445));

                    break :block_446 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_450: {
                    const operand_447 = (value_1).ready;
                    const operand_448 = false;
                    const operand_449 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_447).len, 1))));

                    @memcpy((operand_449)[0..(operand_447).len], operand_447);

                    (operand_449)[(operand_447).len] = operand_448;

                    break :block_450 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_449, {}, });
                }).@"0"));

                break :block_453 block_452: {
                    const operand_451 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_451).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_429, .ready = operand_443, });

                    break :block_452 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_451);
                };
            };
        } else {
            if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: *const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = block_513: {
                    const operand_468 = block_467: {
                        const operand_455 = value_3;

                        const operand_456 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_459: {
                            const operand_457 = ((in).table).first;
                            const operand_458 = (in).index;

                            if ((operand_458 >= (operand_457).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_459 (operand_457)[@intCast(operand_458)];
                        }));

                        const operand_460 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_463: {
                            const operand_461 = ((in).table).second;
                            const operand_462 = (in).index;

                            if ((operand_462 >= (operand_461).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_463 (operand_461)[@intCast(operand_462)];
                        }));

                        const operand_464 = value_1;

                        break :block_467 block_466: {
                            const operand_465 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                            (operand_465).* = @as((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .values = operand_455, .first = operand_456, .remaining = operand_460, .pending = operand_464, });

                            break :block_466 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_465);
                        };
                    };

                    var state_capacity_470: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_471 = false;

                    defer (state_capacity_470).deinit(allocator);

                    var state_capacity_472: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_473 = false;

                    defer (state_capacity_472).deinit(allocator);

                    const state_type_474 = struct {
                        ids: []const u64,
                        ready: []const bool,
                    };
                    const state_type_475 = struct {
                        first: u64,
                        pending: state_type_474,
                        remaining: u64,
                        values: []const u32,
                    };
                    const state_type_479 = struct { []const bool, void, };
                    const state_type_493 = struct { []const u64, void, };
                    var state_454: state_type_475 = state_type_475{ .first = (operand_468).first, .pending = state_type_474{ .ids = ((operand_468).pending).ids, .ready = ((operand_468).pending).ready, }, .remaining = (operand_468).remaining, .values = (operand_468).values, };
                    var state_changed_469 = false;

                    while (((state_454).remaining > @as(u64, 0))) {
                        state_454 = block_505: {
                            const value_6: state_type_475 = state_454;
                            const value_7: u64 = (value_6).remaining;
                            const value_8: state_type_475 = block_504: {
                                break :block_504 state_type_475{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (value_7 - @as(u64, 1)), .values = (value_6).values, };
                            };
                            const value_9: state_type_475 = value_8;
                            const value_10: state_type_474 = (value_9).pending;
                            const value_11: state_type_475 = block_503: {
                                break :block_503 state_type_475{ .first = (value_9).first, .pending = block_502: {
                                    break :block_502 state_type_474{ .ids = block_501: {
                                        const operand_500 = @as([]const u64, (if (((buffers).lane_0 != null)) block_492: {
                                            const operand_487 = ((value_8).pending).ids;

                                            const operand_491 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_490: {
                                                const operand_488 = (value_8).values;
                                                const operand_489 = ((value_8).first + (value_8).remaining);

                                                if ((operand_489 >= (operand_488).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_490 (operand_488)[@intCast(operand_489)];
                                            }));

                                            _ = (try ((std).math).add(usize, (operand_487).len, 1));

                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_487));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_487).len;
                                            }

                                            (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_491));

                                            break :block_492 ((((buffers).lane_0.?).buffer).*).items;
                                        } else (block_499: {
                                            const operand_494 = ((value_8).pending).ids;

                                            const operand_498 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_497: {
                                                const operand_495 = (value_8).values;
                                                const operand_496 = ((value_8).first + (value_8).remaining);

                                                if ((operand_496 >= (operand_495).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_497 (operand_495)[@intCast(operand_496)];
                                            }));

                                            _ = (try ((std).math).add(usize, (operand_494).len, 1));

                                            if ((!state_capacity_started_471)) {
                                                (try (state_capacity_470).appendSlice(allocator, operand_494));
                                                state_capacity_started_471 = true;
                                            } else {
                                                ((state_capacity_470).items).len = (operand_494).len;
                                            }

                                            (try (state_capacity_470).append(allocator, operand_498));

                                            break :block_499 @as(state_type_493, .{ (state_capacity_470).items, {}, });
                                        }).@"0"));

                                        break :block_501 operand_500;
                                    }, .ready = (value_10).ready, };
                                }, .remaining = (value_9).remaining, .values = (value_9).values, };
                            };
                            const value_12: state_type_475 = value_11;
                            const value_13: state_type_474 = (value_12).pending;
                            const value_14: state_type_475 = block_486: {
                                break :block_486 state_type_475{ .first = (value_12).first, .pending = block_485: {
                                    break :block_485 state_type_474{ .ids = (value_13).ids, .ready = block_484: {
                                        const operand_483 = @as([]const bool, (if (((buffers).lane_1 != null)) block_478: {
                                            const operand_476 = ((value_11).pending).ready;
                                            const operand_477 = false;

                                            _ = (try ((std).math).add(usize, (operand_476).len, 1));

                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_476));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_476).len;
                                            }

                                            (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_477));

                                            break :block_478 ((((buffers).lane_1.?).buffer).*).items;
                                        } else (block_482: {
                                            const operand_480 = ((value_11).pending).ready;
                                            const operand_481 = false;

                                            _ = (try ((std).math).add(usize, (operand_480).len, 1));

                                            if ((!state_capacity_started_473)) {
                                                (try (state_capacity_472).appendSlice(allocator, operand_480));
                                                state_capacity_started_473 = true;
                                            } else {
                                                ((state_capacity_472).items).len = (operand_480).len;
                                            }

                                            (try (state_capacity_472).append(allocator, operand_481));

                                            break :block_482 @as(state_type_479, .{ (state_capacity_472).items, {}, });
                                        }).@"0"));

                                        break :block_484 operand_483;
                                    }, };
                                }, .remaining = (value_12).remaining, .values = (value_12).values, };
                            };

                            break :block_505 value_14;
                        };

                        state_changed_469 = true;
                    }

                    var state_owned_506: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_506);

                    if (state_capacity_started_471) {
                        ((state_capacity_470).items).len = (((state_454).pending).ids).len;
                        state_owned_506 = (try (state_capacity_470).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_471) {
                        ((state_454).pending).ids = state_owned_506;
                    }

                    var state_owned_507: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_507);

                    if (state_capacity_started_473) {
                        ((state_capacity_472).items).len = (((state_454).pending).ready).len;
                        state_owned_507 = (try (state_capacity_472).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_473) {
                        ((state_454).pending).ready = state_owned_507;
                    }

                    break :block_513 (if (state_changed_469) block_512: {
                        const operand_511 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                        (operand_511).* = @as((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .first = (state_454).first, .pending = block_510: {
                            const operand_509 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                            (operand_509).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_454).pending).ids, .ready = ((state_454).pending).ready, });

                            break :block_510 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_509);
                        }, .remaining = (state_454).remaining, .values = (state_454).values, });

                        break :block_512 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_511);
                    } else operand_468);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

