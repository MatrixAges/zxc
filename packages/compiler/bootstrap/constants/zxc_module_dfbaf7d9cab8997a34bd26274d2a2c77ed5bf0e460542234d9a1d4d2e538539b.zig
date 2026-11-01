const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d {
    @setRuntimeSafety(true);

    const value_8: []const ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_47: {
        const value_2: []const (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = ((in).expressions).kinds;

        break :block_47 block_46: {
            const operand_31 = block_30: {
                const operand_25 = block_26: {
                    break :block_26 value_2;
                };

                const operand_27 = @as(u64, 0);

                const operand_28 = block_29: {
                    break :block_29 (try (allocator).dupe(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (&[_]?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{})));
                };

                break :block_30 @as((zx_abi).value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f, (zx_abi).value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f{ .index = operand_27, .result = operand_28, .source = operand_25, });
            };

            var state_24: (zx_abi).value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f = operand_31;

            while (((state_24).index < @as(u64, ((state_24).source).len))) {
                state_24 = block_45: {
                    _ = block_44: {
                        const operand_42 = (state_24).source;
                        const operand_43 = (state_24).index;

                        if ((operand_43 >= (operand_42).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_44 (operand_42)[@intCast(operand_43)];
                    };

                    const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);

                    break :block_45 block_41: {
                        const operand_32 = (state_24).source;
                        const operand_33 = ((state_24).index + @as(u64, 1));

                        const operand_34 = (block_40: {
                            const operand_35 = (state_24).result;

                            const operand_37 = block_36: {
                                break :block_36 value_6;
                            };

                            const operand_38 = (try ((std).math).add(usize, (operand_35).len, 1));
                            const operand_39 = (try (zx_abi).zxReserve(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, allocator, operand_35, operand_38, true));
                            (operand_39)[(operand_35).len] = operand_37;

                            break :block_40 @as((zx_abi).value_2fdd31a48200da7b4f90c5db0ca77d0a396a00a7f3c75d8daf1eeac2e8c6b87b, .{ operand_39, {}, null, });
                        }).@"0";

                        break :block_41 @as((zx_abi).value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f, (zx_abi).value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f{ .index = operand_33, .result = operand_34, .source = operand_32, });
                    };
                };
            }

            break :block_46 (state_24).result;
        };
    };

    return block_23: {
        const operand_1 = block_11: {
            const operand_9 = block_8: {
                const operand_7 = block_6: {
                    const operand_2 = (in).root;
                    const operand_3 = @as(u64, 0);

                    break :block_6 block_5: {
                        const operand_4 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                        (operand_4).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_2, .arm = operand_3, });

                        break :block_5 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_4);
                    };
                };

                break :block_8 (try (allocator).dupe(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (&[_]*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{operand_7, })));
            };

            const operand_10 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, allocator, operand_9, (operand_9).len, false));

            break :block_11 operand_10;
        };

        const operand_12 = block_13: {
            break :block_13 value_8;
        };
        const operand_14 = block_19: {
            const operand_15 = @as([]const u8, "");
            const operand_16 = @as(u64, 0);
            const operand_17 = @as(u64, 0);
            const operand_18 = @as([]const u8, "");

            break :block_19 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_15, .start = operand_16, .end = operand_17, .message = operand_18, });
        };

        break :block_23 @as((zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d{ .frames = block_22: {
            const operand_20 = operand_1;
            const operand_21 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, allocator, operand_20, (operand_20).len, false));

            break :block_22 operand_21;
        }, .values = operand_12, .diagnostic = operand_14, });
    };
}

