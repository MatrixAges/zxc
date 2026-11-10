const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const Cache = @import("cache.zig");
/// One unit to generate and the batch whose program and facts it comes from.
pub const Job = struct { batch: *const Batch, unit: generating.Unit };

/// Identifies every unit and fetches its cached source.
const Search = struct {
    jobs: []const Job,
    lookups: []Batch.Lookup,
    fetched: []Cache.Fetched,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn run(self: *Search, arena: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.jobs.len) return;

            self.step(arena.allocator(), position) catch |err| {
                _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

                return;
            };
        }
    }
    fn step(self: *Search, allocator: std.mem.Allocator, position: usize) generating.Error!void {
        const job = self.jobs[position];
        const found = try job.batch.identify(allocator, job.unit);
        self.lookups[position] = found;
        self.fetched[position] = if (job.batch.cache) |cache| try cache.fetch(allocator, found.name, found.key) else .absent;
    }
};

/// Generates every unit no cached source covers.
const Work = struct {
    pending: []const Job,
    results: [][]const u8,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    /// Each unit's working memory comes from one scratch arena per worker, reset after the unit with its pages kept, so
    /// generating unit after unit reuses them instead of mapping and faulting fresh ones.
    fn run(self: *Work, arena: *std.heap.ArenaAllocator) void {
        var scratch = std.heap.ArenaAllocator.init(std.heap.page_allocator);

        defer scratch.deinit();

        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.pending.len) return;

            defer _ = scratch.reset(.{ .retain_with_limit = 32 << 20 });
            const job = self.pending[position];

            self.results[position] = job.batch.generate(arena.allocator(), scratch.allocator(), job.unit) catch |err| {
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

/// Sources of function `units` in order.
pub fn create(owned: std.mem.Allocator, batch: *const Batch, units: []const generating.Unit) generating.Error![][]const u8 {
    const jobs = try batch.backing.alloc(Job, units.len);

    defer batch.backing.free(jobs);

    for (units, jobs) |unit, *job| job.* = .{ .batch = batch, .unit = unit };

    return createJobs(owned, batch.backing, jobs);
}

/// Sources of `jobs` in order: cached units are copied into one buffer, the rest are generated; the search, the copies
/// and the generation run on all cores.
pub fn createJobs(owned: std.mem.Allocator, backing: std.mem.Allocator, jobs: []const Job) generating.Error![][]const u8 {
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const sources = try owned.alloc([]const u8, jobs.len);
    const arenas = try temporary.alloc(std.heap.ArenaAllocator, @import("zx").parallel.width());

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    var search = Search{ .jobs = jobs, .lookups = try temporary.alloc(Batch.Lookup, jobs.len), .fetched = try temporary.alloc(Cache.Fetched, jobs.len) };

    try spread(Search, &search, arenas[0..@min(arenas.len, jobs.len)]);

    const plan = try @import("function_sources_plan.zig").create(temporary, search.fetched);
    const buffer = try owned.alloc(u8, @intCast(plan.size));
    const reused = try temporary.alloc([]const u8, plan.reused.len);
    const copies = try temporary.alloc([]u8, plan.reused.len);

    // Copy borrowed cache bytes before record can replace and release cache entries.
    for (plan.reused, plan.offsets, reused, copies) |position, offset, *source, *copy| {
        source.* = switch (search.fetched[@intCast(position)]) {
            .held, .stored => |value| value,
            else => unreachable,
        };

        copy.* = buffer[@intCast(offset)..][0..source.len];
    }

    var copying = Copying{ .from = reused, .to = copies };

    try spread(Copying, &copying, arenas[0..@min(arenas.len, reused.len)]);

    for (jobs, search.lookups, search.fetched) |job, found, fetched| {
        if (job.batch.cache) |cache| _ = try cache.record(found.name, found.key, fetched);
    }

    for (plan.reused, copies) |position, copy| sources[@intCast(position)] = copy;

    const pending = try temporary.alloc(Job, plan.pending.len);

    for (plan.pending, pending) |position, *job| job.* = jobs[@intCast(position)];

    var work = Work{ .pending = pending, .results = try temporary.alloc([]const u8, pending.len) };

    try spread(Work, &work, arenas[0..@min(arenas.len, pending.len)]);

    for (plan.pending, work.results) |position, generated| {
        sources[position] = try owned.dupe(u8, generated);

        try jobs[position].batch.remember(search.lookups[position], sources[position]);
    }

    return sources;
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
