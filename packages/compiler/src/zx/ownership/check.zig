const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analysis/analyzer.zig");
const Self = @This();
const Places = @import("places.zig");
const State = Places.State;
const Mode = enum { read, move };
pub const Facts = struct { output: ir.Ownership, stores_owned: bool };

allocator: std.mem.Allocator,
program: ir.Program,
reporter: *zx.Reporter,
states: []State,
places: Places,
memo: []?usize,

returned: ?State = null,
stores_owned: bool = true,
pub fn check(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!void {
    _ = try analyze(allocator, program, reporter);
}

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!ir.Ownership {
    return (try facts(allocator, program, reporter)).output;
}

pub fn facts(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!Facts {
    if (program.type_only) return .{ .output = .copy, .stores_owned = true };

    var places = try Places.init(allocator, program);

    defer places.deinit(allocator);

    const states = try allocator.alloc(State, places.layout.nodes.len);

    defer allocator.free(states);

    const memo = try allocator.alloc(?usize, program.expressions.count());

    defer allocator.free(memo);
    @memset(states, .copy);
    @memset(memo, null);

    var self = Self{ .allocator = allocator, .program = program, .reporter = reporter, .states = states, .places = places, .memo = memo };

    places.assign(states, 0, .borrowed);

    try self.block(program.body);

    const output: ir.Ownership = switch (self.returned orelse .copy) {
        .copy => .copy,
        .owned => .owned,
        .borrowed, .loaned => .borrowed,
        .moved => unreachable,
    };

    return .{ .output = output, .stores_owned = self.stores_owned };
}

fn isReference(self: *Self, id: ir.TypeId) bool {
    return Places.isReference(self.program, id);
}

fn block(self: *Self, statements: []const ir.Statement) zx.Error!void {
    for (statements) |statement| {
        defer self.releaseLoans(null);

        switch (statement) {
            .evaluate => |id| {
                _ = try self.value(id, .read);
            },
            .constant => |binding| self.places.assign(self.states, @backingInt(binding.symbol), try self.value(binding.value, .move)),
            .parallel => |invocations| {
                for (invocations) |invocation| {
                    const state = try self.value(invocation.value, .read);

                    if (invocation.symbol) |symbol| self.places.assign(self.states, @backingInt(symbol), state);

                    self.freeze(self.program.expression(invocation.value).value.call.argument);
                }
            },
            .destructure => |binding| {
                const state = try self.value(binding.value, .move);

                for (binding.symbols) |symbol| if (symbol) |id| {
                    self.places.assign(self.states, @backingInt(id), state);
                };
            },
            .result => |result| if (result) |id| {
                const state = try self.value(id, .move);
                self.returned = if (self.returned == .borrowed or state == .borrowed) .borrowed else if (self.returned == .owned or state == .owned) .owned else state;
            },
            .store_set => |setter| {
                const state = try self.value(setter.value, .read);

                self.stores_owned = self.stores_owned and (state == .owned or state == .copy);

                self.freeze(setter.value);
            },
            .branch => |branch| {
                _ = try self.value(branch.condition, .read);

                const before = try self.allocator.dupe(State, self.states);

                defer self.allocator.free(before);

                try self.block(branch.yes);

                const yes = try self.allocator.dupe(State, self.states);

                defer self.allocator.free(yes);
                @memcpy(self.states, before);

                try self.block(branch.no);

                if (Analyzer.returns(branch.yes)) {
                    if (Analyzer.returns(branch.no)) @memcpy(self.states, before);
                } else if (Analyzer.returns(branch.no)) @memcpy(self.states, yes) else merge(self.states, yes);
            },
            .switch_stmt => |selection| {
                _ = try self.value(selection.subject, .read);

                const before = try self.allocator.dupe(State, self.states);

                defer self.allocator.free(before);

                const combined = try self.allocator.dupe(State, before);

                defer self.allocator.free(combined);

                var has_path = !selection.exhaustive;

                for (selection.cases) |case| {
                    @memcpy(self.states, before);

                    try self.block(case.body);

                    if (!Analyzer.returns(case.body)) {
                        if (has_path) merge(combined, self.states) else @memcpy(combined, self.states);

                        has_path = true;
                    }
                }

                @memcpy(self.states, combined);
            },
        }
    }
}

fn merge(target: []State, other: []const State) void {
    for (target, other) |*left, right| {
        left.* = Places.combine(left.*, right);
    }
}

fn value(self: *Self, id: ir.ExprId, mode: Mode) zx.Error!State {
    const expression = self.program.expression(id);

    if (self.memo[@backingInt(id)]) |position| return self.access(position, mode, expression.span);

    const container = self.isReference(expression.type_id);

    const state: State = switch (expression.value) {
        .store_get => .borrowed,
        .list_update => |update| blk: {
            _ = try self.value(update.target, .read);
            _ = try self.value(update.index, .read);
            const replacement = try self.value(update.value, .move);
            const element = self.program.typeOf(expression.type_id).list;

            if (self.isReference(element) or replacement == .borrowed or replacement == .loaned) {
                self.freeze(update.target);
                self.freeze(update.value);

                break :blk .borrowed;
            }

            break :blk .owned;
        },
        .iteration => |iteration| blk: {
            const initial = try self.value(iteration.initial, .read);
            const temporary = self.program.expression(iteration.initial).value == .call and initial == .owned;
            const saved = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(saved);
            defer @memcpy(self.states, saved);

            const state: State = if (container) .borrowed else .copy;

            self.places.assign(self.states, @backingInt(iteration.condition_parameter), state);

            _ = try self.value(iteration.condition, .read);

            @memcpy(self.states, saved);
            self.places.assign(self.states, @backingInt(iteration.parameter), if (temporary) .owned else state);

            const result = try self.value(iteration.body, .move);

            if (temporary and (result == .borrowed or result == .loaned)) {
                @memcpy(self.states, saved);
                self.places.assign(self.states, @backingInt(iteration.parameter), state);

                _ = try self.value(iteration.body, .move);
            }

            const borrowed = container and ((!iteration.postcondition and !temporary) or result == .borrowed or result == .loaned);

            if (borrowed) {
                @memcpy(self.states, saved);
                self.freeze(iteration.initial);
                @memcpy(saved, self.states);
            }

            break :blk if (borrowed) .borrowed else result;
        },
        .scope => |scope| blk: {
            const before = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(before);

            for (0..scope.bindings.len) |record_index| {
                const binding = scope.bindings.at(record_index);
                var evaluated = try self.value(binding.value, if (binding.symbol != null and !binding.borrow) .move else .read);

                if (binding.borrow and self.isReference(self.program.expression(binding.value).type_id)) {
                    self.freeze(binding.value);

                    evaluated = .borrowed;
                }

                if (binding.symbol) |symbol| self.places.assign(self.states, @backingInt(symbol), evaluated);

                self.releaseLoans(before);
            }

            break :blk try self.value(scope.result, mode);
        },
        .reference => |symbol| try self.access(@backingInt(symbol), mode, expression.span),
        .field, .tuple_field => |field| if (self.place(id)) |position| try self.access(position, if (container) mode else .read, expression.span) else try self.value(field.target, if (container) mode else .read),
        .index => |item| blk: {
            const source = try self.value(item.target, if (container) mode else .read);

            _ = try self.value(item.index, .read);

            break :blk source;
        },
        .some, .optional_value => |child| try self.value(child, mode),
        .length => |child| blk: {
            _ = try self.value(child, .read);

            break :blk .copy;
        },
        .list, .tuple => |items| blk: {
            var result: State = .owned;

            for (items) |item| if (try self.aggregateValue(item, mode) == .borrowed) {
                result = .borrowed;
            };

            break :blk result;
        },
        .object => |object| blk: {
            const previous = try self.allocator.dupe(?usize, self.memo);

            defer self.allocator.free(previous);
            defer @memcpy(self.memo, previous);

            for (object.evaluation, self.places.layout.cached[@backingInt(id)]) |item, position| {
                const evaluated = try self.aggregateValue(item, mode);

                self.places.assign(self.states, position, evaluated);
                self.memo[@backingInt(item)] = position;
            }

            var result: State = .owned;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (try self.aggregateValue(field.value, mode) == .borrowed) {
                    result = .borrowed;
                }
            }

            break :blk result;
        },
        .list_operation => |operation| blk: {
            const source = try self.value(operation.target, .read);
            const item_type = self.program.typeOf(self.program.expression(operation.target).type_id).list;
            const shares_source = operation.kind == .pop or operation.kind == .splice or self.isReference(item_type);
            var result: State = if (shares_source and (source == .borrowed or source == .loaned)) .borrowed else .owned;

            for (operation.arguments) |argument| {
                const argument_state = try self.value(argument, .read);

                if (self.isReference(item_type) and (argument_state == .borrowed or argument_state == .loaned)) result = .borrowed;
            }

            if (result == .borrowed) {
                self.freeze(operation.target);

                for (operation.arguments) |argument| self.freeze(argument);
            }

            break :blk result;
        },
        .transform => |transform| blk: {
            const before = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(before);
            defer self.releaseLoans(before);

            _ = try self.aggregateValue(transform.target, .read);
            const initial_state = if (transform.initial) |initial| try self.value(initial, .move) else .copy;
            const saved = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(saved);
            defer @memcpy(self.states, saved);

            const result = try self.callback(transform, initial_state);

            if (transform.kind == .reduce and result == .borrowed and initial_state != .borrowed) {
                @memcpy(self.states, saved);

                _ = try self.callback(transform, .borrowed);
            }

            if (transform.kind == .every or transform.kind == .some) break :blk .copy;

            const item_type = self.program.typeOf(self.program.expression(transform.target).type_id).list;
            const borrowed = (transform.kind == .filter and self.isReference(item_type)) or result == .borrowed or initial_state == .borrowed;

            if (borrowed) {
                @memcpy(self.states, saved);
                self.freeze(transform.target);

                if (transform.initial) |initial| self.freeze(initial);

                @memcpy(saved, self.states);
            }

            break :blk if (borrowed) .borrowed else .owned;
        },
        .call => |call| blk: {
            const before = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(before);
            defer self.releaseLoans(before);

            const function = self.program.functions[@backingInt(call.function)];
            _ = try self.value(call.argument, .read);
            const ownership = function.output_ownership;
            var escapes = container and ownership == .borrowed;

            for (function.stores) |slot| escapes = escapes or slot.writable;
            if (escapes) self.freeze(call.argument);

            break :blk switch (ownership) {
                .copy => .copy,
                .owned => .owned,
                .borrowed => .borrowed,
            };
        },
        .match_expr => |selection| try self.matchValue(selection, mode),
        .conditional => |conditional| blk: {
            _ = try self.value(conditional.condition, .read);

            const before = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(before);

            const yes_state = try self.value(conditional.yes, mode);
            const yes = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(yes);
            @memcpy(self.states, before);

            const no_state = try self.value(conditional.no, mode);

            merge(self.states, yes);

            break :blk if (yes_state == .borrowed or no_state == .borrowed) .borrowed else .owned;
        },
        .binary => |binary| blk: {
            const left = try self.value(binary.left, if (container) mode else .read);
            const before = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(before);

            const right = try self.value(binary.right, if (container) mode else .read);

            if (binary.operator == .logical_and or binary.operator == .logical_or or binary.operator == .coalesce) merge(self.states, before);

            break :blk if (left == .borrowed or right == .borrowed) .borrowed else .owned;
        },
        .capture => |child| try self.value(child, mode),
        .task => |task| blk: {
            for (task.captures) |symbol| {
                _ = try self.access(@backingInt(symbol), .read, expression.span);

                self.places.borrow(self.states, @backingInt(symbol), true);
            }

            const saved = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(saved);
            defer @memcpy(self.states, saved);

            _ = try self.value(task.body, .read);

            break :blk .owned;
        },
        .await_task => |child| blk: {
            _ = try self.value(child, .move);

            break :blk .borrowed;
        },
        .cancel_task => |child| blk: {
            _ = try self.value(child, .move);

            break :blk .copy;
        },
        .parallel => |branches| blk: {
            for (0..branches.len) |record_index| {
                const branch = branches.at(record_index);
                _ = try self.value(branch.task, .move);
            }

            break :blk .borrowed;
        },
        .unary => |unary| blk: {
            _ = try self.value(unary.operand, .read);

            break :blk .copy;
        },
        .template => |parts| blk: {
            for (parts) |part| {
                _ = try self.value(part, .read);
            }

            break :blk .copy;
        },
        else => .copy,
    };

    return if (container) state else .copy;
}

fn access(self: *Self, position: usize, mode: Mode, span: zx.Span) zx.Error!State {
    const current = self.states[position];

    if (current == .moved) return self.reporter.fail(.ownership, span, "the previous owner was consumed; use the new binding returned by the operation");

    const linear = position < self.program.symbols.count() and self.program.typeOf(self.program.symbols.at(position).type_id) == .task;

    if (mode == .move and current == .owned and linear) self.places.assign(self.states, position, .moved);
    if (mode == .move and (current == .loaned or current == .borrowed)) self.places.assign(self.states, position, .borrowed);

    return if (current == .loaned) .borrowed else current;
}

fn place(self: *Self, id: ir.ExprId) ?usize {
    if (self.memo[@backingInt(id)]) |position| return position;

    return switch (self.program.expression(id).value) {
        .reference => |symbol| @backingInt(symbol),
        .field, .tuple_field => |field| if (self.place(field.target)) |parent| self.places.layout.child(parent, field.index) else null,
        else => null,
    };
}

fn callback(self: *Self, transform: ir.Transform, initial: State) zx.Error!State {
    for (transform.parameters, 0..) |parameter, index| {
        const state: State = if (!self.isReference(self.program.symbols.at(@backingInt(parameter)).type_id)) .copy else if (transform.kind == .reduce and index == 0) initial else .borrowed;

        self.places.assign(self.states, @backingInt(parameter), state);
    }

    return self.value(transform.body, .move);
}

fn aggregateValue(self: *Self, id: ir.ExprId, mode: Mode) zx.Error!State {
    const state = try self.value(id, mode);

    if (mode == .read and self.isReference(self.program.expression(id).type_id)) self.borrow(id, false);

    return state;
}

fn releaseLoans(self: *Self, before: ?[]const State) void {
    for (self.states, 0..) |*state, index| {
        if (state.* == .loaned and (before == null or before.?[index] != .loaned)) state.* = .owned;
    }
}

fn freeze(self: *Self, id: ir.ExprId) void {
    self.borrow(id, true);
}

fn borrow(self: *Self, id: ir.ExprId, permanent: bool) void {
    if (self.place(id)) |position| {
        self.places.borrow(self.states, position, permanent);

        return;
    }

    switch (self.program.expression(id).value) {
        .scope => |scope| self.borrow(scope.result, permanent),
        .list_update => |update| {
            self.borrow(update.target, permanent);
            self.borrow(update.value, permanent);
        },
        .iteration => |iteration| self.borrow(iteration.initial, permanent),
        .field, .tuple_field => |field| self.borrow(field.target, permanent),
        .index => |item| self.borrow(item.target, permanent),
        .some, .capture, .optional_value => |child| self.borrow(child, permanent),
        .match_expr => |selection| {
            for (0..selection.arms.len) |record_index| {
                const arm = selection.arms.at(record_index);

                self.borrow(arm.result, permanent);
            }

            self.borrow(selection.fallback, permanent);
        },
        .conditional => |item| {
            self.borrow(item.yes, permanent);
            self.borrow(item.no, permanent);
        },
        .binary => |item| {
            self.borrow(item.left, permanent);
            self.borrow(item.right, permanent);
        },
        .transform => |item| if (permanent) self.freeze(item.target),
        .call => |item| if (permanent) self.freeze(item.argument),
        .list, .tuple => |items| for (items) |item| self.borrow(item, permanent),
        .object => |object| for (object.evaluation) |item| self.borrow(item, permanent),
        else => {},
    }
}

fn matchValue(self: *Self, selection: ir.MatchRow, mode: Mode) zx.Error!State {
    if (selection.subject) |subject| _ = try self.value(subject, .read);

    const before = try self.allocator.alloc(State, self.states.len);

    defer self.allocator.free(before);

    const combined = try self.allocator.alloc(State, self.states.len);

    defer self.allocator.free(combined);

    var borrowed = false;

    for (0..selection.arms.len) |index| {
        const arm = selection.arms.at(index);

        _ = try self.value(arm.condition, .read);

        @memcpy(before, self.states);

        const result = try self.value(arm.result, mode);
        borrowed = borrowed or result == .borrowed;

        if (index == 0) @memcpy(combined, self.states) else merge(combined, self.states);

        @memcpy(self.states, before);
    }

    const fallback = try self.value(selection.fallback, mode);

    if (selection.arms.len != 0) merge(self.states, combined);

    return if (borrowed or fallback == .borrowed) .borrowed else .owned;
}
