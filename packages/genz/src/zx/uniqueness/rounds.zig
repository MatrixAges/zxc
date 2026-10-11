const std = @import("std");
const Self = @This();

/// The cores that analyze the bodies of one round. A round reads facts that stay fixed until it ends, so its bodies
/// are independent. Which worker analyzes a body never changes its result. Rounds are short and frequent, so the
/// workers start once and sleep between rounds.
workers: []Worker,
threads: []std.Thread,
started: usize = 0,
/// Advances once per round; sleeping workers wait for it to change.
generation: std.atomic.Value(u32) = .init(0),
/// Workers other than the calling thread that finished the current round.
finished: std.atomic.Value(u32) = .init(0),
/// Workers taking part in the current round, the calling thread included: every started worker, so none lags behind
/// into the next round.
participants: usize = 0,
job: Job = undefined,
stopping: bool = false,
/// What one worker allocates: passes over a body that every later analysis reuses, the scratch of one analysis, and
/// the results that wait for their visit.
pub const Worker = struct {
    lasting: std.heap.ArenaAllocator,
    scratch: std.heap.ArenaAllocator,
    kept: std.heap.ArenaAllocator,
};

const Job = struct { context: *anyopaque, run: *const fn (*anyopaque, *Worker) void };
/// Bodies one worker analyzes before waking another pays for itself.
const per_thread = 4;
/// Polls before sleeping, as the next round usually starts within a fraction of a millisecond.
const spins = 2000;

pub fn init(allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    const cores = @max(std.Thread.getCpuCount() catch 1, 1);
    const workers = try allocator.alloc(Worker, cores);

    for (workers) |*worker| worker.* = .{ .lasting = .init(std.heap.smp_allocator), .scratch = .init(std.heap.smp_allocator), .kept = .init(std.heap.smp_allocator) };

    return .{ .workers = workers, .threads = try allocator.alloc(std.Thread, cores -| 1) };
}

pub fn deinit(self: *Self) void {
    if (self.started != 0) {
        self.stopping = true;
        _ = self.generation.fetchAdd(1, .release);

        io().futexWake(u32, &self.generation.raw, std.math.maxInt(u32));

        for (self.threads[0..self.started]) |thread| thread.join();
    }

    for (self.workers) |*worker| {
        worker.lasting.deinit();
        worker.scratch.deinit();
        worker.kept.deinit();
    }
}

/// Frees every result kept so far.
pub fn forget(self: *Self) void {
    for (self.workers) |*worker| _ = worker.kept.reset(.retain_capacity);
}

pub fn count(self: *const Self) usize {
    return self.workers.len;
}

/// Calls `task.run(position, worker)` for every position below `total`, spread over the cores, and returns once all
/// ran.
pub fn each(self: *Self, comptime Task: type, task: *Task, total: usize) std.mem.Allocator.Error!void {
    if (total == 0) return;

    var shared = Shared(Task){ .task = task, .count = total };
    const wanted = @min(self.workers.len, (total + per_thread - 1) / per_thread);

    while (self.started + 1 < wanted) {
        self.threads[self.started] = std.Thread.spawn(.{}, work, .{ self, self.started + 1, self.generation.load(.monotonic) }) catch break;
        self.started += 1;
    }

    self.participants = if (wanted > 1) self.started + 1 else 1;

    if (self.participants > 1) {
        self.job = .{ .context = &shared, .run = Shared(Task).erased };

        self.finished.store(0, .monotonic);

        _ = self.generation.fetchAdd(1, .release);

        io().futexWake(u32, &self.generation.raw, std.math.maxInt(u32));
    }

    shared.run(&self.workers[0]);

    if (self.participants > 1) {
        const others: u32 = @intCast(self.participants - 1);

        while (true) {
            const done = await(&self.finished, others);

            if (done == others) break;
        }
    }

    if (shared.failed.load(.monotonic)) return error.OutOfMemory;
}

/// A worker waits for the first round published after it started, at generation `started`.
fn work(self: *Self, worker: usize, started: u32) void {
    var seen = started;

    while (true) {
        seen = next(&self.generation, seen);

        if (self.stopping) return;

        self.job.run(self.job.context, &self.workers[worker]);

        if (self.finished.fetchAdd(1, .acq_rel) + 1 == self.participants - 1) io().futexWake(u32, &self.finished.raw, 1);
    }
}

/// The generation after `seen`, once it starts.
fn next(generation: *std.atomic.Value(u32), seen: u32) u32 {
    for (0..spins) |_| {
        const value = generation.load(.acquire);

        if (value != seen) return value;

        std.atomic.spinLoopHint();
    }

    while (true) {
        const value = generation.load(.acquire);

        if (value != seen) return value;

        io().futexWaitUncancelable(u32, &generation.raw, seen);
    }
}

/// The count of finished workers once it reaches `target`, or whatever it is when the wait wakes.
fn await(finished: *std.atomic.Value(u32), target: u32) u32 {
    for (0..spins) |_| {
        const value = finished.load(.acquire);

        if (value == target) return value;

        std.atomic.spinLoopHint();
    }

    const value = finished.load(.acquire);

    if (value != target) io().futexWaitUncancelable(u32, &finished.raw, value);

    return finished.load(.acquire);
}

/// Waiting needs no event loop: the futex of the threaded implementation blocks the calling thread itself.
fn io() std.Io {
    return std.Io.Threaded.global_single_threaded.io();
}

fn Shared(comptime Task: type) type {
    return struct {
        task: *Task,
        count: usize,
        next: std.atomic.Value(usize) = .init(0),
        failed: std.atomic.Value(bool) = .init(false),
        fn erased(context: *anyopaque, worker: *Worker) void {
            const self: *@This() = @ptrCast(@alignCast(context));

            self.run(worker);
        }
        fn run(self: *@This(), worker: *Worker) void {
            while (!self.failed.load(.monotonic)) {
                const position = self.next.fetchAdd(1, .monotonic);

                if (position >= self.count) return;

                _ = worker.scratch.reset(.retain_capacity);

                self.task.run(position, worker) catch {
                    self.failed.store(true, .monotonic);

                    return;
                };
            }
        }
    };
}
