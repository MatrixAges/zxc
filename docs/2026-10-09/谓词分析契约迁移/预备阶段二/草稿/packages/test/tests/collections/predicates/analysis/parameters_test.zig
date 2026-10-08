const f = @import("fixture.zig");

fn both(callback: []const u8, accepted: bool) !void {
    for ([_][]const u8{ "every", "some" }) |method| try f.method(method, callback, accepted);
}

test "predicate callbacks may omit every parameter" {
    try both("() => true", true);
}

test "predicate callbacks receive elements" {
    try both("item => item > 0", true);
}

test "predicate callback index has u64 type" {
    try both("(item, index) => index < in.length", true);
    try both("(item, index) => index == item", false);
}

test "predicate callbacks receive a typed source array" {
    try both("(item, index, source) => source[index] == item", true);
    try both("(item, index, source) => source + item > 0", false);
}

test "predicate callbacks accept an evaluated ignored second argument" {
    try both("item => item > 0, true", true);
    try both("item => item > 0, in", true);
}

test "predicate callbacks reject parameters beyond the source array" {
    try both("(item, index, source, extra) => true", false);
}

test "predicate calls require an inline callback" {
    try both("", false);
    try both("true", false);
}

test "predicate callbacks reject non bool results" {
    try both("item => item", false);
    try both("item => [item]", false);
}

test "predicate calls reject a third argument" {
    try both("item => true, false, true", false);
}
