const std = @import("std");
const maximum = @import("../archive.zig").maximum_archive;

pub fn read(io: std.Io, allocator: std.mem.Allocator, source: []const u8, base: []const u8) ![]u8 {
    if (!std.mem.startsWith(u8, source, "https://") and !std.mem.startsWith(u8, source, "http://")) {
        const path = try std.fs.path.resolve(allocator, &.{ base, source });

        defer allocator.free(path);

        const bytes = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(maximum + 1));

        errdefer allocator.free(bytes);

        if (bytes.len > maximum) return error.PackageArchiveTooLarge;

        return bytes;
    }

    var client: std.http.Client = .{ .allocator = allocator, .io = io };

    defer client.deinit();

    var request = try client.request(.GET, try std.Uri.parse(source), .{ .redirect_behavior = @enumFromInt(3), .headers = .{ .accept_encoding = .{ .override = "identity" } } });

    defer request.deinit();

    errdefer if (request.connection) |connection| {
        connection.closing = true;
    };

    try request.sendBodiless();

    var redirect_buffer: [8192]u8 = undefined;
    var response = try request.receiveHead(&redirect_buffer);

    if (response.head.status != .ok) return error.PackageDownloadFailed;
    if (response.head.content_encoding != .identity) return error.UnsupportedPackageContentEncoding;
    if (response.head.content_length) |length| if (length > maximum) return error.PackageArchiveTooLarge;

    var buffer: [65536]u8 = undefined;

    return response.reader(&buffer).allocRemaining(allocator, .limited(maximum));
}
