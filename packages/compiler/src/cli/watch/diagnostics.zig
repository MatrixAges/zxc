const std = @import("std");

pub fn key(allocator: std.mem.Allocator, message: []const u8) ![]const u8 {
    const prefix = ".zxc" ++ std.fs.path.sep_str ++ "cache" ++ std.fs.path.sep_str ++ "backend" ++ std.fs.path.sep_str ++ "tmp" ++ std.fs.path.sep_str;
    var output: std.Io.Writer.Allocating = .init(allocator);
    var remaining = message;

    while (std.mem.indexOf(u8, remaining, prefix)) |start| {
        const end = start + prefix.len;
        const tail = remaining[end..];
        const separator = std.mem.indexOfScalar(u8, tail, std.fs.path.sep) orelse break;
        const directory = tail[0..separator];

        try output.writer.writeAll(remaining[0..end]);

        if (directory.len == 16 and for (directory) |byte| {
            if (!std.ascii.isHex(byte)) break false;
        } else true) {
            try output.writer.writeAll("*");
        } else try output.writer.writeAll(directory);

        remaining = tail[separator..];
    }

    try output.writer.writeAll(remaining);

    return output.toOwnedSlice();
}
