const std = @import("std");
const State = @import("zxc_state");
const f = @import("fixture");

fn check(allocator: std.mem.Allocator) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("data", "readonly 🌿");

    const original = state.value_0;
    var request = state.request();

    defer request.deinit();

    const output = try request.execute(&.{ .path = try fixture.path("data"), .max_bytes = 1024 }, f.io);

    try std.testing.expectEqualStrings("readonly 🌿", output.read);
    try std.testing.expectEqualStrings("initial", output.stored.text);
    try std.testing.expectEqual(@as(u64, 0), output.stored.count);
    try std.testing.expectEqual(original, state.value_0);
}

test "readonly Store IO Request combines file bytes and unchanged Store snapshot" {
    try check(f.allocator);
}

test "readonly Store IO Request releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, check, .{});
}

test "readonly Store IO repeated requests release all file buffers after each request" {
    var fixture = try f.init();

    defer fixture.deinit();

    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    var arena = std.heap.ArenaAllocator.init(debug.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("data", "readonly");

    const path = try fixture.path("data");
    const baseline = debug.total_requested_bytes;
    const original = state.value_0;

    for (0..64) |_| {
        {
            var request = state.request();

            defer request.deinit();

            const output = try request.execute(&.{ .path = path, .max_bytes = 1024 }, f.io);

            try std.testing.expectEqualStrings("readonly", output.read);
            try std.testing.expect(debug.total_requested_bytes > baseline);
        }

        try std.testing.expectEqual(baseline, debug.total_requested_bytes);
        try std.testing.expectEqual(original, state.value_0);
    }
}

test "readonly Store IO failed request releases temporary memory without state change" {
    var fixture = try f.init();

    defer fixture.deinit();

    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    var arena = std.heap.ArenaAllocator.init(debug.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const baseline = debug.total_requested_bytes;
    const original = state.value_0;

    {
        var request = state.request();

        defer request.deinit();

        try std.testing.expectError(error.FileNotFound, request.execute(&.{ .path = try fixture.path("missing"), .max_bytes = 1024 }, f.io));
    }

    try std.testing.expectEqual(baseline, debug.total_requested_bytes);
    try std.testing.expectEqual(original, state.value_0);
}

fn denyOpen(_: ?*anyopaque, _: std.Io.Dir, _: []const u8, _: std.Io.Dir.OpenFileOptions) std.Io.File.OpenError!std.Io.File {
    return error.AccessDenied;
}

test "readonly Store Request forwards the supplied host IO without granting publication" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("data", "readonly");

    var request = state.request();

    defer request.deinit();

    const original = state.value_0;
    var vtable = f.io.vtable.*;
    vtable.dirOpenFile = denyOpen;

    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };

    try std.testing.expectError(error.AccessDenied, request.execute(&.{ .path = try fixture.path("data"), .max_bytes = 1024 }, io));
    try std.testing.expectError(error.StoreNotWritable, request.commit(.{ .store_0 = original }));
    try std.testing.expectEqual(original, state.value_0);
}
