const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analysis/analyzer.zig");
const Self = @This();
const State = enum { copy, borrowed, owned, loaned, moved };
const Mode = enum { read, move };

allocator: std.mem.Allocator,
program: ir.Program,
reporter: *zx.Reporter,
states: []State,
memo: []?State,
returned: ?State = null,
pub fn check(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!void {
    _ = try analyze(allocator, program, reporter);
}

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!ir.Ownership {
    if (program.type_only) return .copy;

    const states = try allocator.alloc(State, program.symbols.len);

    defer allocator.free(states);

    const memo = try allocator.alloc(?State, program.expressions.len);

    defer allocator.free(memo);
    @memset(states, .copy);
    @memset(memo, null);

    var self = Self{ .allocator = allocator, .program = program, .reporter = reporter, .states = states, .memo = memo };

    states[0] = if (self.isReference(program.input_type)) .borrowed else .copy;

    try self.block(program.body);

    return switch (self.returned orelse .copy) {
        .copy => .copy,
        .owned => .owned,
        .borrowed, .loaned => .borrowed,
        .moved => unreachable,
    };
}

fn isReference(self: *Self, id: ir.TypeId) bool {
    return switch (self.program.typeOf(id)) {
        .list, .object, .tuple => true,
        .optional => |child| self.isReference(child),
        .scalar => |scalar| scalar == .string,
        else => false,
    };
}

fn block(self: *Self, statements: []const ir.Statement) zx.Error!void {
    for (statements) |statement| {
        defer self.releaseLoans(null);

        switch (statement) {
            .evaluate => |id| {
                _ = try self.value(id, .read);
            },
            .constant => |binding| self.states[@intFromEnum(binding.symbol)] = try self.value(binding.value, .move),
            .parallel => |invocations| {
                for (invocations) |invocation| {
                    const state = try self.value(invocation.value, .read);

                    if (invocation.symbol) |symbol| self.states[@intFromEnum(symbol)] = state;

                    self.freeze(self.program.expression(invocation.value).value.call.argument);
                }
            },
            .destructure => |binding| {
                const state = try self.value(binding.value, .move);

                for (binding.symbols) |symbol| if (symbol) |id| {
                    self.states[@intFromEnum(id)] = if (self.isReference(self.program.symbols[@intFromEnum(id)].type_id)) state else .copy;
                };
            },
            .result => |result| if (result) |id| {
                const state = try self.value(id, .move);
                self.returned = if (self.returned == .borrowed or state == .borrowed) .borrowed else if (self.returned == .owned or state == .owned) .owned else state;
            },
            .store_set => |setter| {
                _ = try self.value(setter.value, .read);

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
        if (left.* == .moved or right == .moved) left.* = .moved else if (left.* == .borrowed or right == .borrowed) left.* = .borrowed else if (left.* == .loaned or right == .loaned) left.* = .loaned;
    }
}

fn value(self: *Self, id: ir.ExprId, mode: Mode) zx.Error!State {
    if (self.memo[@intFromEnum(id)]) |state| return state;

    const expression = self.program.expression(id);
    const container = self.isReference(expression.type_id);

    const state: State = switch (expression.value) {
        .store_get => .borrowed,
        .reference => |symbol| blk: {
            const index = @intFromEnum(symbol);
            const current = self.states[index];

            if (current == .moved) return self.reporter.fail(.ownership, expression.span, "the previous owner was consumed; use the new binding returned by the operation");
            if (mode == .move and current == .owned) self.states[index] = .moved;
            if (mode == .move and current == .loaned) self.states[index] = .borrowed;

            break :blk if (current == .loaned) .borrowed else current;
        },
        .field, .tuple_field => |field| try self.value(field.target, if (container) mode else .read),
        .index => |item| blk: {
            const source = try self.value(item.target, if (container) mode else .read);

            _ = try self.value(item.index, .read);

            break :blk source;
        },
        .some => |child| try self.value(child, mode),
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
            const previous = try self.allocator.dupe(?State, self.memo);

            defer self.allocator.free(previous);
            defer @memcpy(self.memo, previous);

            for (object.evaluation) |item| self.memo[@intFromEnum(item)] = try self.aggregateValue(item, mode);

            var result: State = .owned;

            for (object.fields) |field| if (try self.aggregateValue(field.value, mode) == .borrowed) {
                result = .borrowed;
            };

            break :blk result;
        },
        .list_operation => |operation| blk: {
            const source = try self.value(operation.target, .move);

            if (source != .owned) return self.reporter.fail(.ownership, expression.span, "consuming list operations require an owned value; borrowed values cannot be consumed");

            const item_type = self.program.typeOf(self.program.expression(operation.target).type_id).list;
            var result: State = .owned;

            for (operation.arguments) |argument| {
                const argument_state = try self.value(argument, .move);

                if (self.isReference(item_type) and argument_state == .borrowed) result = .borrowed;
            }

            break :blk result;
        },
        .transform => |transform| blk: {
            _ = try self.value(transform.target, .read);
            const initial_state = if (transform.initial) |initial| try self.value(initial, .move) else .copy;
            const saved = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(saved);
            defer @memcpy(self.states, saved);

            for (transform.parameters) |parameter| self.states[@intFromEnum(parameter)] = if (self.isReference(self.program.symbols[@intFromEnum(parameter)].type_id)) .borrowed else .copy;

            const result = try self.value(transform.body, .move);
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

            _ = try self.value(call.argument, .read);

            const function = self.program.functions[@intFromEnum(call.function)];
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
    switch (self.program.expression(id).value) {
        .reference => |symbol| {
            const state = &self.states[@intFromEnum(symbol)];

            if (state.* == .owned or (permanent and state.* == .loaned)) state.* = if (permanent) .borrowed else .loaned;
        },
        .field, .tuple_field => |field| self.borrow(field.target, permanent),
        .index => |item| self.borrow(item.target, permanent),
        .some => |child| self.borrow(child, permanent),
        .match_expr => |selection| {
            for (selection.arms) |arm| self.borrow(arm.result, permanent);

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

fn matchValue(self: *Self, selection: ir.Match, mode: Mode) zx.Error!State {
    if (selection.subject) |subject| _ = try self.value(subject, .read);

    const before = try self.allocator.alloc(State, self.states.len);

    defer self.allocator.free(before);

    const combined = try self.allocator.alloc(State, self.states.len);

    defer self.allocator.free(combined);

    var borrowed = false;

    for (selection.arms, 0..) |arm, index| {
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
