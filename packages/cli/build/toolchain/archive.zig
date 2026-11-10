const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
const maximum_attempts = 3;
const retry_delay_ms = 250;
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

pub fn prepare(comptime local_archive: bool, io: std.Io, allocator: std.mem.Allocator, release: Release, local: []const u8, destination: []const u8) !void {
    if (local_archive) return transfer(local_archive, io, allocator, release, local, destination);

    var attempt: u32 = 1;

    while (true) : (attempt += 1) {
        transfer(local_archive, io, allocator, release, local, destination) catch |err| {
            if (attempt == maximum_attempts or !retryable(err)) return err;

            std.log.warn("Zig download attempt {d}/{d} failed: {t}; retrying", .{ attempt, maximum_attempts, err });

            try io.sleep(.fromMilliseconds(retry_delay_ms * attempt), .awake);

            continue;
        };

        return;
    }
}

fn transfer(comptime local_archive: bool, io: std.Io, allocator: std.mem.Allocator, release: Release, local: []const u8, destination: []const u8) !void {
    const file = try std.Io.Dir.cwd().createFile(io, destination, .{});

    errdefer std.Io.Dir.cwd().deleteFile(io, destination) catch {};

    defer file.close(io);

    var output_buffer: [65536]u8 = undefined;
    var hash_buffer: [65536]u8 = undefined;
    var output = file.writer(io, &output_buffer);
    var hashed = std.Io.Writer.Hashed(Sha256).initHasher(&output.interface, .init(.{}), &hash_buffer);

    if (local_archive) {
        const input = try std.Io.Dir.cwd().openFile(io, local, .{});

        defer input.close(io);

        var input_buffer: [65536]u8 = undefined;
        var reader = input.reader(io, &input_buffer);

        _ = try reader.interface.streamRemaining(&hashed.writer);
    } else {
        var scratch = std.heap.ArenaAllocator.init(allocator);

        defer scratch.deinit();

        var client: std.http.Client = .{ .allocator = scratch.allocator(), .io = io };

        defer client.deinit();

        const result = try client.fetch(.{ .location = .{ .url = release.archive }, .response_writer = &hashed.writer });

        if (result.status != .ok) return error.ZigDownloadFailed;
    }

    try hashed.writer.flush();
    try output.interface.flush();

    const digest = std.fmt.bytesToHex(hashed.hasher.finalResult(), .lower);

    if (!std.mem.eql(u8, &digest, release.archive_sha256)) return error.ZigArchiveChecksumMismatch;
}

fn retryable(err: anyerror) bool {
    return switch (err) {
        error.TlsInitializationFailed,
        error.ConnectionResetByPeer,
        error.ConnectionRefused,
        error.NetworkUnreachable,
        error.Timeout,
        error.ReadFailed,
        error.EndOfStream,
        => true,
        else => false,
    };
}
