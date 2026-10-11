const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Order = @import("order.zig");
const Identity = @import("identity.zig");
const Trace = @import("trace.zig");
pub const Memo = @import("memo.zig");
const Sites = @import("sites.zig");
const Pool = @import("pool.zig");
const Ahead = @import("ahead.zig");
pub const Basis = @import("basis.zig");
pub const Slots = @import("slots.zig");
pub const Summaries = @import("summaries.zig");
pub const Flags = Function.Flags;
/// How every list update of the program lowers. Appends extend a headered buffer in place when the appended value
/// sits at the buffer's frontier, checked at run time, so they need no uniqueness; element writes and pops rely on
/// static uniqueness. Facts start optimistic and only ever weaken, so the greatest fixpoint is sound. Plain lists that
/// reach an append get one growth copy where they enter; each new copy restarts the fixpoint, and copies only accrue.
pub const Renewal = Function.Renewal;

pub const Plan = struct {
    flags: []const Flags,
    renewals: []const Renewal = &.{},
    pub fn get(self: Plan, id: ir.ExprId) Flags {
        const index = @backingInt(id);

        return if (index < self.flags.len) self.flags[index] else .{};
    }
};

pub const Result = struct { functions: []const Plan, entry: Plan };

pub const Unit = struct {
    unit: Function.Unit,
    body: ir.Block,
    /// Built on the body's first analysis; a build that replays every state of the body never needs them.
    passes: ?Passes = null,
    normalized: std.AutoHashMap(ir.ExprId, Level),
    renewed: std.AutoHashMap(u64, Level),
    callees: []const u32,
    identity: [32]u8 = @splat(0),
    const Passes = struct { order: Order, sites: Sites };
    /// Growth copies a demand pass grows apart from the body's own.
    pub const Growth = struct { normalized: *std.AutoHashMap(ir.ExprId, Level), renewed: *std.AutoHashMap(u64, Level) };

    /// Whether the body calls itself, so that its visit changes what it reads.
    pub fn recursive(self: *const Unit, index: usize) bool {
        return std.mem.indexOfScalar(u32, self.callees, @intCast(index)) != null;
    }

    pub fn state(self: *const Unit, index: usize) Memo.State {
        return .{ .identity = self.identity, .index = index, .input = self.unit.input, .callees = self.callees, .normalized = &self.normalized, .renewed = &self.renewed };
    }
    /// The passes over the body are built on first use in `lasting`, which outlives every later analysis.
    pub fn analyze(self: *Unit, allocator: std.mem.Allocator, lasting: std.mem.Allocator, functions: ir.FunctionTable, slots: Slots, summaries: *Summaries, growth: ?Growth) std.mem.Allocator.Error!Function {
        if (self.passes == null) {
            const order = try Order.create(lasting, self.unit.symbols, self.unit.expressions, self.body);

            self.passes = .{ .order = order, .sites = undefined };
            const passes = &self.passes.?;
            passes.sites = try Sites.create(lasting, &passes.order, slots, self.unit.symbols, self.unit.expressions, summaries);
            self.unit.operations = try Function.collectOperations(lasting, &passes.order, self.unit.expressions);
            self.unit.rows = try Function.readRows(lasting, self.unit.expressions);
        }

        const passes = &self.passes.?;
        var unit = self.unit;

        if (growth) |copies| {
            unit.normalized = copies.normalized;
            unit.renewed = copies.renewed;
        }

        return Function.analyze(allocator, functions, unit, &passes.order, &passes.sites, slots, summaries);
    }
};

/// Analyses per body before giving up on a fixpoint and keeping no facts.
const budget = 64;

