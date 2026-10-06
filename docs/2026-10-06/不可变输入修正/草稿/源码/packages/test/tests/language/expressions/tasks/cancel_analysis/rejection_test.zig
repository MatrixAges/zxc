const std = @import("std");
const f = @import("task_fixture");

test "cancel rejects a scalar operand" {
    try f.rejected(std.testing.allocator, .{ .body = "cancel in\nreturn in" }, .{ .code = .type_mismatch, .message = "cancel requires a task" });
}

test "cancel consumes a local task before a second cancel" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\ncancel work\ncancel work\nreturn in" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "await cannot consume an already canceled task" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\ncancel work\nreturn await work" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "cancel cannot consume an already awaited task" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\nconst value = await work\ncancel work\nreturn value" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "cancel on one branch prevents await after the merge" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\nif (in == 0) { cancel work }\nreturn await work" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "await on one branch prevents cancel after the merge" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\nif (in == 0) { const value = await work }\ncancel work\nreturn in" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "a task cannot capture an outer handle merely to cancel it" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\nconst other = async (cancel work)\ncancel other\nreturn in" }, .{ .code = .ownership, .message = "tasks cannot capture other task handles" });
}

test "cancel preserves immutable captured list access" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values[0]\ncancel work\nconst [changed, _] = values.reverse()\nreturn in" });
}

test "void cancellation result cannot satisfy a scalar return" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\nreturn cancel work" }, .{ .code = .type_mismatch, .message = "expression type does not match its context" });
}
