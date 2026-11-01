const std = @import("std");
const zx_native_0 = @import("zxc_string");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .string, };
const zx_shape_1 = .{ .kind = .list, .child = zx_shape_0, };
const zx_shape_2 = .{ .kind = .object, .fields = .{ .declarations = zx_shape_1, .definitions = zx_shape_0, .precondition = zx_shape_0, .violations = zx_shape_1, }, };
const zx_shape_3 = .{ .kind = .object, .fields = .{ .correctness = zx_shape_0, .feasibility = zx_shape_0, }, };
pub const input_shape = zx_shape_2;
pub const output_shape = zx_shape_3;
pub const Input = *const (zx_abi).zx_type_14;
pub const Output = *const (zx_abi).zx_type_15;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = (try function_1(allocator, (in).declarations));
    const value_2: []const u8 = (try function_4(allocator, (in).violations));

    const value_3: []const u8 = block_15: {
        const operand_11 = value_1;
        const operand_12 = (in).definitions;
        const operand_13 = (in).precondition;
        const operand_14 = (zx_abi).zx_type_13{ .declarations = operand_11, .definitions = operand_12, .predicate = operand_13, };

        break :block_15 (try function_3(allocator, (&operand_14)));
    };

    const value_4: []const u8 = value_3;

    const value_5: []const u8 = block_10: {
        const operand_6 = value_1;
        const operand_7 = (in).definitions;
        const operand_8 = value_2;
        const operand_9 = (zx_abi).zx_type_13{ .declarations = operand_6, .definitions = operand_7, .predicate = operand_8, };

        break :block_10 (try function_3(allocator, (&operand_9)));
    };

    const value_6: []const u8 = value_5;

    return block_5: {
        const operand_1 = value_4;
        const operand_2 = value_6;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_3).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .feasibility = operand_1, .correctness = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_15, operand_3);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!*const (zx_abi).zx_type_15 {
    return executeIn((arena).allocator(), in);
}

pub fn executeValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ OutOfMemory, }!(zx_abi).value_cb929cbbf54709d9a77fce4d10fbf4e30b3c63200b125165520e116bb77c733a {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_39: {
        const operand_38 = (in).declarations;

        break :block_39 (try function_1(allocator, operand_38));
    };

    const value_2: []const u8 = block_37: {
        const operand_36 = (in).violations;

        break :block_37 (try function_4(allocator, operand_36));
    };

    const value_3: []const u8 = block_35: {
        const operand_31 = block_30: {
            break :block_30 value_1;
        };

        const operand_32 = (in).definitions;
        const operand_33 = (in).precondition;
        const operand_34 = (zx_abi).zx_type_13{ .declarations = operand_31, .definitions = operand_32, .predicate = operand_33, };

        break :block_35 (try function_3(allocator, (&operand_34)));
    };

    const value_4: []const u8 = block_29: {
        break :block_29 value_3;
    };

    const value_5: []const u8 = block_28: {
        const operand_23 = block_22: {
            break :block_22 value_1;
        };

        const operand_24 = (in).definitions;

        const operand_26 = block_25: {
            break :block_25 value_2;
        };

        const operand_27 = (zx_abi).zx_type_13{ .declarations = operand_23, .definitions = operand_24, .predicate = operand_26, };

        break :block_28 (try function_3(allocator, (&operand_27)));
    };

    const value_6: []const u8 = block_21: {
        break :block_21 value_5;
    };

    return block_20: {
        const operand_16 = block_17: {
            break :block_17 value_4;
        };

        const operand_18 = block_19: {
            break :block_19 value_6;
        };

        break :block_20 @as((zx_abi).value_cb929cbbf54709d9a77fce4d10fbf4e30b3c63200b125165520e116bb77c733a, (zx_abi).value_cb929cbbf54709d9a77fce4d10fbf4e30b3c63200b125165520e116bb77c733a{ .feasibility = operand_16, .correctness = operand_18, });
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ OutOfMemory, }![]const u8 {
    @setRuntimeSafety(true);

    return block_8: {
        const operand_1 = @as([]const u8, "(set-logic QF_BV)\n(set-option :produce-models true)\n(set-option :timeout 10000)\n");
        const operand_2 = (in).declarations;
        const operand_3 = @as([]const u8, "\n");
        const operand_4 = (in).definitions;
        const operand_5 = @as([]const u8, "\n(assert ");
        const operand_6 = (in).predicate;
        const operand_7 = @as([]const u8, ")\n(check-sat)\n");

        break :block_8 (try ((std).mem).concat(allocator, u8, (&[_][]const u8{operand_1, operand_2, operand_3, operand_4, operand_5, operand_6, operand_7, })));
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: []const []const u8) error{ OutOfMemory, }![]const u8 {
    @setRuntimeSafety(true);

    const switch_1 = (@as(u64, (in).len) == @as(u64, 0));

    if ((switch_1 == true)) {
        return @as([]const u8, "false");
    } else {
        const value_1: []const u8 = (try function_2(allocator, in));

        return value_1;
    }
}

fn function_1(allocator: ((std).mem).Allocator, in: []const []const u8) error{ OutOfMemory, }![]const u8 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_4 = @as((zx_abi).zx_type_12, block_3: {
            const operand_1 = @as([]const u8, "\n");
            const operand_2 = in;

            break :block_3 .{ operand_1, operand_2, };
        });

        break :block_5 (try function_0(allocator, (&operand_4)));
    };
}

fn function_2(allocator: ((std).mem).Allocator, in: []const []const u8) error{ OutOfMemory, }![]const u8 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = block_9: {
        const operand_8 = @as((zx_abi).zx_type_12, block_7: {
            const operand_5 = @as([]const u8, " ");
            const operand_6 = in;

            break :block_7 .{ operand_5, operand_6, };
        });

        break :block_9 (try function_0(allocator, (&operand_8)));
    };

    return block_4: {
        const operand_1 = @as([]const u8, "(or ");
        const operand_2 = value_1;
        const operand_3 = @as([]const u8, ")");

        break :block_4 (try ((std).mem).concat(allocator, u8, (&[_][]const u8{operand_1, operand_2, operand_3, })));
    };
}

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }![]const u8 {
    const native_result = (try (zx_native_0).join(allocator, (in).@"0", (in).@"1"));

    return native_result;
}

