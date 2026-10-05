const std = @import("std");
pub const api = @import("standard").http;
pub const allocator = std.testing.allocator;
pub const Input = @typeInfo(api.Options).pointer.child;
pub const empty_response = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n";

pub fn input() Input {
    return .{ .url = "http://127.0.0.1:18000/path?key=value", .method = .Get, .headers = &.{}, .body = null, .max_body_bytes = 1024, .max_header_bytes = 8192 };
}

pub fn release(gpa: std.mem.Allocator, result: api.Response) void {
    for (result.headers) |entry| {
        gpa.free(entry.name);
        gpa.free(entry.value);
        gpa.destroy(entry);
    }

    gpa.free(result.headers);
    gpa.free(result.body);
    gpa.destroy(result);
}

pub fn header(result: api.Response, name: []const u8) ?[]const u8 {
    for (result.headers) |item| if (std.ascii.eqlIgnoreCase(item.name, name)) return item.value;

    return null;
}
