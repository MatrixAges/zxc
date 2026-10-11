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

pub fn parse32(bytes: []const u8) ?f32 {
    return std.fmt.parseFloat(f32, bytes) catch null;
}

pub fn parse64(bytes: []const u8) ?f64 {
    return std.fmt.parseFloat(f64, bytes) catch null;
}
