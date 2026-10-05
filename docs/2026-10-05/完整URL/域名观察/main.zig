const std = @import("std");
const punycode = @import("punycode");
const nfc = @import("nfc");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedOperationAndText;

    var output: std.ArrayList(u8) = .empty;

    if (std.mem.eql(u8, args[1], "encode") or std.mem.eql(u8, args[1], "nfc")) {
        var points: std.ArrayList(u21) = .empty;
        var iterator = (try std.unicode.Utf8View.init(args[2])).iterator();

        while (iterator.nextCodepoint()) |point| try points.append(allocator, point);

        if (std.mem.eql(u8, args[1], "encode")) {
            try std.Io.File.stdout().writeStreamingAll(init.io, try punycode.encode(allocator, points.items));
        } else {
            for (try nfc.normalize(allocator, points.items)) |point| {
                var bytes: [4]u8 = undefined;
                const length = try std.unicode.utf8Encode(point, &bytes);

                try output.appendSlice(allocator, bytes[0..length]);
            }

            try std.Io.File.stdout().writeStreamingAll(init.io, output.items);
        }
    } else if (std.mem.eql(u8, args[1], "decode")) {
        for (try punycode.decode(allocator, args[2])) |point| {
            var bytes: [4]u8 = undefined;
            const length = try std.unicode.utf8Encode(point, &bytes);

            try output.appendSlice(allocator, bytes[0..length]);
        }

        try std.Io.File.stdout().writeStreamingAll(init.io, output.items);
    } else return error.InvalidOperation;
}
