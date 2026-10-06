const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");
const f = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, count: usize) !void {
    const bytes = try f.payload(count);

    defer f.allocator.free(bytes);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const options = f.options(&.{"mirror"});
    const result = try program.execute(&arena, &.{ .options = &options, .input = bytes }, f.io);

    try std.testing.expectEqualSlices(u8, bytes, result.stdout);
    try std.testing.expectEqualSlices(u8, bytes, result.stderr);
    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 0), result.code);
    for (bytes, 0..) |byte, index| try std.testing.expectEqual(@as(u8, @truncate(index *% 37)), byte);
}

test "generated input process requires IO and preserves borrowed input contract" {
    try std.testing.expect(program.requires_io);
    try std.testing.expect(!@hasDecl(program, "consumes_input"));
}

test "generated input process transports arbitrary bytes on both output streams" {
    try run(f.allocator, 256);
}

test "generated input process provides EOF for empty bytes" {
    try run(f.allocator, 0);
}

test "generated input process exceeds all pipe capacities" {
    try run(f.allocator, 262144);
}

test "generated input process releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, run, .{@as(usize, 32)});
}

fn deny(_: ?*anyopaque, _: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    return error.AccessDenied;
}

test "generated input process respects explicit host IO" {
    var vtable = f.io.vtable.*;
    vtable.processSpawn = deny;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const options = f.options(&.{"echo"});

    try std.testing.expectError(error.AccessDenied, program.execute(&arena, &.{ .options = &options, .input = "data" }, io));
}

test "generated input process propagates output failure then recovers" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var options = f.options(&.{"mirror"});

    options.max_stderr_bytes = 2;

    try std.testing.expectError(error.StreamTooLong, program.execute(&arena, &.{ .options = &options, .input = "123" }, f.io));

    options.max_stderr_bytes = 3;
    const result = try program.execute(&arena, &.{ .options = &options, .input = "123" }, f.io);

    try std.testing.expectEqualSlices(u8, "123", result.stdout);
    try std.testing.expectEqualSlices(u8, "123", result.stderr);
}

test "generated input process reports nonzero exit after complete input" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const options = f.options(&.{"exit"});
    const result = try program.execute(&arena, &.{ .options = &options, .input = "complete" }, f.io);

    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 73), result.code);
}

test "generated input process preserves prior captured result" {
    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const options = f.options(&.{"echo"});
    const first = try program.execute(&arena, &.{ .options = &options, .input = "first" }, f.io);
    const second = try program.execute(&arena, &.{ .options = &options, .input = "second" }, f.io);

    try std.testing.expectEqualSlices(u8, "first", first.stdout);
    try std.testing.expectEqualSlices(u8, "second", second.stdout);
}

test "generated input process preserves signal after full input" {
    if (@import("builtin").os.tag == .windows) return error.SkipZigTest;

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const options = f.options(&.{"signal"});
    const result = try program.execute(&arena, &.{ .options = &options, .input = "complete" }, f.io);

    try std.testing.expectEqual(f.child.TerminationKind.Signal, result.kind);
    try std.testing.expectEqual(@as(u32, @intFromEnum(std.posix.SIG.TERM)), result.code);
}
