const std = @import("std");
const ir = @import("zx").ir;
const Level = @import("level.zig").Level;
const Order = @import("order.zig");
const Sites = @import("sites.zig");
const Slots = @import("slots.zig");
const Summaries = @import("summaries.zig");
const Self = @This();

/// Levels of the list slots of one function body, given what its callers and callees guarantee: loop state reaches its
/// greatest fixpoint, a reference keeps `unique` only while its value is used linearly, and a read inside a task or
/// parallel branch of a value from outside it knows nothing, since another body may extend the same buffer.
pub const Unit = struct {
    symbols: ir.SymbolTable,
    expressions: ir.ExpressionTable,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    input: []const Level,
    function: ?usize,
    normalized: *std.AutoHashMap(ir.ExprId, Level),
    renewed: *std.AutoHashMap(u64, Level),
    /// The reached calls and list updates in expression order, the only nodes the passes over a body act on.
    operations: []const ir.ExprId = &.{},
    /// Every expression row read once up front: the passes revisit each node once per list slot.
    rows: []const ir.ExpressionRow = &.{},
};

pub fn readRows(allocator: std.mem.Allocator, expressions: ir.ExpressionTable) std.mem.Allocator.Error![]const ir.ExpressionRow {
    const result = try allocator.alloc(ir.ExpressionRow, expressions.count());

    for (result, 0..) |*target, index| target.* = expressions.at(index);

    return result;
}

pub fn collectOperations(allocator: std.mem.Allocator, order: *const Order, expressions: ir.ExpressionTable) std.mem.Allocator.Error![]const ir.ExprId {
    var result: std.ArrayList(ir.ExprId) = .empty;

    for (0..expressions.count()) |index| {
        if (order.time[index] == Order.none) continue;

        const id: ir.ExprId = @fromBackingInt(@intCast(index));

        switch (expressions.get(id).value) {
            .call, .list_operation, .list_update => try result.append(allocator, id),
            else => {},
        }
    }

    return result.items;
}

allocator: std.mem.Allocator,
functions: ir.FunctionTable,
expressions: ir.ExpressionTable,
order: *const Order,
sites: *Sites,
slots: Slots,
summaries: *Summaries,
input: []const Level,
function: ?usize,
normalized: *std.AutoHashMap(ir.ExprId, Level),
renewed: *std.AutoHashMap(u64, Level),
operations: []const ir.ExprId,
rows: []const ir.ExpressionRow,
carried: std.AutoHashMapUnmanaged(ir.ExprId, []Level) = .empty,
/// The level of each expression slot once computed, indexed through the sites' slot layout.
levels: []Known,
traced: std.AutoHashMapUnmanaged(u64, void) = .empty,
changed: ?*std.ArrayList(usize) = null,
marked: ?*std.ArrayList(Mark) = null,
grew: bool = false,
/// Records contributions and demands without meeting them into the summaries, which other bodies of the same round
/// read; the round applies them once every body ran.
deferred: bool = false,

/// Every summary level the analysis read, when given: an analysis that reads the same levels again reaches the same
/// result, so the list tells whether a result still holds without analyzing the body again.
reads: ?*std.ArrayList(Read) = null,
pub fn analyze(allocator: std.mem.Allocator, functions: ir.FunctionTable, unit: Unit, order: *const Order, sites: *Sites, slots: Slots, summaries: *Summaries) std.mem.Allocator.Error!Self {
    const levels = try allocator.alloc(Known, sites.slot_first[sites.slot_first.len - 1] - sites.slot_first[unit.symbols.count()]);
    var self = Self{ .allocator = allocator, .functions = functions, .expressions = unit.expressions, .order = order, .sites = sites, .slots = slots, .summaries = summaries, .input = unit.input, .function = unit.function, .normalized = unit.normalized, .renewed = unit.renewed, .operations = unit.operations, .rows = unit.rows, .levels = levels };

    for (order.repeated.items) |id| {
        const state = self.carriedState(id) orelse continue;
        const values = try allocator.alloc(Level, slots.count(self.row(id).type_id));

        for (values, 0..) |*value, slot| value.* = .{
            .headered = true,
            .unique = sites.linear(Sites.symbolRoot(state.parameter), @intCast(slot)) and (state.condition == null or sites.observed(Sites.symbolRoot(state.condition.?), @intCast(slot))),
        };

        try self.carried.put(allocator, id, values);
    }

    var changed = true;

    while (changed) {
        changed = false;

        @memset(self.levels, .unknown);

        var entries = self.carried.iterator();

        while (entries.next()) |entry| {
            const state = self.carriedState(entry.key_ptr.*).?;

            for (entry.value_ptr.*, 0..) |*value, slot| {
                const next = value.meet(try self.entering(entry.key_ptr.*, state.initial, @intCast(slot))).meet(try self.level(state.body, @intCast(slot)));

                if (next == value.*) continue;

                value.* = next;
                changed = true;
            }
        }
    }

    return self;
}

