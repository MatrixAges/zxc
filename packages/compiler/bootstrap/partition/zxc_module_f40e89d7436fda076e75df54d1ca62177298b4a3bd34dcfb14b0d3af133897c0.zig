const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82 = block_137: {
        break :block_137 (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
            .items = (&[_][]const bool{}),
            .storage = .plain,
        };
    };

    const value_2: (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397 = block_136: {
        break :block_136 (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397{
            .items = (&[_][]const u32{}),
            .storage = .plain,
        };
    };

    const value_3: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = block_135: {
        break :block_135 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
            .items = (&[_]u64{}),
            .storage = .plain,
        };
    };

    const value_4: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = block_134: {
        break :block_134 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
            .items = (&[_]u32{}),
            .storage = .plain,
        };
    };

    const value_5: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).partitions));

    return block_133: {
        const value_32: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_132: {
            const operand_94 = value_1;
            const operand_95 = value_2;
            const operand_96 = value_3;
            const operand_97 = block_130: {
                const value_7: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                    .items = (in).roots,
                    .storage = .plain,
                };

                break :block_130 block_129: {
                    const operand_104 = block_103: {
                        const operand_99 = value_7;
                        const operand_100 = @as(u64, 0);

                        const operand_101 = block_102: {
                            break :block_102 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                .items = (&[_]u64{}),
                                .storage = .plain,
                            };
                        };

                        break :block_103 @as((zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1, (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = operand_100,
                            .result = operand_101,
                            .source = operand_99,
                        });
                    };
                    const loop_fields_106 = struct {
                        index: u64,
                        result: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                        source: *const (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
                        zx_origin: ?*const (zx_abi).zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = null,
                    };

                    const loop_seed_105: (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1 = operand_104;

                    break :block_129 (if (((loop_seed_105).index < @as(u64, (((loop_seed_105).source).items).len))) block_127: {
                        var qualified_123: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (loop_seed_105).source;

                        (qualified_123).storage = (if ((@backingInt((qualified_123).storage) >= 2)) .shared else .plain);

                        const operand_124 = (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = (loop_seed_105).index,
                            .result = (loop_seed_105).result,
                            .source = qualified_123,
                            .zx_origin = (loop_seed_105).zx_origin,
                        };

                        var state_98: loop_fields_106 = loop_fields_106{
                            .index = (operand_124).index,
                            .result = (operand_124).result,
                            .source = (&(operand_124).source),
                            .zx_origin = (operand_124).zx_origin,
                        };

                        while (true) {
                            const operand_125 = block_122: {
                                _ = block_121: {
                                    const operand_119 = (((state_98).source).*).items;
                                    const operand_120 = (state_98).index;

                                    if ((operand_120 >= (operand_119).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_121 (operand_119)[@intCast(operand_120)];
                                };

                                const value_11: u64 = @as(u64, 0);

                                break :block_122 block_118: {
                                    const operand_107 = ((state_98).source).*;
                                    const operand_108 = ((state_98).index + @as(u64, 1));
                                    const operand_109 = (block_116: {
                                        const operand_110 = (state_98).result;

                                        const operand_112 = block_111: {
                                            break :block_111 value_11;
                                        };

                                        const operand_113 = (try ((std).math).add(usize, ((operand_110).items).len, 1));

                                        break :block_116 @as((zx_abi).value_47cff92a9b46587c1b50630dc4fca58faeacd65edf899a985425b50990563280, .{
                                            block_115: {
                                                const operand_114 = (try (zx_abi).zxReserveBounded(u64, allocator, (operand_110).items, operand_113, (((loop_seed_105).source).items).len));

                                                (operand_114)[((operand_110).items).len] = operand_112;

                                                break :block_115 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                                    .items = operand_114,
                                                    .storage = (if ((((((operand_110).items).len == 0) or ((operand_114).ptr != ((operand_110).items).ptr)) or ((operand_110).storage == .exclusive))) .exclusive else .shared),
                                                };
                                            },
                                            {},
                                            null,
                                        });
                                    }).@"0";
                                    break :block_118 loop_fields_106{
                                        .index = operand_108,
                                        .result = operand_109,
                                        .source = block_117: {
                                            _ = operand_107;

                                            break :block_117 (&(loop_seed_105).source);
                                        },
                                    };
                                };
                            };

                            state_98 = loop_fields_106{
                                .index = (operand_125).index,
                                .result = (operand_125).result,
                                .source = (operand_125).source,
                                .zx_origin = (operand_125).zx_origin,
                            };

                            if ((!((state_98).index < @as(u64, ((((state_98).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_126 = (zx_abi).value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1{
                            .index = (state_98).index,
                            .result = (state_98).result,
                            .source = ((state_98).source).*,
                            .zx_origin = (state_98).zx_origin,
                        };

                        break :block_127 (operand_126).result;
                    } else block_128: {
                        break :block_128 (loop_seed_105).result;
                    });
                };
            };

            const operand_131 = @as(u64, 0);

            break :block_132 @as((zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943, (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943{
                .used = operand_94,
                .members = operand_95,
                .bytes = operand_96,
                .owners = operand_97,
                .index = operand_131,
            });
        };

        const value_33: (zx_abi).value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285 = block_93: {
            const operand_90 = block_89: {
                break :block_89 value_5;
            };

            const operand_91 = in;
            const operand_92 = value_4;

            break :block_93 @as((zx_abi).value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285, .{
                operand_90,
                operand_91,
                operand_92,
                null,
            });
        };

        break :block_133 block_88: {
            const value_31: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_87: {
                const operand_7 = value_32;
                var state_6: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = operand_7;
                var state_changed_9 = false;

                while (block_11: {
                    const value_14: u64 = (value_33).@"0";

                    break :block_11 ((state_6).index < block_10: {
                        break :block_10 value_14;
                    });
                }) {
                    const operand_75 = block_74: {
                        const value_16: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = (value_33).@"1";
                        const value_26: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (value_33).@"2";

                        break :block_74 block_73: {
                            const value_24: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = block_72: {
                                const value_18: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                    .items = (block_71: {
                                        break :block_71 value_16;
                                    }).sizes,
                                    .storage = .plain,
                                };
                                break :block_72 block_70: {
                                    const operand_44 = block_43: {
                                        const operand_39 = value_18;
                                        const operand_40 = @as(u64, 0);
                                        const operand_41 = block_42: {
                                            break :block_42 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                .items = (&[_]bool{}),
                                                .storage = .plain,
                                            };
                                        };

                                        break :block_43 @as((zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c, (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = operand_40,
                                            .result = operand_41,
                                            .source = operand_39,
                                        });
                                    };
                                    const loop_fields_46 = struct {
                                        index: u64,
                                        result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                                        source: *const (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
                                        zx_origin: ?*const (zx_abi).zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
                                    };
                                    var qualified_47: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = operand_44;

                                    ((qualified_47).source).storage = (if ((@backingInt(((qualified_47).source).storage) >= 2)) .shared else .plain);
                                    const loop_seed_45: (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = qualified_47;

                                    break :block_70 (if (((loop_seed_45).index < @as(u64, (((loop_seed_45).source).items).len))) block_68: {
                                        var qualified_64: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = (loop_seed_45).source;
                                        (qualified_64).storage = (if ((@backingInt((qualified_64).storage) >= 2)) .shared else .plain);

                                        const operand_65 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = (loop_seed_45).index,
                                            .result = (loop_seed_45).result,
                                            .source = qualified_64,
                                            .zx_origin = (loop_seed_45).zx_origin,
                                        };

                                        var state_38: loop_fields_46 = loop_fields_46{
                                            .index = (operand_65).index,
                                            .result = (operand_65).result,
                                            .source = (&(operand_65).source),
                                            .zx_origin = (operand_65).zx_origin,
                                        };

                                        while (true) {
                                            const operand_66 = block_63: {
                                                _ = block_62: {
                                                    const operand_60 = (((state_38).source).*).items;
                                                    const operand_61 = (state_38).index;

                                                    if ((operand_61 >= (operand_60).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    break :block_62 (operand_60)[@intCast(operand_61)];
                                                };
                                                const value_22: bool = false;

                                                break :block_63 block_59: {
                                                    const operand_48 = ((state_38).source).*;
                                                    const operand_49 = ((state_38).index + @as(u64, 1));
                                                    const operand_50 = (block_57: {
                                                        const operand_51 = (state_38).result;

                                                        const operand_53 = block_52: {
                                                            break :block_52 value_22;
                                                        };

                                                        const operand_54 = (try ((std).math).add(usize, ((operand_51).items).len, 1));

                                                        break :block_57 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{
                                                            block_56: {
                                                                const operand_55 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_51).items, operand_54, (((loop_seed_45).source).items).len));

                                                                (operand_55)[((operand_51).items).len] = operand_53;

                                                                break :block_56 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                                                    .items = operand_55,
                                                                    .storage = (if ((((((operand_51).items).len == 0) or ((operand_55).ptr != ((operand_51).items).ptr)) or ((operand_51).storage == .exclusive))) .exclusive else .shared),
                                                                };
                                                            },
                                                            {},
                                                            null,
                                                        });
                                                    }).@"0";
                                                    break :block_59 loop_fields_46{
                                                        .index = operand_49,
                                                        .result = operand_50,
                                                        .source = block_58: {
                                                            _ = operand_48;

                                                            break :block_58 (&(loop_seed_45).source);
                                                        },
                                                    };
                                                };
                                            };

                                            state_38 = loop_fields_46{
                                                .index = (operand_66).index,
                                                .result = (operand_66).result,
                                                .source = (operand_66).source,
                                                .zx_origin = (operand_66).zx_origin,
                                            };

                                            if ((!((state_38).index < @as(u64, ((((state_38).source).*).items).len)))) {
                                                break;
                                            }
                                        }

                                        const operand_67 = (zx_abi).value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c{
                                            .index = (state_38).index,
                                            .result = (state_38).result,
                                            .source = ((state_38).source).*,
                                            .zx_origin = (state_38).zx_origin,
                                        };

                                        break :block_68 (operand_67).result;
                                    } else block_69: {
                                        break :block_69 (loop_seed_45).result;
                                    });
                                };
                            };
                            var value_25: (zx_abi).value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = block_37: {
                                break :block_37 block_36: {
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
                                                    .storage = (if ((((((operand_29).items).len == 0) or ((operand_32).ptr != ((operand_29).items).ptr)) or ((operand_29).storage == .exclusive))) .exclusive else .shared),
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
                                            .storage = (if ((((((operand_21).items).len == 0) or ((operand_24).ptr != ((operand_21).items).ptr)) or ((operand_21).storage == .exclusive))) .exclusive else .shared),
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
                                            .storage = (if ((((((operand_14).items).len == 0) or ((operand_17).ptr != ((operand_14).items).ptr)) or ((operand_14).storage == .exclusive))) .exclusive else .shared),
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

                            break :block_73 value_25;
                        };
                    };

                    const operand_76 = ((operand_75).bytes).items;
                    const operand_77 = ((operand_75).bytes).storage;
                    const operand_78 = (operand_75).index;
                    const operand_79 = ((operand_75).members).items;
                    const operand_80 = ((operand_75).members).storage;
                    const operand_81 = ((operand_75).owners).items;
                    const operand_82 = ((operand_75).owners).storage;
                    const operand_83 = ((operand_75).used).items;
                    const operand_84 = ((operand_75).used).storage;
                    const operand_85 = (operand_75).zx_origin;

                    ((state_6).bytes).items = operand_76;
                    ((state_6).bytes).storage = operand_77;
                    (state_6).index = operand_78;
                    ((state_6).members).items = operand_79;
                    ((state_6).members).storage = operand_80;
                    ((state_6).owners).items = operand_81;
                    ((state_6).owners).storage = operand_82;
                    ((state_6).used).items = operand_83;
                    ((state_6).used).storage = operand_84;
                    (state_6).zx_origin = operand_85;
                    state_changed_9 = true;
                }

                break :block_87 (if (state_changed_9) state_6 else operand_7);
            };

            break :block_88 block_5: {
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
