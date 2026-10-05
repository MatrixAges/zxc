const std = @import("std");

pub fn readStdin(allocator: std.mem.Allocator, io: std.Io, max_bytes: u64) ![]const u8 {
    var buffer: [4096]u8 = undefined;
    var reader = std.Io.File.stdin().readerStreaming(io, &buffer);

    return reader.interface.allocRemaining(allocator, .limited64(max_bytes +| 1));
}

pub fn readStdinText(allocator: std.mem.Allocator, io: std.Io, max_bytes: u64) ![]const u8 {
    const bytes = try readStdin(allocator, io, max_bytes);

    errdefer allocator.free(bytes);

    if (!std.unicode.utf8ValidateSlice(bytes)) return error.InvalidUtf8;

    return bytes;
}

pub fn writeStdout(io: std.Io, data: []const u8) !void {
    try write(.stdout(), io, data);
}

pub fn writeStdoutText(io: std.Io, text: []const u8) !void {
    if (!std.unicode.utf8ValidateSlice(text)) return error.InvalidUtf8;

    try writeStdout(io, text);
}

pub fn writeStderr(io: std.Io, data: []const u8) !void {
    try write(.stderr(), io, data);
}

pub fn writeStderrText(io: std.Io, text: []const u8) !void {
    if (!std.unicode.utf8ValidateSlice(text)) return error.InvalidUtf8;

    try writeStderr(io, text);
}

fn write(file: std.Io.File, io: std.Io, data: []const u8) !void {
    var buffer: [4096]u8 = undefined;
    var writer = file.writerStreaming(io, &buffer);

    try writer.interface.writeAll(data);
    try writer.interface.flush();
}
