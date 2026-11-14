const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762) error{ OutOfMemory, }!(zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2 = (in).left;

    const value_2: (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2 = block_77: {
        const operand_75 = ((in).right).magnitude;
        const operand_76 = (if ((((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)) and (((in).right).magnitude != @as(u64, 0)))) (!((in).right).negative) else ((in).right).negative);

        break :block_77 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_75, .negative = operand_76, });
    };

    const value_3: bool = (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add)) or ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)));

    const value_4: bool = (if (block_74: {
        break :block_74 value_3;
    }) (value_1).negative else ((value_1).negative != (value_2).negative));

    const value_5: u64 = block_73: {
        break :block_73 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).callValue(allocator, block_72: {
            const operand_69 = ((in).target).id;

            const operand_70 = block_71: {
                break :block_71 value_4;
            };

            break :block_72 @as((zx_abi).value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82, (zx_abi).value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82{ .id = operand_69, .negative = operand_70, });
        }));
    };

    const value_6: bool = (block_68: {
        break :block_68 value_4;
    } and (!((in).target).signed));

    const value_7: (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2 = block_67: {
        const operand_65 = @as(u64, 0);
        const operand_66 = false;

        break :block_67 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_65, .negative = operand_66, });
    };

    if (block_35: {
        break :block_35 value_3;
    }) {
        if (((value_1).negative == (value_2).negative)) {
            const value_8: bool = (if (block_62: {
                break :block_62 value_6;
            }) true else (if (((value_2).magnitude > block_63: {
                break :block_63 value_5;
            })) true else ((value_1).magnitude > (block_64: {
                break :block_64 value_5;
            } - (value_2).magnitude))));

            if (block_58: {
                break :block_58 value_8;
            }) {
                return block_61: {
                    const operand_59 = value_7;
                    const operand_60 = @as([]const u8, "integer constant arithmetic overflows its type");

                    break :block_61 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_59, .message = operand_60, });
                };
            }

            const value_9: u64 = ((value_1).magnitude + (value_2).magnitude);

            return block_57: {
                const operand_49 = block_55: {
                    const operand_50 = block_51: {
                        break :block_51 value_9;
                    };
                    const operand_52 = ((block_53: {
                        break :block_53 value_9;
                    } != @as(u64, 0)) and block_54: {
                        break :block_54 value_4;
                    });

                    break :block_55 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_50, .negative = operand_52, });
                };

                const operand_56 = @as([]const u8, "");

                break :block_57 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_49, .message = operand_56, });
            };
        }

        const value_10: bool = ((value_1).magnitude >= (value_2).magnitude);

        const value_11: u64 = (if (block_48: {
            break :block_48 value_10;
        }) ((value_1).magnitude - (value_2).magnitude) else ((value_2).magnitude - (value_1).magnitude));

        const value_12: bool = (if (block_47: {
            break :block_47 value_10;
        }) (value_1).negative else (value_2).negative);

        return block_46: {
            const operand_36 = block_42: {
                const operand_37 = block_38: {
                    break :block_38 value_11;
                };
                const operand_39 = ((block_40: {
                    break :block_40 value_11;
                } != @as(u64, 0)) and block_41: {
                    break :block_41 value_12;
                });

                break :block_42 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_37, .negative = operand_39, });
            };

            const operand_43 = (if ((((block_44: {
                break :block_44 value_11;
            } != @as(u64, 0)) and block_45: {
                break :block_45 value_12;
            }) and (!((in).target).signed))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

            break :block_46 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_36, .message = operand_43, });
        };
    }

    if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply))) {
        const value_13: bool = (((!(!block_34: {
            break :block_34 value_6;
        })) and ((value_1).magnitude != @as(u64, 0))) and ((value_2).magnitude != @as(u64, 0)));

        const value_14: bool = (if (block_32: {
            break :block_32 value_13;
        }) true else (if (((value_2).magnitude == @as(u64, 0))) false else ((value_1).magnitude > @divTrunc(block_33: {
            break :block_33 value_5;
        }, (value_2).magnitude))));

        if (block_28: {
            break :block_28 value_14;
        }) {
            return block_31: {
                const operand_29 = value_7;
                const operand_30 = @as([]const u8, "integer constant arithmetic overflows its type");

                break :block_31 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_29, .message = operand_30, });
            };
        }

        const value_15: u64 = ((value_1).magnitude * (value_2).magnitude);

        return block_27: {
            const operand_19 = block_25: {
                const operand_20 = block_21: {
                    break :block_21 value_15;
                };
                const operand_22 = ((block_23: {
                    break :block_23 value_15;
                } != @as(u64, 0)) and block_24: {
                    break :block_24 value_4;
                });

                break :block_25 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_20, .negative = operand_22, });
            };

            const operand_26 = @as([]const u8, "");

            break :block_27 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_19, .message = operand_26, });
        };
    }

    if (((value_2).magnitude == @as(u64, 0))) {
        return block_18: {
            const operand_16 = value_7;
            const operand_17 = @as([]const u8, "integer constant division by zero");

            break :block_18 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_16, .message = operand_17, });
        };
    }

    const value_16: bool = ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Remainder));

    const value_17: u64 = (if (block_15: {
        break :block_15 value_16;
    }) @rem((value_1).magnitude, (value_2).magnitude) else @divTrunc((value_1).magnitude, (value_2).magnitude));

    return block_14: {
        const operand_1 = block_8: {
            const operand_2 = block_3: {
                break :block_3 value_17;
            };

            const operand_4 = ((block_5: {
                break :block_5 value_17;
            } != @as(u64, 0)) and (if (block_6: {
                break :block_6 value_16;
            }) (value_1).negative else block_7: {
                break :block_7 value_4;
            }));

            break :block_8 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_2, .negative = operand_4, });
        };

        const operand_9 = (if (((!block_10: {
            break :block_10 value_16;
        }) and (block_11: {
            break :block_11 value_6;
        } or (block_12: {
            break :block_12 value_17;
        } > block_13: {
            break :block_13 value_5;
        })))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

        break :block_14 @as((zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d, (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d{ .value = operand_1, .message = operand_9, });
    };
}
