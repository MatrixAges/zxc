const method = @import("options").method;
pub const Rule = enum { cursor, visited };
pub const Event = enum { source, context, visit };
pub const Visit = struct { item: i64, index: u64, source: []const i64 };
pub var cursor: u64 = 0;
pub var count: usize = 0;
pub var visits: [8192]Visit = undefined;
pub var marked: [8192]bool = @splat(false);
pub var events: [8194]Event = undefined;
pub var event_count: usize = 0;
var rule: Rule = .cursor;

pub fn reset(selected: Rule, initial_cursor: u64) void {
    rule = selected;
    cursor = initial_cursor;
    count = 0;
    marked = @splat(false);
    event_count = 0;
}

fn record(event: Event) void {
    events[event_count] = event;
    event_count += 1;
}

pub fn source(values: []const i64) []const i64 {
    record(.source);

    return values;
}

pub fn context() void {
    record(.context);
}

pub fn visit(value: anytype) bool {
    visits[count] = .{ .item = value.item, .index = value.index, .source = value.source };
    count += 1;

    record(.visit);

    if (rule == .cursor) {
        if (cursor != value.index) return method == .some;

        cursor += 1;

        return method == .every;
    }

    if (!marked[value.index]) {
        if (value.index != 0 and !marked[value.index - 1]) return method == .some;

        marked[value.index] = true;

        return method == .every;
    }

    return method == .some;
}
