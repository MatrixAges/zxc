const std = @import("std");

const zx_type_12 = struct {
    primary: []const u64,
    secondary: []const u64,
};

const zx_type_13 = struct { []const u64, void, };
pub const Input = []const u64;
pub const State = *const zx_type_12;
pub const Output = *const zx_type_12;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u64 = block_29: {
        break :block_29 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_2: []const u64 = block_28: {
        break :block_28 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_3: *const zx_type_12 = block_27: {
        const operand_23 = value_1;
        const operand_24 = value_2;

        break :block_27 block_26: {
            const operand_25 = (try (allocator).create(zx_type_12));

            (operand_25).* = @as(zx_type_12, zx_type_12{ .primary = operand_23, .secondary = operand_24, });

            break :block_26 @as(*const zx_type_12, operand_25);
        };
    };

    return block_22: {
        const operand_1 = in;
        const operand_2 = value_3;
        var value_4: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;
        var field_items_4: (std).ArrayList(u64) = .empty;
        var field_started_5 = false;

        defer (field_items_4).deinit(allocator);

        var field_items_6: (std).ArrayList(u64) = .empty;
        var field_started_7 = false;

        defer (field_items_6).deinit(allocator);

        for (operand_1) |value_5| {
            if ((value_5 == @as(u64, 0))) {
            } else {
                value_4 = block_19: {
                    const operand_8 = block_11: {
                        const operand_9 = (value_4).primary;
                        const operand_10 = value_5;

                        _ = (try ((std).math).add(usize, (operand_9).len, 1));

                        if ((!field_started_5)) {
                            (try (field_items_4).appendSlice(allocator, operand_9));
                            field_started_5 = true;
                        }

                        (try (field_items_4).append(allocator, operand_10));

                        break :block_11 (field_items_4).items;
                    };
                    const operand_12 = block_18: {
                        const operand_13 = (value_4).secondary;

                        const operand_17 = block_16: {
                            const operand_14 = value_5;
                            const operand_15 = (value_5 + @as(u64, 1));

                            break :block_16 (try (allocator).dupe(u64, (&[_]u64{operand_14, operand_15, })));
                        };

                        _ = (try ((std).math).add(usize, (operand_13).len, (operand_17).len));

                        if ((!field_started_7)) {
                            (try (field_items_6).appendSlice(allocator, operand_13));
                            field_started_7 = true;
                        }

                        (try (field_items_6).appendSlice(allocator, operand_17));

                        break :block_18 (field_items_6).items;
                    };

                    break :block_19 zx_type_12{ .primary = operand_8, .secondary = operand_12, };
                };

                state_changed_3 = true;
            }
        }

        if (field_started_5) {
            (value_4).primary = (try (field_items_4).toOwnedSlice(allocator));
        }

        if (field_started_7) {
            (value_4).secondary = (try (field_items_6).toOwnedSlice(allocator));
        }

        break :block_22 (if (state_changed_3) block_21: {
            const operand_20 = (try (allocator).create(zx_type_12));

            (operand_20).* = @as(zx_type_12, value_4);

            break :block_21 @as(*const zx_type_12, operand_20);
        } else operand_2);
    };
}

