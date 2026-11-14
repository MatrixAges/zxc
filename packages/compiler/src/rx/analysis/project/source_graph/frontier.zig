const std = @import("std");
const zx = @import("zx");
const Self = @This();
const enabled = @import("rx_options").generated_graph;

seen: []u32,
queue: []u64,
end: usize = 0,

cursor: usize = 0,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const seen = try allocator.alloc(u32, count);

    errdefer allocator.free(seen);

    const queue = try allocator.alloc(u64, count);

    @memset(seen, 0);

    return .{ .seen = seen, .queue = queue };
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    allocator.free(self.queue);
    allocator.free(self.seen);
}

pub fn next(self: *Self) ?usize {
    if (self.cursor == self.end) return null;

    const row = self.queue[self.cursor];

    self.cursor += 1;

    return @intCast(row);
}

pub fn enqueue(self: *Self, targets: []const u64) void {
    if (targets.len == 0) return;

    if (comptime enabled) {
        const generated = @import("generated_source_graph_enqueue");

        const input: std.meta.Child(generated.Input) = .{
            .seen = @ptrCast(&self.seen),
            .queue = @ptrCast(&self.queue),
            .end = self.end,
            .targets = targets,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        self.end = @intCast(zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable);

        return;
    }

    for (targets) |target| {
        const row: usize = @intCast(target);

        if (self.seen[row] != 0) continue;

        self.seen[row] = 1;
        self.queue[self.end] = target;
        self.end += 1;
    }
}
