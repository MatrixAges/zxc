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
};

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
carried: std.AutoHashMapUnmanaged(ir.ExprId, []Level) = .empty,
levels: std.AutoHashMapUnmanaged(u64, Level) = .empty,
traced: std.AutoHashMapUnmanaged(u64, void) = .empty,
changed: ?*std.ArrayList(usize) = null,
grew: bool = false,
pub fn analyze(allocator: std.mem.Allocator, functions: ir.FunctionTable, unit: Unit, order: *const Order, sites: *Sites, slots: Slots, summaries: *Summaries) std.mem.Allocator.Error!Self {
    var self = Self{ .allocator = allocator, .functions = functions, .expressions = unit.expressions, .order = order, .sites = sites, .slots = slots, .summaries = summaries, .input = unit.input, .function = unit.function, .normalized = unit.normalized, .renewed = unit.renewed };

    for (order.repeated.items) |id| {
        const state = self.carriedState(id) orelse continue;
        const values = try allocator.alloc(Level, slots.count(self.expressions.get(id).type_id));

        for (values, 0..) |*value, slot| value.* = .{
            .headered = true,
            .unique = try sites.linear(Sites.symbolRoot(state.parameter), @intCast(slot)) and (state.condition == null or sites.observed(Sites.symbolRoot(state.condition.?), @intCast(slot))),
        };

        try self.carried.put(allocator, id, values);
    }

    var changed = true;

    while (changed) {
        changed = false;
        self.levels.clearRetainingCapacity();

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
pub fn arguments(self: *Self, changed: *std.ArrayList(usize)) std.mem.Allocator.Error!void {
    for (0..self.expressions.count()) |index| {
        if (self.order.time[index] == Order.none) continue;

        const invocation = switch (self.expressions.get(@fromBackingInt(@intCast(index))).value) {
            .call => |invocation| invocation,
            else => continue,
        };
        const callee = @backingInt(invocation.function);

        for (self.summaries.input[callee], 0..) |*value, slot| {
            const met = value.meet(try self.level(invocation.argument, @intCast(slot)));

            if (met == value.*) continue;

            value.* = met;
            try changed.append(self.allocator, callee);
        }
    }
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

fn lacks(level_value: Level, want: Level) bool {
    return (want.headered and !level_value.headered) or (want.unique and !level_value.unique);
}

pub const Renewal = struct { owner: ir.ExprId, path: []const u32 };

/// The loop slots that start from a growth copy of their initial value, by member path from the loop state.
pub fn renewals(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]const Renewal {
    var result: std.ArrayList(Renewal) = .empty;
    var entries = self.renewed.iterator();

    while (entries.next()) |entry| {
        const owner: ir.ExprId = @fromBackingInt(@intCast(entry.key_ptr.* >> 32));
        const slot: u32 = @truncate(entry.key_ptr.*);

        if (self.order.time[@backingInt(owner)] == Order.none) continue;
        if (!lacks(try self.level(self.carriedState(owner).?.initial, slot), entry.value_ptr.*)) continue;

        try result.append(allocator, .{ .owner = owner, .path = try self.slots.path(allocator, self.expressions.get(owner).type_id, slot) });
    }

    std.mem.sort(Renewal, result.items, {}, struct {
        fn less(_: void, left: Renewal, right: Renewal) bool {
            if (left.owner != right.owner) return @backingInt(left.owner) < @backingInt(right.owner);

            return std.mem.order(u32, left.path, right.path) == .lt;
        }
    }.less);

    return result.items;
}

pub const Flags = packed struct(u8) { frontier: bool = false, retract: bool = false, in_place: bool = false, normalize: bool = false, padding: u4 = 0 };

/// How each list update lowers: appends check the frontier of a headered target, pops of a unique headered target hand
/// the frontier back, element writes of a unique target happen in place, and a demanded plain list gets a growth copy.
pub fn flags(self: *Self, values: []Flags) std.mem.Allocator.Error!void {
    @memset(values, .{});

    for (values, 0..) |*value, index| {
        if (self.order.time[index] == Order.none) continue;

        const id: ir.ExprId = @fromBackingInt(@intCast(index));

        value.normalize = if (self.normalized.get(id)) |want| blk: {
            const raw_level = try self.raw(id, 0);

            break :blk (want.headered and !raw_level.headered) or (want.unique and !raw_level.unique);
        } else false;

        switch (self.expressions.get(id).value) {
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
    return switch (self.expressions.get(id).value) {
        .iteration => |iteration| .{ .parameter = iteration.parameter, .condition = iteration.condition_parameter, .initial = iteration.initial, .body = iteration.body },
        .transform => |transform| if (transform.kind == .reduce) .{ .parameter = transform.parameters[0], .condition = null, .initial = transform.initial.?, .body = transform.body } else null,
        else => null,
    };
}

pub fn level(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const key = (@as(u64, @backingInt(id)) << 32) | slot;

    if (self.levels.get(key)) |known| return known;

    const result = try self.compute(id, slot);

    try self.levels.put(self.allocator, key, result);

    return result;
}

fn compute(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const result = try self.raw(id, slot);

    if (slot != 0) return result;

    const want = self.normalized.get(id) orelse return result;

    if ((!want.headered or result.headered) and (!want.unique or result.unique)) return result;

    return .{ .headered = true, .unique = try self.sites.linear(self.sites.nodeRoot(id), 0) };
}

fn raw(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const value = self.expressions.get(id);

    switch (value.value) {
        .field, .tuple_field => |projection| {
            const member = self.slots.member(self.expressions.get(projection.target).type_id, projection.index);

            return self.level(projection.target, member.offset + slot);
        },
        .optional_value => |child| return self.level(child, slot),
        .reference => |symbol| {
            const index = @backingInt(symbol);

            if (self.order.crossesConcurrent(self.order.loop[@backingInt(id)], self.order.def_loop[index])) return .none;

            var result = try self.definition(symbol, slot);

            result.unique = result.unique and try self.sites.linear(Sites.symbolRoot(symbol), slot);

            return result;
        },
        else => {
            var result = try self.node(id, slot);

            result.unique = result.unique and try self.sites.linear(self.sites.nodeRoot(id), slot);

            return result;
        },
    }
}

fn definition(self: *Self, symbol: ir.SymbolId, slot: u32) std.mem.Allocator.Error!Level {
    return switch (self.order.defs[@backingInt(symbol)]) {
        .input => if (slot < self.input.len) self.input[slot] else .none,
        .value => |id| self.level(id, slot),
        .part => |part| self.level(part.value, self.slots.member(self.expressions.get(part.value).type_id, part.index).offset + slot),
        .carried, .condition => |id| self.carried.get(id).?[slot],
        .element, .unknown => .none,
    };
}

fn node(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!Level {
    const value = self.expressions.get(id);

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
        .iteration => self.carried.get(id).?[slot],
        .conditional => |conditional| (try self.level(conditional.yes, slot)).meet(try self.level(conditional.no, slot)),
        .match_expr => |selection| blk: {
            var result = try self.level(selection.fallback, slot);

            for (0..selection.arms.len) |item| result = result.meet(try self.level(selection.arms.at(item).result, slot));

            break :blk result;
        },
        .call => |invocation| blk: {
            const outputs = self.summaries.output[@backingInt(invocation.function)];

            break :blk if (slot < outputs.len) outputs[slot] else .none;
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
pub fn demand(self: *Self, changed: *std.ArrayList(usize)) std.mem.Allocator.Error!void {
    self.changed = changed;

    self.traced.clearRetainingCapacity();

    for (0..self.expressions.count()) |index| {
        if (self.order.time[index] == Order.none) continue;

        switch (self.expressions.get(@fromBackingInt(@intCast(index))).value) {
            .list_operation => |operation| switch (operation.kind) {
                .push, .concat => try self.trace(operation.target, 0, null, false, .{ .headered = true, .unique = false }),
                .sort, .reverse => try self.trace(operation.target, 0, null, false, .fresh),
                .pop, .splice => {},
            },
            .list_update => |update| try self.trace(update.target, 0, null, false, .fresh),
            .call => |invocation| for (self.summaries.inputs[@backingInt(invocation.function)], 0..) |want, slot| {
                if (want != Level.none) try self.trace(invocation.argument, @intCast(slot), null, false, want);
            },
            else => {},
        }
    }

    const function = self.function orelse return;

    for (self.summaries.outputs[function], 0..) |want, slot| {
        if (want == Level.none) continue;

        for (self.order.results.items) |result| try self.trace(result, @intCast(slot), null, false, want);
    }
}

/// Follows a demand for the `wanted` properties of one list slot back to where a growth copy can provide them; only the
/// properties the value lacks and could keep count, so a unique buffer is never demanded of a value used twice.
fn trace(self: *Self, id: ir.ExprId, slot: u32, outer: ?ir.ExprId, repeat: bool, wanted: Level) std.mem.Allocator.Error!void {
    const current = try self.level(id, slot);
    var want = wanted;

    want.headered = want.headered and !current.headered;
    want.unique = want.unique and !current.unique and try self.linearAt(id, slot);

    if (want == Level.none) return;

    const key = (@as(u64, @backingInt(id)) << 35) | (@as(u64, slot) << 3) | (@as(u64, @as(u2, @bitCast(want))) << 1) | @intFromBool(repeat);

    if ((try self.traced.getOrPut(self.allocator, key)).found_existing) return;

    const value = self.expressions.get(id);
    const leaf = if (slot == 0 and self.slots.types.get(value.type_id) == .list) id else outer;

    switch (value.value) {
        .field, .tuple_field => |projection| try self.trace(projection.target, self.slots.member(self.expressions.get(projection.target).type_id, projection.index).offset + slot, leaf, repeat, want),
        .optional_value => |child| try self.trace(child, slot, leaf, repeat, want),
        .reference => |symbol| switch (self.order.defs[@backingInt(symbol)]) {
            .input => {
                if (self.function) |function| try self.mark(self.summaries.inputs[function], slot, function, want);

                try self.normalize(leaf, want);
            },
            .value => |bound| try self.trace(bound, slot, leaf, repeat, want),
            .part => |part| try self.trace(part.value, self.slots.member(self.expressions.get(part.value).type_id, part.index).offset + slot, leaf, repeat, want),
            .carried, .condition => |owner| try self.carry(owner, slot, want),
            .element, .unknown => if (repeat) try self.normalize(leaf, want),
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
        .list_operation => |operation| if (operation.kind == .pop) try self.trace(operation.target, 0, leaf, repeat, want) else if (repeat) try self.normalize(leaf, want),
        .iteration => try self.carry(id, slot, want),
        .transform => |transform| if (transform.kind == .reduce) try self.carry(id, slot, want) else if (repeat) try self.normalize(leaf, want),
        .call => |invocation| {
            const callee = @backingInt(invocation.function);

            if (self.functions.at(callee).external == null) try self.mark(self.summaries.outputs[callee], slot, callee, want);

            try self.normalize(leaf, want);
        },
        else => if (repeat) try self.normalize(leaf, want),
    }
}

/// Whether a value used here could stay unique: a projection defers to its target, a reference to its symbol.
fn linearAt(self: *Self, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!bool {
    return switch (self.expressions.get(id).value) {
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

    if (want.unique) want.unique = try self.sites.linear(Sites.symbolRoot(carried.parameter), slot) and (carried.condition == null or self.sites.observed(Sites.symbolRoot(carried.condition.?), slot));
    if (want == Level.none) return;
    if (self.expressions.get(owner).value == .iteration) try self.renew(owner, slot, want);

    try self.trace(carried.initial, slot, null, true, want);
    try self.trace(carried.body, slot, null, false, want);
}

fn mark(self: *Self, values: []Level, slot: u32, function: usize, want: Level) std.mem.Allocator.Error!void {
    const next = values[slot].join(want);

    if (next == values[slot]) return;

    values[slot] = next;
    try self.changed.?.append(self.allocator, function);
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

    if (want.unique) want.unique = try self.sites.linear(self.sites.nodeRoot(id), 0);
    if (want == Level.none) return;

    const entry = try self.normalized.getOrPut(id);
    const next = if (entry.found_existing) entry.value_ptr.join(want) else want;

    if (entry.found_existing and next == entry.value_ptr.*) return;

    entry.value_ptr.* = next;
    self.grew = true;
}

