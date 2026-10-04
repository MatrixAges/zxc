const std = @import("std");
const f = @import("fixture.zig");

test "fs writeFile replaces existing contents and removes the old suffix" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "old-long-content");
    try f.fs.writeFile(f.io, &.{ .path = try fixture.path("data"), .data = "\x00\xffA" });
    try fixture.expectContent("data", "\x00\xffA");
}

test "fs writeFile creates and truncates empty files" {
    var fixture = try f.init();

    defer fixture.deinit();

    const path = try fixture.path("data");

    try f.fs.writeFile(f.io, &.{ .path = path, .data = "" });
    try fixture.expectContent("data", "");
    try fixture.write("data", "previous");
    try f.fs.writeFile(f.io, &.{ .path = path, .data = "" });
    try fixture.expectContent("data", "");
}

test "fs writeText stores valid Unicode and embedded NUL byte for byte" {
    var fixture = try f.init();

    defer fixture.deinit();

    const text = "文档 🌿\x00\n";

    try f.fs.writeText(f.io, &.{ .path = try fixture.path("文本"), .text = text });
    try fixture.expectContent("文本", text);
}

test "fs invalid writeText preserves existing content and does not create new files" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("existing", "keep");

    for ([_][]const u8{ "existing", "missing" }) |name| {
        try std.testing.expectError(error.InvalidUtf8, f.fs.writeText(f.io, &.{ .path = try fixture.path(name), .text = "\xff" }));
    }

    try fixture.expectContent("existing", "keep");
    try fixture.expectMissing("missing");
}

test "fs truncate shrinks to a byte prefix and clears at zero" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "abcdef");

    const path = try fixture.path("data");

    try f.fs.truncate(f.io, &.{ .path = path, .length = 3 });
    try fixture.expectContent("data", "abc");
    try f.fs.truncate(f.io, &.{ .path = path, .length = 0 });
    try fixture.expectContent("data", "");
}

test "fs truncate extends with zero bytes while preserving the prefix" {
    var fixture = try f.init();

    defer fixture.deinit();

    try fixture.write("data", "abc");
    try f.fs.truncate(f.io, &.{ .path = try fixture.path("data"), .length = 6 });
    try fixture.expectContent("data", "abc\x00\x00\x00");
}

test "fs truncate missing file reports failure without creating it" {
    var fixture = try f.init();

    defer fixture.deinit();

    try std.testing.expectError(error.FileNotFound, f.fs.truncate(f.io, &.{ .path = try fixture.path("missing"), .length = 3 }));
    try fixture.expectMissing("missing");
}
