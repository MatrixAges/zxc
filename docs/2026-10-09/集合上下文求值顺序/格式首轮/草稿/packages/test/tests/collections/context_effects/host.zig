pub const Failure = enum { none, source, context, callback };
pub var selected: Failure = .none;
pub var fail_at: usize = 0;
pub var source_calls: usize = 0;
pub var context_calls: usize = 0;
pub var calls: usize = 0;
pub var events: [8194]u8 = undefined;
pub var event_count: usize = 0;
pub var items: [8192]i64 = undefined;
pub var contexts: [8192]i64 = undefined;
pub var tag: i64 = 0;

pub fn reset(failure: Failure, boundary: usize) void {
    selected = failure;
    fail_at = boundary;
    source_calls = 0;
    context_calls = 0;
    calls = 0;
    event_count = 0;
}

fn event(value: u8) void {
    events[event_count] = value;
    event_count += 1;
}

pub fn source(values: []i64) error{SourceFailure}![]i64 {
    source_calls += 1;

    event('S');

    if (selected == .source) return error.SourceFailure;

    return values;
}

pub fn context(value: i64) error{ContextFailure}!i64 {
    context_calls += 1;
    tag = value;

    event('C');

    if (selected == .context) return error.ContextFailure;

    return value + 7;
}

fn visit(value: anytype) error{CallbackFailure}!void {
    event('V');

    items[calls] = value.item;
    contexts[calls] = value.context;
    calls += 1;

    if (selected == .callback and calls == fail_at) return error.CallbackFailure;
}

pub fn mapValue(value: anytype) error{CallbackFailure}!i64 {
    try visit(value);

    return value.item + value.context;
}

pub fn predicate(value: anytype) error{CallbackFailure}!bool {
    try visit(value);

    return value.item > value.context;
}
