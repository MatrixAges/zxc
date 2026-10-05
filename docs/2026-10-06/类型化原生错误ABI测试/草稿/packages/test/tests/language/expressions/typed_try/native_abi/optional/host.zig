pub const fallible = true;

pub fn apply(input: u64) error{ AlphaFailure, ZetaFailure }!?u64 {
    if (input == 1) return error.ZetaFailure;

    return input;
}
