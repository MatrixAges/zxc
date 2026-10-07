pub const Rule = enum { positive, all, none, index };
pub var calls: usize = 0;
pub var fail_at: usize = 0;
pub var limit: usize = 0;
pub var rule: Rule = .positive;

pub var trace: [8192]i64 = undefined;

pub fn reset(selected: Rule, boundary: usize, failure: usize) void {
    rule = selected;
    limit = boundary;
    fail_at = failure;
    calls = 0;
}

pub fn predicate(value: i64) error{NativeFailure}!bool {
    trace[calls] = value;
    calls += 1;

    if (calls == fail_at) return error.NativeFailure;

    return switch (rule) {
        .positive => value > 0,
        .all => true,
        .none => false,
        .index => calls - 1 <= limit,
    };
}