/// The output slots every return guarantees.
pub fn output(self: *Self, values: []Level) std.mem.Allocator.Error!void {
    @memset(values, if (self.order.results.items.len == 0) .none else .all);

    for (self.order.results.items) |result| {
        for (values, 0..) |*value, slot| value.* = value.meet(try self.level(result, @intCast(slot)));
    }
}

/// Meets what each call in this body passes into every callee input summary; lists the callees that weakened.
/// Lists every contribution in `passed`, in the order it was met, so a later analysis of the same state can replay it.
pub fn arguments(self: *Self, changed: *std.ArrayList(usize), passed: *std.ArrayList(Contribution)) std.mem.Allocator.Error!void {
    for (self.operations) |id| {
        const invocation = switch (self.row(id).value) {
            .call => |invocation| invocation,
            else => continue,
        };

        const callee = @backingInt(invocation.function);
        const levels = try self.allocator.alloc(Level, self.summaries.input[callee].len);

        for (levels, 0..) |*value, slot| {
            value.* = try self.level(invocation.argument, @intCast(slot));

            if (!self.deferred) try meet(self.allocator, self.summaries, @intCast(callee), @intCast(slot), value.*, changed);
        }

        try passed.append(self.allocator, .{ .callee = @intCast(callee), .levels = levels });
    }
}

/// One summary level an analysis read.
pub const Read = struct { table: Table, function: u32, slot: u32, value: Level };
pub const Table = enum(u8) { input, output, inputs, outputs };

/// Whether every level `reads` lists still holds in `summaries`.
pub fn unchanged(summaries: *const Summaries, reads: []const Read) bool {
    for (reads) |entry| {
        const values = switch (entry.table) {
            .input => summaries.input[entry.function],
            .output => summaries.output[entry.function],
            .inputs => summaries.inputs[entry.function],
            .outputs => summaries.outputs[entry.function],
        };

        if (Level.load(&values[entry.slot]) != entry.value) return false;
    }

    return true;
}

/// Reads one summary level, which a background analysis reads while the worklist may store it.
fn read(self: *Self, table: Table, function: usize, values: []const Level, slot: u32) std.mem.Allocator.Error!Level {
    const value = Level.load(&values[slot]);

    if (self.reads) |list| try list.append(self.allocator, .{ .table = table, .function = @intCast(function), .slot = slot, .value = value });

    return value;
}

/// What one call passes into each input slot of its callee, met in slot order.
pub const Contribution = struct { callee: u32, levels: []const Level };

pub fn replay(allocator: std.mem.Allocator, summaries: *Summaries, contribution: Contribution, changed: *std.ArrayList(usize)) std.mem.Allocator.Error!void {
    for (contribution.levels, 0..) |value, slot| try meet(allocator, summaries, contribution.callee, @intCast(slot), value, changed);
}

