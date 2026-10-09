pub const Rule = enum { all, none, positive, before };
pub const Visit = struct { item: i64, index: u64, source: []const i64 };
pub var source_calls: usize = 0;
pub var count: usize = 0;
pub var visits: [8192]Visit = undefined;

var rule: Rule = .all;
var limit: usize = 0;
var failure: usize = 0;

pub fn reset(selected: Rule, boundary: usize, fail_at: usize) void {
    source_calls = 0;
    count = 0;
    rule = selected;
    limit = boundary;
    failure = fail_at;
}

pub fn source(values: []const i64) []const i64 {
    source_calls += 1;

    return values;
}

pub fn visit(value: anytype) error{CallbackFailure}!bool {
    visits[count] = .{ .item = value.item, .index = value.index, .source = value.source };
    count += 1;

    if (failure != 0 and count == failure) return error.CallbackFailure;

    return switch (rule) {
        .all => true,
        .none => false,
        .positive => value.item > 0,
        .before => value.index < limit,
    };
}
