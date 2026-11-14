const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_19: {
        const operand_17 = (((in).input).expressions).kinds;
        const operand_18 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

        if ((operand_18 >= (operand_17).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_19 (operand_17)[@intCast(operand_18)];
    };

    if (((block_14: {
        break :block_14 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_15: {
        break :block_15 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)))) {
        return block_16: {
            break :block_16 (try (@import("zxc_module_d091a2c13fd58458ee549ed30219dfc43970426e2baf9c4e964bf91640c2d20b.zig")).callValue(allocator, in));
        };
    }

    if ((block_12: {
        break :block_12 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) {
        return block_13: {
            break :block_13 (try (@import("zxc_module_3df70753f3f82078be9d4a2f1fb21880dbc76f447ff5787a09fb6f773a90fe1c.zig")).callValue(allocator, in));
        };
    }

    if ((block_10: {
        break :block_10 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) {
        return block_11: {
            break :block_11 (try (@import("zxc_module_2eacaec8fc1c63e7e74aae76ee97843ce718a6d309b7cff5b0e6631ea16f3591.zig")).callValue(allocator, in));
        };
    }

    return block_9: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);

        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_7: {
            break :block_7 (try (@import("zxc_module_cf64de78638ac75e2cfa08d887799a00f788ef839699255831589bc118a1e950.zig")).callValue(allocator, block_6: {
                const operand_4 = (in).input;
                const operand_5 = ((in).frame).id;

                break :block_6 @as((zx_abi).value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe, (zx_abi).value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe{ .input = operand_4, .id = operand_5, });
            }));
        });

        const operand_8 = @as([]const u8, "");

        break :block_9 @as((zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b, (zx_abi).value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_8, });
    };
}
