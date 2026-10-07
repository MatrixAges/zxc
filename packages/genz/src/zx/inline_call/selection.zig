const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("plan.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
marked: []bool,
seen: []bool,
pub fn create(allocator: std.mem.Allocator, expressions: ir.ExpressionTable, body: []const ir.Statement, plan: Plan) Error!?[]bool {
    const marked = try allocator.alloc(bool, expressions.count());
    const seen = try allocator.alloc(bool, expressions.count());
    var program = plan.program;
    program.expressions = expressions;

    var self = Self{ .allocator = allocator, .program = program, .marked = marked, .seen = seen };

    @memset(marked, false);
    @memset(seen, false);

    try self.statements(body);

    var cost: usize = 0;

    for (0..expressions.count(), marked) |expression_index, selected| {
        const expression = expressions.at(expression_index);

        if (selected and expression.value == .call) {
            cost +|= plan.costs[@backingInt(expression.value.call.function)];
        }
    }

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
        .constant => |binding| try self.find(binding.value),
        .parallel => |calls| for (calls) |call| try self.find(call.value),
        .destructure => |binding| try self.find(binding.value),
        .store_set => |setter| try self.find(setter.value),
        .result => |value| if (value) |id| try self.find(id),
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
                const binding = scope.bindings.at(scope.bindings.len - 1);

                if (binding.symbol) |symbol| try self.consume(symbol, binding.value, scope.result);
            }

            for (0..scope.bindings.len) |record_index| {
                const binding = scope.bindings.at(record_index);

                if (binding.symbol == null) {
                    try self.iteration(binding.value);
                }
            }
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

fn walk(self: *Self, value: @FieldType(ir.ExpressionRow, "value"), marking: bool) Error!void {
    const children = @import("children.zig").init(value);

    for (0..children.len) |index| {
        const id = children.at(index);

        if (marking) try self.mark(id) else try self.find(id);
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
