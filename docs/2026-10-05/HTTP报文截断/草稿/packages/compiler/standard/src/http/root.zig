const std = @import("std");
const api = @import("zxc_abi").native.@"std:http";
const options = @import("options.zig");
const headers = @import("headers.zig");
pub const Method = api.Method;
pub const Header = api.Header;
pub const Options = api.Options;
pub const Response = api.Response;

pub fn request(allocator: std.mem.Allocator, io: std.Io, input: Options) !Response {
    const uri = try options.validate(input);
    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    const extra_headers = try headers.prepare(temporary.allocator(), input.headers);
    var client = std.http.Client{ .allocator = temporary.allocator(), .io = io, .read_buffer_size = @intCast(input.max_header_bytes) };

    defer client.deinit();

    var invocation = try client.request(options.method(input.method), uri, .{
        .redirect_behavior = .unhandled,
        .handle_continue = false,
        .keep_alive = false,
        .headers = .{ .user_agent = .omit, .accept_encoding = .omit, .authorization = .omit },
        .extra_headers = extra_headers,
    });

    invocation.connection.?.closing = true;

    defer invocation.deinit();

    if (invocation.method.requestHasBody()) {
        const payload = input.body orelse &.{};
        invocation.transfer_encoding = .{ .content_length = payload.len };
        var body = try invocation.sendBodyUnflushed(&.{});

        try body.writer.writeAll(payload);
        try body.end();
        try invocation.connection.?.flush();
    } else try invocation.sendBodiless();

    var response = try invocation.receiveHead(&.{});
    var head_bytes: u64 = 0;

    while (true) {
        head_bytes +|= response.head.bytes.len;

        if (head_bytes > input.max_header_bytes) return error.HttpHeadersTooLarge;
        if (response.head.status == .switching_protocols) return error.HttpUpgradeUnsupported;
        if (response.head.status.class() != .informational) break;

        response = try invocation.receiveHead(&.{});
    }

    const copied_headers = try headers.copy(allocator, response.head);

    errdefer headers.deinit(allocator, copied_headers);

    const no_body = invocation.method == .HEAD or response.head.status == .no_content or response.head.status == .not_modified;
    var buffer: [8192]u8 = undefined;
    const body = if (no_body) try allocator.alloc(u8, 0) else try response.reader(&buffer).allocRemaining(allocator, .limited64(input.max_body_bytes +| 1));

    errdefer allocator.free(body);

    if (body.len > input.max_body_bytes) return error.StreamTooLong;

    if (!no_body) switch (invocation.reader.state) {
        .ready, .body_none => {},
        else => return error.ReadFailed,
    };

    const result = try allocator.create(api.request.OutputValue);

    result.* = .{ .status = @intFromEnum(response.head.status), .headers = copied_headers, .body = body };

    return result;
}
