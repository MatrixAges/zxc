const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const Cache = @import("cache.zig");

/// Identifies every selected function and fetches its cached source.
const Search = struct {
    batch: *const Batch,
    selected: []const u32,
    lookups: []Batch.Lookup,
    fetched: []Cache.Fetched,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Search, arena: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.selected.len) return;

            self.step(arena.allocator(), position) catch |err| {
                _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                return;
            };
        }
    }

    fn step(self: *Search, allocator: std.mem.Allocator, position: usize) generating.Error!void {
        const found = try self.batch.identify(allocator, .{ .function = @fromBackingInt(self.selected[position]) });

        self.lookups[position] = found;
        self.fetched[position] = if (self.batch.cache) |cache| try cache.fetch(allocator, found.name, found.key) else .absent;
    }
};

/// Generates every function no cached source covers.
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

/// Sources of the selected functions in program order: cached units are reused, the rest are generated; both the
/// search and the generation run on all cores.
pub fn create(owned: std.mem.Allocator, batch: *const Batch, selected: []const u32) generating.Error![]const []const u8 {
    var scratch = std.heap.ArenaAllocator.init(batch.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const sources = try owned.alloc([]const u8, selected.len);
    const arenas = try temporary.alloc(std.heap.ArenaAllocator, @max(std.Thread.getCpuCount() catch 1, 1));

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    var search = Search{ .batch = batch, .selected = selected, .lookups = try temporary.alloc(Batch.Lookup, selected.len), .fetched = try temporary.alloc(Cache.Fetched, selected.len) };

    try spread(Search, &search, temporary, arenas[0..@min(arenas.len, selected.len)]);

    var pending: std.ArrayList(u32) = .empty;
    var positions: std.ArrayList(usize) = .empty;

    for (selected, search.lookups, search.fetched, sources, 0..) |index, found, fetched, *source, position| {
        const cached = if (batch.cache) |cache| try cache.record(found.name, found.key, fetched) else null;

        if (cached) |value| {
            source.* = try owned.dupe(u8, value);

            continue;
        }

        try pending.append(temporary, index);
        try positions.append(temporary, position);
    }

    var work = Work{ .batch = batch, .pending = pending.items, .results = try temporary.alloc([]const u8, pending.items.len) };

    try spread(Work, &work, temporary, arenas[0..@min(arenas.len, pending.items.len)]);

    for (positions.items, work.results) |position, generated| {
        sources[position] = try owned.dupe(u8, generated);

        try batch.remember(search.lookups[position], sources[position]);
    }

    return sources;
}

/// Runs `task` on this thread and one helper per further arena, and reports the first failure.
fn spread(comptime Task: type, task: *Task, temporary: std.mem.Allocator, arenas: []std.heap.ArenaAllocator) generating.Error!void {
    if (arenas.len == 0) return;

    const threads = try temporary.alloc(std.Thread, arenas.len - 1);
    var started: usize = 0;

    for (threads, arenas[1..]) |*thread, *arena| {
        thread.* = std.Thread.spawn(.{}, Task.run, .{ task, arena }) catch break;
        started += 1;
    }

    task.run(&arenas[0]);

    for (threads[0..started]) |thread| thread.join();
    if (task.failure.load(.monotonic) != 0) return @errorCast(@errorFromInt(task.failure.load(.monotonic)));
}
