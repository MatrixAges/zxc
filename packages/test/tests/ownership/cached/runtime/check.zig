const std = @import("std");
pub const program = @import("program");
pub const borrowed = std.mem.eql(u8, @import("options").mode, "borrowed");
pub const Case = struct { count: usize, choice: bool = true, zeros: bool = false };

pub fn run(gpa: std.mem.Allocator, case: Case) !void {
    const first = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(first);

    const second = try std.testing.allocator.alloc(u64, case.count / 2 + 1);

    defer std.testing.allocator.free(second);

    for (first, 0..) |*item, index| item.* = if (case.zeros) 0 else @as(u64, @intCast(index % 11)) + 100;
    for (second, 0..) |*item, index| item.* = if (case.zeros) 0 else @as(u64, @intCast(index % 13)) + 200;

    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .first = first, .second = second, .choice = case.choice });

    for (first, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) 0 else @as(u64, @intCast(index % 11)) + 100, item);
    for (second, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) 0 else @as(u64, @intCast(index % 13)) + 200, item);

    const result = try executed;

    try std.testing.expectEqualSlices(u64, first, result.first);
    try std.testing.expectEqualSlices(u64, second, result.second);
    if (first.len > 0) try std.testing.expectEqual(borrowed, first.ptr == result.first.ptr);
    try std.testing.expectEqual(borrowed, second.ptr == result.second.ptr);

    if (result.first.len > 0) {
        const start_first = @intFromPtr(result.first.ptr);
        const start_second = @intFromPtr(result.second.ptr);

        try std.testing.expect(start_first + result.first.len * @sizeOf(u64) <= start_second or start_second + result.second.len * @sizeOf(u64) <= start_first);
    }
}
