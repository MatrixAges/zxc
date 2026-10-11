const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Order = @import("order.zig");
const Identity = @import("identity.zig");
const Trace = @import("trace.zig");
pub const Memo = @import("memo.zig");
const Sites = @import("sites.zig");
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

const Unit = struct {
    allocator: std.mem.Allocator,
    unit: Function.Unit,
    body: ir.Block,
    /// Built on the body's first analysis; a build that replays every state of the body never needs them.
    passes: ?Passes = null,
    normalized: std.AutoHashMap(ir.ExprId, Level),
    renewed: std.AutoHashMap(u64, Level),
    callees: []const u32,
    identity: [32]u8 = @splat(0),

    const Passes = struct { order: Order, sites: Sites };

    fn state(self: *const Unit, index: usize) Memo.State {
        return .{ .identity = self.identity, .index = index, .input = self.unit.input, .callees = self.callees, .normalized = &self.normalized, .renewed = &self.renewed };
    }

    fn analyze(self: *Unit, allocator: std.mem.Allocator, functions: ir.FunctionTable, slots: Slots, summaries: *Summaries) std.mem.Allocator.Error!Function {
        if (self.passes == null) {
            const order = try Order.create(self.allocator, self.unit.symbols, self.unit.expressions, self.body);

            self.passes = .{ .order = order, .sites = undefined };

            const passes = &self.passes.?;

            passes.sites = try Sites.create(self.allocator, &passes.order, slots, self.unit.symbols, self.unit.expressions, summaries);
            self.unit.operations = try Function.collectOperations(self.allocator, &passes.order, self.unit.expressions);
            self.unit.rows = try Function.readRows(self.allocator, self.unit.expressions);
        }

        const passes = &self.passes.?;

        return Function.analyze(allocator, functions, self.unit, &passes.order, &passes.sites, slots, summaries);
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

    if (memo.persistent) try identify(temporary, shared, units);

    var replay = try follow(temporary, memo, shared, exported, units);

    if (try shortcut(allocator, temporary, program, slots, &summaries, units, memo, &replay)) |result| return result;

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

        try settle(workspace, &work, program, slots, &summaries, units, callers, memo, &replay);

        if (!try demand(workspace, &work, program, slots, &summaries, units, callers, memo, &replay)) break;
    }

    const plans = try allocator.alloc(Plan, count);
    var entry_plan = Plan{ .flags = &.{} };

    for (units, 0..) |entry, index| {
        const unit = entry orelse {
            if (index < count) plans[index] = .{ .flags = &.{} };

            continue;
        };

        const recalled = replay.recall(.planned, index) orelse try memo.getPlanned(&summaries, unit.state(index));
        const planned = recalled orelse planned: {
            var analysis = try unit.analyze(temporary, program.functions, slots, &summaries);
            const flags = try temporary.alloc(Flags, unit.unit.expressions.count());

            try analysis.flags(flags);

            break :planned try memo.putPlanned(flags, try analysis.renewals(temporary));
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

        var analysis = try unit.analyze(temporary, program.functions, slots, summaries);

        var marked: std.ArrayList(Function.Mark) = .empty;

        try analysis.demand(&changed, &marked);

        if (!analysis.grew) break;
    }

    var analysis = try unit.analyze(temporary, program.functions, slots, summaries);
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

/// The greatest fixpoint of the summaries for the current growth copies, or no facts if it does not settle in time. A
/// body is analyzed again only when a callee output it reads or its own input weakened.
fn settle(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo, replay: *Trace.Replay) std.mem.Allocator.Error!void {
    const count = program.functions.count();
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var remaining = budget * units.len;

    while (work.pop()) |index| {
        if (remaining == 0) return summaries.clear();

        remaining -= 1;
        _ = round.reset(.retain_capacity);

        const unit = units[index].?;
        var changed: std.ArrayList(usize) = .empty;
        const output = try round.allocator().alloc(Level, if (index == count) 0 else summaries.output[index].len);

        const recalled = replay.recall(.settled, index) orelse try memo.getSettled(summaries, unit.state(index));
        const settled = if (recalled) |settled| replayed: {
            for (settled.passed) |contribution| try Function.replay(round.allocator(), summaries, contribution, &changed);

            break :replayed settled;
        } else analyzed: {
            var passed: std.ArrayList(Function.Contribution) = .empty;
            var analysis = try unit.analyze(round.allocator(), program.functions, slots, summaries);

            try analysis.arguments(&changed, &passed);

            if (index != count) try analysis.output(output);

            break :analyzed try memo.putSettled(passed.items, output);
        };

        try replay.met(.settled, index, settled, memo);
        @memcpy(output, settled.output);

        for (changed.items) |callee| if (units[callee] != null) try work.push(workspace, callee);

        if (index == count) continue;

        var weakened = false;

        for (output, summaries.output[index]) |next, *current| {
            const met = current.meet(next);

            if (met == current.*) continue;

            current.* = met;
            weakened = true;
        }

        if (weakened) for (callers[index].items) |caller| try work.push(workspace, caller);
    }
}

/// Spreads the growth-copy demand until no input, output or copy is newly demanded; reports whether copies were added.
fn demand(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo, replay: *Trace.Replay) std.mem.Allocator.Error!bool {
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var added = false;

    while (work.pop()) |index| {
        _ = round.reset(.retain_capacity);

        const unit = units[index].?;
        const state = unit.state(index);
        var changed: std.ArrayList(usize) = .empty;

        const recalled = replay.recall(.demanded, index) orelse try memo.getDemanded(summaries, state);
        const demanded = if (recalled) |demanded| replayed: {
            for (demanded.marks) |value| try Function.applyMark(round.allocator(), summaries, value, &changed);

            unit.normalized.clearRetainingCapacity();
            unit.renewed.clearRetainingCapacity();

            for (demanded.normalized) |copy| try unit.normalized.put(copy.id, copy.want);
            for (demanded.renewed) |copy| try unit.renewed.put(copy.key, copy.want);

            break :replayed demanded;
        } else analyzed: {
            var marked: std.ArrayList(Function.Mark) = .empty;
            var analysis = try unit.analyze(round.allocator(), program.functions, slots, summaries);

            try analysis.demand(&changed, &marked);

            break :analyzed try memo.putDemanded(marked.items, state, analysis.grew);
        };

        try replay.met(.demanded, index, demanded, memo);

        if (demanded.grew) added = true;

        for (changed.items) |function| {
            if (function == index) {
                for (callers[function].items) |caller| try work.push(workspace, caller);
            } else if (units[function] != null) try work.push(workspace, function);
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
    var analysis = try unit.analyze(temporary, program.functions, slots, summaries);

    switch (kind) {
        .settled => {
            var passed: std.ArrayList(Function.Contribution) = .empty;
            const output = try temporary.alloc(Level, if (index < summaries.output.len) summaries.output[index].len else 0);

            try analysis.arguments(&changed, &passed);

            if (index < summaries.output.len) try analysis.output(output);

            return try memo.putSettled(passed.items, output);
        },
        .demanded => {
            var marked: std.ArrayList(Function.Mark) = .empty;

            try analysis.demand(&changed, &marked);

            return try memo.putDemanded(marked.items, unit.state(index), analysis.grew);
        },
        .planned => {
            const flags = try temporary.alloc(Flags, unit.unit.expressions.count());

            try analysis.flags(flags);

            return try memo.putPlanned(flags, try analysis.renewals(temporary));
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

    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    hash.update(&shared);
    hash.update(std.mem.sliceAsBytes(exported));

    const previous = if (memo.persistent) if (memo.trace) |*trace| trace else null else null;

    return .init(allocator, previous, hash.finalResult(), identities, calls);
}

fn prepare(allocator: std.mem.Allocator, unit: Function.Unit, body: ir.Block) std.mem.Allocator.Error!*Unit {
    const result = try allocator.create(Unit);

    result.* = .{ .allocator = allocator, .unit = unit, .body = body, .normalized = .init(allocator), .renewed = .init(allocator), .callees = try callees(allocator, unit.expressions) };
    result.unit.normalized = &result.normalized;
    result.unit.renewed = &result.renewed;

    return result;
}

/// Gives every body its content identity; bodies hash independently, so all cores share the work.
fn identify(allocator: std.mem.Allocator, shared: [32]u8, units: []const ?*Unit) std.mem.Allocator.Error!void {
    const Hashing = struct {
        shared: [32]u8,
        units: []const ?*Unit,
        next: std.atomic.Value(usize) = .init(0),

        fn run(work: *@This()) void {
            while (true) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.units.len) return;

                const unit = work.units[index] orelse continue;

                unit.identity = Identity.body(work.shared, unit.unit.symbols, unit.unit.expressions, unit.body, unit.unit.input_type, unit.unit.output_type);
            }
        }
    };

    var work = Hashing{ .shared = shared, .units = units };
    const threads = try allocator.alloc(std.Thread, @min(std.Thread.getCpuCount() catch 1, units.len) -| 1);
    var started: usize = 0;

    for (threads) |*thread| {
        thread.* = std.Thread.spawn(.{}, Hashing.run, .{&work}) catch break;
        started += 1;
    }

    work.run();

    for (threads[0..started]) |thread| thread.join();
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
