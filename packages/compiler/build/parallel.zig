const std = @import("std");

/// One arena per worker thread, so steps running at once never share an allocator.
pub const Arenas = struct {
    items: []std.heap.ArenaAllocator,

    /// Workers for `jobs` steps: at most one per core, and at least one.
    pub fn init(allocator: std.mem.Allocator, jobs: usize) std.mem.Allocator.Error!Arenas {
        const items = try allocator.alloc(std.heap.ArenaAllocator, @max(@min(std.Thread.getCpuCount() catch 1, jobs), 1));

        for (items) |*arena| arena.* = .init(std.heap.smp_allocator);

        return .{ .items = items };
    }

    pub fn deinit(self: Arenas) void {
        for (self.items) |*arena| arena.deinit();
    }
};

/// Runs `context.step(allocator, index)` for every index below `count`, spread over one thread per arena; a step
/// allocates from its thread's arena. Returns the first error a step reports.
pub fn each(arenas: Arenas, count: usize, context: anytype) !void {
    const Context = @TypeOf(context);
    const Work = struct {
        context: Context,
        count: usize,
        next: std.atomic.Value(usize) = .init(0),
        failure: std.atomic.Value(u16) = .init(0),

        fn run(work: *@This(), arena: *std.heap.ArenaAllocator) void {
            while (work.failure.load(.monotonic) == 0) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.count) return;

                work.context.step(arena.allocator(), index) catch |err| {
                    _ = work.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                    return;
                };
            }
        }
    };

    var work = Work{ .context = context, .count = count };
    var threads: [256]std.Thread = undefined;
    var started: usize = 0;

    for (arenas.items[1..@min(arenas.items.len, threads.len + 1)]) |*arena| {
        threads[started] = std.Thread.spawn(.{}, Work.run, .{ &work, arena }) catch break;
        started += 1;
    }

    work.run(&arenas.items[0]);

    for (threads[0..started]) |thread| thread.join();
    if (work.failure.load(.monotonic) != 0) return @errorCast(@errorFromInt(work.failure.load(.monotonic)));
}
