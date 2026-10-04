const std = @import("std");

pub fn decode(allocator: std.mem.Allocator, source: []const u8, maximum: usize) ![]u8 {
    var input: std.Io.Reader = .fixed(source);
    const window = try allocator.alloc(u8, std.compress.flate.max_window_len);

    defer allocator.free(window);

    var decoder = std.compress.flate.Decompress.init(&input, .gzip, window);
    const output = try decoder.reader.allocRemaining(allocator, .limited(maximum));

    errdefer allocator.free(output);

    const metadata = decoder.container_metadata.gzip;

    if (metadata.crc != std.hash.Crc32.hash(output) or metadata.count != @as(u32, @truncate(output.len))) return error.InvalidPackageGzipChecksum;
    if (input.seek != source.len) return error.TrailingPackageGzipData;

    return output;
}
