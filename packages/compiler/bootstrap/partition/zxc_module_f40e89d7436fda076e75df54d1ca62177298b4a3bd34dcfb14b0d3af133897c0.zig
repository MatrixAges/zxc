const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82 = block_136: {
        break :block_136 (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
            .items = (&[_][]const bool{}),
            .storage = .plain,
        };
    };

    const value_2: (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397 = block_135: {
        break :block_135 (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397{
            .items = (&[_][]const u32{}),
            .storage = .plain,
        };
    };

    const value_3: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = block_134: {
        break :block_134 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
            .items = (&[_]u64{}),
            .storage = .plain,
        };
    };

    const value_4: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = block_133: {
        break :block_133 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
            .items = (&[_]u32{}),
            .storage = .plain,
        };
    };

    const value_5: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).partitions));

    return block_132: {
        const value_32: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_131: {
            const operand_93 = value_1;
            const operand_94 = value_2;
            const operand_95 = value_3;
            const operand_96 = block_129: {
                const value_7: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                    .items = (in).roots,
                    .storage = .plain,
                };

                break :block_129 block_128: {
                    const operand_103 = block_102: {
                        const operand_98 = value_7;
                        const operand_99 = @as(u64, 0);

                        const operand_100 = block_101: {
                            break :block_101 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                .items = (&[_]u64{}),
                                .storage = .plain,
                            };
                        };

                        break :block_102 @as((zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1, (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = operand_99,
                            .result = operand_100,
                            .source = operand_98,
                        });
                    };
                    const loop_fields_105 = struct {
                        index: u64,
                        result: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        source: *const (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
                        zx_origin: ?*const (zx_abi).zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = null,
                    };

                    const loop_seed_104: (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1 = operand_103;

                    break :block_128 (if (((loop_seed_104).index < @as(u64, (((loop_seed_104).source).items).len))) block_126: {
                        var qualified_122: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (loop_seed_104).source;

                        (qualified_122).storage = (if ((@backingInt((qualified_122).storage) >= 2)) .shared else .plain);

                        const operand_123 = (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = (loop_seed_104).index,
                            .result = (loop_seed_104).result,
                            .source = qualified_122,
                            .zx_origin = (loop_seed_104).zx_origin,
                        };

                        var state_97: loop_fields_105 = loop_fields_105{
                            .index = (operand_123).index,
                            .result = (operand_123).result,
                            .source = (&(operand_123).source),
                            .zx_origin = (operand_123).zx_origin,
                        };

                        while (true) {
                            const operand_124 = block_121: {
                                _ = block_120: {
                                    const operand_118 = (((state_97).source).*).items;
                                    const operand_119 = (state_97).index;

                                    if ((operand_119 >= (operand_118).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_120 (operand_118)[@intCast(operand_119)];
                                };

                                const value_11: u64 = @as(u64, 0);

                                break :block_121 block_117: {
                                    const operand_106 = ((state_97).source).*;
                                    const operand_107 = ((state_97).index + @as(u64, 1));
                                    const operand_108 = (block_115: {
                                        const operand_109 = (state_97).result;

                                        const operand_111 = block_110: {
                                            break :block_110 value_11;
                                        };

                                        const operand_112 = (try ((std).math).add(usize, ((operand_109).items).len, 1));

                                        break :block_115 @as((zx_abi).value_47cff92a9b46587c1b50630dc4fca58faeacd65edf899a985425b50990563280, .{
                                            block_114: {
                                                const operand_113 = (try (zx_abi).zxReserveBounded(u64, allocator, (operand_109).items, operand_112, (((loop_seed_104).source).items).len));

                                                (operand_113)[((operand_109).items).len] = operand_111;

                                                break :block_114 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                                    .items = operand_113,
                                                    .storage = (if (((((operand_109).items).len == 0) or ((operand_109).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_117 loop_fields_105{
                                        .index = operand_107,
                                        .result = operand_108,
                                        .source = block_116: {
                                            _ = operand_106;

                                            break :block_116 (&(loop_seed_104).source);
                                        },
                                    };
                                };
                            };

                            state_97 = loop_fields_105{
                                .index = (operand_124).index,
                                .result = (operand_124).result,
                                .source = (operand_124).source,
                                .zx_origin = (operand_124).zx_origin,
                            };

                            if ((!((state_97).index < @as(u64, ((((state_97).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_125 = (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = (state_97).index,
                            .result = (state_97).result,
                            .source = ((state_97).source).*,
                            .zx_origin = (state_97).zx_origin,
                        };

                        break :block_126 (operand_125).result;
                    } else block_127: {
                        break :block_127 (loop_seed_104).result;
                    });
                };
            };

            const operand_130 = @as(u64, 0);

            break :block_131 @as((zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943, (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943{
                .used = operand_93,
                .members = operand_94,
                .bytes = operand_95,
                .owners = operand_96,
                .index = operand_130,
            });
        };

        const value_33: (zx_abi).value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285 = block_92: {
            const operand_89 = block_88: {
                break :block_88 value_5;
            };

            const operand_90 = in;
            const operand_91 = value_4;

            break :block_92 @as((zx_abi).value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285, .{
                operand_89,
                operand_90,
                operand_91,
                null,
            });
        };

        break :block_132 block_87: {
            const value_31: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_86: {
                const operand_7 = value_32;
                var state_6: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = operand_7;
                var state_changed_9 = false;

                while (block_11: {
                    const value_14: u64 = (value_33).@"0";

                    break :block_11 ((state_6).index < block_10: {
                        break :block_10 value_14;
                    });
                }) {
                    const operand_74 = block_73: {
                        const value_16: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = (value_33).@"1";
                        const value_26: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_33).@"2";

                        break :block_73 block_72: {
                            const value_24: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = block_71: {
                                const value_18: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                    .items = (block_70: {
                                        break :block_70 value_16;
                                    }).sizes,
                                    .storage = .plain,
                                };
                                break :block_71 block_69: {
                                    const operand_43 = block_42: {
                                        const operand_38 = value_18;
                                        const operand_39 = @as(u64, 0);
                                        const operand_40 = block_41: {
                                            break :block_41 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                .items = (&[_]bool{}),
                                                .storage = .plain,
                                            };
                                        };

                                        break :block_42 @as((zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c, (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = operand_39,
                                            .result = operand_40,
                                            .source = operand_38,
                                        });
                                    };
                                    const loop_fields_45 = struct {
                                        index: u64,
                                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                                    };
                                    var qualified_46: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = operand_43;

                                    ((qualified_46).source).storage = (if ((@backingInt(((qualified_46).source).storage) >= 2)) .shared else .plain);
                                    const loop_seed_44: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = qualified_46;

                                    break :block_69 (if (((loop_seed_44).index < @as(u64, (((loop_seed_44).source).items).len))) block_67: {
                                        var qualified_63: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_44).source;

                                        (qualified_63).storage = (if ((@backingInt((qualified_63).storage) >= 2)) .shared else .plain);

                                        const operand_64 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = (loop_seed_44).index,
                                            .result = (loop_seed_44).result,
                                            .source = qualified_63,
                                            .zx_origin = (loop_seed_44).zx_origin,
                                        };
                                        var state_37: loop_fields_45 = loop_fields_45{
                                            .index = (operand_64).index,
                                            .result = (operand_64).result,
                                            .source = (&(operand_64).source),
                                            .zx_origin = (operand_64).zx_origin,
                                        };

                                        while (true) {
                                            const operand_65 = block_62: {
                                                _ = block_61: {
                                                    const operand_59 = (((state_37).source).*).items;
                                                    const operand_60 = (state_37).index;

                                                    if ((operand_60 >= (operand_59).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    break :block_61 (operand_59)[@intCast(operand_60)];
                                                };
                                                const value_22: bool = false;

                                                break :block_62 block_58: {
                                                    const operand_47 = ((state_37).source).*;
                                                    const operand_48 = ((state_37).index + @as(u64, 1));
                                                    const operand_49 = (block_56: {
                                                        const operand_50 = (state_37).result;
                                                        const operand_52 = block_51: {
                                                            break :block_51 value_22;
                                                        };

                                                        const operand_53 = (try ((std).math).add(usize, ((operand_50).items).len, 1));

                                                        break :block_56 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                                            block_55: {
                                                                const operand_54 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_50).items, operand_53, (((loop_seed_44).source).items).len));

                                                                (operand_54)[((operand_50).items).len] = operand_52;

                                                                break :block_55 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                                    .items = operand_54,
                                                                    .storage = (if (((((operand_50).items).len == 0) or ((operand_50).storage == .exclusive))) .exclusive else .shared),
                                                                };
                                                            },
                                                            {},
                                                            null,
                                                        });
                                                    }).@"0";
                                                    break :block_58 loop_fields_45{
                                                        .index = operand_48,
                                                        .result = operand_49,
                                                        .source = block_57: {
                                                            _ = operand_47;

                                                            break :block_57 (&(loop_seed_44).source);
                                                        },
                                                    };
                                                };
                                            };

                                            state_37 = loop_fields_45{
                                                .index = (operand_65).index,
                                                .result = (operand_65).result,
                                                .source = (operand_65).source,
                                                .zx_origin = (operand_65).zx_origin,
                                            };

                                            if ((!((state_37).index < @as(u64, ((((state_37).source).*).items).len)))) {
                                                break;
                                            }
                                        }

                                        const operand_66 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = (state_37).index,
                                            .result = (state_37).result,
                                            .source = ((state_37).source).*,
                                            .zx_origin = (state_37).zx_origin,
                                        };

                                        break :block_67 (operand_66).result;
                                    } else block_68: {
                                        break :block_68 (loop_seed_44).result;
                                    });
                                };
                            };
                            var value_25: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_36: {
                                var updated_28: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = state_6;

                                const operand_35 = (block_34: {
                                    const operand_29 = (state_6).used;
                                    const operand_30 = value_24;
                                    const operand_31 = (try ((std).math).add(usize, ((operand_29).items).len, 1));

                                    break :block_34 @as((zx_abi).value_d7bceb86a1d91974bdcf463ca8da12910084f072ba4f837b870c8bbbd765982e, .{
                                        block_33: {
                                            const operand_32 = (try (zx_abi).zxReserve([]const bool, allocator, (operand_29).items, operand_31, true));

                                            (operand_32)[((operand_29).items).len] = (operand_30).items;

                                            break :block_33 (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
                                                .items = operand_32,
                                                .storage = (if (((((operand_29).items).len == 0) or ((operand_29).storage == .exclusive))) .exclusive else .shared),
                                            };
                                        },
                                        {},
                                        null,
                                    });
                                }).@"0";
                                (updated_28).used = operand_35;
                                (updated_28).zx_origin = null;

                                break :block_36 updated_28;
                            };
                            const operand_27 = (block_26: {
                                const operand_21 = (value_25).members;
                                const operand_22 = value_26;
                                const operand_23 = (try ((std).math).add(usize, ((operand_21).items).len, 1));

                                break :block_26 @as((zx_abi).value_b716869decc621a5e3ca152b1c4c05d948ca99a713f3252bcb7225f8b5858e08, .{
                                    block_25: {
                                        const operand_24 = (try (zx_abi).zxReserve([]const u32, allocator, (operand_21).items, operand_23, true));

                                        (operand_24)[((operand_21).items).len] = (operand_22).items;

                                        break :block_25 (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397{
                                            .items = operand_24,
                                            .storage = (if (((((operand_21).items).len == 0) or ((operand_21).storage == .exclusive))) .exclusive else .shared),
                                        };
                                    },
                                    {},
                                    null,
                                });
                            }).@"0";
                            (value_25).members = operand_27;
                            (value_25).zx_origin = null;

                            const operand_20 = (block_19: {
                                const operand_14 = (value_25).bytes;
                                const operand_15 = @as(u64, 0);
                                const operand_16 = (try ((std).math).add(usize, ((operand_14).items).len, 1));

                                break :block_19 @as((zx_abi).value_47cff92a9b46587c1b50630dc4fca58faeacd65edf899a985425b50990563280, .{
                                    block_18: {
                                        const operand_17 = (try (zx_abi).zxReserve(u64, allocator, (operand_14).items, operand_16, true));

                                        (operand_17)[((operand_14).items).len] = operand_15;

                                        break :block_18 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                            .items = operand_17,
                                            .storage = (if (((((operand_14).items).len == 0) or ((operand_14).storage == .exclusive))) .exclusive else .shared),
                                        };
                                    },
                                    {},
                                    null,
                                });
                            }).@"0";
                            (value_25).bytes = operand_20;
                            (value_25).zx_origin = null;
                            const value_29: u64 = (value_25).index;

                            const operand_13 = (block_12: {
                                break :block_12 value_29;
                            } + @as(u64, 1));

                            (value_25).index = operand_13;
                            (value_25).zx_origin = null;

                            break :block_72 value_25;
                        };
                    };

                    const operand_75 = ((operand_74).bytes).items;
                    const operand_76 = ((operand_74).bytes).storage;
                    const operand_77 = (operand_74).index;
                    const operand_78 = ((operand_74).members).items;
                    const operand_79 = ((operand_74).members).storage;
                    const operand_80 = ((operand_74).owners).items;
                    const operand_81 = ((operand_74).owners).storage;
                    const operand_82 = ((operand_74).used).items;
                    const operand_83 = ((operand_74).used).storage;
                    const operand_84 = (operand_74).zx_origin;

                    ((state_6).bytes).items = operand_75;
                    ((state_6).bytes).storage = operand_76;
                    (state_6).index = operand_77;
                    ((state_6).members).items = operand_78;
                    ((state_6).members).storage = operand_79;
                    ((state_6).owners).items = operand_80;
                    ((state_6).owners).storage = operand_81;
                    ((state_6).used).items = operand_82;
                    ((state_6).used).storage = operand_83;
                    (state_6).zx_origin = operand_84;
                    state_changed_9 = true;
                }

                break :block_86 (if (state_changed_9) state_6 else operand_7);
            };

            break :block_87 block_5: {
                const operand_1 = (value_31).bytes;
                const operand_2 = (value_31).members;
                const operand_3 = (value_31).owners;
                const operand_4 = (value_31).used;

                break :block_5 @as((zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602, (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602{
                    .bytes = operand_1,
                    .members = operand_2,
                    .owners = operand_3,
                    .used = operand_4,
                });
            };
        };
    };
}
