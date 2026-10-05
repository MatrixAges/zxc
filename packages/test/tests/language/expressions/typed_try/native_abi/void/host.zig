pub const fallible = true;

pub fn apply(input: u64) error{ AlphaFailure, ZetaFailure }!void {
    if (input == 1) return error.ZetaFailure;

    return;
}
