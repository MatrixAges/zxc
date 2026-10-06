const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("plan.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
marked: []bool,
seen: []bool,
pub fn create(allocator: std.mem.Allocator, expressions: []const ir.Expression, body: []const ir.Statement, plan: Plan) Error!?[]bool {
    const marked = try allocator.alloc(bool, expressions.len);
    const seen = try allocator.alloc(bool, expressions.len);
    var program = plan.program;
    program.expressions = expressions;

    var self = Self{ .allocator = allocator, .program = program, .marked = marked, .seen = seen };

    @memset(marked, false);
    @memset(seen, false);

    try self.statements(body);

    var cost: usize = 0;

    for (expressions, marked) |expression, selected| if (selected and expression.value == .call) {
        cost +|= plan.costs[@backingInt(expression.value.call.function)];
    };

    return if (cost != 0 and cost <= Plan.limit) marked else null;
}

fn statements(self: *Self, items: []const ir.Statement) Error!void {
    if (items.len >= 2 and items[items.len - 1] == .result and items[items.len - 2] == .constant) {
        if (items[items.len - 1].result) |result| {
            const binding = items[items.len - 2].constant;

            try self.consume(binding.symbol, binding.value, result);
        }
    }

    for (items) |item| switch (item) {
        .evaluate => |id| {
            try self.iteration(id);
            try self.find(id);
        },
        .branch => |branch| {
            try self.find(branch.condition);
            try self.statements(branch.yes);
            try self.statements(branch.no);
        },
        .switch_stmt => |selection| {
            try self.find(selection.subject);

            for (selection.cases) |case| {
                if (case.value) |value| try self.find(value);
                try self.statements(case.body);
            }
        },
        else => try self.walk(item, false),
    };
}

fn consume(self: *Self, symbol: ir.SymbolId, value: ir.ExprId, result: ir.ExprId) Error!void {
    if (self.program.expression(value).value != .iteration) return;
    if (!try @import("../iteration_value/result.zig").candidate(self.allocator, self.program, .{ .symbol = symbol, .result = result })) return;
    try self.iteration(value);
}

fn iteration(self: *Self, id: ir.ExprId) Error!void {
    const value = self.program.expression(id).value;

    if (value != .iteration) return;

    const type_id = self.program.expression(value.iteration.initial).type_id;

    if (!@import("../iteration_value/list_plan.zig").supported(self.program, type_id) or !productList(self.program, type_id)) return;
    try self.mark(value.iteration.condition);
    try self.mark(value.iteration.body);
}

fn find(self: *Self, id: ir.ExprId) Error!void {
    if (self.seen[@backingInt(id)]) return;

    self.seen[@backingInt(id)] = true;

    const value = self.program.expression(id).value;

    switch (value) {
        .iteration, .capture, .task, .transform => return,
        .scope => |scope| {
            if (scope.bindings.len != 0) {
                const binding = scope.bindings[scope.bindings.len - 1];

                if (binding.symbol) |symbol| try self.consume(symbol, binding.value, scope.result);
            }

            for (scope.bindings) |binding| if (binding.symbol == null) {
                try self.iteration(binding.value);
            };
        },
        else => {},
    }

    try self.walk(value, false);
}

fn mark(self: *Self, id: ir.ExprId) Error!void {
    if (self.marked[@backingInt(id)]) return;

    self.marked[@backingInt(id)] = true;

    try self.walk(self.program.expression(id).value, true);
}

fn walk(self: *Self, value: anytype, marking: bool) Error!void {
    const T = @TypeOf(value);

    if (T == ir.ExprId) return if (marking) self.mark(value) else self.find(value);

    switch (@typeInfo(T)) {
        .@"struct" => |info| inline for (info.field_names) |name| try self.walk(@field(value, name), marking),
        .@"union" => |info| inline for (info.field_names) |name| {
            if (std.mem.eql(u8, @tagName(value), name)) try self.walk(@field(value, name), marking);
        },
        .optional => if (value) |child| try self.walk(child, marking),
        .pointer => |info| if (info.size == .slice and info.child != u8) {
            for (value) |child| try self.walk(child, marking);
        },
        else => {},
    }
}

fn productList(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list => |child| @import("../iteration_layout.zig").represented(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (productList(program, fields.at(index).type_id)) break :blk true;

            break :blk false;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (productList(program, items.at(index))) break :blk true;

            break :blk false;
        },
        else => false,
    };
}
