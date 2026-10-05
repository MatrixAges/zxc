const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");
const pair = "{ first: u64[], second: u64[] }";
const consumed = "{ first: u64[], second: [u64[], void] }";

const readonly = h.Case{
    .input = pair,
    .body = "  const result = inspect({first: values, second: values})\n\n  const [next, _] = values.reverse()\n\n  return result + next.length",
};

const conflict = h.Case{
    .input = consumed,
    .body = "  return inspect({first: values, second: values.reverse()})",
    .marker = "values.reverse()",
};

test "temporary object argument loans end after scalar-returning call" {
    try h.run(readonly);
}

test "temporary tuple argument loans end after scalar-returning call" {
    try h.run(.{
        .input = "[u64[], u64[]]",
        .body = "  const result = inspect([values, values])\n\n  const [next, _] = values.reverse()\n\n  return result + next.length",
    });
}

test "temporary list argument loans end after scalar-returning call" {
    try h.run(.{
        .input = "u64[][]",
        .body = "  const result = inspect([values, values])\n\n  const [next, _] = values.reverse()\n\n  return result + next.length",
    });
}

test "object argument protects earlier borrow from later consumption" {
    try h.run(conflict);
}

test "tuple argument protects earlier borrow from later consumption" {
    try h.run(.{
        .input = "[u64[], [u64[], void]]",
        .body = "  return inspect([values, values.reverse()])",
        .marker = "values.reverse()",
    });
}

test "nested object argument protects outer borrowed value" {
    try h.run(.{
        .input = "{ first: u64[], second: { changed: [u64[], void] } }",
        .body = "  return inspect({first: values, second: {changed: values.reverse()}})",
        .marker = "values.reverse()",
    });
}

test "nested scalar call cannot release an existing outer argument loan" {
    try h.run(.{
        .input = "{ first: u64[], second: u64, third: [u64[], void] }",
        .body = "  return inspect({first: values, second: count(values), third: values.reverse()})",
        .marker = "values.reverse()",
    });
}

test "completed scalar inner call does not loan its input into outer argument" {
    try h.run(.{
        .input = "{ first: u64, second: [u64[], void] }",
        .body = "  return inspect({first: count(values), second: values.reverse()})",
    });
}

test "fresh mapped argument does not loan its scalar source list" {
    try h.run(.{
        .input = consumed,
        .body = "  return inspect({first: values.map(item => item + 1), second: values.reverse()})",
    });
}

test "borrowed return keeps aggregate argument source frozen after call" {
    try h.run(.{
        .input = pair,
        .helper_output = "u64[]",
        .helper_body = "  return in.first",
        .body = "  const view = inspect({first: values, second: values})\n\n  const [next, _] = values.reverse()\n\n  return view.length + next.length",
        .marker = "values.reverse()",
    });
}

test "later scalar call cannot release an already escaped borrow" {
    try h.run(.{
        .input = pair,
        .helper_output = "u64[]",
        .helper_body = "  return in.first",
        .body = "  const view = inspect({first: values, second: values})\n\n  const length = count(values)\n\n  const [next, _] = values.reverse()\n\n  return view.length + next.length + length",
        .marker = "values.reverse()",
    });
}

test "temporary borrow success releases analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{readonly});
}

test "temporary borrow conflict releases analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{conflict});
}
