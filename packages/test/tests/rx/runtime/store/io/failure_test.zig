const std = @import("std");
const State = @import("zxc_state");
const f = @import("fixture");
const execute = @import("execute.zig");

fn check(after_commit: bool, bytes: ?[]const u8, limit: u64, expected: anyerror) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("good", "new");
    if (bytes) |data| try fixture.write("bad", data);

    const original = state.value_0;
    var input = try execute.input(&fixture, if (after_commit) "good" else "bad", "bad");

    input.max_bytes = limit;

    try std.testing.expectError(expected, execute.run(&state, &input, f.io));
    try std.testing.expectEqualStrings(if (after_commit) "new" else "initial", state.value_0.text);
    try std.testing.expectEqual(@as(u64, if (after_commit) 1 else 0), state.value_0.count);
    try std.testing.expectEqualStrings("initial", original.text);
    if (!after_commit) try std.testing.expectEqual(original, state.value_0);

    input = try execute.input(&fixture, "good", "good");

    const output = try execute.run(&state, &input, f.io);

    try std.testing.expectEqualStrings("new", output.text);
    try std.testing.expectEqual(@as(u64, if (after_commit) 2 else 1), output.count);
}

test "Store IO missing first file prevents publication and permits recovery" {
    try check(false, null, 1024, error.FileNotFound);
}

test "Store IO first read limit failure prevents publication" {
    try check(false, "long", 3, error.StreamTooLong);
}

test "Store IO first invalid UTF8 prevents publication" {
    try check(false, "\xff", 1024, error.InvalidUtf8);
}

test "Store IO missing later file retains the earlier publication" {
    try check(true, null, 1024, error.FileNotFound);
}

test "Store IO later read limit failure retains the earlier publication" {
    try check(true, "long", 3, error.StreamTooLong);
}

test "Store IO later invalid UTF8 retains the earlier publication" {
    try check(true, "\xff", 1024, error.InvalidUtf8);
}

fn denyOpen(_: ?*anyopaque, _: std.Io.Dir, _: []const u8, _: std.Io.Dir.OpenFileOptions) std.Io.File.OpenError!std.Io.File {
    return error.AccessDenied;
}

test "Store Request execute forwards its explicit host IO and preserves state on rejection" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("good", "new");

    const original = state.value_0;
    const input = try execute.input(&fixture, "good", "good");
    var vtable = f.io.vtable.*;
    vtable.dirOpenFile = denyOpen;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };

    try std.testing.expectError(error.AccessDenied, execute.run(&state, &input, io));
    try std.testing.expectEqual(original, state.value_0);
    try std.testing.expectEqualStrings("initial", original.text);
}
