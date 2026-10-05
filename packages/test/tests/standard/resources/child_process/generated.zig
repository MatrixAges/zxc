const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");
const f = @import("fixture.zig");

fn run(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input = f.options(&.{"bytes"});
    const result = try program.execute(&arena, &input, f.io);

    try std.testing.expectEqualSlices(u8, &.{ 0, 255, 128, 13, 10 }, result.stdout);
    try std.testing.expectEqualSlices(u8, &.{ 254, 0, 127 }, result.stderr);
    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 0), result.code);
}

test "generated child process entry declares IO requirement" {
    try std.testing.expect(program.requires_io);
    try std.testing.expect(!program.consumes_input);
}

test "generated child process entry preserves binary output" {
    try run(f.allocator);
}

test "generated child process entry releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, run, .{});
}

fn deny(_: ?*anyopaque, _: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    return error.AccessDenied;
}

test "generated child process entry uses caller provided IO" {
    var vtable = f.io.vtable.*;
    vtable.processSpawn = deny;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const input = f.options(&.{ "exit", "0" });

    try std.testing.expectError(error.AccessDenied, program.execute(&arena, &input, io));
}

test "generated child process entry propagates limit failure and recovers" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var input = f.options(&.{"bytes"});

    input.max_stderr_bytes = 2;

    try std.testing.expectError(error.StreamTooLong, program.execute(&arena, &input, f.io));

    input.max_stderr_bytes = 3;

    const result = try program.execute(&arena, &input, f.io);

    try std.testing.expectEqualSlices(u8, &.{ 254, 0, 127 }, result.stderr);
}

test "generated child process entry preserves nonzero exit without throwing" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const input = f.options(&.{ "exit", "73" });
    const result = try program.execute(&arena, &input, f.io);

    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 73), result.code);
}
