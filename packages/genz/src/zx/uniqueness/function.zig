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
        if (order.timeAt(index) == Order.none) continue;

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
/// Set when recording a read ran out of memory. Levels recurse deeply and only that record allocates, so they return
/// plain levels and each public step reports the failure once it returns.
failed: bool = false,
pub fn analyze(allocator: std.mem.Allocator, functions: ir.FunctionTable, unit: Unit, order: *const Order, sites: *Sites, slots: Slots, summaries: *Summaries) std.mem.Allocator.Error!Self {
    const levels = try allocator.alloc(Known, sites.slot_first[sites.slot_first.len - 1] - sites.slot_first[unit.symbols.count()]);
    var self = Self{ .allocator = allocator, .functions = functions, .expressions = unit.expressions, .order = order, .sites = sites, .slots = slots, .summaries = summaries, .input = unit.input, .function = unit.function, .normalized = unit.normalized, .renewed = unit.renewed, .operations = unit.operations, .rows = unit.rows, .levels = levels };

    try self.close();

    return self;
}

fn close(self: *Self) std.mem.Allocator.Error!void {
    for (self.order.repeated) |id| {
        const state = self.carriedState(id) orelse continue;
        const values = try self.allocator.alloc(Level, self.slots.count(self.row(id).type_id));

        for (values, 0..) |*value, slot| value.* = .{
            .headered = true,
            .unique = self.sites.linear(Sites.symbolRoot(state.parameter), @intCast(slot)) and (state.condition == null or self.sites.observed(Sites.symbolRoot(state.condition.?), @intCast(slot))),
        };

        try self.carried.put(self.allocator, id, values);
    }

    var changed = true;

    while (changed) {
        changed = false;

        @memset(self.levels, .unknown);

        var entries = self.carried.iterator();

        while (entries.next()) |entry| {
            const state = self.carriedState(entry.key_ptr.*).?;

            for (entry.value_ptr.*, 0..) |*value, slot| {
                const next = value.meet(self.entering(entry.key_ptr.*, state.initial, @intCast(slot))).meet(self.level(state.body, @intCast(slot)));

                if (next == value.*) continue;

                value.* = next;
                changed = true;
            }
        }
    }

    try self.settled();
}

fn settled(self: Self) std.mem.Allocator.Error!void {
    if (self.failed) return error.OutOfMemory;
}

