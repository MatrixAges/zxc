const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const u64;
pub const State = *const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9;
pub const Output = *const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9 = block_14: {
        const operand_10 = @as(u64, 0);
        const operand_11 = @as(u64, 0);

        break :block_14 block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9));

            (operand_12).* = @as((zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9, (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9{ .count = operand_10, .total = operand_11, });

            break :block_13 @as(*const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9, operand_12);
        };
    };

    return block_9: {
        const operand_1 = in;
        const operand_2 = value_1;
        var value_2: (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9 = (operand_2).*;
        var state_changed_3 = false;

        for (operand_1) |value_3| {
            value_2 = block_6: {
                const operand_4 = ((value_2).count + @as(u64, 1));
                const operand_5 = ((value_2).total + value_3);

                break :block_6 (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9{ .count = operand_4, .total = operand_5, };
            };

            state_changed_3 = true;
        }

        break :block_9 (if (state_changed_3) block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9));

            (operand_7).* = @as((zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9, value_2);

            break :block_8 @as(*const (zx_abi).zx_type_0b437dd4fa0e9bf589473e2622f15de26c2034bfa1240e798b808ee0bb7e6cb9, operand_7);
        } else operand_2);
    };
}

