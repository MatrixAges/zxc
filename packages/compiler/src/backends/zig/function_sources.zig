const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");

const Work = struct {
    batch: *const Batch,
    pending: []const u32,
    results: [][]const u8,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Work, arena: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.pending.len) return;

            self.results[position] = self.batch.generate(arena.allocator(), std.heap.smp_allocator, .{ .function = @fromBackingInt(self.pending[position]) }) catch |err| {
                _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                return;
            };
        }
    }
};

/// Sources of the selected functions in program order: cached units are reused, the rest are generated on all cores.
pub fn create(owned: std.mem.Allocator, batch: *const Batch, selected: []const u32) generating.Error![]const []const u8 {
    var scratch = std.heap.ArenaAllocator.init(batch.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const sources = try owned.alloc([]const u8, selected.len);
    const lookups = try temporary.alloc(Batch.Lookup, selected.len);
    var pending: std.ArrayList(u32) = .empty;
    var positions: std.ArrayList(usize) = .empty;

    for (selected, lookups, sources, 0..) |index, *found, *source, position| {
        found.* = if (batch.cache != null) try batch.lookup(temporary, .{ .function = @fromBackingInt(index) }) else .{ .name = "", .key = undefined, .source = null };

        if (found.source) |cached| {
            source.* = try owned.dupe(u8, cached);

            continue;
        }

        try pending.append(temporary, index);
        try positions.append(temporary, position);
    }

    const results = try temporary.alloc([]const u8, pending.items.len);
    var work = Work{ .batch = batch, .pending = pending.items, .results = results };
    const helpers = @min(std.Thread.getCpuCount() catch 1, pending.items.len) -| 1;
    const arenas = try temporary.alloc(std.heap.ArenaAllocator, helpers + 1);

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    const threads = try temporary.alloc(std.Thread, helpers);
    var started: usize = 0;

    for (threads, arenas[1..]) |*thread, *arena| {
        thread.* = std.Thread.spawn(.{}, Work.run, .{ &work, arena }) catch break;
        started += 1;
    }

    work.run(&arenas[0]);

    for (threads[0..started]) |thread| thread.join();
    if (work.failure.load(.monotonic) != 0) return @errorCast(@errorFromInt(work.failure.load(.monotonic)));

    for (positions.items, results) |position, generated| {
        sources[position] = try owned.dupe(u8, generated);

        try batch.remember(lookups[position], sources[position]);
    }

    return sources;
}
