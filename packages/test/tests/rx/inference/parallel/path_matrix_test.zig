const std = @import("std");
const h = @import("check.zig");
const Path = struct { name: []const u8, overlaps: u8 };

const paths = [_]Path{
    .{ .name = "alpha", .overlaps = 0b1000111 },
    .{ .name = "alpha.x", .overlaps = 0b1000011 },
    .{ .name = "alpha.xy", .overlaps = 0b0000101 },
    .{ .name = "alphabet", .overlaps = 0b0001000 },
    .{ .name = "beta", .overlaps = 0b0110000 },
    .{ .name = "beta.x", .overlaps = 0b0110000 },
    .{ .name = "alpha.x.y", .overlaps = 0b1000011 },
};

test "RX parallel output path matrix distinguishes segment ancestry from textual prefixes" {
    for (paths) |left| {
        for (paths, 0..) |right, index| {
            const source = try std.fmt.allocPrint(std.testing.allocator, "<Module><Parallel><Call fn='number' in={{1}} out='{s}'/><Call fn='number' in={{2}} out='{s}'/><Call fn='number' in={{3}} out='unrelated'/></Parallel><Return value={{0}}/></Module>", .{ left.name, right.name });

            defer std.testing.allocator.free(source);

            const conflict = left.overlaps & (@as(u8, 1) << @as(u3, @intCast(index))) != 0;

            errdefer std.debug.print("output paths {s} and {s}\n", .{ left.name, right.name });

            try h.run(.{
                .source = source,
                .expected = if (conflict) .{ .marker = right.name, .last = true, .message = "Parallel result binding paths must not overlap" } else null,
            });
        }
    }
}
