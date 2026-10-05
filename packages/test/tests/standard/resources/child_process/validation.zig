const std = @import("std");
const f = @import("fixture.zig");
var spawn_calls: usize = 0;

fn deny(_: ?*anyopaque, _: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    spawn_calls += 1;

    return error.AccessDenied;
}

fn reject(input: f.Options, expected: anyerror) !void {
    var vtable = f.io.vtable.*;
    vtable.processSpawn = deny;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    spawn_calls = 0;

    try std.testing.expectError(expected, f.child.spawnSync(f.allocator, io, &input));
    try std.testing.expectEqual(@as(usize, 0), spawn_calls);
}

test "child process rejects empty command before spawning" {
    var input = f.options(&.{});

    input.command = "";

    try reject(input, error.EmptyCommand);
}

test "child process validates command bytes before spawning" {
    var input = f.options(&.{});

    input.command = "valid\x00suffix";

    try reject(input, error.InvalidProcessArgument);

    input.command = "\xff";

    try reject(input, error.InvalidUtf8);
}

test "child process validates every argument before spawning" {
    var input = f.options(&.{ "valid", "bad\x00value" });

    try reject(input, error.InvalidProcessArgument);

    input.args = &.{ "valid", "\xc0\xaf" };

    try reject(input, error.InvalidUtf8);
}

test "child process validates cwd before spawning" {
    var input = f.options(&.{});

    input.cwd = "path\x00suffix";

    try reject(input, error.InvalidProcessArgument);

    input.cwd = "\xed\xa0\x80";

    try reject(input, error.InvalidUtf8);
}

test "child process validates environment names before spawning" {
    var input = f.options(&.{});

    input.env = &.{&.{ .name = "", .value = "x" }};

    try reject(input, error.InvalidEnvironmentName);

    input.env = &.{&.{ .name = "A=B", .value = "x" }};

    try reject(input, error.InvalidEnvironmentName);
}

test "child process validates environment name bytes before spawning" {
    var input = f.options(&.{});

    input.env = &.{&.{ .name = "A\x00B", .value = "x" }};

    try reject(input, error.InvalidProcessArgument);

    input.env = &.{&.{ .name = "\xff", .value = "x" }};

    try reject(input, error.InvalidUtf8);
}

test "child process validates environment value bytes before spawning" {
    var input = f.options(&.{});

    input.env = &.{&.{ .name = "A", .value = "x\x00y" }};

    try reject(input, error.InvalidProcessArgument);

    input.env = &.{&.{ .name = "A", .value = "\xf4\x90\x80\x80" }};

    try reject(input, error.InvalidUtf8);
}

test "child process forwards explicit IO spawn rejection" {
    var vtable = f.io.vtable.*;
    vtable.processSpawn = deny;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    const input = f.options(&.{ "exit", "0" });
    spawn_calls = 0;

    try std.testing.expectError(error.AccessDenied, f.child.spawnSync(f.allocator, io, &input));
    try std.testing.expectEqual(@as(usize, 1), spawn_calls);
}

test "child process reports missing executable" {
    var input = f.options(&.{});

    input.command = try std.fmt.allocPrint(f.allocator, "{s}.missing", .{f.executable});

    defer f.allocator.free(input.command);

    try std.testing.expectError(error.FileNotFound, f.child.spawnSync(f.allocator, f.io, &input));
}

test "child process empty cwd is not inherited cwd" {
    var input = f.options(&.{ "exit", "0" });

    input.cwd = "";

    try std.testing.expectError(error.FileNotFound, f.child.spawnSync(f.allocator, f.io, &input));
}

test "child process nonexistent cwd reports a spawn failure" {
    var input = f.options(&.{ "exit", "0" });
    input.cwd = try std.fmt.allocPrint(f.allocator, "{s}.missing-directory", .{f.executable});

    defer f.allocator.free(input.cwd.?);

    try std.testing.expectError(error.FileNotFound, f.child.spawnSync(f.allocator, f.io, &input));
}
