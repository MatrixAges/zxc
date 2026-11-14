const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db = block_51: {
        const value_2: (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560 = (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560{ .items = ((in).expressions).kinds, .storage = .plain, };

        break :block_51 block_50: {
            const operand_25 = block_24: {
                const operand_20 = value_2;
                const operand_21 = @as(u64, 0);

                const operand_22 = block_23: {
                    break :block_23 (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db{ .items = (&[_]?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{}), .storage = .plain, };
                };

                break :block_24 @as((zx_abi).value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176, (zx_abi).value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176{ .index = operand_21, .result = operand_22, .source = operand_20, });
            };
            const loop_fields_27 = struct {
                index: u64,
                result: (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db,
                source: *const (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560,
                zx_origin: ?*const (zx_abi).zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
            };

            const loop_seed_26: (zx_abi).value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176 = operand_25;

            break :block_50 (if (((loop_seed_26).index < @as(u64, (((loop_seed_26).source).items).len))) block_48: {
                var qualified_44: (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560 = (loop_seed_26).source;

                (qualified_44).storage = (if ((@intFromEnum((qualified_44).storage) >= 2)) .shared else .plain);
                const operand_45 = (zx_abi).value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176{ .index = (loop_seed_26).index, .result = (loop_seed_26).result, .source = qualified_44, .zx_origin = (loop_seed_26).zx_origin, };
                var state_19: loop_fields_27 = loop_fields_27{ .index = (operand_45).index, .result = (operand_45).result, .source = (&(operand_45).source), .zx_origin = (operand_45).zx_origin, };

                while (true) {
                    const operand_46 = block_43: {
                        _ = block_42: {
                            const operand_40 = (((state_19).source).*).items;
                            const operand_41 = (state_19).index;

                            if ((operand_41 >= (operand_40).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_42 (operand_40)[@intCast(operand_41)];
                        };

                        const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);

                        break :block_43 block_39: {
                            const operand_28 = ((state_19).source).*;
                            const operand_29 = ((state_19).index + @as(u64, 1));
                            const operand_30 = (block_37: {
                                const operand_31 = (state_19).result;

                                const operand_33 = block_32: {
                                    break :block_32 value_6;
                                };

                                const operand_34 = (try ((std).math).add(usize, ((operand_31).items).len, 1));

                                break :block_37 @as((zx_abi).value_8e48239a6f4c2de4c5470242fd7bbf1672af768c61d6efd968c0d001656a0e0c, .{ block_36: {
                                    const operand_35 = (try (zx_abi).zxReserveBounded(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, allocator, (operand_31).items, operand_34, (((loop_seed_26).source).items).len));
                                    (operand_35)[((operand_31).items).len] = operand_33;

                                    break :block_36 (zx_abi).value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db{ .items = operand_35, .storage = (if ((((((operand_31).items).len == 0) or ((operand_35).ptr != ((operand_31).items).ptr)) or ((operand_31).storage == .exclusive))) .exclusive else .shared), };
                                }, {}, null, });
                            }).@"0";

                            break :block_39 loop_fields_27{ .index = operand_29, .result = operand_30, .source = block_38: {
                                _ = operand_28;

                                break :block_38 (&(loop_seed_26).source);
                            }, };
                        };
                    };

                    state_19 = loop_fields_27{ .index = (operand_46).index, .result = (operand_46).result, .source = (operand_46).source, .zx_origin = (operand_46).zx_origin, };

                    if ((!((state_19).index < @as(u64, ((((state_19).source).*).items).len)))) {
                        break;
                    }
                }

                const operand_47 = (zx_abi).value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176{ .index = (state_19).index, .result = (state_19).result, .source = ((state_19).source).*, .zx_origin = (state_19).zx_origin, };

                break :block_48 (operand_47).result;
            } else block_49: {
                break :block_49 (loop_seed_26).result;
            });
        };
    };

    return block_18: {
        const operand_1 = block_10: {
            const operand_9 = block_8: {
                const operand_2 = (in).root;
                const operand_3 = @as(u64, 0);
                const operand_4 = operand_2;
                const operand_5 = operand_3;

                break :block_8 block_7: {
                    const operand_6 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                    (operand_6).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_4, .arm = operand_5, });

                    break :block_7 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_6);
                };
            };

            break :block_10 (zx_abi).value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d{ .items = (try (allocator).dupe(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (&[_]*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{operand_9, }))), .storage = .plain, };
        };

        const operand_11 = value_8;

        const operand_12 = block_17: {
            const operand_13 = @as([]const u8, "");
            const operand_14 = @as(u64, 0);
            const operand_15 = @as(u64, 0);
            const operand_16 = @as([]const u8, "");

            break :block_17 @as((zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7{ .code = operand_13, .start = operand_14, .end = operand_15, .message = operand_16, });
        };

        break :block_18 @as((zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, (zx_abi).value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e{ .frames = operand_1, .values = operand_11, .diagnostic = operand_12, });
    };
}