/// `exported` functions are also called from outside the program, so nothing is known about their input. A persistent
/// `memo` carries body analyses over from earlier programs; without one, repeated states only replay within this call.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Basis, persistent: ?*Memo) std.mem.Allocator.Error!Result {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    var local = Memo.init(workspace, false);

    defer local.deinit();

    const memo = persistent orelse &local;
    const temporary = scratch.allocator();
    const slots = basis.slots;
    var summaries = try Summaries.create(temporary, program, basis);
    const count = program.functions.count();
    const units = try temporary.alloc(?*Unit, count + 1);
    const callers = try temporary.alloc(std.ArrayList(usize), count);
    const known = try temporary.alloc(bool, count);

    for (callers) |*values| values.* = .empty;

    for (0..count) |index| {
        const function = program.functions.at(index);

        units[index] = if (function.external != null) null else try prepare(temporary, .{ .symbols = function.symbols, .expressions = function.expressions, .input_type = function.input_type, .output_type = function.output_type, .input = summaries.input[index], .function = index, .normalized = undefined, .renewed = undefined }, function.body.block());
    }

    units[count] = if (program.type_only) null else try prepare(temporary, .{ .symbols = program.symbols, .expressions = program.expressions, .input_type = program.input_type, .output_type = program.output_type, .input = &.{}, .function = null, .normalized = undefined, .renewed = undefined }, program.body.block());

    const shared = if (memo.persistent) Identity.program(program, basis) else @as([32]u8, @splat(0));

    if (memo.persistent) identify(shared, units);

    var replay = try follow(temporary, memo, shared, exported, units);

    if (try shortcut(allocator, temporary, program, slots, &summaries, units, memo, &replay)) |result| return result;

    var pool = try Pool.init(temporary);

    defer pool.deinit();

    var ahead = try Ahead.init(temporary, &pool, program.functions, slots, &summaries, units);

    for (units, 0..) |entry, caller| {
        const unit = entry orelse continue;

        for (unit.callees) |callee| try callers[callee].append(temporary, caller);
    }

    for (callers, known) |list, *reached| reached.* = list.items.len != 0;
    for (exported) |id| known[@backingInt(id)] = false;

    var work = Work{ .queued = try temporary.alloc(bool, count + 1) };

    defer work.queue.deinit(workspace);

    while (true) {
        summaries.reset(program, known);

        try settle(workspace, &work, program, slots, &summaries, units, callers, memo, &replay, &ahead);
        if (!try demand(workspace, &work, program, slots, &summaries, units, callers, memo, &replay, &ahead)) break;
    }

    try work.fill(workspace, units);

    ahead.begin(.planned);
    defer ahead.finish();

    const plans = try allocator.alloc(Plan, count);
    var entry_plan = Plan{ .flags = &.{} };

    for (units, 0..) |entry, index| {
        const unit = entry orelse {
            if (index < count) plans[index] = .{ .flags = &.{} };

            continue;
        };

        try lookAhead(.planned, &work, memo, &replay, &ahead);

        _ = work.pop();

        const recalled = replay.recall(.planned, index) orelse try memo.getPlanned(&summaries, unit.state(index));
        const early = try ahead.take(.planned, index);

        const planned = recalled orelse if (early) |found| try memo.putPlanned(memo.key, found.flags, found.renewals) else planned: {
            var analysis = try unit.analyze(temporary, temporary, program.functions, slots, &summaries, null);
            const flags = try temporary.alloc(Flags, unit.unit.expressions.count());

            try analysis.flags(flags);

            break :planned try memo.putPlanned(memo.key, flags, try analysis.renewals(temporary));
        };

        try replay.met(.planned, index, planned, memo);

        const plan = Plan{ .flags = try allocator.dupe(Flags, planned.flags), .renewals = try copyRenewals(allocator, planned.renewals) };

        if (index < count) plans[index] = plan else entry_plan = plan;
    }

    if (memo.persistent) {
        const trace = try replay.finish(memo.arena.child_allocator);

        if (memo.trace) |*previous| previous.deinit();

        memo.trace = trace;
    }

    return .{ .functions = plans, .entry = entry_plan };
}

/// The plan of an entry body analyzed on its own, as a host entry into functions planned for another program: no
/// callee summary is known, so only the body's own appends and growth copies count.
pub fn analyzeEntry(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, basis: *const Basis) std.mem.Allocator.Error!Plan {
    if (program.type_only) return .{ .flags = &.{} };

    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    var summaries = try Summaries.create(scratch.allocator(), program, basis);

    return analyzeEntryWith(allocator, workspace, program, basis, &summaries);
}

/// `analyzeEntry` over summaries created once for the program's functions, so entries into the same functions share
/// them; they are cleared first.
pub fn analyzeEntryWith(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, basis: *const Basis, summaries: *Summaries) std.mem.Allocator.Error!Plan {
    if (program.type_only) return .{ .flags = &.{} };

    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const slots = basis.slots;

    summaries.clear();
    summaries.clearWants();

    const unit = try prepare(temporary, .{ .symbols = program.symbols, .expressions = program.expressions, .input_type = program.input_type, .output_type = program.output_type, .input = &.{}, .function = null, .normalized = undefined, .renewed = undefined }, program.body.block());

    while (true) {
        var changed: std.ArrayList(usize) = .empty;
        var analysis = try unit.analyze(temporary, temporary, program.functions, slots, summaries, null);
        var marked: std.ArrayList(Function.Mark) = .empty;

        try analysis.demand(&changed, &marked);
        if (!analysis.grew) break;
    }

    var analysis = try unit.analyze(temporary, temporary, program.functions, slots, summaries, null);
    const flags = try allocator.alloc(Flags, program.expressions.count());

    try analysis.flags(flags);

    return .{ .flags = flags, .renewals = try analysis.renewals(allocator) };
}