fn meet(allocator: std.mem.Allocator, summaries: *Summaries, callee: u32, slot: u32, level_value: Level, changed: *std.ArrayList(usize)) std.mem.Allocator.Error!void {
    const value = &summaries.input[callee][slot];
    const met = value.meet(level_value);

    if (met == value.*) return;

    Level.store(value, met);

    try changed.append(allocator, callee);
}

/// The level a loop slot starts with: its initial value's, or a fresh growth buffer where the loop renews the slot.
fn entering(self: *Self, owner: ir.ExprId, initial: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const result = try self.level(initial, slot);
    const want = self.renewed.get(renewal(owner, slot)) orelse return result;

    return if (lacks(result, want)) .all else result;
}

fn renewal(owner: ir.ExprId, slot: u32) u64 {
    return (@as(u64, @backingInt(owner)) << 32) | slot;
}

/// Marks a key whose growth copy renews the value of its expression rather than the state a loop enters with.
const value_renewal: u64 = 1 << 63;

fn lacks(level_value: Level, want: Level) bool {
    return (want.headered and !level_value.headered) or (want.unique and !level_value.unique);
}

/// A list slot of a loop state, or of an expression's own value when `value` is set, that starts from a growth copy.
pub const Renewal = struct { owner: ir.ExprId, path: []const u32, value: bool = false };

/// The slots that start from a growth copy, by member path from the loop state or the renewed value.
pub fn renewals(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]const Renewal {
    var result: std.ArrayList(Renewal) = .empty;
    var entries = self.renewed.iterator();

    while (entries.next()) |entry| {
        const value = entry.key_ptr.* & value_renewal != 0;
        const owner: ir.ExprId = @fromBackingInt(@intCast((entry.key_ptr.* & ~value_renewal) >> 32));
        const slot: u32 = @truncate(entry.key_ptr.*);

        if (self.order.time[@backingInt(owner)] == Order.none) continue;

        const start = if (value) try self.raw(owner, slot) else try self.level(self.carriedState(owner).?.initial, slot);

        if (!lacks(start, entry.value_ptr.*)) continue;
        try result.append(allocator, .{ .owner = owner, .path = try self.slots.path(allocator, self.row(owner).type_id, slot), .value = value });
    }

    std.mem.sort(Renewal, result.items, {}, struct {
        fn less(_: void, left: Renewal, right: Renewal) bool {
            if (left.owner != right.owner) return @backingInt(left.owner) < @backingInt(right.owner);
            if (left.value != right.value) return !left.value;

            return std.mem.order(u32, left.path, right.path) == .lt;
        }
    }.less);

    return result.items;
}

pub const Flags = packed struct(u8) { frontier: bool = false, retract: bool = false, in_place: bool = false, normalize: bool = false, renew: bool = false, padding: u3 = 0 };

/// How each list update lowers: appends check the frontier of a headered target, pops of a unique headered target hand
/// the frontier back, element writes of a unique target happen in place, and a demanded plain list gets a growth copy.
pub fn flags(self: *Self, values: []Flags) std.mem.Allocator.Error!void {
    @memset(values, .{});

    var wanted = self.normalized.iterator();

    while (wanted.next()) |entry| {
        const id = entry.key_ptr.*;
        const want = entry.value_ptr.*;

        if (self.order.time[@backingInt(id)] == Order.none) continue;

        const raw_level = try self.raw(id, 0);

        values[@backingInt(id)].normalize = (want.headered and !raw_level.headered) or (want.unique and !raw_level.unique);
    }

    var renewed = self.renewed.iterator();

    while (renewed.next()) |entry| {
        if (entry.key_ptr.* & value_renewal == 0) continue;

        const id: ir.ExprId = @fromBackingInt(@intCast((entry.key_ptr.* & ~value_renewal) >> 32));

        if (self.order.time[@backingInt(id)] == Order.none) continue;
        if (lacks(try self.raw(id, @truncate(entry.key_ptr.*)), entry.value_ptr.*)) values[@backingInt(id)].renew = true;
    }

    for (self.operations) |id| {
        const value = &values[@backingInt(id)];

        switch (self.row(id).value) {
            .list_operation => |operation| {
                const target = try self.level(operation.target, 0);

                switch (operation.kind) {
                    .push, .concat => value.frontier = target.headered,
                    .pop => value.retract = target.headered and target.unique,
                    .sort, .reverse => value.in_place = target.unique,
                    .splice => {},
                }
            },
            .list_update => |update| value.in_place = (try self.level(update.target, 0)).unique,
            else => {},
        }
    }
}

