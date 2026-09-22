const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analysis/analyzer.zig");
const Self = @This();
const State = enum { copy, borrowed, owned, moved };
const Mode = enum { read, move };

allocator: std.mem.Allocator,
program: ir.Program,
reporter: *zx.Reporter,
states: []State,
memo: []?State,
pub fn check(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!void {
    if (program.type_only) return;

    const states = try allocator.alloc(State, program.symbols.len);

    defer allocator.free(states);

    const memo = try allocator.alloc(?State, program.expressions.len);

    defer allocator.free(memo);
    @memset(states, .copy);
    @memset(memo, null);

    var self = Self{ .allocator = allocator, .program = program, .reporter = reporter, .states = states, .memo = memo };

    states[0] = if (self.containsList(program.input_type)) .borrowed else .copy;

    try self.block(program.body);
}

fn containsList(self: *Self, id: ir.TypeId) bool {
    return switch (self.program.typeOf(id)) {
        .list => true,
        .optional => |child| self.containsList(child),
        .tuple => |children| blk: {
            for (children) |child| if (self.containsList(child)) {
                break :blk true;
            };

            break :blk false;
        },
        .object => |fields| blk: {
            for (fields) |field| if (self.containsList(field.type_id)) {
                break :blk true;
            };

            break :blk false;
        },
        else => false,
    };
}

fn block(self: *Self, statements: []const ir.Statement) zx.Error!void {
    for (statements) |statement| {
        switch (statement) {
            .constant => |binding| self.states[@intFromEnum(binding.symbol)] = try self.value(binding.value, .move),
            .destructure => |binding| {
                const state = try self.value(binding.value, .move);

                for (binding.symbols) |symbol| if (symbol) |id| {
                    self.states[@intFromEnum(id)] = if (self.containsList(self.program.symbols[@intFromEnum(id)].type_id)) state else .copy;
                };
            },
            .result => |result| if (result) |id| {
                _ = try self.value(id, .move);
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
        if (left.* == .moved or right == .moved) left.* = .moved else if (left.* == .borrowed or right == .borrowed) left.* = .borrowed;
    }
}

fn value(self: *Self, id: ir.ExprId, mode: Mode) zx.Error!State {
    if (self.memo[@intFromEnum(id)]) |state| return state;

    const expression = self.program.expression(id);
    const container = self.containsList(expression.type_id);

    const state: State = switch (expression.value) {
        .store_get => .borrowed,
        .reference => |symbol| blk: {
            const index = @intFromEnum(symbol);
            const current = self.states[index];

            if (current == .moved) return self.reporter.fail(.ownership, expression.span, "the previous owner was consumed; use the new binding returned by the operation");
            if (mode == .move and current == .owned) self.states[index] = .moved;

            break :blk current;
        },
        .field, .tuple_field => |field| try self.value(field.target, if (container) mode else .read),
        .index => |item| blk: {
            const source = try self.value(item.target, if (container) mode else .read);

            _ = try self.value(item.index, .read);

            break :blk source;
        },
        .some => |child| try self.value(child, mode),
        .clone => |child| blk: {
            _ = try self.value(child, .read);

            break :blk .owned;
        },
        .length => |child| blk: {
            _ = try self.value(child, .read);

            break :blk .copy;
        },
        .list, .tuple => |items| blk: {
            var result: State = .owned;

            for (items) |item| if (try self.value(item, .move) == .borrowed) {
                result = .borrowed;
            };

            break :blk result;
        },
        .object => |object| blk: {
            const previous = try self.allocator.dupe(?State, self.memo);

            defer self.allocator.free(previous);
            defer @memcpy(self.memo, previous);

            for (object.evaluation) |item| self.memo[@intFromEnum(item)] = try self.value(item, .move);

            var result: State = .owned;

            for (object.fields) |field| if (try self.value(field.value, .move) == .borrowed) {
                result = .borrowed;
            };

            break :blk result;
        },
        .list_operation => |operation| blk: {
            const source = try self.value(operation.target, .move);

            if (source != .owned) return self.reporter.fail(.ownership, expression.span, "consuming list operations require an owned value; clone borrowed input explicitly");

            var result: State = .owned;

            for (operation.arguments) |argument| if (try self.value(argument, .move) == .borrowed) {
                result = .borrowed;
            };

            break :blk result;
        },
        .transform => |transform| blk: {
            _ = try self.value(transform.target, .read);

            if (transform.initial) |initial| {
                _ = try self.value(initial, .move);
            }

            const saved = try self.allocator.dupe(State, self.states);

            defer self.allocator.free(saved);
            defer @memcpy(self.states, saved);

            for (transform.parameters) |parameter| self.states[@intFromEnum(parameter)] = if (self.containsList(self.program.symbols[@intFromEnum(parameter)].type_id)) .borrowed else .copy;

            const result = try self.value(transform.body, .move);
            const item_type = self.program.typeOf(self.program.expression(transform.target).type_id).list;
            const borrowed = (transform.kind == .filter and self.containsList(item_type)) or result == .borrowed;

            if (borrowed) {
                @memcpy(self.states, saved);
                self.freeze(transform.target);
                @memcpy(saved, self.states);
            }

            break :blk if (borrowed) .borrowed else .owned;
        },
        .call => |call| blk: {
            _ = try self.value(call.argument, .read);

            if (container) self.freeze(call.argument);

            break :blk .borrowed;
        },
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

fn freeze(self: *Self, id: ir.ExprId) void {
    switch (self.program.expression(id).value) {
        .reference => |symbol| {
            if (self.states[@intFromEnum(symbol)] == .owned) self.states[@intFromEnum(symbol)] = .borrowed;
        },
        .field, .tuple_field => |field| self.freeze(field.target),
        .index => |item| self.freeze(item.target),
        .some => |child| self.freeze(child),
        .conditional => |item| {
            self.freeze(item.yes);
            self.freeze(item.no);
        },
        .binary => |item| {
            self.freeze(item.left);
            self.freeze(item.right);
        },
        .transform => |item| self.freeze(item.target),
        .call => |item| self.freeze(item.argument),
        .list, .tuple => |items| for (items) |item| self.freeze(item),
        .object => |object| for (object.evaluation) |item| self.freeze(item),
        else => {},
    }
}