/// The output slots every return guarantees.
pub fn output(self: *Self, values: []Level) std.mem.Allocator.Error!void {
    @memset(values, if (self.order.results.len == 0) .none else .all);

    for (self.order.results) |result| {
        for (values, 0..) |*value, slot| value.* = value.meet(self.level(result, @intCast(slot)));
    }

    return self.settled();
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
            value.* = self.level(invocation.argument, @intCast(slot));

            if (!self.deferred) try meet(self.allocator, self.summaries, @intCast(callee), @intCast(slot), value.*, changed);
        }

        try passed.append(self.allocator, .{ .callee = @intCast(callee), .levels = levels });
    }

    return self.settled();
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
fn read(self: *Self, table: Table, function: usize, values: []const Level, slot: u32) Level {
    const value = Level.load(&values[slot]);

    if (self.reads) |list| list.append(self.allocator, .{ .table = table, .function = @intCast(function), .slot = slot, .value = value }) catch {
        self.failed = true;
    };

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
fn entering(self: *Self, owner: ir.ExprId, initial: ir.ExprId, slot: u32) Level {
    const result = self.level(initial, slot);
    const want = self.renewed.get(renewal(owner, slot)) orelse return result;

    return if (Level.lacks(result, want)) Level.materialized(result, want, true) else result;
}

fn renewal(owner: ir.ExprId, slot: u32) u64 {
    return (@as(u64, @backingInt(owner)) << 32) | slot;
}

/// Marks a key whose growth copy renews the value of its expression rather than the state a loop enters with.
const value_renewal: u64 = 1 << 63;
/// A list slot of a loop state, or of an expression's own value when `value` is set, that starts from a growth copy.
pub const Renewal = struct { owner: ir.ExprId, path: []const u32, value: bool = false };

/// The slots that start from a growth copy, by member path from the loop state or the renewed value.
pub fn renewals(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]const Renewal {
    var result: std.ArrayList(Renewal) = .empty;
    var entries = self.renewed.iterator();

    while (entries.next()) |entry| {
        if (!entry.value_ptr.unique) continue;

        const value = entry.key_ptr.* & value_renewal != 0;
        const owner: ir.ExprId = @fromBackingInt(@intCast((entry.key_ptr.* & ~value_renewal) >> 32));
        const slot: u32 = @truncate(entry.key_ptr.*);

        if (self.order.timeAt(@backingInt(owner)) == Order.none) continue;

        const start = if (value) self.raw(owner, slot) else self.level(self.carriedState(owner).?.initial, slot);

        if (!Level.lacks(start, entry.value_ptr.*)) continue;
        try result.append(allocator, .{ .owner = owner, .path = try self.slots.path(allocator, self.row(owner).type_id, slot), .value = value });
    }

    std.mem.sort(Renewal, result.items, {}, struct {
        fn less(_: void, left: Renewal, right: Renewal) bool {
            if (left.owner != right.owner) return @backingInt(left.owner) < @backingInt(right.owner);
            if (left.value != right.value) return !left.value;

            return std.mem.order(u32, left.path, right.path) == .lt;
        }
    }.less);

    try self.settled();

    return result.items;
}

pub const Flags = packed struct(u8) { frontier: bool = false, retract: bool = false, in_place: bool = false, normalize: bool = false, renew: bool = false, grow: bool = false, lazy: bool = false, buffered: bool = false };

/// How each list update lowers: appends check the frontier of a headered target, pops of a unique headered target hand
/// the frontier back, element writes of a unique target happen in place and those of a shared headered target copy into
/// a growth buffer, and a demanded plain list gets a growth copy.
pub fn flags(self: *Self, values: []Flags) std.mem.Allocator.Error!void {
    @memset(values, .{});

    var wanted = self.normalized.iterator();

    while (wanted.next()) |entry| {
        const id = entry.key_ptr.*;
        const want = entry.value_ptr.*;

        if (self.order.timeAt(@backingInt(id)) == Order.none) continue;

        const raw_level = self.raw(id, 0);

        values[@backingInt(id)].normalize = want.unique and Level.lacks(raw_level, want);
    }

    var renewed = self.renewed.iterator();

    while (renewed.next()) |entry| {
        if (entry.key_ptr.* & value_renewal == 0) continue;

        const id: ir.ExprId = @fromBackingInt(@intCast((entry.key_ptr.* & ~value_renewal) >> 32));

        if (self.order.timeAt(@backingInt(id)) == Order.none) continue;
        if (entry.value_ptr.unique and Level.lacks(self.raw(id, @truncate(entry.key_ptr.*)), entry.value_ptr.*)) values[@backingInt(id)].renew = true;
    }

    for (self.operations) |id| {
        const value = &values[@backingInt(id)];

        switch (self.row(id).value) {
            .list_operation => |operation| {
                const target = self.level(operation.target, 0);

                switch (operation.kind) {
                    .push, .concat => {
                        value.frontier = target.headered;
                        value.lazy = !target.headered and target.deferred;
                    },
                    .pop => value.retract = target.headered and target.unique,
                    .sort, .reverse => {
                        value.in_place = target.unique;
                        value.grow = !target.unique and target.headered;
                    },
                    .splice => value.retract = self.prefix(operation) and target.headered and target.unique,
                }
            },
            .list_update => |update| {
                const target = self.level(update.target, 0);

                value.in_place = target.unique;
                value.grow = !target.unique and target.headered;
            },
            else => {},
        }
    }

    try self.bufferFlags(values);

    return self.settled();
}

fn bufferLoop(self: *const Self, id: ir.ExprId) bool {
    const value = self.row(id);

    if (value.value != .iteration) return false;

    const target_type = self.slots.types.get(value.type_id);

    if (target_type != .object and target_type != .tuple) return false;

    var product = false;

    for (0..self.slots.count(value.type_id)) |slot| {
        const list_type = self.slots.listType(value.type_id, @intCast(slot));
        const child = self.slots.types.get(list_type).list;

        if (self.slots.count(child) != 0) return false;

        const target = self.slots.types.get(self.slots.unwrapped[@backingInt(child)]);

        product = product or target == .object or target == .tuple;
    }

    return product;
}

fn bufferFlags(self: *Self, values: []Flags) std.mem.Allocator.Error!void {
    if (comptime !@import("genz_options").generated_analysis) return;

    const writes = for (self.operations) |id| {
        const target = switch (self.row(id).value) {
            .list_update => |update| update.target,
            .list_operation => |operation| if (operation.kind == .push) operation.target else continue,
            else => continue,
        };

        const element = self.slots.types.get(self.row(target).type_id).list;
        const child = self.slots.types.get(self.slots.unwrapped[@backingInt(element)]);

        if (child == .object or child == .tuple) break true;
    } else false;

    if (!writes) return;

    const needed = for (self.order.repeated) |id| {
        if (self.bufferLoop(id)) break true;
    } else false;

    if (!needed) return;

    var arena = std.heap.ArenaAllocator.init(self.allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const generated = @import("generated_iteration_owners");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.slots.types);

    const input: Input = .{
        .types = &types,
        .expressions = @import("zx").columns.pointer(@FieldType(Input, "expressions"), &@as(*const Self, self).expressions),
        .loops = @as([*]const u32, @ptrCast(self.order.repeated.ptr))[0..self.order.repeated.len],
    };

    const owners = generated.executeValue(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (owners.len == 0) return;

    var normalized = std.AutoHashMap(ir.ExprId, Level).init(temporary);
    var renewed = std.AutoHashMap(u64, Level).init(temporary);

    for (owners) |index| {
        const id: ir.ExprId = @fromBackingInt(index);

        values[index].buffered = true;

        for (0..self.slots.count(self.row(id).type_id)) |slot| try renewed.put(renewal(id, @intCast(slot)), .all);
    }

    var reads: std.ArrayList(Read) = .empty;
    var owned = self.*;
    owned.allocator = temporary;
    owned.normalized = &normalized;
    owned.renewed = &renewed;
    owned.carried = .empty;
    owned.levels = try temporary.alloc(Known, self.levels.len);
    owned.failed = false;
    owned.reads = if (self.reads != null) &reads else null;

    try owned.close();

    for (self.operations) |id| {
        const target = switch (self.row(id).value) {
            .list_operation => |operation| switch (operation.kind) {
                .push, .pop => operation.target,
                else => continue,
            },
            .list_update => |update| update.target,
            else => continue,
        };

        values[@backingInt(id)].buffered = owned.level(target, 0).unique;
    }

    try owned.settled();
    if (self.reads) |recorded| try recorded.appendSlice(self.allocator, reads.items);
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

pub fn level(self: *Self, id: ir.ExprId, slot: u32) Level {
    const root = self.sites.nodeRoot(id);
    const base = self.sites.slot_first[self.sites.symbols.count()];
    const index = self.sites.slot_first[root] + slot;

    if (index >= self.sites.slot_first[root + 1]) return self.compute(id, slot);

    const entry = &self.levels[index - base];

    if (entry.* != .unknown) return @bitCast(@as(u3, @intCast(@backingInt(entry.*))));

    const result = self.compute(id, slot);

    entry.* = @fromBackingInt(@intCast(@as(u3, @bitCast(result))));

    return result;
}

fn compute(self: *Self, id: ir.ExprId, slot: u32) Level {
    const result = self.raw(id, slot);
    const want = (if (slot == 0) self.normalized.get(id) else null) orelse self.renewed.get(renewal(id, slot) | value_renewal) orelse return result;

    if (!Level.lacks(result, want)) return result;

    return Level.materialized(result, want, self.copyLinear(id, slot));
}

/// Whether the new copy stays unique at this expression; symbol uses belong to the symbol.
fn copyLinear(self: *Self, id: ir.ExprId, slot: u32) bool {
    return self.row(id).value != .reference and self.sites.linear(self.sites.nodeRoot(id), slot);
}

fn raw(self: *Self, id: ir.ExprId, slot: u32) Level {
    const value = self.row(id);

    switch (value.value) {
        .field, .tuple_field => |projection| {
            const member = self.slots.member(self.row(projection.target).type_id, projection.index);

            return self.level(projection.target, member.offset + slot);
        },
        .optional_value => |child| return self.level(child, slot),
        .reference => |symbol| {
            const index = @backingInt(symbol);

            if (self.order.crossesConcurrent(self.order.loopAt(@backingInt(id)), self.order.defLoopAt(index))) return .none;

            var result = self.definition(symbol, slot);
            result.unique = result.unique and (self.empty(symbol) or self.sites.linear(Sites.symbolRoot(symbol), slot));

            return result;
        },
        else => {
            var result = self.node(id, slot);

            result.unique = result.unique and (self.emptyList(id) or self.sites.linear(self.sites.nodeRoot(id), slot));

            return result;
        },
    }
}

/// Whether a symbol is bound to an empty list literal, whose uses may share it as `emptyList` says.
fn empty(self: Self, symbol: ir.SymbolId) bool {
    return switch (self.order.definition(symbol)) {
        .value => |id| self.emptyList(id),
        else => false,
    };
}

/// Whether an expression is an empty list literal. Its uses may share the buffer: nothing is ever written in place into
/// an empty list, since appends to one allocate and it has no elements to update, pop or splice.
fn emptyList(self: Self, id: ir.ExprId) bool {
    return switch (self.row(id).value) {
        .list => |items| items.len == 0,
        else => false,
    };
}

fn definition(self: *Self, symbol: ir.SymbolId, slot: u32) Level {
    return switch (self.order.definition(symbol)) {
        .input => if (slot < self.input.len) self.read(.input, self.function.?, self.input, slot) else .none,
        .value => |id| self.level(id, slot),
        .part => |part| self.level(part.value, self.slots.member(self.row(part.value).type_id, part.index).offset + slot),
        .carried => |id| self.carried.get(id).?[slot],
        .condition => |id| if (self.row(id).value.iteration.postcondition) self.carried.get(id).?[slot] else self.carried.get(id).?[slot].meet(self.level(self.row(id).value.iteration.initial, slot)),
        .element, .unknown => .none,
    };
}

fn node(self: *Self, id: ir.ExprId, slot: u32) Level {
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
        .list_operation => |operation| if (slot != 0) (if (slot == 1 and self.prefix(operation)) self.level(operation.target, 0) else .none) else switch (operation.kind) {
            .push, .concat => blk: {
                const target = self.level(operation.target, 0);

                if (operation.kind == .concat) break :blk .{ .headered = target.headered, .unique = target.unique, .deferred = !target.headered };

                break :blk .{ .headered = true, .unique = (!target.headered and !target.deferred) or target.unique };
            },
            .pop => self.level(operation.target, 0),
            .sort, .reverse => Level.written(self.level(operation.target, 0)),
            .splice => .fresh,
        },
        .list_update => |update| Level.written(self.level(update.target, 0)),
        .transform => |transform| switch (transform.kind) {
            .map, .filter => .fresh,
            .reduce => self.carried.get(id).?[slot].meet(self.level(transform.initial.?, slot)),
            .every, .some => .none,
        },
        .scope => |scope| self.level(scope.result, slot),
        .binary => |binary| if (binary.operator == .coalesce) (self.level(binary.left, slot)).meet(self.level(binary.right, slot)) else .none,
        .iteration => |iteration| if (iteration.postcondition) self.carried.get(id).?[slot] else self.carried.get(id).?[slot].meet(self.level(iteration.initial, slot)),
        .conditional => |conditional| (self.level(conditional.yes, slot)).meet(self.level(conditional.no, slot)),
        .match_expr => |selection| blk: {
            var result = self.level(selection.fallback, slot);

            for (0..selection.arms.len) |item| result = result.meet(self.level(selection.arms.at(item).result, slot));

            break :blk result;
        },
        .call => |invocation| blk: {
            const callee = @backingInt(invocation.function);
            const outputs = self.summaries.output[callee];

            break :blk if (slot < outputs.len) self.read(.output, callee, outputs, slot) else .none;
        },
        else => .none,
    };
}

/// Whether a splice starts at the front, so the part it removes is a prefix of the target's own buffer, as a pop's rest
/// is.
fn prefix(self: Self, operation: anytype) bool {
    return @import("basis.zig").prefix(self.expressions, operation);
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
                    const want = self.read(.inputs, callee, self.summaries.inputs[callee], @intCast(slot));

                    if (want != Level.none) try self.trace(invocation.argument, @intCast(slot), null, true, want);
                }
            },
            else => {},
        }
    }

    const function = self.function orelse return self.settled();

    for (0..self.summaries.outputs[function].len) |slot| {
        const want = self.read(.outputs, function, self.summaries.outputs[function], @intCast(slot));

        if (want == Level.none) continue;
        for (self.order.results) |result| try self.trace(result, @intCast(slot), null, true, want);
    }

    return self.settled();
}

