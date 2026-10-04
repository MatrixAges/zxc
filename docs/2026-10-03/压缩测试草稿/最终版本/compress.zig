const std = @import("std");
const flate = std.compress.flate;
const abi = @import("zxc_abi").native.@"std:zlib";

pub fn compress(allocator: std.mem.Allocator, input: abi.CompressOptions, container: flate.Container) ![]const u8 {
    if (input.level < -1 or input.level > 9) return error.InvalidCompressionLevel;

    var output = try std.Io.Writer.Allocating.initCapacity(allocator, 4096);

    defer output.deinit();

    if (input.level == 0) {
        @import("stored.zig").write(&output.writer, input.data, container) catch return error.OutOfMemory;

        return output.toOwnedSlice();
    }

    const buffer = try allocator.alloc(u8, flate.max_window_len);

    defer allocator.free(buffer);

    const options: flate.Compress.Options = switch (input.level) {
        -1, 6 => .level_6,
        1 => .level_1,
        2 => .level_2,
        3 => .level_3,
        4 => .level_4,
        5 => .level_5,
        7 => .level_7,
        8 => .level_8,
        9 => .level_9,
        else => unreachable,
    };
    var compressor = flate.Compress.init(&output.writer, buffer, container, options) catch return error.OutOfMemory;

    compressor.writer.writeAll(input.data) catch return error.OutOfMemory;
    compressor.finish() catch return error.OutOfMemory;

    return output.toOwnedSlice();
}
