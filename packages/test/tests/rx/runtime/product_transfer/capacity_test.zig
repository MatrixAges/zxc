const std = @import("std");
const h = @import("check.zig");

test "independent product writes transfer both payloads without round proportional copies" {
    const args: h.Case = .{ .left_length = 65537, .right_length = 32771, .left_index = 0, .right_index = 32770, .forbid_resize = true };
    var initial = args;
    initial.count = 0;

    var first = args;
    first.count = 1;
    var many = args;
    many.count = 64;
    const before = try h.run(std.testing.allocator, initial);
    const once = try h.run(std.testing.allocator, first);
    const after = try h.run(std.testing.allocator, many);
    const payload = @as(usize, @min(args.left_length, args.right_length)) * @sizeOf(i64);

    std.debug.print("product bytes initial={d} first={d} long={d} smaller_payload={d}\n", .{ before.bytes, once.bytes, after.bytes, payload });

    try std.testing.expect(once.bytes < before.bytes + payload);
    try std.testing.expect(after.bytes < once.bytes + payload);
}
