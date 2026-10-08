const options = @import("options");
pub const Value = if (options.kind == .text) []const u8 else i64;
pub const Failure = enum { none, source, seed, callback };
pub const Visit = struct { previous: Value, current: Value, index: u64, source: []const Value };
pub var failure: Failure = .none;
pub var fail_at: usize = 0;
pub var source_calls: usize = 0;
pub var seed_calls: usize = 0;
pub var count: usize = 0;
pub var visits: [8192]Visit = undefined;
pub var events: [8194]u8 = undefined;
pub var event_count: usize = 0;

pub fn reset(selected: Failure, boundary: usize) void {
    failure = selected;
    fail_at = boundary;
    source_calls = 0;
    seed_calls = 0;
    count = 0;
    event_count = 0;
}

fn event(value: u8) void {
    events[event_count] = value;
    event_count += 1;
}

pub fn source(values: []const Value) error{SourceFailure}![]const Value {
    source_calls += 1;

    event('S');

    if (failure == .source) return error.SourceFailure;

    return values;
}

pub fn seed(value: Value) error{SeedFailure}!Value {
    seed_calls += 1;

    event('I');

    if (failure == .seed) return error.SeedFailure;

    return value;
}

pub fn visit(value: anytype) error{CallbackFailure}!Value {
    visits[count] = .{ .previous = value.previous, .current = value.current, .index = value.index, .source = value.source };
    count += 1;

    event('V');

    if (failure == .callback and count == fail_at) return error.CallbackFailure;

    return value.current;
}
