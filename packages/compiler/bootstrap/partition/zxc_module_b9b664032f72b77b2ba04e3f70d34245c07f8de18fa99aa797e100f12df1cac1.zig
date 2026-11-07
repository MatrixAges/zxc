const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!u64 {
    @setRuntimeSafety(true);

    if ((@as(u64, ((in).closures).len) == @as(u64, 0))) {
        return @as(u64, 0);
    }

    const value_38: u64 = block_122: {
        const value_36: (zx_abi).zx_type_d28fe3064e2fdd72452506f920bf877de2f90791750c1a0eb9e337bfbaebc47a = block_121: {
            const operand_84 = block_118: {
                const value_2: []const u64 = ((in).graph).sizes;

                break :block_118 block_117: {
                    const operand_90 = block_89: {
                        const operand_86 = value_2;
                        const operand_87 = @as(u64, 0);
                        const operand_88 = @as([]const bool, (comptime (&[_]bool{})));

                        break :block_89 (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1{
                            .index = operand_87,
                            .result = operand_88,
                            .source = operand_86,
                        };
                    };
                    const loop_fields_92 = struct {
                        index: u64,
                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                    };
                    const loop_seed_91: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                        .index = (operand_90).index,
                        .result = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                            .items = (operand_90).result,
                            .storage = .plain,
                        },
                        .source = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                            .items = (operand_90).source,
                            .storage = .plain,
                        },
                        .zx_origin = (&operand_90),
                    };

                    break :block_117 (if (((loop_seed_91).index < @as(u64, (((loop_seed_91).source).items).len))) block_114: {
                        var qualified_109: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_91).source;

                        (qualified_109).storage = (if ((@backingInt((qualified_109).storage) >= 2)) .shared else .plain);

                        const operand_110 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (loop_seed_91).index,
                            .result = (loop_seed_91).result,
                            .source = qualified_109,
                            .zx_origin = (loop_seed_91).zx_origin,
                        };

                        var state_85: loop_fields_92 = loop_fields_92{
                            .index = (operand_110).index,
                            .result = (operand_110).result,
                            .source = (&(operand_110).source),
                            .zx_origin = (operand_110).zx_origin,
                        };

                        while (true) {
                            const operand_111 = block_108: {
                                _ = block_107: {
                                    const operand_105 = (((state_85).source).*).items;
                                    const operand_106 = (state_85).index;

                                    if ((operand_106 >= (operand_105).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_107 (operand_105)[@intCast(operand_106)];
                                };

                                const value_6: bool = false;

                                break :block_108 block_104: {
                                    const operand_93 = ((state_85).source).*;
                                    const operand_94 = ((state_85).index + @as(u64, 1));
                                    const operand_95 = (block_102: {
                                        const operand_96 = (state_85).result;

                                        const operand_98 = block_97: {
                                            break :block_97 value_6;
                                        };

                                        const operand_99 = (try ((std).math).add(usize, ((operand_96).items).len, 1));

                                        break :block_102 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                            block_101: {
                                                const operand_100 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_96).items, operand_99, (((loop_seed_91).source).items).len));

                                                (operand_100)[((operand_96).items).len] = operand_98;

                                                break :block_101 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                    .items = operand_100,
                                                    .storage = (if (((((operand_96).items).len == 0) or ((operand_96).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_104 loop_fields_92{
                                        .index = operand_94,
                                        .result = operand_95,
                                        .source = block_103: {
                                            _ = operand_93;

                                            break :block_103 (&(loop_seed_91).source);
                                        },
                                    };
                                };
                            };

                            state_85 = loop_fields_92{
                                .index = (operand_111).index,
                                .result = (operand_111).result,
                                .source = (operand_111).source,
                                .zx_origin = (operand_111).zx_origin,
                            };

                            if ((!((state_85).index < @as(u64, ((((state_85).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_112 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (state_85).index,
                            .result = (state_85).result,
                            .source = ((state_85).source).*,
                            .zx_origin = (state_85).zx_origin,
                        };

                        const operand_113 = (operand_112).result;

                        break :block_114 (operand_113).items;
                    } else block_116: {
                        const operand_115 = (loop_seed_91).result;

                        break :block_116 (operand_115).items;
                    });
                };
            };

            const operand_119 = @as(u64, 0);
            const operand_120 = @as(u64, 0);

            break :block_121 (zx_abi).zx_type_d28fe3064e2fdd72452506f920bf877de2f90791750c1a0eb9e337bfbaebc47a{
                .seen = operand_84,
                .bytes = operand_119,
                .index = operand_120,
            };
        };

        const value_37: *const (zx_abi).zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5 = in;

        break :block_122 block_83: {
            break :block_83 block_82: {
                const operand_5 = ((&value_36)).*;

                var state_4: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f{
                    .bytes = (operand_5).bytes,
                    .index = (operand_5).index,
                    .seen = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                        .items = (operand_5).seen,
                        .storage = .plain,
                    },
                    .zx_origin = (&operand_5),
                };

                while (block_8: {
                    const value_9: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = block_7: {
                        break :block_7 (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015{
                            .closures = (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
                                .items = (value_37).closures,
                                .storage = .plain,
                            },
                            .graph = (value_37).graph,
                            .zx_origin = value_37,
                        };
                    };

                    break :block_8 ((state_4).index < @as(u64, (((value_9).closures).items).len));
                }) {
                    const operand_75 = block_74: {
                        const value_11: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = block_73: {
                            break :block_73 (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015{
                                .closures = (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
                                    .items = (value_37).closures,
                                    .storage = .plain,
                                },
                                .graph = (value_37).graph,
                                .zx_origin = value_37,
                            };
                        };
                        break :block_74 block_72: {
                            const value_12: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                .items = (block_71: {
                                    const operand_69 = ((value_11).closures).items;
                                    const operand_70 = (state_4).index;

                                    if ((operand_70 >= (operand_69).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_71 (operand_69)[@intCast(operand_70)];
                                }).nodes,
                                .storage = .plain,
                            };
                            const value_30: (zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a = block_68: {
                                const value_28: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_67: {
                                    const operand_64 = (state_4).seen;
                                    const operand_65 = (state_4).bytes;
                                    const operand_66 = @as(u64, 0);

                                    break :block_67 @as((zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f, (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f{
                                        .seen = operand_64,
                                        .bytes = operand_65,
                                        .index = operand_66,
                                    });
                                };
                                const value_29: (zx_abi).value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b = block_63: {
                                    const operand_61 = value_12;
                                    const operand_62 = value_11;

                                    break :block_63 @as((zx_abi).value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b, .{
                                        operand_61,
                                        operand_62,
                                        null,
                                    });
                                };
                                break :block_68 block_60: {
                                    const value_27: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_59: {
                                        const operand_20 = value_28;
                                        var state_19: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = operand_20;
                                        var state_changed_22 = false;

                                        while (block_23: {
                                            const value_14: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_29).@"0";

                                            break :block_23 ((state_19).index < @as(u64, ((value_14).items).len));
                                        }) {
                                            const operand_52 = block_51: {
                                                const value_16: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_29).@"0";
                                                const value_22: (zx_abi).value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = (value_29).@"1";

                                                break :block_51 block_50: {
                                                    const value_17: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_49: {
                                                        const operand_47 = (value_16).items;
                                                        const operand_48 = (state_19).index;

                                                        if ((operand_48 >= (operand_47).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_49 (operand_47)[@intCast(operand_48)];
                                                    }));

                                                    var value_24: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = (if ((!block_29: {
                                                        const operand_27 = ((state_19).seen).items;

                                                        const operand_28 = block_26: {
                                                            break :block_26 value_17;
                                                        };

                                                        if ((operand_28 >= (operand_27).len)) {
                                                            return error.IndexOutOfBounds;
                                                        }

                                                        break :block_29 (operand_27)[@intCast(operand_28)];
                                                    })) block_46: {
                                                        const value_18: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (state_19).seen;

                                                        const value_19: u64 = block_45: {
                                                            break :block_45 value_17;
                                                        };
                                                        var value_20: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_44: {
                                                            var updated_36: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = state_19;

                                                            const operand_43 = block_42: {
                                                                const operand_37 = value_18;
                                                                const operand_39 = block_38: {
                                                                    break :block_38 value_19;
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
                                                            (updated_36).seen = operand_43;
                                                            (updated_36).zx_origin = null;

                                                            break :block_44 updated_36;
                                                        };
                                                        const value_21: u64 = (value_20).bytes;

                                                        const operand_35 = (block_30: {
                                                            break :block_30 value_21;
                                                        } + block_34: {
                                                            const operand_32 = ((value_22).graph).sizes;

                                                            const operand_33 = block_31: {
                                                                break :block_31 value_17;
                                                            };

                                                            if ((operand_33 >= (operand_32).len)) {
                                                                return error.IndexOutOfBounds;
                                                            }

                                                            break :block_34 (operand_32)[@intCast(operand_33)];
                                                        });

                                                        (value_20).bytes = operand_35;
                                                        (value_20).zx_origin = null;

                                                        break :block_46 value_20;
                                                    } else state_19);

                                                    const value_25: u64 = (value_24).index;

                                                    const operand_25 = (block_24: {
                                                        break :block_24 value_25;
                                                    } + @as(u64, 1));

                                                    (value_24).index = operand_25;
                                                    (value_24).zx_origin = null;

                                                    break :block_50 value_24;
                                                };
                                            };

                                            const operand_53 = (operand_52).bytes;
                                            const operand_54 = (operand_52).index;
                                            const operand_55 = ((operand_52).seen).items;
                                            const operand_56 = ((operand_52).seen).storage;
                                            const operand_57 = (operand_52).zx_origin;
                                            (state_19).bytes = operand_53;
                                            (state_19).index = operand_54;
                                            ((state_19).seen).items = operand_55;
                                            ((state_19).seen).storage = operand_56;
                                            (state_19).zx_origin = operand_57;
                                            state_changed_22 = true;
                                        }

                                        break :block_59 (if (state_changed_22) state_19 else operand_20);
                                    };
                                    break :block_60 block_18: {
                                        const operand_16 = (value_27).bytes;
                                        const operand_17 = (value_27).seen;

                                        break :block_18 @as((zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a, (zx_abi).value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a{
                                            .bytes = operand_16,
                                            .seen = operand_17,
                                        });
                                    };
                                };
                            };
                            var value_31: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = block_14: {
                                var updated_12: (zx_abi).value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = state_4;
                                const operand_13 = (value_30).seen;
                                (updated_12).seen = operand_13;
                                (updated_12).zx_origin = null;

                                break :block_14 updated_12;
                            };
                            const operand_11 = (value_30).bytes;

                            (value_31).bytes = operand_11;
                            (value_31).zx_origin = null;
                            const value_33: u64 = (value_31).index;

                            const operand_10 = (block_9: {
                                break :block_9 value_33;
                            } + @as(u64, 1));

                            (value_31).index = operand_10;
                            (value_31).zx_origin = null;

                            break :block_72 value_31;
                        };
                    };

                    const operand_76 = (operand_75).bytes;
                    const operand_77 = (operand_75).index;
                    const operand_78 = ((operand_75).seen).items;
                    const operand_79 = ((operand_75).seen).storage;
                    const operand_80 = (operand_75).zx_origin;
                    (state_4).bytes = operand_76;
                    (state_4).index = operand_77;
                    ((state_4).seen).items = operand_78;
                    ((state_4).seen).storage = operand_79;
                    (state_4).zx_origin = operand_80;
                }

                const operand_81 = (state_4).bytes;

                break :block_82 operand_81;
            };
        };
    };

    const value_39: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).graph).partitions));
    const value_40: u64 = @divTrunc(((value_38 + value_39) - @as(u64, 1)), value_39);

    const value_41: u64 = (block_3: {
        const operand_1 = (in).closures;
        const operand_2 = @as(u64, 0);

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    }).bytes;

    return (if ((value_41 > value_40)) value_41 else value_40);
}
