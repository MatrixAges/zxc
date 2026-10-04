const std = @import("std");

pub const Input = void;

pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = arena;

    _ = in;

    const value_1: u64 = @as(u64, 13);

    return value_1;
}

