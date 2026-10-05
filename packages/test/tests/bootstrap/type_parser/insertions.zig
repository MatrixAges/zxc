const std = @import("std");
const comparison = @import("check.zig");

const sources = [_][]const u8{
    "Alpha",
    "Alpha?[]",
    "Box<[u64, bool?]>",
    "{left: Box<u64[]>, right: [bool, Text?]}",
    "[{name: Text, value: T?}, Box<[u64, bool]>][]?",
    "{first: T\nsecond: U}",
    "{first: T second: U}",
    "Box<[u64, bool]",
    "{field: [T, U}",
    "T[]? next",
};

const insertions = [_][]const u8{ " ", "\t", "\n", "\r\n", "/* note */", "/*\n*/", "// note\n", "// note", "/*", "\xff" };

pub fn run(prefix: []const u8, start: u64) !void {
    var count: usize = 0;

    for (sources) |source| {
        for (0..source.len + 1) |offset| {
            for (insertions) |insertion| {
                const mutated = try std.fmt.allocPrint(std.testing.allocator, "{s}{s}{s}{s}", .{ prefix, source[0..offset], insertion, source[offset..] });

                defer std.testing.allocator.free(mutated);

                comparison.check(mutated, start, 0) catch |err| {
                    std.debug.print("type insertion start {d}, offset {d}, bytes {x}, seed {s}\n", .{ start, offset, insertion, source });

                    return err;
                };

                count += 1;
            }
        }
    }

    try std.testing.expectEqual(@as(usize, 2040), count);
}
