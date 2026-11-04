const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_8ba89f6fd24b0d685288fcbd2d68ba4f61dabc30ebd626fb829a319904883aba) error{ OutOfMemory, }!(zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8 = (in).left;

    const value_2: (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8 = block_74: {
        const operand_72 = ((in).right).magnitude;
        const operand_73 = (if ((((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)) and (((in).right).magnitude != @as(u64, 0)))) (!((in).right).negative) else ((in).right).negative);

        break :block_74 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_72, .negative = operand_73, });
    };

    const value_3: bool = (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Add)) or ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Subtract)));

    const value_4: bool = (if (block_71: {
        break :block_71 value_3;
    }) (value_1).negative else ((value_1).negative != (value_2).negative));

    const value_5: u64 = block_70: {
        const operand_66 = ((in).target).id;

        const operand_68 = block_67: {
            break :block_67 value_4;
        };

        const operand_69 = (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3{ .id = operand_66, .negative = operand_68, };

        break :block_70 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).call(allocator, (&operand_69)));
    };

    const value_6: bool = (block_65: {
        break :block_65 value_4;
    } and (!((in).target).signed));

    const value_7: (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8 = block_64: {
        const operand_62 = @as(u64, 0);
        const operand_63 = false;

        break :block_64 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_62, .negative = operand_63, });
    };

    if (block_33: {
        break :block_33 value_3;
    }) {
        if (((value_1).negative == (value_2).negative)) {
            if (((block_56: {
                break :block_56 value_6;
            } or ((value_2).magnitude > block_57: {
                break :block_57 value_5;
            })) or ((value_1).magnitude > (block_58: {
                break :block_58 value_5;
            } - (value_2).magnitude)))) {
                return block_61: {
                    const operand_59 = value_7;
                    const operand_60 = @as([]const u8, "integer constant arithmetic overflows its type");

                    break :block_61 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_59, .message = operand_60, });
                };
            }

            const value_8: u64 = ((value_1).magnitude + (value_2).magnitude);

            return block_55: {
                const operand_47 = block_53: {
                    const operand_48 = block_49: {
                        break :block_49 value_8;
                    };
                    const operand_50 = ((block_51: {
                        break :block_51 value_8;
                    } != @as(u64, 0)) and block_52: {
                        break :block_52 value_4;
                    });

                    break :block_53 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_48, .negative = operand_50, });
                };

                const operand_54 = @as([]const u8, "");

                break :block_55 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_47, .message = operand_54, });
            };
        }

        const value_9: bool = ((value_1).magnitude >= (value_2).magnitude);

        const value_10: u64 = (if (block_46: {
            break :block_46 value_9;
        }) ((value_1).magnitude - (value_2).magnitude) else ((value_2).magnitude - (value_1).magnitude));

        const value_11: bool = (if (block_45: {
            break :block_45 value_9;
        }) (value_1).negative else (value_2).negative);

        return block_44: {
            const operand_34 = block_40: {
                const operand_35 = block_36: {
                    break :block_36 value_10;
                };

                const operand_37 = ((block_38: {
                    break :block_38 value_10;
                } != @as(u64, 0)) and block_39: {
                    break :block_39 value_11;
                });

                break :block_40 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_35, .negative = operand_37, });
            };

            const operand_41 = (if ((((block_42: {
                break :block_42 value_10;
            } != @as(u64, 0)) and block_43: {
                break :block_43 value_11;
            }) and (!((in).target).signed))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

            break :block_44 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_34, .message = operand_41, });
        };
    }

    if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Multiply))) {
        if ((((block_28: {
            break :block_28 value_6;
        } and ((value_1).magnitude != @as(u64, 0))) and ((value_2).magnitude != @as(u64, 0))) or (((value_2).magnitude != @as(u64, 0)) and ((value_1).magnitude > @divTrunc(block_29: {
            break :block_29 value_5;
        }, (value_2).magnitude))))) {
            return block_32: {
                const operand_30 = value_7;
                const operand_31 = @as([]const u8, "integer constant arithmetic overflows its type");

                break :block_32 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_30, .message = operand_31, });
            };
        }

        const value_12: u64 = ((value_1).magnitude * (value_2).magnitude);

        return block_27: {
            const operand_19 = block_25: {
                const operand_20 = block_21: {
                    break :block_21 value_12;
                };
                const operand_22 = ((block_23: {
                    break :block_23 value_12;
                } != @as(u64, 0)) and block_24: {
                    break :block_24 value_4;
                });

                break :block_25 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_20, .negative = operand_22, });
            };

            const operand_26 = @as([]const u8, "");

            break :block_27 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_19, .message = operand_26, });
        };
    }

    if (((value_2).magnitude == @as(u64, 0))) {
        return block_18: {
            const operand_16 = value_7;
            const operand_17 = @as([]const u8, "integer constant division by zero");

            break :block_18 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_16, .message = operand_17, });
        };
    }

    const value_13: bool = ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Remainder));

    const value_14: u64 = (if (block_15: {
        break :block_15 value_13;
    }) @rem((value_1).magnitude, (value_2).magnitude) else @divTrunc((value_1).magnitude, (value_2).magnitude));

    return block_14: {
        const operand_1 = block_8: {
            const operand_2 = block_3: {
                break :block_3 value_14;
            };

            const operand_4 = ((block_5: {
                break :block_5 value_14;
            } != @as(u64, 0)) and (if (block_6: {
                break :block_6 value_13;
            }) (value_1).negative else block_7: {
                break :block_7 value_4;
            }));

            break :block_8 @as((zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8, (zx_abi).value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8{ .magnitude = operand_2, .negative = operand_4, });
        };

        const operand_9 = (if (((!block_10: {
            break :block_10 value_13;
        }) and (block_11: {
            break :block_11 value_6;
        } or (block_12: {
            break :block_12 value_14;
        } > block_13: {
            break :block_13 value_5;
        })))) @as([]const u8, "integer constant arithmetic overflows its type") else @as([]const u8, ""));

        break :block_14 @as((zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22, (zx_abi).value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22{ .value = operand_1, .message = operand_9, });
    };
}