const State = struct { parameter: ir.SymbolId, condition: ?ir.SymbolId, initial: ir.ExprId, body: ir.ExprId };

fn carriedState(self: Self, id: ir.ExprId) ?State {
    return switch (self.row(id).value) {
        .iteration => |iteration| .{ .parameter = iteration.parameter, .condition = iteration.condition_parameter, .initial = iteration.initial, .body = iteration.body },
        .transform => |transform| if (transform.kind == .reduce) .{ .parameter = transform.parameters[0], .condition = null, .initial = transform.initial.?, .body = transform.body } else null,
        else => null,
    };
}

fn row(self: Self, id: ir.ExprId) *const ir.ExpressionRow {
    return &self.rows[@backingInt(id)];
}

const Known = enum(u8) { unknown = 0xff, _ };

pub fn level(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const root = self.sites.nodeRoot(id);
    const base = self.sites.slot_first[self.sites.symbols.count()];
    const index = self.sites.slot_first[root] + slot;

    if (index >= self.sites.slot_first[root + 1]) return self.compute(id, slot);

    const entry = &self.levels[index - base];

    if (entry.* != .unknown) return @bitCast(@as(u2, @intCast(@backingInt(entry.*))));

    const result = try self.compute(id, slot);

    entry.* = @fromBackingInt(@intCast(@as(u2, @bitCast(result))));

    return result;
}

fn compute(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const result = try self.raw(id, slot);
    const want = (if (slot == 0) self.normalized.get(id) else null) orelse self.renewed.get(renewal(id, slot) | value_renewal) orelse return result;

    if (!lacks(result, want)) return result;

    return .{ .headered = true, .unique = self.copyLinear(id, slot) };
}

/// Whether a growth copy made at `id` stays unique: its uses must be linear, and a symbol's uses are tracked on the
/// symbol, not on each reference to it.
fn copyLinear(self: *Self, id: ir.ExprId, slot: u32) bool {
    return self.row(id).value != .reference and self.sites.linear(self.sites.nodeRoot(id), slot);
}

fn raw(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const value = self.row(id);

    switch (value.value) {
        .field, .tuple_field => |projection| {
            const member = self.slots.member(self.row(projection.target).type_id, projection.index);

            return self.level(projection.target, member.offset + slot);
        },
        .optional_value => |child| return self.level(child, slot),
        .reference => |symbol| {
            const index = @backingInt(symbol);

            if (self.order.crossesConcurrent(self.order.loop[@backingInt(id)], self.order.def_loop[index])) return .none;

            var result = try self.definition(symbol, slot);
            result.unique = result.unique and self.sites.linear(Sites.symbolRoot(symbol), slot);

            return result;
        },
        else => {
            var result = try self.node(id, slot);
            result.unique = result.unique and self.sites.linear(self.sites.nodeRoot(id), slot);

            return result;
        },
    }
}

fn definition(self: *Self, symbol: ir.SymbolId, slot: u32) std.mem.Allocator.Error!Level {
    return switch (self.order.defs[@backingInt(symbol)]) {
        .input => if (slot < self.input.len) try self.read(.input, self.function.?, self.input, slot) else .none,
        .value => |id| self.level(id, slot),
        .part => |part| self.level(part.value, self.slots.member(self.row(part.value).type_id, part.index).offset + slot),
        .carried, .condition => |id| self.carried.get(id).?[slot],
        .element, .unknown => .none,
    };
}

