const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990) error{ IntegerOverflow, OutOfMemory, }!*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_14: {
        const operand_11 = (in).specifiers;
        const operand_12 = (try (allocator).alloc(u64, (operand_11).len));

        for (operand_11, 0..) |_, index_13| {
            (operand_12)[index_13] = @as(u64, 0);
        }

        break :block_14 operand_12;
    };

    const value_4: []const u32 = block_10: {
        const operand_7 = (in).specifiers;
        const operand_8 = (try (allocator).alloc(u32, (operand_7).len));

        for (operand_7, 0..) |_, index_9| {
            (operand_8)[index_9] = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, @as(u64, 0)));
        }

        break :block_10 operand_8;
    };

    return block_6: {
        const operand_1 = value_2;
        const operand_2 = value_4;
        const operand_3 = @as(u64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add));

            (operand_4).* = @as((zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .mapping = operand_1, .order = operand_2, .count = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, operand_4);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990) error{ IntegerOverflow, OutOfMemory, }!(zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add {
    @setRuntimeSafety(true);

    const value_2: []const u64 = block_26: {
        const operand_23 = (in).specifiers;
        const operand_24 = (try (allocator).alloc(u64, (operand_23).len));

        for (operand_23, 0..) |_, index_25| {
            (operand_24)[index_25] = @as(u64, 0);
        }

        break :block_26 operand_24;
    };

    const value_4: []const u32 = block_22: {
        const operand_19 = (in).specifiers;
        const operand_20 = (try (allocator).alloc(u32, (operand_19).len));

        for (operand_19, 0..) |_, index_21| {
            (operand_20)[index_21] = (try (@import("zxc_module_e26f316dbaffbd004e94ada680b7f0deab9d8578f54ffddbc5e76698632cfaa9")).call(allocator, @as(u64, 0)));
        }

        break :block_22 operand_20;
    };

    return block_18: {
        const operand_15 = value_2;
        const operand_16 = value_4;
        const operand_17 = @as(u64, 0);

        break :block_18 (zx_abi).zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add{ .mapping = operand_15, .order = operand_16, .count = operand_17, };
    };
}

