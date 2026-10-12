const std = @import("std");
const ir = @import("zx").ir;
const Order = @import("order.zig");
const Slots = @import("slots.zig");
const Self = @This();

/// Which input slots of each function its output may hold and its updates may write in place, closed over the call
/// graph. A value is followed back from where it ends up to the input slots it can come from: through projections,
/// aggregates, bindings, loop state and the inputs of callees that hold them. What an output holds includes the lists
/// stored as elements of its lists; what an update writes is one buffer, and elements are never written in place. A
/// value whose origin the walk cannot follow counts as every input slot.
held: []const []const bool,
written: []const []const bool,
pub fn create(allocator: std.mem.Allocator, program: ir.Program, slots: Slots) std.mem.Allocator.Error!Self {
    const count = program.functions.count();
    const held = try allocator.alloc([]bool, count);
    const written = try allocator.alloc([]bool, count);
    const bodies = try allocator.alloc(?Body, count);
    const callers = try allocator.alloc(std.ArrayList(u32), count);
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    for (callers) |*list| list.* = .empty;

    for (0..count) |index| {
        const function = program.functions.at(index);
        const size = slots.count(function.input_type);
        held[index] = try allocator.alloc(bool, size);
        written[index] = try allocator.alloc(bool, size);

        @memset(written[index], false);

        if (function.external != null) {
            const outputs = try @import("basis.zig").lists(temporary, slots, function.output_type);

            for (held[index], 0..) |*value, slot| value.* = std.mem.indexOfScalar(ir.TypeId, outputs, slots.listType(function.input_type, @intCast(slot))) != null;

            bodies[index] = null;

            continue;
        }

        @memset(held[index], false);

        bodies[index] = try Body.create(temporary, function, slots);

        for (function.expressions.kinds, 0..) |_, expression| {
            const callee = function.expressions.callee(expression) orelse continue;

            try callers[@backingInt(callee)].append(temporary, @intCast(index));
        }
    }

    const self = Self{ .held = held, .written = written };
    var queued = try temporary.alloc(bool, count);
    var queue: std.ArrayList(u32) = .empty;

    // Callees come before their callers in the table, and the queue pops from its end, so it starts with the first
    // function on top: most bodies then read finished callee summaries and are walked once.
    for (0..count) |position| {
        const index = count - 1 - position;

        queued[index] = bodies[index] != null;

        if (queued[index]) try queue.append(temporary, @intCast(index));
    }

    var walk = Walk{ .allocator = temporary, .flow = self, .slots = slots };

    while (queue.pop()) |index| {
        queued[index] = false;
        const body = &bodies[index].?;
        const grew = try walk.held(body, held[index]) or try walk.written(body, written[index]);

        if (!grew) continue;

        for (callers[index].items) |caller| {
            if (queued[caller]) continue;

            queued[caller] = true;

            try queue.append(temporary, caller);
        }
    }

    return self;
}

const Body = struct {
    function: ir.Function,
    order: Order,
    /// The list each element parameter of a transform reads from, by symbol.
    elements: std.AutoHashMapUnmanaged(ir.SymbolId, ir.ExprId),
    /// Where the list slots of each expression start in one dense numbering of every expression slot of the body.
    first: []u32,
    fn create(allocator: std.mem.Allocator, function: ir.Function, slots: Slots) std.mem.Allocator.Error!Body {
        var elements: std.AutoHashMapUnmanaged(ir.SymbolId, ir.ExprId) = .empty;
        const count = function.expressions.count();
        const first = try allocator.alloc(u32, count + 1);
        var total: u32 = 0;

        for (0..count) |index| {
            first[index] = total;
            total += slots.count(function.expressions.get(@fromBackingInt(@intCast(index))).type_id);
        }

        first[count] = total;

        for (0..function.expressions.count()) |index| {
            const transform = switch (function.expressions.get(@fromBackingInt(@intCast(index))).value) {
                .transform => |value| value,
                else => continue,
            };

            for (transform.parameters, 0..) |symbol, position| {
                if (transform.kind == .reduce and position == 0) continue;
                try elements.put(allocator, symbol, transform.target);
            }
        }

        return .{ .function = function, .order = try Order.create(allocator, function.symbols, function.expressions, function.body.block()), .elements = elements, .first = first };
    }
};

