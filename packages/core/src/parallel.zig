//! Worker threads shared by every parallel loop of the compiler. They start on first use and sleep between loops, so a
//! compiler that stays resident between builds starts them once instead of once per loop; sleeping right away leaves
//! the cores to the threads that still work. Loops may run at the same
//! time from different threads: each takes the workers that are free when it starts, and its caller always takes part.
const std = @import("std");

/// One spread waiting for workers; it lives on its caller's stack until every worker that joined it returned.
const Job = struct {
    context: *anyopaque,
    run: *const fn (*anyopaque, usize) void,
    wanted: usize,
    /// Participants so far, the caller included; changes only under `lock`.
    joined: usize = 1,
    /// Workers that joined and returned.
    finished: std.atomic.Value(u32) = .init(0),
};

/// Spreads waiting for workers at once; a spread that finds no free slot runs on its caller alone.
const slots = 16;
var jobs: [slots]?*Job = @splat(null);
/// Guards `jobs` and every listed job's `joined`, which are only touched for a moment.
var lock: std.atomic.Value(bool) = .init(false);
/// Changes whenever a spread starts, so that sleeping workers look for it.
var signal: std.atomic.Value(u32) = .init(0);
var state: std.atomic.Value(enum(u8) { idle, starting, started }) = .init(.idle);

/// The most participants a spread can have: one per core.
pub fn width() usize {
    return @max(std.Thread.getCpuCount() catch 1, 1);
}

/// Calls `run(context, participant)` on up to `wanted` threads at once, the calling thread as participant 0, and
/// returns once every call returned. Each call shares the work with the others, usually by taking items from a common
/// counter until none is left, so a participant that joins late may find nothing to do.
pub fn spread(comptime Context: type, context: *Context, comptime run: fn (*Context, usize) void, wanted: usize) void {
    if (wanted <= 1) return run(context, 0);

    start();

    var job = Job{ .context = context, .run = struct {
        fn erased(erased_context: *anyopaque, participant: usize) void {
            run(@ptrCast(@alignCast(erased_context)), participant);
        }
    }.erased, .wanted = @min(wanted, width()) };

    const listed = list(&job);

    if (listed) wake(job.wanted - 1);

    run(context, 0);

    if (!listed) return;

    // Once off the list no worker joins, so the participants are known and the caller waits for theirs.
    acquire();

    for (&jobs) |*slot| {
        if (slot.* == &job) slot.* = null;
    }

    const workers: u32 = @intCast(job.joined - 1);

    release();

    while (true) {
        const done = job.finished.load(.acquire);

        if (done == workers) return;

        io().futexWaitUncancelable(u32, &job.finished.raw, done);
    }
}

fn list(job: *Job) bool {
    acquire();
    defer release();

    for (&jobs) |*slot| if (slot.* == null) {
        slot.* = job;

        return true;
    };

    return false;
}

fn start() void {
    if (state.load(.acquire) != .idle or state.cmpxchgStrong(.idle, .starting, .acquire, .monotonic) != null) return;

    for (1..width()) |_| {
        const thread = std.Thread.spawn(.{}, work, .{}) catch break;

        thread.detach();
    }

    state.store(.started, .release);
}

/// Wakes as many workers as a spread can take.
fn wake(count: usize) void {
    _ = signal.fetchAdd(1, .release);

    io().futexWake(u32, &signal.raw, @intCast(count));
}

fn work() void {
    var seen = signal.load(.acquire);

    while (true) {
        if (join()) |found| {
            found.job.run(found.job.context, found.participant);

            _ = found.job.finished.fetchAdd(1, .release);

            io().futexWake(u32, &found.job.finished.raw, 1);

            continue;
        }

        seen = next(seen);
    }
}

/// A free participant of a listed spread, taken.
fn join() ?struct { job: *Job, participant: usize } {
    acquire();

    defer release();

    for (jobs) |slot| {
        const job = slot orelse continue;

        if (job.joined == job.wanted) continue;

        job.joined += 1;

        return .{ .job = job, .participant = job.joined - 1 };
    }

    return null;
}

/// The signal after `seen`, once a spread starts.
fn next(seen: u32) u32 {
    while (true) {
        const value = signal.load(.acquire);

        if (value != seen) return value;

        io().futexWaitUncancelable(u32, &signal.raw, seen);
    }
}

fn acquire() void {
    while (lock.swap(true, .acquire)) std.atomic.spinLoopHint();
}

fn release() void {
    lock.store(false, .release);
}

/// Waiting needs no event loop: the futex of the threaded implementation blocks the calling thread itself.
fn io() std.Io {
    return std.Io.Threaded.global_single_threaded.io();
}
