const f = @import("fixture.zig");

test "predicate callbacks capture outer scalar bindings" {
    try f.accepted(.{ .body = "const limit = 0\nreturn in.every(item => item > limit)" });
    try f.accepted(.{ .body = "const limit = 0\nreturn in.some(item => item > limit)" });
}

test "predicate parameters shadow outer bindings" {
    try f.accepted(.{ .body = "const item = false\nreturn in.every(item => item > 0)" });
}

test "nested predicate callbacks capture the enclosing element" {
    try f.accepted(.{ .body = "return in.every(row => row.some(item => item > row[0]))", .input = "i64[][]" });
}

test "nested predicate callbacks capture a shared outer scalar" {
    try f.accepted(.{ .body = "const limit = 0\nreturn in.some(row => row.every(item => item > limit))", .input = "i64[][]" });
}

test "predicate callbacks reject unresolved captures" {
    try f.rejected(.{ .body = "return in.every(item => item > missing)" }, .name, null);
}

test "predicate callback parameters reject duplicate bindings" {
    try f.rejected(.{ .body = "return in.every((item, item) => true)" }, .name, null);
}

test "predicate callbacks cannot repeatedly consume an outer task" {
    try f.rejected(.{ .body = "const work = async true\nreturn in.every(item => await work)" }, .ownership, "collection callbacks cannot repeatedly consume a captured task handle");
}
