const std = @import("std");

const zx_type_11 = struct {
    kind: []const u8,
    value: i64,
};

const zx_type_12 = struct { i64, };
const zx_type_13 = struct { i64, i64, };
const zx_type_14 = struct { *const zx_type_11, };
const zx_type_15 = struct { *const zx_type_11, i64, };
const zx_type_16 = struct { *const zx_type_11, i64, i64, };
pub const Input = *const zx_type_11;
pub const Output = i64;

fn function_0(allocator: ((std).mem).Allocator, in: i64) anyerror!i64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_1(allocator: ((std).mem).Allocator, in: i64) anyerror!i64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in * @as(i64, 2));
}

fn function_2(allocator: ((std).mem).Allocator, in: i64) anyerror!i64 {
    @setRuntimeSafety(true);

    const value_1: i64 = (try function_1(allocator, in));

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) anyerror!i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: i64 = (try function_0(allocator, (in).value));
    const switch_1 = (in).kind;

    if (block_8: {
        const operand_6 = switch_1;
        const operand_7 = @as([]const u8, "double");

        break :block_8 ((std).mem).eql(u8, operand_6, operand_7);
    }) {
        const value_2: i64 = (try function_2(allocator, value_1));

        return value_2;
    } else {
        if (block_4: {
            const operand_2 = switch_1;
            const operand_3 = @as([]const u8, "absolute");

            break :block_4 ((std).mem).eql(u8, operand_2, operand_3);
        }) {
            const switch_5 = (value_1 < @as(i64, 0));

            if ((switch_5 == true)) {
                return (-value_1);
            } else {
                if ((switch_5 == false)) {
                    return value_1;
                } else {
                    unreachable;
                }
            }
        } else {
            return value_1;
        }
    }
}

