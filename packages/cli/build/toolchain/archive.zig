const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
pub const Release = struct { host: []const u8, archive: []const u8, archive_sha256: []const u8 };
const Releases = struct { version: []const u8, releases: []const Release };

pub fn find(allocator: std.mem.Allocator, host: []const u8) !struct { version: []const u8, release: Release } {
    const releases = try std.json.parseFromSliceLeaky(Releases, allocator, @embedFile("releases.json"), .{});
    const zig_host = if (std.mem.eql(u8, host, "aarch64-windows")) "x86_64-windows" else host;

    for (releases.releases) |release| {
        if (std.mem.eql(u8, release.host, zig_host)) return .{ .version = releases.version, .release = release };
    }

    return error.UnsupportedZigHost;
}

pub fn prepare(io: std.Io, allocator: std.mem.Allocator, release: Release, local: []const u8, destination: []const u8) !void {
    const file = try std.Io.Dir.cwd().createFile(io, destination, .{});

    defer file.close(io);

    var output_buffer: [65536]u8 = undefined;
    var hash_buffer: [65536]u8 = undefined;
    var output = file.writer(io, &output_buffer);
    var hashed = std.Io.Writer.Hashed(Sha256).initHasher(&output.interface, .init(.{}), &hash_buffer);

    if (local.len != 0) {
        const input = try std.Io.Dir.cwd().openFile(io, local, .{});

        defer input.close(io);

        var input_buffer: [65536]u8 = undefined;
        var reader = input.reader(io, &input_buffer);

        _ = try reader.interface.streamRemaining(&hashed.writer);
    } else {
        var client: std.http.Client = .{ .allocator = allocator, .io = io };

        defer client.deinit();

        const result = try client.fetch(.{ .location = .{ .url = release.archive }, .response_writer = &hashed.writer });

        if (result.status != .ok) return error.ZigDownloadFailed;
    }

    try hashed.writer.flush();
    try output.interface.flush();

    const digest = std.fmt.bytesToHex(hashed.hasher.finalResult(), .lower);

    if (!std.mem.eql(u8, &digest, release.archive_sha256)) return error.ZigArchiveChecksumMismatch;
}
