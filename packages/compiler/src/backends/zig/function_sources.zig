const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const Cache = @import("cache.zig");

/// Identifies every unit and fetches its cached source.
const Search = struct {
    batch: *const Batch,
    units: []const generating.Unit,
    lookups: []Batch.Lookup,
    fetched: []Cache.Fetched,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Search, arena: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.units.len) return;

            self.step(arena.allocator(), position) catch |err| {
                _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                return;
            };
        }
    }
    fn step(self: *Search, allocator: std.mem.Allocator, position: usize) generating.Error!void {
        const found = try self.batch.identify(allocator, self.units[position]);
        self.lookups[position] = found;
        self.fetched[position] = if (self.batch.cache) |cache| try cache.fetch(allocator, found.name, found.key) else .absent;
    }
};

/// Generates every unit no cached source covers.
const Work = struct {
    batch: *const Batch,
    pending: []const generating.Unit,
    results: [][]const u8,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Work, arena: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.pending.len) return;

            self.results[position] = self.batch.generate(arena.allocator(), std.heap.smp_allocator, self.pending[position]) catch |err| {
                _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                return;
            };
        }
    }
};

/// Copies cached sources into the result, which owns its sources.
const Copying = struct {
    from: []const []const u8,
    to: []const []u8,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Copying, _: *std.heap.ArenaAllocator) void {
        while (true) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.from.len) return;

            @memcpy(self.to[position], self.from[position]);
        }
    }
};

/// Sources of function `units` in order: cached units are copied into one buffer, the rest are generated; the search,
/// the copies and the generation run on all cores.
pub fn create(owned: std.mem.Allocator, batch: *const Batch, units: []const generating.Unit) generating.Error![][]const u8 {
    var scratch = std.heap.ArenaAllocator.init(batch.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const sources = try owned.alloc([]const u8, units.len);
    const arenas = try temporary.alloc(std.heap.ArenaAllocator, @import("zx").parallel.width());

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    var search = Search{ .batch = batch, .units = units, .lookups = try temporary.alloc(Batch.Lookup, units.len), .fetched = try temporary.alloc(Cache.Fetched, units.len) };

    try spread(Search, &search, arenas[0..@min(arenas.len, units.len)]);

    // Reused sources are copied straight from what the search fetched, before recording can replace cache entries.
    var reused: std.ArrayList([]const u8) = .empty;
    var size: usize = 0;

    for (search.fetched) |fetched| if (reusable(fetched)) |value| {
        try reused.append(temporary, value);

        size += value.len;
    };

    const buffer = try owned.alloc(u8, size);
    const copies = try temporary.alloc([]u8, reused.items.len);
    var offset: usize = 0;

    for (reused.items, copies) |value, *copy| {
        copy.* = buffer[offset..][0..value.len];
        offset += value.len;
    }

    var copying = Copying{ .from = reused.items, .to = copies };

    try spread(Copying, &copying, arenas[0..@min(arenas.len, reused.items.len)]);

    var pending: std.ArrayList(generating.Unit) = .empty;
    var positions: std.ArrayList(usize) = .empty;
    var next: usize = 0;

    for (units, search.lookups, search.fetched, sources, 0..) |unit, found, fetched, *source, position| {
        if (batch.cache) |cache| _ = try cache.record(found.name, found.key, fetched);

        if (reusable(fetched) != null) {
            source.* = copies[next];
            next += 1;

            continue;
        }

        try pending.append(temporary, unit);
        try positions.append(temporary, position);
    }

    var work = Work{ .batch = batch, .pending = pending.items, .results = try temporary.alloc([]const u8, pending.items.len) };

    try spread(Work, &work, arenas[0..@min(arenas.len, pending.items.len)]);

    for (positions.items, work.results) |position, generated| {
        sources[position] = try owned.dupe(u8, generated);

        try batch.remember(search.lookups[position], sources[position]);
    }

    return sources;
}

fn reusable(fetched: Cache.Fetched) ?[]const u8 {
    return switch (fetched) {
        .held => |value| value,
        .stored => |value| value,
        else => null,
    };
}

/// Runs `task` on this thread and the shared workers, one arena per participant, and reports the first failure.
pub fn spread(comptime Task: type, task: *Task, arenas: []std.heap.ArenaAllocator) generating.Error!void {
    if (arenas.len == 0) return;

    const Shared = struct {
        task: *Task,
        arenas: []std.heap.ArenaAllocator,
        fn run(self: *@This(), participant: usize) void {
            self.task.run(&self.arenas[participant]);
        }
    };

    var shared = Shared{ .task = task, .arenas = arenas };

    @import("zx").parallel.spread(Shared, &shared, Shared.run, arenas.len);

    if (task.failure.load(.monotonic) != 0) return @errorCast(@errorFromInt(task.failure.load(.monotonic)));
}
