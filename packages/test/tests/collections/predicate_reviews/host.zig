pub const Spec = struct {
    rule: enum { above, equal, always, before, after },
    threshold: i64 = 0,
    value: bool = false,
    failure: usize = 0,
};

pub var calls: usize = 0;
pub var trace: [8192]i64 = undefined;

var spec: Spec = undefined;

pub fn reset(value: Spec) void {
    calls = 0;
    spec = value;
}

pub fn predicate(value: i64) error{NativeFailure}!bool {
    trace[calls] = value;
    calls += 1;

    if (spec.failure != 0 and calls == spec.failure) return error.NativeFailure;

    return switch (spec.rule) {
        .above => value > spec.threshold,
        .equal => value == spec.threshold,
        .always => spec.value,
        .before => @as(i64, @intCast(calls - 1)) <= spec.threshold,
        .after => @as(i64, @intCast(calls - 1)) > spec.threshold,
    };
}
