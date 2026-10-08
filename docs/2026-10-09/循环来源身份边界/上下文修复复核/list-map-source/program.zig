const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c66e6df860adac873dcd6b04506ccbafe5594eb34ad2d48352f9e62c139aab85;
pub const Output = []const i64;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_7, .@"1" = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .context = zx_shape_11, .items = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .captures = zx_shape_14, .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c66e6df860adac873dcd6b04506ccbafe5594eb34ad2d48352f9e62c139aab85) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, Overflow, }![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: []const i64 = (try (@import("zxc_module_6952b2c59aaf79778922fdd8eb0044481237298c434e6d09b7d52fe2a08bc34b")).call(allocator, (in).context));

    return block_38: {
        const value_4: []const i64 = (in).items;

        break :block_38 block_37: {
            const operand_12 = block_11: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(i64, (&[_]i64{})));
                };
                const operand_6 = block_10: {
                    const operand_7 = value_1;

                    break :block_10 block_9: {
                        const operand_8 = (try (allocator).create((zx_abi).zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9));

                        (operand_8).* = @as((zx_abi).zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9, .{ operand_7, });

                        break :block_9 @as(*const (zx_abi).zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9, operand_8);
                    };
                };

                break :block_11 (zx_abi).zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6{ .captures = operand_6, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_13: (std).ArrayList(i64) = .empty;
            var state_capacity_started_14 = false;

            defer (state_capacity_13).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813 = (zx_abi).value_zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813{ .captures = @as((zx_abi).value_zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, .{ ((operand_12).captures).@"0", (operand_12).captures, }), .index = (operand_12).index, .result = (operand_12).result, .source = (operand_12).source, .zx_origin = (&operand_12), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_35: {
                    const value_7: i64 = block_34: {
                        const operand_32 = (state_1).source;
                        const operand_33 = (state_1).index;

                        if ((operand_33 >= (operand_32).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_34 (operand_32)[@intCast(operand_33)];
                    };

                    const value_3: []const i64 = ((state_1).captures).@"0";

                    const value_2: i64 = block_31: {
                        break :block_31 value_7;
                    };
                    const value_8: i64 = block_30: {
                        const operand_29 = @as((zx_abi).zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c, block_28: {
                            const operand_25 = block_24: {
                                break :block_24 value_2;
                            };
                            const operand_27 = block_26: {
                                break :block_26 value_3;
                            };

                            break :block_28 .{ operand_25, operand_27, };
                        });

                        break :block_30 (try (@import("zxc_module_ec2b674d76d414ae498bdd4a588d8b369016026f9fedb75d817d7977049ec73b")).call(allocator, (&operand_29)));
                    };

                    break :block_35 block_23: {
                        const operand_15 = (state_1).source;
                        const operand_16 = ((state_1).index + @as(u64, 1));

                        const operand_17 = (block_21: {
                            const operand_18 = (state_1).result;

                            const operand_20 = block_19: {
                                break :block_19 value_8;
                            };

                            _ = (try ((std).math).add(usize, (operand_18).len, 1));

                            if ((!state_capacity_started_14)) {
                                (try (state_capacity_13).ensureTotalCapacityPrecise(allocator, ((operand_12).source).len));
                                (try (state_capacity_13).appendSlice(allocator, operand_18));
                                state_capacity_started_14 = true;
                            } else {
                                ((state_capacity_13).items).len = (operand_18).len;
                            }

                            (try (state_capacity_13).append(allocator, operand_20));

                            break :block_21 @as((zx_abi).value_zx_type_6dc613f5d836d29f343ecd2a2d7cb4564750ac7abca6e702eb6d700f37c1d5d4_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_13).items, {}, null, });
                        }).@"0";

                        const operand_22 = (state_1).captures;

                        break :block_23 @as((zx_abi).value_zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813, (zx_abi).value_zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813{ .captures = operand_22, .index = operand_16, .result = operand_17, .source = operand_15, });
                    };
                };
            }

            var state_owned_36: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_36);

            if (state_capacity_started_14) {
                ((state_capacity_13).items).len = ((state_1).result).len;
                state_owned_36 = (try (state_capacity_13).toOwnedSlice(allocator));
            }

            if (state_capacity_started_14) {
                state_1 = (zx_abi).value_zx_type_7942d7fe9b4b747d1bd566285cb02f0a5b2f41b9f219a8ed44e6abc7c9d8fef6_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813{ .captures = (state_1).captures, .index = (state_1).index, .result = state_owned_36, .source = (state_1).source, };
            }

            break :block_37 (state_1).result;
        };
    };
}

