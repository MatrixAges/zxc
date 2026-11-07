const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 {
    @setRuntimeSafety(true);

    const value_1: []const u32 = block_153: {
        break :block_153 (&[_]u32{});
    };

    return block_152: {
        const value_37: (zx_abi).zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce = block_151: {
            const operand_105 = block_110: {
                const operand_109 = block_108: {
                    const operand_106 = ((in).graph).roots;
                    const operand_107 = (in).index;

                    if ((operand_107 >= (operand_106).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_108 (operand_106)[@intCast(operand_107)];
                };

                break :block_110 (try (allocator).dupe(u32, (&[_]u32{
                    operand_109,
                })));
            };
            const operand_111 = block_147: {
                const value_3: []const u64 = ((in).graph).sizes;

                break :block_147 block_146: {
                    const operand_118 = block_117: {
                        const operand_113 = value_3;
                        const operand_114 = @as(u64, 0);

                        const operand_115 = block_116: {
                            break :block_116 (&[_]bool{});
                        };

                        break :block_117 (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1{
                            .index = operand_114,
                            .result = operand_115,
                            .source = operand_113,
                        };
                    };
                    const loop_fields_121 = struct {
                        index: u64,
                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                    };
                    const loop_seed_120: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                        .index = (operand_118).index,
                        .result = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                            .items = (operand_118).result,
                            .storage = .plain,
                        },
                        .source = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                            .items = (operand_118).source,
                            .storage = .plain,
                        },
                        .zx_origin = (&operand_118),
                    };

                    break :block_146 (if (((loop_seed_120).index < @as(u64, (((loop_seed_120).source).items).len))) block_143: {
                        var qualified_138: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_120).source;

                        (qualified_138).storage = (if ((@backingInt((qualified_138).storage) >= 2)) .shared else .plain);

                        const operand_139 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (loop_seed_120).index,
                            .result = (loop_seed_120).result,
                            .source = qualified_138,
                            .zx_origin = (loop_seed_120).zx_origin,
                        };
                        var state_112: loop_fields_121 = loop_fields_121{
                            .index = (operand_139).index,
                            .result = (operand_139).result,
                            .source = (&(operand_139).source),
                            .zx_origin = (operand_139).zx_origin,
                        };

                        while (true) {
                            const operand_140 = block_137: {
                                _ = block_136: {
                                    const operand_134 = (((state_112).source).*).items;
                                    const operand_135 = (state_112).index;

                                    if ((operand_135 >= (operand_134).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_136 (operand_134)[@intCast(operand_135)];
                                };
                                const value_7: bool = false;

                                break :block_137 block_133: {
                                    const operand_122 = ((state_112).source).*;
                                    const operand_123 = ((state_112).index + @as(u64, 1));
                                    const operand_124 = (block_131: {
                                        const operand_125 = (state_112).result;

                                        const operand_127 = block_126: {
                                            break :block_126 value_7;
                                        };

                                        const operand_128 = (try ((std).math).add(usize, ((operand_125).items).len, 1));

                                        break :block_131 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                            block_130: {
                                                const operand_129 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_125).items, operand_128, (((loop_seed_120).source).items).len));

                                                (operand_129)[((operand_125).items).len] = operand_127;

                                                break :block_130 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                    .items = operand_129,
                                                    .storage = (if (((((operand_125).items).len == 0) or ((operand_125).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_133 loop_fields_121{
                                        .index = operand_123,
                                        .result = operand_124,
                                        .source = block_132: {
                                            _ = operand_122;

                                            break :block_132 (&(loop_seed_120).source);
                                        },
                                    };
                                };
                            };

                            state_112 = loop_fields_121{
                                .index = (operand_140).index,
                                .result = (operand_140).result,
                                .source = (operand_140).source,
                                .zx_origin = (operand_140).zx_origin,
                            };

                            if ((!((state_112).index < @as(u64, ((((state_112).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_141 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                            .index = (state_112).index,
                            .result = (state_112).result,
                            .source = ((state_112).source).*,
                            .zx_origin = (state_112).zx_origin,
                        };

                        const operand_142 = (operand_141).result;

                        break :block_143 (operand_142).items;
                    } else block_145: {
                        const operand_144 = (loop_seed_120).result;

                        break :block_145 (operand_144).items;
                    });
                };
            };

            const operand_148 = value_1;
            const operand_149 = @as(u64, 0);
            const operand_150 = @as(u64, 0);

            break :block_151 (zx_abi).zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce{
                .pending = operand_105,
                .seen = operand_111,
                .nodes = operand_148,
                .bytes = operand_149,
                .head = operand_150,
            };
        };

        const value_38: *const (zx_abi).zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04 = in;

        break :block_152 block_104: {
            const value_35: (zx_abi).zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce = block_103: {
                const operand_7 = ((&value_37)).*;

                var state_6: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1{
                    .bytes = (operand_7).bytes,
                    .head = (operand_7).head,
                    .nodes = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                        .items = (operand_7).nodes,
                        .storage = .plain,
                    },
                    .pending = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                        .items = (operand_7).pending,
                        .storage = .plain,
                    },
                    .seen = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                        .items = (operand_7).seen,
                        .storage = .plain,
                    },
                    .zx_origin = (&operand_7),
                };

                while (((state_6).head < @as(u64, (((state_6).pending).items).len))) {
                    const operand_91 = block_90: {
                        const value_20: (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = block_89: {
                            break :block_89 (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670{
                                .graph = (value_38).graph,
                                .index = (value_38).index,
                                .zx_origin = value_38,
                            };
                        };
                        break :block_90 block_88: {
                            const value_11: u32 = block_87: {
                                const operand_85 = ((state_6).pending).items;
                                const operand_86 = (state_6).head;

                                if ((operand_86 >= (operand_85).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_87 (operand_85)[@intCast(operand_86)];
                            };
                            const value_12: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_84: {
                                break :block_84 value_11;
                            }));

                            const value_13: u64 = (state_6).head;

                            const value_14: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_83: {
                                var updated_80: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = state_6;

                                const operand_82 = (block_81: {
                                    break :block_81 value_13;
                                } + @as(u64, 1));

                                (updated_80).head = operand_82;
                                (updated_80).zx_origin = null;

                                break :block_83 updated_80;
                            };
                            const value_34: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = (if ((!block_12: {
                                const operand_10 = ((value_14).seen).items;

                                const operand_11 = block_9: {
                                    break :block_9 value_12;
                                };

                                if ((operand_11 >= (operand_10).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_12 (operand_10)[@intCast(operand_11)];
                            })) block_79: {
                                const value_15: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_14).seen;

                                const value_16: u64 = block_78: {
                                    break :block_78 value_12;
                                };
                                var value_17: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = block_77: {
                                    var updated_69: (zx_abi).value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = value_14;

                                    const operand_76 = block_75: {
                                        const operand_70 = value_15;
                                        const operand_72 = block_71: {
                                            break :block_71 value_16;
                                        };

                                        if ((operand_72 >= ((operand_70).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_73 = true;
                                        const operand_74 = @constCast((operand_70).items);

                                        (operand_74)[@intCast(operand_72)] = operand_73;

                                        break :block_75 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                            .items = operand_74,
                                            .storage = (if ((@backingInt((operand_70).storage) >= 2)) .exclusive else .owned),
                                        };
                                    };
                                    (updated_69).seen = operand_76;
                                    (updated_69).zx_origin = null;

                                    break :block_77 updated_69;
                                };
                                const operand_68 = (block_67: {
                                    const operand_61 = (value_17).nodes;

                                    const operand_63 = block_62: {
                                        break :block_62 value_11;
                                    };

                                    const operand_64 = (try ((std).math).add(usize, ((operand_61).items).len, 1));

                                    break :block_67 @as((zx_abi).value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb, .{
                                        block_66: {
                                            const operand_65 = (try (zx_abi).zxReserve(u32, allocator, (operand_61).items, operand_64, true));

                                            (operand_65)[((operand_61).items).len] = operand_63;

                                            break :block_66 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                                .items = operand_65,
                                                .storage = (if (((((operand_61).items).len == 0) or ((operand_61).storage == .exclusive))) .exclusive else .shared),
                                            };
                                        },
                                        {},
                                        null,
                                    });
                                }).@"0";
                                (value_17).nodes = operand_68;
                                (value_17).zx_origin = null;
                                const value_19: u64 = (value_17).bytes;

                                const operand_60 = (block_55: {
                                    break :block_55 value_19;
                                } + block_59: {
                                    const operand_57 = ((value_20).graph).sizes;

                                    const operand_58 = block_56: {
                                        break :block_56 value_12;
                                    };

                                    if ((operand_58 >= (operand_57).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_59 (operand_57)[@intCast(operand_58)];
                                });

                                (value_17).bytes = operand_60;
                                (value_17).zx_origin = null;

                                const value_22: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = block_54: {
                                    break :block_54 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                        .items = block_53: {
                                            const operand_51 = ((value_20).graph).callees;

                                            const operand_52 = block_50: {
                                                break :block_50 value_12;
                                            };

                                            if ((operand_52 >= (operand_51).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_53 (operand_51)[@intCast(operand_52)];
                                        },
                                        .storage = .plain,
                                    };
                                };
                                const operand_49 = block_48: {
                                    const value_31: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = block_47: {
                                        const operand_45 = (value_17).pending;
                                        const operand_46 = @as(u64, 0);

                                        break :block_47 @as((zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22, (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22{
                                            .values = operand_45,
                                            .index = operand_46,
                                        });
                                    };
                                    const value_32: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_22;

                                    break :block_48 block_44: {
                                        break :block_44 block_43: {
                                            const operand_14 = value_31;
                                            var state_13: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = operand_14;

                                            while (block_16: {
                                                const value_24: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_32;

                                                break :block_16 ((state_13).index < @as(u64, ((value_24).items).len));
                                            }) {
                                                const operand_38 = block_37: {
                                                    const value_26: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = value_32;

                                                    break :block_37 block_36: {
                                                        var value_27: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = block_35: {
                                                            var updated_19: (zx_abi).value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = state_13;

                                                            const operand_34 = (block_33: {
                                                                const operand_20 = (state_13).values;
                                                                const operand_24 = block_23: {
                                                                    const operand_21 = (value_26).items;
                                                                    const operand_22 = (state_13).index;

                                                                    if ((operand_22 >= (operand_21).len)) {
                                                                        return error.IndexOutOfBounds;
                                                                    }

                                                                    break :block_23 (operand_21)[@intCast(operand_22)];
                                                                };

                                                                const operand_25 = (try ((std).math).add(usize, ((operand_20).items).len, 1));

                                                                break :block_33 @as((zx_abi).value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb, .{
                                                                    block_32: {
                                                                        const operand_26 = operand_20;

                                                                        const operand_31 = (if ((@backingInt((operand_26).storage) >= 2)) block_29: {
                                                                            const operand_28 = (try (zx_abi).zxReserve(u32, allocator, (operand_26).items, operand_25, true));

                                                                            break :block_29 operand_28;
                                                                        } else block_30: {
                                                                            const operand_27 = (try (zx_abi).zxReserve(u32, allocator, (operand_26).items, operand_25, false));

                                                                            break :block_30 operand_27;
                                                                        });

                                                                        (operand_31)[((operand_20).items).len] = operand_24;

                                                                        break :block_32 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                                                            .items = operand_31,
                                                                            .storage = (if (((!(@backingInt((operand_20).storage) >= 2)) or ((operand_20).storage == .exclusive))) .exclusive else .shared),
                                                                        };
                                                                    },
                                                                    {},
                                                                    null,
                                                                });
                                                            }).@"0";

                                                            (updated_19).values = operand_34;
                                                            (updated_19).zx_origin = null;

                                                            break :block_35 updated_19;
                                                        };
                                                        const value_28: u64 = (value_27).index;

                                                        const operand_18 = (block_17: {
                                                            break :block_17 value_28;
                                                        } + @as(u64, 1));

                                                        (value_27).index = operand_18;
                                                        (value_27).zx_origin = null;

                                                        break :block_36 value_27;
                                                    };
                                                };

                                                const operand_39 = (operand_38).index;
                                                const operand_40 = ((operand_38).values).items;
                                                const operand_41 = ((operand_38).values).storage;
                                                const operand_42 = (operand_38).zx_origin;
                                                (state_13).index = operand_39;
                                                ((state_13).values).items = operand_40;
                                                ((state_13).values).storage = operand_41;
                                                (state_13).zx_origin = operand_42;
                                            }

                                            break :block_43 (state_13).values;
                                        };
                                    };
                                };
                                (value_17).pending = operand_49;
                                (value_17).zx_origin = null;

                                break :block_79 value_17;
                            } else value_14);

                            break :block_88 value_34;
                        };
                    };

                    const operand_92 = (operand_91).bytes;
                    const operand_93 = (operand_91).head;
                    const operand_94 = ((operand_91).nodes).items;
                    const operand_95 = ((operand_91).nodes).storage;
                    const operand_96 = ((operand_91).pending).items;
                    const operand_97 = ((operand_91).pending).storage;
                    const operand_98 = ((operand_91).seen).items;
                    const operand_99 = ((operand_91).seen).storage;
                    const operand_100 = (operand_91).zx_origin;

                    (state_6).bytes = operand_92;
                    (state_6).head = operand_93;
                    ((state_6).nodes).items = operand_94;
                    ((state_6).nodes).storage = operand_95;
                    ((state_6).pending).items = operand_96;
                    ((state_6).pending).storage = operand_97;
                    ((state_6).seen).items = operand_98;
                    ((state_6).seen).storage = operand_99;
                    (state_6).zx_origin = operand_100;
                }

                break :block_103 block_102: {
                    break :block_102 (if (((state_6).zx_origin != null)) ((state_6).zx_origin.?).* else block_101: {
                        break :block_101 (zx_abi).zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce{
                            .bytes = (state_6).bytes,
                            .head = (state_6).head,
                            .nodes = ((state_6).nodes).items,
                            .pending = ((state_6).pending).items,
                            .seen = ((state_6).seen).items,
                        };
                    });
                };
            };

            break :block_104 block_5: {
                const value_36: *const (zx_abi).zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04 = value_38;

                break :block_5 block_4: {
                    const operand_1 = (value_36).index;
                    const operand_2 = ((&value_35)).nodes;
                    const operand_3 = ((&value_35)).bytes;

                    break :block_4 (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0{
                        .index = operand_1,
                        .nodes = operand_2,
                        .bytes = operand_3,
                    };
                };
            };
        };
    };
}
