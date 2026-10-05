const std = @import("std");
const f = @import("fixture.zig");

test "child input exact output limits accept both streams" {
    var options = f.options(&.{"mirror"});
    options.max_stdout_bytes = 5;
    options.max_stderr_bytes = 5;

    try f.expect(options, &.{ 0, 1, 2, 254, 255 }, &.{ 0, 1, 2, 254, 255 }, &.{ 0, 1, 2, 254, 255 }, 0);
}

test "child input zero limits accept EOF without output" {
    var options = f.options(&.{"echo"});
    options.max_stdout_bytes = 0;
    options.max_stderr_bytes = 0;

    try f.expect(options, &.{}, &.{}, &.{}, 0);
}

test "child input stdout one byte beyond limit rejects result" {
    var options = f.options(&.{"echo"});

    options.max_stdout_bytes = 4;

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = "12345" }));
}

test "child input stderr one byte beyond limit rejects result" {
    var options = f.options(&.{"mirror"});
    options.max_stderr_bytes = 4;

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = "12345" }));
}

test "child input stdout limit cancels blocked writer" {
    const bytes = try f.payload(2 * 1024 * 1024);

    defer f.allocator.free(bytes);

    var options = f.options(&.{"duplex"});
    options.max_stdout_bytes = 1;
    const started = std.Io.Timestamp.now(f.io, .awake);

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = bytes }));
    try std.testing.expect(started.durationTo(std.Io.Timestamp.now(f.io, .awake)).nanoseconds < 5 * std.time.ns_per_s);
}

test "child input stderr limit cancels blocked writer" {
    const bytes = try f.payload(2 * 1024 * 1024);

    defer f.allocator.free(bytes);

    var options = f.options(&.{"duplex"});
    options.max_stderr_bytes = 1;
    const started = std.Io.Timestamp.now(f.io, .awake);

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = bytes }));
    try std.testing.expect(started.durationTo(std.Io.Timestamp.now(f.io, .awake)).nanoseconds < 5 * std.time.ns_per_s);
}

test "child input early close reports failure while child keeps stdout open" {
    const bytes = try f.payload(2 * 1024 * 1024);

    defer f.allocator.free(bytes);

    const options = f.options(&.{"close"});
    const started = std.Io.Timestamp.now(f.io, .awake);

    try std.testing.expectError(error.BrokenPipe, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = bytes }));

    const elapsed = started.durationTo(std.Io.Timestamp.now(f.io, .awake));

    try std.testing.expect(elapsed.nanoseconds < 5 * std.time.ns_per_s);
}

test "child input repeated failed limits allow a later invocation" {
    var options = f.options(&.{"mirror"});
    options.max_stderr_bytes = 0;

    for (0..8) |_| try std.testing.expectError(error.StreamTooLong, f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = "x" }));

    try f.expect(f.options(&.{"echo"}), "recovered", "recovered", "", 0);
}
