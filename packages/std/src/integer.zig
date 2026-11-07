const std = @import("std");

pub fn widen(value: u32) u64 {
    return value;
}

pub fn widenShort(value: u16) u64 {
    return value;
}

pub fn widenByte(value: u8) u64 {
    return value;
}

pub fn widenSigned(value: u32) i64 {
    return value;
}

pub fn narrow(value: u64) error{IntegerOverflow}!u32 {
    return std.math.cast(u32, value) orelse error.IntegerOverflow;
}

pub fn narrowByte(value: u64) error{IntegerOverflow}!u8 {
    return std.math.cast(u8, value) orelse error.IntegerOverflow;
}

pub fn narrowSigned(value: i64) error{IntegerOverflow}!u32 {
    return std.math.cast(u32, value) orelse error.IntegerOverflow;
}

pub fn bitMask(index: u64) error{IntegerOverflow}!u64 {
    if (index >= @bitSizeOf(u64)) return error.IntegerOverflow;

    return @as(u64, 1) << @as(u6, @intCast(index));
}

pub fn andBits(left: u64, right: u64) u64 {
    return left & right;
}

pub fn orBits(left: u64, right: u64) u64 {
    return left | right;
}

pub fn shiftLeft(value: u64, amount: u64) error{IntegerOverflow}!u64 {
    if (amount >= @bitSizeOf(u64)) return error.IntegerOverflow;

    return value << @as(u6, @intCast(amount));
}

pub fn hash(value: u64) u64 {
    return std.hash.Wyhash.hash(0, std.mem.asBytes(&value));
}

pub fn hash32(value: u32) u64 {
    return std.hash.Wyhash.hash(0, std.mem.asBytes(&value));
}
