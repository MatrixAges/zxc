const std = @import("std");
const url = @import("standard").url;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 4 or args.len > 5) return error.ExpectedOperationPlatformAndInput;

    const windows = if (std.mem.eql(u8, args[2], "windows")) true else if (std.mem.eql(u8, args[2], "posix")) false else return error.InvalidPlatform;

    if (std.mem.eql(u8, args[1], "from")) {
        if (args.len != 5) return error.ExpectedWorkingDirectory;

        try std.Io.File.stdout().writeStreamingAll(init.io, try url.pathToFileUrl(allocator, args[3], windows, args[4]));
    } else {
        var parsed = try url.parse(allocator, args[3], null);

        defer parsed.deinit();

        const result = if (std.mem.eql(u8, args[1], "text"))
            try url.fileUrlToPath(allocator, parsed.value, windows)

        else if (std.mem.eql(u8, args[1], "bytes"))
            try url.fileUrlToBytes(allocator, parsed.value, windows)
        else
            return error.InvalidOperation;

        try std.Io.File.stdout().writeStreamingAll(init.io, result);
    }
}
