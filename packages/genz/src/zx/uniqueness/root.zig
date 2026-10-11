const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("function.zig");
const Level = @import("level.zig").Level;
const Order = @import("order.zig");
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

const Unit = struct { unit: Function.Unit, order: Order, sites: Sites, normalized: std.AutoHashMap(ir.ExprId, Level), renewed: std.AutoHashMap(u64, Level) };

/// Analyses per body before giving up on a fixpoint and keeping no facts.
const budget = 64;

/// `exported` functions are also called from outside the program, so nothing is known about their input.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Basis) std.mem.Allocator.Error!Result {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

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

        units[index] = if (function.external != null) null else try prepare(temporary, slots, .{ .symbols = function.symbols, .expressions = function.expressions, .input_type = function.input_type, .output_type = function.output_type, .input = summaries.input[index], .function = index, .normalized = undefined, .renewed = undefined }, function.body.block(), &summaries);
    }

    units[count] = if (program.type_only) null else try prepare(temporary, slots, .{ .symbols = program.symbols, .expressions = program.expressions, .input_type = program.input_type, .output_type = program.output_type, .input = &.{}, .function = null, .normalized = undefined, .renewed = undefined }, program.body.block(), &summaries);

    for (units, 0..) |entry, caller| {
        const unit = entry orelse continue;

        for (0..unit.unit.expressions.count()) |expression| switch (unit.unit.expressions.get(@fromBackingInt(@intCast(expression))).value) {
            .call => |invocation| {
                const list = &callers[@backingInt(invocation.function)];

                if (list.items.len == 0 or list.items[list.items.len - 1] != caller) try list.append(temporary, caller);
            },
            else => {},
        };
    }

    for (callers, known) |list, *reached| reached.* = list.items.len != 0;
    for (exported) |id| known[@backingInt(id)] = false;

    var work = Work{ .queued = try temporary.alloc(bool, count + 1) };

    defer work.queue.deinit(workspace);

    while (true) {
        summaries.reset(program, known);

        try settle(workspace, &work, program, slots, &summaries, units, callers);

        if (!try demand(workspace, &work, program, slots, &summaries, units, callers)) break;
    }

    const plans = try allocator.alloc(Plan, count);
    var entry_plan = Plan{ .flags = &.{} };

    for (units, 0..) |entry, index| {
        const unit = entry orelse {
            if (index < count) plans[index] = .{ .flags = &.{} };

            continue;
        };

        var analysis = try Function.analyze(temporary, program.functions, unit.unit, &unit.order, &unit.sites, slots, &summaries);
        const flags = try allocator.alloc(Flags, unit.unit.expressions.count());

        try analysis.flags(flags);

        const plan = Plan{ .flags = flags, .renewals = try analysis.renewals(allocator) };

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

    const unit = try prepare(temporary, slots, .{ .symbols = program.symbols, .expressions = program.expressions, .input_type = program.input_type, .output_type = program.output_type, .input = &.{}, .function = null, .normalized = undefined, .renewed = undefined }, program.body.block(), &summaries);

    while (true) {
        var changed: std.ArrayList(usize) = .empty;

        var analysis = try Function.analyze(temporary, program.functions, unit.unit, &unit.order, &unit.sites, slots, &summaries);

        try analysis.demand(&changed);

        if (!analysis.grew) break;
    }

    var analysis = try Function.analyze(temporary, program.functions, unit.unit, &unit.order, &unit.sites, slots, &summaries);
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
fn settle(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize)) std.mem.Allocator.Error!void {
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

        var analysis = try Function.analyze(round.allocator(), program.functions, unit.unit, &unit.order, &unit.sites, slots, summaries);

        try analysis.arguments(&changed);

        for (changed.items) |callee| if (units[callee] != null) try work.push(workspace, callee);

        if (index == count) continue;

        const output = try round.allocator().alloc(Level, summaries.output[index].len);
        var weakened = false;

        try analysis.output(output);

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
fn demand(workspace: std.mem.Allocator, work: *Work, program: ir.Program, slots: Slots, summaries: *Summaries, units: []const ?*Unit, callers: []const std.ArrayList(usize)) std.mem.Allocator.Error!bool {
    var round = std.heap.ArenaAllocator.init(workspace);

    defer round.deinit();

    try work.fill(workspace, units);

    var added = false;

    while (work.pop()) |index| {
        _ = round.reset(.retain_capacity);

        const unit = units[index].?;
        var changed: std.ArrayList(usize) = .empty;

        var analysis = try Function.analyze(round.allocator(), program.functions, unit.unit, &unit.order, &unit.sites, slots, summaries);

        try analysis.demand(&changed);

        if (analysis.grew) added = true;

        for (changed.items) |function| {
            if (function == index) {
                for (callers[function].items) |caller| try work.push(workspace, caller);
            } else if (units[function] != null) try work.push(workspace, function);
        }
    }

    return added;
}

fn prepare(allocator: std.mem.Allocator, slots: Slots, unit: Function.Unit, body: ir.Block, summaries: *const Summaries) std.mem.Allocator.Error!*Unit {
    const result = try allocator.create(Unit);

    result.unit = unit;
    result.normalized = .init(allocator);
    result.renewed = .init(allocator);
    result.unit.normalized = &result.normalized;
    result.unit.renewed = &result.renewed;
    result.order = try Order.create(allocator, unit.symbols, unit.expressions, body);
    result.sites = try Sites.create(allocator, &result.order, slots, unit.symbols, unit.expressions, summaries);
    result.unit.operations = try Function.collectOperations(allocator, &result.order, unit.expressions);
    result.unit.rows = try Function.readRows(allocator, unit.expressions);

    return result;
}
