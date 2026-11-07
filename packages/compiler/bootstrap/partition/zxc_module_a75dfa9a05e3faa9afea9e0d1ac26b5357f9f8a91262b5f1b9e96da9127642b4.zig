const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec {
    @setRuntimeSafety(true);

    return block_69: {
        const value_17: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = block_68: {
            const operand_64 = (in).used;
            const operand_65 = (in).members;
            const operand_66 = (in).bytes;
            const operand_67 = @as(u64, 0);

            break :block_68 @as((zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7, (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7{
                .used = operand_64,
                .members = operand_65,
                .bytes = operand_66,
                .index = operand_67,
            });
        };

        const value_18: (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = in;

        break :block_69 block_63: {
            const value_16: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = block_62: {
                const operand_7 = value_17;
                var state_6: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = operand_7;
                var state_changed_9 = false;

                if (block_10: {
                    const value_2: (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = value_18;

                    break :block_10 ((state_6).index < @as(u64, (((value_2).nodes).items).len));
                }) {
                    (try (zx_abi).zxRenew(allocator, (&state_6), (&[_][2][]const u8{
                        .{
                            "used",
                            "zx_origin",
                        },
                    }), false));

                    while (true) {
                        const operand_53 = block_52: {
                            const value_4: (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = value_18;

                            break :block_52 block_51: {
                                const value_5: u32 = block_50: {
                                    const operand_48 = ((value_4).nodes).items;
                                    const operand_49 = (state_6).index;

                                    if ((operand_49 >= (operand_48).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_50 (operand_48)[@intCast(operand_49)];
                                };
                                const value_6: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_47: {
                                    break :block_47 value_5;
                                }));

                                var value_13: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = (if ((!block_16: {
                                    const operand_14 = ((state_6).used).items;

                                    const operand_15 = block_13: {
                                        break :block_13 value_6;
                                    };

                                    if ((operand_15 >= (operand_14).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_16 (operand_14)[@intCast(operand_15)];
                                })) block_46: {
                                    const value_7: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (state_6).used;

                                    const value_8: u64 = block_45: {
                                        break :block_45 value_6;
                                    };
                                    var value_9: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = block_44: {
                                        var updated_36: (zx_abi).value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = state_6;

                                        const operand_43 = block_42: {
                                            const operand_37 = value_7;
                                            const operand_39 = block_38: {
                                                break :block_38 value_8;
                                            };

                                            if ((operand_39 >= ((operand_37).items).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_40 = true;
                                            const operand_41 = @constCast((operand_37).items);

                                            (operand_41)[@intCast(operand_39)] = operand_40;

                                            break :block_42 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                .items = operand_41,
                                                .storage = (if ((@backingInt((operand_37).storage) >= 2)) .exclusive else .owned),
                                            };
                                        };
                                        (updated_36).used = operand_43;
                                        (updated_36).zx_origin = null;

                                        break :block_44 updated_36;
                                    };
                                    const operand_35 = (block_34: {
                                        const operand_23 = (value_9).members;

                                        const operand_25 = block_24: {
                                            break :block_24 value_5;
                                        };

                                        const operand_26 = (try ((std).math).add(usize, ((operand_23).items).len, 1));

                                        break :block_34 @as((zx_abi).value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb, .{
                                            block_33: {
                                                const operand_27 = operand_23;

                                                const operand_32 = (if ((@backingInt((operand_27).storage) >= 2)) block_30: {
                                                    const operand_29 = (try (zx_abi).zxReserve(u32, allocator, (operand_27).items, operand_26, true));

                                                    break :block_30 operand_29;
                                                } else block_31: {
                                                    const operand_28 = (try (zx_abi).zxReserve(u32, allocator, (operand_27).items, operand_26, false));

                                                    break :block_31 operand_28;
                                                });

                                                (operand_32)[((operand_23).items).len] = operand_25;

                                                break :block_33 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                                    .items = operand_32,
                                                    .storage = (if (((!(@backingInt((operand_23).storage) >= 2)) or ((operand_23).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    (value_9).members = operand_35;
                                    (value_9).zx_origin = null;
                                    const value_11: u64 = (value_9).bytes;

                                    const operand_22 = (block_17: {
                                        break :block_17 value_11;
                                    } + block_21: {
                                        const operand_19 = ((value_4).weights).items;

                                        const operand_20 = block_18: {
                                            break :block_18 value_6;
                                        };

                                        if ((operand_20 >= (operand_19).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_21 (operand_19)[@intCast(operand_20)];
                                    });

                                    (value_9).bytes = operand_22;
                                    (value_9).zx_origin = null;

                                    break :block_46 value_9;
                                } else state_6);

                                const value_14: u64 = (value_13).index;

                                const operand_12 = (block_11: {
                                    break :block_11 value_14;
                                } + @as(u64, 1));

                                (value_13).index = operand_12;
                                (value_13).zx_origin = null;

                                break :block_51 value_13;
                            };
                        };

                        const operand_54 = (operand_53).bytes;
                        const operand_55 = (operand_53).index;
                        const operand_56 = ((operand_53).members).items;
                        const operand_57 = ((operand_53).members).storage;
                        const operand_58 = ((operand_53).used).items;
                        const operand_59 = ((operand_53).used).storage;
                        const operand_60 = (operand_53).zx_origin;

                        (state_6).bytes = operand_54;
                        (state_6).index = operand_55;
                        ((state_6).members).items = operand_56;
                        ((state_6).members).storage = operand_57;
                        ((state_6).used).items = operand_58;
                        ((state_6).used).storage = operand_59;
                        (state_6).zx_origin = operand_60;
                        state_changed_9 = true;

                        if ((!block_10: {
                            const value_2: (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = value_18;

                            break :block_10 ((state_6).index < @as(u64, (((value_2).nodes).items).len));
                        })) {
                            break;
                        }
                    }
                }

                break :block_62 (if (state_changed_9) state_6 else operand_7);
            };

            break :block_63 block_5: {
                const operand_2 = (value_16).bytes;
                const operand_3 = (value_16).members;
                const operand_4 = (value_16).used;

                break :block_5 @as((zx_abi).value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec, (zx_abi).value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec{
                    .bytes = operand_2,
                    .members = operand_3,
                    .used = operand_4,
                });
            };
        };
    };
}
