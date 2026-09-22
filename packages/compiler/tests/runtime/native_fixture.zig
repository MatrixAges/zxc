pub const Input = struct { value: f64 };
pub const Output = struct { value: f64 };

pub fn copy(value: Input) Output {
    return .{ .value = value.value };
}

pub fn zero() f64 {
    return 0;
}
