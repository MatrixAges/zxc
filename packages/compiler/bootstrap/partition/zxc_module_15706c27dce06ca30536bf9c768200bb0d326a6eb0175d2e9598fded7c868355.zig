const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 {
    @setRuntimeSafety(true);

    return block_105: {
        const value_23: (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = block_104: {
            const operand_102 = (in).groups;
            const operand_103 = @as(u64, 0);

            break :block_104 @as((zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f, (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f{
                .groups = operand_102,
                .index = operand_103,
            });
        };

        const value_24: *const (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = in;

        break :block_105 block_101: {
            const value_22: (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = block_100: {
                const operand_5 = value_23;
                var state_4: (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = operand_5;
                var state_changed_7 = false;

                while (block_8: {
                    const value_2: *const (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = value_24;

                    break :block_8 ((state_4).index < @as(u64, (((value_2).closures).items).len));
                }) {
                    const operand_87 = block_86: {
                        const value_4: *const (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = value_24;

                        break :block_86 block_85: {
                            const value_5: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 = block_84: {
                                const operand_82 = ((value_4).closures).items;
                                const operand_83 = (state_4).index;

                                if ((operand_83 >= (operand_82).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_84 (operand_82)[@intCast(operand_83)];
                            };
                            const value_6: u64 = block_81: {
                                var qualified_80: (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = block_79: {
                                    const operand_73 = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                        .items = (block_74: {
                                            break :block_74 value_5;
                                        }).nodes,
                                        .storage = .plain,
                                    };
                                    const operand_75 = ((state_4).groups).used;
                                    const operand_76 = ((state_4).groups).bytes;
                                    const operand_77 = (value_4).weights;
                                    const operand_78 = (value_4).capacity;

                                    break :block_79 @as((zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134, (zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134{
                                        .nodes = operand_73,
                                        .used = operand_75,
                                        .bytes = operand_76,
                                        .weights = operand_77,
                                        .capacity = operand_78,
                                    });
                                };

                                zx_weaken_3ad1414129206d5e88ad45f867e6373f70d2704ad8c283732f62a12c4ca9e575((&qualified_80));

                                break :block_81 (try (@import("zxc_module_5635b5a07b8992f62a9cbaea6beb6f820cce47877ce22bf2c7764b7f93f846a1.zig")).callValue(allocator, qualified_80));
                            };
                            const value_7: (zx_abi).value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec = block_72: {
                                break :block_72 (try (@import("zxc_module_a75dfa9a05e3faa9afea9e0d1ac26b5357f9f8a91262b5f1b9e96da9127642b4.zig")).callValue(allocator, block_71: {
                                    const operand_51 = block_56: {
                                        break :block_56 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{
                                            .items = block_55: {
                                                const operand_53 = (((state_4).groups).used).items;

                                                const operand_54 = block_52: {
                                                    break :block_52 value_6;
                                                };

                                                if ((operand_54 >= (operand_53).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_55 (operand_53)[@intCast(operand_54)];
                                            },
                                            .storage = .plain,
                                        };
                                    };
                                    const operand_57 = block_62: {
                                        break :block_62 (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                            .items = block_61: {
                                                const operand_59 = (((state_4).groups).members).items;

                                                const operand_60 = block_58: {
                                                    break :block_58 value_6;
                                                };

                                                if ((operand_60 >= (operand_59).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_61 (operand_59)[@intCast(operand_60)];
                                            },
                                            .storage = .plain,
                                        };
                                    };
                                    const operand_63 = block_67: {
                                        const operand_65 = (((state_4).groups).bytes).items;

                                        const operand_66 = block_64: {
                                            break :block_64 value_6;
                                        };

                                        if ((operand_66 >= (operand_65).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_67 (operand_65)[@intCast(operand_66)];
                                    };

                                    const operand_68 = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{
                                        .items = (block_69: {
                                            break :block_69 value_5;
                                        }).nodes,
                                        .storage = .plain,
                                    };

                                    const operand_70 = (value_4).weights;

                                    break :block_71 @as((zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f, (zx_abi).value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f{
                                        .used = operand_51,
                                        .members = operand_57,
                                        .bytes = operand_63,
                                        .nodes = operand_68,
                                        .weights = operand_70,
                                    });
                                }));
                            };
                            const value_8: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = ((state_4).groups).owners;

                            const value_9: u64 = (block_50: {
                                break :block_50 value_5;
                            }).index;
                            var value_10: (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = block_49: {
                                break :block_49 block_48: {
                                    var updated_38: (zx_abi).value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = state_4;

                                    const operand_47 = block_46: {
                                        break :block_46 @as((zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602, (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602{
                                            .bytes = ((state_4).groups).bytes,
                                            .members = ((state_4).groups).members,
                                            .owners = block_45: {
                                                const operand_39 = value_8;

                                                const operand_41 = block_40: {
                                                    break :block_40 value_9;
                                                };

                                                if ((operand_41 >= ((operand_39).items).len)) {
                                                    return error.IndexOutOfBounds;
                                                }
                                                const operand_43 = block_42: {
                                                    break :block_42 value_6;
                                                };

                                                const operand_44 = @constCast((operand_39).items);

                                                (operand_44)[@intCast(operand_41)] = operand_43;

                                                break :block_45 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                                    .items = operand_44,
                                                    .storage = (if ((@backingInt((operand_39).storage) >= 2)) .exclusive else .owned),
                                                };
                                            },
                                            .used = ((state_4).groups).used,
                                        });
                                    };

                                    (updated_38).groups = operand_47;
                                    (updated_38).zx_origin = null;

                                    break :block_48 updated_38;
                                };
                            };

                            const value_11: (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82 = ((value_10).groups).used;

                            const value_12: u64 = block_37: {
                                break :block_37 value_6;
                            };
                            const operand_36 = block_35: {
                                break :block_35 @as((zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602, (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602{
                                    .bytes = ((value_10).groups).bytes,
                                    .members = ((value_10).groups).members,
                                    .owners = ((value_10).groups).owners,
                                    .used = block_34: {
                                        const operand_29 = value_11;

                                        const operand_31 = block_30: {
                                            break :block_30 value_12;
                                        };

                                        if ((operand_31 >= ((operand_29).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_32 = (value_7).used;
                                        const operand_33 = @constCast((operand_29).items);

                                        (operand_33)[@intCast(operand_31)] = (operand_32).items;

                                        break :block_34 (zx_abi).value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82{
                                            .items = operand_33,
                                            .storage = (if ((@backingInt((operand_29).storage) >= 2)) .exclusive else .owned),
                                        };
                                    },
                                });
                            };
                            (value_10).groups = operand_36;
                            (value_10).zx_origin = null;
                            const value_14: (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397 = ((value_10).groups).members;

                            const value_15: u64 = block_28: {
                                break :block_28 value_6;
                            };
                            const operand_27 = block_26: {
                                break :block_26 @as((zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602, (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602{
                                    .bytes = ((value_10).groups).bytes,
                                    .members = block_25: {
                                        const operand_20 = value_14;
                                        const operand_22 = block_21: {
                                            break :block_21 value_15;
                                        };

                                        if ((operand_22 >= ((operand_20).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_23 = (value_7).members;
                                        const operand_24 = @constCast((operand_20).items);

                                        (operand_24)[@intCast(operand_22)] = (operand_23).items;

                                        break :block_25 (zx_abi).value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397{
                                            .items = operand_24,
                                            .storage = (if ((@backingInt((operand_20).storage) >= 2)) .exclusive else .owned),
                                        };
                                    },
                                    .owners = ((value_10).groups).owners,
                                    .used = ((value_10).groups).used,
                                });
                            };

                            (value_10).groups = operand_27;
                            (value_10).zx_origin = null;
                            const value_17: (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = ((value_10).groups).bytes;

                            const value_18: u64 = block_19: {
                                break :block_19 value_6;
                            };
                            const operand_18 = block_17: {
                                break :block_17 @as((zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602, (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602{
                                    .bytes = block_16: {
                                        const operand_11 = value_17;
                                        const operand_13 = block_12: {
                                            break :block_12 value_18;
                                        };

                                        if ((operand_13 >= ((operand_11).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_14 = (value_7).bytes;
                                        const operand_15 = @constCast((operand_11).items);

                                        (operand_15)[@intCast(operand_13)] = operand_14;

                                        break :block_16 (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                                            .items = operand_15,
                                            .storage = (if ((@backingInt((operand_11).storage) >= 2)) .exclusive else .owned),
                                        };
                                    },
                                    .members = ((value_10).groups).members,
                                    .owners = ((value_10).groups).owners,
                                    .used = ((value_10).groups).used,
                                });
                            };

                            (value_10).groups = operand_18;
                            (value_10).zx_origin = null;
                            const value_20: u64 = (value_10).index;

                            const operand_10 = (block_9: {
                                break :block_9 value_20;
                            } + @as(u64, 1));

                            (value_10).index = operand_10;
                            (value_10).zx_origin = null;

                            break :block_85 value_10;
                        };
                    };

                    const operand_88 = (((operand_87).groups).bytes).items;
                    const operand_89 = (((operand_87).groups).bytes).storage;
                    const operand_90 = (((operand_87).groups).members).items;
                    const operand_91 = (((operand_87).groups).members).storage;
                    const operand_92 = (((operand_87).groups).owners).items;
                    const operand_93 = (((operand_87).groups).owners).storage;
                    const operand_94 = (((operand_87).groups).used).items;
                    const operand_95 = (((operand_87).groups).used).storage;
                    const operand_96 = ((operand_87).groups).zx_origin;
                    const operand_97 = (operand_87).index;
                    const operand_98 = (operand_87).zx_origin;
                    (((state_4).groups).bytes).items = operand_88;
                    (((state_4).groups).bytes).storage = operand_89;
                    (((state_4).groups).members).items = operand_90;
                    (((state_4).groups).members).storage = operand_91;
                    (((state_4).groups).owners).items = operand_92;
                    (((state_4).groups).owners).storage = operand_93;
                    (((state_4).groups).used).items = operand_94;
                    (((state_4).groups).used).storage = operand_95;
                    ((state_4).groups).zx_origin = operand_96;
                    (state_4).index = operand_97;
                    (state_4).zx_origin = operand_98;
                    state_changed_7 = true;
                }

                break :block_100 (if (state_changed_7) state_4 else operand_5);
            };

            break :block_101 block_3: {
                const operand_1 = ((value_22).groups).members;
                const operand_2 = ((value_22).groups).owners;

                break :block_3 @as((zx_abi).value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77, (zx_abi).value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77{
                    .members = operand_1,
                    .owners = operand_2,
                });
            };
        };
    };
}

fn zx_weaken_3ad1414129206d5e88ad45f867e6373f70d2704ad8c283732f62a12c4ca9e575(value: *(zx_abi).value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134) void {
    ((value).bytes).storage = (if ((@backingInt(((value).bytes).storage) >= 2)) .shared else .plain);
    ((value).nodes).storage = (if ((@backingInt(((value).nodes).storage) >= 2)) .shared else .plain);
    ((value).used).storage = (if ((@backingInt(((value).used).storage) >= 2)) .shared else .plain);
    ((value).weights).storage = (if ((@backingInt(((value).weights).storage) >= 2)) .shared else .plain);
}
