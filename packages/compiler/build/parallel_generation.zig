const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
pub const Job = struct { entry: []const u8, output: []const u8, types: ?[]const u8 = null };
pub const Inputs = struct { modules: []const rx.ModuleSource, sources: []const compiler.project.Source, interfaces: []const compiler.project.NativeInterface };
const maximum_workers = 8;
const stack_size = 64 * 1024 * 1024;

const Queue = struct {
    jobs: []const Job,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    fn take(self: *Queue) ?Job {
        if (self.failure.load(.acquire) != 0) return null;

        const index = self.next.fetchAdd(1, .monotonic);

        return if (index < self.jobs.len) self.jobs[self.jobs.len - 1 - index] else null;
    }
    fn fail(self: *Queue, err: anyerror) void {
        _ = self.failure.cmpxchgStrong(0, @intFromError(err), .acq_rel, .acquire);
    }
};

/// Bootstrap entries share only read-only inputs, so workers generate them concurrently; the largest closures sit at the end of the list and start first.
pub fn run(init: std.process.Init, jobs: []const Job, inputs: Inputs, comptime generate: fn (std.process.Init, Inputs, Job) anyerror!void) !void {
    const Worker = struct {
        fn work(queue: *Queue, context: std.process.Init, shared: Inputs) void {
            while (queue.take()) |job| generate(context, shared, job) catch |err| queue.fail(err);
        }
    };

    var queue = Queue{ .jobs = jobs };
    const threads = try init.gpa.alloc(std.Thread, @min(jobs.len, @min(maximum_workers, std.Thread.getCpuCount() catch 1)));

    defer init.gpa.free(threads);

    var spawned: usize = 0;

    defer for (threads[0..spawned]) |thread| thread.join();

    for (threads) |*thread| {
        thread.* = try std.Thread.spawn(.{ .stack_size = stack_size }, Worker.work, .{ &queue, init, inputs });
        spawned += 1;
    }

    for (threads[0..spawned]) |thread| thread.join();

    spawned = 0;

    const failure = queue.failure.load(.acquire);

    if (failure != 0) return @errorFromInt(failure);
}
