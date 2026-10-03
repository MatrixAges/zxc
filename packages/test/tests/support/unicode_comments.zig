const std = @import("std");
const Mode = enum { line, block };

pub fn check(comptime check_source: anytype, args: struct { mode: Mode, first: u21, last: u21, terminators: []const u21 }) !void {
    const mode = args.mode;
    const prefix = if (mode == .line) "//var " else "/*var ";
    const suffix = if (mode == .line) "xx = 1;\n" else "xx = 1*/\n";
    const program = "export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return 0;\n}\n";

    for (args.first..@as(usize, args.last) + 1) |point| {
        const surrogate = point >= 0xd800 and point <= 0xdfff;
        var encoded: [4]u8 = undefined;

        const length: usize = if (surrogate) blk: {
            encoded[0] = @as(u8, @intCast(point >> 12)) | 0xe0;
            encoded[1] = @as(u8, @intCast((point >> 6) & 0x3f)) | 0x80;
            encoded[2] = @as(u8, @intCast(point & 0x3f)) | 0x80;

            break :blk 3;
        } else try std.unicode.utf8Encode(@intCast(point), &encoded);

        var buffer: [512]u8 = undefined;
        const source = try std.fmt.bufPrint(&buffer, "{s}{s}{s}{s}", .{ prefix, encoded[0..length], suffix, program });

        const result = if (surrogate)
            check_source(source, .parse, .lexical, .{ 0, source.len })

        else if (std.mem.indexOfScalar(u21, args.terminators, @intCast(point)) != null)
            check_source(source, .parse, .contract, .{ prefix.len + length, prefix.len + length + 2 })
        else
            check_source(source, .analyze, null, null);

        result catch |err| {
            std.debug.print("Unicode comment {s} U+{X:0>4}\n", .{ @tagName(mode), point });

            return err;
        };
    }
}
