const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 {
    @setRuntimeSafety(true);

    return (block_98: {
        const operand_5 = block_4: {
            const operand_2 = (in).input;
            const operand_3 = (in).cursor;

            break :block_4 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .input = operand_2, .cursor = operand_3, });
        };

        var state_1: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = operand_5;
        var state_changed_7 = false;

        if (((@as(u64, ((((state_1).cursor).frames).items).len) != @as(u64, 0)) and block_10: {
            const operand_8 = (((state_1).cursor).diagnostic).message;
            const operand_9 = @as([]const u8, "");

            break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
        })) {
            (try (zx_abi).zxRenew(allocator, (&state_1), (&[_][2][]const u8{.{ "cursor", "zx_origin", }, .{ "frames", "zx_origin", }, }), false));

            while (true) {
                const operand_84 = block_83: {
                    const value_3: u64 = (@as(u64, ((((state_1).cursor).frames).items).len) - @as(u64, 1));

                    const value_4: *const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = block_82: {
                        const operand_80 = (((state_1).cursor).frames).items;

                        const operand_81 = block_79: {
                            break :block_79 value_3;
                        };

                        if ((operand_81 >= (operand_80).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_82 (operand_80)[@intCast(operand_81)];
                    };
                    const value_5: (zx_abi).value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969 = block_78: {
                        break :block_78 (try (@import("zxc_module_3651e11c8ce1242251c0ceb14a74e55db72e9316ff1dc9534f24e3ae67cdfb92.zig")).callValue(allocator, block_77: {
                            const operand_73 = (state_1).input;
                            const operand_74 = (state_1).cursor;

                            const operand_75 = block_76: {
                                break :block_76 value_4;
                            };

                            break :block_77 @as((zx_abi).value_d5a2abbc372f76159966b3930c9c4c5a4acd842be2767b076d686112aa34e82e, (zx_abi).value_d5a2abbc372f76159966b3930c9c4c5a4acd842be2767b076d686112aa34e82e{ .input = operand_73, .cursor = operand_74, .frame = operand_75, });
                        }));
                    };
                    const value_18: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = (if ((!block_13: {
                        const operand_11 = (value_5).message;
                        const operand_12 = @as([]const u8, "");

                        break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
                    })) block_30: {
                        const value_6: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (block_29: {
                            break :block_29 value_4;
                        }).id));

                        const value_7: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = block_28: {
                            break :block_28 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .cursor = block_27: {
                                break :block_27 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .diagnostic = block_26: {
                                    const operand_14 = @as([]const u8, "type_mismatch");
                                    const operand_15 = block_19: {
                                        const operand_17 = (((state_1).input).expressions).span_start;

                                        const operand_18 = block_16: {
                                            break :block_16 value_6;
                                        };

                                        if ((operand_18 >= (operand_17).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_19 (operand_17)[@intCast(operand_18)];
                                    };
                                    const operand_20 = block_24: {
                                        const operand_22 = (((state_1).input).expressions).span_end;

                                        const operand_23 = block_21: {
                                            break :block_21 value_6;
                                        };

                                        if ((operand_23 >= (operand_22).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_24 (operand_22)[@intCast(operand_23)];
                                    };
                                    const operand_25 = (value_5).message;

                                    break :block_26 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_14, .start = operand_15, .end = operand_20, .message = operand_25, });
                                }, .frames = ((state_1).cursor).frames, .values = ((state_1).cursor).values, });
                            }, .input = (state_1).input, });
                        };

                        break :block_30 value_7;
                    } else block_72: {
                        const value_17: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = (if (((value_5).child != null)) block_46: {
                            const value_8: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = block_45: {
                                break :block_45 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .cursor = block_44: {
                                    break :block_44 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .diagnostic = ((state_1).cursor).diagnostic, .frames = (block_43: {
                                        const operand_31 = ((state_1).cursor).frames;

                                        const operand_39 = block_38: {
                                            const operand_32 = (value_5).child.?;
                                            const operand_33 = @as(u64, 0);
                                            const operand_34 = operand_32;
                                            const operand_35 = operand_33;

                                            break :block_38 block_37: {
                                                const operand_36 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                                                (operand_36).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_34, .arm = operand_35, });

                                                break :block_37 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_36);
                                            };
                                        };

                                        const operand_40 = (try ((std).math).add(usize, ((operand_31).items).len, 1));

                                        break :block_43 @as((zx_abi).value_58e1795fdb635db9100e922c52e097020ab7211a8b685583f9bcc2429e02160a, .{ block_42: {
                                            const operand_41 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, allocator, (operand_31).items, operand_40, true));

                                            (operand_41)[((operand_31).items).len] = operand_39;

                                            break :block_42 (zx_abi).value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11{ .items = operand_41, .storage = (if (((((operand_31).items).len == 0) or ((operand_31).storage == .exclusive))) .exclusive else .shared), };
                                        }, {}, null, });
                                    }).@"0", .values = ((state_1).cursor).values, });
                                }, .input = (state_1).input, });
                            };

                            break :block_46 value_8;
                        } else block_71: {
                            const value_16: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = (if (((value_5).value != null)) block_60: {
                                const value_9: (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3 = ((state_1).cursor).values;

                                const value_10: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (block_59: {
                                    break :block_59 value_4;
                                }).id));

                                const value_11: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = block_58: {
                                    break :block_58 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .cursor = block_57: {
                                        break :block_57 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .diagnostic = ((state_1).cursor).diagnostic, .frames = ((state_1).cursor).frames, .values = block_56: {
                                            const operand_51 = value_9;
                                            const operand_53 = block_52: {
                                                break :block_52 value_10;
                                            };

                                            if ((operand_53 >= ((operand_51).items).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_54 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_5).value.?);
                                            const operand_55 = @constCast((operand_51).items);

                                            (operand_55)[@intCast(operand_53)] = operand_54;
                                            break :block_56 (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3{ .items = operand_55, .storage = (if ((@intFromEnum((operand_51).storage) >= 2)) .exclusive else .owned), };
                                        }, });
                                    }, .input = (state_1).input, });
                                };
                                const value_12: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = block_50: {
                                    break :block_50 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .cursor = block_49: {
                                        break :block_49 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .diagnostic = ((value_11).cursor).diagnostic, .frames = (block_48: {
                                            const operand_47 = ((value_11).cursor).frames;

                                            if ((((operand_47).items).len != 0)) {
                                                (zx_abi).zxRetract(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (operand_47).items, (((operand_47).items).len - 1));
                                            }

                                            break :block_48 @as((zx_abi).value_f5683dc6904c174d83434650b9f32edae81bfd9d82b6497a3db2c60195d534c5, (if ((((operand_47).items).len == 0)) .{ operand_47, null, null, } else .{ (zx_abi).value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11{ .items = ((operand_47).items)[0..(((operand_47).items).len - 1)], .storage = (if ((@intFromEnum((operand_47).storage) >= 2)) (if ((@rem(@intFromEnum((operand_47).storage), 2) != 0)) .exclusive else .shared) else (if ((@rem(@intFromEnum((operand_47).storage), 2) != 0)) .owned else .plain)), }, ((operand_47).items)[(((operand_47).items).len - 1)], null, }));
                                        }).@"0", .values = ((value_11).cursor).values, });
                                    }, .input = (value_11).input, });
                                };

                                break :block_60 value_12;
                            } else block_70: {
                                const value_13: (zx_abi).value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11 = ((state_1).cursor).frames;

                                const value_14: u64 = block_69: {
                                    break :block_69 value_3;
                                };
                                const value_15: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = block_68: {
                                    break :block_68 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .cursor = block_67: {
                                        break :block_67 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .diagnostic = ((state_1).cursor).diagnostic, .frames = block_66: {
                                            const operand_61 = value_13;

                                            const operand_63 = block_62: {
                                                break :block_62 value_14;
                                            };

                                            if ((operand_63 >= ((operand_61).items).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_64 = (value_5).frame;
                                            const operand_65 = @constCast((operand_61).items);

                                            (operand_65)[@intCast(operand_63)] = operand_64;
                                            break :block_66 (zx_abi).value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11{ .items = operand_65, .storage = (if ((@intFromEnum((operand_61).storage) >= 2)) .exclusive else .owned), };
                                        }, .values = ((state_1).cursor).values, });
                                    }, .input = (state_1).input, });
                                };

                                break :block_70 value_15;
                            });

                            break :block_71 value_16;
                        });

                        break :block_72 value_17;
                    });

                    break :block_83 value_18;
                };

                const operand_85 = (((operand_84).cursor).diagnostic).code;
                const operand_86 = (((operand_84).cursor).diagnostic).end;
                const operand_87 = (((operand_84).cursor).diagnostic).message;
                const operand_88 = (((operand_84).cursor).diagnostic).start;
                const operand_89 = (((operand_84).cursor).diagnostic).zx_origin;
                const operand_90 = (((operand_84).cursor).frames).items;
                const operand_91 = (((operand_84).cursor).frames).storage;
                const operand_92 = (((operand_84).cursor).values).items;
                const operand_93 = (((operand_84).cursor).values).storage;
                const operand_94 = ((operand_84).cursor).zx_origin;
                const operand_95 = (operand_84).input;
                const operand_96 = (operand_84).zx_origin;

                (((state_1).cursor).diagnostic).code = operand_85;
                (((state_1).cursor).diagnostic).end = operand_86;
                (((state_1).cursor).diagnostic).message = operand_87;
                (((state_1).cursor).diagnostic).start = operand_88;
                (((state_1).cursor).diagnostic).zx_origin = operand_89;
                (((state_1).cursor).frames).items = operand_90;
                (((state_1).cursor).frames).storage = operand_91;
                (((state_1).cursor).values).items = operand_92;
                (((state_1).cursor).values).storage = operand_93;
                ((state_1).cursor).zx_origin = operand_94;
                (state_1).input = operand_95;
                (state_1).zx_origin = operand_96;
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

        break :block_98 (if (state_changed_7) state_1 else operand_5);
    }).cursor;
}

