const std = @import("std");
const flate = std.compress.flate;
const abi = @import("zxc_abi").native.@"std:zlib";
const header = @import("header.zig");

pub fn decompress(allocator: std.mem.Allocator, input: abi.DecompressOptions, container: flate.Container) ![]const u8 {
    var source = std.Io.Reader.fixed(input.data);
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    const buffer = try allocator.alloc(u8, flate.max_window_len);

    defer allocator.free(buffer);

    while (true) {
        try header.validate(source.buffer[source.seek..source.end], container);

        var decoder = flate.Decompress.init(&source, container, buffer);
        const start = output.items.len;
        const remaining = input.max_output_length - output.items.len;

        decoder.reader.appendRemaining(allocator, &output, .limited(remaining)) catch |err| {
            switch (err) {
                error.StreamTooLong => {
                    if (decoder.reader.peekByte()) |_| {
                        return error.OutputTooLarge;
                    } else |end| switch (end) {
                        error.EndOfStream => {},
                        error.ReadFailed => return decoder.err orelse error.InvalidCompressedData,
                    }
                },
                error.ReadFailed => return decoder.err orelse error.InvalidCompressedData,
                else => return err,
            }
        };

        const member = output.items[start..];

        switch (decoder.container_metadata) {
            .raw => {},
            .zlib => |metadata| {
                if (metadata.adler != std.hash.Adler32.hash(member)) return error.InvalidChecksum;
            },
            .gzip => |metadata| {
                if (metadata.crc != std.hash.Crc32.hash(member)) return error.InvalidChecksum;
                if (metadata.count != @as(u32, @truncate(member.len))) return error.InvalidLength;
            },
        }

        if (source.seek == source.end) break;
        if (container != .gzip) return error.TrailingData;
    }

    return output.toOwnedSlice(allocator);
}
