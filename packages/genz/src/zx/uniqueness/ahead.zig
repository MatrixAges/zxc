const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Memo = @import("memo.zig");
const Pool = @import("pool.zig");
const Slots = @import("slots.zig");
const Summaries = @import("summaries.zig");
const Unit = @import("root.zig").Unit;
const Self = @This();

/// Body analyses run ahead of the worklist on background threads. The worklist visits one body at a time, and a visit
/// may weaken what later visits read, so background threads analyze the next bodies of the queue against the summaries
/// as they stand while the worklist goes on, and each result lists the summary levels it read. A visit uses the result
/// only if every level it read still holds: the analysis reads nothing else that changes, so it would read the same
/// levels and reach the same result again, which keeps every result and the order of the worklist those of visiting
/// one body at a time. A body that calls itself reads what its own visit changes, so it is never analyzed ahead.
pool: *Pool,
functions: ir.FunctionTable,
slots: Slots,
summaries: *Summaries,
units: []const ?*Unit,
/// Where each body's analysis ahead stands; a background thread owns the body while it runs.
states: []std.atomic.Value(State),
/// Bodies whose summaries changed since their analysis ahead was requested, so that it is likely stale.
dirty: []bool,
settled: []Settled,
demanded: []Demanded,
planned: []Planned,
pub const Settled = struct { passed: []const Function.Contribution, output: []const Level, reads: []const Function.Read };

pub const Demanded = struct { marks: []const Function.Mark, grew: bool, normalized: []const Memo.Normalized, renewed: []const Memo.Renewed, reads: []const Function.Read };
pub const Planned = struct { flags: []const Function.Flags, renewals: []const Function.Renewal };
const State = enum(u8) { idle, queued, running, ready, failed, held };

/// Queued bodies looked at ahead per thread: enough to keep the threads busy while the worklist waits on a chain of
/// changes, few enough that a weakened summary wastes little.
const per_thread = 16;

pub fn init(allocator: std.mem.Allocator, pool: *Pool, functions: ir.FunctionTable, slots: Slots, summaries: *Summaries, units: []const ?*Unit) std.mem.Allocator.Error!Self {
    const states = try allocator.alloc(std.atomic.Value(State), units.len);
    const dirty = try allocator.alloc(bool, units.len);

    @memset(states, .init(.idle));
    @memset(dirty, false);

    return .{
        .pool = pool,
        .functions = functions,
        .slots = slots,
        .summaries = summaries,
        .units = units,
        .states = states,
        .dirty = dirty,
        .settled = try allocator.alloc(Settled, units.len),
        .demanded = try allocator.alloc(Demanded, units.len),
        .planned = try allocator.alloc(Planned, units.len),
    };
}

/// Starts analyzing ahead for the visits of `kind`.
pub fn begin(self: *Self, comptime kind: Memo.Kind) void {
    self.pool.serve(Self, Task(kind).run, self);
}

/// Waits for the analyses ahead still running and drops every result not visited, before the summaries change
/// outside the worklist.
pub fn finish(self: *Self) void {
    self.pool.drain();
    self.pool.forget();
    @memset(self.states, .init(.idle));
    @memset(self.dirty, false);
}

/// Notes that a summary body `index` reads changed, so that its analysis ahead runs again before its visit.
pub fn invalidate(self: *Self, index: usize) void {
    self.dirty[index] = true;
}

/// How many queued bodies are looked at ahead.
pub fn width(self: *const Self) usize {
    return self.pool.count() * per_thread;
}

/// Queues the bodies of `indices` that have no analysis ahead or one that a summary change made stale, skipping those
/// whose result the memo already holds.
pub fn request(self: *Self, comptime kind: Memo.Kind, memo: *Memo, indices: []const usize) std.mem.Allocator.Error!void {
    for (indices) |index| {
        const state = &self.states[index];

        switch (state.load(.monotonic)) {
            .idle => {},
            .ready, .held => if (!self.dirty[index]) continue,
            .queued => {
                self.dirty[index] = false;

                continue;
            },
            .running, .failed => continue,
        }

        if (self.units[index].?.recursive(index)) continue;

        self.dirty[index] = false;

        if (try memo.holds(kind, self.summaries, self.units[index].?.state(index))) {
            state.store(.held, .monotonic);

            continue;
        }

        state.store(.queued, .monotonic);

        if (!self.pool.submit(@intCast(index))) return state.store(.idle, .monotonic);
    }
}

