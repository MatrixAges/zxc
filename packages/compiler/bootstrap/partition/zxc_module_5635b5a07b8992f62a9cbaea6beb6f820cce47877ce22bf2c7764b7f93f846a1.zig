const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96) error{
    IndexOutOfBounds,
    OutOfMemory,
}!u64 {
    @setRuntimeSafety(true);

    return block_89: {
        const value_35: (zx_abi).zx_type_4ae9c38e491a5e74a082a4101b123b1edfcec9d56ea3305e1058b3e072eb1285 = block_88: {
            const operand_84 = @as(u64, 0);
            const operand_85 = @as(u64, 0);
            const operand_86 = @as(u64, 0);
            const operand_87 = @as(u64, 0);

            break :block_88 (zx_abi).zx_type_4ae9c38e491a5e74a082a4101b123b1edfcec9d56ea3305e1058b3e072eb1285{
                .index = operand_84,
                .owner = operand_85,
                .cost = operand_86,
                .bytes = operand_87,
            };
        };

        const value_36: *const (zx_abi).zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96 = in;

        break :block_89 block_83: {
            break :block_83 block_82: {
                const operand_2 = ((&value_35)).*;

                var state_1: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f{
                    .bytes = (operand_2).bytes,
                    .cost = (operand_2).cost,
                    .index = (operand_2).index,
                    .owner = (operand_2).owner,
                    .zx_origin = (&operand_2),
                };
                while (block_5: {
                    const value_2: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = block_4: {
                        break :block_4 (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134{
                            .bytes = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                .items = (value_36).bytes,
                                .storage = .plain,
                            },
                            .capacity = (value_36).capacity,
                            .nodes = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                .items = (value_36).nodes,
                                .storage = .plain,
                            },
                            .used = (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
                                .items = (value_36).used,
                                .storage = .plain,
                            },
                            .weights = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                .items = (value_36).weights,
                                .storage = .plain,
                            },
                            .zx_origin = value_36,
                        };
                    };

                    break :block_5 ((state_1).index < @as(u64, (((value_2).used).items).len));
                }) {
                    const operand_75 = block_74: {
                        const value_4: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = block_73: {
                            break :block_73 (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134{
                                .bytes = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                    .items = (value_36).bytes,
                                    .storage = .plain,
                                },
                                .capacity = (value_36).capacity,
                                .nodes = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                    .items = (value_36).nodes,
                                    .storage = .plain,
                                },
                                .used = (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
                                    .items = (value_36).used,
                                    .storage = .plain,
                                },
                                .weights = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                    .items = (value_36).weights,
                                    .storage = .plain,
                                },
                                .zx_origin = value_36,
                            };
                        };
                        break :block_74 block_72: {
                            const value_5: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = block_71: {
                                break :block_71 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                    .items = block_70: {
                                        const operand_68 = ((value_4).used).items;
                                        const operand_69 = (state_1).index;

                                        if ((operand_69 >= (operand_68).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_70 (operand_68)[@intCast(operand_69)];
                                    },
                                    .storage = .plain,
                                };
                            };
                            const value_20: u64 = block_67: {
                                const value_18: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = block_66: {
                                    const operand_64 = @as(u64, 0);
                                    const operand_65 = @as(u64, 0);

                                    break :block_66 @as((zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306, (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306{
                                        .index = operand_64,
                                        .bytes = operand_65,
                                    });
                                };
                                const value_19: (zx_abi).value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705 = block_63: {
                                    const operand_61 = value_4;
                                    const operand_62 = value_5;

                                    break :block_63 @as((zx_abi).value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705, .{
                                        operand_61,
                                        operand_62,
                                        null,
                                    });
                                };
                                break :block_67 block_60: {
                                    break :block_60 block_59: {
                                        const operand_32 = value_18;
                                        var state_31: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = operand_32;

                                        while (block_34: {
                                            const value_7: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = (value_19).@"0";

                                            break :block_34 ((state_31).index < @as(u64, (((value_7).nodes).items).len));
                                        }) {
                                            const operand_55 = block_54: {
                                                const value_9: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = (value_19).@"0";
                                                const value_11: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_19).@"1";

                                                break :block_54 block_53: {
                                                    const value_10: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_52: {
                                                        const operand_50 = ((value_9).nodes).items;
                                                        const operand_51 = (state_31).index;

                                                        if ((operand_51 >= (operand_50).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_52 (operand_50)[@intCast(operand_51)];
                                                    }));

                                                    var value_14: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = (if ((!block_40: {
                                                        const operand_38 = (value_11).items;

                                                        const operand_39 = block_37: {
                                                            break :block_37 value_10;
                                                        };

                                                        if ((operand_39 >= (operand_38).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_40 (operand_38)[@intCast(operand_39)];
                                                    })) block_49: {
                                                        const value_12: u64 = (state_31).bytes;

                                                        const value_13: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = block_48: {
                                                            var updated_41: (zx_abi).value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = state_31;

                                                            const operand_47 = (block_42: {
                                                                break :block_42 value_12;
                                                            } + block_46: {
                                                                const operand_44 = ((value_9).weights).items;

                                                                const operand_45 = block_43: {
                                                                    break :block_43 value_10;
                                                                };

                                                                if ((operand_45 >= (operand_44).len)) {
                                                                    return error.IndexOutOfBounds;
                                                                }

                                                                break :block_46 (operand_44)[@intCast(operand_45)];
                                                            });

                                                            (updated_41).bytes = operand_47;
                                                            (updated_41).zx_origin = null;

                                                            break :block_48 updated_41;
                                                        };

                                                        break :block_49 value_13;
                                                    } else state_31);

                                                    const value_15: u64 = (value_14).index;

                                                    const operand_36 = (block_35: {
                                                        break :block_35 value_15;
                                                    } + @as(u64, 1));

                                                    (value_14).index = operand_36;
                                                    (value_14).zx_origin = null;

                                                    break :block_53 value_14;
                                                };
                                            };

                                            const operand_56 = (operand_55).bytes;
                                            const operand_57 = (operand_55).index;
                                            const operand_58 = (operand_55).zx_origin;

                                            (state_31).bytes = operand_56;
                                            (state_31).index = operand_57;
                                            (state_31).zx_origin = operand_58;
                                        }

                                        break :block_59 (state_31).bytes;
                                    };
                                };
                            };
                            const value_21: u64 = (block_29: {
                                const operand_27 = ((value_4).bytes).items;
                                const operand_28 = (state_1).index;

                                if ((operand_28 >= (operand_27).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_29 (operand_27)[@intCast(operand_28)];
                            } + block_30: {
                                break :block_30 value_20;
                            });

                            const value_22: u64 = (if ((block_25: {
                                break :block_25 value_21;
                            } > (value_4).capacity)) (block_26: {
                                break :block_26 value_21;
                            } - (value_4).capacity) else @as(u64, 0));

                            const value_23: u64 = (block_23: {
                                break :block_23 value_20;
                            } + block_24: {
                                break :block_24 value_22;
                            });

                            const value_24: bool = ((state_1).index == @as(u64, 0));

                            const value_25: bool = (block_22: {
                                break :block_22 value_23;
                            } < (state_1).cost);

                            const value_26: bool = ((block_20: {
                                break :block_20 value_23;
                            } == (state_1).cost) and (block_21: {
                                break :block_21 value_21;
                            } < (state_1).bytes));

                            const value_27: bool = (((!(!block_17: {
                                break :block_17 value_24;
                            })) or block_18: {
                                break :block_18 value_25;
                            }) or block_19: {
                                break :block_19 value_26;
                            });

                            var value_31: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = (if (block_8: {
                                break :block_8 value_27;
                            }) block_16: {
                                var value_28: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = block_15: {
                                    var updated_13: (zx_abi).value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = state_1;
                                    const operand_14 = (state_1).index;
                                    (updated_13).owner = operand_14;
                                    (updated_13).zx_origin = null;

                                    break :block_15 updated_13;
                                };
                                const operand_12 = block_11: {
                                    break :block_11 value_23;
                                };
                                (value_28).cost = operand_12;
                                (value_28).zx_origin = null;

                                const operand_10 = block_9: {
                                    break :block_9 value_21;
                                };
                                (value_28).bytes = operand_10;
                                (value_28).zx_origin = null;

                                break :block_16 value_28;
                            } else state_1);

                            const value_32: u64 = (value_31).index;

                            const operand_7 = (block_6: {
                                break :block_6 value_32;
                            } + @as(u64, 1));

                            (value_31).index = operand_7;
                            (value_31).zx_origin = null;

                            break :block_72 value_31;
                        };
                    };

                    const operand_76 = (operand_75).bytes;
                    const operand_77 = (operand_75).cost;
                    const operand_78 = (operand_75).index;
                    const operand_79 = (operand_75).owner;
                    const operand_80 = (operand_75).zx_origin;
                    (state_1).bytes = operand_76;
                    (state_1).cost = operand_77;
                    (state_1).index = operand_78;
                    (state_1).owner = operand_79;
                    (state_1).zx_origin = operand_80;
                }

                const operand_81 = (state_1).owner;

                break :block_82 operand_81;
            };
        };
    };
}
