const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac = (in).pending;

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_92: {
        const operand_90 = ((in).table).kinds;
        const operand_91 = (in).index;

        if ((operand_91 >= (operand_90).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_92 (operand_90)[@intCast(operand_91)];
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

                const value_15: *const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = block_89: {
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

                    var state_44: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (operand_58).first, .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_58).pending).ids, .ready = ((operand_58).pending).ready, .zx_origin = (operand_58).pending, }, .remaining = (operand_58).remaining, .values = (operand_58).values, .zx_origin = operand_58, };
                    var state_changed_59 = false;

                    while (((state_44).remaining > @as(u64, 0))) {
                        state_44 = block_81: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_44;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_80: {
                                break :block_80 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_79: {
                                    break :block_79 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_78: {
                                break :block_78 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_77: {
                                    break :block_77 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_76: {
                                        const operand_69 = ((value_8).pending).ids;

                                        const operand_75 = block_74: {
                                            const operand_73 = block_72: {
                                                const operand_70 = (value_8).values;
                                                const operand_71 = ((value_8).first + (value_8).remaining);

                                                if ((operand_71 >= (operand_70).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_72 (operand_70)[@intCast(operand_71)];
                                            };

                                            break :block_74 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_73));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_69).len, 1));

                                        if ((!state_capacity_started_61)) {
                                            (try (state_capacity_60).appendSlice(allocator, operand_69));

                                            state_capacity_started_61 = true;
                                        } else {
                                            ((state_capacity_60).items).len = (operand_69).len;
                                        }

                                        (try (state_capacity_60).append(allocator, operand_75));

                                        break :block_76 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_60).items, {}, null, });
                                    }).@"0", .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_68: {
                                break :block_68 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_67: {
                                    break :block_67 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = (block_66: {
                                        const operand_64 = ((value_11).pending).ready;
                                        const operand_65 = false;

                                        _ = (try ((std).math).add(usize, (operand_64).len, 1));

                                        if ((!state_capacity_started_63)) {
                                            (try (state_capacity_62).appendSlice(allocator, operand_64));
                                            state_capacity_started_63 = true;
                                        } else {
                                            ((state_capacity_62).items).len = (operand_64).len;
                                        }

                                        (try (state_capacity_62).append(allocator, operand_65));
                                        break :block_66 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_62).items, {}, null, });
                                    }).@"0", });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_81 value_14;
                        };

                        state_changed_59 = true;
                    }

                    var state_owned_82: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_82);

                    if (state_capacity_started_61) {
                        ((state_capacity_60).items).len = (((state_44).pending).ids).len;
                        state_owned_82 = (try (state_capacity_60).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_61) {
                        state_44 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_44).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_82, .ready = ((state_44).pending).ready, }), .remaining = (state_44).remaining, .values = (state_44).values, };
                    }

                    var state_owned_83: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_83);

                    if (state_capacity_started_63) {
                        ((state_capacity_62).items).len = (((state_44).pending).ready).len;
                        state_owned_83 = (try (state_capacity_62).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_63) {
                        state_44 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_44).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_44).pending).ids, .ready = state_owned_83, }), .remaining = (state_44).remaining, .values = (state_44).values, };
                    }

                    break :block_89 (if (state_changed_59) block_88: {
                        break :block_88 (if (((state_44).zx_origin != null)) (state_44).zx_origin.? else block_87: {
                            const operand_86 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                            (operand_86).* = (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .first = (state_44).first, .pending = (if ((((state_44).pending).zx_origin != null)) ((state_44).pending).zx_origin.? else block_85: {
                                const operand_84 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                                (operand_84).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_44).pending).ids, .ready = ((state_44).pending).ready, };

                                break :block_85 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_84);
                            }), .remaining = (state_44).remaining, .values = (state_44).values, };

                            break :block_87 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_86);
                        });
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

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_193: {
        const operand_192 = block_191: {
            const operand_189 = ((in).table).kinds;
            const operand_190 = (in).index;

            if ((operand_190 >= (operand_189).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_191 (operand_189)[@intCast(operand_190)];
        };

        break :block_193 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_192));
    };

    if ((block_93: {
        break :block_93 value_2;
    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_122: {
            const operand_94 = (block_112: {
                const operand_104 = (block_103: {
                    const operand_95 = (value_1).ids;

                    const operand_101 = block_100: {
                        const operand_99 = block_98: {
                            const operand_96 = ((in).table).first;
                            const operand_97 = (in).index;

                            if ((operand_97 >= (operand_96).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_98 (operand_96)[@intCast(operand_97)];
                        };

                        break :block_100 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_99));
                    };

                    const operand_102 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_95).len, 1))));

                    @memcpy((operand_102)[0..(operand_95).len], operand_95);

                    (operand_102)[(operand_95).len] = operand_101;

                    break :block_103 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_102, {}, null, });
                }).@"0";
                const operand_110 = block_109: {
                    const operand_108 = block_107: {
                        const operand_105 = ((in).table).second;
                        const operand_106 = (in).index;

                        if ((operand_106 >= (operand_105).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_107 (operand_105)[@intCast(operand_106)];
                    };

                    break :block_109 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_108));
                };

                const operand_111 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_104).len, 1))));

                @memcpy((operand_111)[0..(operand_104).len], operand_104);

                (operand_111)[(operand_104).len] = operand_110;

                break :block_112 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_111, {}, null, });
            }).@"0";
            const operand_113 = (block_121: {
                const operand_118 = (block_117: {
                    const operand_114 = (value_1).ready;
                    const operand_115 = false;
                    const operand_116 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_114).len, 1))));

                    @memcpy((operand_116)[0..(operand_114).len], operand_114);

                    (operand_116)[(operand_114).len] = operand_115;

                    break :block_117 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_116, {}, null, });
                }).@"0";
                const operand_119 = false;
                const operand_120 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_118).len, 1))));

                @memcpy((operand_120)[0..(operand_118).len], operand_118);

                (operand_120)[(operand_118).len] = operand_119;

                break :block_121 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_120, {}, null, });
            }).@"0";

            break :block_122 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_94, .ready = operand_113, });
        };
    } else {
        if (((block_123: {
            break :block_123 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (block_124: {
            break :block_124 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_140: {
                const operand_125 = (block_134: {
                    const operand_126 = (value_1).ids;

                    const operand_132 = block_131: {
                        const operand_130 = block_129: {
                            const operand_127 = ((in).table).first;
                            const operand_128 = (in).index;

                            if ((operand_128 >= (operand_127).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_129 (operand_127)[@intCast(operand_128)];
                        };

                        break :block_131 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_130));
                    };

                    const operand_133 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_126).len, 1))));

                    @memcpy((operand_133)[0..(operand_126).len], operand_126);

                    (operand_133)[(operand_126).len] = operand_132;

                    break :block_134 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_133, {}, null, });
                }).@"0";
                const operand_135 = (block_139: {
                    const operand_136 = (value_1).ready;
                    const operand_137 = false;
                    const operand_138 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_136).len, 1))));

                    @memcpy((operand_138)[0..(operand_136).len], operand_136);

                    (operand_138)[(operand_136).len] = operand_137;

                    break :block_139 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_138, {}, null, });
                }).@"0";

                break :block_140 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_125, .ready = operand_135, });
            };
        } else {
            if (((block_141: {
                break :block_141 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (block_142: {
                break :block_142 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((block_188: {
                    break :block_188 value_2;
                } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_187: {
                    const operand_160 = block_159: {
                        const operand_144 = block_145: {
                            break :block_145 value_3;
                        };
                        const operand_146 = block_151: {
                            const operand_150 = block_149: {
                                const operand_147 = ((in).table).first;
                                const operand_148 = (in).index;

                                if ((operand_148 >= (operand_147).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_149 (operand_147)[@intCast(operand_148)];
                            };

                            break :block_151 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_150));
                        };
                        const operand_152 = block_157: {
                            const operand_156 = block_155: {
                                const operand_153 = ((in).table).second;
                                const operand_154 = (in).index;

                                if ((operand_154 >= (operand_153).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_155 (operand_153)[@intCast(operand_154)];
                            };

                            break :block_157 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_156));
                        };

                        const operand_158 = value_1;

                        break :block_159 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_144, .first = operand_146, .remaining = operand_152, .pending = operand_158, });
                    };

                    var state_capacity_162: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_163 = false;

                    defer (state_capacity_162).deinit(allocator);

                    var state_capacity_164: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_165 = false;

                    defer (state_capacity_164).deinit(allocator);

                    var state_143: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_160;
                    var state_changed_161 = false;

                    while (((state_143).remaining > @as(u64, 0))) {
                        state_143 = block_183: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_143;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_182: {
                                break :block_182 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_181: {
                                    break :block_181 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_180: {
                                break :block_180 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_179: {
                                    break :block_179 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_178: {
                                        const operand_171 = ((value_8).pending).ids;

                                        const operand_177 = block_176: {
                                            const operand_175 = block_174: {
                                                const operand_172 = (value_8).values;
                                                const operand_173 = ((value_8).first + (value_8).remaining);

                                                if ((operand_173 >= (operand_172).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_174 (operand_172)[@intCast(operand_173)];
                                            };

                                            break :block_176 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_175));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_171).len, 1));

                                        if ((!state_capacity_started_163)) {
                                            (try (state_capacity_162).appendSlice(allocator, operand_171));

                                            state_capacity_started_163 = true;
                                        } else {
                                            ((state_capacity_162).items).len = (operand_171).len;
                                        }

                                        (try (state_capacity_162).append(allocator, operand_177));

                                        break :block_178 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_162).items, {}, null, });
                                    }).@"0", .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_170: {
                                break :block_170 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_169: {
                                    break :block_169 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = (block_168: {
                                        const operand_166 = ((value_11).pending).ready;
                                        const operand_167 = false;

                                        _ = (try ((std).math).add(usize, (operand_166).len, 1));

                                        if ((!state_capacity_started_165)) {
                                            (try (state_capacity_164).appendSlice(allocator, operand_166));

                                            state_capacity_started_165 = true;
                                        } else {
                                            ((state_capacity_164).items).len = (operand_166).len;
                                        }

                                        (try (state_capacity_164).append(allocator, operand_167));

                                        break :block_168 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_164).items, {}, null, });
                                    }).@"0", });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_183 value_14;
                        };

                        state_changed_161 = true;
                    }

                    var state_owned_184: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_184);

                    if (state_capacity_started_163) {
                        ((state_capacity_162).items).len = (((state_143).pending).ids).len;
                        state_owned_184 = (try (state_capacity_162).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_163) {
                        state_143 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_143).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_184, .ready = ((state_143).pending).ready, }), .remaining = (state_143).remaining, .values = (state_143).values, };
                    }

                    var state_owned_185: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_185);

                    if (state_capacity_started_165) {
                        ((state_capacity_164).items).len = (((state_143).pending).ready).len;
                        state_owned_185 = (try (state_capacity_164).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_165) {
                        state_143 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_143).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_143).pending).ids, .ready = state_owned_185, }), .remaining = (state_143).remaining, .values = (state_143).values, };
                    }

                    break :block_187 (if (state_changed_161) state_143 else operand_160);
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

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_362: {
        const operand_361 = block_360: {
            const operand_358 = ((in).table).kinds;
            const operand_359 = (in).index;

            if ((operand_359 >= (operand_358).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_360 (operand_358)[@intCast(operand_359)];
        };

        break :block_362 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_361));
    };

    if ((block_194: {
        break :block_194 value_2;
    } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_269: {
            const operand_195 = @as([]const u64, (if (((buffers).lane_0 != null)) block_220: {
                const operand_213 = @as([]const u64, (if (((buffers).lane_0 != null)) block_203: {
                    const operand_196 = (value_1).ids;
                    const operand_202 = block_201: {
                        const operand_200 = block_199: {
                            const operand_197 = ((in).table).first;
                            const operand_198 = (in).index;

                            if ((operand_198 >= (operand_197).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_199 (operand_197)[@intCast(operand_198)];
                        };

                        break :block_201 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_200));
                    };

                    _ = (try ((std).math).add(usize, (operand_196).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_196));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_196).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_202));

                    break :block_203 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_212: {
                    const operand_204 = (value_1).ids;

                    const operand_210 = block_209: {
                        const operand_208 = block_207: {
                            const operand_205 = ((in).table).first;
                            const operand_206 = (in).index;

                            if ((operand_206 >= (operand_205).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_207 (operand_205)[@intCast(operand_206)];
                        };

                        break :block_209 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_208));
                    };

                    const operand_211 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_204).len, 1))));

                    @memcpy((operand_211)[0..(operand_204).len], operand_204);

                    (operand_211)[(operand_204).len] = operand_210;

                    break :block_212 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_211, {}, null, });
                }).@"0"));

                const operand_219 = block_218: {
                    const operand_217 = block_216: {
                        const operand_214 = ((in).table).second;
                        const operand_215 = (in).index;

                        if ((operand_215 >= (operand_214).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_216 (operand_214)[@intCast(operand_215)];
                    };

                    break :block_218 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_217));
                };

                _ = (try ((std).math).add(usize, (operand_213).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_213));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_213).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_219));

                break :block_220 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_246: {
                const operand_238 = @as([]const u64, (if (((buffers).lane_0 != null)) block_228: {
                    const operand_221 = (value_1).ids;

                    const operand_227 = block_226: {
                        const operand_225 = block_224: {
                            const operand_222 = ((in).table).first;
                            const operand_223 = (in).index;

                            if ((operand_223 >= (operand_222).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_224 (operand_222)[@intCast(operand_223)];
                        };

                        break :block_226 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_225));
                    };

                    _ = (try ((std).math).add(usize, (operand_221).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_221));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_221).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_227));

                    break :block_228 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_237: {
                    const operand_229 = (value_1).ids;

                    const operand_235 = block_234: {
                        const operand_233 = block_232: {
                            const operand_230 = ((in).table).first;
                            const operand_231 = (in).index;

                            if ((operand_231 >= (operand_230).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_232 (operand_230)[@intCast(operand_231)];
                        };

                        break :block_234 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_233));
                    };

                    const operand_236 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_229).len, 1))));

                    @memcpy((operand_236)[0..(operand_229).len], operand_229);

                    (operand_236)[(operand_229).len] = operand_235;

                    break :block_237 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_236, {}, null, });
                }).@"0"));

                const operand_244 = block_243: {
                    const operand_242 = block_241: {
                        const operand_239 = ((in).table).second;
                        const operand_240 = (in).index;

                        if ((operand_240 >= (operand_239).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_241 (operand_239)[@intCast(operand_240)];
                    };

                    break :block_243 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_242));
                };

                const operand_245 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_238).len, 1))));

                @memcpy((operand_245)[0..(operand_238).len], operand_238);
                (operand_245)[(operand_238).len] = operand_244;

                break :block_246 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_245, {}, null, });
            }).@"0"));

            const operand_247 = @as([]const bool, (if (((buffers).lane_1 != null)) block_257: {
                const operand_255 = @as([]const bool, (if (((buffers).lane_1 != null)) block_250: {
                    const operand_248 = (value_1).ready;
                    const operand_249 = false;

                    _ = (try ((std).math).add(usize, (operand_248).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_248));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_248).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_249));

                    break :block_250 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_254: {
                    const operand_251 = (value_1).ready;
                    const operand_252 = false;
                    const operand_253 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_251).len, 1))));

                    @memcpy((operand_253)[0..(operand_251).len], operand_251);

                    (operand_253)[(operand_251).len] = operand_252;

                    break :block_254 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_253, {}, null, });
                }).@"0"));

                const operand_256 = false;

                _ = (try ((std).math).add(usize, (operand_255).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_255));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_255).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_256));

                break :block_257 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_268: {
                const operand_265 = @as([]const bool, (if (((buffers).lane_1 != null)) block_260: {
                    const operand_258 = (value_1).ready;
                    const operand_259 = false;

                    _ = (try ((std).math).add(usize, (operand_258).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_258));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_258).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_259));

                    break :block_260 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_264: {
                    const operand_261 = (value_1).ready;
                    const operand_262 = false;
                    const operand_263 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_261).len, 1))));

                    @memcpy((operand_263)[0..(operand_261).len], operand_261);

                    (operand_263)[(operand_261).len] = operand_262;

                    break :block_264 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_263, {}, null, });
                }).@"0"));

                const operand_266 = false;
                const operand_267 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_265).len, 1))));

                @memcpy((operand_267)[0..(operand_265).len], operand_265);

                (operand_267)[(operand_265).len] = operand_266;

                break :block_268 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_267, {}, null, });
            }).@"0"));

            break :block_269 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_195, .ready = operand_247, });
        };
    } else {
        if (((block_270: {
            break :block_270 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (block_271: {
            break :block_271 value_2;
        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_298: {
                const operand_272 = @as([]const u64, (if (((buffers).lane_0 != null)) block_280: {
                    const operand_273 = (value_1).ids;
                    const operand_279 = block_278: {
                        const operand_277 = block_276: {
                            const operand_274 = ((in).table).first;
                            const operand_275 = (in).index;

                            if ((operand_275 >= (operand_274).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_276 (operand_274)[@intCast(operand_275)];
                        };

                        break :block_278 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_277));
                    };

                    _ = (try ((std).math).add(usize, (operand_273).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_273));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_273).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_279));

                    break :block_280 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_289: {
                    const operand_281 = (value_1).ids;

                    const operand_287 = block_286: {
                        const operand_285 = block_284: {
                            const operand_282 = ((in).table).first;
                            const operand_283 = (in).index;

                            if ((operand_283 >= (operand_282).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_284 (operand_282)[@intCast(operand_283)];
                        };

                        break :block_286 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_285));
                    };

                    const operand_288 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_281).len, 1))));

                    @memcpy((operand_288)[0..(operand_281).len], operand_281);

                    (operand_288)[(operand_281).len] = operand_287;

                    break :block_289 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_288, {}, null, });
                }).@"0"));

                const operand_290 = @as([]const bool, (if (((buffers).lane_1 != null)) block_293: {
                    const operand_291 = (value_1).ready;
                    const operand_292 = false;

                    _ = (try ((std).math).add(usize, (operand_291).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_291));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_291).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_292));

                    break :block_293 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_297: {
                    const operand_294 = (value_1).ready;
                    const operand_295 = false;
                    const operand_296 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_294).len, 1))));

                    @memcpy((operand_296)[0..(operand_294).len], operand_294);

                    (operand_296)[(operand_294).len] = operand_295;

                    break :block_297 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_296, {}, null, });
                }).@"0"));

                break :block_298 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = operand_272, .ready = operand_290, });
            };
        } else {
            if (((block_299: {
                break :block_299 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (block_300: {
                break :block_300 value_2;
            } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((block_357: {
                    break :block_357 value_2;
                } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_356: {
                    const operand_318 = block_317: {
                        const operand_302 = block_303: {
                            break :block_303 value_3;
                        };
                        const operand_304 = block_309: {
                            const operand_308 = block_307: {
                                const operand_305 = ((in).table).first;
                                const operand_306 = (in).index;

                                if ((operand_306 >= (operand_305).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_307 (operand_305)[@intCast(operand_306)];
                            };

                            break :block_309 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_308));
                        };
                        const operand_310 = block_315: {
                            const operand_314 = block_313: {
                                const operand_311 = ((in).table).second;
                                const operand_312 = (in).index;

                                if ((operand_312 >= (operand_311).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_313 (operand_311)[@intCast(operand_312)];
                            };

                            break :block_315 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_314));
                        };

                        const operand_316 = value_1;

                        break :block_317 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .values = operand_302, .first = operand_304, .remaining = operand_310, .pending = operand_316, });
                    };

                    var state_capacity_320: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_321 = false;

                    defer (state_capacity_320).deinit(allocator);

                    var state_capacity_322: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_323 = false;

                    defer (state_capacity_322).deinit(allocator);

                    var state_301: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = operand_318;
                    var state_changed_319 = false;

                    while (((state_301).remaining > @as(u64, 0))) {
                        state_301 = block_352: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_301;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_351: {
                                break :block_351 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_350: {
                                    break :block_350 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_349: {
                                break :block_349 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_348: {
                                    break :block_348 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = @as([]const u64, (if (((buffers).lane_0 != null)) block_339: {
                                        const operand_332 = ((value_8).pending).ids;

                                        const operand_338 = block_337: {
                                            const operand_336 = block_335: {
                                                const operand_333 = (value_8).values;
                                                const operand_334 = ((value_8).first + (value_8).remaining);

                                                if ((operand_334 >= (operand_333).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_335 (operand_333)[@intCast(operand_334)];
                                            };

                                            break :block_337 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_336));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_332).len, 1));

                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_332));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_332).len;
                                        }

                                        (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_338));

                                        break :block_339 ((((buffers).lane_0.?).buffer).*).items;
                                    } else (block_347: {
                                        const operand_340 = ((value_8).pending).ids;

                                        const operand_346 = block_345: {
                                            const operand_344 = block_343: {
                                                const operand_341 = (value_8).values;
                                                const operand_342 = ((value_8).first + (value_8).remaining);

                                                if ((operand_342 >= (operand_341).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_343 (operand_341)[@intCast(operand_342)];
                                            };

                                            break :block_345 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_344));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_340).len, 1));

                                        if ((!state_capacity_started_321)) {
                                            (try (state_capacity_320).appendSlice(allocator, operand_340));
                                            state_capacity_started_321 = true;
                                        } else {
                                            ((state_capacity_320).items).len = (operand_340).len;
                                        }

                                        (try (state_capacity_320).append(allocator, operand_346));

                                        break :block_347 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_320).items, {}, null, });
                                    }).@"0")), .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_331: {
                                break :block_331 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_330: {
                                    break :block_330 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = @as([]const bool, (if (((buffers).lane_1 != null)) block_326: {
                                        const operand_324 = ((value_11).pending).ready;
                                        const operand_325 = false;

                                        _ = (try ((std).math).add(usize, (operand_324).len, 1));

                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_324));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_324).len;
                                        }

                                        (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_325));

                                        break :block_326 ((((buffers).lane_1.?).buffer).*).items;
                                    } else (block_329: {
                                        const operand_327 = ((value_11).pending).ready;
                                        const operand_328 = false;
                                        _ = (try ((std).math).add(usize, (operand_327).len, 1));

                                        if ((!state_capacity_started_323)) {
                                            (try (state_capacity_322).appendSlice(allocator, operand_327));
                                            state_capacity_started_323 = true;
                                        } else {
                                            ((state_capacity_322).items).len = (operand_327).len;
                                        }

                                        (try (state_capacity_322).append(allocator, operand_328));
                                        break :block_329 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_322).items, {}, null, });
                                    }).@"0")), });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_352 value_14;
                        };

                        state_changed_319 = true;
                    }

                    var state_owned_353: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_353);

                    if (state_capacity_started_321) {
                        ((state_capacity_320).items).len = (((state_301).pending).ids).len;
                        state_owned_353 = (try (state_capacity_320).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_321) {
                        state_301 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_301).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_353, .ready = ((state_301).pending).ready, }), .remaining = (state_301).remaining, .values = (state_301).values, };
                    }

                    var state_owned_354: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_354);

                    if (state_capacity_started_323) {
                        ((state_capacity_322).items).len = (((state_301).pending).ready).len;
                        state_owned_354 = (try (state_capacity_322).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_323) {
                        state_301 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_301).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_301).pending).ids, .ready = state_owned_354, }), .remaining = (state_301).remaining, .values = (state_301).values, };
                    }

                    break :block_356 (if (state_changed_319) state_301 else operand_318);
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

    const value_2: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, block_512: {
        const operand_510 = ((in).table).kinds;
        const operand_511 = (in).index;

        if ((operand_511 >= (operand_510).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_512 (operand_510)[@intCast(operand_511)];
    }));

    if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Task))) {
        return block_427: {
            const operand_363 = @as([]const u64, (if (((buffers).lane_0 != null)) block_382: {
                const operand_377 = @as([]const u64, (if (((buffers).lane_0 != null)) block_369: {
                    const operand_364 = (value_1).ids;

                    const operand_368 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_367: {
                        const operand_365 = ((in).table).first;
                        const operand_366 = (in).index;

                        if ((operand_366 >= (operand_365).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_367 (operand_365)[@intCast(operand_366)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_364).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_364));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_364).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_368));

                    break :block_369 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_376: {
                    const operand_370 = (value_1).ids;

                    const operand_374 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_373: {
                        const operand_371 = ((in).table).first;
                        const operand_372 = (in).index;

                        if ((operand_372 >= (operand_371).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_373 (operand_371)[@intCast(operand_372)];
                    }));

                    const operand_375 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_370).len, 1))));

                    @memcpy((operand_375)[0..(operand_370).len], operand_370);

                    (operand_375)[(operand_370).len] = operand_374;

                    break :block_376 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_375, {}, });
                }).@"0"));

                const operand_381 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_380: {
                    const operand_378 = ((in).table).second;
                    const operand_379 = (in).index;

                    if ((operand_379 >= (operand_378).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_380 (operand_378)[@intCast(operand_379)];
                }));

                _ = (try ((std).math).add(usize, (operand_377).len, 1));

                if ((!(((buffers).lane_0.?).started).*)) {
                    (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_377));
                    (((buffers).lane_0.?).started).* = true;
                } else {
                    (((((buffers).lane_0.?).buffer).*).items).len = (operand_377).len;
                }

                (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_381));

                break :block_382 ((((buffers).lane_0.?).buffer).*).items;
            } else (block_402: {
                const operand_396 = @as([]const u64, (if (((buffers).lane_0 != null)) block_388: {
                    const operand_383 = (value_1).ids;

                    const operand_387 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_386: {
                        const operand_384 = ((in).table).first;
                        const operand_385 = (in).index;

                        if ((operand_385 >= (operand_384).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_386 (operand_384)[@intCast(operand_385)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_383).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_383));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_383).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_387));

                    break :block_388 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_395: {
                    const operand_389 = (value_1).ids;

                    const operand_393 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_392: {
                        const operand_390 = ((in).table).first;
                        const operand_391 = (in).index;

                        if ((operand_391 >= (operand_390).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_392 (operand_390)[@intCast(operand_391)];
                    }));

                    const operand_394 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_389).len, 1))));

                    @memcpy((operand_394)[0..(operand_389).len], operand_389);

                    (operand_394)[(operand_389).len] = operand_393;

                    break :block_395 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_394, {}, });
                }).@"0"));

                const operand_400 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_399: {
                    const operand_397 = ((in).table).second;
                    const operand_398 = (in).index;

                    if ((operand_398 >= (operand_397).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_399 (operand_397)[@intCast(operand_398)];
                }));

                const operand_401 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_396).len, 1))));

                @memcpy((operand_401)[0..(operand_396).len], operand_396);

                (operand_401)[(operand_396).len] = operand_400;

                break :block_402 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_401, {}, });
            }).@"0"));

            const operand_403 = @as([]const bool, (if (((buffers).lane_1 != null)) block_413: {
                const operand_411 = @as([]const bool, (if (((buffers).lane_1 != null)) block_406: {
                    const operand_404 = (value_1).ready;
                    const operand_405 = false;

                    _ = (try ((std).math).add(usize, (operand_404).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_404));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_404).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_405));

                    break :block_406 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_410: {
                    const operand_407 = (value_1).ready;
                    const operand_408 = false;
                    const operand_409 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_407).len, 1))));

                    @memcpy((operand_409)[0..(operand_407).len], operand_407);

                    (operand_409)[(operand_407).len] = operand_408;

                    break :block_410 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_409, {}, });
                }).@"0"));

                const operand_412 = false;

                _ = (try ((std).math).add(usize, (operand_411).len, 1));

                if ((!(((buffers).lane_1.?).started).*)) {
                    (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_411));
                    (((buffers).lane_1.?).started).* = true;
                } else {
                    (((((buffers).lane_1.?).buffer).*).items).len = (operand_411).len;
                }

                (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_412));

                break :block_413 ((((buffers).lane_1.?).buffer).*).items;
            } else (block_424: {
                const operand_421 = @as([]const bool, (if (((buffers).lane_1 != null)) block_416: {
                    const operand_414 = (value_1).ready;
                    const operand_415 = false;

                    _ = (try ((std).math).add(usize, (operand_414).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_414));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_414).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_415));

                    break :block_416 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_420: {
                    const operand_417 = (value_1).ready;
                    const operand_418 = false;
                    const operand_419 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_417).len, 1))));

                    @memcpy((operand_419)[0..(operand_417).len], operand_417);

                    (operand_419)[(operand_417).len] = operand_418;

                    break :block_420 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_419, {}, });
                }).@"0"));

                const operand_422 = false;
                const operand_423 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_421).len, 1))));

                @memcpy((operand_423)[0..(operand_421).len], operand_421);

                (operand_423)[(operand_421).len] = operand_422;

                break :block_424 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_423, {}, });
            }).@"0"));

            break :block_427 block_426: {
                const operand_425 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                (operand_425).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_363, .ready = operand_403, });

                break :block_426 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_425);
            };
        };
    } else {
        if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Optional)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .List)))) {
            return block_452: {
                const operand_428 = @as([]const u64, (if (((buffers).lane_0 != null)) block_434: {
                    const operand_429 = (value_1).ids;

                    const operand_433 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_432: {
                        const operand_430 = ((in).table).first;
                        const operand_431 = (in).index;

                        if ((operand_431 >= (operand_430).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_432 (operand_430)[@intCast(operand_431)];
                    }));

                    _ = (try ((std).math).add(usize, (operand_429).len, 1));

                    if ((!(((buffers).lane_0.?).started).*)) {
                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_429));
                        (((buffers).lane_0.?).started).* = true;
                    } else {
                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_429).len;
                    }

                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_433));

                    break :block_434 ((((buffers).lane_0.?).buffer).*).items;
                } else (block_441: {
                    const operand_435 = (value_1).ids;

                    const operand_439 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_438: {
                        const operand_436 = ((in).table).first;
                        const operand_437 = (in).index;

                        if ((operand_437 >= (operand_436).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_438 (operand_436)[@intCast(operand_437)];
                    }));

                    const operand_440 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_435).len, 1))));

                    @memcpy((operand_440)[0..(operand_435).len], operand_435);

                    (operand_440)[(operand_435).len] = operand_439;

                    break :block_441 @as((zx_abi).zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, .{ operand_440, {}, });
                }).@"0"));

                const operand_442 = @as([]const bool, (if (((buffers).lane_1 != null)) block_445: {
                    const operand_443 = (value_1).ready;
                    const operand_444 = false;

                    _ = (try ((std).math).add(usize, (operand_443).len, 1));

                    if ((!(((buffers).lane_1.?).started).*)) {
                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_443));
                        (((buffers).lane_1.?).started).* = true;
                    } else {
                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_443).len;
                    }

                    (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_444));

                    break :block_445 ((((buffers).lane_1.?).buffer).*).items;
                } else (block_449: {
                    const operand_446 = (value_1).ready;
                    const operand_447 = false;
                    const operand_448 = (try (allocator).alloc(bool, (try ((std).math).add(usize, (operand_446).len, 1))));

                    @memcpy((operand_448)[0..(operand_446).len], operand_446);

                    (operand_448)[(operand_446).len] = operand_447;

                    break :block_449 @as((zx_abi).zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, .{ operand_448, {}, });
                }).@"0"));

                break :block_452 block_451: {
                    const operand_450 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_450).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_428, .ready = operand_442, });

                    break :block_451 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_450);
                };
            };
        } else {
            if (((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple)) or (value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Object)))) {
                const value_3: []const u32 = (if ((value_2 == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Tuple))) ((in).table).children else ((in).table).field_types);

                const value_15: *const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = block_509: {
                    const operand_467 = block_466: {
                        const operand_454 = value_3;

                        const operand_455 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_458: {
                            const operand_456 = ((in).table).first;
                            const operand_457 = (in).index;

                            if ((operand_457 >= (operand_456).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_458 (operand_456)[@intCast(operand_457)];
                        }));

                        const operand_459 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_462: {
                            const operand_460 = ((in).table).second;
                            const operand_461 = (in).index;

                            if ((operand_461 >= (operand_460).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_462 (operand_460)[@intCast(operand_461)];
                        }));

                        const operand_463 = value_1;

                        break :block_466 block_465: {
                            const operand_464 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                            (operand_464).* = @as((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .values = operand_454, .first = operand_455, .remaining = operand_459, .pending = operand_463, });

                            break :block_465 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_464);
                        };
                    };

                    var state_capacity_469: (std).ArrayList(u64) = .empty;
                    var state_capacity_started_470 = false;

                    defer (state_capacity_469).deinit(allocator);

                    var state_capacity_471: (std).ArrayList(bool) = .empty;
                    var state_capacity_started_472 = false;

                    defer (state_capacity_471).deinit(allocator);

                    var state_453: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (operand_467).first, .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_467).pending).ids, .ready = ((operand_467).pending).ready, .zx_origin = (operand_467).pending, }, .remaining = (operand_467).remaining, .values = (operand_467).values, .zx_origin = operand_467, };
                    var state_changed_468 = false;

                    while (((state_453).remaining > @as(u64, 0))) {
                        state_453 = block_501: {
                            const value_6: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = state_453;
                            const value_7: u64 = (value_6).remaining;

                            const value_8: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_500: {
                                break :block_500 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_6).first, .pending = (value_6).pending, .remaining = (block_499: {
                                    break :block_499 value_7;
                                } - @as(u64, 1)), .values = (value_6).values, });
                            };
                            const value_9: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_8;
                            const value_10: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_9).pending;

                            const value_11: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_498: {
                                break :block_498 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_9).first, .pending = block_497: {
                                    break :block_497 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = @as([]const u64, (if (((buffers).lane_0 != null)) block_488: {
                                        const operand_481 = ((value_8).pending).ids;

                                        const operand_487 = block_486: {
                                            const operand_485 = block_484: {
                                                const operand_482 = (value_8).values;
                                                const operand_483 = ((value_8).first + (value_8).remaining);

                                                if ((operand_483 >= (operand_482).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_484 (operand_482)[@intCast(operand_483)];
                                            };

                                            break :block_486 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_485));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_481).len, 1));

                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_481));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_481).len;
                                        }

                                        (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_487));

                                        break :block_488 ((((buffers).lane_0.?).buffer).*).items;
                                    } else (block_496: {
                                        const operand_489 = ((value_8).pending).ids;

                                        const operand_495 = block_494: {
                                            const operand_493 = block_492: {
                                                const operand_490 = (value_8).values;
                                                const operand_491 = ((value_8).first + (value_8).remaining);

                                                if ((operand_491 >= (operand_490).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_492 (operand_490)[@intCast(operand_491)];
                                            };

                                            break :block_494 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_493));
                                        };

                                        _ = (try ((std).math).add(usize, (operand_489).len, 1));

                                        if ((!state_capacity_started_470)) {
                                            (try (state_capacity_469).appendSlice(allocator, operand_489));

                                            state_capacity_started_470 = true;
                                        } else {
                                            ((state_capacity_469).items).len = (operand_489).len;
                                        }

                                        (try (state_capacity_469).append(allocator, operand_495));

                                        break :block_496 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_469).items, {}, null, });
                                    }).@"0")), .ready = (value_10).ready, });
                                }, .remaining = (value_9).remaining, .values = (value_9).values, });
                            };
                            const value_12: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = value_11;
                            const value_13: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_12).pending;

                            const value_14: (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = block_480: {
                                break :block_480 @as((zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5, (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (value_12).first, .pending = block_479: {
                                    break :block_479 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_13).ids, .ready = @as([]const bool, (if (((buffers).lane_1 != null)) block_475: {
                                        const operand_473 = ((value_11).pending).ready;
                                        const operand_474 = false;

                                        _ = (try ((std).math).add(usize, (operand_473).len, 1));

                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_473));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_473).len;
                                        }

                                        (try ((((buffers).lane_1.?).buffer).*).append(allocator, operand_474));

                                        break :block_475 ((((buffers).lane_1.?).buffer).*).items;
                                    } else (block_478: {
                                        const operand_476 = ((value_11).pending).ready;
                                        const operand_477 = false;

                                        _ = (try ((std).math).add(usize, (operand_476).len, 1));

                                        if ((!state_capacity_started_472)) {
                                            (try (state_capacity_471).appendSlice(allocator, operand_476));
                                            state_capacity_started_472 = true;
                                        } else {
                                            ((state_capacity_471).items).len = (operand_476).len;
                                        }

                                        (try (state_capacity_471).append(allocator, operand_477));
                                        break :block_478 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_471).items, {}, null, });
                                    }).@"0")), });
                                }, .remaining = (value_12).remaining, .values = (value_12).values, });
                            };

                            break :block_501 value_14;
                        };

                        state_changed_468 = true;
                    }

                    var state_owned_502: []const u64 = (&[_]u64{});

                    errdefer (allocator).free(state_owned_502);

                    if (state_capacity_started_470) {
                        ((state_capacity_469).items).len = (((state_453).pending).ids).len;
                        state_owned_502 = (try (state_capacity_469).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_470) {
                        state_453 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_453).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_502, .ready = ((state_453).pending).ready, }), .remaining = (state_453).remaining, .values = (state_453).values, };
                    }

                    var state_owned_503: []const bool = (&[_]bool{});

                    errdefer (allocator).free(state_owned_503);

                    if (state_capacity_started_472) {
                        ((state_capacity_471).items).len = (((state_453).pending).ready).len;
                        state_owned_503 = (try (state_capacity_471).toOwnedSlice(allocator));
                    }

                    if (state_capacity_started_472) {
                        state_453 = (zx_abi).value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5{ .first = (state_453).first, .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_453).pending).ids, .ready = state_owned_503, }), .remaining = (state_453).remaining, .values = (state_453).values, };
                    }

                    break :block_509 (if (state_changed_468) block_508: {
                        break :block_508 (if (((state_453).zx_origin != null)) (state_453).zx_origin.? else block_507: {
                            const operand_506 = (try (allocator).create((zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814));

                            (operand_506).* = (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814{ .first = (state_453).first, .pending = (if ((((state_453).pending).zx_origin != null)) ((state_453).pending).zx_origin.? else block_505: {
                                const operand_504 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                                (operand_504).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_453).pending).ids, .ready = ((state_453).pending).ready, };

                                break :block_505 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_504);
                            }), .remaining = (state_453).remaining, .values = (state_453).values, };

                            break :block_507 @as(*const (zx_abi).zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814, operand_506);
                        });
                    } else operand_467);
                };

                return (value_15).pending;
            }
        }
    }

    return value_1;
}

