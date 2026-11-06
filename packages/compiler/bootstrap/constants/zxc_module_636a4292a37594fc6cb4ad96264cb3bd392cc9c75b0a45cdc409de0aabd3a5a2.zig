const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3) error{ OutOfMemory, }!(zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7 = (in).left;

    const value_2: (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7 = block_76: {
        const operand_74 = ((in).right).magnitude;
        const operand_75 = (if ((((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)) and (((in).right).magnitude != @as(u64, 0)))) (!((in).right).negative) else ((in).right).negative);

        break :block_76 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_74, .negative = operand_75, });
    };

    const value_3: bool = (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add)) or ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)));

    const value_4: bool = (if (block_73: {
        break :block_73 value_3;
    }) (value_1).negative else ((value_1).negative != (value_2).negative));

    const value_5: u64 = block_72: {
        const operand_68 = ((in).target).id;

        const operand_70 = block_69: {
            break :block_69 value_4;
        };

        const operand_71 = (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3{ .id = operand_68, .negative = operand_70, };

        break :block_72 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).call(allocator, (&operand_71)));
    };

    const value_6: bool = (block_67: {
        break :block_67 value_4;
    } and (!((in).target).signed));

    const value_7: (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7 = block_66: {
        const operand_64 = @as(u64, 0);
        const operand_65 = false;

        break :block_66 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_64, .negative = operand_65, });
    };

    if (block_34: {
        break :block_34 value_3;
    }) {
        if (((value_1).negative == (value_2).negative)) {
            const value_8: bool = (((!(!block_61: {
                break :block_61 value_6;
            })) or ((value_2).magnitude > block_62: {
                break :block_62 value_5;
            })) or ((value_1).magnitude > (block_63: {
                break :block_63 value_5;
            } - (value_2).magnitude)));

            if (block_57: {
                break :block_57 value_8;
            }) {
                return block_60: {
                    const operand_58 = value_7;
                    const operand_59 = @as([]const u8, "integer constant arithmetic overflows its type");

                    break :block_60 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_58, .message = operand_59, });
                };
            }

            const value_9: u64 = ((value_1).magnitude + (value_2).magnitude);

            return block_56: {
                const operand_48 = block_54: {
                    const operand_49 = block_50: {
                        break :block_50 value_9;
                    };
                    const operand_51 = ((block_52: {
                        break :block_52 value_9;
                    } != @as(u64, 0)) and block_53: {
                        break :block_53 value_4;
                    });

                    break :block_54 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_49, .negative = operand_51, });
                };

                const operand_55 = @as([]const u8, "");

                break :block_56 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_48, .message = operand_55, });
            };
        }

        const value_10: bool = ((value_1).magnitude >= (value_2).magnitude);

        const value_11: u64 = (if (block_47: {
            break :block_47 value_10;
        }) ((value_1).magnitude - (value_2).magnitude) else ((value_2).magnitude - (value_1).magnitude));

        const value_12: bool = (if (block_46: {
            break :block_46 value_10;
        }) (value_1).negative else (value_2).negative);

        return block_45: {
            const operand_35 = block_41: {
                const operand_36 = block_37: {
                    break :block_37 value_11;
                };
                const operand_38 = ((block_39: {
                    break :block_39 value_11;
                } != @as(u64, 0)) and block_40: {
                    break :block_40 value_12;
                });

                break :block_41 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_36, .negative = operand_38, });
            };

            const operand_42 = (if ((((block_43: {
                break :block_43 value_11;
            } != @as(u64, 0)) and block_44: {
                break :block_44 value_12;
            }) and (!((in).target).signed))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

            break :block_45 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_35, .message = operand_42, });
        };
    }

    if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply))) {
        const value_13: bool = ((((!(!block_32: {
            break :block_32 value_6;
        })) and ((value_1).magnitude != @as(u64, 0))) and ((value_2).magnitude != @as(u64, 0))) or (((value_2).magnitude != @as(u64, 0)) and ((value_1).magnitude > @divTrunc(block_33: {
            break :block_33 value_5;
        }, (value_2).magnitude))));

        if (block_28: {
            break :block_28 value_13;
        }) {
            return block_31: {
                const operand_29 = value_7;
                const operand_30 = @as([]const u8, "integer constant arithmetic overflows its type");

                break :block_31 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_29, .message = operand_30, });
            };
        }

        const value_14: u64 = ((value_1).magnitude * (value_2).magnitude);

        return block_27: {
            const operand_19 = block_25: {
                const operand_20 = block_21: {
                    break :block_21 value_14;
                };
                const operand_22 = ((block_23: {
                    break :block_23 value_14;
                } != @as(u64, 0)) and block_24: {
                    break :block_24 value_4;
                });

                break :block_25 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_20, .negative = operand_22, });
            };

            const operand_26 = @as([]const u8, "");

            break :block_27 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_19, .message = operand_26, });
        };
    }

    if (((value_2).magnitude == @as(u64, 0))) {
        return block_18: {
            const operand_16 = value_7;
            const operand_17 = @as([]const u8, "integer constant division by zero");

            break :block_18 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_16, .message = operand_17, });
        };
    }

    const value_15: bool = ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Remainder));

    const value_16: u64 = (if (block_15: {
        break :block_15 value_15;
    }) @rem((value_1).magnitude, (value_2).magnitude) else @divTrunc((value_1).magnitude, (value_2).magnitude));

    return block_14: {
        const operand_1 = block_8: {
            const operand_2 = block_3: {
                break :block_3 value_16;
            };

            const operand_4 = ((block_5: {
                break :block_5 value_16;
            } != @as(u64, 0)) and (if (block_6: {
                break :block_6 value_15;
            }) (value_1).negative else block_7: {
                break :block_7 value_4;
            }));

            break :block_8 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_2, .negative = operand_4, });
        };

        const operand_9 = (if (((!block_10: {
            break :block_10 value_15;
        }) and (block_11: {
            break :block_11 value_6;
        } or (block_12: {
            break :block_12 value_16;
        } > block_13: {
            break :block_13 value_5;
        })))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

        break :block_14 @as((zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64, (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64{ .value = operand_1, .message = operand_9, });
    };
}

