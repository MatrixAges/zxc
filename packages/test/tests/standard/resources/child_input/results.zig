const std = @import("std");
const f = @import("fixture.zig");

test "child input empty bytes deliver EOF" {
    try f.expect(f.options(&.{"eof"}), &.{}, "eof", "", 0);
}

test "child input arbitrary bytes are preserved" {
    const bytes = [_]u8{ 0, 255, 128, 13, 10, 0, 1, 127 };

    try f.expect(f.options(&.{"echo"}), &bytes, &bytes, "", 0);
}

test "child input Unicode bytes are not interpreted as text" {
    try f.expect(f.options(&.{"echo"}), "你好 🌿\x00", "你好 🌿\x00", "", 0);
}

test "child input complete byte alphabet and chunk boundaries" {
    for ([_]usize{ 1, 255, 256, 8191, 8192, 8193, 65537 }) |count| {
        const bytes = try f.payload(count);

        defer f.allocator.free(bytes);

        try f.expect(f.options(&.{"echo"}), bytes, bytes, "", 0);
    }
}

test "child input stdout stderr and stdin exceed pipe capacity together" {
    const bytes = try f.payload(524288);

    defer f.allocator.free(bytes);

    var options = f.options(&.{"duplex"});
    options.max_stdout_bytes = 262144 + bytes.len;
    options.max_stderr_bytes = 262144;
    const result = try f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = bytes });

    defer f.free(f.allocator, result);

    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 0), result.code);
    try std.testing.expectEqual(@as(usize, 262144 + bytes.len), result.stdout.len);
    try std.testing.expectEqual(@as(usize, 262144), result.stderr.len);
    for (result.stdout[0..262144]) |byte| try std.testing.expectEqual(@as(u8, 'o'), byte);
    for (result.stderr) |byte| try std.testing.expectEqual(@as(u8, 'e'), byte);
    try std.testing.expectEqualSlices(u8, bytes, result.stdout[262144..]);
}

test "child input nonzero exit after draining preserves termination" {
    try f.expect(f.options(&.{"exit"}), "complete input", "", "", 73);
}

test "child input arguments remain literal" {
    try f.expect(f.options(&.{ "args", "", "two words", "'\";$()|*", "中文" }), "drain", "\x00two words\x00'\";$()|*\x00中文\x00", "", 0);
}

test "child input explicit environment is preserved" {
    var options = f.options(&.{"env"});
    options.env = &.{&.{ .name = "ZXC_CHILD_INPUT_VALUE", .value = "provided 🌿" }};

    try f.expect(options, "drain", "provided 🌿", "", 0);
}

test "child input empty environment does not inherit" {
    var options = f.options(&.{"env"});
    options.env = &.{};

    try f.expect(options, "drain", "missing", "", 0);
}

test "child input explicit cwd leaves host directory unchanged" {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    const cwd = try temporary.dir.realPathFileAlloc(f.io, ".", f.allocator);

    defer f.allocator.free(cwd);

    const before = try std.Io.Dir.cwd().realPathFileAlloc(f.io, ".", f.allocator);

    defer f.allocator.free(before);

    var options = f.options(&.{"cwd"});

    options.cwd = cwd;

    try f.expect(options, "drain", cwd, "", 0);

    const after = try std.Io.Dir.cwd().realPathFileAlloc(f.io, ".", f.allocator);

    defer f.allocator.free(after);

    try std.testing.expectEqualStrings(before, after);
}

test "child input signal termination after full input is preserved" {
    if (@import("builtin").os.tag == .windows) return error.SkipZigTest;

    const options = f.options(&.{"signal"});
    const result = try f.child.spawnSyncWithInput(f.allocator, f.io, &.{ .options = &options, .input = "complete" });

    defer f.free(f.allocator, result);

    try std.testing.expectEqual(f.child.TerminationKind.Signal, result.kind);
    try std.testing.expectEqual(@as(u32, @intFromEnum(std.posix.SIG.TERM)), result.code);
}
