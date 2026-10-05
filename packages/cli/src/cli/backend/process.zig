const std = @import("std");
const protocol = @import("protocol.zig");

pub fn run(io: std.Io, allocator: std.mem.Allocator, arguments: []const []const u8, environment: *const std.process.Environ.Map) !protocol.Result {
    var child = try std.process.spawn(io, .{
        .argv = arguments,
        .environ_map = environment,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .pipe,
    });

    defer child.kill(io);

    const Header = std.zig.Client.Message.Header;
    var request_buffer: [2 * @sizeOf(Header)]u8 = undefined;
    var request = child.stdin.?.writer(io, &request_buffer);

    try request.interface.writeStruct(Header{ .tag = .update, .bytes_len = 0 }, .little);
    try request.interface.writeStruct(Header{ .tag = .exit, .bytes_len = 0 }, .little);
    try request.interface.flush();

    child.stdin.?.close(io);

    child.stdin = null;
    var buffer: std.Io.File.MultiReader.Buffer(2) = undefined;
    var reader: std.Io.File.MultiReader = undefined;

    reader.init(allocator, io, buffer.toStreams(), &.{ child.stdout.?, child.stderr.? });
    defer reader.deinit();

    while (reader.fill(4096, .none)) |_| {
        if (reader.reader(0).buffered().len > 128 * 1024 * 1024 or reader.reader(1).buffered().len > 128 * 1024 * 1024) return error.BackendOutputTooLarge;
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    try reader.checkAnyError();

    const termination = try child.wait(io);

    if (arguments.len > 1 and std.mem.eql(u8, arguments[1], "translate-c")) return protocol.decodeTranslation(allocator, reader.reader(0).buffered(), reader.reader(1).buffered(), termination);

    return protocol.decode(allocator, reader.reader(0).buffered(), reader.reader(1).buffered(), termination);
}
