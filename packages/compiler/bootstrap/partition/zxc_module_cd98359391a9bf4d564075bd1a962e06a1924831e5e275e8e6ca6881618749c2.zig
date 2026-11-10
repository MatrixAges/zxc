const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = block_158: {
        break :block_158 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
            .items = (&[_]u32{}),
            .storage = .plain,
        };
    };

    return block_157: {
        const value_37: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_156: {
            const operand_112 = block_117: {
                const operand_116 = block_115: {
                    const operand_113 = ((in).graph).roots;
                    const operand_114 = (in).index;

                    if ((operand_114 >= (operand_113).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_115 (operand_113)[@intCast(operand_114)];
                };

                break :block_117 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                    .items = (try (allocator).dupe(u32, (&[_]u32{
                        operand_116,
                    }))),
                    .storage = .plain,
                };
            };
            const operand_118 = block_152: {
                const value_3: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                    .items = ((in).graph).sizes,
                    .storage = .plain,
                };

                break :block_152 block_151: {
                    const operand_125 = block_124: {
                        const operand_120 = value_3;
                        const operand_121 = @as(u64, 0);

                        const operand_122 = block_123: {
                            break :block_123 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                .items = (&[_]bool{}),
                                .storage = .plain,
                            };
                        };

                        break :block_124 @as((zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c, (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = operand_121,
                            .result = operand_122,
                            .source = operand_120,
                        });
                    };
                    const loop_fields_127 = struct {
                        index: u64,
                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                    };

                    var qualified_128: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = operand_125;

                    ((qualified_128).source).storage = (if ((@backingInt(((qualified_128).source).storage) >= 2)) .shared else .plain);

                    const loop_seed_126: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = qualified_128;

                    break :block_151 (if (((loop_seed_126).index < @as(u64, (((loop_seed_126).source).items).len))) block_149: {
                        var qualified_145: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_126).source;

                        (qualified_145).storage = (if ((@backingInt((qualified_145).storage) >= 2)) .shared else .plain);

                        const operand_146 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (loop_seed_126).index,
                            .result = (loop_seed_126).result,
                            .source = qualified_145,
                            .zx_origin = (loop_seed_126).zx_origin,
                        };

                        var state_119: loop_fields_127 = loop_fields_127{
                            .index = (operand_146).index,
                            .result = (operand_146).result,
                            .source = (&(operand_146).source),
                            .zx_origin = (operand_146).zx_origin,
                        };

                        while (true) {
                            const operand_147 = block_144: {
                                _ = block_143: {
                                    const operand_141 = (((state_119).source).*).items;
                                    const operand_142 = (state_119).index;

                                    if ((operand_142 >= (operand_141).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_143 (operand_141)[@intCast(operand_142)];
                                };
                                const value_7: bool = false;

                                break :block_144 block_140: {
                                    const operand_129 = ((state_119).source).*;
                                    const operand_130 = ((state_119).index + @as(u64, 1));
                                    const operand_131 = (block_138: {
                                        const operand_132 = (state_119).result;
                                        const operand_134 = block_133: {
                                            break :block_133 value_7;
                                        };

                                        const operand_135 = (try ((std).math).add(usize, ((operand_132).items).len, 1));

                                        break :block_138 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                            block_137: {
                                                const operand_136 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_132).items, operand_135, (((loop_seed_126).source).items).len));

                                                (operand_136)[((operand_132).items).len] = operand_134;

                                                break :block_137 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                    .items = operand_136,
                                                    .storage = (if ((((((operand_132).items).len == 0) or ((operand_136).ptr != ((operand_132).items).ptr)) or ((operand_132).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_140 loop_fields_127{
                                        .index = operand_130,
                                        .result = operand_131,
                                        .source = block_139: {
                                            _ = operand_129;

                                            break :block_139 (&(loop_seed_126).source);
                                        },
                                    };
                                };
                            };

                            state_119 = loop_fields_127{
                                .index = (operand_147).index,
                                .result = (operand_147).result,
                                .source = (operand_147).source,
                                .zx_origin = (operand_147).zx_origin,
                            };

                            if ((!((state_119).index < @as(u64, ((((state_119).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_148 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (state_119).index,
                            .result = (state_119).result,
                            .source = ((state_119).source).*,
                            .zx_origin = (state_119).zx_origin,
                        };

                        break :block_149 (operand_148).result;
                    } else block_150: {
                        break :block_150 (loop_seed_126).result;
                    });
                };
            };

            const operand_153 = value_1;
            const operand_154 = @as(u64, 0);
            const operand_155 = @as(u64, 0);

            break :block_156 @as((zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1, (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1{
                .pending = operand_112,
                .seen = operand_118,
                .nodes = operand_153,
                .bytes = operand_154,
                .head = operand_155,
            });
        };

        const value_38: (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = in;

        break :block_157 block_111: {
            const value_35: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_110: {
                const operand_12 = value_37;
                var state_11: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = operand_12;
                var state_changed_14 = false;

                while (((state_11).head < @as(u64, (((state_11).pending).items).len))) {
                    const operand_99 = block_98: {
                        const value_20: (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = value_38;

                        break :block_98 block_97: {
                            const value_11: u32 = block_96: {
                                const operand_94 = ((state_11).pending).items;
                                const operand_95 = (state_11).head;

                                if ((operand_95 >= (operand_94).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_96 (operand_94)[@intCast(operand_95)];
                            };
                            const value_12: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_93: {
                                break :block_93 value_11;
                            }));

                            const value_13: u64 = (state_11).head;

                            const value_14: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_92: {
                                break :block_92 block_91: {
                                    var updated_88: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = state_11;

                                    const operand_90 = (block_89: {
                                        break :block_89 value_13;
                                    } + @as(u64, 1));

                                    (updated_88).head = operand_90;
                                    (updated_88).zx_origin = null;

                                    break :block_91 updated_88;
                                };
                            };
                            const value_34: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = (if ((!block_18: {
                                const operand_16 = ((value_14).seen).items;

                                const operand_17 = block_15: {
                                    break :block_15 value_12;
                                };

                                if ((operand_17 >= (operand_16).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_18 (operand_16)[@intCast(operand_17)];
                            })) block_87: {
                                const value_15: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_14).seen;

                                const value_16: u64 = block_86: {
                                    break :block_86 value_12;
                                };
                                var value_17: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_85: {
                                    break :block_85 block_84: {
                                        var updated_76: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = value_14;

                                        const operand_83 = block_82: {
                                            const operand_77 = value_15;
                                            const operand_79 = block_78: {
                                                break :block_78 value_16;
                                            };

                                            if ((operand_79 >= ((operand_77).items).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_80 = true;
                                            const operand_81 = @constCast((operand_77).items);

                                            (operand_81)[@intCast(operand_79)] = operand_80;

                                            break :block_82 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                .items = operand_81,
                                                .storage = (if ((@backingInt((operand_77).storage) >= 2)) .exclusive else .owned),
                                            };
                                        };
                                        (updated_76).seen = operand_83;
                                        (updated_76).zx_origin = null;

                                        break :block_84 updated_76;
                                    };
                                };
                                const operand_75 = (block_74: {
                                    const operand_68 = (value_17).nodes;
                                    const operand_70 = block_69: {
                                        break :block_69 value_11;
                                    };

                                    const operand_71 = (try ((std).math).add(usize, ((operand_68).items).len, 1));

                                    break :block_74 @as((zx_abi).value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb, .{
                                        block_73: {
                                            const operand_72 = (try (zx_abi).zxReserve(u32, allocator, (operand_68).items, operand_71, true));

                                            (operand_72)[((operand_68).items).len] = operand_70;

                                            break :block_73 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                                .items = operand_72,
                                                .storage = (if ((((((operand_68).items).len == 0) or ((operand_72).ptr != ((operand_68).items).ptr)) or ((operand_68).storage == .exclusive))) .exclusive else .shared),
                                            };
                                        },
                                        {},
                                        null,
                                    });
                                }).@"0";
                                (value_17).nodes = operand_75;
                                (value_17).zx_origin = null;
                                const value_19: u64 = (value_17).bytes;

                                const operand_67 = (block_62: {
                                    break :block_62 value_19;
                                } + block_66: {
                                    const operand_64 = ((value_20).graph).sizes;

                                    const operand_65 = block_63: {
                                        break :block_63 value_12;
                                    };

                                    if ((operand_65 >= (operand_64).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_66 (operand_64)[@intCast(operand_65)];
                                });

                                (value_17).bytes = operand_67;
                                (value_17).zx_origin = null;

                                const value_22: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = block_61: {
                                    break :block_61 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                        .items = block_60: {
                                            const operand_58 = ((value_20).graph).callees;

                                            const operand_59 = block_57: {
                                                break :block_57 value_12;
                                            };

                                            if ((operand_59 >= (operand_58).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_60 (operand_58)[@intCast(operand_59)];
                                        },
                                        .storage = .plain,
                                    };
                                };
                                const operand_56 = block_55: {
                                    const value_31: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = block_54: {
                                        const operand_52 = (value_17).pending;
                                        const operand_53 = @as(u64, 0);

                                        break :block_54 @as((zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22, (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22{
                                            .values = operand_52,
                                            .index = operand_53,
                                        });
                                    };
                                    const value_32: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_22;

                                    break :block_55 block_51: {
                                        break :block_51 block_50: {
                                            const operand_20 = value_31;
                                            var state_19: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = operand_20;

                                            while (block_22: {
                                                const value_24: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_32;

                                                break :block_22 ((state_19).index < @as(u64, ((value_24).items).len));
                                            }) {
                                                const operand_45 = block_44: {
                                                    const value_26: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_32;

                                                    break :block_44 block_43: {
                                                        var value_27: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = block_42: {
                                                            break :block_42 block_41: {
                                                                var updated_25: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = state_19;

                                                                const operand_40 = (block_39: {
                                                                    const operand_26 = (state_19).values;
                                                                    const operand_30 = block_29: {
                                                                        const operand_27 = (value_26).items;
                                                                        const operand_28 = (state_19).index;

                                                                        if ((operand_28 >= (operand_27).len)) {
                                                                            return error.IndexOutOfBounds;
                                                                        }

                                                                        break :block_29 (operand_27)[@intCast(operand_28)];
                                                                    };

                                                                    const operand_31 = (try ((std).math).add(usize, ((operand_26).items).len, 1));

                                                                    break :block_39 @as((zx_abi).value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb, .{
                                                                        block_38: {
                                                                            const operand_32 = operand_26;

                                                                            const operand_37 = (if ((@backingInt((operand_32).storage) >= 2)) block_35: {
                                                                                const operand_34 = (try (zx_abi).zxReserve(u32, allocator, (operand_32).items, operand_31, true));

                                                                                break :block_35 operand_34;
                                                                            } else block_36: {
                                                                                const operand_33 = (try (zx_abi).zxReserve(u32, allocator, (operand_32).items, operand_31, false));

                                                                                break :block_36 operand_33;
                                                                            });

                                                                            (operand_37)[((operand_26).items).len] = operand_30;

                                                                            break :block_38 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                                                                .items = operand_37,
                                                                                .storage = (if ((((((operand_26).items).len == 0) or ((operand_37).ptr != ((operand_26).items).ptr)) or ((operand_26).storage == .exclusive))) .exclusive else .shared),
                                                                            };
                                                                        },
                                                                        {},
                                                                        null,
                                                                    });
                                                                }).@"0";
                                                                (updated_25).values = operand_40;
                                                                (updated_25).zx_origin = null;

                                                                break :block_41 updated_25;
                                                            };
                                                        };
                                                        const value_28: u64 = (value_27).index;

                                                        const operand_24 = (block_23: {
                                                            break :block_23 value_28;
                                                        } + @as(u64, 1));

                                                        (value_27).index = operand_24;
                                                        (value_27).zx_origin = null;

                                                        break :block_43 value_27;
                                                    };
                                                };

                                                const operand_46 = (operand_45).index;
                                                const operand_47 = ((operand_45).values).items;
                                                const operand_48 = ((operand_45).values).storage;
                                                const operand_49 = (operand_45).zx_origin;
                                                (state_19).index = operand_46;
                                                ((state_19).values).items = operand_47;
                                                ((state_19).values).storage = operand_48;
                                                (state_19).zx_origin = operand_49;
                                            }

                                            break :block_50 (state_19).values;
                                        };
                                    };
                                };

                                (value_17).pending = operand_56;
                                (value_17).zx_origin = null;

                                break :block_87 value_17;
                            } else value_14);

                            break :block_97 value_34;
                        };
                    };

                    const operand_100 = (operand_99).bytes;
                    const operand_101 = (operand_99).head;
                    const operand_102 = ((operand_99).nodes).items;
                    const operand_103 = ((operand_99).nodes).storage;
                    const operand_104 = ((operand_99).pending).items;
                    const operand_105 = ((operand_99).pending).storage;
                    const operand_106 = ((operand_99).seen).items;
                    const operand_107 = ((operand_99).seen).storage;
                    const operand_108 = (operand_99).zx_origin;
                    (state_11).bytes = operand_100;
                    (state_11).head = operand_101;
                    ((state_11).nodes).items = operand_102;
                    ((state_11).nodes).storage = operand_103;
                    ((state_11).pending).items = operand_104;
                    ((state_11).pending).storage = operand_105;
                    ((state_11).seen).items = operand_106;
                    ((state_11).seen).storage = operand_107;
                    (state_11).zx_origin = operand_108;
                    state_changed_14 = true;
                }

                break :block_110 (if (state_changed_14) state_11 else operand_12);
            };

            break :block_111 block_10: {
                const value_36: (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = value_38;

                break :block_10 block_9: {
                    const operand_1 = (value_36).index;
                    const operand_2 = (value_35).nodes;
                    const operand_3 = (value_35).bytes;
                    const operand_4 = operand_1;
                    const operand_5 = operand_2;
                    const operand_6 = operand_3;

                    break :block_9 block_8: {
                        const operand_7 = (try (allocator).create((zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0));

                        (operand_7).* = @as((zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0{
                            .index = operand_4,
                            .nodes = (operand_5).items,
                            .bytes = operand_6,
                        });

                        break :block_8 @as(*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, operand_7);
                    };
                };
            };
        };
    };
}
