const std = @import("std");
const h = @import("check.zig");
const Name = struct { name: []const u8, valid: bool };

const names = [_]Name{
    .{ .name = "alpha", .valid = true },
    .{ .name = "alpha_x", .valid = true },
    .{ .name = "alphabet", .valid = true },
    .{ .name = "beta", .valid = true },
    .{ .name = "alpha.x", .valid = false },
    .{ .name = "1x", .valid = false },
    .{ .name = "task", .valid = false },
};

test "RX parallel name matrix distinguishes identifiers duplicates and shared prefixes" {
    for (names) |left| {
        for (names) |right| {
            const source = try std.fmt.allocPrint(std.testing.allocator, "<Module><Parallel><Call fn='{s}.zx' in={{1}}/><Call fn='{s}.zx' in={{2}}/><Call fn='number_other.zx' in={{3}}/></Parallel><Return value={{0}}/></Module>", .{ left.name, right.name });

            defer std.testing.allocator.free(source);

            const duplicate = std.mem.eql(u8, left.name, right.name);
            const invalid = !left.valid or !right.valid;
            const failed = if (!left.valid) left.name else right.name;
            const marker = try std.fmt.allocPrint(std.testing.allocator, "{s}.zx'", .{failed});

            defer std.testing.allocator.free(marker);
            errdefer std.debug.print("result names {s} and {s}\n", .{ left.name, right.name });

            try h.run(.{
                .source = source,
                .expected = if (invalid or duplicate) .{
                    .marker = marker,
                    .last = left.valid,
                    .message = if (!invalid) "Parallel result binding paths must not overlap" else null,
                } else null,
            });
        }
    }
}
