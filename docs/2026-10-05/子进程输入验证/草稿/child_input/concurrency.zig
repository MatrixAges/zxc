const std = @import("std");
const f = @import("fixture.zig");
var calls: usize = 0;
var fail_at: usize = 0;
var kills: usize = 0;
var reaped: bool = false;
var stdin_handle: ?@FieldType(std.Io.File, "handle") = null;
var stdin_closes = std.atomic.Value(usize).init(0);

fn spawn(userdata: ?*anyopaque, options: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    const child = try f.io.vtable.processSpawn(userdata, options);

    stdin_handle = child.stdin.?.handle;

    return child;
}

fn close(userdata: ?*anyopaque, files: []const std.Io.File) void {
    if (stdin_handle) |handle| {
        for (files) |file| if (file.handle == handle) {
            _ = stdin_closes.fetchAdd(1, .monotonic);
        };
    }

    f.io.vtable.fileClose(userdata, files);
}

fn concurrent(userdata: ?*anyopaque, group: *std.Io.Group, context: []const u8, context_alignment: std.mem.Alignment, start: *const fn (*const anyopaque) void) std.Io.ConcurrentError!void {
    const index = calls;

    calls += 1;

    if (index == fail_at) return error.ConcurrencyUnavailable;

    return f.io.vtable.groupConcurrent(userdata, group, context, context_alignment, start);
}

fn kill(userdata: ?*anyopaque, child: *std.process.Child) void {
    kills += 1;

    f.io.vtable.childKill(userdata, child);

    reaped = child.id == null and child.stdin == null and child.stdout == null and child.stderr == null;
}

fn check(index: usize) !void {
    calls = 0;
    fail_at = index;
    stdin_handle = null;

    stdin_closes.store(0, .monotonic);

    kills = 0;
    reaped = false;
    var vtable = f.io.vtable.*;
    vtable.groupConcurrent = concurrent;
    vtable.processSpawn = spawn;
    vtable.fileClose = close;
    vtable.childKill = kill;

    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    const bytes = try f.payload(2 * 1024 * 1024);

    defer f.allocator.free(bytes);

    const options = f.options(&.{"duplex"});
    const started = std.Io.Timestamp.now(f.io, .awake);

    try std.testing.expectError(error.ConcurrencyUnavailable, f.child.spawnSyncWithInput(f.allocator, io, &.{ .options = &options, .input = bytes }));
    try std.testing.expectEqual(index + 1, calls);
    if (index == 1) try std.testing.expectEqual(@as(usize, 1), stdin_closes.load(.monotonic));
    try std.testing.expectEqual(@as(usize, 1), kills);
    try std.testing.expect(reaped);
    try std.testing.expect(started.durationTo(std.Io.Timestamp.now(f.io, .awake)).nanoseconds < 5 * std.time.ns_per_s);
    try f.expect(f.options(&.{"echo"}), "recovery", "recovery", "", 0);
}

test "child input writer dispatch failure kills and reaps child" {
    try check(0);
}

test "child input reader dispatch failure cancels blocked writer and reaps child" {
    try check(1);
}

fn cancelWait(_: ?*anyopaque, _: *std.process.Child) std.process.Child.WaitError!std.process.Child.Term {
    return error.Canceled;
}

test "child input canceled final wait kills and reaps child" {
    kills = 0;
    reaped = false;
    var vtable = f.io.vtable.*;
    vtable.childWait = cancelWait;
    vtable.childKill = kill;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    const options = f.options(&.{"echo"});

    try std.testing.expectError(error.Canceled, f.child.spawnSyncWithInput(f.allocator, io, &.{ .options = &options, .input = "all bytes" }));
    try std.testing.expectEqual(@as(usize, 1), kills);
    try std.testing.expect(reaped);
}