/// Bodies whose facts may have changed, each queued at most once; the entry body is the last index.
const Work = struct {
    queue: std.ArrayList(usize) = .empty,
    head: usize = 0,
    queued: []bool,
    fn fill(self: *Work, allocator: std.mem.Allocator, units: []const ?*Unit) std.mem.Allocator.Error!void {
        self.queue.clearRetainingCapacity();

        self.head = 0;

        @memset(self.queued, false);

        for (units, 0..) |entry, index| if (entry != null) try self.push(allocator, index);
    }
    fn push(self: *Work, allocator: std.mem.Allocator, index: usize) std.mem.Allocator.Error!void {
        if (self.queued[index]) return;

        self.queued[index] = true;

        try self.queue.append(allocator, index);
    }
    fn pop(self: *Work) ?usize {
        if (self.head == self.queue.items.len) return null;

        const index = self.queue.items[self.head];

        self.head += 1;
        self.queued[index] = false;

        return index;
    }
};

/// Queues body `index` again after a summary it reads changed.
fn requeue(workspace: std.mem.Allocator, work: *Work, ahead: *Ahead, index: usize) std.mem.Allocator.Error!void {
    ahead.invalidate(index);

    try work.push(workspace, index);
}

/// Queues for analysis ahead the bodies at the front of the queue, unless the worklist follows a trace, whose visits
/// are recalled instead of analyzed.
fn lookAhead(comptime kind: Memo.Kind, work: *const Work, memo: *Memo, replay: *const Trace.Replay, ahead: *Ahead) std.mem.Allocator.Error!void {
    if (replay.trace != null) return;
    try ahead.request(kind, memo, work.queue.items[work.head..@min(work.queue.items.len, work.head + ahead.width())]);
}

fn restoreGrowth(unit: *Unit, normalized: []const Memo.Normalized, renewed: []const Memo.Renewed) std.mem.Allocator.Error!void {
    unit.normalized.clearRetainingCapacity();
    unit.renewed.clearRetainingCapacity();

    for (normalized) |copy| try unit.normalized.put(copy.id, copy.want);
    for (renewed) |copy| try unit.renewed.put(copy.key, copy.want);
}

/// The greatest fixpoint of the summaries for the current growth copies, or no facts if it does not settle in time. A
/// body is analyzed again only when a callee output it reads or its own input weakened.
fn settle(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo, replay: *Trace.Replay, ahead: *Ahead) std.mem.Allocator.Error!void {
    const count = program.functions.count();
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var remaining = budget * units.len;

    ahead.begin(.settled);
    defer ahead.finish();

    while (true) {
        try lookAhead(.settled, work, memo, replay, ahead);

        const index = work.pop() orelse break;

        if (remaining == 0) {
            ahead.finish();

            return summaries.clear();
        }

        remaining -= 1;
        _ = round.reset(.retain_capacity);
        const unit = units[index].?;
        var changed: std.ArrayList(usize) = .empty;
        const output = try round.allocator().alloc(Level, if (index == count) 0 else summaries.output[index].len);
        const recalled = replay.recall(.settled, index) orelse try memo.getSettled(summaries, unit.state(index));
        const early = try ahead.take(.settled, index);
        const known = recalled orelse if (early) |found| try memo.putSettled(memo.key, found.passed, found.output) else null;

        const settled = if (known) |settled| replayed: {
            for (settled.passed) |contribution| try Function.replay(round.allocator(), summaries, contribution, &changed);

            break :replayed settled;
        } else analyzed: {
            var passed: std.ArrayList(Function.Contribution) = .empty;
            var analysis = try unit.analyze(round.allocator(), ahead.kept(), program.functions, slots, summaries, null);

            try analysis.arguments(&changed, &passed);

            if (index != count) try analysis.output(output);

            break :analyzed try memo.putSettled(memo.key, passed.items, output);
        };

        try replay.met(.settled, index, settled, memo);

        @memcpy(output, settled.output);

        for (changed.items) |callee| if (units[callee] != null) try requeue(workspace, work, ahead, callee);
        if (index == count) continue;

        var weakened = false;

        for (output, summaries.output[index]) |next, *current| {
            const met = current.meet(next);

            if (met == current.*) continue;

            Level.store(current, met);

            weakened = true;
        }

        if (!weakened) continue;
        for (callers[index].items) |caller| try requeue(workspace, work, ahead, caller);
    }
}

