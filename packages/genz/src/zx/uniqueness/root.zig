const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Order = @import("order.zig");
const Identity = @import("identity.zig");
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

    if (memo.persistent) try identify(temporary, Identity.program(program, basis), units);

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

        try settle(workspace, &work, program, slots, &summaries, units, callers, memo);

        if (!try demand(workspace, &work, program, slots, &summaries, units, callers, memo)) break;
    }

    const plans = try allocator.alloc(Plan, count);
    var entry_plan = Plan{ .flags = &.{} };

    for (units, 0..) |entry, index| {
        const unit = entry orelse {
            if (index < count) plans[index] = .{ .flags = &.{} };

            continue;
        };

        const plan: Plan = if (try memo.getPlanned(&summaries, unit.state(index))) |planned|
            .{ .flags = try allocator.dupe(Flags, planned.flags), .renewals = try copyRenewals(allocator, planned.renewals) }
        else planned: {
            var analysis = try unit.analyze(temporary, program.functions, slots, &summaries);
            const flags = try allocator.alloc(Flags, unit.unit.expressions.count());

            try analysis.flags(flags);

            const result = Plan{ .flags = flags, .renewals = try analysis.renewals(allocator) };

            try memo.putPlanned(result.flags, result.renewals);

            break :planned result;
        };

        if (index < count) plans[index] = plan else entry_plan = plan;
    }

    return .{ .functions = plans, .entry = entry_plan };
}

/// The plan of an entry body analyzed on its own, as a host entry into functions planned for another program: no
/// callee summary is known, so only the body's own appends and growth copies count.
pub fn analyzeEntry(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, basis: *const Basis) std.mem.Allocator.Error!Plan {
    if (program.type_only) return .{ .flags = &.{} };

    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const slots = basis.slots;
    var summaries = try Summaries.create(temporary, program, basis);

    summaries.clear();

    const unit = try prepare(temporary, .{ .symbols = program.symbols, .expressions = program.expressions, .input_type = program.input_type, .output_type = program.output_type, .input = &.{}, .function = null, .normalized = undefined, .renewed = undefined }, program.body.block());

    while (true) {
        var changed: std.ArrayList(usize) = .empty;

        var analysis = try unit.analyze(temporary, program.functions, slots, &summaries);

        var marked: std.ArrayList(Function.Mark) = .empty;

        try analysis.demand(&changed, &marked);

        if (!analysis.grew) break;
    }

    var analysis = try unit.analyze(temporary, program.functions, slots, &summaries);
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
fn settle(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo) std.mem.Allocator.Error!void {
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

        if (try memo.getSettled(summaries, unit.state(index))) |settled| {
            for (settled.passed) |contribution| try Function.replay(round.allocator(), summaries, contribution, &changed);

            @memcpy(output, settled.output);
        } else {
            var passed: std.ArrayList(Function.Contribution) = .empty;
            var analysis = try unit.analyze(round.allocator(), program.functions, slots, summaries);

            try analysis.arguments(&changed, &passed);

            if (index != count) try analysis.output(output);

            try memo.putSettled(passed.items, output);
        }

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
fn demand(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize), memo: *Memo) std.mem.Allocator.Error!bool {
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var added = false;

    while (work.pop()) |index| {
        _ = round.reset(.retain_capacity);

        const unit = units[index].?;
        const state = unit.state(index);
        var changed: std.ArrayList(usize) = .empty;

        if (try memo.getDemanded(summaries, state)) |demanded| {
            for (demanded.marks) |value| try Function.applyMark(round.allocator(), summaries, value, &changed);

            unit.normalized.clearRetainingCapacity();
            unit.renewed.clearRetainingCapacity();

            for (demanded.normalized) |copy| try unit.normalized.put(copy.id, copy.want);
            for (demanded.renewed) |copy| try unit.renewed.put(copy.key, copy.want);

            if (demanded.grew) added = true;
        } else {
            var marked: std.ArrayList(Function.Mark) = .empty;
            var analysis = try unit.analyze(round.allocator(), program.functions, slots, summaries);

            try analysis.demand(&changed, &marked);
            try memo.putDemanded(marked.items, state, analysis.grew);

            if (analysis.grew) added = true;
        }

        for (changed.items) |function| {
            if (function == index) {
                for (callers[function].items) |caller| try work.push(workspace, caller);
            } else if (units[function] != null) try work.push(workspace, function);
        }
    }

    return added;
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

    for (0..expressions.count()) |index| switch (expressions.at(index).value) {
        .call => |invocation| if (std.mem.indexOfScalar(u32, result.items, @backingInt(invocation.function)) == null) try result.append(allocator, @backingInt(invocation.function)),
        else => {},
    };

    return result.items;
}
