pub var calls: usize = 0;
pub var fail_at: usize = 0;
pub var trace: [64]u64 = undefined;

pub fn reset(failure: usize) void {
    calls = 0;
    fail_at = failure;
    trace = undefined;
}

pub fn record(input: u64) error{Stop}!void {
    trace[calls] = input;
    calls += 1;

    if (calls == fail_at) return error.Stop;
}

pub fn seed(input: u64) error{Stop}!u64 {
    try record(1000 + input);

    return input;
}

pub fn check(input: u64) error{Stop}!bool {
    try record(2000 + input);

    return input > 0;
}
