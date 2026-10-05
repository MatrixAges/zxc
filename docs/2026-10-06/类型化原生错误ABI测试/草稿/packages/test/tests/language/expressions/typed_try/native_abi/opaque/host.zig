pub const fallible = true;

pub fn apply(input: u64) anyerror!u64 {
    if (input == 1) return error.ZetaFailure;

    return input;
}
