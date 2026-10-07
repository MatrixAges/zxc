const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const independent = @import("independent.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
function: ir.Function,
summaries: []const []const flow.Lane,
readers: []const bool = &.{},
bindings: []?ir.ExprId,
iterations: []?ir.ExprId,
assumptions: std.ArrayList(independent.Proof) = .empty,
proven: std.ArrayList(independent.Proof) = .empty,
results: std.ArrayList(ir.ExprId) = .empty,
appends: std.ArrayList(ir.ExprId) = .empty,
pops: std.ArrayList(ir.ExprId) = .empty,
updates: std.ArrayList(ir.ExprId) = .empty,
loops: std.ArrayList(flow.Iteration) = .empty,
selected_loops: []const flow.Iteration = &.{},
calls: std.ArrayList(flow.Call) = .empty,
pub fn init(allocator: std.mem.Allocator, program: ir.Program, function: ir.Function, summaries: []const []const flow.Lane) Error!Self {
    var self = Self{ .allocator = allocator, .program = program, .function = function, .summaries = summaries, .bindings = try allocator.alloc(?ir.ExprId, function.symbols.count()), .iterations = try allocator.alloc(?ir.ExprId, function.symbols.count()) };

    @memset(self.bindings, null);
    @memset(self.iterations, null);

    try self.block(function.body.block());

    for (0..function.expressions.count()) |expression_index| {
        const expression = function.expressions.at(expression_index);

        if (expression.value == .scope) {
            for (0..expression.value.scope.bindings.len) |record_index| {
                const binding = expression.value.scope.bindings.at(record_index);

                if (binding.symbol) |symbol| {
                    self.bindings[@backingInt(symbol)] = binding.value;
                }
            }
        }
    }

    for (0..function.expressions.count()) |index| {
        const expression = function.expressions.at(index);

        if (expression.value == .iteration) {
            const iteration = expression.value.iteration;
            const id: ir.ExprId = @fromBackingInt(@intCast(index));

            self.iterations[@backingInt(iteration.condition_parameter)] = id;
            self.iterations[@backingInt(iteration.parameter)] = id;
        }
    }

    return self;
}

pub fn lane(self: *Self, output: []const u32) Error!?flow.Lane {
    self.appends.clearRetainingCapacity();
    self.pops.clearRetainingCapacity();
    self.updates.clearRetainingCapacity();
    self.loops.clearRetainingCapacity();
    self.calls.clearRetainingCapacity();

    var input: ?[]const u32 = null;

    for (self.results.items) |result| {
        const origin = try self.trace(result, output) orelse return null;

        if (input) |previous| {
            if (!std.mem.eql(u32, previous, origin)) return null;
        } else input = origin;
    }

    return .{
        .input = input orelse return null,
        .output = output,
        .appends = try self.allocator.dupe(ir.ExprId, self.appends.items),
        .pops = try self.allocator.dupe(ir.ExprId, self.pops.items),
        .updates = try self.allocator.dupe(ir.ExprId, self.updates.items),
        .iterations = try self.allocator.dupe(flow.Iteration, self.loops.items),
        .calls = try self.allocator.dupe(flow.Call, self.calls.items),
    };
}

fn block(self: *Self, statements: ir.Block) Error!void {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .constant => |binding| self.bindings[@backingInt(binding.symbol)] = binding.value,
            .result => |value| if (value) |id| {
                try self.results.append(self.allocator, id);
            },
            .branch => |branch| {
                try self.block(branch.yes);
                try self.block(branch.no);
            },
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                try self.block(case.body);
            },
            else => {},
        }
    }
}