const Walk = struct {
    allocator: std.mem.Allocator,
    flow: Self,
    slots: Slots,
    body: *const Body = undefined,
    /// Whether the walk follows the lists stored in a list's elements as well as its buffer.
    contents: bool = false,
    visited: std.DynamicBitSetUnmanaged = .{},
    pending: std.ArrayList(u64) = .empty,
    /// Marks the input slots the output may hold; whether any was new.
    fn held(self: *Walk, body: *const Body, reached: []bool) std.mem.Allocator.Error!bool {
        try self.begin(body, true);
        for (body.order.results.items) |result| try self.whole(result);

        return self.finish(reached);
    }

    /// Marks the input slots the body's own updates and its callees may write in place; whether any was new.
    fn written(self: *Walk, body: *const Body, reached: []bool) std.mem.Allocator.Error!bool {
        try self.begin(body, false);

        const expressions = body.function.expressions;

        for (0..expressions.count()) |index| {
            const id: ir.ExprId = @fromBackingInt(@intCast(index));

            if (body.order.time[index] == Order.none) continue;

            switch (expressions.get(id).value) {
                .list_update => |update| try self.push(update.target, 0),
                .list_operation => |operation| switch (operation.kind) {
                    .sort, .reverse, .pop => try self.push(operation.target, 0),
                    .splice => if (@import("basis.zig").prefix(expressions, operation)) try self.push(operation.target, 0),
                    .push, .concat => {},
                },
                .call => |invocation| for (self.flow.written[@backingInt(invocation.function)], 0..) |value, slot| {
                    if (value) try self.push(invocation.argument, @intCast(slot));
                },
                else => {},
            }
        }

        return self.finish(reached);
    }
    fn begin(self: *Walk, body: *const Body, contents: bool) std.mem.Allocator.Error!void {
        const total = body.first[body.first.len - 1];

        self.body = body;
        self.contents = contents;

        self.pending.clearRetainingCapacity();

        if (self.visited.bit_length < total) try self.visited.resize(self.allocator, total, false);

        self.visited.setRangeValue(.{ .start = 0, .end = total }, false);
    }
    fn finish(self: *Walk, reached: []bool) std.mem.Allocator.Error!bool {
        var grew = false;
        var every = false;

        while (self.pending.pop()) |key| {
            const id: ir.ExprId = @fromBackingInt(@intCast(key >> 32));
            const slot: u32 = @truncate(key);

            if (try self.step(id, slot, reached, &grew)) every = true;
        }

        if (every) for (reached) |*value| {
            if (value.*) continue;

            value.* = true;
            grew = true;
        };

        return grew;
    }
    /// Follows one slot of one value a step back; true when its origin cannot be followed.
    fn step(self: *Walk, id: ir.ExprId, slot: u32, reached: []bool, grew: *bool) std.mem.Allocator.Error!bool {
        const expressions = self.body.function.expressions;
        const value = expressions.get(id);

        switch (value.value) {
            .reference => |symbol| switch (self.body.order.defs[@backingInt(symbol)]) {
                .input => if (slot < reached.len and !reached[slot]) {
                    reached[slot] = true;
                    grew.* = true;
                },
                .value => |bound| try self.push(bound, slot),
                .part => |part| try self.push(part.value, self.offset(part.value, part.index) + slot),
                .carried, .condition => |owner| switch (expressions.get(owner).value) {
                    .iteration => |iteration| {
                        try self.push(iteration.initial, slot);
                        try self.push(iteration.body, slot);
                    },
                    .transform => |transform| {
                        try self.push(transform.initial.?, slot);
                        try self.push(transform.body, slot);
                    },
                    else => return true,
                },
                .element => if (self.contents) try self.push(self.body.elements.get(symbol) orelse return true, 0),
                .unknown => return true,
            },
            .field, .tuple_field => |projection| try self.push(projection.target, self.offset(projection.target, projection.index) + slot),
            .optional_value, .some, .capture => |child| try self.push(child, slot),
            .object => |object| for (0..object.fields.len) |item| {
                const field = object.fields.at(item);

                try self.member(value.type_id, field.index, field.value, slot);
            },
            .tuple => |items| for (items, 0..) |item, position| try self.member(value.type_id, @intCast(position), item, slot),
            .scope => |scope| try self.push(scope.result, slot),
            .conditional => |conditional| {
                try self.push(conditional.yes, slot);
                try self.push(conditional.no, slot);
            },
            .match_expr => |selection| {
                for (0..selection.arms.len) |item| try self.push(selection.arms.at(item).result, slot);
                try self.push(selection.fallback, slot);
            },
            .binary => |binary| if (binary.operator == .coalesce) {
                try self.push(binary.left, slot);
                try self.push(binary.right, slot);
            },
            .list => |items| if (self.contents) for (items) |item| try self.whole(item),
            .list_operation => |operation| {
                const aliased = slot == @intFromBool(operation.kind == .splice);

                if (aliased or (self.contents and self.nested(operation.target))) try self.push(operation.target, 0);
                if (!self.contents) return false;

                switch (operation.kind) {
                    .push => for (operation.arguments) |argument| try self.whole(argument),
                    .concat => for (operation.arguments) |argument| if (self.nested(argument)) try self.whole(argument),
                    .splice => if (self.nested(operation.arguments[2])) try self.whole(operation.arguments[2]),
                    .pop, .sort, .reverse => {},
                }
            },
            .list_update => |update| {
                try self.push(update.target, 0);
                if (self.contents) try self.whole(update.value);
            },
            .index => |item| if (self.contents) try self.push(item.target, 0),
            .transform => |transform| switch (transform.kind) {
                .map => if (self.contents) try self.whole(transform.body),
                .filter => if (self.contents and self.nested(transform.target)) try self.push(transform.target, 0),
                .reduce => {
                    try self.push(transform.initial.?, slot);
                    try self.push(transform.body, slot);
                },
                .every, .some => {},
            },
            .iteration => |iteration| {
                try self.push(iteration.initial, slot);
                try self.push(iteration.body, slot);
            },
            .call => |invocation| for (self.flow.held[@backingInt(invocation.function)], 0..) |holds, input| {
                if (holds) try self.push(invocation.argument, @intCast(input));
            },
            .task, .await_task, .parallel, .store_get => return true,
            else => {},
        }

        return false;
    }
    fn member(self: *Walk, type_id: ir.TypeId, index: u32, item: ir.ExprId, slot: u32) std.mem.Allocator.Error!void {
        const selected = self.slots.member(type_id, index);

        if (slot >= selected.offset and slot < selected.offset + self.slots.count(selected.type_id)) try self.push(item, slot - selected.offset);
    }
    fn offset(self: *Walk, target: ir.ExprId, index: u32) u32 {
        return self.slots.member(self.body.function.expressions.get(target).type_id, index).offset;
    }

    /// Whether the elements of a list hold lists of their own, which copying the elements carries along.
    fn nested(self: *Walk, list: ir.ExprId) bool {
        const type_id = self.slots.unwrap(self.body.function.expressions.get(list).type_id);

        return self.slots.count(self.slots.types.get(type_id).list) != 0;
    }

    /// Every slot of a value, as when it becomes part of a list's contents.
    fn whole(self: *Walk, id: ir.ExprId) std.mem.Allocator.Error!void {
        const index = @backingInt(id);

        for (0..self.body.first[index + 1] - self.body.first[index]) |slot| try self.push(id, @intCast(slot));
    }
    fn push(self: *Walk, id: ir.ExprId, slot: u32) std.mem.Allocator.Error!void {
        const index = @backingInt(id);
        const bit = self.body.first[index] + slot;

        if (bit >= self.body.first[index + 1] or self.visited.isSet(bit)) return;

        self.visited.set(bit);
        try self.pending.append(self.allocator, (@as(u64, index) << 32) | slot);
    }
};