/// The result analyzed ahead for body `index` if every level it read still holds; waits while it is analyzed.
pub fn take(self: *Self, comptime kind: Memo.Kind, index: usize) std.mem.Allocator.Error!?Found(kind) {
    const state = &self.states[index];

    self.dirty[index] = false;

    defer state.store(.idle, .monotonic);

    while (true) {
        switch (state.load(.acquire)) {
            .idle, .held => return null,
            .queued => if (state.cmpxchgWeak(.queued, .idle, .monotonic, .monotonic) == null) return null,
            .running => std.atomic.spinLoopHint(),
            .ready => break,
            .failed => return error.OutOfMemory,
        }
    }

    const found = @field(self, @tagName(kind))[index];

    return if (kind == .planned or Function.unchanged(self.summaries, found.reads)) found else null;
}

/// Where the calling thread builds the passes over a body it analyzes itself.
pub fn kept(self: *const Self) std.mem.Allocator {
    return self.pool.workers[0].lasting.allocator();
}

fn Found(comptime kind: Memo.Kind) type {
    return switch (kind) {
        .settled => Settled,
        .demanded => Demanded,
        .planned => Planned,
    };
}

fn Task(comptime kind: Memo.Kind) type {
    return struct {
        fn run(self: *Self, worker: *Pool.Worker, index: u32) void {
            const state = &self.states[index];

            if (state.cmpxchgStrong(.queued, .running, .acquire, .monotonic) != null) return;

            @field(self, @tagName(kind))[index] = analyze(self, worker, index) catch return state.store(.failed, .release);
            state.store(.ready, .release);
        }
        fn analyze(ahead: *Self, worker: *Pool.Worker, index: usize) std.mem.Allocator.Error!Found(kind) {
            const unit = ahead.units[index].?;
            const summaries = ahead.summaries;
            const scratch = worker.scratch.allocator();
            const keep = worker.kept.allocator();
            const lasting = worker.lasting.allocator();
            var changed: std.ArrayList(usize) = .empty;
            var reads: std.ArrayList(Function.Read) = .empty;

            switch (kind) {
                .settled => {
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, null);
                    var passed: std.ArrayList(Function.Contribution) = .empty;
                    const output = try keep.alloc(Level, if (index < summaries.output.len) summaries.output[index].len else 0);
                    analysis.deferred = true;
                    analysis.reads = &reads;

                    try analysis.arguments(&changed, &passed);
                    if (index < summaries.output.len) try analysis.output(output);

                    const contributions = try keep.alloc(Function.Contribution, passed.items.len);

                    for (passed.items, contributions) |contribution, *target| target.* = .{ .callee = contribution.callee, .levels = try keep.dupe(Level, contribution.levels) };

                    return .{ .passed = contributions, .output = output, .reads = try keep.dupe(Function.Read, reads.items) };
                },
                .demanded => {
                    // The growth copies a demand pass leaves are its own; the body's stay as they were until its visit.
                    var normalized = try unit.normalized.cloneWithAllocator(scratch);
                    var renewed = try unit.renewed.cloneWithAllocator(scratch);
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, .{ .normalized = &normalized, .renewed = &renewed });
                    var marked: std.ArrayList(Function.Mark) = .empty;
                    analysis.deferred = true;
                    analysis.reads = &reads;

                    try analysis.demand(&changed, &marked);

                    return .{ .marks = try keep.dupe(Function.Mark, marked.items), .grew = analysis.grew, .normalized = try entries(Memo.Normalized, keep, &normalized), .renewed = try entries(Memo.Renewed, keep, &renewed), .reads = try keep.dupe(Function.Read, reads.items) };
                },
                .planned => {
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, null);
                    const flags = try keep.alloc(Function.Flags, unit.unit.expressions.count());

                    try analysis.flags(flags);

                    return .{ .flags = flags, .renewals = try analysis.renewals(keep) };
                },
            }
        }
    };
}

fn entries(comptime Item: type, allocator: std.mem.Allocator, map: anytype) std.mem.Allocator.Error![]const Item {
    const result = try allocator.alloc(Item, map.count());
    var values = map.iterator();

    for (result) |*target| {
        const entry = values.next().?;

        target.* = if (Item == Memo.Normalized) .{ .id = entry.key_ptr.*, .want = entry.value_ptr.* } else .{ .key = entry.key_ptr.*, .want = entry.value_ptr.* };
    }

    return result;
}
