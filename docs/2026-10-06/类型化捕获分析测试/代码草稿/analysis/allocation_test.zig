const std = @import("std");
const fixture = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

test "capture success refinement releases every failed analysis allocation" {
    const case: fixture.Case = .{ .body = "  const [err, res] = try native.apply(in)\n\n  if (err != null) {\n    return 0\n  }\n\n  return res" };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.accepted, .{case});
}

test "unknown capture diagnostic releases every failed analysis allocation" {
    const case: fixture.Case = .{ .body = "  const [err, res] = try native.apply(in)\n\n  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws\n" };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.rejected, .{ case, @as(fixture.Failure, .{ .message = "try requires a finite error contract; declare the native function's throws members" }) });
}
