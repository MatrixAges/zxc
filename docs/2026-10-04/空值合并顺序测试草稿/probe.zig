pub var trace: [8]u8 = undefined;
pub var count: usize = 0;

pub fn left(fail: bool) !f64 {
    trace[count] = 'L';
    count += 1;

    if (fail) return error.LeftFailure;

    return 2;
}

pub fn right(fail: bool) !f64 {
    trace[count] = 'R';
    count += 1;

    if (fail) return error.RightFailure;

    return 3;
}

pub fn optionalLeft(input: anytype) !?bool {
    _ = try left(input.fail);

    return input.value;
}

pub fn optionalRight(input: anytype) !?bool {
    _ = try right(input.fail);

    return input.value;
}
