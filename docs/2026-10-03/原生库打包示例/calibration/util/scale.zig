const std = @import("std");
const factor = std.fmt.parseFloat(f64, @embedFile("factor.txt")) catch @compileError("invalid calibration factor");

pub fn apply(value: f64) f64 {
    return value * factor;
}
