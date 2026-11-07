const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 {
    @setRuntimeSafety(true);

    var state_reference_6: (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = undefined;

    const value_1: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = block_18: {
        break :block_18 (try (@import("zxc_module_3ac4a84bb2e2037608cd4cdfbec9d613703b961787dbb51ae1ff48dc84ca4be6.zig")).callValue(allocator, in));
    };

    const value_2: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = block_17: {
        break :block_17 (try (@import("zxc_module_d3f8fecc25e1f582cd1a2c93110fb8c8d47e40368554c34b8e0b21a24d7975e3.zig")).callValue(allocator, value_1));
    };

    const value_3: u64 = block_16: {
        const operand_11 = in;
        const operand_12 = value_2;
        const operand_13 = (operand_12).items;

        const operand_14 = (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
            .items = operand_13,
            .storage = .plain,
        };

        const operand_15 = (zx_abi).zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5{
            .graph = operand_11,
            .closures = (operand_14).items,
        };

        break :block_16 (try (@import("zxc_module_b9b664032f72b77b2ba04e3f70d34245c07f8de18fa99aa797e100f12df1cac1.zig")).call(allocator, (&operand_15)));
    };

    const value_4: (zx_abi).value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602 = block_10: {
        break :block_10 (try (@import("zxc_module_f40e89d7436fda076e75df54d1ca62177298b4a3bd34dcfb14b0d3af133897c0.zig")).callValue(allocator, in));
    };

    const value_5: (zx_abi).value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 = block_9: {
        break :block_9 (try (@import("zxc_module_15706c27dce06ca30536bf9c768200bb0d326a6eb0175d2e9598fded7c868355.zig")).callValue(allocator, block_8: {
            const operand_1 = value_2;
            const operand_2 = value_4;

            const operand_3 = (zx_abi).value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e{
                .items = (in).sizes,
                .storage = .plain,
            };

            const operand_4 = block_5: {
                break :block_5 value_3;
            };

            break :block_8 block_7: {
                state_reference_6 = @as((zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447, (zx_abi).value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447{
                    .closures = operand_1,
                    .groups = operand_2,
                    .weights = operand_3,
                    .capacity = operand_4,
                });

                break :block_7 (&state_reference_6);
            };
        }));
    };

    return value_5;
}
