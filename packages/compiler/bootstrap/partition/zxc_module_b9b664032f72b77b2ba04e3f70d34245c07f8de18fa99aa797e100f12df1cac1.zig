const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!u64 {
    @setRuntimeSafety(true);

    if ((@as(u64, (((in).closures).items).len) == @as(u64, 0))) {
        return @as(u64, 0);
    }

    const value_38: u64 = block_130: {
        const value_36: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_129: {
            const operand_93 = block_126: {
                const value_2: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                    .items = ((in).graph).sizes,
                    .storage = .plain,
                };

                break :block_126 block_125: {
                    const operand_99 = block_98: {
                        const operand_95 = value_2;
                        const operand_96 = @as(u64, 0);

                        const operand_97 = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                            .items = @as([]const bool, (comptime (&[_]bool{}))),
                            .storage = .plain,
                        };

                        break :block_98 @as((zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c, (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = operand_96,
                            .result = operand_97,
                            .source = operand_95,
                        });
                    };
                    const loop_fields_101 = struct {
                        index: u64,
                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                    };

                    var qualified_102: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = operand_99;

                    ((qualified_102).source).storage = (if ((@backingInt(((qualified_102).source).storage) >= 2)) .shared else .plain);
                    const loop_seed_100: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = qualified_102;

                    break :block_125 (if (((loop_seed_100).index < @as(u64, (((loop_seed_100).source).items).len))) block_123: {
                        var qualified_119: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_100).source;

                        (qualified_119).storage = (if ((@backingInt((qualified_119).storage) >= 2)) .shared else .plain);

                        const operand_120 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (loop_seed_100).index,
                            .result = (loop_seed_100).result,
                            .source = qualified_119,
                            .zx_origin = (loop_seed_100).zx_origin,
                        };

                        var state_94: loop_fields_101 = loop_fields_101{
                            .index = (operand_120).index,
                            .result = (operand_120).result,
                            .source = (&(operand_120).source),
                            .zx_origin = (operand_120).zx_origin,
                        };

                        while (true) {
                            const operand_121 = block_118: {
                                _ = block_117: {
                                    const operand_115 = (((state_94).source).*).items;
                                    const operand_116 = (state_94).index;

                                    if ((operand_116 >= (operand_115).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_117 (operand_115)[@intCast(operand_116)];
                                };

                                const value_6: bool = false;

                                break :block_118 block_114: {
                                    const operand_103 = ((state_94).source).*;
                                    const operand_104 = ((state_94).index + @as(u64, 1));
                                    const operand_105 = (block_112: {
                                        const operand_106 = (state_94).result;

                                        const operand_108 = block_107: {
                                            break :block_107 value_6;
                                        };

                                        const operand_109 = (try ((std).math).add(usize, ((operand_106).items).len, 1));

                                        break :block_112 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                            block_111: {
                                                const operand_110 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_106).items, operand_109, (((loop_seed_100).source).items).len));

                                                (operand_110)[((operand_106).items).len] = operand_108;

                                                break :block_111 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                    .items = operand_110,
                                                    .storage = (if ((((((operand_106).items).len == 0) or ((operand_110).ptr != ((operand_106).items).ptr)) or ((operand_106).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_114 loop_fields_101{
                                        .index = operand_104,
                                        .result = operand_105,
                                        .source = block_113: {
                                            _ = operand_103;

                                            break :block_113 (&(loop_seed_100).source);
                                        },
                                    };
                                };
                            };

                            state_94 = loop_fields_101{
                                .index = (operand_121).index,
                                .result = (operand_121).result,
                                .source = (operand_121).source,
                                .zx_origin = (operand_121).zx_origin,
                            };

                            if ((!((state_94).index < @as(u64, ((((state_94).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_122 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (state_94).index,
                            .result = (state_94).result,
                            .source = ((state_94).source).*,
                            .zx_origin = (state_94).zx_origin,
                        };

                        break :block_123 (operand_122).result;
                    } else block_124: {
                        break :block_124 (loop_seed_100).result;
                    });
                };
            };

            const operand_127 = @as(u64, 0);
            const operand_128 = @as(u64, 0);

            break :block_129 @as((zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f, (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f{
                .seen = operand_93,
                .bytes = operand_127,
                .index = operand_128,
            });
        };

        const value_37: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = in;

        break :block_130 block_92: {
            break :block_92 block_91: {
                const operand_12 = value_36;
                var state_11: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = operand_12;

                while (block_14: {
                    const value_9: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = value_37;

                    break :block_14 ((state_11).index < @as(u64, (((value_9).closures).items).len));
                }) {
                    const operand_85 = block_84: {
                        const value_11: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = value_37;

                        break :block_84 block_83: {
                            const value_12: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                .items = (block_82: {
                                    const operand_80 = ((value_11).closures).items;
                                    const operand_81 = (state_11).index;

                                    if ((operand_81 >= (operand_80).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_82 (operand_80)[@intCast(operand_81)];
                                }).nodes,
                                .storage = .plain,
                            };
                            const value_30: (zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a = block_79: {
                                const value_28: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_78: {
                                    const operand_72 = (state_11).seen;
                                    const operand_73 = (state_11).bytes;
                                    const operand_74 = @as(u64, 0);
                                    _ = operand_72;
                                    _ = operand_73;

                                    break :block_78 block_77: {
                                        var updated_75: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = state_11;
                                        const operand_76 = operand_74;
                                        (updated_75).index = operand_76;
                                        (updated_75).zx_origin = null;

                                        break :block_77 updated_75;
                                    };
                                };
                                const value_29: (zx_abi).value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b = block_71: {
                                    const operand_69 = value_12;
                                    const operand_70 = value_11;

                                    break :block_71 @as((zx_abi).value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b, .{
                                        operand_69,
                                        operand_70,
                                        null,
                                    });
                                };
                                break :block_79 block_68: {
                                    const value_27: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_67: {
                                        const operand_27 = value_28;
                                        var state_26: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = operand_27;
                                        var state_changed_29 = false;

                                        while (block_30: {
                                            const value_14: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_29).@"0";

                                            break :block_30 ((state_26).index < @as(u64, ((value_14).items).len));
                                        }) {
                                            const operand_60 = block_59: {
                                                const value_16: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_29).@"0";
                                                const value_22: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = (value_29).@"1";

                                                break :block_59 block_58: {
                                                    const value_17: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_57: {
                                                        const operand_55 = (value_16).items;
                                                        const operand_56 = (state_26).index;

                                                        if ((operand_56 >= (operand_55).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_57 (operand_55)[@intCast(operand_56)];
                                                    }));

                                                    var value_24: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = (if ((!block_36: {
                                                        const operand_34 = ((state_26).seen).items;

                                                        const operand_35 = block_33: {
                                                            break :block_33 value_17;
                                                        };

                                                        if ((operand_35 >= (operand_34).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_36 (operand_34)[@intCast(operand_35)];
                                                    })) block_54: {
                                                        const value_18: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (state_26).seen;

                                                        const value_19: u64 = block_53: {
                                                            break :block_53 value_17;
                                                        };
                                                        var value_20: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_52: {
                                                            break :block_52 block_51: {
                                                                var updated_43: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = state_26;

                                                                const operand_50 = block_49: {
                                                                    const operand_44 = value_18;
                                                                    const operand_46 = block_45: {
                                                                        break :block_45 value_19;
                                                                    };

                                                                    if ((operand_46 >= ((operand_44).items).len)) {
                                                                        return error.IndexOutOfBounds;
                                                                    }

                                                                    const operand_47 = true;
                                                                    const operand_48 = @constCast((operand_44).items);

                                                                    (operand_48)[@intCast(operand_46)] = operand_47;
                                                                    break :block_49 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                                        .items = operand_48,
                                                                        .storage = (if ((@backingInt((operand_44).storage) >= 2)) .exclusive else .owned),
                                                                    };
                                                                };
                                                                (updated_43).seen = operand_50;
                                                                (updated_43).zx_origin = null;

                                                                break :block_51 updated_43;
                                                            };
                                                        };
                                                        const value_21: u64 = (value_20).bytes;

                                                        const operand_42 = (block_37: {
                                                            break :block_37 value_21;
                                                        } + block_41: {
                                                            const operand_39 = ((value_22).graph).sizes;

                                                            const operand_40 = block_38: {
                                                                break :block_38 value_17;
                                                            };

                                                            if ((operand_40 >= (operand_39).len)) {
                                                                return error.IndexOutOfBounds;
                                                            }

                                                            break :block_41 (operand_39)[@intCast(operand_40)];
                                                        });

                                                        (value_20).bytes = operand_42;
                                                        (value_20).zx_origin = null;

                                                        break :block_54 value_20;
                                                    } else state_26);

                                                    const value_25: u64 = (value_24).index;

                                                    const operand_32 = (block_31: {
                                                        break :block_31 value_25;
                                                    } + @as(u64, 1));

                                                    (value_24).index = operand_32;
                                                    (value_24).zx_origin = null;

                                                    break :block_58 value_24;
                                                };
                                            };

                                            const operand_61 = (operand_60).bytes;
                                            const operand_62 = (operand_60).index;
                                            const operand_63 = ((operand_60).seen).items;
                                            const operand_64 = ((operand_60).seen).storage;
                                            const operand_65 = (operand_60).zx_origin;
                                            (state_26).bytes = operand_61;
                                            (state_26).index = operand_62;
                                            ((state_26).seen).items = operand_63;
                                            ((state_26).seen).storage = operand_64;
                                            (state_26).zx_origin = operand_65;
                                            state_changed_29 = true;
                                        }

                                        break :block_67 (if (state_changed_29) state_26 else operand_27);
                                    };
                                    break :block_68 block_25: {
                                        const operand_23 = (value_27).bytes;
                                        const operand_24 = (value_27).seen;

                                        break :block_25 @as((zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a, (zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a{
                                            .bytes = operand_23,
                                            .seen = operand_24,
                                        });
                                    };
                                };
                            };

                            var value_31: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_21: {
                                break :block_21 block_20: {
                                    var updated_18: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = state_11;
                                    const operand_19 = (value_30).seen;
                                    (updated_18).seen = operand_19;
                                    (updated_18).zx_origin = null;

                                    break :block_20 updated_18;
                                };
                            };
                            const operand_17 = (value_30).bytes;
                            (value_31).bytes = operand_17;
                            (value_31).zx_origin = null;
                            const value_33: u64 = (value_31).index;

                            const operand_16 = (block_15: {
                                break :block_15 value_33;
                            } + @as(u64, 1));

                            (value_31).index = operand_16;
                            (value_31).zx_origin = null;

                            break :block_83 value_31;
                        };
                    };

                    const operand_86 = (operand_85).bytes;
                    const operand_87 = (operand_85).index;
                    const operand_88 = ((operand_85).seen).items;
                    const operand_89 = ((operand_85).seen).storage;
                    const operand_90 = (operand_85).zx_origin;
                    (state_11).bytes = operand_86;
                    (state_11).index = operand_87;
                    ((state_11).seen).items = operand_88;
                    ((state_11).seen).storage = operand_89;
                    (state_11).zx_origin = operand_90;
                }

                break :block_91 (state_11).bytes;
            };
        };
    };

    const value_39: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).graph).partitions));

    const value_40: u64 = @divTrunc(((block_8: {
        break :block_8 value_38;
    } + block_9: {
        break :block_9 value_39;
    }) - @as(u64, 1)), block_10: {
        break :block_10 value_39;
    });

    const value_41: u64 = (block_7: {
        const operand_5 = ((in).closures).items;
        const operand_6 = @as(u64, 0);

        if ((operand_6 >= (operand_5).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_7 (operand_5)[@intCast(operand_6)];
    }).bytes;

    return (if ((block_1: {
        break :block_1 value_41;
    } > block_2: {
        break :block_2 value_40;
    })) block_3: {
        break :block_3 value_41;
    } else block_4: {
        break :block_4 value_40;
    });
}
