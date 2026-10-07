const std = @import("std");

pub fn narrow(value: f64) f32 {
    return @floatCast(value);
}

pub fn widen(value: f32) f64 {
    return value;
}

pub fn isFinite(value: f64) bool {
    return std.math.isFinite(value);
}
