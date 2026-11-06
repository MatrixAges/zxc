const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3 = block_51: {
        const value_2: (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080 = (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080{ .items = ((in).expressions).kinds, .storage = .plain, };

        break :block_51 block_50: {
            const operand_25 = block_24: {
                const operand_20 = value_2;
                const operand_21 = @as(u64, 0);

                const operand_22 = block_23: {
                    break :block_23 (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3{ .items = (&[_]?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{}), .storage = .plain, };
                };

                break :block_24 @as((zx_abi).value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed, (zx_abi).value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed{ .index = operand_21, .result = operand_22, .source = operand_20, });
            };
            const loop_fields_27 = struct {
                index: u64,
                result: (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3,
                source: *const (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080,
                zx_origin: ?*const (zx_abi).zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
            };

            const loop_seed_26: (zx_abi).value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed = operand_25;

            break :block_50 (if (((loop_seed_26).index < @as(u64, (((loop_seed_26).source).items).len))) block_48: {
                var qualified_44: (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080 = (loop_seed_26).source;

                (qualified_44).storage = (if ((@intFromEnum((qualified_44).storage) >= 2)) .shared else .plain);
                const operand_45 = (zx_abi).value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed{ .index = (loop_seed_26).index, .result = (loop_seed_26).result, .source = qualified_44, .zx_origin = (loop_seed_26).zx_origin, };
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

                                break :block_37 @as((zx_abi).value_13356d39ddf3177e39325fb4aa979982608a3684af70f02e17d123aa2f8b3283, .{ block_36: {
                                    const operand_35 = (try (zx_abi).zxReserveBounded(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, allocator, (operand_31).items, operand_34, (((loop_seed_26).source).items).len));
                                    (operand_35)[((operand_31).items).len] = operand_33;

                                    break :block_36 (zx_abi).value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3{ .items = operand_35, .storage = (if (((((operand_31).items).len == 0) or ((operand_31).storage == .exclusive))) .exclusive else .shared), };
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

                const operand_47 = (zx_abi).value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed{ .index = (state_19).index, .result = (state_19).result, .source = ((state_19).source).*, .zx_origin = (state_19).zx_origin, };

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

            break :block_10 (zx_abi).value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11{ .items = (try (allocator).dupe(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (&[_]*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{operand_9, }))), .storage = .plain, };
        };

        const operand_11 = value_8;

        const operand_12 = block_17: {
            const operand_13 = @as([]const u8, "");
            const operand_14 = @as(u64, 0);
            const operand_15 = @as(u64, 0);
            const operand_16 = @as([]const u8, "");

            break :block_17 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_13, .start = operand_14, .end = operand_15, .message = operand_16, });
        };

        break :block_18 @as((zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3{ .frames = operand_1, .values = operand_11, .diagnostic = operand_12, });
    };
}

