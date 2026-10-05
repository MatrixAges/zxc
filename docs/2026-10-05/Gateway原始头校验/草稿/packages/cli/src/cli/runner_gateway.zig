const std = @import("std");
const application = @import("application");

pub fn main(init: std.process.Init) !void {
    const address = try std.Io.net.IpAddress.parseLiteral(application.listen);
    var listener = try address.listen(init.io, .{ .reuse_address = true });

    defer listener.deinit(init.io);

    var state = application.State{ .arena = init.arena };

    defer state.deinit();

    try state.initialize();

    const head_buffer = try init.gpa.alloc(u8, application.max_header_bytes);

    defer init.gpa.free(head_buffer);

    while (true) {
        const stream = try listener.accept(init.io);

        defer {
            stream.shutdown(init.io, .both) catch {};
            stream.close(init.io);
        }

        handle(init, &state, stream, head_buffer) catch |err| {
            if (err == error.OutOfMemory or err == error.Canceled) return err;

            std.log.err("Gateway connection failed: {s}", .{@errorName(err)});
        };
    }
}

fn handle(init: std.process.Init, state: *application.State, stream: std.Io.net.Stream, head_buffer: []u8) !void {
    var output_buffer: [4096]u8 = undefined;
    var input = stream.reader(init.io, head_buffer);
    var output = stream.writer(init.io, &output_buffer);
    var server = std.http.Server.init(&input.interface, &output.interface);

    var request = server.receiveHead() catch |err| {
        try checkCanceled(input.err, output.err);

        if (err == error.HttpConnectionClosing) return;

        const status: []const u8 = if (err == error.HttpHeadersOversize) "431 Request Header Fields Too Large" else "400 Bad Request";

        try output.interface.print("HTTP/1.1 {s}\r\nconnection: close\r\ncontent-length: 0\r\n\r\n", .{status});
        try output.interface.flush();

        return;
    };

    var scope = state.request();

    defer scope.deinit();

    application.dispatch(&scope, init.io, init.minimal, &request) catch |err| {
        try checkCanceled(input.err, output.err);

        return err;
    };

    try checkCanceled(input.err, output.err);
}

fn checkCanceled(input: ?anyerror, output: ?anyerror) error{Canceled}!void {
    if (input) |err| if (err == error.Canceled) return error.Canceled;
    if (output) |err| if (err == error.Canceled) return error.Canceled;
}