fn node(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const value = self.row(id);

    return switch (value.value) {
        .object => |object| for (0..object.fields.len) |item| {
            const field = object.fields.at(item);
            const member = self.slots.member(value.type_id, field.index);

            if (slot >= member.offset and slot < member.offset + self.slots.count(member.type_id)) break self.level(field.value, slot - member.offset);
        } else .none,
        .tuple => |items| for (items, 0..) |item, position| {
            const member = self.slots.member(value.type_id, @intCast(position));

            if (slot >= member.offset and slot < member.offset + self.slots.count(member.type_id)) break self.level(item, slot - member.offset);
        } else .none,
        .some => |child| self.level(child, slot),
        .list => |items| if (items.len == 0) .all else .none,
        .list_operation => |operation| if (slot != 0) .none else switch (operation.kind) {
            .push, .concat => blk: {
                const target = try self.level(operation.target, 0);

                break :blk .{ .headered = true, .unique = !target.headered or target.unique };
            },
            .pop => self.level(operation.target, 0),
            .sort, .reverse => written(try self.level(operation.target, 0)),
            .splice => .fresh,
        },
        .list_update => |update| written(try self.level(update.target, 0)),
        .transform => |transform| switch (transform.kind) {
            .map, .filter => .fresh,
            .reduce => self.carried.get(id).?[slot],
            .every, .some => .none,
        },
        .scope => |scope| self.level(scope.result, slot),
        .binary => |binary| if (binary.operator == .coalesce) (try self.level(binary.left, slot)).meet(try self.level(binary.right, slot)) else .none,
        .iteration => self.carried.get(id).?[slot],
        .conditional => |conditional| (try self.level(conditional.yes, slot)).meet(try self.level(conditional.no, slot)),
        .match_expr => |selection| blk: {
            var result = try self.level(selection.fallback, slot);

            for (0..selection.arms.len) |item| result = result.meet(try self.level(selection.arms.at(item).result, slot));

            break :blk result;
        },
        .call => |invocation| blk: {
            const callee = @backingInt(invocation.function);
            const outputs = self.summaries.output[callee];

            break :blk if (slot < outputs.len) try self.read(.output, callee, outputs, slot) else .none;
        },
        else => .none,
    };
}

/// An element write keeps a unique target's buffer and otherwise copies into a fresh one.
fn written(target: Level) Level {
    return if (target.unique) target else .fresh;
}

/// Demand for growth copies: appends want a header and element writes want a unique buffer. Each demand traces back to
/// where a plain or shared list enters, through inputs to the callers and through outputs to the callees. A loop's
/// initial state, a plain input or an opaque producer then gets one growth copy there, so the updates that follow work
/// in place instead of copying on every step. Lists the functions whose demand grew.
pub fn demand(self: *Self, changed: *std.ArrayList(usize), marked: *std.ArrayList(Mark)) std.mem.Allocator.Error!void {
    self.changed = changed;
    self.marked = marked;

    self.traced.clearRetainingCapacity();

    for (self.operations) |id| {
        switch (self.row(id).value) {
            .list_operation => |operation| switch (operation.kind) {
                .push, .concat => try self.trace(operation.target, 0, null, false, .{ .headered = true, .unique = false }),
                .sort, .reverse => try self.trace(operation.target, 0, null, false, .fresh),
                .pop, .splice => {},
            },
            .list_update => |update| try self.trace(update.target, 0, null, false, .fresh),
            .call => |invocation| {
                const callee = @backingInt(invocation.function);

                for (0..self.summaries.inputs[callee].len) |slot| {
                    const want = try self.read(.inputs, callee, self.summaries.inputs[callee], @intCast(slot));

                    if (want != Level.none) try self.trace(invocation.argument, @intCast(slot), null, true, want);
                }
            },
            else => {},
        }
    }

    const function = self.function orelse return;

    for (0..self.summaries.outputs[function].len) |slot| {
        const want = try self.read(.outputs, function, self.summaries.outputs[function], @intCast(slot));

        if (want == Level.none) continue;
        for (self.order.results.items) |result| try self.trace(result, @intCast(slot), null, true, want);
    }
}