/// Spreads the growth-copy demand until no input, output or copy is newly demanded; reports whether copies were added.
fn demand(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo, replay: *Trace.Replay, ahead: *Ahead) std.mem.Allocator.Error!bool {
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var added = false;

    ahead.begin(.demanded);
    defer ahead.finish();

    while (true) {
        try lookAhead(.demanded, work, memo, replay, ahead);

        const index = work.pop() orelse break;
        _ = round.reset(.retain_capacity);
        const unit = units[index].?;
        const state = unit.state(index);
        var changed: std.ArrayList(usize) = .empty;
        const recalled = replay.recall(.demanded, index) orelse try memo.getDemanded(summaries, state);
        const early = try ahead.take(.demanded, index);

        const demanded = if (recalled) |demanded| replayed: {
            for (demanded.marks) |value| try Function.applyMark(round.allocator(), summaries, value, &changed);

            try restoreGrowth(unit, demanded.normalized, demanded.renewed);

            break :replayed demanded;
        } else if (early) |found| ahead: {
            try restoreGrowth(unit, found.normalized, found.renewed);
            for (found.marks) |value| try Function.applyMark(round.allocator(), summaries, value, &changed);

            break :ahead try memo.putDemanded(memo.key, found.marks, state, found.grew);
        } else analyzed: {
            var marked: std.ArrayList(Function.Mark) = .empty;
            var analysis = try unit.analyze(round.allocator(), ahead.kept(), program.functions, slots, summaries, null);

            try analysis.demand(&changed, &marked);

            break :analyzed try memo.putDemanded(memo.key, marked.items, state, analysis.grew);
        };

        try replay.met(.demanded, index, demanded, memo);
        if (demanded.grew) added = true;

        for (changed.items) |function| {
            if (function == index) {
                for (callers[function].items) |caller| try requeue(workspace, work, ahead, caller);
            } else if (units[function] != null) try requeue(workspace, work, ahead, function);
        }
    }

    return added;
}

/// The plans of an analysis that takes the path of the trace it follows, known without walking it: every changed body,
/// analyzed again in each state the trace met it in, settles and demands as recorded, so every other body meets what
/// it met before. Only the plans of the changed bodies are new. Null, with the summaries and growth copies as they
/// were, when a changed body differs.
fn shortcut(allocator: std.mem.Allocator, temporary: std.mem.Allocator, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, memo: *Memo, replay: *const Trace.Replay) std.mem.Allocator.Error!?Result {
    if (replay.trace == null) return null;

    const trace = &memo.trace.?;
    const planned = try temporary.alloc(?Memo.Planned, units.len);

    @memset(planned, null);

    for (units, replay.changed, planned, 0..) |entry, changed, *plan, index| {
        const unit = entry orelse continue;

        if (trace.of(.planned, index).values.len != 1) return null;
        if (!changed) continue;

        inline for (.{ Memo.Kind.settled, Memo.Kind.demanded }) |kind| {
            const visits = trace.of(kind, index);

            for (visits.values, visits.states) |recorded, state| {
                const value = try revisit(kind, temporary, program, slots, summaries, unit, index, memo, state) orelse return undo(summaries, units, replay.changed);

                if (!try Trace.agree(kind, temporary, recorded, value)) return undo(summaries, units, replay.changed);
            }
        }

        plan.* = try revisit(.planned, temporary, program, slots, summaries, unit, index, memo, trace.of(.planned, index).states[0]) orelse return undo(summaries, units, replay.changed);
    }

    const count = program.functions.count();
    const plans = try allocator.alloc(Plan, count);
    var entry_plan = Plan{ .flags = &.{} };

    for (units, planned, 0..) |entry, renewed, index| {
        const plan: Plan = if (entry == null) .{ .flags = &.{} } else plan: {
            const value = &trace.of(.planned, index).values[0];

            if (renewed) |replacement| value.* = replacement;

            break :plan .{ .flags = try allocator.dupe(Flags, value.flags), .renewals = try copyRenewals(allocator, value.renewals) };
        };

        if (index < count) plans[index] = plan else entry_plan = plan;
    }

    @memcpy(trace.identities, replay.identities);

    return .{ .functions = plans, .entry = entry_plan };
}

