const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549) error{ }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: *const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (in).left;
    const value_2: *const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (in).right;

    if (((block_35: {
        break :block_35 value_1;
    }).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) {
        return block_49: {
            const operand_36 = (in).operator;

            break :block_49 switch (operand_36) { @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal) => ((block_47: {
                break :block_47 value_1;
            }).floating == (block_48: {
                break :block_48 value_2;
            }).floating), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual) => ((block_45: {
                break :block_45 value_1;
            }).floating != (block_46: {
                break :block_46 value_2;
            }).floating), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less) => ((block_43: {
                break :block_43 value_1;
            }).floating < (block_44: {
                break :block_44 value_2;
            }).floating), @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual) => ((block_41: {
                break :block_41 value_1;
            }).floating <= (block_42: {
                break :block_42 value_2;
            }).floating), else => (if ((operand_36 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) ((block_39: {
                break :block_39 value_1;
            }).floating > (block_40: {
                break :block_40 value_2;
            }).floating) else ((block_37: {
                break :block_37 value_1;
            }).floating >= (block_38: {
                break :block_38 value_2;
            }).floating)), };
        };
    }

    const value_3: bool = block_34: {
        const operand_20 = (block_19: {
            break :block_19 value_1;
        }).kind;

        break :block_34 switch (operand_20) { @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean) => ((block_32: {
            break :block_32 value_1;
        }).boolean == (block_33: {
            break :block_33 value_2;
        }).boolean), @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String) => block_31: {
            const operand_29 = (block_27: {
                break :block_27 value_1;
            }).text;

            const operand_30 = (block_28: {
                break :block_28 value_2;
            }).text;

            break :block_31 ((std).mem).eql(u8, operand_29, operand_30);
        }, else => (if ((operand_20 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue))) ((block_25: {
            break :block_25 value_1;
        }).enumeration == (block_26: {
            break :block_26 value_2;
        }).enumeration) else (((block_21: {
            break :block_21 value_1;
        }).negative == (block_22: {
            break :block_22 value_2;
        }).negative) and ((block_23: {
            break :block_23 value_1;
        }).integer == (block_24: {
            break :block_24 value_2;
        }).integer))), };
    };

    if ((((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal)) or ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual)))) {
        return (if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal))) block_17: {
            break :block_17 value_3;
        } else (!block_18: {
            break :block_18 value_3;
        }));
    }

    const value_4: bool = (if (((block_9: {
        break :block_9 value_1;
    }).negative != (block_10: {
        break :block_10 value_2;
    }).negative)) (block_11: {
        break :block_11 value_1;
    }).negative else (if ((block_12: {
        break :block_12 value_1;
    }).negative) ((block_13: {
        break :block_13 value_1;
    }).integer > (block_14: {
        break :block_14 value_2;
    }).integer) else ((block_15: {
        break :block_15 value_1;
    }).integer < (block_16: {
        break :block_16 value_2;
    }).integer)));

    return block_8: {
        const operand_1 = (in).operator;

        break :block_8 switch (operand_1) { @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less) => block_7: {
            break :block_7 value_4;
        }, @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual) => (block_5: {
            break :block_5 value_4;
        } or block_6: {
            break :block_6 value_3;
        }), else => (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) ((!block_3: {
            break :block_3 value_4;
        }) and (!block_4: {
            break :block_4 value_3;
        })) else (!block_2: {
            break :block_2 value_4;
        })), };
    };
}
