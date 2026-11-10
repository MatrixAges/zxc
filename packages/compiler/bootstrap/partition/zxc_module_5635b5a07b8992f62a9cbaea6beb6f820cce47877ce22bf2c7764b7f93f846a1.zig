const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134) error{
    IndexOutOfBounds,
    OutOfMemory,
}!u64 {
    @setRuntimeSafety(true);

    return block_92: {
        const value_37: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = block_91: {
            const operand_87 = @as(u64, 0);
            const operand_88 = @as(u64, 0);
            const operand_89 = @as(u64, 0);
            const operand_90 = @as(u64, 0);

            break :block_91 @as((zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f, (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f{
                .index = operand_87,
                .owner = operand_88,
                .cost = operand_89,
                .bytes = operand_90,
            });
        };

        const value_38: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = in;

        break :block_92 block_86: {
            break :block_86 block_85: {
                const operand_2 = value_37;
                var state_1: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = operand_2;

                while (block_4: {
                    const value_2: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = value_38;

                    break :block_4 ((state_1).index < @as(u64, (((value_2).used).items).len));
                }) {
                    const operand_79 = block_78: {
                        const value_4: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = value_38;

                        break :block_78 block_77: {
                            const value_5: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = block_76: {
                                break :block_76 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                    .items = block_75: {
                                        const operand_73 = ((value_4).used).items;
                                        const operand_74 = (state_1).index;

                                        if ((operand_74 >= (operand_73).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_75 (operand_73)[@intCast(operand_74)];
                                    },
                                    .storage = .plain,
                                };
                            };
                            const value_20: u64 = block_72: {
                                const value_18: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = block_71: {
                                    const operand_69 = @as(u64, 0);
                                    const operand_70 = @as(u64, 0);

                                    break :block_71 @as((zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306, (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306{
                                        .index = operand_69,
                                        .bytes = operand_70,
                                    });
                                };
                                const value_19: (zx_abi).value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705 = block_68: {
                                    const operand_66 = value_4;
                                    const operand_67 = value_5;

                                    break :block_68 @as((zx_abi).value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705, .{
                                        operand_66,
                                        operand_67,
                                        null,
                                    });
                                };
                                break :block_72 block_65: {
                                    break :block_65 block_64: {
                                        const operand_36 = value_18;
                                        var state_35: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = operand_36;

                                        while (block_38: {
                                            const value_7: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = (value_19).@"0";

                                            break :block_38 ((state_35).index < @as(u64, (((value_7).nodes).items).len));
                                        }) {
                                            const operand_60 = block_59: {
                                                const value_9: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = (value_19).@"0";
                                                const value_11: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_19).@"1";

                                                break :block_59 block_58: {
                                                    const value_10: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_57: {
                                                        const operand_55 = ((value_9).nodes).items;
                                                        const operand_56 = (state_35).index;

                                                        if ((operand_56 >= (operand_55).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_57 (operand_55)[@intCast(operand_56)];
                                                    }));
                                                    var value_14: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = (if ((!block_44: {
                                                        const operand_42 = (value_11).items;

                                                        const operand_43 = block_41: {
                                                            break :block_41 value_10;
                                                        };

                                                        if ((operand_43 >= (operand_42).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_44 (operand_42)[@intCast(operand_43)];
                                                    })) block_54: {
                                                        const value_12: u64 = (state_35).bytes;

                                                        const value_13: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = block_53: {
                                                            break :block_53 block_52: {
                                                                var updated_45: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = state_35;

                                                                const operand_51 = (block_46: {
                                                                    break :block_46 value_12;
                                                                } + block_50: {
                                                                    const operand_48 = ((value_9).weights).items;

                                                                    const operand_49 = block_47: {
                                                                        break :block_47 value_10;
                                                                    };

                                                                    if ((operand_49 >= (operand_48).len)) {
                                                                        return error.IndexOutOfBounds;
                                                                    }

                                                                    break :block_50 (operand_48)[@intCast(operand_49)];
                                                                });

                                                                (updated_45).bytes = operand_51;
                                                                (updated_45).zx_origin = null;

                                                                break :block_52 updated_45;
                                                            };
                                                        };

                                                        break :block_54 value_13;
                                                    } else state_35);

                                                    const value_15: u64 = (value_14).index;

                                                    const operand_40 = (block_39: {
                                                        break :block_39 value_15;
                                                    } + @as(u64, 1));

                                                    (value_14).index = operand_40;
                                                    (value_14).zx_origin = null;

                                                    break :block_58 value_14;
                                                };
                                            };

                                            const operand_61 = (operand_60).bytes;
                                            const operand_62 = (operand_60).index;
                                            const operand_63 = (operand_60).zx_origin;
                                            (state_35).bytes = operand_61;
                                            (state_35).index = operand_62;
                                            (state_35).zx_origin = operand_63;
                                        }

                                        break :block_64 (state_35).bytes;
                                    };
                                };
                            };
                            const value_21: u64 = block_34: {
                                const operand_32 = ((value_4).bytes).items;
                                const operand_33 = (state_1).index;

                                if ((operand_33 >= (operand_32).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_34 (operand_32)[@intCast(operand_33)];
                            };
                            const value_22: u64 = (block_30: {
                                break :block_30 value_21;
                            } + block_31: {
                                break :block_31 value_20;
                            });

                            const value_23: u64 = (if ((block_28: {
                                break :block_28 value_22;
                            } > (value_4).capacity)) (block_29: {
                                break :block_29 value_22;
                            } - (value_4).capacity) else @as(u64, 0));

                            const value_24: u64 = (if ((block_26: {
                                break :block_26 value_21;
                            } > (value_4).capacity)) (block_27: {
                                break :block_27 value_21;
                            } - (value_4).capacity) else @as(u64, 0));

                            const value_25: u64 = ((block_23: {
                                break :block_23 value_20;
                            } + block_24: {
                                break :block_24 value_23;
                            }) - block_25: {
                                break :block_25 value_24;
                            });

                            const value_26: bool = ((state_1).index == @as(u64, 0));

                            const value_27: bool = (block_22: {
                                break :block_22 value_25;
                            } < (state_1).cost);

                            const value_28: bool = ((block_20: {
                                break :block_20 value_25;
                            } == (state_1).cost) and (block_21: {
                                break :block_21 value_22;
                            } < (state_1).bytes));

                            const value_29: bool = (((!(!block_17: {
                                break :block_17 value_26;
                            })) or block_18: {
                                break :block_18 value_27;
                            }) or block_19: {
                                break :block_19 value_28;
                            });

                            var value_33: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = (if (block_7: {
                                break :block_7 value_29;
                            }) block_16: {
                                var value_30: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = block_15: {
                                    break :block_15 block_14: {
                                        var updated_12: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = state_1;
                                        const operand_13 = (state_1).index;
                                        (updated_12).owner = operand_13;
                                        (updated_12).zx_origin = null;

                                        break :block_14 updated_12;
                                    };
                                };
                                const operand_11 = block_10: {
                                    break :block_10 value_25;
                                };

                                (value_30).cost = operand_11;
                                (value_30).zx_origin = null;

                                const operand_9 = block_8: {
                                    break :block_8 value_22;
                                };

                                (value_30).bytes = operand_9;
                                (value_30).zx_origin = null;

                                break :block_16 value_30;
                            } else state_1);

                            const value_34: u64 = (value_33).index;

                            const operand_6 = (block_5: {
                                break :block_5 value_34;
                            } + @as(u64, 1));

                            (value_33).index = operand_6;
                            (value_33).zx_origin = null;

                            break :block_77 value_33;
                        };
                    };

                    const operand_80 = (operand_79).bytes;
                    const operand_81 = (operand_79).cost;
                    const operand_82 = (operand_79).index;
                    const operand_83 = (operand_79).owner;
                    const operand_84 = (operand_79).zx_origin;
                    (state_1).bytes = operand_80;
                    (state_1).cost = operand_81;
                    (state_1).index = operand_82;
                    (state_1).owner = operand_83;
                    (state_1).zx_origin = operand_84;
                }

                break :block_85 (state_1).owner;
            };
        };
    };
}
