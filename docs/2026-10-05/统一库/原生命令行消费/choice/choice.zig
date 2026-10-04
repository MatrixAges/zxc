pub const Mode = @import("zxc_abi").native.@"zig:choice".Mode;
pub var calls: usize = 0;
pub var fail_at: usize = 0;
pub var trace: [2]Mode = undefined;

pub fn reset(failure: usize) void {
    calls = 0;
    fail_at = failure;
    trace = undefined;
}

pub fn flip(input: Mode) !Mode {
    trace[calls] = input;
    calls += 1;

    if (calls == fail_at) return error.NativeFailure;

    return switch (input) {
        .First => .Second,
        .Second => .First,
    };
}
