const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Memo = @import("memo.zig");
const Rounds = @import("rounds.zig");
const Slots = @import("slots.zig");
const Summaries = @import("summaries.zig");
const Unit = @import("root.zig").Unit;
const Self = @This();

/// Body analyses run ahead of the worklist on all cores. The worklist visits one body at a time, and a visit may
/// weaken what later visits read, so the next bodies of the queue are analyzed together against the summaries as they
/// stand, and each result lists the summary levels it read. A visit uses the result only while every level it read
/// still holds, which keeps every result and the order of the worklist those of visiting one body at a time; when the
/// next body has no such result, the bodies ahead of the queue that lack one are analyzed again. A body that calls
/// itself reads what its own visit changes, so it is never analyzed ahead.
rounds: *Rounds,
/// Holds the lists of bodies each round analyzes.
scratch: std.mem.Allocator,
functions: ir.FunctionTable,
slots: Slots,
summaries: *Summaries,
units: []const ?*Unit,
settled: []?Entry(Settled),
demanded: []?Entry(Demanded),
planned: []?Entry(Planned),
pub const Settled = struct { passed: []const Function.Contribution, output: []const Level, reads: []const Function.Read };

pub const Demanded = struct { marks: []const Function.Mark, grew: bool, normalized: []const Memo.Normalized, renewed: []const Memo.Renewed, reads: []const Function.Read };
pub const Planned = struct { flags: []const Function.Flags, renewals: []const Function.Renewal };

/// A result analyzed ahead, or null where the memo already holds one.
fn Entry(comptime Result: type) type {
    return struct { found: ?Result };
}

/// Queued bodies looked at ahead per core: enough to keep the cores busy, few enough that a weakened summary wastes
/// little.
const per_core = 4;

pub fn init(allocator: std.mem.Allocator, rounds: *Rounds, functions: ir.FunctionTable, slots: Slots, summaries: *Summaries, units: []const ?*Unit) std.mem.Allocator.Error!Self {
    var self = Self{
        .rounds = rounds,
        .scratch = allocator,
        .functions = functions,
        .slots = slots,
        .summaries = summaries,
        .units = units,
        .settled = try allocator.alloc(?Entry(Settled), units.len),
        .demanded = try allocator.alloc(?Entry(Demanded), units.len),
        .planned = try allocator.alloc(?Entry(Planned), units.len),
    };

    self.reset();

    return self;
}

/// Drops every result not visited yet.
pub fn reset(self: *Self) void {
    @memset(self.settled, null);
    @memset(self.demanded, null);
    @memset(self.planned, null);
    self.rounds.forget();
}

/// How many queued bodies a round looks at.
pub fn width(self: *const Self) usize {
    return self.rounds.count() * per_core;
}

/// Analyzes the bodies of `indices` that lack a current result once the first of them was never analyzed ahead: a
/// body whose result went stale is visited on the calling thread instead, as its summaries changed only now and the
/// bodies after it may still change them again.
pub fn prepare(self: *Self, comptime kind: Memo.Kind, memo: *Memo, indices: []const usize) std.mem.Allocator.Error!void {
    const first = indices[0];

    if (@field(self, @tagName(kind))[first] != null or self.recursive(first)) return;

    var pending: std.ArrayList(usize) = .empty;

    for (indices) |index| {
        if (self.current(kind, index) or self.recursive(index)) continue;

        const slots = @field(self, @tagName(kind));

        if (try memo.holds(kind, self.summaries, self.units[index].?.state(index))) {
            slots[index] = .{ .found = null };

            continue;
        }

        slots[index] = null;

        try pending.append(self.scratch, index);
    }

    var task = Task(kind){ .ahead = self, .indices = pending.items };

    try self.rounds.each(Task(kind), &task, pending.items.len);
}

/// The result analyzed ahead for body `index` while nothing it reads changed since; once.
pub fn take(self: *Self, comptime kind: Memo.Kind, index: usize) ?Found(kind) {
    const fresh = self.current(kind, index);
    const slot = &@field(self, @tagName(kind))[index];
    const entry = slot.* orelse return null;
    slot.* = null;

    return if (fresh) entry.found else null;
}

/// Where a body analyzed on the calling thread builds the passes it keeps; the calling thread is also the first core
/// of every round, so the passes stay where rounds build them.
pub fn kept(self: *const Self) std.mem.Allocator {
    return self.rounds.workers[0].lasting.allocator();
}

/// Whether body `index` has a result whose reads still hold; the plan pass reads summaries that no longer change.
fn current(self: *const Self, comptime kind: Memo.Kind, index: usize) bool {
    const entry = @field(self, @tagName(kind))[index] orelse return false;
    const found = entry.found orelse return false;

    return kind == .planned or Function.unchanged(self.summaries, found.reads);
}

fn recursive(self: *const Self, index: usize) bool {
    return self.units[index].?.recursive(index);
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
        ahead: *Self,
        indices: []const usize,
        pub fn run(self: *@This(), position: usize, worker: *Rounds.Worker) std.mem.Allocator.Error!void {
            const ahead = self.ahead;
            const index = self.indices[position];
            const unit = ahead.units[index].?;
            const summaries = ahead.summaries;
            const scratch = worker.scratch.allocator();
            const keep = worker.kept.allocator();
            const lasting = worker.lasting.allocator();
            var changed: std.ArrayList(usize) = .empty;
            var reads: std.ArrayList(Function.Read) = .empty;

            const found: Found(kind) = switch (kind) {
                .settled => found: {
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, null);
                    var passed: std.ArrayList(Function.Contribution) = .empty;
                    const output = try keep.alloc(Level, if (index < summaries.output.len) summaries.output[index].len else 0);
                    analysis.deferred = true;
                    analysis.reads = &reads;

                    try analysis.arguments(&changed, &passed);
                    if (index < summaries.output.len) try analysis.output(output);

                    const contributions = try keep.alloc(Function.Contribution, passed.items.len);

                    for (passed.items, contributions) |contribution, *target| target.* = .{ .callee = contribution.callee, .levels = try keep.dupe(Level, contribution.levels) };

                    break :found .{ .passed = contributions, .output = output, .reads = try keep.dupe(Function.Read, reads.items) };
                },
                .demanded => found: {
                    // The growth copies a demand pass leaves are its own; the body's stay as they were until its visit.
                    var normalized = try unit.normalized.cloneWithAllocator(scratch);
                    var renewed = try unit.renewed.cloneWithAllocator(scratch);
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, .{ .normalized = &normalized, .renewed = &renewed });
                    var marked: std.ArrayList(Function.Mark) = .empty;
                    analysis.deferred = true;
                    analysis.reads = &reads;

                    try analysis.demand(&changed, &marked);

                    break :found .{ .marks = try keep.dupe(Function.Mark, marked.items), .grew = analysis.grew, .normalized = try entries(Memo.Normalized, keep, &normalized), .renewed = try entries(Memo.Renewed, keep, &renewed), .reads = try keep.dupe(Function.Read, reads.items) };
                },
                .planned => found: {
                    var analysis = try unit.analyze(scratch, lasting, ahead.functions, ahead.slots, summaries, null);
                    const flags = try keep.alloc(Function.Flags, unit.unit.expressions.count());

                    try analysis.flags(flags);

                    break :found .{ .flags = flags, .renewals = try analysis.renewals(keep) };
                },
            };

            @field(ahead, @tagName(kind))[index] = .{ .found = found };
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