/// Follows a demand for the `wanted` properties of one list slot back to where a growth copy can provide them; only the
/// properties the value lacks and could keep count, so a unique buffer is never demanded of a value used twice.
/// `repeat` places the copy where the value enters even when no update follows it here: a loop's initial value, or a
/// value a callee or caller wants, since a summary that lacks the property makes every other caller copy on each call.
fn trace(self: *Self, id: ir.ExprId, slot: u32, outer: ?ir.ExprId, repeat: bool, wanted: Level) std.mem.Allocator.Error!void {
    const current = self.level(id, slot);
    var want = wanted;
    want.headered = want.headered and !current.headered and !current.deferred;
    want.unique = want.unique and !current.unique and self.linearAt(id, slot);

    if (want == Level.none) return;

    const key = (@as(u64, @backingInt(id)) << 36) | (@as(u64, slot) << 4) | (@as(u64, @as(u3, @bitCast(want))) << 1) | @intFromBool(repeat);

    if ((try self.traced.getOrPut(self.allocator, key)).found_existing) return;

    const value = self.row(id);
    const leaf = if (slot == 0 and self.slots.types.get(value.type_id) == .list) id else outer;

    switch (value.value) {
        .field, .tuple_field => |projection| try self.trace(projection.target, self.slots.member(self.row(projection.target).type_id, projection.index).offset + slot, leaf, repeat, want),
        .optional_value => |child| try self.trace(child, slot, leaf, repeat, want),
        .reference => |symbol| switch (self.order.definition(symbol)) {
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
        // The rest of a pop and the prefix a splice removes from the front keep the target's buffer; the popped element
        // is read out of it like any element.
        .list_operation => |operation| if ((operation.kind == .pop and slot == 0) or (slot == 1 and self.prefix(operation))) try self.trace(operation.target, 0, leaf, repeat, want) else if (repeat) try self.provide(id, slot, leaf, want),
        .iteration => try self.provide(id, slot, leaf, want),
        .transform => |transform| if (transform.kind == .reduce) try self.provide(id, slot, leaf, want) else if (repeat) try self.normalize(leaf, want),
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
fn linearAt(self: *Self, id: ir.ExprId, slot: u32) bool {
    return switch (self.row(id).value) {
        .field, .tuple_field, .optional_value => true,
        .reference => |symbol| self.sites.linear(Sites.symbolRoot(symbol), slot),
        else => self.sites.linear(self.sites.nodeRoot(id), slot),
    };
}

/// A loop slot is prepared when its body first runs; its initial value retains its own properties on the zero-round
/// path. A unique buffer also needs the state used linearly, or no copy could provide it.
fn carry(self: *Self, owner: ir.ExprId, slot: u32, wanted: Level) std.mem.Allocator.Error!void {
    const carried = self.carriedState(owner).?;
    var want = wanted;

    if (want.unique) want.unique = self.sites.linear(Sites.symbolRoot(carried.parameter), slot) and (carried.condition == null or self.sites.observed(Sites.symbolRoot(carried.condition.?), slot));
    if (want == Level.none) return;
    try self.renew(owner, slot, want);
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
