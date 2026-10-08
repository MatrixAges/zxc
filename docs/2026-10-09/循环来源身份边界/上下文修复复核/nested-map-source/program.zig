const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .active = zx_shape_1, .left = zx_shape_11, .right = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_7, .@"1" = zx_shape_12, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .context = zx_shape_12, .items = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .captures = zx_shape_15, .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, Overflow, }![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3 = (try (@import("zxc_module_6952b2c59aaf79778922fdd8eb0044481237298c434e6d09b7d52fe2a08bc34b")).call(allocator, (in).context));

    return block_34: {
        const value_4: []const i64 = (in).items;

        break :block_34 block_33: {
            const operand_12 = block_11: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(i64, (&[_]i64{})));
                };
                const operand_6 = block_10: {
                    const operand_7 = value_1;

                    break :block_10 block_9: {
                        const operand_8 = (try (allocator).create((zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6));

                        (operand_8).* = @as((zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6, .{ operand_7, });

                        break :block_9 @as(*const (zx_abi).zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6, operand_8);
                    };
                };

                break :block_11 (zx_abi).zx_type_219c47f68f54b4b562110ca641cb83c688afe8265afab486d36f1fda5a0b20c0{ .captures = operand_6, .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_13: (std).ArrayList(i64) = .empty;
            var state_capacity_started_14 = false;

            defer (state_capacity_13).deinit(allocator);

            var state_1: (zx_abi).zx_type_219c47f68f54b4b562110ca641cb83c688afe8265afab486d36f1fda5a0b20c0 = operand_12;

            while ((((&state_1)).index < @as(u64, (((&state_1)).source).len))) {
                state_1 = block_31: {
                    const value_7: i64 = block_30: {
                        const operand_28 = ((&state_1)).source;
                        const operand_29 = ((&state_1)).index;

                        if ((operand_29 >= (operand_28).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_30 (operand_28)[@intCast(operand_29)];
                    };

                    const value_3: *const (zx_abi).zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3 = (((&state_1)).captures).@"0";
                    const value_2: i64 = value_7;
                    const value_8: i64 = block_27: {
                        const operand_26 = @as((zx_abi).zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3, block_25: {
                            const operand_23 = value_2;
                            const operand_24 = value_3;

                            break :block_25 .{ operand_23, operand_24, };
                        });

                        break :block_27 (try (@import("zxc_module_ec2b674d76d414ae498bdd4a588d8b369016026f9fedb75d817d7977049ec73b")).call(allocator, (&operand_26)));
                    };

                    break :block_31 block_22: {
                        const operand_15 = ((&state_1)).source;
                        const operand_16 = (((&state_1)).index + @as(u64, 1));

                        const operand_17 = (block_20: {
                            const operand_18 = ((&state_1)).result;
                            const operand_19 = value_8;
                            _ = (try ((std).math).add(usize, (operand_18).len, 1));

                            if ((!state_capacity_started_14)) {
                                (try (state_capacity_13).ensureTotalCapacityPrecise(allocator, ((operand_12).source).len));
                                (try (state_capacity_13).appendSlice(allocator, operand_18));
                                state_capacity_started_14 = true;
                            } else {
                                ((state_capacity_13).items).len = (operand_18).len;
                            }

                            (try (state_capacity_13).append(allocator, operand_19));

                            break :block_20 @as((zx_abi).zx_type_6dc613f5d836d29f343ecd2a2d7cb4564750ac7abca6e702eb6d700f37c1d5d4, .{ (state_capacity_13).items, {}, });
                        }).@"0";

                        const operand_21 = ((&state_1)).captures;

                        break :block_22 (zx_abi).zx_type_219c47f68f54b4b562110ca641cb83c688afe8265afab486d36f1fda5a0b20c0{ .captures = operand_21, .index = operand_16, .result = operand_17, .source = operand_15, };
                    };
                };
            }

            var state_owned_32: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_32);

            if (state_capacity_started_14) {
                ((state_capacity_13).items).len = ((state_1).result).len;
                state_owned_32 = (try (state_capacity_13).toOwnedSlice(allocator));
            }

            if (state_capacity_started_14) {
                state_1 = (zx_abi).zx_type_219c47f68f54b4b562110ca641cb83c688afe8265afab486d36f1fda5a0b20c0{ .captures = (state_1).captures, .index = (state_1).index, .result = state_owned_32, .source = (state_1).source, };
            }

            break :block_33 (state_1).result;
        };
    };
}

