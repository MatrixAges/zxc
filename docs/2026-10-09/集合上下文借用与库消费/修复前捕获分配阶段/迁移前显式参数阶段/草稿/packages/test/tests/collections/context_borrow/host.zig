const options = @import("options");
pub const Failure = enum { none, echo, callback };
pub var selected: Failure = .none;
pub var fail_at: usize = 0;
pub var echoes: usize = 0;
pub var calls: usize = 0;
pub var original: usize = 0;
pub var left: usize = 0;
pub var right: usize = 0;
pub var invalid_borrow: bool = false;
pub var trace: [8192]i64 = undefined;
pub var scores: [8192]i64 = undefined;

fn address(context: anytype) usize {
    return @intFromPtr(if (options.kind == .list) context.ptr else context);
}

pub fn reset(context: anytype, failure: Failure, boundary: usize) void {
    selected = failure;
    fail_at = boundary;
    echoes = 0;
    calls = 0;
    invalid_borrow = false;
    original = address(context);

    if (options.kind == .object) left = @intFromPtr(context.payload.ptr);

    if (options.kind == .nested) {
        left = @intFromPtr(context.left.ptr);
        right = @intFromPtr(context.right.ptr);
    }
}

fn borrowed(context: anytype) void {
    invalid_borrow = invalid_borrow or address(context) != original;

    if (options.kind == .object) invalid_borrow = invalid_borrow or @intFromPtr(context.payload.ptr) != left;
    if (options.kind == .nested) invalid_borrow = invalid_borrow or @intFromPtr(context.left.ptr) != left or @intFromPtr(context.right.ptr) != right;
}

fn sum(values: []const i64) i64 {
    var result: i64 = 0;

    for (values, 0..) |value, index| result += value * @as(i64, @intCast(index + 1));

    return result;
}

fn score(context: anytype) i64 {
    return if (options.kind == .list) sum(context) else if (options.kind == .object) context.limit + sum(context.payload) else sum(context.left) - sum(context.right) + @as(i64, @intFromBool(context.active));
}

pub fn echo(context: anytype) error{NativeFailure}!@TypeOf(context) {
    borrowed(context);

    echoes += 1;

    if (selected == .echo) return error.NativeFailure;

    return context;
}

fn visit(item: i64, context: anytype) error{NativeFailure}!i64 {
    borrowed(context);

    trace[calls] = item;

    const value = score(context);
    scores[calls] = value;
    calls += 1;

    if (selected == .callback and calls == fail_at) return error.NativeFailure;

    return value;
}

pub fn mapValue(item: i64, context: anytype) error{NativeFailure}!i64 {
    return item + try visit(item, context);
}

pub fn predicate(item: i64, context: anytype) error{NativeFailure}!bool {
    return item > try visit(item, context);
}