/// Follows a demand for the `wanted` properties of one list slot back to where a growth copy can provide them; only the
/// properties the value lacks and could keep count, so a unique buffer is never demanded of a value used twice.
/// `repeat` places the copy where the value enters even when no update follows it here: a loop's initial value, or a
/// value a callee or caller wants, since a summary that lacks the property makes every other caller copy on each call.
fn trace(self: *Self, id: ir.ExprId, slot: u32, outer: ?ir.ExprId, repeat: bool, wanted: Level) std.mem.Allocator.Error!void {
    const current = try self.level(id, slot);
    var want = wanted;
    want.headered = want.headered and !current.headered;
    want.unique = want.unique and !current.unique and try self.linearAt(id, slot);

    if (want == Level.none) return;

    const key = (@as(u64, @backingInt(id)) << 35) | (@as(u64, slot) << 3) | (@as(u64, @as(u2, @bitCast(want))) << 1) | @intFromBool(repeat);

    if ((try self.traced.getOrPut(self.allocator, key)).found_existing) return;

    const value = self.row(id);
    const leaf = if (slot == 0 and self.slots.types.get(value.type_id) == .list) id else outer;

    switch (value.value) {
        .field, .tuple_field => |projection| try self.trace(projection.target, self.slots.member(self.row(projection.target).type_id, projection.index).offset + slot, leaf, repeat, want),
        .optional_value => |child| try self.trace(child, slot, leaf, repeat, want),
        .reference => |symbol| switch (self.order.defs[@backingInt(symbol)]) {
            .input => {
                if (self.function) |function| try self.mark(.{ .output = false, .function = @intCast(function), .slot = slot, .want = want });
                try self.normalize(leaf, want);
            },
            .value => |bound| try self.trace(bound, slot, leaf, repeat, want),
            .part => |part| try self.trace(part.value, self.slots.member(self.row(part.value).type_id, part.index).offset + slot, leaf, repeat, want),
            .carried, .condition => |owner| try self.carry(owner, slot, want),
            .element, .unknown => if (repeat) try self.provide(id, slot, leaf, want),
        },
        .object => |object| for (0..object.fields.len) |item| {
            const field = object.fields.at(item);
            const member = self.slots.member(value.type_id, field.index);

            if (slot >= member.offset and slot < member.offset + self.slots.count(member.type_id)) try self.trace(field.value, slot - member.offset, null, repeat, want);
        },
        .tuple => |items| for (items, 0..) |item, position| {
            const member = self.slots.member(value.type_id, @intCast(position));

            if (slot >= member.offset and slot < member.offset + self.slots.count(member.type_id)) try self.trace(item, slot - member.offset, null, repeat, want);
        },
        .some => |child| try self.trace(child, slot, null, repeat, want),
        .scope => |scope| try self.trace(scope.result, slot, leaf, repeat, want),
        .conditional => |conditional| {
            try self.trace(conditional.yes, slot, null, repeat, want);
            try self.trace(conditional.no, slot, null, repeat, want);
        },
        .match_expr => |selection| {
            for (0..selection.arms.len) |item| try self.trace(selection.arms.at(item).result, slot, null, repeat, want);
            try self.trace(selection.fallback, slot, null, repeat, want);
        },
        .binary => |binary| if (binary.operator == .coalesce) {
            try self.trace(binary.left, slot, null, repeat, want);
            try self.trace(binary.right, slot, null, repeat, want);
        },
        // The rest of the list keeps the target's buffer; the popped element is read out of it like any element.
        .list_operation => |operation| if (operation.kind == .pop and slot == 0) try self.trace(operation.target, 0, leaf, repeat, want) else if (repeat) try self.provide(id, slot, leaf, want),
        .iteration => try self.carry(id, slot, want),
        .transform => |transform| if (transform.kind == .reduce) try self.carry(id, slot, want) else if (repeat) try self.normalize(leaf, want),
        .call => |invocation| {
            const callee = @backingInt(invocation.function);

            if (self.functions.at(callee).external == null) try self.mark(.{ .output = true, .function = @intCast(callee), .slot = slot, .want = want });
            try self.normalize(leaf, want);
        },
        else => if (repeat) try self.provide(id, slot, leaf, want),
    }
}

