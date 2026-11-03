const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("lower.zig");
const Key = struct { negative: bool = false, value: u64 };
const Dense = std.StaticBitSet(@as(usize, std.math.maxInt(u8)) + 1);

pub fn constantLabels(self: *Lower, selection: ir.MatchRow) Lower.Error!bool {
    const subject = selection.subject orelse return false;

    if (selection.arms.len < 2) return false;

    const table = &self.program.expressions;
    const type_id = table.types[@backingInt(subject)];

    switch (self.program.typeOf(@fromBackingInt(type_id))) {
        .enumeration, .error_set => {},
        .scalar => |scalar| switch (scalar) {
            .void, .string, .f32, .f64 => return false,
            else => {},
        },
        else => return false,
    }

    var seen: std.AutoHashMapUnmanaged(Key, void) = .empty;
    var dense = Dense.empty;

    defer seen.deinit(self.allocator);

    for (0..selection.arms.len) |index| {
        const label = @backingInt(selection.arms.at(index).condition);

        if (table.types[label] != type_id) return false;

        const payload = table.payloads[label];

        const key: Key = switch (table.kinds[label]) {
            .Integer => .{ .value = table.integers[payload] },
            .NegativeInteger => .{ .negative = table.negative_integers[payload] != 0, .value = table.negative_integers[payload] },
            .Boolean => .{ .value = @intFromBool(table.booleans[payload]) },
            .EnumValue => .{ .value = table.enumerations[payload] },
            .ErrorValue => .{ .value = table.errors[payload] },
            else => return false,
        };

        if (!key.negative and key.value < Dense.bit_length) {
            const bit: usize = @intCast(key.value);

            if (dense.isSet(bit)) return false;

            dense.set(bit);
        } else if ((try seen.getOrPut(self.allocator, key)).found_existing) return false;
    }

    return true;
}
