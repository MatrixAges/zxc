const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d {
    @setRuntimeSafety(true);

    return (block_83: {
        const operand_5 = block_4: {
            const operand_2 = (in).input;
            const operand_3 = (in).cursor;

            break :block_4 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .input = operand_2, .cursor = operand_3, });
        };

        var state_1: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = operand_5;
        var state_changed_6 = false;

        while (((@as(u64, (((state_1).cursor).frames).len) != @as(u64, 0)) and block_9: {
            const operand_7 = (((state_1).cursor).diagnostic).message;
            const operand_8 = @as([]const u8, "");

            break :block_9 ((std).mem).eql(u8, operand_7, operand_8);
        })) {
            state_1 = block_81: {
                const value_3: u64 = (@as(u64, (((state_1).cursor).frames).len) - @as(u64, 1));

                const value_4: *const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = block_80: {
                    const operand_78 = ((state_1).cursor).frames;

                    const operand_79 = block_77: {
                        break :block_77 value_3;
                    };

                    if ((operand_79 >= (operand_78).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_80 (operand_78)[@intCast(operand_79)];
                };

                const value_5: (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f = block_76: {
                    break :block_76 (try (@import("zxc_module_3651e11c8ce1242251c0ceb14a74e55db72e9316ff1dc9534f24e3ae67cdfb92.zig")).callValue(allocator, block_75: {
                        const operand_71 = (state_1).input;
                        const operand_72 = (state_1).cursor;

                        const operand_73 = block_74: {
                            break :block_74 value_4;
                        };

                        break :block_75 @as((zx_abi).value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108, (zx_abi).value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108{ .input = operand_71, .cursor = operand_72, .frame = operand_73, });
                    }));
                };
                const value_18: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = (if ((!block_12: {
                    const operand_10 = (value_5).message;
                    const operand_11 = @as([]const u8, "");

                    break :block_12 ((std).mem).eql(u8, operand_10, operand_11);
                })) block_29: {
                    const value_6: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, (block_28: {
                        break :block_28 value_4;
                    }).id));

                    const value_7: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = block_27: {
                        break :block_27 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .cursor = block_26: {
                            break :block_26 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .diagnostic = block_25: {
                                const operand_13 = @as([]const u8, "type_mismatch");
                                const operand_14 = block_18: {
                                    const operand_16 = (((state_1).input).expressions).span_start;

                                    const operand_17 = block_15: {
                                        break :block_15 value_6;
                                    };

                                    if ((operand_17 >= (operand_16).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_18 (operand_16)[@intCast(operand_17)];
                                };
                                const operand_19 = block_23: {
                                    const operand_21 = (((state_1).input).expressions).span_end;

                                    const operand_22 = block_20: {
                                        break :block_20 value_6;
                                    };

                                    if ((operand_22 >= (operand_21).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_23 (operand_21)[@intCast(operand_22)];
                                };
                                const operand_24 = (value_5).message;

                                break :block_25 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_13, .start = operand_14, .end = operand_19, .message = operand_24, });
                            }, .frames = ((state_1).cursor).frames, .values = ((state_1).cursor).values, });
                        }, .input = (state_1).input, });
                    };

                    break :block_29 value_7;
                } else block_70: {
                    const value_17: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = (if (((value_5).child != null)) block_42: {
                        const value_8: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = block_41: {
                            break :block_41 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .cursor = block_40: {
                                break :block_40 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .diagnostic = ((state_1).cursor).diagnostic, .frames = (block_39: {
                                    const operand_30 = ((state_1).cursor).frames;

                                    const operand_36 = block_35: {
                                        const operand_31 = (value_5).child.?;
                                        const operand_32 = @as(u64, 0);

                                        break :block_35 block_34: {
                                            const operand_33 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                                            (operand_33).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_31, .arm = operand_32, });

                                            break :block_34 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_33);
                                        };
                                    };

                                    const operand_37 = (try ((std).math).add(usize, (operand_30).len, 1));
                                    const operand_38 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, allocator, operand_30, operand_37, true));

                                    (operand_38)[(operand_30).len] = operand_36;

                                    break :block_39 @as((zx_abi).value_1f9649a515f859e127a36ca89d608790532a16e6ea1546c96e78e731cef9beae, .{ operand_38, {}, null, });
                                }).@"0", .values = ((state_1).cursor).values, });
                            }, .input = (state_1).input, });
                        };

                        break :block_42 value_8;
                    } else block_69: {
                        const value_16: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = (if (((value_5).value != null)) block_57: {
                            const value_9: []const ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = ((state_1).cursor).values;

                            const value_10: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, (block_56: {
                                break :block_56 value_4;
                            }).id));

                            const value_11: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = block_55: {
                                break :block_55 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .cursor = block_54: {
                                    break :block_54 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .diagnostic = ((state_1).cursor).diagnostic, .frames = ((state_1).cursor).frames, .values = block_53: {
                                        const operand_48 = block_47: {
                                            break :block_47 value_9;
                                        };
                                        const operand_50 = block_49: {
                                            break :block_49 value_10;
                                        };

                                        if ((operand_50 >= (operand_48).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_51 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (value_5).value.?);
                                        const operand_52 = @constCast(operand_48);

                                        (operand_52)[@intCast(operand_50)] = operand_51;
                                        break :block_53 operand_52;
                                    }, });
                                }, .input = (state_1).input, });
                            };
                            const value_12: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = block_46: {
                                break :block_46 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .cursor = block_45: {
                                    break :block_45 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .diagnostic = ((value_11).cursor).diagnostic, .frames = (block_44: {
                                        const operand_43 = ((value_11).cursor).frames;

                                        if (((operand_43).len != 0)) {
                                            (zx_abi).zxRetract(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_43, ((operand_43).len - 1));
                                        }

                                        break :block_44 @as((zx_abi).value_630ec9d33439476996e1b739fdd47d00a4a4e78a448fb9fdfb5f6a73ff0e909a, (if (((operand_43).len == 0)) .{ operand_43, null, null, } else .{ (operand_43)[0..((operand_43).len - 1)], (operand_43)[((operand_43).len - 1)], null, }));
                                    }).@"0", .values = ((value_11).cursor).values, });
                                }, .input = (value_11).input, });
                            };

                            break :block_57 value_12;
                        } else block_68: {
                            const value_13: []const *const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = ((state_1).cursor).frames;

                            const value_14: u64 = block_67: {
                                break :block_67 value_3;
                            };
                            const value_15: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = block_66: {
                                break :block_66 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .cursor = block_65: {
                                    break :block_65 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .diagnostic = ((state_1).cursor).diagnostic, .frames = block_64: {
                                        const operand_59 = block_58: {
                                            break :block_58 value_13;
                                        };
                                        const operand_61 = block_60: {
                                            break :block_60 value_14;
                                        };

                                        if ((operand_61 >= (operand_59).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_62 = (value_5).frame;
                                        const operand_63 = @constCast(operand_59);

                                        (operand_63)[@intCast(operand_61)] = operand_62;

                                        break :block_64 operand_63;
                                    }, .values = ((state_1).cursor).values, });
                                }, .input = (state_1).input, });
                            };

                            break :block_68 value_15;
                        });

                        break :block_69 value_16;
                    });

                    break :block_70 value_17;
                });

                break :block_81 value_18;
            };

            state_changed_6 = true;
        }

        break :block_83 (if (state_changed_6) state_1 else operand_5);
    }).cursor;
}

