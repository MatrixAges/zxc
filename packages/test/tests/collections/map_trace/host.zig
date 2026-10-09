pub const Spec = struct {
    rule: enum { cursor, violations },
    cursor: u64 = 0,
    failure: usize = 0,
};

pub const Visit = struct { item: i64, index: u64, source: []const i64 };
pub var source_calls: usize = 0;
pub var count: usize = 0;
pub var ordered: bool = true;
pub var visits: [8192]Visit = undefined;

var spec: Spec = undefined;
var cursor: u64 = 0;
var seen: [8192]bool = @splat(false);

pub fn reset(value: Spec) void {
    spec = value;
    cursor = value.cursor;
    count = 0;
    ordered = true;
    source_calls = 0;

    @memset(&seen, false);
}

pub fn source(values: []const i64) []const i64 {
    source_calls += 1;

    return values;
}

pub fn visit(value: anytype) error{CallbackFailure}!bool {
    visits[count] = .{ .item = value.item, .index = value.index, .source = value.source };
    count += 1;

    if (spec.failure != 0 and count == spec.failure) return error.CallbackFailure;

    if (spec.rule == .cursor) {
        if (value.index != cursor) {
            ordered = false;

            return false;
        }

        cursor += 1;

        return true;
    }

    const index: usize = @intCast(value.index);

    if (seen[index] or (index != 0 and !seen[index - 1])) return true;

    seen[index] = true;

    return false;
}
