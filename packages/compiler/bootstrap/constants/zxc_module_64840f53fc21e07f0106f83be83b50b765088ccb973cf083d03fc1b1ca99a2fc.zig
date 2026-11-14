const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e {
    @setRuntimeSafety(true);

    return block_111: {
        const value_19: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = block_110: {
            const operand_5 = block_4: {
                const operand_2 = (in).input;
                const operand_3 = (in).cursor;

                break :block_4 @as((zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579, (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579{ .input = operand_2, .cursor = operand_3, });
            };

            var state_1: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = operand_5;
            var state_changed_7 = false;

            if (((@as(u64, ((((state_1).cursor).frames).items).len) != @as(u64, 0)) and block_10: {
                const operand_8 = (((state_1).cursor).diagnostic).message;
                const operand_9 = @as([]const u8, "");

                break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
            })) {
                (try (zx_abi).zxRenew(allocator, (&state_1), (&[_][2][]const u8{.{ "cursor", "zx_origin", }, .{ "frames", "zx_origin", }, }), false));

                while (true) {
                    const operand_96 = block_95: {
                        const value_3: u64 = (@as(u64, ((((state_1).cursor).frames).items).len) - @as(u64, 1));

                        const value_4: *const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = block_94: {
                            const operand_92 = (((state_1).cursor).frames).items;

                            const operand_93 = block_91: {
                                break :block_91 value_3;
                            };

                            if ((operand_93 >= (operand_92).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_94 (operand_92)[@intCast(operand_93)];
                        };
                        const value_5: (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b = block_90: {
                            break :block_90 (try (@import("zxc_module_3651e11c8ce1242251c0ceb14a74e55db72e9316ff1dc9534f24e3ae67cdfb92.zig")).callValue(allocator, block_89: {
                                const operand_85 = (state_1).input;
                                const operand_86 = (state_1).cursor;

                                const operand_87 = block_88: {
                                    break :block_88 value_4;
                                };

                                break :block_89 @as((zx_abi).value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9, (zx_abi).value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9{ .input = operand_85, .cursor = operand_86, .frame = operand_87, });
                            }));
                        };
                        const value_18: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = (if ((!block_13: {
                            const operand_11 = (value_5).message;
                            const operand_12 = @as([]const u8, "");

                            break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
                        })) block_33: {
                            const value_6: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (block_32: {
                                break :block_32 value_4;
                            }).id));

                            const value_7: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = block_31: {
                                break :block_31 block_30: {
                                    var updated_14: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = state_1;

                                    const operand_29 = block_28: {
                                        break :block_28 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .diagnostic = block_27: {
                                            const operand_15 = @as([]const u8, "type_mismatch");
                                            const operand_16 = block_20: {
                                                const operand_18 = (((state_1).input).expressions).span_start;

                                                const operand_19 = block_17: {
                                                    break :block_17 value_6;
                                                };

                                                if ((operand_19 >= (operand_18).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_20 (operand_18)[@intCast(operand_19)];
                                            };
                                            const operand_21 = block_25: {
                                                const operand_23 = (((state_1).input).expressions).span_end;

                                                const operand_24 = block_22: {
                                                    break :block_22 value_6;
                                                };

                                                if ((operand_24 >= (operand_23).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_25 (operand_23)[@intCast(operand_24)];
                                            };
                                            const operand_26 = (value_5).message;

                                            break :block_27 @as((zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7{ .code = operand_15, .start = operand_16, .end = operand_21, .message = operand_26, });
                                        }, .frames = ((state_1).cursor).frames, .values = ((state_1).cursor).values, });
                                    };

                                    (updated_14).cursor = operand_29;
                                    (updated_14).zx_origin = null;

                                    break :block_30 updated_14;
                                };
                            };

                            break :block_33 value_7;
                        } else block_84: {
                            const value_17: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = (if (((value_5).child != null)) block_52: {
                                const value_8: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = block_51: {
                                    break :block_51 block_50: {
                                        var updated_34: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = state_1;

                                        const operand_49 = block_48: {
                                            break :block_48 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .diagnostic = ((state_1).cursor).diagnostic, .frames = (block_47: {
                                                const operand_35 = ((state_1).cursor).frames;

                                                const operand_43 = block_42: {
                                                    const operand_36 = (value_5).child.?;
                                                    const operand_37 = @as(u64, 0);
                                                    const operand_38 = operand_36;
                                                    const operand_39 = operand_37;

                                                    break :block_42 block_41: {
                                                        const operand_40 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                                                        (operand_40).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_38, .arm = operand_39, });

                                                        break :block_41 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_40);
                                                    };
                                                };

                                                const operand_44 = (try ((std).math).add(usize, ((operand_35).items).len, 1));

                                                break :block_47 @as((zx_abi).value_30171d09e8eae29f60d074b9dcbdb99d3a5142b2495ac6a632bb64ff022c4faf, .{ block_46: {
                                                    const operand_45 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, allocator, (operand_35).items, operand_44, true));

                                                    (operand_45)[((operand_35).items).len] = operand_43;

                                                    break :block_46 (zx_abi).value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d{ .items = operand_45, .storage = (if ((((((operand_35).items).len == 0) or ((operand_45).ptr != ((operand_35).items).ptr)) or ((operand_35).storage == .exclusive))) .exclusive else .shared), };
                                                }, {}, null, });
                                            }).@"0", .values = ((state_1).cursor).values, });
                                        };

                                        (updated_34).cursor = operand_49;
                                        (updated_34).zx_origin = null;

                                        break :block_50 updated_34;
                                    };
                                };

                                break :block_52 value_8;
                            } else block_83: {
                                const value_16: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = (if (((value_5).value != null)) block_69: {
                                    const value_9: (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db = ((state_1).cursor).values;

                                    const value_10: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (block_68: {
                                        break :block_68 value_4;
                                    }).id));

                                    var value_11: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = block_67: {
                                        break :block_67 block_66: {
                                            var updated_57: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = state_1;

                                            const operand_65 = block_64: {
                                                break :block_64 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .diagnostic = ((state_1).cursor).diagnostic, .frames = ((state_1).cursor).frames, .values = block_63: {
                                                    const operand_58 = value_9;
                                                    const operand_60 = block_59: {
                                                        break :block_59 value_10;
                                                    };

                                                    if ((operand_60 >= ((operand_58).items).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    const operand_61 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_5).value.?);
                                                    const operand_62 = @constCast((operand_58).items);

                                                    (operand_62)[@intCast(operand_60)] = operand_61;

                                                    break :block_63 (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db{ .items = operand_62, .storage = (if ((@intFromEnum((operand_58).storage) >= 2)) .exclusive else .owned), };
                                                }, });
                                            };
                                            (updated_57).cursor = operand_65;
                                            (updated_57).zx_origin = null;

                                            break :block_66 updated_57;
                                        };
                                    };
                                    const operand_56 = block_55: {
                                        break :block_55 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .diagnostic = ((value_11).cursor).diagnostic, .frames = (block_54: {
                                            const operand_53 = ((value_11).cursor).frames;

                                            if ((((operand_53).items).len != 0)) {
                                                (zx_abi).zxRetract(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (operand_53).items, (((operand_53).items).len - 1));
                                            }

                                            break :block_54 @as((zx_abi).value_f77f88e85b2a7f61509ed5cbd0a601f686b428bbbcde6e49a03e4de67adb65f8, (if ((((operand_53).items).len == 0)) .{ operand_53, null, null, } else .{ (zx_abi).value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d{ .items = ((operand_53).items)[0..(((operand_53).items).len - 1)], .storage = (if ((@intFromEnum((operand_53).storage) >= 2)) (if ((@rem(@intFromEnum((operand_53).storage), 2) != 0)) .exclusive else .shared) else (if ((@rem(@intFromEnum((operand_53).storage), 2) != 0)) .owned else .plain)), }, ((operand_53).items)[(((operand_53).items).len - 1)], null, }));
                                        }).@"0", .values = ((value_11).cursor).values, });
                                    };

                                    (value_11).cursor = operand_56;
                                    (value_11).zx_origin = null;

                                    break :block_69 value_11;
                                } else block_82: {
                                    const value_13: (zx_abi).value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d = ((state_1).cursor).frames;

                                    const value_14: u64 = block_81: {
                                        break :block_81 value_3;
                                    };
                                    const value_15: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = block_80: {
                                        break :block_80 block_79: {
                                            var updated_70: (zx_abi).value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = state_1;

                                            const operand_78 = block_77: {
                                                break :block_77 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .diagnostic = ((state_1).cursor).diagnostic, .frames = block_76: {
                                                    const operand_71 = value_13;
                                                    const operand_73 = block_72: {
                                                        break :block_72 value_14;
                                                    };

                                                    if ((operand_73 >= ((operand_71).items).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    const operand_74 = (value_5).frame;
                                                    const operand_75 = @constCast((operand_71).items);

                                                    (operand_75)[@intCast(operand_73)] = operand_74;

                                                    break :block_76 (zx_abi).value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d{ .items = operand_75, .storage = (if ((@intFromEnum((operand_71).storage) >= 2)) .exclusive else .owned), };
                                                }, .values = ((state_1).cursor).values, });
                                            };

                                            (updated_70).cursor = operand_78;
                                            (updated_70).zx_origin = null;

                                            break :block_79 updated_70;
                                        };
                                    };

                                    break :block_82 value_15;
                                });

                                break :block_83 value_16;
                            });

                            break :block_84 value_17;
                        });

                        break :block_95 value_18;
                    };

                    const operand_97 = (((operand_96).cursor).diagnostic).code;
                    const operand_98 = (((operand_96).cursor).diagnostic).end;
                    const operand_99 = (((operand_96).cursor).diagnostic).message;
                    const operand_100 = (((operand_96).cursor).diagnostic).start;
                    const operand_101 = (((operand_96).cursor).diagnostic).zx_origin;
                    const operand_102 = (((operand_96).cursor).frames).items;
                    const operand_103 = (((operand_96).cursor).frames).storage;
                    const operand_104 = (((operand_96).cursor).values).items;
                    const operand_105 = (((operand_96).cursor).values).storage;
                    const operand_106 = ((operand_96).cursor).zx_origin;
                    const operand_107 = (operand_96).input;
                    const operand_108 = (operand_96).zx_origin;
                    (((state_1).cursor).diagnostic).code = operand_97;
                    (((state_1).cursor).diagnostic).end = operand_98;
                    (((state_1).cursor).diagnostic).message = operand_99;
                    (((state_1).cursor).diagnostic).start = operand_100;
                    (((state_1).cursor).diagnostic).zx_origin = operand_101;
                    (((state_1).cursor).frames).items = operand_102;
                    (((state_1).cursor).frames).storage = operand_103;
                    (((state_1).cursor).values).items = operand_104;
                    (((state_1).cursor).values).storage = operand_105;
                    ((state_1).cursor).zx_origin = operand_106;
                    (state_1).input = operand_107;
                    (state_1).zx_origin = operand_108;
                    state_changed_7 = true;

                    if ((!((@as(u64, ((((state_1).cursor).frames).items).len) != @as(u64, 0)) and block_10: {
                        const operand_8 = (((state_1).cursor).diagnostic).message;
                        const operand_9 = @as([]const u8, "");

                        break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
                    }))) {
                        break;
                    }
                }
            }

            break :block_110 (if (state_changed_7) state_1 else operand_5);
        };

        break :block_111 (value_19).cursor;
    };
}
