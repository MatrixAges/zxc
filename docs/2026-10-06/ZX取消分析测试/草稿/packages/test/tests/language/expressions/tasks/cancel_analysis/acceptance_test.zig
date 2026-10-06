const std = @import("std");
const f = @import("task_fixture");

test "mutually exclusive paths can cancel or await the same task" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async native.apply(in)\nif (in == 0) { cancel work\nreturn 0 } else { return await work }" });
}

test "independent branch tasks can each be canceled before a merged return" {
    try f.accepted(std.testing.allocator, .{ .body = "if (in == 0) { const work = async native.apply(in)\ncancel work } else { const work = async native.other(in)\ncancel work }\nreturn in" });
}

test "a captured list remains readable after cancellation" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values[0]\ncancel work\nreturn values[1]" });
}

test "a worker can cancel its own directly created inner task" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async (cancel async native.apply(in))\ncancel work\nreturn in" });
}

test "void application output can return direct cancellation" {
    try f.accepted(std.testing.allocator, .{ .body = "return cancel async native.effect(in)", .output = "void" });
}
