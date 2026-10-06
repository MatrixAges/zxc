const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("task_fixture");

fn reject(allocator: std.mem.Allocator) !void {
    try f.rejected(allocator, .{ .body = "const work = async in\ncancel work\ncancel work\nreturn in" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "local cancellation analysis and IR validation clean allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.accepted, .{f.Case{ .body = "const work = async native.apply(in)\ncancel work\nreturn in" }});
}

test "mixed cancel await branches clean analysis allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.accepted, .{f.Case{ .body = "const work = async native.apply(in)\nif (in == 0) { cancel work\nreturn 0 } else { return await work }" }});
}

test "second cancel ownership rejection cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{});
}