pub fn trace(self: *Self, id: ir.ExprId, path: []const u32) Error!?[]const u32 {
    const expression = self.function.expressions.at(@backingInt(id));

    return switch (expression.value) {
        .scope => |scope| self.trace(scope.result, path),
        .reference => |symbol| if (@backingInt(symbol) == 0)
            path
        else if (self.bindings[@backingInt(symbol)]) |binding|
            self.trace(binding, path)
        else if (self.iterations[@backingInt(symbol)]) |iteration|
            self.trace(self.function.expressions.at(@backingInt(iteration)).value.iteration.initial, path)
        else
            null,
        .field, .tuple_field => |projection| blk: {
            const target = self.function.expressions.at(@backingInt(projection.target)).value;

            if (target == .list_operation and target.list_operation.kind != .pop and target.list_operation.kind != .splice) {
                const operation = target.list_operation;

                if (path.len != 0 or projection.index != 0 or (operation.kind != .push and operation.kind != .concat)) break :blk null;
                if (std.mem.indexOfScalar(ir.ExprId, self.appends.items, id) == null) try self.appends.append(self.allocator, id);

                break :blk try self.trace(operation.target, &.{});
            }

            const selected = try self.allocator.alloc(u32, path.len + 1);

            selected[0] = projection.index;

            @memcpy(selected[1..], path);

            break :blk try self.trace(projection.target, selected);
        },
        .object => |object| blk: {
            if (path.len == 0) break :blk null;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (field.index == path[0]) break :blk try self.trace(field.value, path[1..]);
            }

            break :blk null;
        },
        .tuple => |items| if (path.len != 0 and path[0] < items.len) self.trace(items[path[0]], path[1..]) else null,
        .iteration => |iteration| blk: {
            const initial = try self.trace(iteration.initial, path) orelse break :blk null;
            const result = try self.trace(iteration.body, path) orelse break :blk null;

            if (!std.mem.eql(u32, initial, result)) break :blk null;

            const present = for (self.loops.items) |loop| {
                if (loop.expression == id and std.mem.eql(u32, loop.path, path)) break true;
            } else false;

            if (!present) try self.loops.append(self.allocator, .{ .expression = id, .path = try self.allocator.dupe(u32, path) });

            break :blk initial;
        },
        .list_update => |update| blk: {
            if (path.len != 0) break :blk null;
            if (std.mem.indexOfScalar(ir.ExprId, self.updates.items, id) == null) try self.updates.append(self.allocator, id);

            break :blk try self.trace(update.target, &.{});
        },
        .list_operation => |operation| blk: {
            if (path.len == 1 and path[0] == 1 and @import("prefix.zig").matches(self.function.expressions, id)) {
                break :blk try self.trace(operation.target, &.{});
            }

            if (operation.kind != .pop or path.len != 1 or path[0] != 0) break :blk null;
            if (std.mem.indexOfScalar(ir.ExprId, self.pops.items, id) == null) try self.pops.append(self.allocator, id);

            break :blk try self.trace(operation.target, &.{});
        },
        .conditional => |value| self.join(value.yes, value.no, path),
        .match_expr => |value| blk: {
            const origin = try self.trace(value.fallback, path) orelse break :blk null;

            for (0..value.arms.len) |record_index| {
                const arm = value.arms.at(record_index);
                const next = try self.trace(arm.result, path) orelse break :blk null;

                if (!std.mem.eql(u32, origin, next)) break :blk null;
            }

            break :blk origin;
        },
        .call => |call| blk: {
            const index = @backingInt(call.function);

            if (index >= self.summaries.len) break :blk null;

            for (self.summaries[index], 0..) |summary, lane_index| {
                if (!std.mem.eql(u32, summary.output, path)) continue;

                const duplicate = for (self.calls.items) |saved| {
                    if (saved.expression == id and saved.lane == lane_index) break true;
                } else false;

                if (!duplicate) try self.calls.append(self.allocator, .{ .expression = id, .lane = lane_index });

                break :blk try self.trace(call.argument, summary.input);
            }

            break :blk null;
        },
        else => null,
    };
}

fn join(self: *Self, yes: ir.ExprId, no: ir.ExprId, path: []const u32) Error!?[]const u32 {
    const left = try self.trace(yes, path) orelse return null;
    const right = try self.trace(no, path) orelse return null;

    return if (std.mem.eql(u32, left, right)) left else null;
}
