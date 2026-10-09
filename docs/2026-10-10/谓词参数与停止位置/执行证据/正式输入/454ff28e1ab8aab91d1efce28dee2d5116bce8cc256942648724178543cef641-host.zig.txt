pub const Spec = struct { failure: usize = 0 };
pub const Visit = struct { item: i64, index: u64, source: []const i64 };
pub var source_calls: usize = 0;
pub var count: usize = 0;
pub var visits: [8192]Visit = undefined;

var spec: Spec = undefined;

pub fn reset(value: Spec) void {
    spec = value;
    count = 0;
    source_calls = 0;
}

pub fn source(values: []const i64) []const i64 {
    source_calls += 1;

    return values;
}

pub fn visit(value: anytype) error{CallbackFailure}!bool {
    visits[count] = .{ .item = value.item, .index = value.index, .source = value.source };
    count += 1;

    if (spec.failure != 0 and count == spec.failure) return error.CallbackFailure;

    return true;
}
