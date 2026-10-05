const std = @import("std");
const f = @import("fixture.zig");

test "child process captures literal arguments without shell evaluation" {
    try f.expect(f.options(&.{ "args", "", "two words", "'\";$()|*", "中文 🌿", "line\nnext" }), "\x00two words\x00'\";$()|*\x00中文 🌿\x00line\nnext\x00", "", 0);
}

test "child process preserves arbitrary stdout and stderr bytes" {
    try f.expect(f.options(&.{"bytes"}), &.{ 0, 255, 128, 13, 10 }, &.{ 254, 0, 127 }, 0);
}

test "child process returns nonzero exit status as a result" {
    try f.expect(f.options(&.{ "exit", "73" }), "", "", 73);
}

test "child process preserves maximum normalized exit code" {
    try f.expect(f.options(&.{ "exit", "255" }), "", "", 255);
}

test "child process stdin is EOF" {
    try f.expect(f.options(&.{"stdin"}), "eof", "", 0);
}

test "child process null environment inherits controlled variable" {
    try f.expect(f.options(&.{"env"}), "inherited-test-value", "", 0);
}

test "child process empty environment does not inherit controlled variable" {
    var input = f.options(&.{"env"});

    input.env = &.{};

    try f.expect(input, "<missing>", "", 0);
}

test "child process explicit environment replaces inherited value" {
    var input = f.options(&.{"env"});
    input.env = &.{&.{ .name = "ZXC_CHILD_TEST_VALUE", .value = "value 🌿 with spaces" }};

    try f.expect(input, "value 🌿 with spaces", "", 0);
}

test "child process duplicate environment key uses final entry" {
    var input = f.options(&.{"env"});

    input.env = &.{ &.{ .name = "ZXC_CHILD_TEST_VALUE", .value = "first" }, &.{ .name = "ZXC_CHILD_TEST_VALUE", .value = "last" } };

    try f.expect(input, "last", "", 0);
}

test "child process empty environment value is not missing" {
    var input = f.options(&.{"env"});

    input.env = &.{&.{ .name = "ZXC_CHILD_TEST_VALUE", .value = "" }};

    try f.expect(input, "", "", 0);
}

test "child process cwd is explicit and leaves parent cwd unchanged" {
    var temporary = std.testing.tmpDir(.{});

    defer temporary.cleanup();

    const cwd = try temporary.dir.realPathFileAlloc(f.io, ".", f.allocator);

    defer f.allocator.free(cwd);

    const before = try std.Io.Dir.cwd().realPathFileAlloc(f.io, ".", f.allocator);

    defer f.allocator.free(before);

    var input = f.options(&.{"cwd"});

    input.cwd = cwd;

    try f.expect(input, cwd, "", 0);
    try f.expect(f.options(&.{"cwd"}), before, "", 0);
}

test "child process output limits include exact endpoints" {
    var input = f.options(&.{"bytes"});

    input.max_stdout_bytes = 5;
    input.max_stderr_bytes = 3;

    try f.expect(input, &.{ 0, 255, 128, 13, 10 }, &.{ 254, 0, 127 }, 0);
}

test "child process zero limits accept empty streams" {
    var input = f.options(&.{ "exit", "0" });
    input.max_stdout_bytes = 0;
    input.max_stderr_bytes = 0;

    try f.expect(input, "", "", 0);
}

test "child process stdout overflow rejects full result" {
    var input = f.options(&.{"bytes"});

    input.max_stdout_bytes = 4;

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSync(f.allocator, f.io, &input));
}

test "child process stderr overflow rejects full result" {
    var input = f.options(&.{"bytes"});

    input.max_stderr_bytes = 2;

    try std.testing.expectError(error.StreamTooLong, f.child.spawnSync(f.allocator, f.io, &input));
}

test "child process captures both streams beyond pipe capacity" {
    var input = f.options(&.{ "streams", "262144" });

    input.max_stdout_bytes = 262144;
    input.max_stderr_bytes = 262144;

    const result = try f.child.spawnSync(f.allocator, f.io, &input);

    defer f.free(f.allocator, result);

    try std.testing.expectEqual(f.child.TerminationKind.Exited, result.kind);
    try std.testing.expectEqual(@as(u32, 0), result.code);
    try std.testing.expectEqual(@as(usize, 262144), result.stdout.len);
    try std.testing.expectEqual(@as(usize, 262144), result.stderr.len);
    for (result.stdout) |byte| try std.testing.expectEqual(@as(u8, 'o'), byte);
    for (result.stderr) |byte| try std.testing.expectEqual(@as(u8, 'e'), byte);
}

test "child process output survives a later invocation" {
    const input = f.options(&.{ "args", "first" });
    const first = try f.child.spawnSync(f.allocator, f.io, &input);

    defer f.free(f.allocator, first);

    try f.expect(f.options(&.{ "args", "second" }), "second\x00", "", 0);
    try std.testing.expectEqualSlices(u8, "first\x00", first.stdout);
}

test "child process reports POSIX signal termination" {
    if (@import("builtin").os.tag == .windows) return error.SkipZigTest;

    const input = f.options(&.{"signal"});
    const result = try f.child.spawnSync(f.allocator, f.io, &input);

    defer f.free(f.allocator, result);

    try std.testing.expectEqual(f.child.TerminationKind.Signal, result.kind);
    try std.testing.expectEqual(@as(u32, @intFromEnum(std.posix.SIG.TERM)), result.code);
}

test "child process accepts maximum u64 output limits" {
    var input = f.options(&.{"bytes"});
    input.max_stdout_bytes = std.math.maxInt(u64);
    input.max_stderr_bytes = std.math.maxInt(u64);

    try f.expect(input, &.{ 0, 255, 128, 13, 10 }, &.{ 254, 0, 127 }, 0);
}

test "child process repeated stream failures allow later successful execution" {
    var input = f.options(&.{ "streams", "8192" });

    input.max_stdout_bytes = 0;

    for (0..16) |_| try std.testing.expectError(error.StreamTooLong, f.child.spawnSync(f.allocator, f.io, &input));

    try f.expect(f.options(&.{ "exit", "0" }), "", "", 0);
}