/// The result body `index` reaches in a recorded state: the memo's when it has one, or a new analysis in that state.
fn revisit(comptime kind: Memo.Kind, temporary: std.mem.Allocator, program: ir.Program, slots: Slots, summaries: *Summaries, unit: *Unit, index: usize, memo: *Memo, state: []const u8) std.mem.Allocator.Error!?Memo.Result(kind) {
    if (try memo.find(kind, unit.identity, state)) |value| return value;
    if (!try Memo.restore(kind, state, summaries, index, unit.callees, &unit.normalized, &unit.renewed)) return null;

    var changed: std.ArrayList(usize) = .empty;
    var analysis = try unit.analyze(temporary, temporary, program.functions, slots, summaries, null);

    switch (kind) {
        .settled => {
            var passed: std.ArrayList(Function.Contribution) = .empty;
            const output = try temporary.alloc(Level, if (index < summaries.output.len) summaries.output[index].len else 0);

            try analysis.arguments(&changed, &passed);
            if (index < summaries.output.len) try analysis.output(output);

            return try memo.putSettled(memo.key, passed.items, output);
        },
        .demanded => {
            var marked: std.ArrayList(Function.Mark) = .empty;

            try analysis.demand(&changed, &marked);

            return try memo.putDemanded(memo.key, marked.items, unit.state(index), analysis.grew);
        },
        .planned => {
            const flags = try temporary.alloc(Flags, unit.unit.expressions.count());

            try analysis.flags(flags);

            return try memo.putPlanned(memo.key, flags, try analysis.renewals(temporary));
        },
    }
}

/// Clears what revisiting changed bodies left behind, as the fixpoint expects to start from.
fn undo(summaries: *Summaries, units: []const ?*Unit, changed: []const bool) ?Result {
    summaries.clearWants();

    for (units, changed) |entry, differs| if (differs) if (entry) |unit| {
        unit.normalized.clearRetainingCapacity();
        unit.renewed.clearRetainingCapacity();
    };

    return null;
}

/// The replay of the memo's last analysis, which this one follows when it ran for the same program shape and exports.
fn follow(allocator: std.mem.Allocator, memo: *const Memo, shared: [32]u8, exported: []const ir.FunctionId, units: []const ?*Unit) std.mem.Allocator.Error!Trace.Replay {
    const identities = try allocator.alloc(Trace.Digest, units.len);
    const calls = try allocator.alloc([]const u32, units.len);

    for (units, identities, calls) |entry, *identity, *called| {
        identity.* = if (entry) |unit| unit.identity else @splat(0);
        called.* = if (entry) |unit| unit.callees else &.{};
    }

    var hash = @import("zx").Sha256.init(.{});

    hash.update(&shared);
    hash.update(std.mem.sliceAsBytes(exported));

    const previous = if (memo.persistent) if (memo.trace) |*trace| trace else null else null;

    return .init(allocator, previous, hash.finalResult(), identities, calls);
}

fn prepare(allocator: std.mem.Allocator, unit: Function.Unit, body: ir.Block) std.mem.Allocator.Error!*Unit {
    const result = try allocator.create(Unit);
    result.* = .{ .unit = unit, .body = body, .normalized = .init(allocator), .renewed = .init(allocator), .callees = try callees(allocator, unit.expressions) };
    result.unit.normalized = &result.normalized;
    result.unit.renewed = &result.renewed;

    return result;
}

/// Gives every body its content identity; bodies hash independently, so all cores share the work.
fn identify(shared: [32]u8, units: []const ?*Unit) void {
    const Hashing = struct {
        shared: [32]u8,
        units: []const ?*Unit,
        next: std.atomic.Value(usize) = .init(0),
        fn run(work: *@This(), _: usize) void {
            while (true) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.units.len) return;

                const unit = work.units[index] orelse continue;
                unit.identity = Identity.body(work.shared, unit.unit.symbols, unit.unit.expressions, unit.body, unit.unit.input_type, unit.unit.output_type);
            }
        }
    };

    var work = Hashing{ .shared = shared, .units = units };

    @import("zx").parallel.spread(Hashing, &work, Hashing.run, units.len);
}

fn copyRenewals(allocator: std.mem.Allocator, renewals: []const Renewal) std.mem.Allocator.Error![]const Renewal {
    const result = try allocator.alloc(Renewal, renewals.len);

    for (renewals, result) |renewal, *target| target.* = .{ .owner = renewal.owner, .path = try allocator.dupe(u32, renewal.path) };

    return result;
}

/// The functions a body calls, each once in order of first call.
fn callees(allocator: std.mem.Allocator, expressions: ir.ExpressionTable) std.mem.Allocator.Error![]const u32 {
    var result: std.ArrayList(u32) = .empty;

    for (0..expressions.count()) |index| {
        const function = @backingInt(expressions.callee(index) orelse continue);

        if (std.mem.indexOfScalar(u32, result.items, function) == null) try result.append(allocator, function);
    }

    return result.items;
}
