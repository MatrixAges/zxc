const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd = ((in).input).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).id));

    const value_3: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_78: {
        const operand_76 = (block_74: {
            break :block_74 value_1;
        }).kinds;

        const operand_77 = block_75: {
            break :block_75 value_2;
        };

        if ((operand_77 >= (operand_76).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_78 (operand_76)[@intCast(operand_77)];
    };

    const value_4: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_73: {
        const operand_71 = (block_69: {
            break :block_69 value_1;
        }).payloads;

        const operand_72 = block_70: {
            break :block_70 value_2;
        };

        if ((operand_72 >= (operand_71).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_73 (operand_71)[@intCast(operand_72)];
    }));

    const value_5: bool = ((block_67: {
        break :block_67 value_3;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer)) or (block_68: {
        break :block_68 value_3;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger)));

    const value_6: u64 = block_66: {
        const operand_55 = block_54: {
            break :block_54 value_3;
        };

        break :block_66 switch (operand_55) { @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer) => block_65: {
            const operand_63 = (block_61: {
                break :block_61 value_1;
            }).integers;

            const operand_64 = block_62: {
                break :block_62 value_4;
            };

            if ((operand_64 >= (operand_63).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_65 (operand_63)[@intCast(operand_64)];
        }, else => (if ((operand_55 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger))) block_60: {
            const operand_58 = (block_56: {
                break :block_56 value_1;
            }).negative_integers;

            const operand_59 = block_57: {
                break :block_57 value_4;
            };

            if ((operand_59 >= (operand_58).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_60 (operand_58)[@intCast(operand_59)];
        } else @as(u64, 0)), };
    };

    return block_53: {
        const operand_1 = block_6: {
            const operand_4 = (block_2: {
                break :block_2 value_1;
            }).types;

            const operand_5 = block_3: {
                break :block_3 value_2;
            };

            if ((operand_5 >= (operand_4).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_6 (operand_4)[@intCast(operand_5)];
        };

        const operand_7 = (if (block_8: {
            break :block_8 value_5;
        }) @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer) else block_9: {
            break :block_9 value_3;
        });

        const operand_10 = block_11: {
            break :block_11 value_6;
        };

        const operand_12 = ((block_13: {
            break :block_13 value_6;
        } != @as(u64, 0)) and (block_14: {
            break :block_14 value_3;
        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger)));

        const operand_15 = (if ((block_16: {
            break :block_16 value_3;
        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) block_21: {
            const operand_19 = (block_17: {
                break :block_17 value_1;
            }).floats;

            const operand_20 = block_18: {
                break :block_18 value_4;
            };

            if ((operand_20 >= (operand_19).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_21 (operand_19)[@intCast(operand_20)];
        } else @as(f64, @as(f64, @bitCast(@as(u64, 0)))));

        const operand_22 = (if ((block_23: {
            break :block_23 value_3;
        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) block_28: {
            const operand_26 = (block_24: {
                break :block_24 value_1;
            }).strings;

            const operand_27 = block_25: {
                break :block_25 value_4;
            };

            if ((operand_27 >= (operand_26).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_28 (operand_26)[@intCast(operand_27)];
        } else @as([]const u8, ""));

        const operand_29 = ((block_30: {
            break :block_30 value_3;
        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean)) and block_35: {
            const operand_33 = (block_31: {
                break :block_31 value_1;
            }).booleans;

            const operand_34 = block_32: {
                break :block_32 value_4;
            };

            if ((operand_34 >= (operand_33).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_35 (operand_33)[@intCast(operand_34)];
        });

        const operand_36 = (if ((block_37: {
            break :block_37 value_3;
        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue))) block_42: {
            const operand_40 = (block_38: {
                break :block_38 value_1;
            }).enumerations;

            const operand_41 = block_39: {
                break :block_39 value_4;
            };

            if ((operand_41 >= (operand_40).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_42 (operand_40)[@intCast(operand_41)];
        } else @as(u32, 0));

        const operand_43 = operand_1;
        const operand_44 = operand_7;
        const operand_45 = operand_10;
        const operand_46 = operand_12;
        const operand_47 = operand_15;
        const operand_48 = operand_22;
        const operand_49 = operand_29;
        const operand_50 = operand_36;

        break :block_53 block_52: {
            const operand_51 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

            (operand_51).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .type_id = operand_43, .kind = operand_44, .integer = operand_45, .negative = operand_46, .floating = operand_47, .text = operand_48, .boolean = operand_49, .enumeration = operand_50, });

            break :block_52 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_51);
        };
    };
}
