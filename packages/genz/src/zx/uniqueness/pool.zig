const std = @import("std");
const Self = @This();

/// Background threads that analyze the bodies the calling thread requests while it walks the worklist on its own. A
/// request waits in a bounded ring; when the ring is full the request is dropped, as the calling thread analyzes any
/// body without a result itself.
workers: []Worker,
threads: []std.Thread,
started: usize = 0,
ring: []std.atomic.Value(u32),
/// Requests written so far; only the calling thread advances it.
tail: std.atomic.Value(u32) = .init(0),
/// Requests taken so far.
head: std.atomic.Value(u32) = .init(0),
/// Workers that may hold a request they took.
busy: std.atomic.Value(u32) = .init(0),
/// Workers asleep, and the word they sleep on, which changes whenever a request or the stop may have woken them.
sleepers: std.atomic.Value(u32) = .init(0),
signal: std.atomic.Value(u32) = .init(0),
stopping: std.atomic.Value(bool) = .init(false),
job: Job = undefined,
/// What one worker allocates: passes over a body that every later analysis reuses, the scratch of one analysis, and
/// the results that wait for their visit. The first belongs to the calling thread.
pub const Worker = struct {
    lasting: std.heap.ArenaAllocator,
    scratch: std.heap.ArenaAllocator,
    kept: std.heap.ArenaAllocator,
};

const Job = struct { context: *anyopaque, run: *const fn (*anyopaque, *Worker, u32) void };
/// Threads, the calling one included. More of them mostly analyze bodies whose summaries change before their visit,
/// and they slow the calling thread, which waits on the analysis of what its last visit changed.
const most = 8;
/// Requests that fit in the ring; more than the bodies looked at ahead.
const capacity = 256;
/// Polls before sleeping, as the next request usually comes within a fraction of a millisecond.
const spins = 2000;

pub fn init(allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    const cores = std.math.clamp(std.Thread.getCpuCount() catch 1, 1, most);
    const workers = try allocator.alloc(Worker, cores);
    const ring = try allocator.alloc(std.atomic.Value(u32), capacity);

    for (workers) |*worker| worker.* = .{ .lasting = .init(std.heap.smp_allocator), .scratch = .init(std.heap.smp_allocator), .kept = .init(std.heap.smp_allocator) };

    return .{ .workers = workers, .threads = try allocator.alloc(std.Thread, cores - 1), .ring = ring };
}

pub fn deinit(self: *Self) void {
    self.drain();
    self.stopping.store(true, .seq_cst);
    self.wake();

    for (self.threads[0..self.started]) |thread| thread.join();

    for (self.workers) |*worker| {
        worker.lasting.deinit();
        worker.scratch.deinit();
        worker.kept.deinit();
    }
}

/// Background threads, the calling thread aside.
pub fn count(self: *const Self) usize {
    return self.threads.len;
}

/// Runs `run(context, worker, index)` for every later request; only while no request is pending.
pub fn serve(self: *Self, comptime Context: type, comptime run: fn (*Context, *Worker, u32) void, context: *Context) void {
    self.job = .{ .context = context, .run = struct {
        fn erased(erased_context: *anyopaque, worker: *Worker, index: u32) void {
            run(@ptrCast(@alignCast(erased_context)), worker, index);
        }
    }.erased };
}

/// Queues body `index` for a background thread; false when the ring is full.
pub fn submit(self: *Self, index: u32) bool {
    const tail = self.tail.load(.monotonic);

    if (self.threads.len == 0 or tail -% self.head.load(.seq_cst) >= capacity) return false;
    if (self.started < self.threads.len) self.start();

    self.ring[tail % capacity].store(index, .monotonic);
    self.tail.store(tail +% 1, .seq_cst);
    self.wake();

    return true;
}

/// Drops every request no worker took and waits for the workers that hold one.
pub fn drain(self: *Self) void {
    const tail = self.tail.load(.monotonic);
    var head = self.head.load(.seq_cst);

    while (head != tail) head = self.head.cmpxchgWeak(head, tail, .seq_cst, .seq_cst) orelse break;
    while (self.busy.load(.seq_cst) != 0) std.atomic.spinLoopHint();
}

/// Frees every result kept so far; only once drained.
pub fn forget(self: *Self) void {
    for (self.workers) |*worker| _ = worker.kept.reset(.retain_capacity);
}

fn start(self: *Self) void {
    while (self.started < self.threads.len) : (self.started += 1) {
        self.threads[self.started] = std.Thread.spawn(.{}, work, .{ self, &self.workers[self.started + 1] }) catch return;
    }
}

fn wake(self: *Self) void {
    if (self.sleepers.load(.seq_cst) == 0) return;

    _ = self.signal.fetchAdd(1, .seq_cst);

    io().futexWake(u32, &self.signal.raw, std.math.maxInt(u32));
}

fn work(self: *Self, worker: *Worker) void {
    var idle: usize = 0;

    while (true) {
        if (self.head.load(.seq_cst) != self.tail.load(.seq_cst)) {
            // Counted as busy before looking again, so a drain that saw no worker busy has no claim left to wait for.
            _ = self.busy.fetchAdd(1, .seq_cst);

            const head = self.head.load(.seq_cst);

            if (head != self.tail.load(.seq_cst)) {
                // The slot is read before the claim: once the head moves past it, the calling thread may reuse it.
                const index = self.ring[head % capacity].load(.monotonic);

                if (self.head.cmpxchgWeak(head, head +% 1, .seq_cst, .monotonic) == null) {
                    _ = worker.scratch.reset(.retain_capacity);

                    self.job.run(self.job.context, worker, index);
                }
            }

            _ = self.busy.fetchSub(1, .seq_cst);
            idle = 0;

            continue;
        }

        if (self.stopping.load(.seq_cst)) return;

        if (idle < spins) {
            idle += 1;

            std.atomic.spinLoopHint();

            continue;
        }

        _ = self.sleepers.fetchAdd(1, .seq_cst);

        const seen = self.signal.load(.seq_cst);

        if (self.head.load(.seq_cst) == self.tail.load(.seq_cst) and !self.stopping.load(.seq_cst)) io().futexWaitUncancelable(u32, &self.signal.raw, seen);

        _ = self.sleepers.fetchSub(1, .seq_cst);
        idle = 0;
    }
}

/// Waiting needs no event loop: the futex of the threaded implementation blocks the calling thread itself.
fn io() std.Io {
    return std.Io.Threaded.global_single_threaded.io();
}
