const std = @import("std");
const bundle = @import("bundle");

pub fn run(io: std.Io, allocator: std.mem.Allocator, directory: std.Io.Dir) !void {
    try verify(bundle.zig_archive, bundle.zig_digest);
    try verify(bundle.archive, bundle.resources_digest);

    if (bundle.zig_format == .zip) {
        {
            const file = try directory.createFile(io, "zig.zip", .{});

            defer file.close(io);

            try file.writeStreamingAll(io, bundle.zig_archive);
        }

        {
            const file = try directory.openFile(io, "zig.zip", .{});

            defer file.close(io);

            var buffer: [65536]u8 = undefined;
            var reader = file.reader(io, &buffer);

            try std.zip.extract(directory, &reader, .{});
        }

        try directory.deleteFile(io, "zig.zip");
    } else {
        var input: std.Io.Reader = .fixed(bundle.zig_archive);
        var decompressed = try std.compress.xz.Decompress.init(&input, allocator, &.{});

        defer decompressed.deinit();

        try std.tar.extract(io, directory, &decompressed.reader, .{});

        var remaining: [65536]u8 = undefined;

        while (try decompressed.reader.readSliceShort(&remaining) != 0) {}
    }

    try directory.rename(bundle.zig_directory, directory, "zig", io);

    var input: std.Io.Reader = .fixed(bundle.archive);
    const buffer = try allocator.alloc(u8, std.compress.flate.max_window_len);

    defer allocator.free(buffer);

    var decompressed = std.compress.flate.Decompress.init(&input, .gzip, buffer);

    try std.tar.extract(io, directory, &decompressed.reader, .{});

    _ = try decompressed.reader.discardRemaining();
}

fn verify(bytes: []const u8, expected: []const u8) !void {
    var hash: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(bytes, &hash, .{});

    if (!std.mem.eql(u8, &std.fmt.bytesToHex(hash, .lower), expected)) return error.CorruptBundledToolchain;
}
