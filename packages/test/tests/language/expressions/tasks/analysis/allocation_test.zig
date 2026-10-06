const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn reject(allocator: std.mem.Allocator) !void {
    try f.rejected(allocator, .{ .body = "const work = async (in + 1)\nconst copy = work\nreturn in" }, .{ .code = .ownership, .message = "a task binding must create its own task; task handles cannot be copied" });
}

test "task capture analysis and independent IR validation clean allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.accepted, .{f.Case{ .body = "const value = in + 1\nconst work = async (value + in)\nreturn await work" }});
}

test "parallel error capture analysis and validation clean allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.accepted, .{f.Case{ .body = "const [err, res] = try parallel({ first: () => native.apply(in), second: () => native.other(in) })\nif (err != null) { return 0 }\nreturn res.first + res.second" }});
}

test "task ownership rejection cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, reject, .{});
}