/// A growth copy where a value enters: of the list itself when the demand reached one, or else of the value `id`
/// holding the slot, renewed along the member path to it.
fn provide(self: *Self, id: ir.ExprId, slot: u32, leaf: ?ir.ExprId, wanted: Level) std.mem.Allocator.Error!void {
    if (leaf) |list| return self.normalize(list, wanted);

    var want = wanted;

    if (want.unique) want.unique = self.copyLinear(id, slot);
    if (want == Level.none) return;

    const entry = try self.renewed.getOrPut(renewal(id, slot) | value_renewal);
    const next = if (entry.found_existing) entry.value_ptr.join(want) else want;

    if (entry.found_existing and next == entry.value_ptr.*) return;

    entry.value_ptr.* = next;
    self.grew = true;
}

/// Whether a value used here could stay unique: a projection defers to its target, a reference to its symbol.
fn linearAt(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!bool {
    return switch (self.row(id).value) {
        .field, .tuple_field, .optional_value => true,
        .reference => |symbol| self.sites.linear(Sites.symbolRoot(symbol), slot),
        else => self.sites.linear(self.sites.nodeRoot(id), slot),
    };
}

/// A loop slot needs its initial value copied once before the loop and every step to keep the demanded properties;
/// a unique buffer also needs the state used linearly, or no copy could provide it.
fn carry(self: *Self, owner: ir.ExprId, slot: u32, wanted: Level) std.mem.Allocator.Error!void {
    const carried = self.carriedState(owner).?;
    var want = wanted;

    if (want.unique) want.unique = self.sites.linear(Sites.symbolRoot(carried.parameter), slot) and (carried.condition == null or self.sites.observed(Sites.symbolRoot(carried.condition.?), slot));
    if (want == Level.none) return;
    try self.renew(owner, slot, want);
    try self.trace(carried.initial, slot, null, true, want);
    try self.trace(carried.body, slot, null, false, want);
}

/// A demand for the `want` properties of one input or output slot of a function.
pub const Mark = struct { output: bool, function: u32, slot: u32, want: Level };

fn mark(self: *Self, value: Mark) std.mem.Allocator.Error!void {
    try self.marked.?.append(self.allocator, value);
    if (!self.deferred) try applyMark(self.allocator, self.summaries, value, self.changed.?);
}

pub fn applyMark(allocator: std.mem.Allocator, summaries: *Summaries, value: Mark, changed: *std.ArrayList(usize)) std.mem.Allocator.Error!void {
    const values = if (value.output) summaries.outputs[value.function] else summaries.inputs[value.function];
    const next = values[value.slot].join(value.want);

    if (next == values[value.slot]) return;

    Level.store(&values[value.slot], next);

    try changed.append(allocator, value.function);
}

fn renew(self: *Self, owner: ir.ExprId, slot: u32, want: Level) std.mem.Allocator.Error!void {
    const entry = try self.renewed.getOrPut(renewal(owner, slot));
    const next = if (entry.found_existing) entry.value_ptr.join(want) else want;

    if (entry.found_existing and next == entry.value_ptr.*) return;

    entry.value_ptr.* = next;
    self.grew = true;
}

fn normalize(self: *Self, leaf: ?ir.ExprId, wanted: Level) std.mem.Allocator.Error!void {
    const id = leaf orelse return;
    var want = wanted;

    if (want.unique) want.unique = self.sites.linear(self.sites.nodeRoot(id), 0);
    if (want == Level.none) return;

    const entry = try self.normalized.getOrPut(id);
    const next = if (entry.found_existing) entry.value_ptr.join(want) else want;

    if (entry.found_existing and next == entry.value_ptr.*) return;

    entry.value_ptr.* = next;
    self.grew = true;
}
