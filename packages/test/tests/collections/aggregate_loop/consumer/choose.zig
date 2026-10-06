pub var calls: usize = 0;
pub var slot: u64 = 0;
pub var failed: bool = false;

pub fn reset() void {
    calls = 0;
    slot = 0;
    failed = false;
}

pub fn index(input: anytype) error{SelectionFailed}!u64 {
    calls += 1;
    slot = input.slot;
    failed = input.fail;

    if (input.fail) return error.SelectionFailed;

    return input.slot;
}
