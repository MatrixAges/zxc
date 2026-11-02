const std = @import("std");

pub fn validate(input: []const u8, container: std.compress.flate.Container) !void {
    switch (container) {
        .raw => {},
        .zlib => {
            if (input.len < 2) return error.TruncatedInput;
            if (input[0] & 15 != 8 or input[0] >> 4 > 7) return error.InvalidHeader;
            if (std.mem.readInt(u16, input[0..2], .big) % 31 != 0) return error.InvalidHeader;
            if (input[1] & 0x20 != 0) return error.UnsupportedDictionary;
        },
        .gzip => try validateGzip(input),
    }
}

fn validateGzip(input: []const u8) !void {
    if (input.len < 10) return error.TruncatedInput;
    if (!std.mem.eql(u8, input[0..3], &.{ 0x1f, 0x8b, 8 }) or input[3] & 0xe0 != 0) return error.InvalidHeader;

    const flags = input[3];
    var index: usize = 10;

    if (flags & 4 != 0) {
        if (input.len - index < 2) return error.TruncatedInput;

        const length = std.mem.readInt(u16, input[index..][0..2], .little);

        index += 2;

        if (input.len - index < length) return error.TruncatedInput;

        index += length;
    }

    for ([_]u8{ 8, 16 }) |flag| {
        if (flags & flag == 0) continue;

        const length = std.mem.indexOfScalar(u8, input[index..], 0) orelse return error.TruncatedInput;

        index += length + 1;
    }

    if (flags & 2 != 0) {
        if (input.len - index < 2) return error.TruncatedInput;

        const checksum: u16 = @truncate(std.hash.Crc32.hash(input[0..index]));

        if (checksum != std.mem.readInt(u16, input[index..][0..2], .little)) return error.InvalidHeaderChecksum;
    }
}
