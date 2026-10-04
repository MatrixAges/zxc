const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending = zx_pending{ .store_0 = null, };

    (pending).store_0 = block_9: {
        const operand_5 = ((pending).store_0 orelse ((context).store_0).*);
        const operand_6 = ((((pending).store_0 orelse ((context).store_0).*)).count + (in).increment);

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6));

            (operand_7).* = @as((zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6, (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6{ .count = operand_6, .items = (operand_5).items, });

            break :block_8 @as(*const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6, operand_7);
        };
    };

    const output_4 = (block_3: {
        const operand_1 = (((pending).store_0 orelse ((context).store_0).*)).items;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } + (((pending).store_0 orelse ((context).store_0).*)).count);

    (try (context).commit(pending));

    return output_4;
}

