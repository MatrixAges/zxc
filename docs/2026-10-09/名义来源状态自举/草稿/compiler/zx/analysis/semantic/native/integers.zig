const std = @import("std");

pub fn widen(value: u32) u64 {
    return value;
}

pub fn widenByte(value: u8) u64 {
    return value;
}

pub fn narrow(value: u64) error{IntegerOverflow}!u32 {
    return std.math.cast(u32, value) orelse error.IntegerOverflow;
}
