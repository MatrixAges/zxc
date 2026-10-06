const std = @import("std");
const zx_type_11 = enum { Value, Callable, TypeDecl, };

const zx_type_12 = struct {
    kind: zx_type_11,
    name: []const u8,
};

const zx_type_13 = struct {
    after_underscore: bool,
    index: u64,
    kind: zx_type_11,
    name: []const u8,
    valid: bool,
};

const zx_type_14 = struct { *const zx_type_12, };
const zx_type_15 = struct { *const zx_type_12, bool, };

const value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kind: zx_type_11,
    name: []const u8,
    zx_origin: ?*const zx_type_12 = null,
};

const value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    after_underscore: bool,
    index: u64,
    kind: zx_type_11,
    name: []const u8,
    valid: bool,
    zx_origin: ?*const zx_type_13 = null,
};

const value_zx_type_14_ed98ab2d684155f0f16edf3c906e8b7cce9beb0c415885713abde878f5ffabc6 = struct { value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_14, };
const value_zx_type_15_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac = struct { value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, bool, ?*const zx_type_15, };
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
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .kind = zx_shape_11, .name = zx_shape_10, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .after_underscore = zx_shape_1, .index = zx_shape_5, .kind = zx_shape_11, .name = zx_shape_10, .valid = zx_shape_1, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_1, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_1;
pub const Input = *const zx_type_12;
pub const Output = bool;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    if ((@as(u64, ((in).name).len) == @as(u64, 0))) {
        return false;
    }

    const value_1: u8 = block_42: {
        const operand_40 = (in).name;
        const operand_41 = @as(u64, 0);

        if ((operand_41 >= (operand_40).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_42 (operand_40)[@intCast(operand_41)];
    };

    const value_2: bool = (if (((in).kind == @as(zx_type_11, .TypeDecl))) ((value_1 >= @as(u8, 65)) and (value_1 <= @as(u8, 90))) else ((value_1 >= @as(u8, 97)) and (value_1 <= @as(u8, 122))));

    if ((!value_2)) {
        return false;
    }

    const value_30: zx_type_13 = block_39: {
        const operand_8 = block_7: {
            const operand_2 = (in).name;
            const operand_3 = (in).kind;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;
            const operand_6 = true;

            break :block_7 zx_type_13{ .name = operand_2, .kind = operand_3, .index = operand_4, .after_underscore = operand_5, .valid = operand_6, };
        };

        var state_1: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (operand_8).after_underscore, .index = (operand_8).index, .kind = (operand_8).kind, .name = (operand_8).name, .valid = (operand_8).valid, .zx_origin = (&operand_8), };

        while (((state_1).valid and ((state_1).index < @as(u64, ((state_1).name).len)))) {
            state_1 = block_36: {
                const value_5: u8 = block_35: {
                    const operand_33 = (state_1).name;
                    const operand_34 = (state_1).index;

                    if ((operand_34 >= (operand_33).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_35 (operand_33)[@intCast(operand_34)];
                };

                const value_6: bool = ((block_31: {
                    break :block_31 value_5;
                } >= @as(u8, 65)) and (block_32: {
                    break :block_32 value_5;
                } <= @as(u8, 90)));

                const value_7: bool = ((block_29: {
                    break :block_29 value_5;
                } >= @as(u8, 97)) and (block_30: {
                    break :block_30 value_5;
                } <= @as(u8, 122)));

                const value_8: bool = ((block_27: {
                    break :block_27 value_5;
                } >= @as(u8, 48)) and (block_28: {
                    break :block_28 value_5;
                } <= @as(u8, 57)));

                const value_25: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (if ((((state_1).kind == @as(zx_type_11, .Value)) and (block_12: {
                    break :block_12 value_5;
                } == @as(u8, 95)))) block_17: {
                    const value_9: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;
                    _ = (value_9).valid;

                    const value_11: bool = (!(state_1).after_underscore);

                    const value_12: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                        break :block_16 @as(value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_9).after_underscore, .index = (value_9).index, .kind = (value_9).kind, .name = (value_9).name, .valid = block_15: {
                            break :block_15 value_11;
                        }, });
                    };
                    const value_13: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;
                    _ = (value_13).after_underscore;
                    const value_15: bool = true;
                    const value_16: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_14: {
                        break :block_14 @as(value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = block_13: {
                            break :block_13 value_15;
                        }, .index = (value_13).index, .kind = (value_13).kind, .name = (value_13).name, .valid = (value_13).valid, });
                    };

                    break :block_17 value_16;
                } else block_26: {
                    const value_17: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_1;
                    _ = (value_17).valid;

                    const value_19: bool = (((block_22: {
                        break :block_22 value_6;
                    } or block_23: {
                        break :block_23 value_7;
                    }) or block_24: {
                        break :block_24 value_8;
                    }) and (((state_1).kind != @as(zx_type_11, .Value)) or (!block_25: {
                        break :block_25 value_6;
                    })));

                    const value_20: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_21: {
                        break :block_21 @as(value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_17).after_underscore, .index = (value_17).index, .kind = (value_17).kind, .name = (value_17).name, .valid = block_20: {
                            break :block_20 value_19;
                        }, });
                    };
                    const value_21: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_20;
                    _ = (value_21).after_underscore;
                    const value_23: bool = false;

                    const value_24: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_19: {
                        break :block_19 @as(value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = block_18: {
                            break :block_18 value_23;
                        }, .index = (value_21).index, .kind = (value_21).kind, .name = (value_21).name, .valid = (value_21).valid, });
                    };

                    break :block_26 value_24;
                });

                const value_26: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_25;
                const value_27: u64 = (value_26).index;
                const value_28: u64 = @as(u64, 1);

                const value_29: value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_11: {
                    break :block_11 @as(value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_13_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .after_underscore = (value_26).after_underscore, .index = (block_9: {
                        break :block_9 value_27;
                    } + block_10: {
                        break :block_10 value_28;
                    }), .kind = (value_26).kind, .name = (value_26).name, .valid = (value_26).valid, });
                };

                break :block_36 value_29;
            };
        }

        break :block_39 block_38: {
            break :block_38 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_37: {
                break :block_37 zx_type_13{ .after_underscore = (state_1).after_underscore, .index = (state_1).index, .kind = (state_1).kind, .name = (state_1).name, .valid = (state_1).valid, };
            });
        };
    };

    return (((&value_30)).valid and (!((&value_30)).after_underscore));
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: bool = (try function_0(allocator, in));

    return value_1;
}
