const std = @import("std");
pub const checks = @import("checks");
const ir = @import("zx").ir;
pub const Lane = checks.flow.Lane;

pub const Source = struct {
    input: [2]u32 = .{ 0, 2 },
    output: [2]u32 = .{ 1, 3 },
    appends: [2]ir.ExprId = .{ @fromBackingInt(4), @fromBackingInt(5) },
    pops: [1]ir.ExprId = .{@fromBackingInt(6)},
    updates: [2]ir.ExprId = .{ @fromBackingInt(7), @fromBackingInt(8) },
    calls: [2]checks.flow.Call = .{ .{ .expression = @fromBackingInt(9), .lane = 0 }, .{ .expression = @fromBackingInt(10), .lane = 2 } },
    first_path: [2]u32 = .{ 0, 1 },
    second_path: [3]u32 = .{ 2, 3, 4 },
    iterations: [2]checks.flow.Iteration = undefined,
    pub fn lane(self: *Source) Lane {
        self.iterations = .{
            .{ .expression = @fromBackingInt(11), .path = &self.first_path },
            .{ .expression = @fromBackingInt(12), .path = &self.second_path },
        };

        return .{
            .input = &self.input, .output = &self.output,
            .appends = &self.appends, .pops = &self.pops, .updates = &self.updates,
            .calls = &self.calls, .iterations = &self.iterations, .rejection = .unsupported_call,
        };
    }

    pub fn poisonFlat(self: *Source) void {
        @memset(&self.input, 99);
        @memset(&self.output, 99);
        @memset(&self.appends, @fromBackingInt(99));
        @memset(&self.pops, @fromBackingInt(99));
        @memset(&self.updates, @fromBackingInt(99));
        @memset(&self.calls, .{ .expression = @fromBackingInt(99), .lane = 99 });
    }

    pub fn poisonIterations(self: *Source) void {
        @memset(&self.first_path, 99);
        @memset(&self.second_path, 99);
        @memset(&self.iterations, .{ .expression = @fromBackingInt(99), .path = &.{} });
    }
};

pub fn copied(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var source: Source = .{};
    var expected: Source = .{};
    const saved = try checks.lanes.copy(arena.allocator(), &.{ &.{}, &.{source.lane()} });

    source.poisonFlat();
    source.poisonIterations();

    try std.testing.expectEqual(@as(usize, 0), saved[0].len);
    try std.testing.expectEqualDeep(expected.lane(), saved[1][0]);
}
