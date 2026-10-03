const scaling = @import("util/scale.zig");
const units = @import("units");

pub fn convert(value: f64) f64 {
    return scaling.apply(value) + units.offset;
}
