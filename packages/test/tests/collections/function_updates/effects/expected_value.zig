const std = @import("std");
const mode = @import("options").mode;
const Operation = enum { set, add, subtract, multiply, divide, remainder };
const name = mode[(std.mem.lastIndexOfScalar(u8, mode, '_') orelse unreachable) + 1 ..];
const operation = std.meta.stringToEnum(Operation, name) orelse @compileError("unknown function update operator");
pub const compound = operation != .set;
pub const default_delta: i64 = if (operation == .multiply) 2 else 7;

pub fn repeated(initial: i64, delta: i64, rounds: usize) i64 {
    var value = initial;

    for (0..rounds) |_| {
        value = switch (operation) {
            .set => delta,
            .add => value + delta,
            .subtract => value - delta,
            .multiply => value * delta,
            .divide => @divTrunc(value, delta),
            .remainder => @rem(value, delta),
        };
    }

    return value;
}
