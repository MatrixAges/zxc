const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2) error{ }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = ((in).left).*;
    const value_2: (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = ((in).right).*;

    if ((((&value_1)).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) {
        return block_9: {
            const operand_8 = (in).operator;

            break :block_9 (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal))) (((&value_1)).floating == ((&value_2)).floating) else (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual))) (((&value_1)).floating != ((&value_2)).floating) else (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less))) (((&value_1)).floating < ((&value_2)).floating) else (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual))) (((&value_1)).floating <= ((&value_2)).floating) else (if ((operand_8 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) (((&value_1)).floating > ((&value_2)).floating) else (((&value_1)).floating >= ((&value_2)).floating))))));
        };
    }

    const value_3: bool = block_7: {
        const operand_3 = ((&value_1)).kind;

        break :block_7 (if ((operand_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean))) (((&value_1)).boolean == ((&value_2)).boolean) else (if ((operand_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) block_6: {
            const operand_4 = ((&value_1)).text;
            const operand_5 = ((&value_2)).text;

            break :block_6 ((std).mem).eql(u8, operand_4, operand_5);
        } else (if ((operand_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue))) (((&value_1)).enumeration == ((&value_2)).enumeration) else ((((&value_1)).negative == ((&value_2)).negative) and (((&value_1)).integer == ((&value_2)).integer)))));
    };

    if ((((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal)) or ((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .NotEqual)))) {
        return (if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Equal))) value_3 else (!value_3));
    }

    const value_4: bool = (if ((((&value_1)).negative != ((&value_2)).negative)) ((&value_1)).negative else (if (((&value_1)).negative) (((&value_1)).integer > ((&value_2)).integer) else (((&value_1)).integer < ((&value_2)).integer)));

    return block_2: {
        const operand_1 = (in).operator;

        break :block_2 (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Less))) value_4 else (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LessEqual))) (value_4 or value_3) else (if ((operand_1 == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Greater))) ((!value_4) and (!value_3)) else (!value_4))));
    };
}

