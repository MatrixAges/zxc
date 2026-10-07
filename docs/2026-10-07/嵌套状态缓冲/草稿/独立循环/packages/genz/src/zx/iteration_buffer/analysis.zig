const std = @import("std");
const ir = @import("zx").ir;
const facts = @import("fact.zig");
const Value = facts.Value;
const flow = @import("../buffer_call/analysis/flow.zig");
pub const Calls = struct { selected: []const flow.Call, summaries: []const []const flow.Lane, readers: []const bool };

const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
symbols: []Value,
cached: []?Value,
current: usize = 0,
serial: usize = 0,
valid: bool = true,
updates: std.ArrayList(ir.ExprId) = .empty,
calls: ?Calls = null,
const Snapshot = struct { symbols: []Value, cached: []?Value, current: usize };

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, path: []const usize) Error!?[]const ir.ExprId {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();

    var self = Self{
        .allocator = temporary,
        .program = program,
        .symbols = try temporary.alloc(Value, program.symbols.len),
        .cached = try temporary.alloc(?Value, program.expressions.len),
    };

    const initial = try self.seed(program.expression(iteration.initial).type_id, path);

    @memset(self.symbols, .none);
    @memset(self.cached, null);
    self.symbols[@backingInt(iteration.condition_parameter)] = initial;

    _ = try self.expression(iteration.condition);

    if (!self.valid or self.current != 0) return null;

    self.symbols[@backingInt(iteration.parameter)] = initial;

    const result = try self.expression(iteration.body);

    if (!self.valid or self.updates.items.len == 0 or !self.retains(result, path)) return null;

    self.symbols[@backingInt(iteration.condition_parameter)] = result;

    const current = self.current;

    _ = try self.expression(iteration.condition);

    if (!self.valid or self.current != current) return null;

    return try allocator.dupe(ir.ExprId, self.updates.items);
}

pub fn seed(self: *Self, id: ir.TypeId, path: []const usize) Error!Value {
    if (path.len == 0) return .{ .version = self.current };

    const target = self.program.typeOf(id);
    const size = if (target == .object) target.object.len else target.tuple.len;
    const child = if (target == .object) target.object.at(path[0]).type_id else target.tuple.at(path[0]);
    const values = try self.allocator.alloc(Value, size);

    @memset(values, .none);

    values[path[0]] = try self.seed(child, path[1..]);

    return .{ .aggregate = values };
}

pub fn retains(self: *const Self, value: Value, path: []const usize) bool {
    if (path.len == 0) return value == .version and value.version == self.current;
    if (value != .aggregate or path[0] >= value.aggregate.len) return false;

    for (value.aggregate, 0..) |child, index| {
        if (index == path[0]) {
            if (!self.retains(child, path[1..])) return false;
        } else if (facts.contains(child)) return false;
    }

    return true;
}

pub fn expression(self: *Self, id: ir.ExprId) Error!Value {
    if (!self.valid) return .none;
    if (self.cached[@backingInt(id)]) |value| return value;

    return switch (self.program.expression(id).value) {
        .capture, .task, .await_task, .cancel_task, .parallel => blk: {
            self.valid = false;

            break :blk .none;
        },
        .reference => |symbol| self.symbols[@backingInt(symbol)],
        .field, .tuple_field => |field| facts.field(try self.expression(field.target), field.index),
        .length => |child| blk: {
            _ = try self.expression(child);

            break :blk .none;
        },
        .index => |item| blk: {
            const target = try self.expression(item.target);

            self.observe(try self.expression(item.index));
            self.observe(target);

            break :blk .none;
        },
        .list_update => |update| blk: {
            const target = try self.expression(update.target);

            self.observe(try self.expression(update.index));
            self.rejectAlias(try self.expression(update.value));

            break :blk try self.advance(id, target);
        },
        .scope => |scope| blk: {
            const previous = try self.allocator.dupe(Value, self.symbols);

            defer for (scope.bindings) |binding| if (binding.symbol) |symbol| {
                self.symbols[@backingInt(symbol)] = previous[@backingInt(symbol)];
            };

            for (scope.bindings) |binding| {
                const value = try self.expression(binding.value);

                if (binding.symbol) |symbol| self.symbols[@backingInt(symbol)] = value;
            }

            break :blk try self.expression(scope.result);
        },
        .object => |object| blk: {
            const previous = try self.allocator.dupe(?Value, self.cached);

            defer @memcpy(self.cached, previous);

            for (object.evaluation) |item| self.cached[@backingInt(item)] = try self.expression(item);

            const fields = try self.allocator.alloc(Value, object.fields.len);

            @memset(fields, .none);

            for (object.fields) |field| fields[field.index] = try self.expression(field.value);

            break :blk .{ .aggregate = fields };
        },
        .tuple => |items| blk: {
            const values = try self.allocator.alloc(Value, items.len);

            for (items, values) |item, *value| value.* = try self.expression(item);

            break :blk .{ .aggregate = values };
        },
        .conditional => |conditional| blk: {
            self.observe(try self.expression(conditional.condition));

            const before = try self.snapshot();
            const yes = try self.expression(conditional.yes);
            const yes_state = try self.snapshot();

            self.restore(before);

            const no = try self.expression(conditional.no);

            break :blk try self.join(yes_state, yes, no);
        },
        .match_expr => |selection| blk: {
            if (selection.subject) |subject| self.observe(try self.expression(subject));

            const version = self.current;

            for (selection.arms) |arm| self.observe(try self.expression(arm.condition));
            if (self.current != version) self.valid = false;

            const before = try self.snapshot();
            var result = try self.expression(selection.fallback);

            for (selection.arms) |arm| {
                const previous = try self.snapshot();

                self.restore(before);

                const next = try self.expression(arm.result);

                result = try self.join(previous, result, next);
            }

            break :blk result;
        },
        .call => |call| blk: {
            const argument = try self.expression(call.argument);
            const function = self.program.functions[@backingInt(call.function)];

            if (self.calls) |calls| {
                if (!facts.contains(argument)) break :blk .none;

                for (calls.selected) |selected| {
                    if (selected.expression != id) continue;

                    const lane = calls.summaries[@backingInt(call.function)][selected.lane];
                    var target = argument;

                    for (lane.input) |part| target = facts.field(target, part);

                    _ = try self.advance(id, target);

                    const path = try self.allocator.alloc(usize, lane.output.len);

                    for (lane.output, path) |part, *output| output.* = part;

                    break :blk try self.seed(function.output_type, path);
                }

                self.observe(argument);

                if (@backingInt(call.function) >= calls.readers.len or !calls.readers[@backingInt(call.function)]) self.valid = false;

                break :blk .none;
            }

            self.observe(argument);

            if (facts.contains(argument) and (function.external != null or self.hasList(function.output_type))) self.valid = false;

            break :blk .none;
        },
        .some => |child| blk: {
            self.rejectAlias(try self.expression(child));

            break :blk .none;
        },
        .optional_value => |child| blk: {
            self.rejectAlias(try self.expression(child));

            break :blk .none;
        },
        .list, .template => |items| blk: {
            for (items) |item| self.rejectAlias(try self.expression(item));

            break :blk .none;
        },
        .list_operation => |operation| blk: {
            const target = try self.expression(operation.target);

            for (operation.arguments) |argument| self.rejectAlias(try self.expression(argument));

            if (target == .none) break :blk .none;

            if (operation.kind != .push and operation.kind != .concat and operation.kind != .pop) {
                self.valid = false;

                break :blk .none;
            }

            const next = try self.advance(id, target);
            const values = try self.allocator.dupe(Value, &.{ next, .none });

            break :blk .{ .aggregate = values };
        },
        .iteration => |iteration| self.independentIteration(iteration),
        .transform => blk: {
            self.valid = false;

            break :blk .none;
        },
        .unary => |unary| blk: {
            self.observe(try self.expression(unary.operand));

            break :blk .none;
        },
        .binary => |binary| blk: {
            const left = try self.expression(binary.left);

            self.observe(left);

            const version = self.current;
            const right = try self.expression(binary.right);

            self.observe(left);
            self.observe(right);

            if (binary.operator == .coalesce) {
                self.rejectAlias(left);
                self.rejectAlias(right);
            }

            if ((binary.operator == .logical_and or binary.operator == .logical_or or binary.operator == .coalesce) and self.current != version) self.valid = false;

            break :blk .none;
        },
        .store_get => blk: {
            self.valid = false;

            break :blk .none;
        },
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value => .none,
    };
}

