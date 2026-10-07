pub var calls: u64 = 0;
pub var trace: u64 = 0;

pub fn tick(value: u64) u64 {
    calls += 1;
    trace = trace *% 131 +% (value + 1);

    return value % 3 + 1;
}

pub fn reset() void {
    calls = 0;
    trace = 0;
}
