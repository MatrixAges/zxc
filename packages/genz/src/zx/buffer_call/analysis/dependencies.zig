const std = @import("std");
const Trace = @import("trace.zig");
const Reach = @import("reach.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

const Context = struct {
    pub fn hash(_: @This(), path: []const u32) u64 {
        return std.hash.Wyhash.hash(0, std.mem.sliceAsBytes(path));
    }

    pub fn eql(_: @This(), left: []const u32, right: []const u32) bool {
        return std.mem.eql(u32, left, right);
    }
};

reach: ?*Reach = null,
entries: std.HashMapUnmanaged([]const u32, []const []const u32, Context, std.hash_map.default_max_load_percentage) = .empty,
/// Callee inputs that may flow into one output path, in input order.
pub fn inputs(self: *Self, trace: *Trace, output: []const u32) Error![]const []const u32 {
    if (self.entries.get(output)) |found| return found;

    const paths = try trace.inputPaths();

    const reach = self.reach orelse blk: {
        const created = try trace.allocator.create(Reach);
        created.* = try Reach.init(trace.allocator, trace, paths, &.{});
        self.reach = created;

        break :blk created;
    };

    const dependent = try trace.allocator.alloc(usize, reach.words);

    @memset(dependent, 0);

    for (trace.results.items) |result| {
        const index = try reach.visit(result, output);

        for (dependent, reach.row(index)) |*word, value| word.* |= value;
    }

    var found: std.ArrayList([]const u32) = .empty;

    for (paths, 0..) |input, position| {
        if (dependent[position / @bitSizeOf(usize)] & (@as(usize, 1) << @intCast(position % @bitSizeOf(usize))) != 0) try found.append(trace.allocator, input);
    }

    try self.entries.put(trace.allocator, try trace.allocator.dupe(u32, output), found.items);

    return found.items;
}
