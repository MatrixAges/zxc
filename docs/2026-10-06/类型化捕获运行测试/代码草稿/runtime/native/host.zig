pub var calls: usize = 0;

pub fn reset() void {
    calls = 0;
}

pub fn value(input: u64) error{ NativeFailure, MissingValue }!u64 {
    calls += 1;

    return switch (input) {
        0 => error.NativeFailure,
        1 => error.MissingValue,
        else => input,
    };
}

pub fn optional(input: u64) error{NativeFailure}!?u64 {
    calls += 1;

    return switch (input) {
        0 => error.NativeFailure,
        1 => null,
        else => input,
    };
}

pub fn effect(input: u64) error{NativeFailure}!void {
    calls += 1;

    if (input == 0) return error.NativeFailure;
}

pub fn identity(input: u64) u64 {
    calls += 1;

    return input;
}

pub fn empty(input: u64) error{}!u64 {
    calls += 1;

    return input;
}
