const std = @import("std");
const program = @import("program");
const f = @import("fixture");

fn request(fixture: *f, text: []const u8, length: u64) !std.meta.Child(program.Input) {
    return .{
        .source = try fixture.path("source"),
        .copy = try fixture.path("copy"),
        .destination = try fixture.path("destination"),
        .text = text,
        .max_bytes = 1024,
        .length = length,
        .exclusive = true,
    };
}

fn success(allocator: std.mem.Allocator, text: []const u8, expected: []const u8) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input = try request(&fixture, text, expected.len);
    const output = try program.execute(&arena, &input, f.io);

    try std.testing.expectEqualStrings(text, output.before);
    try std.testing.expectEqualStrings(expected, output.after);
    try fixture.expectContent("source", text);
    try fixture.expectMissing("copy");
    try fixture.expectContent("destination", expected);
}

test "generated RX IO executes discarded void calls for empty files" {
    try success(f.allocator, "", "");
}

test "generated RX IO copy rename truncate preserve observable order" {
    try success(f.allocator, "abcdef", "abc");
}

test "generated RX IO preserves multibyte text before byte truncation" {
    try success(f.allocator, "你好 🌿", "你好");
}

test "generated RX IO truncation extension is visible to the following read" {
    try success(f.allocator, "abc", "abc\x00\x00");
}

test "generated RX IO earlier returned buffers survive later calls" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var input = try request(&fixture, "abcdef", 3);
    const first = try program.execute(&arena, &input, f.io);

    input.text = "123456";
    input.length = 2;

    const second = try program.execute(&arena, &input, f.io);

    try std.testing.expectEqualStrings("abcdef", first.before);
    try std.testing.expectEqualStrings("abc", first.after);
    try std.testing.expectEqualStrings("123456", second.before);
    try std.testing.expectEqualStrings("12", second.after);
}

test "generated RX IO first void call failure prevents every later side effect" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    try fixture.write("source", "keep");

    var input = try request(&fixture, "changed", 2);

    input.source = try fixture.path("source\x00suffix");

    try std.testing.expectError(error.InvalidPath, program.execute(&arena, &input, f.io));
    try fixture.expectContent("source", "keep");
    try fixture.expectMissing("copy");
    try fixture.expectMissing("destination");
}

test "generated RX IO read failure preserves completed write and prevents copy" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var input = try request(&fixture, "abcdef", 2);

    input.max_bytes = 3;

    try std.testing.expectError(error.StreamTooLong, program.execute(&arena, &input, f.io));
    try fixture.expectContent("source", "abcdef");
    try fixture.expectMissing("copy");
    try fixture.expectMissing("destination");
}

test "generated RX IO middle void call failure prevents rename and truncation" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    try fixture.write("copy", "existing-copy");
    try fixture.write("destination", "existing-destination");

    const input = try request(&fixture, "new-source", 1);

    try std.testing.expectError(error.PathAlreadyExists, program.execute(&arena, &input, f.io));
    try fixture.expectContent("source", "new-source");
    try fixture.expectContent("copy", "existing-copy");
    try fixture.expectContent("destination", "existing-destination");
}

test "generated RX IO final read limit failure retains completed file operations" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var input = try request(&fixture, "abc", 5);

    input.max_bytes = 3;

    try std.testing.expectError(error.StreamTooLong, program.execute(&arena, &input, f.io));
    try fixture.expectContent("source", "abc");
    try fixture.expectMissing("copy");
    try fixture.expectContent("destination", "abc\x00\x00");
}

test "generated RX IO final UTF8 failure occurs after byte truncation" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    const input = try request(&fixture, "你", 1);

    try std.testing.expectError(error.InvalidUtf8, program.execute(&arena, &input, f.io));
    try fixture.expectContent("source", "你");
    try fixture.expectMissing("copy");
    try fixture.expectContent("destination", "\xe4");
}

test "generated RX IO releases every failed arena allocation without hiding IO errors" {
    try std.testing.checkAllAllocationFailures(f.allocator, success, .{ @as([]const u8, "abcdef"), @as([]const u8, "abc") });
}

fn denyOpen(_: ?*anyopaque, _: std.Io.Dir, _: []const u8, _: std.Io.Dir.OpenFileOptions) std.Io.File.OpenError!std.Io.File {
    return error.AccessDenied;
}

test "generated RX IO forwards the provided host to native file reads" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var vtable = f.io.vtable.*;
    vtable.dirOpenFile = denyOpen;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    const input = try request(&fixture, "payload", 3);

    try std.testing.expectError(error.AccessDenied, program.execute(&arena, &input, io));
    try fixture.expectContent("source", "payload");
    try fixture.expectMissing("copy");
    try fixture.expectMissing("destination");
}

fn denyRename(_: ?*anyopaque, _: std.Io.Dir, _: []const u8, _: std.Io.Dir, _: []const u8) std.Io.Dir.RenameError!void {
    return error.ReadOnlyFileSystem;
}

test "generated RX IO forwards the provided host through discarded void calls" {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(f.allocator);

    defer arena.deinit();

    var vtable = f.io.vtable.*;
    vtable.dirRename = denyRename;
    const io = std.Io{ .userdata = f.io.userdata, .vtable = &vtable };
    const input = try request(&fixture, "payload", 3);

    try std.testing.expectError(error.ReadOnlyFileSystem, program.execute(&arena, &input, io));
    try fixture.expectContent("source", "payload");
    try fixture.expectContent("copy", "payload");
    try fixture.expectMissing("destination");
}
