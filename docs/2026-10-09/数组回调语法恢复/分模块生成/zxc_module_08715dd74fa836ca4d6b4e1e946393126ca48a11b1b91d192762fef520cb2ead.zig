const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    if ((block_192: {
        const operand_190 = ((in).state).mapping;
        const operand_191 = (in).index;

        if ((operand_191 >= (operand_190).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_192 (operand_190)[@intCast(operand_191)];
    } != @as(u64, 0))) {
        return (in).state;
    }

    const value_1: []const u64 = block_189: {
        const operand_188 = (in).index;

        break :block_189 (try (allocator).dupe(u64, (&[_]u64{operand_188, })));
    };

    const value_2: []const bool = block_187: {
        const operand_186 = false;

        break :block_187 (try (allocator).dupe(bool, (&[_]bool{operand_186, })));
    };

    const value_55: *const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_185: {
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
        var state_1: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_13).pending).ids, .ready = ((operand_13).pending).ready, .zx_origin = (operand_13).pending, }, .plan = (operand_13).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_13).request).maximum_count, .names = ((operand_13).request).names, .origins = ((operand_13).request).origins, .roots = ((operand_13).request).roots, .scalar_count = ((operand_13).request).scalar_count, .table = ((operand_13).request).table, .zx_origin = (operand_13).request, }, .zx_origin = operand_13, };
        var state_changed_14 = false;

        while (((((state_1).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_1).pending).ids).len) > @as(u64, 0)))) {
            state_1 = block_175: {
                const value_5: u64 = (@as(u64, (((state_1).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_174: {
                    const operand_172 = ((state_1).pending).ids;

                    const operand_173 = block_171: {
                        break :block_171 value_5;
                    };

                    if ((operand_173 >= (operand_172).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_174 (operand_172)[@intCast(operand_173)];
                };
                const value_7: bool = block_170: {
                    const operand_168 = ((state_1).pending).ready;

                    const operand_169 = block_167: {
                        break :block_167 value_5;
                    };

                    if ((operand_169 >= (operand_168).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_170 (operand_168)[@intCast(operand_169)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_1;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_166: {
                    break :block_166 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_165: {
                        break :block_165 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_164: {
                            const operand_163 = ((state_1).pending).ids;

                            break :block_164 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_163).len == 0)) .{ operand_163, null, null, } else .{ (operand_163)[0..((operand_163).len - 1)], (operand_163)[((operand_163).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_162: {
                    break :block_162 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_161: {
                        break :block_161 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_160: {
                            const operand_159 = ((value_10).pending).ready;

                            break :block_160 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_159).len == 0)) .{ operand_159, null, null, } else .{ (operand_159)[0..((operand_159).len - 1)], (operand_159)[((operand_159).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_28: {
                    const operand_26 = ((value_13).plan).mapping;

                    const operand_27 = block_25: {
                        break :block_25 value_6;
                    };

                    if ((operand_27 >= (operand_26).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_28 (operand_26)[@intCast(operand_27)];
                } == @as(u64, 0))) block_158: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_29: {
                        break :block_29 value_7;
                    })) block_48: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_47: {
                            break :block_47 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_46: {
                                break :block_46 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_45: {
                                    const operand_42 = ((value_13).pending).ids;

                                    const operand_44 = block_43: {
                                        break :block_43 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_42).len, 1));

                                    if ((!state_capacity_started_16)) {
                                        (try (state_capacity_15).appendSlice(allocator, operand_42));
                                        state_capacity_started_16 = true;
                                    } else {
                                        ((state_capacity_15).items).len = (operand_42).len;
                                    }

                                    (try (state_capacity_15).append(allocator, operand_44));

                                    break :block_45 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_15).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_41: {
                            break :block_41 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_40: {
                                break :block_40 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_39: {
                                    const operand_37 = ((value_16).pending).ready;
                                    const operand_38 = true;

                                    _ = (try ((std).math).add(usize, (operand_37).len, 1));

                                    if ((!state_capacity_started_18)) {
                                        (try (state_capacity_17).appendSlice(allocator, operand_37));

                                        state_capacity_started_18 = true;
                                    } else {
                                        ((state_capacity_17).items).len = (operand_37).len;
                                    }

                                    (try (state_capacity_17).append(allocator, operand_38));

                                    break :block_39 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_17).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_36: {
                            break :block_36 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_35: {
                                break :block_35 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_34: {
                                    const operand_30 = ((value_19).request).table;

                                    const operand_31 = block_32: {
                                        break :block_32 value_6;
                                    };

                                    const operand_33 = (value_19).pending;

                                    break :block_34 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_30, .index = operand_31, .pending = operand_33, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_15), .started = (&state_capacity_started_16), }, .lane_1 = .{ .buffer = (&state_capacity_17), .started = (&state_capacity_started_18), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_48 value_21;
                    } else block_157: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_23).plan;

                        const value_25: []const u64 = (block_156: {
                            break :block_156 value_24;
                        }).mapping;
                        const value_26: u64 = block_155: {
                            break :block_155 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_154: {
                            break :block_154 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_153: {
                                break :block_153 block_152: {
                                    const operand_151 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_151).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_139: {
                                        break :block_139 value_24;
                                    }).count, .mapping = block_147: {
                                        const operand_141 = block_140: {
                                            break :block_140 value_25;
                                        };
                                        const operand_143 = block_142: {
                                            break :block_142 value_26;
                                        };

                                        if ((operand_143 >= (operand_141).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_145 = (block_144: {
                                            break :block_144 value_22;
                                        } + @as(u64, 1));

                                        break :block_147 block_146: {
                                            if ((!state_items_started_20)) {
                                                state_items_19 = (try (allocator).dupe(u64, operand_141));
                                                state_items_started_20 = true;
                                            }

                                            (state_items_19)[@intCast(operand_143)] = operand_145;

                                            break :block_146 state_items_19;
                                        };
                                    }, .order = (block_148: {
                                        break :block_148 value_24;
                                    }).order, .origins = (block_149: {
                                        break :block_149 value_24;
                                    }).origins, .status = (block_150: {
                                        break :block_150 value_24;
                                    }).status, });

                                    break :block_152 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_151);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_28).plan;

                        const value_30: []const u32 = (block_138: {
                            break :block_138 value_29;
                        }).order;
                        const value_31: u64 = block_137: {
                            break :block_137 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_136: {
                            break :block_136 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_135: {
                                break :block_135 block_134: {
                                    const operand_133 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_133).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_119: {
                                        break :block_119 value_29;
                                    }).count, .mapping = (block_120: {
                                        break :block_120 value_29;
                                    }).mapping, .order = block_130: {
                                        const operand_122 = block_121: {
                                            break :block_121 value_30;
                                        };
                                        const operand_124 = block_123: {
                                            break :block_123 value_31;
                                        };

                                        if ((operand_124 >= (operand_122).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_128 = block_127: {
                                            const operand_126 = block_125: {
                                                break :block_125 value_6;
                                            };

                                            break :block_127 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_126));
                                        };

                                        break :block_130 block_129: {
                                            if ((!state_items_started_22)) {
                                                state_items_21 = (try (allocator).dupe(u32, operand_122));
                                                state_items_started_22 = true;
                                            }

                                            (state_items_21)[@intCast(operand_124)] = operand_128;

                                            break :block_129 state_items_21;
                                        };
                                    }, .origins = (block_131: {
                                        break :block_131 value_29;
                                    }).origins, .status = (block_132: {
                                        break :block_132 value_29;
                                    }).status, });

                                    break :block_134 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_133);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_33).plan;

                        const value_35: u64 = (block_118: {
                            break :block_118 value_34;
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_117: {
                            break :block_117 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_116: {
                                break :block_116 block_115: {
                                    const operand_114 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_114).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_109: {
                                        break :block_109 value_35;
                                    } + @as(u64, 1)), .mapping = (block_110: {
                                        break :block_110 value_34;
                                    }).mapping, .order = (block_111: {
                                        break :block_111 value_34;
                                    }).order, .origins = (block_112: {
                                        break :block_112 value_34;
                                    }).origins, .status = (block_113: {
                                        break :block_113 value_34;
                                    }).status, });

                                    break :block_115 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_114);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_108: {
                            const operand_107 = block_106: {
                                const operand_104 = (((value_36).request).table).kinds;

                                const operand_105 = block_103: {
                                    break :block_103 value_6;
                                };

                                if ((operand_105 >= (operand_104).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_106 (operand_104)[@intCast(operand_105)];
                            };

                            break :block_108 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_107));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_49: {
                            break :block_49 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_50: {
                            break :block_50 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_102: {
                            const value_38: u64 = block_101: {
                                const operand_91 = ((value_36).request).origins;
                                const operand_92 = ((value_36).request).names;

                                const operand_94 = block_93: {
                                    break :block_93 value_6;
                                };
                                const operand_99 = block_98: {
                                    const operand_96 = (((value_36).request).table).labels;

                                    const operand_97 = block_95: {
                                        break :block_95 value_6;
                                    };

                                    if ((operand_97 >= (operand_96).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_98 (operand_96)[@intCast(operand_97)];
                                };

                                const operand_100 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_91, .names = operand_92, .index = operand_94, .name = operand_99, };

                                break :block_101 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_100)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_51: {
                                break :block_51 value_38;
                            } == @as(u64, 0))) block_60: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_39).plan;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_59: {
                                    break :block_59 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_58: {
                                        break :block_58 block_57: {
                                            const operand_56 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_56).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_52: {
                                                break :block_52 value_40;
                                            }).count, .mapping = (block_53: {
                                                break :block_53 value_40;
                                            }).mapping, .order = (block_54: {
                                                break :block_54 value_40;
                                            }).order, .origins = (block_55: {
                                                break :block_55 value_40;
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_57 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_56);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_60 value_41;
                            } else block_90: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_61: {
                                    break :block_61 value_38;
                                } == @as(u64, 1))) block_70: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_42).plan;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_69: {
                                        break :block_69 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_68: {
                                            break :block_68 block_67: {
                                                const operand_66 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_66).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_62: {
                                                    break :block_62 value_43;
                                                }).count, .mapping = (block_63: {
                                                    break :block_63 value_43;
                                                }).mapping, .order = (block_64: {
                                                    break :block_64 value_43;
                                                }).order, .origins = (block_65: {
                                                    break :block_65 value_43;
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_67 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_66);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_70 value_44;
                                } else block_89: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_45).plan;

                                    const value_47: []const u64 = (block_88: {
                                        break :block_88 value_46;
                                    }).origins;
                                    const value_48: u64 = block_87: {
                                        break :block_87 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_86: {
                                        break :block_86 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_85: {
                                            break :block_85 block_84: {
                                                const operand_83 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_83).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_71: {
                                                    break :block_71 value_46;
                                                }).count, .mapping = (block_72: {
                                                    break :block_72 value_46;
                                                }).mapping, .order = (block_73: {
                                                    break :block_73 value_46;
                                                }).order, .origins = block_81: {
                                                    const operand_75 = block_74: {
                                                        break :block_74 value_47;
                                                    };
                                                    const operand_77 = block_76: {
                                                        break :block_76 value_48;
                                                    };

                                                    if ((operand_77 >= (operand_75).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_79 = (block_78: {
                                                        break :block_78 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_81 block_80: {
                                                        if ((!state_items_started_24)) {
                                                            state_items_23 = (try (allocator).dupe(u64, operand_75));
                                                            state_items_started_24 = true;
                                                        }

                                                        (state_items_23)[@intCast(operand_77)] = operand_79;
                                                        break :block_80 state_items_23;
                                                    };
                                                }, .status = (block_82: {
                                                    break :block_82 value_46;
                                                }).status, });

                                                break :block_84 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_83);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_89 value_49;
                                });

                                break :block_90 value_50;
                            });

                            break :block_102 value_51;
                        } else value_36);

                        break :block_157 value_52;
                    });

                    break :block_158 value_53;
                } else value_13);

                break :block_175 value_54;
            };

            state_changed_14 = true;
        }

        var state_owned_176: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_176);

        if (state_capacity_started_16) {
            ((state_capacity_15).items).len = (((state_1).pending).ids).len;
            state_owned_176 = (try (state_capacity_15).toOwnedSlice(allocator));
        }

        if (state_capacity_started_16) {
            state_1 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_176, .ready = ((state_1).pending).ready, }), .plan = (state_1).plan, .request = (state_1).request, };
        }

        var state_owned_177: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_177);

        if (state_capacity_started_18) {
            ((state_capacity_17).items).len = (((state_1).pending).ready).len;
            state_owned_177 = (try (state_capacity_17).toOwnedSlice(allocator));
        }

        if (state_capacity_started_18) {
            state_1 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_1).pending).ids, .ready = state_owned_177, }), .plan = (state_1).plan, .request = (state_1).request, };
        }

        break :block_185 (if (state_changed_14) block_184: {
            break :block_184 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_183: {
                const operand_182 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_182).* = (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_1).pending).zx_origin != null)) ((state_1).pending).zx_origin.? else block_179: {
                    const operand_178 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_178).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_1).pending).ids, .ready = ((state_1).pending).ready, };

                    break :block_179 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_178);
                }), .plan = (state_1).plan, .request = (if ((((state_1).request).zx_origin != null)) ((state_1).request).zx_origin.? else block_181: {
                    const operand_180 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_180).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_1).request).maximum_count, .names = ((state_1).request).names, .origins = ((state_1).request).origins, .roots = ((state_1).request).roots, .scalar_count = ((state_1).request).scalar_count, .table = ((state_1).request).table, };

                    break :block_181 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_180);
                }), };

                break :block_183 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_182);
            });
        } else operand_13);
    };

    return (value_55).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 {
    @setRuntimeSafety(true);

    if ((block_380: {
        const operand_378 = ((in).state).mapping;
        const operand_379 = (in).index;

        if ((operand_379 >= (operand_378).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_380 (operand_378)[@intCast(operand_379)];
    } != @as(u64, 0))) {
        return ((in).state).*;
    }

    const value_1: []const u64 = block_377: {
        const operand_376 = (in).index;

        break :block_377 (try (allocator).dupe(u64, (&[_]u64{operand_376, })));
    };

    const value_2: []const bool = block_375: {
        const operand_374 = false;

        break :block_375 (try (allocator).dupe(bool, (&[_]bool{operand_374, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_373: {
        const operand_203 = block_202: {
            const operand_194 = (in).request;
            const operand_195 = (in).state;

            const operand_196 = block_201: {
                const operand_197 = value_1;
                const operand_198 = value_2;

                break :block_201 block_200: {
                    const operand_199 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_199).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_197, .ready = operand_198, });

                    break :block_200 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_199);
                };
            };

            break :block_202 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_194, .plan = operand_195, .pending = operand_196, };
        };

        var state_capacity_204: (std).ArrayList(u64) = .empty;
        var state_capacity_started_205 = false;

        defer (state_capacity_204).deinit(allocator);

        var state_capacity_206: (std).ArrayList(bool) = .empty;
        var state_capacity_started_207 = false;

        defer (state_capacity_206).deinit(allocator);

        var state_items_208: []u64 = undefined;
        var state_items_started_209 = false;
        var state_items_210: []u32 = undefined;
        var state_items_started_211 = false;
        var state_items_212: []u64 = undefined;
        var state_items_started_213 = false;
        var state_193: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_203).pending).ids, .ready = ((operand_203).pending).ready, .zx_origin = (operand_203).pending, }, .plan = (operand_203).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_203).request).maximum_count, .names = ((operand_203).request).names, .origins = ((operand_203).request).origins, .roots = ((operand_203).request).roots, .scalar_count = ((operand_203).request).scalar_count, .table = ((operand_203).request).table, .zx_origin = (operand_203).request, }, .zx_origin = (&operand_203), };

        while (((((state_193).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_193).pending).ids).len) > @as(u64, 0)))) {
            state_193 = block_364: {
                const value_5: u64 = (@as(u64, (((state_193).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_363: {
                    const operand_361 = ((state_193).pending).ids;

                    const operand_362 = block_360: {
                        break :block_360 value_5;
                    };

                    if ((operand_362 >= (operand_361).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_363 (operand_361)[@intCast(operand_362)];
                };
                const value_7: bool = block_359: {
                    const operand_357 = ((state_193).pending).ready;

                    const operand_358 = block_356: {
                        break :block_356 value_5;
                    };

                    if ((operand_358 >= (operand_357).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_359 (operand_357)[@intCast(operand_358)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_193;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_355: {
                    break :block_355 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_354: {
                        break :block_354 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_353: {
                            const operand_352 = ((state_193).pending).ids;

                            break :block_353 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_352).len == 0)) .{ operand_352, null, null, } else .{ (operand_352)[0..((operand_352).len - 1)], (operand_352)[((operand_352).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_351: {
                    break :block_351 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_350: {
                        break :block_350 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_349: {
                            const operand_348 = ((value_10).pending).ready;

                            break :block_349 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_348).len == 0)) .{ operand_348, null, null, } else .{ (operand_348)[0..((operand_348).len - 1)], (operand_348)[((operand_348).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_217: {
                    const operand_215 = ((value_13).plan).mapping;

                    const operand_216 = block_214: {
                        break :block_214 value_6;
                    };

                    if ((operand_216 >= (operand_215).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_217 (operand_215)[@intCast(operand_216)];
                } == @as(u64, 0))) block_347: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_218: {
                        break :block_218 value_7;
                    })) block_237: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_236: {
                            break :block_236 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_235: {
                                break :block_235 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_234: {
                                    const operand_231 = ((value_13).pending).ids;

                                    const operand_233 = block_232: {
                                        break :block_232 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_231).len, 1));

                                    if ((!state_capacity_started_205)) {
                                        (try (state_capacity_204).appendSlice(allocator, operand_231));
                                        state_capacity_started_205 = true;
                                    } else {
                                        ((state_capacity_204).items).len = (operand_231).len;
                                    }

                                    (try (state_capacity_204).append(allocator, operand_233));

                                    break :block_234 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_204).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_230: {
                            break :block_230 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_229: {
                                break :block_229 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_228: {
                                    const operand_226 = ((value_16).pending).ready;
                                    const operand_227 = true;

                                    _ = (try ((std).math).add(usize, (operand_226).len, 1));

                                    if ((!state_capacity_started_207)) {
                                        (try (state_capacity_206).appendSlice(allocator, operand_226));

                                        state_capacity_started_207 = true;
                                    } else {
                                        ((state_capacity_206).items).len = (operand_226).len;
                                    }

                                    (try (state_capacity_206).append(allocator, operand_227));

                                    break :block_228 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_206).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_225: {
                            break :block_225 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_224: {
                                break :block_224 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_223: {
                                    const operand_219 = ((value_19).request).table;

                                    const operand_220 = block_221: {
                                        break :block_221 value_6;
                                    };

                                    const operand_222 = (value_19).pending;

                                    break :block_223 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_219, .index = operand_220, .pending = operand_222, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_204), .started = (&state_capacity_started_205), }, .lane_1 = .{ .buffer = (&state_capacity_206), .started = (&state_capacity_started_207), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_237 value_21;
                    } else block_346: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_345: {
                            break :block_345 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_344: {
                            break :block_344 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_343: {
                            break :block_343 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_342: {
                                break :block_342 block_341: {
                                    const operand_340 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_340).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_328: {
                                        break :block_328 (&value_24);
                                    }).count, .mapping = block_336: {
                                        const operand_330 = block_329: {
                                            break :block_329 value_25;
                                        };
                                        const operand_332 = block_331: {
                                            break :block_331 value_26;
                                        };

                                        if ((operand_332 >= (operand_330).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_334 = (block_333: {
                                            break :block_333 value_22;
                                        } + @as(u64, 1));

                                        break :block_336 block_335: {
                                            if ((!state_items_started_209)) {
                                                state_items_208 = (try (allocator).dupe(u64, operand_330));
                                                state_items_started_209 = true;
                                            }

                                            (state_items_208)[@intCast(operand_332)] = operand_334;
                                            break :block_335 state_items_208;
                                        };
                                    }, .order = (block_337: {
                                        break :block_337 (&value_24);
                                    }).order, .origins = (block_338: {
                                        break :block_338 (&value_24);
                                    }).origins, .status = (block_339: {
                                        break :block_339 (&value_24);
                                    }).status, });

                                    break :block_341 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_340);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_327: {
                            break :block_327 (&value_29);
                        }).order;
                        const value_31: u64 = block_326: {
                            break :block_326 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_325: {
                            break :block_325 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_324: {
                                break :block_324 block_323: {
                                    const operand_322 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_322).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_308: {
                                        break :block_308 (&value_29);
                                    }).count, .mapping = (block_309: {
                                        break :block_309 (&value_29);
                                    }).mapping, .order = block_319: {
                                        const operand_311 = block_310: {
                                            break :block_310 value_30;
                                        };
                                        const operand_313 = block_312: {
                                            break :block_312 value_31;
                                        };

                                        if ((operand_313 >= (operand_311).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_317 = block_316: {
                                            const operand_315 = block_314: {
                                                break :block_314 value_6;
                                            };

                                            break :block_316 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_315));
                                        };

                                        break :block_319 block_318: {
                                            if ((!state_items_started_211)) {
                                                state_items_210 = (try (allocator).dupe(u32, operand_311));
                                                state_items_started_211 = true;
                                            }

                                            (state_items_210)[@intCast(operand_313)] = operand_317;
                                            break :block_318 state_items_210;
                                        };
                                    }, .origins = (block_320: {
                                        break :block_320 (&value_29);
                                    }).origins, .status = (block_321: {
                                        break :block_321 (&value_29);
                                    }).status, });

                                    break :block_323 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_322);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_307: {
                            break :block_307 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_306: {
                            break :block_306 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_305: {
                                break :block_305 block_304: {
                                    const operand_303 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_303).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_298: {
                                        break :block_298 value_35;
                                    } + @as(u64, 1)), .mapping = (block_299: {
                                        break :block_299 (&value_34);
                                    }).mapping, .order = (block_300: {
                                        break :block_300 (&value_34);
                                    }).order, .origins = (block_301: {
                                        break :block_301 (&value_34);
                                    }).origins, .status = (block_302: {
                                        break :block_302 (&value_34);
                                    }).status, });

                                    break :block_304 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_303);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_297: {
                            const operand_296 = block_295: {
                                const operand_293 = (((value_36).request).table).kinds;

                                const operand_294 = block_292: {
                                    break :block_292 value_6;
                                };

                                if ((operand_294 >= (operand_293).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_295 (operand_293)[@intCast(operand_294)];
                            };

                            break :block_297 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_296));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_238: {
                            break :block_238 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_239: {
                            break :block_239 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_291: {
                            const value_38: u64 = block_290: {
                                const operand_280 = ((value_36).request).origins;
                                const operand_281 = ((value_36).request).names;

                                const operand_283 = block_282: {
                                    break :block_282 value_6;
                                };
                                const operand_288 = block_287: {
                                    const operand_285 = (((value_36).request).table).labels;

                                    const operand_286 = block_284: {
                                        break :block_284 value_6;
                                    };

                                    if ((operand_286 >= (operand_285).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_287 (operand_285)[@intCast(operand_286)];
                                };

                                const operand_289 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_280, .names = operand_281, .index = operand_283, .name = operand_288, };

                                break :block_290 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_289)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_240: {
                                break :block_240 value_38;
                            } == @as(u64, 0))) block_249: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_248: {
                                    break :block_248 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_247: {
                                        break :block_247 block_246: {
                                            const operand_245 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_245).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_241: {
                                                break :block_241 (&value_40);
                                            }).count, .mapping = (block_242: {
                                                break :block_242 (&value_40);
                                            }).mapping, .order = (block_243: {
                                                break :block_243 (&value_40);
                                            }).order, .origins = (block_244: {
                                                break :block_244 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_246 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_245);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_249 value_41;
                            } else block_279: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_250: {
                                    break :block_250 value_38;
                                } == @as(u64, 1))) block_259: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_258: {
                                        break :block_258 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_257: {
                                            break :block_257 block_256: {
                                                const operand_255 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_255).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_251: {
                                                    break :block_251 (&value_43);
                                                }).count, .mapping = (block_252: {
                                                    break :block_252 (&value_43);
                                                }).mapping, .order = (block_253: {
                                                    break :block_253 (&value_43);
                                                }).order, .origins = (block_254: {
                                                    break :block_254 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_256 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_255);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_259 value_44;
                                } else block_278: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_277: {
                                        break :block_277 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_276: {
                                        break :block_276 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_275: {
                                        break :block_275 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_274: {
                                            break :block_274 block_273: {
                                                const operand_272 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_272).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_260: {
                                                    break :block_260 (&value_46);
                                                }).count, .mapping = (block_261: {
                                                    break :block_261 (&value_46);
                                                }).mapping, .order = (block_262: {
                                                    break :block_262 (&value_46);
                                                }).order, .origins = block_270: {
                                                    const operand_264 = block_263: {
                                                        break :block_263 value_47;
                                                    };
                                                    const operand_266 = block_265: {
                                                        break :block_265 value_48;
                                                    };

                                                    if ((operand_266 >= (operand_264).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_268 = (block_267: {
                                                        break :block_267 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_270 block_269: {
                                                        if ((!state_items_started_213)) {
                                                            state_items_212 = (try (allocator).dupe(u64, operand_264));
                                                            state_items_started_213 = true;
                                                        }

                                                        (state_items_212)[@intCast(operand_266)] = operand_268;

                                                        break :block_269 state_items_212;
                                                    };
                                                }, .status = (block_271: {
                                                    break :block_271 (&value_46);
                                                }).status, });

                                                break :block_273 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_272);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_278 value_49;
                                });

                                break :block_279 value_50;
                            });

                            break :block_291 value_51;
                        } else value_36);

                        break :block_346 value_52;
                    });

                    break :block_347 value_53;
                } else value_13);

                break :block_364 value_54;
            };
        }

        var state_owned_365: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_365);

        if (state_capacity_started_205) {
            ((state_capacity_204).items).len = (((state_193).pending).ids).len;
            state_owned_365 = (try (state_capacity_204).toOwnedSlice(allocator));
        }

        if (state_capacity_started_205) {
            state_193 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_365, .ready = ((state_193).pending).ready, }), .plan = (state_193).plan, .request = (state_193).request, };
        }

        var state_owned_366: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_366);

        if (state_capacity_started_207) {
            ((state_capacity_206).items).len = (((state_193).pending).ready).len;
            state_owned_366 = (try (state_capacity_206).toOwnedSlice(allocator));
        }

        if (state_capacity_started_207) {
            state_193 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_193).pending).ids, .ready = state_owned_366, }), .plan = (state_193).plan, .request = (state_193).request, };
        }

        break :block_373 block_372: {
            break :block_372 (if (((state_193).zx_origin != null)) ((state_193).zx_origin.?).* else block_371: {
                break :block_371 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_193).pending).zx_origin != null)) ((state_193).pending).zx_origin.? else block_368: {
                    const operand_367 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_367).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_193).pending).ids, .ready = ((state_193).pending).ready, };

                    break :block_368 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_367);
                }), .plan = (state_193).plan, .request = (if ((((state_193).request).zx_origin != null)) ((state_193).request).zx_origin.? else block_370: {
                    const operand_369 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_369).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_193).request).maximum_count, .names = ((state_193).request).names, .origins = ((state_193).request).origins, .roots = ((state_193).request).roots, .scalar_count = ((state_193).request).scalar_count, .table = ((state_193).request).table, };

                    break :block_370 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_369);
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

    if ((block_580: {
        const operand_578 = ((in).state).mapping;
        const operand_579 = (in).index;

        if ((operand_579 >= (operand_578).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_580 (operand_578)[@intCast(operand_579)];
    } != @as(u64, 0))) {
        return ((in).state).*;
    }

    const value_1: []const u64 = block_577: {
        const operand_576 = (in).index;

        break :block_577 (try (allocator).dupe(u64, (&[_]u64{operand_576, })));
    };

    const value_2: []const bool = block_575: {
        const operand_574 = false;

        break :block_575 (try (allocator).dupe(bool, (&[_]bool{operand_574, })));
    };

    const value_55: (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_573: {
        const operand_391 = block_390: {
            const operand_382 = (in).request;
            const operand_383 = (in).state;

            const operand_384 = block_389: {
                const operand_385 = value_1;
                const operand_386 = value_2;

                break :block_389 block_388: {
                    const operand_387 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_387).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_385, .ready = operand_386, });

                    break :block_388 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_387);
                };
            };

            break :block_390 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_382, .plan = operand_383, .pending = operand_384, };
        };

        var state_capacity_392: (std).ArrayList(u64) = .empty;
        var state_capacity_started_393 = false;

        defer (state_capacity_392).deinit(allocator);

        var state_capacity_394: (std).ArrayList(bool) = .empty;
        var state_capacity_started_395 = false;

        defer (state_capacity_394).deinit(allocator);

        var state_capacity_396: (std).ArrayList(u64) = .empty;
        var state_capacity_started_397 = false;

        defer (state_capacity_396).deinit(allocator);

        var state_capacity_398: (std).ArrayList(u32) = .empty;
        var state_capacity_started_399 = false;

        defer (state_capacity_398).deinit(allocator);

        var state_capacity_400: (std).ArrayList(u64) = .empty;
        var state_capacity_started_401 = false;

        defer (state_capacity_400).deinit(allocator);

        var state_381: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_391).pending).ids, .ready = ((operand_391).pending).ready, .zx_origin = (operand_391).pending, }, .plan = (operand_391).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_391).request).maximum_count, .names = ((operand_391).request).names, .origins = ((operand_391).request).origins, .roots = ((operand_391).request).roots, .scalar_count = ((operand_391).request).scalar_count, .table = ((operand_391).request).table, .zx_origin = (operand_391).request, }, .zx_origin = (&operand_391), };

        while (((((state_381).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_381).pending).ids).len) > @as(u64, 0)))) {
            state_381 = block_555: {
                const value_5: u64 = (@as(u64, (((state_381).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_554: {
                    const operand_552 = ((state_381).pending).ids;

                    const operand_553 = block_551: {
                        break :block_551 value_5;
                    };

                    if ((operand_553 >= (operand_552).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_554 (operand_552)[@intCast(operand_553)];
                };
                const value_7: bool = block_550: {
                    const operand_548 = ((state_381).pending).ready;

                    const operand_549 = block_547: {
                        break :block_547 value_5;
                    };

                    if ((operand_549 >= (operand_548).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_550 (operand_548)[@intCast(operand_549)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_381;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_546: {
                    break :block_546 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_545: {
                        break :block_545 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_544: {
                            const operand_543 = ((state_381).pending).ids;

                            break :block_544 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_543).len == 0)) .{ operand_543, null, null, } else .{ (operand_543)[0..((operand_543).len - 1)], (operand_543)[((operand_543).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_542: {
                    break :block_542 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_541: {
                        break :block_541 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_540: {
                            const operand_539 = ((value_10).pending).ready;

                            break :block_540 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_539).len == 0)) .{ operand_539, null, null, } else .{ (operand_539)[0..((operand_539).len - 1)], (operand_539)[((operand_539).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_405: {
                    const operand_403 = ((value_13).plan).mapping;

                    const operand_404 = block_402: {
                        break :block_402 value_6;
                    };

                    if ((operand_404 >= (operand_403).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_405 (operand_403)[@intCast(operand_404)];
                } == @as(u64, 0))) block_538: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_406: {
                        break :block_406 value_7;
                    })) block_425: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_424: {
                            break :block_424 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_423: {
                                break :block_423 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_422: {
                                    const operand_419 = ((value_13).pending).ids;

                                    const operand_421 = block_420: {
                                        break :block_420 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_419).len, 1));

                                    if ((!state_capacity_started_393)) {
                                        (try (state_capacity_392).appendSlice(allocator, operand_419));

                                        state_capacity_started_393 = true;
                                    } else {
                                        ((state_capacity_392).items).len = (operand_419).len;
                                    }

                                    (try (state_capacity_392).append(allocator, operand_421));

                                    break :block_422 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_392).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_418: {
                            break :block_418 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_417: {
                                break :block_417 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_416: {
                                    const operand_414 = ((value_16).pending).ready;
                                    const operand_415 = true;

                                    _ = (try ((std).math).add(usize, (operand_414).len, 1));

                                    if ((!state_capacity_started_395)) {
                                        (try (state_capacity_394).appendSlice(allocator, operand_414));

                                        state_capacity_started_395 = true;
                                    } else {
                                        ((state_capacity_394).items).len = (operand_414).len;
                                    }

                                    (try (state_capacity_394).append(allocator, operand_415));

                                    break :block_416 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_394).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_413: {
                            break :block_413 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_412: {
                                break :block_412 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_411: {
                                    const operand_407 = ((value_19).request).table;

                                    const operand_408 = block_409: {
                                        break :block_409 value_6;
                                    };

                                    const operand_410 = (value_19).pending;

                                    break :block_411 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_407, .index = operand_408, .pending = operand_410, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_392), .started = (&state_capacity_started_393), }, .lane_1 = .{ .buffer = (&state_capacity_394), .started = (&state_capacity_started_395), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_425 value_21;
                    } else block_537: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_23).plan).*;

                        const value_25: []const u64 = (block_536: {
                            break :block_536 (&value_24);
                        }).mapping;
                        const value_26: u64 = block_535: {
                            break :block_535 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_534: {
                            break :block_534 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_533: {
                                break :block_533 block_532: {
                                    const operand_531 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_531).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_518: {
                                        break :block_518 (&value_24);
                                    }).count, .mapping = block_527: {
                                        const operand_520 = block_519: {
                                            break :block_519 value_25;
                                        };
                                        const operand_522 = block_521: {
                                            break :block_521 value_26;
                                        };

                                        if ((operand_522 >= (operand_520).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_524 = (block_523: {
                                            break :block_523 value_22;
                                        } + @as(u64, 1));

                                        break :block_527 @as([]const u64, (if (((buffers).lane_0 != null)) block_525: {
                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_520));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_520).len;
                                            }

                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_522)] = operand_524;

                                            break :block_525 ((((buffers).lane_0.?).buffer).*).items;
                                        } else block_526: {
                                            if ((!state_capacity_started_397)) {
                                                (try (state_capacity_396).appendSlice(allocator, operand_520));

                                                state_capacity_started_397 = true;
                                            } else {
                                                ((state_capacity_396).items).len = (operand_520).len;
                                            }

                                            ((state_capacity_396).items)[@intCast(operand_522)] = operand_524;
                                            break :block_526 (state_capacity_396).items;
                                        }));
                                    }, .order = (block_528: {
                                        break :block_528 (&value_24);
                                    }).order, .origins = (block_529: {
                                        break :block_529 (&value_24);
                                    }).origins, .status = (block_530: {
                                        break :block_530 (&value_24);
                                    }).status, });

                                    break :block_532 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_531);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_28).plan).*;

                        const value_30: []const u32 = (block_517: {
                            break :block_517 (&value_29);
                        }).order;
                        const value_31: u64 = block_516: {
                            break :block_516 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_515: {
                            break :block_515 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_514: {
                                break :block_514 block_513: {
                                    const operand_512 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_512).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_497: {
                                        break :block_497 (&value_29);
                                    }).count, .mapping = (block_498: {
                                        break :block_498 (&value_29);
                                    }).mapping, .order = block_509: {
                                        const operand_500 = block_499: {
                                            break :block_499 value_30;
                                        };
                                        const operand_502 = block_501: {
                                            break :block_501 value_31;
                                        };

                                        if ((operand_502 >= (operand_500).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_506 = block_505: {
                                            const operand_504 = block_503: {
                                                break :block_503 value_6;
                                            };

                                            break :block_505 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_504));
                                        };

                                        break :block_509 @as([]const u32, (if (((buffers).lane_1 != null)) block_507: {
                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_500));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_500).len;
                                            }

                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_502)] = operand_506;

                                            break :block_507 ((((buffers).lane_1.?).buffer).*).items;
                                        } else block_508: {
                                            if ((!state_capacity_started_399)) {
                                                (try (state_capacity_398).appendSlice(allocator, operand_500));

                                                state_capacity_started_399 = true;
                                            } else {
                                                ((state_capacity_398).items).len = (operand_500).len;
                                            }

                                            ((state_capacity_398).items)[@intCast(operand_502)] = operand_506;

                                            break :block_508 (state_capacity_398).items;
                                        }));
                                    }, .origins = (block_510: {
                                        break :block_510 (&value_29);
                                    }).origins, .status = (block_511: {
                                        break :block_511 (&value_29);
                                    }).status, });

                                    break :block_513 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_512);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_33).plan).*;

                        const value_35: u64 = (block_496: {
                            break :block_496 (&value_34);
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_495: {
                            break :block_495 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_494: {
                                break :block_494 block_493: {
                                    const operand_492 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_492).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_487: {
                                        break :block_487 value_35;
                                    } + @as(u64, 1)), .mapping = (block_488: {
                                        break :block_488 (&value_34);
                                    }).mapping, .order = (block_489: {
                                        break :block_489 (&value_34);
                                    }).order, .origins = (block_490: {
                                        break :block_490 (&value_34);
                                    }).origins, .status = (block_491: {
                                        break :block_491 (&value_34);
                                    }).status, });

                                    break :block_493 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_492);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_486: {
                            const operand_485 = block_484: {
                                const operand_482 = (((value_36).request).table).kinds;

                                const operand_483 = block_481: {
                                    break :block_481 value_6;
                                };

                                if ((operand_483 >= (operand_482).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_484 (operand_482)[@intCast(operand_483)];
                            };

                            break :block_486 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_485));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_426: {
                            break :block_426 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_427: {
                            break :block_427 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_480: {
                            const value_38: u64 = block_479: {
                                const operand_469 = ((value_36).request).origins;
                                const operand_470 = ((value_36).request).names;

                                const operand_472 = block_471: {
                                    break :block_471 value_6;
                                };
                                const operand_477 = block_476: {
                                    const operand_474 = (((value_36).request).table).labels;

                                    const operand_475 = block_473: {
                                        break :block_473 value_6;
                                    };

                                    if ((operand_475 >= (operand_474).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_476 (operand_474)[@intCast(operand_475)];
                                };

                                const operand_478 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_469, .names = operand_470, .index = operand_472, .name = operand_477, };

                                break :block_479 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_478)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_428: {
                                break :block_428 value_38;
                            } == @as(u64, 0))) block_437: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_39).plan).*;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_436: {
                                    break :block_436 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_435: {
                                        break :block_435 block_434: {
                                            const operand_433 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_433).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_429: {
                                                break :block_429 (&value_40);
                                            }).count, .mapping = (block_430: {
                                                break :block_430 (&value_40);
                                            }).mapping, .order = (block_431: {
                                                break :block_431 (&value_40);
                                            }).order, .origins = (block_432: {
                                                break :block_432 (&value_40);
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_434 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_433);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_437 value_41;
                            } else block_468: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_438: {
                                    break :block_438 value_38;
                                } == @as(u64, 1))) block_447: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_42).plan).*;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_446: {
                                        break :block_446 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_445: {
                                            break :block_445 block_444: {
                                                const operand_443 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_443).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_439: {
                                                    break :block_439 (&value_43);
                                                }).count, .mapping = (block_440: {
                                                    break :block_440 (&value_43);
                                                }).mapping, .order = (block_441: {
                                                    break :block_441 (&value_43);
                                                }).order, .origins = (block_442: {
                                                    break :block_442 (&value_43);
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_444 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_443);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_447 value_44;
                                } else block_467: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = ((value_45).plan).*;

                                    const value_47: []const u64 = (block_466: {
                                        break :block_466 (&value_46);
                                    }).origins;
                                    const value_48: u64 = block_465: {
                                        break :block_465 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_464: {
                                        break :block_464 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_463: {
                                            break :block_463 block_462: {
                                                const operand_461 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_461).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_448: {
                                                    break :block_448 (&value_46);
                                                }).count, .mapping = (block_449: {
                                                    break :block_449 (&value_46);
                                                }).mapping, .order = (block_450: {
                                                    break :block_450 (&value_46);
                                                }).order, .origins = block_459: {
                                                    const operand_452 = block_451: {
                                                        break :block_451 value_47;
                                                    };
                                                    const operand_454 = block_453: {
                                                        break :block_453 value_48;
                                                    };

                                                    if ((operand_454 >= (operand_452).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_456 = (block_455: {
                                                        break :block_455 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_459 @as([]const u64, (if (((buffers).lane_2 != null)) block_457: {
                                                        if ((!(((buffers).lane_2.?).started).*)) {
                                                            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_452));
                                                            (((buffers).lane_2.?).started).* = true;
                                                        } else {
                                                            (((((buffers).lane_2.?).buffer).*).items).len = (operand_452).len;
                                                        }

                                                        (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_454)] = operand_456;

                                                        break :block_457 ((((buffers).lane_2.?).buffer).*).items;
                                                    } else block_458: {
                                                        if ((!state_capacity_started_401)) {
                                                            (try (state_capacity_400).appendSlice(allocator, operand_452));

                                                            state_capacity_started_401 = true;
                                                        } else {
                                                            ((state_capacity_400).items).len = (operand_452).len;
                                                        }

                                                        ((state_capacity_400).items)[@intCast(operand_454)] = operand_456;
                                                        break :block_458 (state_capacity_400).items;
                                                    }));
                                                }, .status = (block_460: {
                                                    break :block_460 (&value_46);
                                                }).status, });

                                                break :block_462 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_461);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_467 value_49;
                                });

                                break :block_468 value_50;
                            });

                            break :block_480 value_51;
                        } else value_36);

                        break :block_537 value_52;
                    });

                    break :block_538 value_53;
                } else value_13);

                break :block_555 value_54;
            };
        }

        var state_owned_556: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_556);

        if (state_capacity_started_393) {
            ((state_capacity_392).items).len = (((state_381).pending).ids).len;
            state_owned_556 = (try (state_capacity_392).toOwnedSlice(allocator));
        }

        if (state_capacity_started_393) {
            state_381 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_556, .ready = ((state_381).pending).ready, }), .plan = (state_381).plan, .request = (state_381).request, };
        }

        var state_owned_557: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_557);

        if (state_capacity_started_395) {
            ((state_capacity_394).items).len = (((state_381).pending).ready).len;
            state_owned_557 = (try (state_capacity_394).toOwnedSlice(allocator));
        }

        if (state_capacity_started_395) {
            state_381 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_381).pending).ids, .ready = state_owned_557, }), .plan = (state_381).plan, .request = (state_381).request, };
        }

        var state_owned_558: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_558);

        if (state_capacity_started_397) {
            ((state_capacity_396).items).len = (((state_381).plan).mapping).len;
            state_owned_558 = (try (state_capacity_396).toOwnedSlice(allocator));
        }

        if (state_capacity_started_397) {
            state_381 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_381).pending, .plan = block_560: {
                const operand_559 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_559).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_381).plan).count, .mapping = state_owned_558, .order = ((state_381).plan).order, .origins = ((state_381).plan).origins, .status = ((state_381).plan).status, });

                break :block_560 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_559);
            }, .request = (state_381).request, };
        }

        var state_owned_561: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_561);

        if (state_capacity_started_399) {
            ((state_capacity_398).items).len = (((state_381).plan).order).len;
            state_owned_561 = (try (state_capacity_398).toOwnedSlice(allocator));
        }

        if (state_capacity_started_399) {
            state_381 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_381).pending, .plan = block_563: {
                const operand_562 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_562).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_381).plan).count, .mapping = ((state_381).plan).mapping, .order = state_owned_561, .origins = ((state_381).plan).origins, .status = ((state_381).plan).status, });

                break :block_563 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_562);
            }, .request = (state_381).request, };
        }

        var state_owned_564: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_564);

        if (state_capacity_started_401) {
            ((state_capacity_400).items).len = (((state_381).plan).origins).len;
            state_owned_564 = (try (state_capacity_400).toOwnedSlice(allocator));
        }

        if (state_capacity_started_401) {
            state_381 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_381).pending, .plan = block_566: {
                const operand_565 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_565).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_381).plan).count, .mapping = ((state_381).plan).mapping, .order = ((state_381).plan).order, .origins = state_owned_564, .status = ((state_381).plan).status, });

                break :block_566 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_565);
            }, .request = (state_381).request, };
        }

        break :block_573 block_572: {
            break :block_572 (if (((state_381).zx_origin != null)) ((state_381).zx_origin.?).* else block_571: {
                break :block_571 (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_381).pending).zx_origin != null)) ((state_381).pending).zx_origin.? else block_568: {
                    const operand_567 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_567).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_381).pending).ids, .ready = ((state_381).pending).ready, };

                    break :block_568 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_567);
                }), .plan = (state_381).plan, .request = (if ((((state_381).request).zx_origin != null)) ((state_381).request).zx_origin.? else block_570: {
                    const operand_569 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_569).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_381).request).maximum_count, .names = ((state_381).request).names, .origins = ((state_381).request).origins, .roots = ((state_381).request).roots, .scalar_count = ((state_381).request).scalar_count, .table = ((state_381).request).table, };

                    break :block_570 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_569);
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

    if ((block_784: {
        const operand_782 = ((in).state).mapping;
        const operand_783 = (in).index;

        if ((operand_783 >= (operand_782).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_784 (operand_782)[@intCast(operand_783)];
    } != @as(u64, 0))) {
        return (in).state;
    }

    const value_1: []const u64 = block_781: {
        const operand_780 = (in).index;

        break :block_781 (try (allocator).dupe(u64, (&[_]u64{operand_780, })));
    };

    const value_2: []const bool = block_779: {
        const operand_778 = false;

        break :block_779 (try (allocator).dupe(bool, (&[_]bool{operand_778, })));
    };

    const value_55: *const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = block_777: {
        const operand_593 = block_592: {
            const operand_582 = (in).request;
            const operand_583 = (in).state;

            const operand_584 = block_589: {
                const operand_585 = value_1;
                const operand_586 = value_2;

                break :block_589 block_588: {
                    const operand_587 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_587).* = @as((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = operand_585, .ready = operand_586, });

                    break :block_588 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_587);
                };
            };

            break :block_592 block_591: {
                const operand_590 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_590).* = @as((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .request = operand_582, .plan = operand_583, .pending = operand_584, });

                break :block_591 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_590);
            };
        };

        var state_capacity_595: (std).ArrayList(u64) = .empty;
        var state_capacity_started_596 = false;

        defer (state_capacity_595).deinit(allocator);

        var state_capacity_597: (std).ArrayList(bool) = .empty;
        var state_capacity_started_598 = false;

        defer (state_capacity_597).deinit(allocator);

        var state_capacity_599: (std).ArrayList(u64) = .empty;
        var state_capacity_started_600 = false;

        defer (state_capacity_599).deinit(allocator);

        var state_capacity_601: (std).ArrayList(u32) = .empty;
        var state_capacity_started_602 = false;

        defer (state_capacity_601).deinit(allocator);

        var state_capacity_603: (std).ArrayList(u64) = .empty;
        var state_capacity_started_604 = false;

        defer (state_capacity_603).deinit(allocator);

        var state_581: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((operand_593).pending).ids, .ready = ((operand_593).pending).ready, .zx_origin = (operand_593).pending, }, .plan = (operand_593).plan, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_593).request).maximum_count, .names = ((operand_593).request).names, .origins = ((operand_593).request).origins, .roots = ((operand_593).request).roots, .scalar_count = ((operand_593).request).scalar_count, .table = ((operand_593).request).table, .zx_origin = (operand_593).request, }, .zx_origin = operand_593, };
        var state_changed_594 = false;

        while (((((state_581).plan).status == @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready)) and (@as(u64, (((state_581).pending).ids).len) > @as(u64, 0)))) {
            state_581 = block_758: {
                const value_5: u64 = (@as(u64, (((state_581).pending).ids).len) - @as(u64, 1));

                const value_6: u64 = block_757: {
                    const operand_755 = ((state_581).pending).ids;

                    const operand_756 = block_754: {
                        break :block_754 value_5;
                    };

                    if ((operand_756 >= (operand_755).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_757 (operand_755)[@intCast(operand_756)];
                };
                const value_7: bool = block_753: {
                    const operand_751 = ((state_581).pending).ready;

                    const operand_752 = block_750: {
                        break :block_750 value_5;
                    };

                    if ((operand_752 >= (operand_751).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_753 (operand_751)[@intCast(operand_752)];
                };

                const value_8: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = state_581;
                const value_9: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_8).pending;

                const value_10: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_749: {
                    break :block_749 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_748: {
                        break :block_748 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_747: {
                            const operand_746 = ((state_581).pending).ids;

                            break :block_747 @as((zx_abi).value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_746).len == 0)) .{ operand_746, null, null, } else .{ (operand_746)[0..((operand_746).len - 1)], (operand_746)[((operand_746).len - 1)], null, }));
                        }).@"0", .ready = (value_9).ready, });
                    }, .plan = (value_8).plan, .request = (value_8).request, });
                };

                const value_11: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_10;
                const value_12: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_11).pending;

                const value_13: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_745: {
                    break :block_745 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_744: {
                        break :block_744 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_12).ids, .ready = (block_743: {
                            const operand_742 = ((value_10).pending).ready;

                            break :block_743 @as((zx_abi).value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754, (if (((operand_742).len == 0)) .{ operand_742, null, null, } else .{ (operand_742)[0..((operand_742).len - 1)], (operand_742)[((operand_742).len - 1)], null, }));
                        }).@"0", });
                    }, .plan = (value_11).plan, .request = (value_11).request, });
                };

                const value_54: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_608: {
                    const operand_606 = ((value_13).plan).mapping;

                    const operand_607 = block_605: {
                        break :block_605 value_6;
                    };

                    if ((operand_607 >= (operand_606).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_608 (operand_606)[@intCast(operand_607)];
                } == @as(u64, 0))) block_741: {
                    const value_53: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((!block_609: {
                        break :block_609 value_7;
                    })) block_628: {
                        const value_14: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_15: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pending;

                        const value_16: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_627: {
                            break :block_627 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_626: {
                                break :block_626 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (block_625: {
                                    const operand_622 = ((value_13).pending).ids;

                                    const operand_624 = block_623: {
                                        break :block_623 value_6;
                                    };

                                    _ = (try ((std).math).add(usize, (operand_622).len, 1));

                                    if ((!state_capacity_started_596)) {
                                        (try (state_capacity_595).appendSlice(allocator, operand_622));

                                        state_capacity_started_596 = true;
                                    } else {
                                        ((state_capacity_595).items).len = (operand_622).len;
                                    }

                                    (try (state_capacity_595).append(allocator, operand_624));

                                    break :block_625 @as((zx_abi).value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_595).items, {}, null, });
                                }).@"0", .ready = (value_15).ready, });
                            }, .plan = (value_14).plan, .request = (value_14).request, });
                        };
                        const value_17: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_16;
                        const value_18: (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_17).pending;

                        const value_19: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_621: {
                            break :block_621 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = block_620: {
                                break :block_620 @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = (value_18).ids, .ready = (block_619: {
                                    const operand_617 = ((value_16).pending).ready;
                                    const operand_618 = true;

                                    _ = (try ((std).math).add(usize, (operand_617).len, 1));

                                    if ((!state_capacity_started_598)) {
                                        (try (state_capacity_597).appendSlice(allocator, operand_617));
                                        state_capacity_started_598 = true;
                                    } else {
                                        ((state_capacity_597).items).len = (operand_617).len;
                                    }

                                    (try (state_capacity_597).append(allocator, operand_618));

                                    break :block_619 @as((zx_abi).value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_597).items, {}, null, });
                                }).@"0", });
                            }, .plan = (value_17).plan, .request = (value_17).request, });
                        };
                        const value_20: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_19;

                        const value_21: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_616: {
                            break :block_616 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_615: {
                                break :block_615 (try (@import("zxc_module_fcc0c4a22383a2bd5fe917c9af9c6546c46eb86250256bcdf733b48fffee48d4")).callBuffered(allocator, block_614: {
                                    const operand_610 = ((value_19).request).table;

                                    const operand_611 = block_612: {
                                        break :block_612 value_6;
                                    };

                                    const operand_613 = (value_19).pending;

                                    break :block_614 @as((zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1, (zx_abi).value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1{ .table = operand_610, .index = operand_611, .pending = operand_613, });
                                }, .{ .lane_0 = .{ .buffer = (&state_capacity_595), .started = (&state_capacity_started_596), }, .lane_1 = .{ .buffer = (&state_capacity_597), .started = (&state_capacity_started_598), }, }));
                            }), .plan = (value_20).plan, .request = (value_20).request, });
                        };

                        break :block_628 value_21;
                    } else block_740: {
                        const value_22: u64 = ((value_13).plan).count;
                        const value_23: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_13;
                        const value_24: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_23).plan;

                        const value_25: []const u64 = (block_739: {
                            break :block_739 value_24;
                        }).mapping;
                        const value_26: u64 = block_738: {
                            break :block_738 value_6;
                        };
                        const value_27: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_737: {
                            break :block_737 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_23).pending, .plan = block_736: {
                                break :block_736 block_735: {
                                    const operand_734 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_734).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_721: {
                                        break :block_721 value_24;
                                    }).count, .mapping = block_730: {
                                        const operand_723 = block_722: {
                                            break :block_722 value_25;
                                        };
                                        const operand_725 = block_724: {
                                            break :block_724 value_26;
                                        };

                                        if ((operand_725 >= (operand_723).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_727 = (block_726: {
                                            break :block_726 value_22;
                                        } + @as(u64, 1));

                                        break :block_730 @as([]const u64, (if (((buffers).lane_0 != null)) block_728: {
                                            if ((!(((buffers).lane_0.?).started).*)) {
                                                (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_723));
                                                (((buffers).lane_0.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_0.?).buffer).*).items).len = (operand_723).len;
                                            }

                                            (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_725)] = operand_727;

                                            break :block_728 ((((buffers).lane_0.?).buffer).*).items;
                                        } else block_729: {
                                            if ((!state_capacity_started_600)) {
                                                (try (state_capacity_599).appendSlice(allocator, operand_723));

                                                state_capacity_started_600 = true;
                                            } else {
                                                ((state_capacity_599).items).len = (operand_723).len;
                                            }

                                            ((state_capacity_599).items)[@intCast(operand_725)] = operand_727;

                                            break :block_729 (state_capacity_599).items;
                                        }));
                                    }, .order = (block_731: {
                                        break :block_731 value_24;
                                    }).order, .origins = (block_732: {
                                        break :block_732 value_24;
                                    }).origins, .status = (block_733: {
                                        break :block_733 value_24;
                                    }).status, });

                                    break :block_735 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_734);
                                };
                            }, .request = (value_23).request, });
                        };

                        const value_28: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_27;
                        const value_29: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_28).plan;

                        const value_30: []const u32 = (block_720: {
                            break :block_720 value_29;
                        }).order;
                        const value_31: u64 = block_719: {
                            break :block_719 value_22;
                        };
                        const value_32: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_718: {
                            break :block_718 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_28).pending, .plan = block_717: {
                                break :block_717 block_716: {
                                    const operand_715 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_715).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_700: {
                                        break :block_700 value_29;
                                    }).count, .mapping = (block_701: {
                                        break :block_701 value_29;
                                    }).mapping, .order = block_712: {
                                        const operand_703 = block_702: {
                                            break :block_702 value_30;
                                        };
                                        const operand_705 = block_704: {
                                            break :block_704 value_31;
                                        };

                                        if ((operand_705 >= (operand_703).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_709 = block_708: {
                                            const operand_707 = block_706: {
                                                break :block_706 value_6;
                                            };

                                            break :block_708 (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, operand_707));
                                        };

                                        break :block_712 @as([]const u32, (if (((buffers).lane_1 != null)) block_710: {
                                            if ((!(((buffers).lane_1.?).started).*)) {
                                                (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_703));
                                                (((buffers).lane_1.?).started).* = true;
                                            } else {
                                                (((((buffers).lane_1.?).buffer).*).items).len = (operand_703).len;
                                            }

                                            (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_705)] = operand_709;

                                            break :block_710 ((((buffers).lane_1.?).buffer).*).items;
                                        } else block_711: {
                                            if ((!state_capacity_started_602)) {
                                                (try (state_capacity_601).appendSlice(allocator, operand_703));

                                                state_capacity_started_602 = true;
                                            } else {
                                                ((state_capacity_601).items).len = (operand_703).len;
                                            }

                                            ((state_capacity_601).items)[@intCast(operand_705)] = operand_709;

                                            break :block_711 (state_capacity_601).items;
                                        }));
                                    }, .origins = (block_713: {
                                        break :block_713 value_29;
                                    }).origins, .status = (block_714: {
                                        break :block_714 value_29;
                                    }).status, });

                                    break :block_716 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_715);
                                };
                            }, .request = (value_28).request, });
                        };
                        const value_33: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_32;
                        const value_34: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_33).plan;

                        const value_35: u64 = (block_699: {
                            break :block_699 value_34;
                        }).count;

                        const value_36: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_698: {
                            break :block_698 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_33).pending, .plan = block_697: {
                                break :block_697 block_696: {
                                    const operand_695 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                    (operand_695).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_690: {
                                        break :block_690 value_35;
                                    } + @as(u64, 1)), .mapping = (block_691: {
                                        break :block_691 value_34;
                                    }).mapping, .order = (block_692: {
                                        break :block_692 value_34;
                                    }).order, .origins = (block_693: {
                                        break :block_693 value_34;
                                    }).origins, .status = (block_694: {
                                        break :block_694 value_34;
                                    }).status, });

                                    break :block_696 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_695);
                                };
                            }, .request = (value_33).request, });
                        };
                        const value_37: (zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = block_689: {
                            const operand_688 = block_687: {
                                const operand_685 = (((value_36).request).table).kinds;

                                const operand_686 = block_684: {
                                    break :block_684 value_6;
                                };

                                if ((operand_686 >= (operand_685).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_687 (operand_685)[@intCast(operand_686)];
                            };

                            break :block_689 (try (@import("zxc_module_0cf4ad6c9f1d61369d38fc86dc3ea82672c603aac792ffaeb7dabd13e68427d5")).call(allocator, operand_688));
                        };

                        const value_52: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if (((block_629: {
                            break :block_629 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .Enumeration)) or (block_630: {
                            break :block_630 value_37;
                        } == @as((zx_abi).zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd, .NativeReference)))) block_683: {
                            const value_38: u64 = block_682: {
                                const operand_672 = ((value_36).request).origins;
                                const operand_673 = ((value_36).request).names;

                                const operand_675 = block_674: {
                                    break :block_674 value_6;
                                };
                                const operand_680 = block_679: {
                                    const operand_677 = (((value_36).request).table).labels;

                                    const operand_678 = block_676: {
                                        break :block_676 value_6;
                                    };

                                    if ((operand_678 >= (operand_677).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_679 (operand_677)[@intCast(operand_678)];
                                };
                                const operand_681 = (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae{ .origins = operand_672, .names = operand_673, .index = operand_675, .name = operand_680, };

                                break :block_682 (try (@import("zxc_module_6cd87c652ae7b180829ab29d874a6d1f20589ce50882aafb756f86218e280699")).call(allocator, (&operand_681)));
                            };
                            const value_51: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_631: {
                                break :block_631 value_38;
                            } == @as(u64, 0))) block_640: {
                                const value_39: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                const value_40: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_39).plan;

                                const value_41: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_639: {
                                    break :block_639 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_39).pending, .plan = block_638: {
                                        break :block_638 block_637: {
                                            const operand_636 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                            (operand_636).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_632: {
                                                break :block_632 value_40;
                                            }).count, .mapping = (block_633: {
                                                break :block_633 value_40;
                                            }).mapping, .order = (block_634: {
                                                break :block_634 value_40;
                                            }).order, .origins = (block_635: {
                                                break :block_635 value_40;
                                            }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .MissingOrigin), });

                                            break :block_637 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_636);
                                        };
                                    }, .request = (value_39).request, });
                                };

                                break :block_640 value_41;
                            } else block_671: {
                                const value_50: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = (if ((block_641: {
                                    break :block_641 value_38;
                                } == @as(u64, 1))) block_650: {
                                    const value_42: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_43: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_42).plan;

                                    const value_44: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_649: {
                                        break :block_649 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_42).pending, .plan = block_648: {
                                            break :block_648 block_647: {
                                                const operand_646 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_646).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_642: {
                                                    break :block_642 value_43;
                                                }).count, .mapping = (block_643: {
                                                    break :block_643 value_43;
                                                }).mapping, .order = (block_644: {
                                                    break :block_644 value_43;
                                                }).order, .origins = (block_645: {
                                                    break :block_645 value_43;
                                                }).origins, .status = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid), });

                                                break :block_647 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_646);
                                            };
                                        }, .request = (value_42).request, });
                                    };

                                    break :block_650 value_44;
                                } else block_670: {
                                    const value_45: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = value_36;
                                    const value_46: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (value_45).plan;

                                    const value_47: []const u64 = (block_669: {
                                        break :block_669 value_46;
                                    }).origins;
                                    const value_48: u64 = block_668: {
                                        break :block_668 value_22;
                                    };
                                    const value_49: (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = block_667: {
                                        break :block_667 @as((zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280, (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (value_45).pending, .plan = block_666: {
                                            break :block_666 block_665: {
                                                const operand_664 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                                                (operand_664).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (block_651: {
                                                    break :block_651 value_46;
                                                }).count, .mapping = (block_652: {
                                                    break :block_652 value_46;
                                                }).mapping, .order = (block_653: {
                                                    break :block_653 value_46;
                                                }).order, .origins = block_662: {
                                                    const operand_655 = block_654: {
                                                        break :block_654 value_47;
                                                    };
                                                    const operand_657 = block_656: {
                                                        break :block_656 value_48;
                                                    };

                                                    if ((operand_657 >= (operand_655).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }
                                                    const operand_659 = (block_658: {
                                                        break :block_658 value_38;
                                                    } - @as(u64, 1));

                                                    break :block_662 @as([]const u64, (if (((buffers).lane_2 != null)) block_660: {
                                                        if ((!(((buffers).lane_2.?).started).*)) {
                                                            (try ((((buffers).lane_2.?).buffer).*).appendSlice(allocator, operand_655));
                                                            (((buffers).lane_2.?).started).* = true;
                                                        } else {
                                                            (((((buffers).lane_2.?).buffer).*).items).len = (operand_655).len;
                                                        }

                                                        (((((buffers).lane_2.?).buffer).*).items)[@intCast(operand_657)] = operand_659;

                                                        break :block_660 ((((buffers).lane_2.?).buffer).*).items;
                                                    } else block_661: {
                                                        if ((!state_capacity_started_604)) {
                                                            (try (state_capacity_603).appendSlice(allocator, operand_655));

                                                            state_capacity_started_604 = true;
                                                        } else {
                                                            ((state_capacity_603).items).len = (operand_655).len;
                                                        }

                                                        ((state_capacity_603).items)[@intCast(operand_657)] = operand_659;

                                                        break :block_661 (state_capacity_603).items;
                                                    }));
                                                }, .status = (block_663: {
                                                    break :block_663 value_46;
                                                }).status, });

                                                break :block_665 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_664);
                                            };
                                        }, .request = (value_45).request, });
                                    };

                                    break :block_670 value_49;
                                });

                                break :block_671 value_50;
                            });

                            break :block_683 value_51;
                        } else value_36);

                        break :block_740 value_52;
                    });

                    break :block_741 value_53;
                } else value_13);

                break :block_758 value_54;
            };

            state_changed_594 = true;
        }

        var state_owned_759: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_759);

        if (state_capacity_started_596) {
            ((state_capacity_595).items).len = (((state_581).pending).ids).len;
            state_owned_759 = (try (state_capacity_595).toOwnedSlice(allocator));
        }

        if (state_capacity_started_596) {
            state_581 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = state_owned_759, .ready = ((state_581).pending).ready, }), .plan = (state_581).plan, .request = (state_581).request, };
        }

        var state_owned_760: []const bool = (&[_]bool{});

        errdefer (allocator).free(state_owned_760);

        if (state_capacity_started_598) {
            ((state_capacity_597).items).len = (((state_581).pending).ready).len;
            state_owned_760 = (try (state_capacity_597).toOwnedSlice(allocator));
        }

        if (state_capacity_started_598) {
            state_581 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = @as((zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .ids = ((state_581).pending).ids, .ready = state_owned_760, }), .plan = (state_581).plan, .request = (state_581).request, };
        }

        var state_owned_761: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_761);

        if (state_capacity_started_600) {
            ((state_capacity_599).items).len = (((state_581).plan).mapping).len;
            state_owned_761 = (try (state_capacity_599).toOwnedSlice(allocator));
        }

        if (state_capacity_started_600) {
            state_581 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_581).pending, .plan = block_763: {
                const operand_762 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_762).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_581).plan).count, .mapping = state_owned_761, .order = ((state_581).plan).order, .origins = ((state_581).plan).origins, .status = ((state_581).plan).status, });

                break :block_763 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_762);
            }, .request = (state_581).request, };
        }

        var state_owned_764: []const u32 = (&[_]u32{});

        errdefer (allocator).free(state_owned_764);

        if (state_capacity_started_602) {
            ((state_capacity_601).items).len = (((state_581).plan).order).len;
            state_owned_764 = (try (state_capacity_601).toOwnedSlice(allocator));
        }

        if (state_capacity_started_602) {
            state_581 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_581).pending, .plan = block_766: {
                const operand_765 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_765).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_581).plan).count, .mapping = ((state_581).plan).mapping, .order = state_owned_764, .origins = ((state_581).plan).origins, .status = ((state_581).plan).status, });

                break :block_766 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_765);
            }, .request = (state_581).request, };
        }

        var state_owned_767: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_767);

        if (state_capacity_started_604) {
            ((state_capacity_603).items).len = (((state_581).plan).origins).len;
            state_owned_767 = (try (state_capacity_603).toOwnedSlice(allocator));
        }

        if (state_capacity_started_604) {
            state_581 = (zx_abi).value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280{ .pending = (state_581).pending, .plan = block_769: {
                const operand_768 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                (operand_768).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = ((state_581).plan).count, .mapping = ((state_581).plan).mapping, .order = ((state_581).plan).order, .origins = state_owned_767, .status = ((state_581).plan).status, });

                break :block_769 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_768);
            }, .request = (state_581).request, };
        }

        break :block_777 (if (state_changed_594) block_776: {
            break :block_776 (if (((state_581).zx_origin != null)) (state_581).zx_origin.? else block_775: {
                const operand_774 = (try (allocator).create((zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef));

                (operand_774).* = (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef{ .pending = (if ((((state_581).pending).zx_origin != null)) ((state_581).pending).zx_origin.? else block_771: {
                    const operand_770 = (try (allocator).create((zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac));

                    (operand_770).* = (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac{ .ids = ((state_581).pending).ids, .ready = ((state_581).pending).ready, };

                    break :block_771 @as(*const (zx_abi).zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac, operand_770);
                }), .plan = (state_581).plan, .request = (if ((((state_581).request).zx_origin != null)) ((state_581).request).zx_origin.? else block_773: {
                    const operand_772 = (try (allocator).create((zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77));

                    (operand_772).* = (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77{ .maximum_count = ((state_581).request).maximum_count, .names = ((state_581).request).names, .origins = ((state_581).request).origins, .roots = ((state_581).request).roots, .scalar_count = ((state_581).request).scalar_count, .table = ((state_581).request).table, };

                    break :block_773 @as(*const (zx_abi).zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77, operand_772);
                }), };

                break :block_775 @as(*const (zx_abi).zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef, operand_774);
            });
        } else operand_593);
    };

    return (value_55).plan;
}

