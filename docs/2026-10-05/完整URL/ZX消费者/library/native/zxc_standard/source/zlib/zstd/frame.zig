const std = @import("std");
const Frame = std.compress.zstd.Decompress.Frame;

pub const Result = struct {
    length: usize,
    window_length: u32 = 0,
    content_size: ?usize = null,
    checksum: ?u32 = null,
    skippable: bool = false,
};

pub fn read(data: []const u8, max_window_length: u32) !Result {
    var source = std.Io.Reader.fixed(data);
    const magic = try source.takeEnumNonexhaustive(Frame.Magic, .little);

    switch (magic.kind() orelse return error.BadMagic) {
        .skippable => {
            const length = try source.takeInt(u32, .little);

            _ = try source.take(length);

            return .{ .length = source.seek, .skippable = true };
        },
        .zstandard => {},
    }

    const header = try Frame.Zstandard.Header.decode(&source);
    const frame = try Frame.init(header, max_window_length, false);

    while (true) {
        const block = try source.takeStruct(Frame.Zstandard.Block.Header, .little);

        if (block.size > frame.block_size_max) return error.BlockOversize;

        const length = switch (block.type) {
            .raw, .compressed => block.size,
            .rle => 1,
            .reserved => return error.ReservedBlock,
        };

        _ = try source.take(length);

        if (block.last) break;
    }

    const checksum = if (frame.has_checksum) try source.takeInt(u32, .little) else null;

    return .{
        .length = source.seek,
        .window_length = @intCast(frame.window_size),
        .content_size = frame.content_size,
        .checksum = checksum,
    };
}
