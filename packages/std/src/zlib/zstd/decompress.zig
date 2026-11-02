const std = @import("std");
const zstd = std.compress.zstd;
const abi = @import("zxc_abi").native.@"std:zlib";
const frame = @import("frame.zig");

pub fn decompress(allocator: std.mem.Allocator, input: abi.ZstdDecompressOptions) ![]const u8 {
    if (input.data.len == 0) return error.InvalidCompressedData;

    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    var offset: usize = 0;

    while (offset < input.data.len) {
        const member = try frame.read(input.data[offset..], input.max_window_length);
        const data = input.data[offset..][0..member.length];

        offset += member.length;

        if (member.skippable) continue;

        const remaining = input.max_output_length - output.items.len;

        if (member.content_size) |size| {
            if (size > remaining) return error.OutputTooLarge;
        }

        const capacity = std.math.add(u32, member.window_length, zstd.block_size_max) catch return error.WindowOversize;
        const buffer = try allocator.alloc(u8, capacity);

        defer allocator.free(buffer);

        var source = std.Io.Reader.fixed(data);
        var decoder = zstd.Decompress.init(&source, buffer, .{ .window_len = member.window_length });
        const start = output.items.len;

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

        if (member.checksum) |checksum| {
            const actual: u32 = @truncate(std.hash.XxHash64.hash(0, output.items[start..]));

            if (actual != checksum) return error.InvalidChecksum;
        }
    }

    return output.toOwnedSlice(allocator);
}