fn independentIteration(self: *Self, iteration: ir.Iteration) Error!Value {
    self.rejectAlias(try self.expression(iteration.initial));

    const before = try self.snapshot();
    const serial = self.serial;

    defer self.restore(before);
    self.symbols[@backingInt(iteration.condition_parameter)] = .none;
    self.observe(try self.expression(iteration.condition));
    self.restore(before);
    self.symbols[@backingInt(iteration.parameter)] = .none;
    self.rejectAlias(try self.expression(iteration.body));

    self.valid = self.valid and self.serial == serial;

    return .none;
}

fn advance(self: *Self, id: ir.ExprId, target: Value) Error!Value {
    if (target == .none) return .none;

    if (target != .version or target.version != self.current) {
        self.valid = false;

        return .none;
    }

    if (std.mem.indexOfScalar(ir.ExprId, self.updates.items, id) == null) try self.updates.append(self.allocator, id);

    self.current = self.fresh();

    return .{ .version = self.current };
}

pub fn observe(self: *Self, value: Value) void {
    self.valid = self.valid and facts.observe(value, self.current);
}

fn rejectAlias(self: *Self, value: Value) void {
    if (facts.contains(value)) self.valid = false;
}

fn fresh(self: *Self) usize {
    self.serial += 1;

    return self.serial;
}

pub fn snapshot(self: *Self) Error!Snapshot {
    return .{ .symbols = try self.allocator.dupe(Value, self.symbols), .cached = try self.allocator.dupe(?Value, self.cached), .current = self.current };
}

pub fn restore(self: *Self, saved: Snapshot) void {
    @memcpy(self.symbols, saved.symbols);
    @memcpy(self.cached, saved.cached);

    self.current = saved.current;
}

pub fn join(self: *Self, previous: Snapshot, left: Value, right: Value) Error!Value {
    const next_version = self.current;
    const joined = if (previous.current == next_version) next_version else self.fresh();

    for (previous.symbols, self.symbols) |a, *b| b.* = try facts.merge(self.allocator, a, b.*, previous.current, next_version, joined);

    for (previous.cached, self.cached) |a, *b| {
        if (a != null and b.* != null) b.* = try facts.merge(self.allocator, a.?, b.*.?, previous.current, next_version, joined) else b.* = null;
    }

    self.current = joined;

    return facts.merge(self.allocator, left, right, previous.current, next_version, joined);
}

fn hasList(self: *const Self, id: ir.TypeId) bool {
    return switch (self.program.typeOf(id)) {
        .list => true,
        .optional => |child| self.hasList(child),
        .object => |fields| blk: {
            for (0..fields.len) |view_index| {
                const field = fields.at(view_index);

                if (self.hasList(field.type_id)) break :blk true;
            }

            break :blk false;
        },
        .tuple => |items| blk: {
            for (0..items.len) |item_index| {
                const item = items.at(item_index);

                if (self.hasList(item)) break :blk true;
            }

            break :blk false;
        },
        else => false,
    };
}
