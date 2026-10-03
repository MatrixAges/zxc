const std = @import("std");
const runtime = @import("zx_runtime");

const zx_type_12 = struct {
    enabled: bool,
    score: f64,
    status: []const u8,
    weights: []const f64,
};

const zx_type_13 = struct {
    grade: []const u8,
    ready: bool,
    score: f64,
};

pub const Input = zx_type_12;
pub const Output = zx_type_13;

pub fn execute(arena: *(runtime).Arena, in: zx_type_12) anyerror!zx_type_13 {
    @setRuntimeSafety(true);

    _ = arena;

    const value_1: []const u8 = (if (((in).enabled and ((in).score >= @as(f64, @as(f64, @bitCast(@as(u64, 4636033603912859648))))))) @as([]const u8, "A") else (if ((((in).score >= @as(f64, @as(f64, @bitCast(@as(u64, 4633641066610819072))))) and ((in).score < @as(f64, @as(f64, @bitCast(@as(u64, 4636033603912859648))))))) @as([]const u8, "B") else @as([]const u8, "C")));

    const value_2: bool = block_10: {
        const operand_9 = (in).status;

        break :block_10 (if ((runtime).equal([]const u8, operand_9, @as([]const u8, "paid"))) true else false);
    };

    const value_5: f64 = block_8: {
        const operand_5 = @as(u64, ((in).weights).len);

        break :block_8 (if ((operand_5 == @as(u64, 0))) (in).score else block_7: {
            const operand_6 = (in).weights;
            var value_3: f64 = @as(f64, @as(f64, @bitCast(@as(u64, 0))));

            for (operand_6) |value_4| {
                value_3 = (value_3 + value_4);
            }

            break :block_7 value_3;
        });
    };

    return block_4: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_5;

        break :block_4 zx_type_13{ .grade = operand_1, .ready = operand_2, .score = operand_3, };
    };
}

