fn readBody(allocator: std.mem.Allocator, request: *std.http.Server.Request) !?[]const u8 {
    if (request.head.expect) |expect| {
        if (!std.ascii.eqlIgnoreCase(expect, "100-continue")) {
            try respond(request, .expectation_failed, "unsupported expectation", &.{});

            return null;
        }

        request.head.expect = "100-continue";
    }

    if (request.head.transfer_compression != .identity) {
        try respond(request, .unsupported_media_type, "compressed input is unsupported", &.{});

        return null;
    }

    if ((request.head.content_length orelse 0) > max_body_bytes) {
        try respond(request, .payload_too_large, "request body too large", &.{});

        return null;
    }

    const flush = request.head.expect != null;

    try request.writeExpectContinue();
    if (flush) try request.server.out.flush();

    var buffer: [4096]u8 = undefined;
    const length = if (request.head.transfer_encoding == .none) request.head.content_length orelse 0 else null;
    const reader = request.server.reader.bodyReader(&buffer, request.head.transfer_encoding, length);

    const body = reader.allocRemaining(allocator, .limited(max_body_bytes +| 1)) catch |err| {
        if (err == error.OutOfMemory) return err;

        if (err == error.StreamTooLong) {
            try respond(request, .payload_too_large, "request body too large", &.{});
        } else try respond(request, .bad_request, "invalid request body", &.{});

        return null;
    };

    if (body.len > max_body_bytes) {
        try respond(request, .payload_too_large, "request body too large", &.{});

        return null;
    }

    if (request.server.reader.state != .ready) {
        try respond(request, .bad_request, "truncated request body", &.{});

        return null;
    }

    return body;
}

fn respond(request: *std.http.Server.Request, status: std.http.Status, body: []const u8, headers: []const std.http.Header) !void {
    request.head.expect = null;

    try request.respond(body, .{ .status = status, .keep_alive = false, .extra_headers = headers });
}
